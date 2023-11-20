# 210 gestión de clientes de red

## 210.1 Configuración DHCP

DHCP (Dynamic Host Configuration Protocol) es un protocolo cliente/servidor que tiene como objetivo asignar automáticamente una dirección IP, así como los parámetros funcionales a los equipos de la red. Por defecto escucha en el puerto 67 y responde a través de 68.

### Funcionamiento DHCP

DHCP (Dynamic Host Configuration Protocol) es un protocolo cliente/servidor que tiene como objetivo asignar automáticamente una dirección IP, así como los parámetros funcionales a los equipos de la red. 

`DHCPDISCOVER` Descubrimiento de servidor: el cliente envia un brodcast a la red para ver si existe algún servidor DHCP

`DHCPOFFER` Respuesta de servidor: como el cliente aun no tiene ip se envia un broadcast con la configuración.

`DHCPREQUEST` Aceptación: el cliente envia una aceptación de la configuración en broadcast.

`DHCPACK` Acuse de recibo: El servidor realiza la asignación de la dirección y cierra la transacción enviando un acuse de recibo. 

### Configuración

El archivo de configuración  `/etc/dhcpd/dhcpd.conf` se basa en una configuración global y a partir de ahí se asignan opciones por subred o host.

```bash
# Configuració general
default-lease-time 86400; # Indica la duración de la concesión DHCP en segundos.
max-lease-time 259200;
option routers 192.168.88.1;
option subnet-mask 255.255.255.0;
option broadcast-address 192.168.88.255;
option domain-name-servers 8.8.8.8, 1.1.1.1;
option domain-name-servers 192.168.88.4;
option domain-search "local.lan";

# Aquest servidor dhcp sera el principal la subxarxa
authoritative;

# Subxarxa
subnet 192.168.88.0 netmask 255.255.255.0 {
  range 192.168.88.10 192.168.88.25;
}

# (Torre [Ethernet])
host torreEthernet {
  option host-name "pc02";
  hardware ethernet b4:2e:99:48:ad:b6;
  fixed-address 192.168.88.2;
}
```

El servidor DHCP conserva la información de cada una de las concesiones asignadas en el archivo **dhcpd.leases**, que se encuentra en el directorio **/var/lib/dhcp/**.

En ocasiones el servidor DHCP tiene diferentes interfaces de red y solo queremos que resuelva peticiones por una de ellas.  La única dificultad reside en que este elemento de configuración no se encuentra en **/etc/dhcpd.conf**, sino que está en **/etc/defaults/dhcp3-server**.

```bash
cat  /etc/default/dhcp3-server
INTERFACES="enp3s0"
```

#### Subredes

Todas las subredes que comparten la misma red física deben especificarse dentro de una declaración `shared-network` El nombre de `shared-network` debe ser el título descriptivo de la red ya que se vera reflejado en los logs

```
shared-network dep-ventas {
    option domain-name              "test.redhat.com";
    option domain-name-servers      ns1.redhat.com, ns2.redhat.com;
    option routers                  192.168.1.254;
    more parameters for EXAMPLE shared-network
 
    subnet 192.168.1.0 netmask 255.255.255.0 {
        parameters for subnet
        range 192.168.1.1 192.168.1.31;
    }
    subnet 192.168.1.32 netmask 255.255.255.0 {
        parameters for subnet
        range 192.168.1.33 192.168.1.63;
    }
}
```

#### Grupos

La declaración `group` puede utilizarse para aplicar parámetros globales a un grupo 

```
group {
   option routers                  192.168.1.254;
   option subnet-mask              255.255.255.0;
   option domain-name              "example.com";
   option domain-name-servers       192.168.1.1;
   option time-offset              -18000;     # Eastern Standard Time

   host apex {
      option host-name "apex.example.com";
      hardware ethernet 00:A0:78:8E:9E:AA; 
      fixed-address 192.168.1.4;
   }

   host raleigh {
      option host-name "raleigh.example.com";
      hardware ethernet 00:A1:DD:74:C3:F2;
      fixed-address 192.168.1.6;
   }
}
```



### Cliente

El comando **dhclient** permite realizar peticiones DHCP en los equipos cliente. Si el comando no se ejecuta manualmente por un administrador, se puede llamar mediante los scripts de inicialización de red. 

```bash
dhclient enp3s0		# pedir configuracion
dhclient -r enp3s0	# eliminar configuración
```

Las comunicaciones DHCP se realizan por broadcast y los mensajes broadcast no pasan a través de los routers.  Sin embargo, si se desea utilizar solo un servidor para varias redes, existe una solución: los agentes DHCP relay.

```
                      ┌───────┐
   ┌─────┬───────┬────┤router ├─────┬────────┬─────┐
   │     │    ┌──┴─┐  └───────┘  ┌──┴──┐     │     │
 ┌─┴─┐ ┌─┴─┐  │    │             │     │   ┌─┴─┐ ┌─┴─┐
 │pc │ │pc │  │DHCP│             │relay│   │pc │ │pc │
 └───┘ └───┘  └────┘             └─────┘   └───┘ └───┘       
```

El servidor DHCP tiene toda la configuración, el agente DHCPRelay solo escucha las peticiones DHCP de esa red, las envia al servidor DHCP pasando por el router en unicast y devuelve la respuesta al cliente.

```bash
dhcrelay -i interfaz dirección_servidor # activar dhcrelay
-i interfaz	# Especifica la interfaz por la que el agente relay estará a la escucha 
dirección_servidor  # La IP del servidor al que se transmitirán las peticiones DHCP.
```



## 210.2 Autentificación PAM

Pam es un conjunto de librerías, que proporciona una api para autenticar aplicaciones (servicios), los clientes de pam, son las aplicaciones que tienen que autenticar

Una aplicación solicita a PAM si un usuario se puede conectar. PAM, en función de su configuración, invocará los módulos que utilizarán un método de autentificación. Si el resultado es positivo (el usuario ha proporcionado los elementos correctos de autentificación), PAM devuelve la autorización de conexión a la aplicación.

Los **módulos** están en archivos cuya ubicación estándar es `/lib/security`.

|                  | Módulos PAM principales                                      |
| ---------------- | ------------------------------------------------------------ |
| pam_securetty.so | Prohíbe el login para la cuenta root excepto en los terminales listados en /etc/securetty. |
| pam_nologin.so   | Si el archivo /etc/nologin existe, muestra su contenido ante cualquier intento de apertura de sesión y prohíbe el login ante cualquier usuario que no sea root. |
| pam_env.so       | Declara las variables de entorno que se leen en /etc/environment o en el archivo al que se hace referencia con el parámetro «envfile=». |
| pam_unix.so      | Permite la autentificación mediante el método tradicional de los archivos /etc/passwd y /etc/shadow. |
| pam_deny.so      | Vía muerta. Generalmente se ejecuta si ningún otro módulo se ha ejecutado con éxito. |
| pam_permit.so    | Devuelve un resultado positivo incondicionalmente.           |
| pam_limits.so    | Asigna ciertas limitaciones funcionales a usuarios o grupos en función de los datos del archivo /etc/security/limits.conf. |
| pam_cracklib.so  | Se asegura que la contraseña empleada presenta un nivel de seguridad suficiente. |
| pam_selinux.so   | Si selinux está activo en el sistema, este módulo va a asegurar que el shell se ejecuta en el contexto de seguridad adecuado. |
| pam_lastlog.so   | Muestra la información de la última apertura de sesión con éxito. |
| pam_mail.so      | Comprueba la presencia de nuevos correos para un usuario (mensajería interna). |

### Configuración

Utiliza un directorio **/etc/pam.d** que contiene tantos archivos como aplicaciones que usan PAM. Si existe el directorio **/etc/pam.d**, el archivo **/etc/pam.conf** no se consultará. Cada aplicación que utilice PAM necesita un archivo (en general del mismo nombre que la aplicación) que alberga su configuración PAM.

**Importante**:  Pam no es un servicio, al hacer un cambio en los archivos es inmediato

|            | Archivo de pam.d: formato estándar                           |
| ---------- | ------------------------------------------------------------ |
| tipo       | Representa el tipo de acción que necesita recurrir a PAM. Los cuatro valores posibles son: **auth**, **account**, **password** y **session**. |
| control    | Indica cómo deberá reaccionar el módulo ante el éxito o el error de su ejecución. Los valores comunes son **required**, **requisite**, **sufficient** y **optional**. |
| módulo     | El nombre del módulo invocado. El formato estándar es: **pam_****servicio.so**, donde servicio representa el nombre actual del módulo. |
| argumentos | Parámetros opcionales enviados al módulo para modificar su funcionamiento. |

Archivo login estandar en Fedora

```bash
[root@pam pam.d]# cat system-auth 
#%PAM-1.0
# This file is auto-generated.
# User changes will be destroyed the next time authconfig is run.
auth        required      pam_env.so
auth        sufficient    pam_unix.so try_first_pass nullok
auth        required      pam_deny.so

account     required      pam_unix.so

password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type=
password    sufficient    pam_unix.so try_first_pass use_authtok nullok sha512 shadow
password    required      pam_deny.so

session     optional      pam_keyinit.so revoke
session     required      pam_limits.so
-session     optional      pam_systemd.so
session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid
session     required      pam_unix.so
```

#### Tipos

En los controles hay que saber diferenciar entre `auth` (autentificación, demostrar quien soy) y `autz` (a que me da derecho mi autentificación)

| Tipos    | Significados                                                 |
| -------- | ------------------------------------------------------------ |
| auth     | la acción de autentificación propiamente dicha               |
| account  | acceso a la información de cuentas (tengo permiso para modificar) |
| password | reglas para cambiar pasword                                  |
| session  | acciones que se deben realizar antes o después de la apertura de la sesión. |

#### Control

La opción de control, es compleja, tiene echo unos alias donde agrupan una serie de opciones predefinidas mas habituales.

ejemplo:

```bash
required
[success=ok new_authtok_reqd=ok ignore=ignore default=bad]
requisite
[success=ok new_authtok_reqd=ok ignore=ignore default=die]
sufficient
[success=done new_authtok_reqd=done default=ignore]
optional
[success=ok new_authtok_reqd=ok default=ignore]
```

- `ignore`: ignora esta opción
- `bad` :  marca como fallo y sigue evaluando
- `die`: marca como fallo y no evalúes más
- `ok`: marca como resultado positivo y sigue avaluando 
- `done`: resultado positivo y no evalúes más opciones
- `N` numero de casillas a saltar
- `reset` resetea valores anteriores

| controles |                                                              |
| --------- | ------------------------------------------------------------ |
| required  | Esta opción siempre tendrá que dar cierto, si da falso,  fallara pero sigue preguntando la siguiente opción. |
| requisite | Esta opción tiene que dar cierto, si da falso, cierra, no pasa a la siguiente opcion. |
| suficient | Si da cierto ya vale para la autentificación, en caso que de falso se ignora |
| optional  | Opciones que intentara hacer, el resultado de los módulos en este control, no afectara a no ser que sea el único a evaluar |
| include   | Incluir otros módulos de reglas existentes como si estuvieran en el mismo archivo |
| substrack | llama a otro archivo y devuelve true o false, según la tabla de reglas. |



## 210.3 Cliente LDAP

En Linux hay herramientas por línea de comandos que permiten realizar operaciones en los servidores LDAP. Generalmente proporcionadas por `ldap-utils`. Su sintaxis, poco atractiva, requiere un pequeño tiempo de adaptación para usarla con comodidad.

### Búsqueda de información

```bash
ldapsearch -x -b contexto 
-x 	# utilizar autentificación simple
-b 	# Realizar la búsqueda a partir del DN del contenedor del contexto.
ldapsearch -x -D dn_admin -W -h ip_servidor -b contexto -s sub atributo=valor 
-D user	# Realiza la autentificación con el nombre distinguido dn_admin.
-W	# Solicitar interactivamente la contraseña.
-s	# Realiza una búsqueda recursiva en todos los niveles por debajo del contexto de búsqueda.
```

Ejemplo orden `ldapsearch`

```bash
usuario@ubuntu:~$ ldapsearch -x -D cn=admin,dc=pas,dc=net -w password 
-h 172.17.7.20 -b dc=pas,dc=net -s sub telephoneNumber=91* 
# extended LDIF 
...
# toto, madrid, pas.net 
dn: cn=toto,ou=madrid,dc=pas,dc=net 
objectClass: person 
cn: toto 
sn: toto 
telephoneNumber: 9123456789 
...
```

Atributos de busqueda

```bash
 ldapsearch -x -LLL -h 172.17.0.2 -b 'dc=edt,dc=org' '(|(cn=* Mas)(cn=* Pou))' dn
 ldapsearch -x -LLL -b 'dc=edt,dc=org' '(&(cn=* Mas)(ou=Profes))' dn
 ldapsearch -x -LLL -b 'dc=edt,dc=org' '(&(|(cn=* Mas)(cn=* Pou))(gidNumber=600))'
 ldapsearch -x -LLL -b 'ou=usuaris,dc=edt,dc=org' 'uidNumber>=5000' dn uidNumber
 ldapsearch -x -LLL -b 'dc=edt,dc=org'  -s [sub|base|one|children]
 ldapsearch -x -LLL -b 'dc=edt,dc=org' +  #  atributos operacionales, lenguaje ldap    
```

- `-s sub` es la salida estándar
- `-s base` es el primer nivel del árbol de la base de datos
- `-s one` es el segundo nivel ( los grupos )
- `-s children` del segundo nivel incluido hasta el ultimo ( grupos y usuarios )

### Agregar objetos

El agregar objetos a la base de datos LDAP se a de realizar mediante un fichero y la herramienta `ldapadd`

```bash
# ldapadd -x -D dn_admin -W -h ip_servidor -f archivo_ldif 
ldapadd -x -D cn=Manager,dc=edt,dc=org -w secret -f /tmp/ldap/usuario_nuevo.ldif
```

> La opción `-c` permite en el caso de añadir un elemento y falle pase al siguiente y no pare todo el proceso.

*usuario_nuevo.ldif*

```
dn: cn=toto,dc=pas,dc=net 
objectClass: person 
cn: toto 
sn: toto 
telephoneNumber: 9123456789
```

### Modificar objetos existentes

El comando **ldapmodify** también se usa con un archivo ldif como argumento y sus parámetros de uso son los mismos que los del comando **ldapadd**.

```bash
# ldapmodify -D dn_admin -W -h ip_servidor -f archivo_ldif 
ldapmodify -x -D cn=Manager,dc=edt,dc=org -w secret -f modificaciones.ldif
```

El archivo de modificación tiene su propia sintaxis guiando las acciones con `changetype: <[modify|add|delete|modrdn]>`. Primero se añade el `dn` del objeto a modificar seguido de la acción. El simbolo `-` representa el cambio de acción en un mismo objeto y una linea en blanco la finalización de utilización de dicho objeto.

```
dn: cn=Pau Pou,ou=usuaris,dc=edt,dc=org
changetype: modify
replace: mail
mail: modme@example.com
-
replace: homePhone
homephone:111-222-333
-
delete: description

dn: cn=Anna Pou,ou=usuaris,dc=edt,dc=org
changetype: modify
add: description
description: nueva descripcion para Anna Pou
```

Eliminación de objeto

```
dn: cn=Anna Pou,ou=usuaris,dc=edt,dc=org
changetype: delete
```

Añadir objeto

```
dn: cn=pepe,dc=pas,dc=net 
changetype: add
objectClass: person 
cn: pepe 
sn: pepe 
telephoneNumber: 9123456789
```

### Eliminación de objetos

```bash
ldapdelete -x  -D cn=Manager,dc=edt,dc=org -w secret 'cn=Pau Pou,ou=usuaris,dc=edt,dc=org'
ldapdelete -x -D cn=Manager,dc=edt,dc=org -w secret -f modificaciones.ldif
```

### Modificación de contraseñas

```bash
 # ldappasswd -x -D dn_admin -W -h ip_servidor -s contraseña dn_usuario 
 ldappasswd -x -h 172.17.0.2 -D 'cn=user10,ou=usuaris,dc=edt,dc=org' -w jupiter -s user10
 
 -w	# antiguo password
 -s -S # nuevo password -S interactivo
```

### Cliente gráfico

Las aplicaciones compatibles LDAP integran un cliente que les permite realizar peticiones de directorio para su funcionamiento. Son muchas y de calidad variable las herramientas de este tipo. Podemos citar luma, gq y lat.

## 210.4 Configuración OpenLDAP

Los directorios LDAP utilizan la norma X500 y presentan características estructurales comunes. 

Son jerárquicos y tienen un punto de origen que generalmente se denomina Root. Todo elemento del directorio se llama objeto; algunos elementos son estructurales y otros son totalmente informativos. Los elementos estructurales se llaman contenedores y son de distintos tipos, como por ejemplo organización, dominio o unidad organizativa.

### Estructura

```
                                +----------------+
                                |  dc=org        |
                                +----------------+
                                         |
                                +----------------+
          Entidades             |  dc=edt        |
                                +----------------+
                                   |          |
                             +-----+          +-------+
     Unidades    +----------------+                +------------------+
     organizativas                |                |                  |
                 |  ou=usuarios   |                |   ou=maquinas    |
                 +----------------+                +------------------+
      Usuarios                    |
              +---------------------+
    +----------------+       +----------------+
    |  uid=pedro     |       |   uid=anna     |
    |  sn=lopez      |       |   sn=gomez     |
    |  ...           |       |   ...          |
    +----------------+       +----------------+
```

> ldap crea un directorio `/var/lib/ldap` y `/etc/openldap/slapd.d` donde esta la configuración en formato `.ldapd`  estos directorios son del usuario `ldap:ldap`  y siempre a de ser así. si los modificamos como root tendremos que cambiarlo al usuario original al acabar los cambios.

**La organitzación** `edt.org`  contiene 4 entidades con diferentes atributos, este sería un ejemplo de estructura.

```
dn: dc=edt,dc=org
dc: edt
description: Escola del treball de Barcelona
objectClass: dcObject
objectClass: organization
o: edt.org

dn: ou=maquines,dc=edt,dc=org
ou: maquines
description: Container per a maquines linux
objectclass: organizationalunit

dn: ou=clients,dc=edt,dc=org
ou: clients
description: Container per a clients linux
objectclass: organizationalunit

dn: ou=productes,dc=edt,dc=org
ou: productes
description: Container per a productes linux
objectclass: organizationalunit

dn: ou=usuaris,dc=edt,dc=org
ou: usuaris
description: Container per usuaris del sistema linux
objectclass: organizationalunit
```

Usuarios edt.org

```
dn: cn=Pau,ou=usuaris,dc=edt,dc=org
objectclass: posixAccount
objectclass: inetOrgPerson
cn: Pau
mail: pau@edt.org
description: Watch out for this guy
```

Con esta estructura se obtendría un *Distinguished Name* `dn: cn=Pau,ou=usuaris,dc=edt,dc=org`

### Configuración

El archivo de configuración de ldap lo encontramos en `/etc/openldap/slapd.d` con el nombre `slapd.conf` este archivo contendrá la descripción de la base de datos y el acceso.

configuración de la base de datos:

```
...
database mdb
suffix "dc=edt,dc=org"
rootdn "cn=Manager,dc=edt,dc=org"
rootpw secret
directory /var/lib/ldap
...
```

- `database` es el tipo de base de datos que queremos
- `suffix` el nombre de la base de datos
- `rootdn/rootpw` Usuario con privilegios virtual ( administrador )

La contraseña de `rootpw` se puede añadir como (SHA1, MD5, crypt o texto sin encriptar).

```bash
[root@beta openldap]# slappasswd -s contraseña 
{SSHA}oW6wu+yUpFnaB6tg+4cMWnAa8OmDXV62 
```

Configuración de los permisos de acceso a la base de datos

```
....
# ACL for this database
access to *
    by self write
    by * read
...
```

Generar base de datos

```bash
# borrar configuración por defecto
rm -rf /var/lib/ldap/*
rm -rf /etc/openldap/slapd.d/*

slaptest -f slapd.conf # valida el archivo de configuracion
slaptest -f slapd.conf -u # enable dry-run mode
slaptest -f slapd.conf -F /etc/openldap/slapd.d/ # generar DB en el directorio indicado
slaptest -f slapd.conf -F /etc/openldap/slapd.d/ -u

chown -R ldap:ldap /etc/openldap/slapd.d
chown -R ldap:ldap /var/lib/ldap 
```

Una vez generada la base de datos es bueno comprobar la configuración con `slapcat`

```bash
slapcat -l all.ldif # dump completo de la configuración base de datos
slapadd -l all.ldif	# restauración 
```

---

En este punto, el directorio es completamente funcional después de un reinicio del servicio, pero aún estará vacío. Ya solo falta llenarlo con los clientes LDAP.

### Autentificación por LDAP

#### Configurar NSS

La autentificación solo será posible si la información de los usuarios está accesible vía NSS. La librería NSS, responsable de consultar al directorio, tiene que disponer de la información necesaria. 

La configuración se encuentra en `/etc/ldap.conf` proporcionado por el paquete **libnss_ldap**

```
SASL_NOCANON	on
URI ldap://ldapserver
BASE dc=edt,dc=org
```

El archivo `/etc/nsswitch` se debe configurar para hacer referencia a LDAP como fuente de información prioritaria. 

```
passwd : ldap files 
group: ldap files 
shadow: ldap files
```

Para comprobar la configuración utilizamos `getent`

```bash
getent passwd
```



#### Configurar PAM

Según las necesidades, todos o parte de los servicios que usan PAM tienen que poder apoyarse en la autentificación LDAP.  

Afortunadamente, las distribuciones Linux modernas facilitan la tarea concentrando en los archivos **common-action** para Debian o **system-auth** para Red Hat la configuración de todas las aplicaciones que comparten los mismos modos de autentificación.

```bash
authconfig --enableshadow --enablelocauthorize \
   --enableldap \
   --enableldapauth \
   --ldapserver='ldapserver' \
   --ldapbase='dc=edt,dc=org' \
   --enablemkhomedir \
   --updateall
```

Que genera un archivo pam como el siguiente

```bash
#%PAM-1.0
# This file is auto-generated.
# User changes will be destroyed the next time authconfig is run.
auth        required      pam_env.so
auth        optional      pam_mount.so
auth        sufficient    pam_unix.so try_first_pass nullok
auth        sufficient    pam_ldap.so try_first_pass
auth        required      pam_deny.so

account     sufficient      pam_unix.so
account     sufficient    pam_ldap.so
account     required      pam_deny.so

password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type=
password    sufficient    pam_unix.so try_first_pass use_authtok nullok sha512 shadow
password  sufficient      pam_ldap.so try_first_pass
password    required      pam_deny.so

session     optional      pam_keyinit.so revoke
session     required      pam_limits.so
-session     optional      pam_systemd.so
session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid
session     required      pam_mkhomedir.so
session     optional      pam_mount.so
session     sufficient      pam_unix.so
session     sufficient      pam_ldap.so
```

