# ssh

Ssh funciona con parejas de claves pública, privada, para una conexión entre hosts. 

tipos de clave: `rsa, dsa,...`

Al instalarse los paquetes `openssh-client, openssh-server` directamente se generan las claves de host. 

> **Nota:** En docker no, se tiene que indicar con `ssh-keygen -A` para generar las claves de host.

## Claves

Las claves privadas tendrán unos permisos de `0600` mientras que las públicas `0644`

```bash
-rw------- 1 debian debian 1,8K jun 17 10:11 id_rsa
-rw-r--r-- 1 debian debian  393 jun 17 10:11 id_rsa.pub
-rw------- 1 debian debian 5,2K dic 10 18:09 known_hosts
-rw------- 1 debian debian 5,2K dic 10 18:11 authorized_keys
```

### Host

Las claves de host están en `/etc/ssh/` junto a la configuración.

### Usuario

Las claves de usuario se encuentran en `~/.ssh/`

`known_host`: claves publicas de hosts

`authoriced_keys`: claves publicas de usuarios

## Autenticación

La autentificación la hace en dos pasos, identificar el host y después el usuario.

### Host

**Host** , es el primero en autenticar, al establecer conexión el remoto envía su fingerprint al local y le pregunta si es con el realmente si quiere conectar, si es cierto el remoto envía su clave pública al local.

Ejemplo fingerprint.

```bash
ssh-keygen -l -f /etc/ssh/ssh_host_rsa_key.pub 
2048 SHA256:rY7+fOVHZ0PAab05HhBwGht0ZdFN60nCucU/xeXT2Mg no comment (RSA)
```

Una vez aceptada la conexión el host remoto guarda la clave publica en `.ssh/know-host`

### Usuario

**Usuario** es el segundo en autenticarse, y se puede hacer manualmente, añadiendo la contraseña en cada conexión, o automáticamente, con una clave pública de usuario que se guardare el remoto en `.ssh/autorized_keys`

```bash
ssh-keygen # generar clave
ssh-copy-id local2@172.20.0.3 # enviar al remoto
```

También se puede copiar la clave pública (cuidado en no reescribirla)

```bash
scp .ssh/id_rsa.pub local1@172.20.0.3:.ssh/authorized_keys
```

## Transferencia de archivos

```bash
# genera archivo file local del resultado ls -la remoto
ssh local1@172.20.0.3 ls -la > file.txt
# genera todo remotamente
ssh local1@172.20.0.3 "ls -la > file.txt"
# comprimir localmente y guarda en remoto
tar cvf - /boot | ssh local1@172.20.0.3 "cat - > boot.tar"
```

```bash
# sshfs
sshfs local1@172.20.0.3: /tmp/mnt
fusermount -u /tmp/mnt 

# desde nautilus
sftp://local1@172.20.0.3/home/local1
```

## Cliente

El cliente ssh tiene 3 propiedades de configuración. Global es la que menos prioridad tiene, si una orden se duplica en la configuración de usuario, se aplicará la del usuario. lo mismo pasa con comand line, esta es la que mas prioridad tiene.

1. comand line

2. user config `~/.ssh/config`

3. global `/etc/ssh/ssh_config`

```bash
Host localhost
    VisualHostKey no

Host *
    VisualHostKey yes

Host 192.168.80.252
    VisualHostKey no
    PasswordAuthentication no
```

>  Si un host coincide en distintos filtros, se le aplica el que mas se parezca.

## Servidor

```bash
/etc/ssh/sshd_conf
/var/run/sshd.pid
```

port 2022

listenAdress `<ip por donde entrar>`

MaxSessions

MaxAuthTries numero de intentos de poner password -1

UsePam

En el caso en el que coincidan 2 configuraciones de host y user en una conexión, se aplica el primero que encuentra.

```bash
# sshd_config
Match Host 172.19.0.1
        banner /etc/banner

Match user local2
        banner /etc/banner2
```

```bash
ssh local2@172.19.0.2  
baner1
```



Reload servicio

```bash
kill -1 <num-servicio>
```



### Restricciones

Existen múltiples mecanismos de restricción para el acceso ssh, algunos de ellos, son globales para los servicios de red  y otros específicos de sshd.

Mecanismos de restricción:

- configuración del servidor sshd.
- Configuración de reglas de PAM
- Utilizar **TCP Wrappers**  con los ficheros host.allow y host.deny de la configuración global del sistema.
- Creación de Firewalls con iptables.


#### Acceder solo desde 1 ip a un usuario.

Esto nos puede servir para configurar remotamente un servidor con la seguridad de que solo se podrá hacer mediante 1 pc remoto o en físico, si combinamos configuración de ssh entrada libre a invitados y restringida a un usuario administrador mediante 1 ip única. 

1. Modificar el fichero ***/etc/pam.d/sshd*** para que nos permita utilizar el fichero de accesos ***/etc/security/access.conf***

***/etc/pam.d/sshd***

```bash
# Comentar la línea (poniendo un # al inicio):
#account    required     pam_nologin.so

# Descomentar la línea (quitando el # del inicio):
account  required     pam_access.so
```



2. Modificamos el fichero de accesos ***/etc/security/access.conf*** para permitir únicamente acceso al debian desde nuestra IP. Añadimos al final del mismo:

```bash
---
+:debian:10.10.10.10
-:debian:ALL
```

- Donde 10.10.10.10 es nuestra IP, con la que accederemos al servidor SSH
- Donde -:debian:ALL niega a todas las demás ip’s

#### Servidor sshd

El orden que se aplicaran las opciones en la configuración del archivo `sshd_config` es: `DenyUsers - AllowUser - DenyGroups - AllowGroup`

Estas opciones irán seguidas de una lista de usuarios o grupos separados por un espacio, solo los nombres están permitidos, si el patrón forma `user@host` dará coincidencia, en un usuario en determinado host.

```bash
AllowUsers pere marta
AllowUsers pere@pc01.edt.org marta jordi@m06.cat
```

```bash
---
DenyUsers jorge debian
```



Con la siguiente línea conseguimos lo mismo que la anterior pero dirigiéndose al grupo que pertenecen.

```bash
---
DenyGroups  admin
```



Con la siguiente línea conseguimos que únicamente se pueda acceder al usuario debian mediante ssh.

```bash
---
AllowUsers debian
```



Con la siguiente línea conseguimos que únicamente se pueda acceder a los usuarios que pertenezcan a admin.

```bash
---
AllowGroups admin
```


#### Pam

##### Pam_access

Con el modulo de pam `pam_access.so` , se puede restringir el acceso, modificando el  archivo `access.conf`

*/etc/pam.d/sshd*

```bash
#%PAM-1.0
auth       substack     password-auth
auth       include      postlogin
account    required     pam_sepermit.so
account    required     pam_nologin.so
account    required     pam_access.so accessfile=/etc/security/access.conf
account    include      password-auth
password   include      password-auth
# pam_selinux.so close should be the first session rule
session    required     pam_selinux.so close
session    required     pam_loginuid.so
# pam_selinux.so open should only be followed by sessions to be executed in the user context
session    required     pam_selinux.so open env_params
session    required     pam_namespace.so
session    optional     pam_keyinit.so force revoke
session    include      password-auth
session    include      postlogin                        
```



*/etc/security/access.conf*

```bash
# All other users should be denied to get access from all sources.
#- : ALL : ALL
# denegar a local2 el aceso a todo
- : local2 : ALL
```



Algunos ejemplos de `access.conf`

```bash
# permiso : usuario/s : servicio/s : host
+ : root : crond :0 tty1 tty2 tty3 tty4 tty5 tty6
+ : root : 192.168.200.1 192.168.200.4 192.168.200.9
+ : root : 127.0.0.1
#El usuario root debería tener acceso desde la red 192.168.201. donde el término se evaluará mediante la coincidencia de cadenas. Pero podría ser mejor usar network / netmask en su lugar. El mismo significado de 192.168.201. es 192.168.201.0/24 o 192.168.201.0/255.255.255.0.
+ : root : 192.168.201.
+ : root : foo1.bar.org foo2.bar.org
- : root : ALL
# Los usuarios y los miembros de los administradores de netgroup deben tener acceso a todas las fuentes. Esto solo funcionará si el servicio netgroup está disponible.
+ : @admins foo : ALL
# User john and foo should get access from IPv6 host address.
+ : john foo : 2001:db8:0:101::1
- : ALL : ALL 
```



##### Pam_listfile

Con el modulo `pam_listfile.so` se puede restringir o dar acceso a diferentes usuarios.

```bash
  pam_listfile.so item=[tty|user|rhost|ruser|group|shell]
                       sense=[allow|deny] file=/path/filename
                       onerr=[succeed|fail] [apply=[user|@group]] [quiet]
```

En el fichero `sshd` de pam, especificamos que tipo de datos encontrara en el archivo que le indicaremos en ruta.

- `item`: que tipo de dato encontrará
- `sense`: que hacer.
- `file`: ruta del archivo.



*/etc/pam.d/sshd*

```bash
#%PAM-1.0
auth       substack     password-auth
auth       include      postlogin
account    required     pam_sepermit.so
account    required     pam_nologin.so
account    required     pam_listfile.so  item=user sense=allow file=/etc/security/users.conf
account    include      password-auth
password   include      password-auth
# pam_selinux.so close should be the first session rule
session    required     pam_selinux.so close
session    required     pam_loginuid.so
# pam_selinux.so open should only be followed by sessions to be executed in the user context
session    required     pam_selinux.so open env_params
session    required     pam_namespace.so
session    optional     pam_keyinit.so force revoke
session    include      password-auth
session    include      postlogin                        
```



*/etc/security/users.conf* 

```bash
local1
local2
```

## clusterssh

Para intalar/gestionar  pc's desde consola

Lo que haces lo transmite a todos a la vez.

**Instalar**

```bash
dnf -y install clusterssh
```



Comando

```bash
cssh
```



Ejemplos

```bash
cssh root a01 a02 a03 a04 
cssh root@a[01-35]
```



**Arxiu de configuració d'alies de cluster**

Ejemplo crear un grupo:

***/etc/clusters***

```bash
f2a a01 a02 a03 a04 
```



Ejecutar el grupo se ejecutarán todos los hosts indicados en el grupo seleccionada.

```bash
sudo cssh -l root "f2a"
```



