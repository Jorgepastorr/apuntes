# Ldap - Samba - Hostpam

Se creara un servidor ldap con usuarios, un servidor samba con puntos de montaje para cada usuario y un host que autenticara usuarios mediante ldap, creara localmente un home a cada usuario y montara un recurso samba en el home del usuario.



## Ldap

Partimos de un servidor ldap ya creado en docker con usuarios `user01,...,user08`, estos usuarios están repartidos en diferentes grupos `hisx1,...,hisx4`

```bash
docker run --rm --name ldapserver -h ldapserver --net ldapnet -d jorgepastorr/ldapserver19
```

```bash
user01:*:7001:610:user01:/tmp/home/hisx1/user01:/bin/bash
user02:*:7002:610:user02:/tmp/home/hisx1/user02:/bin/bash
user03:*:7003:611:user03:/tmp/home/hisx2/user03:
user04:*:7004:611:user04:/tmp/home/hisx2/user04:
user05:*:7005:612:user05:/tmp/home/hisx3/user05:
user06:*:7006:612:user06:/tmp/home/hisx3/user06:
user07:*:7007:613:user07:/tmp/home/hisx4/user07:
user08:*:7008:613:user08:/tmp/home/hisx4/user08:
```



## Samba

El servidor samba tendrá los usuarios locales samba `lila, pla, rock, patipla` , y ademas los usuarios samba de ldap.

Para esto conectamos con el servidor ldap y los añadimos a samba.

### Paquetes necesarios

```bash
dnf install -y passwd nss-pam-ldapd authconfig samba samba-client
```



### Configurar conexión con ldap

```bash
authconfig --enableshadow --enablelocauthorize \
   --enableldap \
   --enableldapauth \
   --ldapserver='ldapserver' \
   --ldapbase='dc=edt,dc=org' \
   --enablemkhomedir \
   --updateall
```

#### Encender servicio

```bash
/sbin/nscd
/sbin/nslcd
```

ya podemos hacer `getent passwd` y ver los usuarios ldap.



### Añadir usuarios 

```bash
# usuarios locales samba
useradd lila
useradd rock
useradd patipla
useradd pla 

echo -e "lila\nlila" | smbpasswd -a lila
echo -e "rock\nrock" | smbpasswd -a rock
echo -e "patipla\npatipla" | smbpasswd -a patipla
echo -e "pla\npla" | smbpasswd -a pla
```



A mas de añadir los usuarios ldap, hay que crearles el home y ponerles los permisos adecuados.

```bash
# usuarios ldap samba
for num in {01..08}
do 
    echo -e "jupiter\njupiter" | smbpasswd -a user$num 

    liniaget=$( getent passwd user$num )
    uid=$( echo $liniaget | cut -d: -f 3 )
    gid=$( echo $liniaget | cut -d: -f 4 )
    homedir=$( echo $liniaget | cut -d: -f 6 )

    if [ ! -d $homedir ];then
        mkdir -p $homedir
        cp -ra /etc/skel/. $homedir
        chown -R $uid:$gid $homedir
    fi
done
```



### Configurar samba

En la configuración de samba nos interesa la sección de homes de usuario

*/etc/samba/smb.conf* 

```bash

[global]
        workgroup = MYGROUP
        server string = Samba Server Version %v
        log file = /var/log/samba/log.%m
        max log size = 50
        security = user
        passdb backend = tdbsam
        load printers = yes
        cups options = raw
[homes]
        comment = Home Directories
        browseable = no
        writable = yes
;       valid users = %S
;       valid users = MYDOMAIN\%S
[printers]
        comment = All Printers
        path = /var/spool/samba
        browseable = no
        guest ok = no
        writable = no
        printable = yes
```

#### Arrancar servicio

```bash
/sbin/smbd
/sbin/nmbd
```



## Host

En el host nos interesa, tener conexión con ldap para la autentificación y con samba para crear el punto de montaje.

###  Paquetes necesarios

```bash
dnf install -y passwd nss-pam-ldapd authconfig samba-client cifs-utils pam_mount
```



### Conexión ldap

```bash
authconfig --enableshadow --enablelocauthorize \
   --enableldap \
   --enableldapauth \
   --ldapserver='ldapserver' \
   --ldapbase='dc=edt,dc=org' \
   --enablemkhomedir \
   --updateall
```

```bash
/sbin/nscd
/sbin/nslcd
```



### Usuarios locales

```bash
useradd local1
useradd local2
useradd local3

echo 'local1' | passwd local1 --stdin
echo 'local2' | passwd local2 --stdin
echo 'local3' | passwd local3 --stdin
```



### Montaje automático

Para que monte automáticamente, el recurso samba en el home hay que modificar `system-auth` y `pam_mount.conf.xml`.

*/etc/pam.d/system-auth* 

```bash
#%PAM-1.0
# This file is auto-generated.
# User changes will be destroyed the next time authconfig is run.
auth        required      pam_env.so
auth        optional      pam_mount.so
auth        required      pam_faildelay.so delay=2000000
auth        sufficient    pam_unix.so nullok try_first_pass
auth        requisite     pam_succeed_if.so uid >= 1000 quiet_success
auth        sufficient    pam_ldap.so use_first_pass
auth        required      pam_deny.so

account     required      pam_unix.so broken_shadow
account     sufficient    pam_localuser.so
account     sufficient    pam_succeed_if.so uid < 1000 quiet
account     [default=bad success=ok user_unknown=ignore] pam_ldap.so
account     required      pam_permit.so

password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type=
password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok
password    sufficient    pam_ldap.so use_authtok
password    required      pam_deny.so

session     optional      pam_keyinit.so revoke
session     required      pam_limits.so
-session     optional      pam_systemd.so
session     optional      pam_mkhomedir.so umask=0077
session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid
session     required      pam_unix.so
session     optional      pam_ldap.so

session     [success=ignore default=1] pam_succeed_if.so uid >= 7000
session     optional      pam_mount.so
```

Se a añadido el modulo `pam_mount.so` con  una condición, de que si el usuario tiene un `uid >= 7000` ( los de ldap) se active.



*/etc/security/pam_mount.conf.xml*

```bash
...		
		<!-- Volume definitions -->
<volume user="*" fstype="cifs" server="samba" path="%(USER)" mountpoint="~/%(USER)" options="user=%(USER)" />
...
```

Se este archivo le decimos que montar y donde.

- `server=samba` y `path="%(USER)"` es equivalente a `//server/user` , donde el user sera el que inicia sesión.
- `mountpoint"~/%(USER)"` donde se montara.
- `options="user=%(USER)"`  el usuario con el que hará la petición al recurso samba.



## Docker

```bash
docker run --rm --name ldapserver -h ldapserver --net ldapnet -d jorgepastorr/ldapserver19

docker run --rm --name samba -h samba --net ldapnet --privileged -d jorgepastorr/samba19:pam

docker run --rm --name pam -h pam --net ldapnet --privileged -it jorgepastorr/hostpam19:samba

```



```bash
[local1@pam ~]$ su - user01
pam_mount password:
[user01@pam ~]$ pwd
/tmp/home/hisx1/user01
[user01@pam ~]$ ls
user01
```

