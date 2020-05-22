# Samba

Samba es un protocolo de transferencia de archivos, que permite la transferencia entre dispositivos windows y linux. El protocolo tiene dos demonios `smbd, nmbd`.

 `smbd` shares, files, print. 

`nmbd` name resolution.

```bash
139/tcp open  netbios-ssn
445/tcp open  microsoft-ds
```

Windows utiliza el protocolo para compartir smb, hoy en dia cifs. Desde linux lo simula con samba, haciendo ver que es un dispositivo windows y permitiendo el acceso.

## Diferentes rols

- stand alone:  Estar a su aire, el host puede monta directorios remotos, se administra el mismo.

- server: Ofrecer algun servicio a otro dispositivo, un stand alone que ofrece un servicio especial (montar algún directorio).

- controlador de domini: PDC (primari domain controle) o DC (domain controle)

## Tipologia de red

- peer to peer:  una red entre iguales.

- client/servidor: administración centralizada.

windows dominio

kerberros kingdom

## Organizacion

- workgroup: van a su aire pero pertenecen a un grupo

- domain: pertenecen a un dominio que tienen que dar autorizacion

//server/recurso se denomina unic

`$` final es un recurso windows oculto smbtree

## Linux y samba

- Un cliente de samba, para conectar a un server samba windows

- Un server samba para compartir una carpeta

- Puede hacer de controlador de dominio

## Ordenes samba

`testparm` test de configuracion de samba, ver que estoy compartiendo

`smbtree`  funciona en broadcast y muestra los equipos que comparten en red la red.

```bash
smbtree
smbtree -D # ver dominio
smbtree -S # ver server
```

```bash
smbclient # conectar a un recurso
smbclient //samba/manpages # conectar con user actual
smbclient -N //samba/manpages # user anonimo
smbclient //samba/manpages -U ramon # user ramon
smbclient //samba/manpages -U ramon%tururu # user%pasword
smbclient -d1 //samba/public # debug rango de 1-9

smbget # descargar archivo de recurso
smbget smb://samba/documentation/xz/COPYING
smbget -R smb://samba/documentation/ # recursivo 

smb: \> get archivo renombre
smb: \> put archivo renombre

nmblookup samba
nmblookup -A 172.17.0.2
nmblookup -S samba # registros de recurso

pdbedit -L      # usuarios de samba
```

- `smbclient, smbget`  hacen resolucion por `nmb`, que este lanza un brodcast a la red para preguntar quien hay sirviendo. 

- `mount` utiliza dns, por eso en vez de utilizar el nombre del server, utilizo la ip. Ademas se tiene que especificar el protocolo `cifs` y el usuario.

```bash
#mount -t protocolo -o usuario //server/recurso /punto_de_montaje
sudo mount -t cifs -o guest //172.17.0.2/public /mnt
```

## Acceso gráfico

Desde el explorador de archivos, se puede acceder gráficamente a un recurse que se este sirviendo:

```bash
smb://samba/public
```

lmhosts equivalente a /etc/hosts   lan manager

## Usuarios

Samba tiene sus propios usuarios, pero estos han de existir en el sistema, ya sea linux o windows.

```bash
useradd lila
smbpasswd -a lila
```

## Configuración

El archivo de configuración de samba, se encuentra en `/etc/samba/smb.conf` define shares, recursos compartidos, y configuración global.

browseable se muestra

netbios name = jorge

### Opciones shares

```bash
path = /dir1/dir2/share
comment = share description
volume = share name
browseable = yes/no
max connections = #
public = yes/no
guest ok = yes/no
guest account = unix-useraccount
guest only = yes/no
valid users = user1 user2 @group1 @group2 ...
invalid users = user1 user2 @group1 @group2 ...
auto services = user1 user2 @group1 @group2 ...
admin users = user1 user2 @group1 @group2 ...
writable = yes/no
read only = yes/no
write list = user1 user2 @group1 @group2 ...
read list = user1 user2 @group1 @group2 ...
create mode = 0660
directory mode = 0770
```

### Permisos

#### Usuarios

##### acceso anonimo

`guest ok = yes` es equivalente a `public = yes` y permiten el acceso al usuario anónimo guest, que este en el sistema linux se transforma como `nobody`.

si estan las dos y se contradicen, prevalece la ultima opcion.

```bash
[public]
        comment = Share de contingut public
        path = /var/lib/samba/public
        public = yes
        browseable = yes
        writable = yes
        guest ok = yes
```

##### solo anónimo

`guest only = yes` Permite unicamente el acceso a usuarios anónimos, si intentas acceder como usuario automáticamente ara un mapping a usuario anónimo.

```bash
[public]
        comment = Share de contingut public
        path = /var/lib/samba/public
        public = yes
        browseable = yes
        writable = yes
        guest only = yes
```

##### lista usuarios validos

`$ smbclient -U user //server/recurs`

`$ smbclient -U user%password //server/recurs`

`valid users = user1 user2 @grup1 @grup2`  Permite el acceso al recurso a los usuarios indicados en la lista.  Anónimo tampoco podrá acceder aun que este indicado `guest ok = yes`

```bash
[public]
        comment = Share de contingut public
        path = /var/lib/samba/public
        public = yes
        browseable = yes
        writable = yes
        guest ok = yes
        valid users = lila patipla
```

##### lista usuarios restringidos

`invalid users = user1 user2 userN`  indica la lista de usuarios que no pueden acceder al recurso, los demás si podrán acceder. (anónimo dependerá de `guest ok`)

```bash
[public]
        comment = Share de contingut public
        path = /var/lib/samba/public
        public = yes
        browseable = yes
        writable = yes
        guest ok = yes
        invalid users = lila patipla
```

##### Admin

`admin users = user`  Permite definir un conjunto de usuarios que serán convertidos en el sistema como root . Es decir el usuario de samba definido como admin, tendrá permisos de root en el sistema.

```bash
[public]
      comment = Share de contingut public
      path = /var/lib/samba/public
      writable = yes
      guest ok = yes
      admin users = lila
```

#### Escritura lectura

##### solo lectura

`read only = yes`  y `writeable = no` , son equivalentes. De las dos maneras estamos diciendo que es solo lectura.

si estan las dos y se contradicen, prevalece la ultima opcion.

```bash
[public]
        comment = Share de contingut public
        path = /var/lib/samba/public
        public = yes
        browseable = yes
        writable = no
        guest ok = yes
```

##### lectura escritura

`read only = no` y ` writable = yes` , son equivalentes

```bash
[public]
        comment = Share de contingut public
        path = /var/lib/samba/public
        public = yes
        browseable = yes
        read only = no
        guest ok = yes
```

##### lista usuarios lectura

`read list = user1 user2 userN` lista de usuarios que solo pueden leer. 

**Atención** esta directiva se indica en recursos que son de lectura/escritura y sirve para restringir, a los usuarios indicados, a solo lectura.

```bash
[public]
        comment = Share de contingut public
        path = /var/lib/samba/public
        public = yes
        browseable = yes
        writable = yes
        read list = rock
        guest ok = yes
```

##### Pista de usuarios escritura

`write list = user1 user2` 

Lista de usuarios que podrán escribir en el recurso, se utiliza en recursos que son solo de lectura.

```bash
[public]
        comment = Share de contingut public
        path = /var/lib/samba/public
        public = yes
        browseable = yes
        writable = no
        write list = rock
        guest ok = yes
```

##### modos de directorios ficheros

`create mask = 0600` y `directory mask = 0700`  permite establecer los permisos con los que se escribirán los archivos y directorios.

```bash
[public]
        comment = Share de contingut public
        path = /var/lib/samba/public
        public = yes
        browseable = yes
        read only = no
        guest ok = yes
        create mask = 0600
        directory mask = 0700
```

### Homes

Por defecto la configuración de samba viene un share para la exportación de los homes de usuarios.

`smbclient //samba/lila -U lila%lila`

```bash
[homes]
        comment = Home Directories
        browseable = no
        writable = yes
        valid users = %S
```
