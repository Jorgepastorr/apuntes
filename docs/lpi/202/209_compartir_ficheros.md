# 209 compartir ficheros

## 209.1 samba

Samba es un protocolo de transferencia de archivos, que permite la  transferencia entre dispositivos windows y linux. El protocolo tiene dos demonios `smbd, nmbd`.

- `smbd`  se encarga de las comparticiones de archivos y de impresoras.
- `nmbd` se encarga de anunciar los servicios y en general de todo el funcionamiento NetBIOS over IP.

```
139/tcp open  netbios-ssn
445/tcp open  microsoft-ds
```

Windows utiliza el protocolo para compartir smb, hoy en dia cifs.  Desde linux lo simula con samba, haciendo ver que es un dispositivo  windows y permitiendo el acceso.

### Ordenes básicas

```bash
smbstatus # ver clientes que estan conectados
testparm	# test de configuracion de samba, ver que estoy compartiendo

smbtree	#  funciona en broadcast y muestra los equipos que comparten en red la red.
smbtree -D # ver dominio
smbtree -S # ver server
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

# montage
smbmount //dirección_servidor/compartición punto_de_montaje -o user=nombre_usuario 
mount -t smbfs -o username=nombre_usuario //dirección_servidor/compartición punto_de_montaje 
mount -t cifs -o username=nombre_usuario //dirección_servidor/compartición punto_de_montaje 
```

- `smbclient, smbget`  hacen resolucion por `nmb`, que este lanza un brodcast a la red para preguntar quien hay sirviendo. 
- `mount` utiliza dns, por eso en vez de utilizar el nombre del server, utilizo la ip. Ademas se tiene que especificar el protocolo `cifs` y el usuario.

```bash
#mount -t protocolo -o usuario //server/recurso /punto_de_montaje
sudo mount -t cifs -o guest //172.17.0.2/public /mnt
```

### Configuración

La configuración esta dividida por secciones la global y los diferentes recursos.

```
workgroup = grupo_de_trabajo # El nombre del grupo de trabajo del servidor. 
   server string = comentario 
   log file = /ruta/log.%m 
   max log size = log_maxi 
   security = user (por defecto) 
   encrypt passwords = true (por defecto)
```

**Opciones** de compartición

```bash
path = /dir1/dir2/share
comment = share description
volume = share name
browseable = yes/no	# se muestra
max connections = #
public = yes/no		# yes  permiten el acceso al usuario anónimo guest,
guest ok = yes/no	# igual al anterior
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

**Sección** de directorio compartido

```
[public]
        comment = Share de contingut public
        path = /var/lib/samba/public
        public = yes
        browseable = yes
        writable = yes
        guest ok = yes
```

### Autentificación

Un servidor Linux con la suite de software Samba instalada utiliza nativamente las cuentas del sistema para las autentificaciones Samba. Sin embargo, esta situación podría ser un problema. El cliente de Windows al usar el argoritmo de hash MD4 en vez de MD5 que utiliza Linux.

Contraseña MD4 en linux

```bash
smbpasswd -a nombre_cuenta # add crear cuenta
smbpasswd -d nombre_cuenta # disable desactivar cuenta
smbpasswd -e nombre_cuenta # enable reactivasr cuenta
smbpasswd -x nombre_cuenta # eliminar cuenta
```

> las contraseñas MD4 en linux se almacenan generalmente en `/etc/samba/smbpasswd`

Se puede solicitar que se sincronicen las contraseñas Samba con las contraseñas del sistema Linux. la sincronización se realizara al ejecutar el comando `smbpasswd` este creará un hash MD4 y otro MD5

```
cat /etc/samba/smb.conf
...
unix password sync = yes
...
```



## 209.2 nfs

NFS es el protocolo tradicional de compartición de archivos en sistemas Unix. , trabaja en el puerto 2049.

El script de administración del servicio NFS provoca la ejecución de tres daemons estándar:

- portmap: gestiona las peticiones RPC (Remote Procedure Call).
- nfsd: espacio de usuario del servicio NFS. Inicia los threads NFS para las conexiones cliente.
- mountd: gestiona las peticiones de montaje de los clientes.

El fichero de directorios a exportar se encuentra en `/etc/exports`  se tiene que añadir la ruta del directorio más las opciones de exportacion.

```shell
# sample /etc/exports file
/               master(rw) trusty(rw,no_root_squash)
/projects       proj*.local.domain(rw)
/usr            *.local.domain(ro) @trusted(rw)
/home/joe       pc001(rw,all_squash,anonuid=150,anongid=100)
/pub            *(ro,insecure,all_squash)
/srv/www        -sync,rw server @trusted @external(ro)
/foo            2001:db8:9:e54::/64(rw) 192.0.2.0/24(rw)
/build          buildhost[0-9].local.domain(rw)
```



```bash
exportfs # ver  comparticiones activas en el sistema
-a	# exportar todos los direcciones
-ua	# desactivar lista de exportacion
-v	# verbose
-r	# resetear exportaciones

nfsstat	# ver estadisticas de actividad

rpcinfo opciones [servidor]	# mapeador de puertos en un sistema rpcinfo local o remoto
-p	# escanear puertos
-u [trabajo|servidor]	# probar una conexión sin hacer ningún trabajo real
-t [trabajo|servidor]	# probar coexiones tcp
```

El comando **exportfs** también permite declarar una compartición de forma interactiva. Se utiliza para declarar comparticiones puntuales.

```bash
exportfs dirección_cliente:/ruta_compartición 
exportfs *:/ruta_compartición
exportfs -o ro *:/data
```

- dirección_cliente: Dirección IP del cliente o de la red que se puede conectar a la compartición

Desde la parte del cliente si quieres montar el directorio exportado

```shell
mount -t nfs dirección_servidor:/ruta_compartición punto_de_montaje 
```

Para ver los dispositivos que han montado un directorio de exportación  en una máquina concreta.

```shell
cat /proc/fs/nfs/exports	# ver tabla de exportación del kernel

showmount [opciones] [servidor]
showmount	# mostrar nombres de clientes con montajes activos
showmount --exports	# mostrar lista de exportación activa
showmount --directories	# mostrar directorios que son montados por clientes remotos
showmount --all	# muestre tanto los nombres de cliente como los directorios
```

Los **permisos de cliente** puede ser bastante sorprendente comprobar que no se solicita ningún tipo de identificación en la conexión a una compartición NFS. Se encontrará conectado sin tener que haber proporcionado credenciales. 

Cuando un cliente se conecta a una compartición NFS, presenta su uid y tiene exactamente los permisos que el usuario con el mismo uid en el servidor. No se realiza ningún control.

Al acceder a una máquina remota por NFS como usuario root passas a ser usuario nobody debido al parametro por defecto `root_squash`  que indica: La cuenta root pierde sus privilegios en la compartición.

## 209.3 (Extra) FTP

FTP (File Transfer Protocol) es un protocolo cliente/servidor bastante antiguo que fue uno de los primeros que permitía compartir archivos entre ordenadores. Hoy en día es utilizado  especialmente por los servicios de alojamiento web que ofrecen a sus clientes accesos FTP para actualizar sus páginas web.

El nivel de transporte de FTP es TCP y funciona por el puerto 21 para la transmisión de comandos. El puerto 20 es el que se usa tradicionalmente para transmitir datos, pero no es un comportamiento universal.
