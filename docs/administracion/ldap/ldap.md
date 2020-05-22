# ldap

autenticación  demostrar quien soy 

information provides ( info de la cuenta )
authentication provides ( password )

ldap es una base de datos **no relacional** que es **jerárquica**  ( estructura de árbol ), ademas **puede ser distribuida** y esta **optimizada para lecturas** . 

el nodo raíz se  compone de:  

```bash
dc=edt,dc=org  
```

## Estructura

El árbol de la estructura se denomina `DIT` 

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

- Los diferentes tipos de entidad se refieren a los recuadros y cada una de ellas tiene sus atributos (datos) referente a ella. como por ejemplo la entidad de Usuarios tiene atributos como uid, sn, etc...

- Cada entidad es un tipo de objeto, esto lo veremos en los archivos de configuración por ejemplo:
  
  - `edt,org` pertenece al objeto `o` organization
  - `usuarios, maquinas` son el objeto `ou` organizationunit.
  - los usuarios `posixacount,inetorgperson` 

ldap crea un directorio `/var/lib/ldap` y `/etc/openldap/slapd.d` donde esta la configuración en formato `.ldapd`  estos directorios son del usuario `ldap:ldap`  y siempre a de ser así. si los modificamos como root tendremos que cambiarlo al usuario original al acabar los cambios.

dn  distingished name
nom=pep,ou=usuaris,dn=edt,dc=org  

## Ficheros datos

`.ldif` es la extensión de los datos de ldap con estos ficheros cargaremos y modificaremos los datos.

**organitzacio_edt.org** 
contiene 4 entidades con diferentes atributos, sería un ejemplo de estructura.

```bash
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

**usuaris_edt.org**   

En este ejemplo se ve los datos para introducir varios usuarios, no todos los atributos son necesarios los obligatorios para un usuario `posixAccount` son: `sn, cn, uid, uidNumber,  gidNumber, homeDirectory `

```bash
dn: cn=Pau Pou,ou=usuaris,dc=edt,dc=org
objectclass: posixAccount
objectclass: inetOrgPerson
cn: Pau Pou
cn: Pauet Pou
sn: Pou
homephone: 555-222-2220
mail: pau@edt.org
description: Watch out for this guy
ou: Profes
uid: pau
uidNumber: 5000
gidNumber: 100
homeDirectory: /tmp/home/pau
userPassword: {SSHA}NDkipesNQqTFDgGJfyraLz/csZAIlk2/

dn: cn=Pere Pou,ou=usuaris,dc=edt,dc=org
objectclass: posixAccount
objectclass: inetOrgPerson
cn: Pere Pou
sn: Pou
homephone: 555-222-2221
mail: pere@edt.org
description: Watch out for this guy
ou: Profes
uid: pere
uidNumber: 5001
gidNumber: 100
homeDirectory: /tmp/home/pere
userPassword: {SSHA}ghmtRL11YtXoUhIP7z6f7nb8RCNadFe+
```

## Ficheros de configuración

podemos modificar los datos de configuración de diferentes maneras, desde bajo nivel con los ficheros que empiezan con `s` como `slapd.conf`  o de forma de alto nivel desde comandos como `ldapadd` 

**slapf-edt.org.conf**      

Es el fichero de configuración del demonio  donde incluye los diferentes schemas de ldap, configuración de la base de datos, control de acceso, etc...

configuración de la base de datos:

```bash
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

```bash
....
# ACL for this database
access to *
    by self write
    by * read
...
```

- permisos de acceso a la base de datos.

## Pasos de instalación en docker

```bash
docker run --name ldapserver -it --hostname ldapserver fedora:27 /bin/bash
```

Ya dentro del contenedor   

```bash
dnf update vi 
dnf install -y vim procps  iputils iproute tree nmap mlocate man
```

```bash
dnf install -y openldap-clients openldap-servers  
```

esto crea un directorio `/var/lib/ldap` con el usuario ldap y siempre a de ser así  
también crea `/etc/openldap/slapd.d` donde esta la configuración en formato `.ldapd` 

### Generar la base de datos

Borraremos toda la configuración por defecto y crearemos la que deseamos desde el archivo `slapd.conf` y `DB_CONFIG` , estos dos archivos son los necesarios para generar la configuración de los datos.

`slaptest`   genera la configuración inicial en `/etc/openldap/slapd.d/` desde el fichero `slapd.conf`

copiamos dentro del contenedor los archivos que necesitaremos.

```bash
mkdir /opt/docker
# desde el host al contenedor
docker cp slapd-edt.org.conf ldapserver:/opt/docker
docker cp DB_CONFIG ldapserver:/opt/docker
docker cp usuaris_edt.org.ldif ldapserver:/opt/docker
docker cp organitzacio_edt.org.ldif ldapserver:/opt/docker
```

#### Borrar contenido por defecto

```bash
rm -rf /var/lib/ldap/*
rm -rf /etc/openldap/slapd.d/*
```

#### Generar base de datos

```bash
cp DB_CONFIG /var/lib/ldap/
slaptest -f slapd-edt.org.conf # valida el archivo de configuracion
slaptest -f slapd-edt.org.conf -u 
slaptest -f slapd-edt.org.conf -F /etc/openldap/slapd.d/ 
slaptest -f slapd-edt.org.conf -F /etc/openldap/slapd.d/ -u
```

- En este momento se a creado la base de datos pero nada más, aun no contiene datos. Comprobar con `slapcat`  o `slapcat -n0` la configuración del servidor.

> `DB_CONFIG` es un archivo binario que ayuda a la base de datos a ser mas optima en el rendimiento

#### Generar estructura

El siguiente paso sería el populate (cargar los datos ) . Cargar los datos de forma cliente mediante las ordenes `ldapadd` con el protocolo ldap o cargar entradas masivas en forma de servidor con `slapadd`.     

De marera masiva, desde el servidor ( el servicio tiene que estar apagado ).

```bash
# cargo estructura
slapadd -F /etc/openldap/slapd.d/ -l organitzacio_edt.org.ldif 
# # se podrian cargar también nlos usuarios en este paso pero lo dejamos para ver las 2 maneras.

# compruebo estructura
slapcat
chown -R ldap:ldap  /etc/openldap/slapd.d/
chown -R ldap:ldap  /var/lib/ldap/
```

> Al generar datos de esta manera los archivos cambian de usuario y grupo, por lo tanto les devolvemos sus usuario y grupo originales `ldap:ldap`  

### Arrancar servicio

```bash
/sbin/slapd
```

> ldap funciona en el puerto `389/tcp` , así que mapeando ese puerto podemos ver si esta activo.

**Comprobar**  

```bash
ldapsearch -x -LLL -b 'dc=edt,dc=org'
ldapsearch -x -LLL -b 'dc=edt,dc=org' dn
ldapsearch -x -LLL -b 'dc=edt,dc=org' description
ldapsearch -x -LLL -b 'dc=edt,dc=org'  +
ldapsearch -x -LLL -b 'dc=edt,dc=org' -h 172.17.0.2
```

- `-LLL` formato ldif

- `-b` base search

- `-x` evitar identificación avanzada 

- `-h` host 

### Cliente ldap

El cliente ldap tiene que indicar que servidor tiene que consultar, por lo tanto se lo indicamos en el archivo de configuración del cliente `/etc/openldap/ldap.conf` 

```bash
...
URI ldap://ldapserver
BASE dc=edt,dc=org
```

comprobar que funciona 

```bash
ldapwhoami -x -h 172.17.0.2
ldapwhoami -x -h 172.17.0.2 -D 'cn=Manager,dc=edt,dc=org' -w secret
```

#### Insertar datos desde cliente

```bash
ldapadd -x -h 172.17.0.2   -f usuaris_edt.org.ldif  -D 'cn=Manager,dc=edt,dc=org' -w secret
ldapadd -x -h 172.17.0.2   -f usuaris_edt.org.ldif  -D 'cn=Manager,dc=edt,dc=org' -W
```

### Generar imagen docker

Todo esto se a creado dentro de un contenedor de docker, pasaremos ese contenedor a imagen para futuros usos.

```bash
docker commit ldapserver  jorgepastorr/ldapserver19
```

### Arrancar de nuevo

En este caso ya no queremos un contenedor interactivo por lo tanto le indicaremos un `-d` 

```bash
docker run --rm -d jorgepastorr/ldapserver19 /sbin/slapd -d0
```

- `-d0`  argumento de slapd para que quede en forgraund
- `-d` detach

>  demonios del sistema se ejecutan en background los demonios de container se ejecutan en forgraund.

## Dockerfile

```dockerfile
# ldapserver
FROM fedora:27  
LABEL version="1.0"
LABEL author="@jorgepastorr"

RUN  dnf -y install openldap-servers openldap-clients
RUN mkdir /opt/docker

COPY * /opt/docker/

RUN chmod +x /opt/docker/startup.sh
CMD /opt/docker/startup.sh
```

**<u>install.sh</u>**  

```bash
#!/bin/bash
# install ldapserver

rm -rf /etc/openldap/slapd.d/*
rm -rf /var/lib/ldap/* 
cp /opt/docker/DB_CONFIG /var/lib/ldap/.
slaptest -f /opt/docker/slapd-edt.org.conf -F /etc/openldap/slapd.d/  

slapadd -F /etc/openldap/slapd.d -l /opt/docker/organitzacio_edt.org.ldif
slapadd -F /etc/openldap/slapd.d -l /opt/docker/usuaris_edt.org.ldif 

chown -R ldap:ldap /etc/openldap/slapd.d
chown -R ldap:ldap /var/lib/ldap   

cp /opt/docker/ldap.conf /etc/openldap/.
```

**<u>startup.sh</u>**  

```bash
#!/bin/bash

bash /opt/docker/install.sh
/sbin/slapd -d0
```

**Importante:** Si tenemos que arrancar el contenedor en máquinas limitadas como amazon es posible tener que añadir `unlimit -n 1024` antes de la linea de arrancar el servicio ldapd.



### Generar imagen con Dockerfile

Estando en el directorio donde se encuentra el Dockerfile

```bash
.
├── DB_CONFIG
├── Dockerfile
├── install.sh
├── ldap.conf
├── organitzacio_edt.org.ldif
├── slapd-edt.org.conf
├── startup.sh
└── usuaris_edt.org.ldif
```

> Es importante que este directorio no sea muy pesado ya que al crear la imagen copiara todo su contenido.

```bash
# generar imagen
docker build -t ldapserver:base .
# arrancar contenedor
docker run --rm -d --name ldapserver -h ldapserver -p 389:389 ldapserver:base
```

## El profe quiere/dice

Siempre que tengamos que copiar archivos dentro de una imagen hacerlo en `/opt/docker` 

La instalación básica la hará el `Dockerfile` y la configuración el archivo `install.sh`  que lo ejecutara `startup.sh` que como ultima opción siempre tendrá un servicio en foregraund.

El entrypoint de la linea de comandos  tiene mas poder que el del dockerfile, si no ponemos ninguno ejecutara el del dockerfile, si pongo un entrypoint en el `docker run` este anulara el del Dockerfile y lo remplazara.

-p local:container -p389:389  

docker history ldapserver19:base

## Cliente filtrar, modificar, añadir, eliminar.

### Búsquedas

```bash
 ldapsearch -x -LLL -h 172.17.0.2 -b 'dc=edt,dc=org' '(|(cn=* Mas)(cn=* Pou))' dn
 ldapsearch -x -LLL -b 'dc=edt,dc=org' '(&(cn=* Mas)(ou=Profes))' dn
 ldapsearch -x -LLL -b 'dc=edt,dc=org' '(&(|(cn=* Mas)(cn=* Pou))(gidNumber=600))'
 ldapsearch -x -LLL -b 'ou=usuaris,dc=edt,dc=org' 'uidNumber>=5000' dn uidNumber
 ldapsearch -x -LLL -b 'dc=edt,dc=org'  -s sub
 ldapsearch -x -LLL -b 'dc=edt,dc=org' -s base
 ldapsearch -x -LLL -b 'dc=edt,dc=org' -s one
 ldapsearch -x -LLL -b 'dc=edt,dc=org' -s children
 ldapsearch -x -LLL -b 'dc=edt,dc=org' +  #  atributos operacionales, lenguaje ldap    
```

- `-s sub` es la salida estándar
- `-s base` es el primer nivel del árbol de la base de datos
- `-s one` es el segundo nivel ( los grupos )
- `-s children` del segundo nivel incluido hasta el ultimo ( grupos y usuarios )

### Añadir

```bash
ldapadd -x -D cn=Manager,dc=edt,dc=org -w secret -f /tmp/ldap/usuario_nuevo.ldif
```

> La opción `-c` permite en el caso de añadir un elemento y falle pase al siguiente y no pare todo el proceso.

**<u>usuario_nuevo.ldif</u>** 

```bash
dn: cn=Pau Maria Pou,ou=usuaris,dc=edt,dc=org
objectClass: posixAccount
objectClass: inetOrgPerson
cn: Pau Maria Pou
sn: Pou
ou: Profes
uid: pau
uidNumber: 5000
gidNumber: 100
homeDirectory: /tmp/home/pau
userPassword:: e1NTSEF9TkRraXBlc05RcVRGRGdHSmZ5cmFMei9jc1pBSWxrMi8=
mail: modme@example.com
homePhone: 111-222-333
description: nueva descripcion para Pau Pou
```

### Eliminar

```bash
ldapdelete -x  -D cn=Manager,dc=edt,dc=org -w secret 'cn=Pau Pou,ou=usuaris,dc=edt,dc=org'
ldapdelete -x -D cn=Manager,dc=edt,dc=org -w secret -f modificaciones.ldif
```

### Modificar

```bash
ldapmodify -x -D cn=Manager,dc=edt,dc=org -w secret -f modificaciones.ldif
```

`changetype: <[modify|add|delete|modrdn]>` 

#### Modify

**<u>modificaciones.ldif</u>** 

```bash
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

borrar todos los cn repetidos y dejar solo 1

```bash
dn: cn=Anna Pou,ou=usuaris,dc=edt,dc=org
changetype: modify
replace: cn
cn: Anna Pou
```

**<u>modificaciones.ldif</u>**

```bash
dn: cn=Anna Pou,ou=usuaris,dc=edt,dc=org
changetype: delete
```

```bash
ldapdelete -x -r -D cn=Manager,dc=edt,dc=org -w secret "ou=usuaris,dc=edt,dc=org"
```

- Ojo opción `-r` recursivo que borra toda su descendencia

#### Add

**<u>modificaciones.ldif</u>**

```bash
dn: cn=Anna Pou,ou=usuaris,dc=edt,dc=org
changetype: add
objectClass: posixAccount
objectClass: inetOrgPerson
cn: Anna Pou
cn: Anita Pou
sn: Pou
mail: anna@edt.org
ou: Alumnes
uid: anna
uidNumber: 5002
gidNumber: 600
homeDirectory: /tmp/home/anna
userPassword:: e1NTSEF9Qm00QjNCdS9mdUg2QmJ5OWxneGZGQXdMWXJLMFJiT3E=
description: modified description
homePhone: 93-222-333
```

#### Modrdn

**<u>modificaciones.ldif</u>** 

```bash
dn: cn=Pau Pou,ou=usuaris,dc=edt,dc=org
changetype: modrdn
newrdn: cn=Pau Maria Pou
deleteoldrdn: 0
```

- `deleteoldrdn`  0 | 1 se  refiere a si quieres remplazar el ultimo registro de cn o solo añadir uno nuevo.

```bash
dn: cn=Anna Woman,ou=usuaris,dc=edt,dc=org
changetype: modrdn
newrdn: cn=Anna Elder
deleteoldrdn: 1
newsuperior: ou=consumidors,dc=edt,dc=org
```

- `newsuperior` modificar ruta del usuario

Modificar desde linea de comando.

```bash
ldapmodrdn -x -D cn=Manager,dc=edt,dc=org -w secret 'cn=Anna Puig,ou=usuaris,dc=edt,dc=org' 'cn=Annita Puig'
```

### Ldapcompare

ldapcompare sirve para verificar datos en scripts, muestra cierto en el caso que el dato sea correcto.

```bash
ldapcompare -x -h 172.17.0.2 'cn=Anna pou,ou=usuaris,dc=edt,dc=org' mail:anna@edt.org
TRUE
```

### getent

permite validar obtener la información de los usuarios del sistema independientemente de donde vengan.

```bash
getent passwd <usuario>
getent group <grupo>
```

```bash
ldapurl -h 172.17.0.2 -b dc=edt,dc=org -s sub

ldapurl -H ldap://172.17.0.2:389/dc=edt,dc=org?dn,mail?sub?(cn=Pau Pou)
```

### Password

**Cliente** 

```bash
 ldappasswd -x -h 172.17.0.2 -D 'cn=user10,ou=usuaris,dc=edt,dc=org' -w jupiter -s user10
```

- `-w` antiguo pasword `-s` nuevo pasword

**Servidor** 

generar contraseñas para añadir al archivo de usuarios.

```bash
slappasswd -h {SSHA}|{CRYPT}|{md5}
New password:
Re-enter new password: jupiter
{SHA}ovf8ta/reYP/u2zj0afpHt8yE1A=
```

- por defecto ya la genera `{SHA}` no hace falta la opción `-h` 

## Múltiples bases de datos

**slapd.conf**  

```bash
...
# ----------------------------------------------------------------------
database mdb
suffix "dc=edt,dc=org"
rootdn "cn=Manager,dc=edt,dc=org"
rootpw secret
directory /var/lib/ldap.edt.org
index objectClass                       eq,pres
access to * by self write by * read
# ----------------------------------------------------------------------
database mdb
suffix "dc=m06,dc=cat"
rootdn "cn=Root,dc=m06,dc=cat"
rootpw jupiter
directory /var/lib/ldap.m06.cat
index objectClass                       eq,pres
access to * by self write by * read
# --------------------------------------------------------

database config
rootdn "cn=Sysadmin,cn=config"
rootpw {SSHA}5DfZc1WXeIwrP7C3fr23WLZiPZ5YHMgA

# enable monitoring
database monitor
```

la instalación cambia un poco a la original, cada base de datos tendrá su propio directorio.

```bash
rm -rf /etc/openldap/slapd.d/*
rm -rf /var/lib/ldap/* 
mkdir /var/lib/ldap.m06.cat
mkdir /var/lib/ldap.edt.org

cp /opt/docker/DB_CONFIG /var/lib/ldap.m06.cat/.
cp /opt/docker/DB_CONFIG /var/lib/ldap.edt.org/.

slaptest -f /opt/docker/slapd.conf -F /etc/openldap/slapd.d/  

slapadd -F /etc/openldap/slapd.d -l /opt/docker/edt.org.ldif
# especifico en que base de datos inyectar los elementos con -b
slapadd -b 'dc=m06,dc=cat' -F /etc/openldap/slapd.d -l /opt/docker/m06.cat.ldif

chown -R ldap:ldap /etc/openldap/slapd.d
chown -R ldap:ldap /var/lib/ldap   
chown -R ldap:ldap /var/lib/ldap.m06.cat   
chown -R ldap:ldap /var/lib/ldap.edt.org   

cp /opt/docker/ldap.conf /etc/openldap/.
```

`/etc/openldap/slap.d` config

```bash
/var/lib/ldab.edt.org
/var/lib/ldab.m06.cat
/var/lib/ldap
```

```bash
slapcat > back.ldap.dump
```

## Backup

backup del directorio de de configuracion y de datos o con slapcat un fichero ldif  

## Acl

Las acl son los permisos que tendrá cada usuario respecto a las bases de datos

La base de datos `config` se crea por defecto, pero si no la especificas en el archivo `slapd.conf` el nombre y la contraseña de rootdn y rootpw serán aleatorios, y no podrás configurar los permisos.

```bash
database config
rootdn "cn=Sysadmin,cn=config"
rootpw {SSHA}8a7gp+odUWaevnLbf+9eJK9y3lTbMonq
```

```bash
ldapmodify -x -D 'cn=Sysadmin,cn=config' -w syskey -f acl.ldif
```



### A tener en cuenta

- Por defecto si no se especifica ninguna acl esta es `access to * by * read` 

- En cuanto añades cualquier acl por defecto se implementara en ultimo lugar  `access to * by * none` 

- El usuario especificado como `rootdn`no le afectarán en ningún caso las reglas de acl

- El usuario anonymous en ningún caso podrá modificar algún dato.

- Primero se implementaran las reglas de la base de datos y seguidamente las globales

- La posición de las reglas irán de mas restrictivas a menos.

**Sintaxis de la implantación de reglas**

```bash
access to <what> [ by <who> [ <access> ] [ <control> ] ]+

 <level> ::= none|disclose|auth|compare|search|read|{write|add|delete}|manage
```

- `what` se refiere a que atributo afecta.
- `who` quien esta afectado, usuario, grupo, etc...
- `access` tipo de acceso que se va a tener

Cuando coinciden dos o mas `what` solo se implementará el primero.

```bash
# sintaxis erronea
access to attrs=homePhone by dn.exact=”cn=Anna Pou,ou=usuaris,dc=edt,dc=org” write
access to attrs=homePhone by dn.exact=”cn=Admin System,ou=usuaris,dc=edt,dc=org” write
access to attrs=homePhone by * read

# sintaxis correcta
access to attrs=homePhone
    by dn.exact=”cn=Anna Pou,ou=usuaris,dc=edt,dc=org” write
    by dn.exact=”cn=Admin System,ou=usuaris,dc=edt,dc=org” write
    by * read
```

Ojo  con el atributo `userPassword` 

```bash
access to attrs=userPassword
        by self write
        by * auth
        [ by * none ]
access to * 
        by * read
```

Ejemplo de modificación.

```bash
dn: olcDatabase={1}mdb,cn=config
changetype: modify
replace: olcAccess
olcAccess: to attrs=homePhone by * read
olcAccess: to * by * write
```

### slapacl

Es una manera de ver los permisos rapidamente para una acción

```bash
# permisos generales de usuario
slapacl -b 'cn=Marta Mas,ou=usuaris,dc=edt,dc=org'
entry: read(=rscxd)
children: read(=rscxd)
....

# marta mas puede leer su pasword?
slapacl -b 'cn=Marta Mas,ou=usuaris,dc=edt,dc=org' -D 'cn=Marta Mas,ou=usuaris,dc=edt,dc=org' userpassword/read
read access to userPassword: ALLOWED
```

## Schemas

`/etc/openldap/schema`

En los elementos de la base de datos se le añaden objetos y atributos que están definidos en los archivos `schema` , estos atributos son los que nos ayudan a cargar los datos. Por defecto ya vienen predefinidos los objetos necesarios para su correcto funcionamiento, pero si queremos objetos adicionales se tienen que crear manualmente.

### Tipos de objeto

Toda entidad tiene que tener un objeto structural, ademas puede tener mas objetos auxiliares.

**Structural**: Es el objeto principal por el que se identificara a ese elemento, por ejemplo una persona. nombre, id, apellido.

**Auxiliary**: Es un objeto que aporta información extra al structural, por ejemplo datos de gimnasio. foto, vestuario, clases.

### Descendencia

Los objetos pueden descender de *TOP* o de otro objeto. El caso es que si desciende de TOP y es un objeto *structural*  se tiene que añadir un atributo para identificar el futuro elemento, en el caso de ser *auxiliar* no hay ningún problema.

Si un objeto desciende de otro objeto, este heredará los atributos del objeto superior.

### Identificadores

**OID** (sistema de implantación de números únicos) 

Identificadores únicos para tipo de caracteres.

| **Name**          | **OID**                       | **Description**        |
| ----------------- | ----------------------------- | ---------------------- |
| boolean           | 1.3.6.1.4.1.1466.115.121.1.7  | boolean value          |
| directoryString   | 1.3.6.1.4.1.1466.115.121.1.15 | Unicode (UTF-8) string |
| distinguishedName | 1.3.6.1.4.1.1466.115.121.1.12 | LDAP DN                |
| integer           | 1.3.6.1.4.1.1466.115.121.1.27 | integer                |
| numericString     | 1.3.6.1.4.1.1466.115.121.1.36 | numeric string         |
| OID               | 1.3.6.1.4.1.1466.115.121.1.38 | object identifier      |
| octetString       | 1.3.6.1.4.1.1466.115.121.1.40 | arbitrary octets       |

Identificadores únicos para tipo de objetos, atributos, elementos.

| **OID**   | **Assignment**     |
| --------- | ------------------ |
| 1.1       | Organization's OID |
| 1.1.1     | SNMP Elements      |
| 1.1.2     | LDAP Elements      |
| 1.1.2.1   | AttributeTypes     |
| 1.1.2.1.1 | x-my-Attribute     |
| 1.1.2.2   | ObjectClasses      |
| 1.1.2.2.1 | x-my-ObjectClass   |

**importante**: En una base de datos ldap un identificador único en un objeto, atributo, etc... no se pueden repetir, por lo tanto si creo un atributo su id será `1.1.2.1.1` y el siguiente `1.1.2.1.2` y así consecutivamente.

### Objetos

diferentes combinaciones del mismo objeto.

```
objectclass ( 1.1.2.2.1 NAME 'x-futbolistes'
    DESC 'futboleros'
    SUP TOP
    AUXILIARY
    MUST x-equip
    MAY ( x-dorsal $ x-web $ x-foto $ x-lesionat ))

objectclass ( 1.1.2.2.1 NAME 'x-futbolistes'
    DESC 'futboleros'
    SUP TOP
    STRUCTURAL
    MUST ( lonom $ x-equip )
    MAY ( x-dorsal $ x-web $ x-foto $ x-lesionat ))

objectclass ( 1.1.2.2.1 NAME 'x-futbolistes'
    DESC 'futboleros'
    SUP inetOrgPerson
    STRUCTURAL
    MUST x-equip
    MAY ( x-dorsal $ x-web $ x-foto $ x-lesionat ))
```

- `DESC`: descripcion
- `SUP`: descendencia, de donde desciende.
- `ESTRUCTURAL/AUXILIARY` : tipo de objeto
- `MUST`: Atributos obligatorio del objeto
- `MAY`: atributos opcionales

### Atributos

```
attributetype ( 1.1.2.1.1 NAME 'x-equip'
    DESC     'EQUIP DEL FUTBOLISTA'
    EQUALITY caseIgnoreMatch
    SUBSTR   caseIgnoreSubstringsMatch
    SYNTAX   1.3.6.1.4.1.1466.115.121.1.15
    SINGLE-VALUE)
```

- `DESC`: descripción

- `EQUALITY`: para restringir si es igual o no un nombre

- `SUBSTR`:  para restringir la búsqueda

- `SYNTAX`: tipo de atributo

- `SINGLE-VALUE`: valor único, no se puede repetir.

### Ejemplo schema

```scheme
attributetype ( 1.1.2.1.1 NAME 'x-equip'
    DESC     'EQUIP DEL FUTBOLISTA'
    EQUALITY caseIgnoreMatch
    SUBSTR   caseIgnoreSubstringsMatch
    SYNTAX   1.3.6.1.4.1.1466.115.121.1.15
    SINGLE-VALUE)

attributetype ( 1.1.2.1.2 NAME 'x-dorsal'
    DESC     'dorsal de futbolista'
    SYNTAX   1.3.6.1.4.1.1466.115.121.1.27
    SINGLE-VALUE)

attributetype ( 1.1.2.1.3 NAME 'x-web'
    DESC 'pagina web del futbolista'
    EQUALITY caseIgnoreMatch
    SYNTAX   1.3.6.1.4.1.1466.115.121.1.15 )

attributetype ( 1.1.2.1.4 NAME 'x-foto'
    DESC 'foto del futbolista'
    SYNTAX   1.3.6.1.4.1.1466.115.121.1.40 )

attributetype ( 1.1.2.1.5 NAME 'x-lesionat'
    DESC 'futbolista lesionat'
    SYNTAX   1.3.6.1.4.1.1466.115.121.1.7 
    SINGLE-VALUE)

objectclass ( 1.1.2.2.1 NAME 'x-futbolistes'
    DESC 'futboleros'
    SUP TOP
    AUXILIARY
    MUST x-equip
    MAY ( x-dorsal $ x-web $ x-foto $ x-lesionat ))
```



## Gestores gráficos

Existen diferentes gestores gráficos para modificar, añadir, eliminar contenido en el servidor ldap. Estos son `gq` y `phpldapadmin` , los dos realizan las mismas funciones.

**GQ** es mas simple de instalar pero menos fiable `dnf install gq`.

**phpldapadmin** tiene una pequeña configuración y requiere un apache, pero es mas fiable.



### phpldapadmin

instalación

```bash
dnf install phpldapadmin php-xml httpd
systemctl start httpd
```

configuración con ldap

```bash
# vim  /etc/phpldapadmin/config.php
$servers->newServer('ldap_pla');
$servers->setValue('server','name','Local LDAP Server');
$servers->setValue('server','host','172.17.0.2');
// ip o hostame de servidor ldap
$servers->setValue('server','port',389);
$servers->setValue('server','base',array('dc=edt,dc=org'));
$servers->setValue('login','auth_type','session');
$servers->setValue('server','tls',false)

// $servers->setValue('appearance','password_hash','ssha');
// comentada perquè generava un error
//$servers->setValue('login','attr','uid');
// comentada perquè generava un error
```

configuración para acceso remoto

```bash
# vim /etc/httpd/config.d/phpldapadmin.conf
Alias /phpldapadmin /usr/share/phpldapadmin/htdocs
Alias /ldapadmin /usr/share/phpldapadmin/htdocs
<Directory /usr/share/phpldapadmin/htdocs>
    <IfModule mod_authz_core.c>
 	   Require all granted
    </IfModule>
    <IfModule !mod_authz_core.c>
  	  Allow from *
    </IfModule>
</Directory>
```

- Por defecto phpldapadmin solo acepta acceso desde localhost, con esta configuración aceptara acceso remoto de cualquiera.

`localhost/phpldapadmin`



#### Docker

Dockerfile

```dockerfile
# phpldapadmin
FROM fedora:27  
LABEL version="1.0"
LABEL author="@jorgepastorr"
                            
RUN  dnf -y install phpldapadmin php-xml httpd
RUN mkdir /opt/docker

COPY * /opt/docker/

RUN chmod +x /opt/docker/startup.sh

WORKDIR /opt/docker
CMD /opt/docker/startup.sh                                        
```



install.sh

```bash
#!/bin/bash

cp /opt/docker/phpldapadmin.conf /etc/httpd/conf.d/
cp /opt/docker/config.php /etc/phpldapadmin/
```



startup.sh

```bash
#!/bin/bash

bash /opt/docker/install.sh
/sbin/php-fpm
/sbin/httpd -D FOREGROUND
```



```bash
➜  tree
.
├── config.php
├── Dockerfile
├── install.sh
├── phpldapadmin.conf
└── startup.sh

docker build -t phpldapadmin .
docker run -h phpldapadmin --name phpldapadmin -d -p 80:80 phpldapadmin
```



## Configurar cliente ldap

En todos los clientes que vallan a tener acceso al servidor ldap, tienen que tener la siguiente configuración.

**Paquetes necesarios** : `authconfig nss-pam-ldapd`

Primero es bueno verificar que podemos conectar con el servidor, con el paquete `openldap-clients`.

Añadimos ruta al archivo de configuración:

*/etc/openldap/ldap.conf*

```bash
...
URI ldap://ldapserver
BASE dc=edt,dc=org
```

Comprobamos con  `ldapsearch -x -LLL dn`.



### Configuración de acceso al servidor

para el acceso a los usuarios, se necesita modificar el archivo `/etc/pam.d/system-auth` , pero lo aremos automáticamente con `authconfig`

```bash
authconfig --enableshadow --enablelocauthorize \
   --enableldap \
   --enableldapauth \
   --ldapserver='ldapserver' \
   --ldapbase='dc=edt,dc=org' \
   --enablemkhomedir \
   --updateall
```



El comando anterior comando a modificado los siguientes archivos y `system-auth`

*/etc/nslcd.conf*

```bash
...
uri ldap://ldapserver
base dc=edt,dc=org
...
```

*/etc/nsswitch.conf*

```bash
...
passwd:     files ldap systemd
shadow:     files ldap
group:      files ldap systemd
...
```



En este momento ya tenemos 

- `ldap.conf` con la búsqueda predefinida a nuestro servidor ldap, para que funcionen los comandos `ldapsearch` etc.. 
- `nslcd.conf` para que el sistema conecte con el servidor ldap.
- `nsswitch.conf` para que el sistema mire los archivos `passwd, shadow, group` en el orden establecido.

Comprobamos con `getent passwd`.