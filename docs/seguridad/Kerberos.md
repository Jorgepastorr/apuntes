# Kerberos

Es un [protocolo](https://es.wikipedia.org/wiki/Protocolo_(informática)) de [autenticación](https://es.wikipedia.org/wiki/Autenticación) de [redes de ordenador](https://es.wikipedia.org/wiki/Red_de_telecomunicación) creado por el [MIT](https://es.wikipedia.org/wiki/Instituto_Tecnológico_de_Massachusetts) que permite a dos ordenadores en una red insegura demostrar su identidad mutuamente de manera segura. : tanto cliente como servidor verifican la identidad uno del otro. Los mensajes de autenticación están protegidos para evitar [eavesdropping](https://es.wikipedia.org/wiki/Eavesdropping) y [ataques de Replay](https://es.wikipedia.org/wiki/Ataques_de_REPLAY).

Kerberos se basa en [criptografía de clave simétrica](https://es.wikipedia.org/wiki/Criptografía_simétrica) y requiere un [tercero de confianza](https://es.wikipedia.org/wiki/Tercero_de_confianza). 

El usuario se conecta con un servidor de kerberos y obtiene un tiquet, este tiquet es la prueba de quien eres.

En los servidores kerberizados (que entienden kerberos), los usuarios presentas su tiquet, y el servidor kerberizado se comunica con el server kerberos para verificar quien es y autenticar.

*Ejemplo de tiquet:*

```bash
[isx47787241@i09 curs]$ klist
Ticket cache: FILE:/tmp/krb5cc_101709_6EW9wO
Default principal: isx47787241@INFORMATICA.ESCOLADELTREBALL.ORG

Valid starting     Expires            Service principal
18/02/20 08:46:52  19/02/20 08:46:52  krbtgt/INFORMATICA.ESCOLADELTREBALL.ORG@INFORMATICA.ESCOLADELTREBALL.ORG
18/02/20 08:46:56  19/02/20 08:46:52  nfs/madiba.informatica.escoladeltreball.org@INFORMATICA.ESCOLADELTREBALL.ORG
```

**Auth** autentication ( quien soy ) 

- AP autentication provider: son los métodos de autenticación, es decir, verificar quien eres. Esto lo proporciona : `kerberos, ldap, /etc/passwd`

**Autz** authorization ( que tengo derecho a hacer)

- IP  information provider: Una vez sabido quien eres, que puedes hacer, se dicta a trabes de uid, gid, ... Se proporciona a trabes de: `ldap, /etc/passwd`

**Autenticaction Provider AP**
Kerberos propoerciona el servei de proveïdor d'autenticació. No emmagatzema informació
dels comptes d'usuari com el uid, git, shell, etc. Simplement emmagatzema i gestiona els
passwords dels usuaris, en entrades anomenades  principals  en la seva base de dades.
Coneixem els següents AP:

- /etc/passwd  que conté els password (AP) i també la informació dels comptes d'usuari
  (IP).
- ldap  el servei de directori ldap conté informació dels comptes d'usuari (IP) i també
  els seus passwords (AP).
- kerberos  que únicament actua de AP i no de IP.

**Information Provider IP**
Els serveis que emmagatzemen la informació dels comptes d'usuari s'anomenen Information
providers. Aquests serveis proporcionen el uid, gid, shell, gecos, etc. Els clàssics són
/etc/passwd i ldap.

Kerberos utiliza tres servicios:

```bash
88/tcp open kerberos-sec
464/tcp open kpasswd5
749/tcp open kerberos-adm
```

**kadmind**: demonio del servicio de administración kerberos

**krb5kdc**: demonio de kerberos  encargado de distribuir tiquets.

## Instalación del server

### instalar paquetes

```bash
dnf -y install krb5-server krb5-workstation

# tree /var/kerberos/
/var/kerberos/
├── krb5
│ └── user
└── krb5kdc
  ├── kadm5.acl
  └── kdc.conf
```

### configurar

Modificar el fichero de configuración principal `/etc/krb5.conf` añadir nuestro dominio ( realm ) y especificar el servidor

```bash
includedir /etc/krb5.conf.d/

[logging]
 default = FILE:/var/log/krb5libs.log
 kdc = FILE:/var/log/krb5kdc.log
 admin_server = FILE:/var/log/kadmind.log

[libdefaults]
 dns_lookup_realm = false
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true
 rdns = false
 default_realm = EDT.ORG
# default_ccache_name = KEYRING:persistent:%{uid}

[realms]
 EDT.ORG = {
 # servidor kerberos
  kdc = kserver.edt.org
  admin_server = kserver.edt.org
 }

[domain_realm]
 .edt.org = EDT.ORG 
 edt.org = EDT.ORG
```

Poner el REALM  en el archivo ` /var/kerberos/krb5kdc/kdc.conf`

```bash
[kdcdefaults]
 kdc_ports = 88
 kdc_tcp_ports = 88

[realms]
 EDT.ORG = {
  #master_key_type = aes256-cts
  acl_file = /var/kerberos/krb5kdc/kadm5.acl
  dict_file = /usr/share/dict/words
  admin_keytab = /var/kerberos/krb5kdc/kadm5.keytab
  supported_enctypes = aes256-cts:normal aes128-cts:normal des3-hmac-sha1:normal arcfour-hmac:normal camellia256-cts:normal camellia128-cts:normal des-hmac-sha1:normal des-cbc-md5:normal des-cbc-crc:normal
 }
```

### Crear base de datos

Crear la base de datos que almacena claves principales ( usuarios y maquinas )

```bash
kdb5_util create -s -P masterkey
# verificar que se a creado
tree /var/kerberos/
/var/kerberos/
├── krb5
│ └── user
└── krb5kdc
  ├── kadm5.acl
  ├── kdc.conf
  ├── principal
  ├── principal.kadm5
  ├── principal.kadm5.lock
  └── principal.ok
```

### definir acl's

Definir las acl de los usuarios principales en `/var/kerberos/krb5kdc/kadm5.acl`

```bash
*/admin@EDT.ORG        *
superuser@EDT.ORG    *
pau/admin@EDT.ORG    *
marta@EDT.ORG        *
```

### añadir usuarios

crear usuarios principales

```bash
kadmin.local -q "addprinc -pw superuser superuser"
kadmin.local -q "addprinc -pw admin admin"
kadmin.local -q "addprinc -pw kpere pere"
kadmin.local -q "addprinc -pw kmarta marta"
kadmin.local -q "addprinc -pw kjordi jordi"
kadmin.local -q "addprinc -pw kpau pau"
kadmin.local -q "addprinc -pw kpau pau/admin"

[root@kserver /]# kadmin.local -q "list_principals"
Authenticating as principal root/admin@EDT.ORG with password.
K/M@EDT.ORG
admin@EDT.ORG
jordi@EDT.ORG
kadmin/admin@EDT.ORG
kadmin/changepw@EDT.ORG
kadmin/kserver@EDT.ORG
kiprop/kserver@EDT.ORG
krbtgt/EDT.ORG@EDT.ORG
marta@EDT.ORG
pau/admin@EDT.ORG
pau@EDT.ORG
pere@EDT.ORG
superuser@EDT.ORG
```

### Arrancar servicio

```bash
systemctl start bkrb5kdc.service
systemctl start kadmin.service

/usr/sbin/krb5kdc
/usr/sbin/kadmind -nofork
```

## Instalación cliente

```bash
[root@kclient /]# dnf install -y krb5-workstation
```

Configuración

```bash
[root@khost /]# vi /etc/krb5.conf
includedir /etc/krb5.conf.d/

[logging]
 default = FILE:/var/log/krb5libs.log
 kdc = FILE:/var/log/krb5kdc.log
 admin_server = FILE:/var/log/kadmind.log

[libdefaults]
 dns_lookup_realm = false
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true
 rdns = false
 default_realm = EDT.ORG
# default_ccache_name = KEYRING:persistent:%{uid}

[realms]
 EDT.ORG = {
 # servidor kerberos
  kdc = kserver.edt.org
  admin_server = kserver.edt.org
 }

[domain_realm]
 .edt.org = EDT.ORG 
 edt.org = EDT.ORG
```

Comprobar

```bash
[root@khost /]# kinit marta
Password for marta@EDT.ORG: 

[root@khost /]# klist
Ticket cache: FILE:/tmp/krb5cc_0
Default principal: marta@EDT.ORG
Valid starting     Expires            Service principal
02/18/20 18:52:27  02/19/20 18:52:27  krbtgt/EDT.ORG@EDT.ORG
```

## Gestión de acl

Definir las acl de los usuarios principales en `/var/kerberos/krb5kdc/kadm5.acl`

El orden de las entradas es significativo. La primera entrada  coincidente especifica el principal en el que se aplica el acceso de  control, ya sea solo en el principal o en el principal cuando opera en  un principal objetivo.

Las líneas que contienen entradas de ACL deben tener el siguiente formato:

```bash
principal operation-mask [operation-target]
```

**Operation mask**: Permisos sobre que se podrá hacer, si la opción está en mayúscula se denegará la acción, en minúscula se aprueba, es decir a permite crear principales, A deniega crear principales.

Con la excepción de x que no tiene versión mayúscula.

| a   | permite crear principals y politicas                                                                            |
| --- | --------------------------------------------------------------------------------------------------------------- |
| c   | permite cambio de contraseñas a principals                                                                      |
| d   | permite eliminar principals y politicas                                                                         |
| i   | permite consultas sobre principals y politicas                                                                  |
| l   | permite listar principals y politicas                                                                           |
| m   | permite modificar principals y politicas                                                                        |
| p   | permite la propagación de la base de datos principal (utilizada en la propagación de base de datos incremental) |
| s   | permite la configuración explícita de la clave para un principal                                                |
| x   | Corto para admcil. Todos los privilegios                                                                        |
| *   | Igual que x.                                                                                                    |

**Operation target**: opcional, objeto sobre el cual podrá aplicar los permisos indicados, si no se indica ninguno es a todos.

Ejemplos:

```bash
# el usuario kser01/admin tiene permido de: add,delete, modifi. sobre todos los usuarios
kuser01/admin@realm adm 

# el usuario kuser01 tiene permisos sobre todos los usuarios del grupo instance de: cambiar contraseña, modificar y ver datos de usuario
kuser01@EDT.ORG cim */instance@EDT.ORG

# si hay un mach solo se aplica la primea regla, kuser01 solo puede cambiar contraseñas
kuser01@EDT.ORG        c
kuser01@EDT.ORG        *

# kuser01 puede camiar contraseña solo a kuser05
kuser01@EDT.ORG        c kuser05@EDT.ORG

# todos los usuarios pueden cambiarse la contraseña a si mismos, no a los demas.
*@EDT.ORG        c     self@EDT.ORG

# ¿?
sms@ATHENA.MIT.EDU        x   * -maxlife 9h -postdateable

# kuser01 puede añadir usuarios pero no borrarlos
kuser01@EDT.ORG        aD

# todos los usuarios pueden cambiarse la contraseña y kuser01 ademas puede listar y ver usuarios.
*@EDT.ORG        c    self@EDT.ORG
kuser01@EDT.ORG        li
```

## Gestión del servidor

Para gestionar el servidor kerberos  se tiene las siguientes herramientas.

- `kadmin.local` utilidad de administración de la base de datos de principals, esta utilidad accede a bajo nivel modifica los ficheros directamente. solo se puede utilizar directamente desde el servidor y con privilegios de root.
- `kadmin`  utilidad de administración que conecta con el servidor por red usando el protocolo kerberos. Se puede utilizar desde cualquier cliente o servidor y establece una conexión de red segura. Los permisos de ACL's establecidos determina los privilegios de cada usuario.

Desde host:

```bash
kinit kuser06     # pedir tiquet
klist        # listar tiquet
kpasswd        # cambiar password
Password for kuser06@EDT.ORG: 
Enter new password: 
Enter it again: 
Password changed.

kdestroy     # eliminar tiquet
```

Desde server:

```bash
# añadir principal
kadmin.local -q "addprinc superuser"
kadmin.local -q "addprinc -pw contrasena kuser03"
kadmin:  addprinc pau

# listar principals
kadmin.local -q "listprincs"
kadmin:  listprincs

# ver principal
kadmin:  getprinc kuser06
kadmin.local -q "getprinc kuser06"

# cabiar contraseña
kadmin.local -q "change_password kuser02"
kadmin.local -q "cpw kuser02"

# eliminar principal
kadmin.local -q "delprinc kuser02"

# modificar principal
kadmin: modprinc -expire "12/31 7pm" kuser01
```

https://docs.oracle.com/cd/E19683-01/816-0211/6m6nc66tj/index.html

```bash
addprinc -randkey host/sshd.edt.org
ktadd -k /etc/krb5.keytab host/sshd.edt.org
```

```bash
docker exec  kserver.edt.org kadmin -p marta -w kmarta -q listprincs

docker system prune
```


