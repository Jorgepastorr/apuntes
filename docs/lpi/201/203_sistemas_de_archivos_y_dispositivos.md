# 203 sistemas de archivos y dispositivos



## 203.1 Manipular sistemas de archivos



### Tipos de filesystem

| fisic    | filesystem                                                   |
| -------- | ------------------------------------------------------------ |
| EXT2     | versión base de ext, archivos de hasta 2TB y volumen máximo 32TB, fecha limte de archivo en 2038. |
| EXT3     | se añade un registro de transacciones sobre la version ext2. |
| EXT4     | archivos hasta 16TB y volumenes 1EB, fecha limite de archivo en año 2514. |
| reiserfs | Este tipo de sistema de archivos ya no se mantiene, por lo que se debería evitar. Tenia un rendimiento ligeramente mejor a ext3 |
| XFS      | - Permite archivos  de hasta 8EB y una partición de 16EB <br>- Las operaciones de escritura sobre los metadatos se escriben en el registro antes de ejecutarse, lo que permite garantizar la coherencia del sistema de archivos en caso de fallo físico. <br>- Permite realizar de forma simultánea diferentes operaciones de entrada/salida en un mismo sistema de archivos<br>- Permite crear snapshots, Se puede ampliar en caliente, herramientas especificas |
| BTRFS    | - implementa la posibilidad de compresión, de copia de seguridad en línea, de redundancia de datos, de snapshot, de redimensionamiento en línea, etc.<br>- `multi-devices`: se puede crear un unico sistema de ficheros en varias particiones `mkfs.btrfs /dev/device1 /dev/device2 /dev/device3`<br>- `Subvolumenes`: se puede crear subvolúmenes y snapshots(instantaneas) `btrfs subvolume create /mnt/punto-montaje/subvolumen1`  <br>- [mas información sobre btrfs](https://juanjoselo.wordpress.com/2018/01/28/uso-de-btrfs-en-linux/) |



**Virtual filesystem o Pseudofilesystem**

En los sistemas Linux hay sistemas de archivos virtuales que solo están presentes en memoria sin ocupar espacio en disco.

`proc` El sistema de archivos virtual **proc** (o **procfs**), generalmente montado en el directorio `/proc`, permite la visualización de los elementos del sistema relacionados con la gestión de procesos por parte del núcleo.

`sys` El sistema de archivos virtual **sys** (o **sysfs**), generalmente montado en el directorio `/sys`, permite visualizar elementos de sistema relacionados con los periféricos.





**Creación sistem de archivos**

Para crear los sistemas de archivos el comando más utilizado es `mkfs` junto a sus diferentes extensiones adecuadas a cada sistema de archivos

```bash
mkfs -t tipo dispositivo 
-c	# comprovar bloques defectuosos

sudo mkfs.ext4 /dev/sdb1
sudo mkfs -t ext4 /dev/sdb1

mkfs.ext4
mkfs.vfat
mkfs.ntfs
mkfs.btrfs
mkfs.xfs
mkswap
```





### Administración del swap

El swap es una partición en la que la RAM utiliza para grabar datos en caso de que el sistema este llegando a sus límites y así evitar el colapso del sistema. 

La gran época del swap se dio cuando la memoria tenía un coste tan caro que era necesario encontrar para el servidor un compromiso entre el coste del sistema y el rendimiento que podía obtener.

Hoy en  día aun que se crea por defecto en la instalación básica, no es obligatoria. El tamaño a establecer como Swap siempre a sido un dilema, antiguamente se decia igual o doblar el tamaño de RAM. En los tiempos que corren dedicar 4G al swap es  suficiente.

```bash
# crear filesystem swap
mkswap espacio_de_almacenamiento
/ruta/archivo
/dev/device
-L label
-U uuid

swapon espacio_de_almacenamiento
-s	# visualizar espacio  swap ( /proc/swaps)
-a	# montar swap definida en /etc/fstab

swapoff espacio_de_almacenamiento
-a	# desmontar swap definida en /etc/fstab
```

Por defecto las distribuciones empiezan a utilizar swap cuando la ram está a un 40% de su capacidad, y lo ideal es cambiarlo a 10% o 0%.

```bash
sudo sysctl -a | grep vm.swappiness	# ver porcentaje actual
sudo echo vm.swappiness=10 >> /etc/sysctl.conf	# definir porcentaje
sudo sysctl -p	# guardar
```



### Montaje del sistema de ficheros

El comando más usado para montar  sistemas de ficheros localmente es `mount` junto `umount` para desmontarlos.

```bash
mount [-t tipo_fs] [-o opciones] dispositivo punto_de_montaje
umount [-O opciones] [dispositivo] punto_de_montaje 
-f	# forzar desmontaje
-l	# desmontar cuando todo este liberado

# visualizan filesystem montados
mount
/etc/mtab
/proc/mounts
```



**/etc/fstab** es el archivo donde se guardan los puntos de montaje que se haran al arrancar el  sistema

Este es un archivo de texto, donde cada línea describe un sistema de  archivos que se va a montar, con seis campos por línea en el siguiente  orden:

```bash
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
/dev/sda5       /               ext4    errors=remount-ro 0       1
```



|               |                                                              |
| ---------------------- | ------------------------------------------------------------ |
| `fyle_sistem` | hace referencia a una partición o recurso.                   |
| `mount_point` | Dónde se montará el sistema de archivos.                     |
| `type`        | El tipo de sistema de archivos. (ext4, ntfs, xfs, vfat, ...) |
| `options`     | las opciones para montar un dispositivo, si son varias se separan por comas. Para opciones por defcto se utiliza **defaults** |
| `dump`        | si se utiliza dump para hacer copias de seguridad en esta columna podemos indicar 1 para indicar que se copie la partición o un 0 para ignorarla. |
| `pass`        | Cuando es distinto de cero, define el orden en el que se comprobarán los sistemas de archivos durante el arranque. Normalmente es cero. |



Las diferentes formas de identificar un `file system`

```bash
/dev/sdax # nombre particion
UUID=854f5443...  # Uid completo de particion
LABEL=sistema # label de partición 
/dev/sr0      # cdrom/dvd
192.168.88.10:/ruta   # dispositivo de red  nfs
/mnt/imagen.raw   # imagen en ruta del sistema
```



|                  | Diferentes opciones de montaje de file sistem.               |
| ---------------- | ------------------------------------------------------------ |
| `default`        | Englova las siguientes opciones                              |
| `ro, rw`         | Solo lectura o lectura y escritura.                          |
| `noauto`         | no se montara automáticamente en el arranque del sistema ni con `mount -a` |
| `users`          | cualquier usuario puede montar  y desmontar una linea con la opción users, indiferentemente quien lo aya montado. |
| `user`           | puede montar cualquier usuario, pero solo el usuario que lo monta puede desmontarlo. |
| `group`          | Permite a un usuario montar el sistema de archivos si el usuario  pertenece al mismo grupo que posee el dispositivo que lo contiene. |
| `exec, noexec`   | no se pueden ejecutar archivos en esa partición.             |
| `async`          | utiliza bufers para el uso de tareas en el disco, `sync`  no utiliza bufers y escribe al momento. |
| `atime, noatime` | por defecto, cada vez que se lee un archivo, se actualiza la información de tiempo de acceso. |
| `dev, nodev`     | se deben interpretarse los dispositivos de caracteres o bloques en el sistema de archivos |
| `suid, nosuid`   | Permite, o no, que los bits SETUID y SETGID surtan efecto.   |
| `remount`        | sta opción no es par `/etc/fstab`  sino para el comando `mount -o remount,ro /dev/sdb1` que remontara un dispositivo en solo lectura |



#### Montaje con Systemd

Systemd también se puede utilizar para gestionar el montaje (y montaje automático) de sistemas de archivos.

Para utilizar esta función de systemd, debe crear un archivo de configuración llamado *mount unit*. Cada volumen que se va a montar tiene su propia unidad de montaje y es necesario colocarlos en `/etc/systemd/system/`.

*mnt-external.mount*

```bash
[Unit]
Description=External data disk

[Mount]
What=/dev/disk/by-uuid/56C11DCC5D2E1334
Where=/mnt/external
Type=ntfs
Options=defaults

[Install]
WantedBy=multi-user.target
```

> Para que funcione correctamente, la unidad de montaje *debe* tener el mismo nombre que el punto de montaje. En este caso, el punto de montaje es `/mnt/external`, por lo que el archivo debe llamarse `mnt-external.mount`.

Despues de esto se debe reiniciar el demonio de systemd e inciar la unidad:

```bash
sudo systemctl daemon-reload	# recargar systemd
sudo systemctl start mnt-external.mount	# iniciar unidad de montaje
sudo systemctl enable mnt-external.mount	# habilitar unidad en el arranque
```



## 203.2 Mantener sistemas de archivos

**tar** es un clasico en copias de seguridad en Linux, esto se deve a la versatilidad a la hora de crear copias de seguridad a nivell de archivos.

opciones para copia de seguridad

- Totales: se copian todos los datos

- Diferenciales: se copian sólo los que se hayan modificado desde una fecha indicada. Se utiliza la opción `-N` seguido de la fecha
- incrementales: se copian sólo los ficheros que se han modificado desde la última copia. Se utiliza la opción `-g` seguido de la ruta del fichero de registro.

```bash
-c # comprime
-x # descomprime
-z # gzip
-J # xz
-j # bzip2
-p # conserva permisos
-h # conservar softlinks
-v # muestra informacion vervose
-P # conserva ruta absoluta
-f # referencia a archivos       
-r # añade elementos a un fichero compacto
-t # ver interior tar
-u # añadir archivo a tar
--exclude # Excluir directorio o fichero
--delete # borrar ruta del interior del tar
```



```bash
tar cf file.tar files*
tar xf file.tar

tar czf file.tar.gz files*
tar xzf file.tar.gz

find /etc -type f -print0 | tar -cJ -f /srv/backup/etc.tar.xz -T - --null
```

La opción `-T` indica que son nombres extraidos de un fichero o comando, y la opción `--null` que el caracter separador es nulo.



**cpio** tiene una función parecida a `tar`. Copia ficheros  y desde n solo archivo. Utiliza la enttrada y salida estándar para el origen y destino de datos.

```bash
-o	# crear un archivo  con el contenido que le indiquemos
-i 	# extrae el contenido de un fichero
-t 	# junto con "-i" lista el contenido de un archivo de recopilación existente
-p	# copia una estructura de directorios a otro lugar

find /etc/ | cpio -o > copia_etc.cpio
cpio -i < copia_etc.cpio

find /etc/ | cpio -o | gzip > copia_etc.cpio.ggz
```



**Btrfs** es un nuevo sistema de archivos de copia en escritura (CoW) para Linux  destinado a implementar funciones avanzadas mientras se enfoca en la  tolerancia a fallas, reparación y fácil administración.

Algunas ventajas son: crear sistema de ficheros en multiples discos, compresión  de datos, suvbolumenes y snapshots, soporta raid.

```bash
# crear una particion en varios discos
mkfs.btrfs /dev/sdb /dev/sdc /dev/sdd /dev/sde
# creacion raid 0
mkfs.btrfs -d raid0 /dev/sdb /dev/sdc
# raid10 con datos y metadatos 
mkfs.btrfs -m raid10 -d raid10 /dev/sdb /dev/sdc /dev/sdd /dev/sde
# no duplicar datos en una unidad
mkfs.btrfs -m single /dev/sdb

btrfs filesystem show	# ver sistema de archivos creados

btrfs subvolume create /home	# crear subvolumen de /home
btrfs subvolume snapshot /home/ /home-snap	# crear snapshot
btrfs subvolume delete /home-snap/	# eliminar instantanea
```



**ZFS** actualmente propiedad de Oracle Corporation, fue desarrollado en Sun Microsystems  como un sistema de archivos de próxima generación destinado a una  escalabilidad casi infinita y libre de paradigmas de diseño  tradicionales.

las principales ventajas de zfs son: alta tolerancia a fallos, almacenamiento casi ilimitado, gestion hibrida de volumen, compresion, snapshots, volumenes(zvols), ...

```bash
zpool create -f -m /tank tank /dev/vdb	# crear volumenes
zpool scrub tank	# añadir control de fallos al volumen
zpool list 
zpool status 
zpool history	

# creear subvolumen con compresion
zfs create -o compression=on tank/documents	

zfs create tank/documents
zfs set compression=on tank/documents

zfs list 

# snapshots
zfs snapshot tank/documents@backup
zfs list -t snapshot
ll /tank/documents/.zfs/snapshot/backup
```





### copias de seguridad a nivel de sistema de archivos

Las utilidades **dump** y **restore** permiten realizar copias de seguridad incrementales y la restauración de un sistema de archivos entero.

```bash
 dump 0 -f /root/cs /dev/sdb1 
 0	# n nivel de incremento 0 copia completa
 -f	# archivo destino
 
 restore  -rvf /root/cs
 -r	# realizar restauracion
 -f	# fichero de restauración
```



Los sistemas de ficheros xfs tienen sus propias herramientas `xfsdump xfsrestore`

```bash
xfsdump -f file.dump /dev/sdb2
-L	# añadir etiqueta
-f	# modo desatendido
-E	# sobreescritura

xfsrestore -f file.dump dir-destino
-t	# ver contenido del dump
-f	 # fichero de dump
-v trace	# visualizacion detallada
```



### Programas de copias de seguridad

**AMANDA** (Advanced Maryland Automatic Network Disk Archiver) es una solución de copias de seguridad creada inicialmente por la universidad de Maryland con licencia BSD. Disponible con licencia libre (gratuita) o comercial, AMANDA permite hacer copias de seguridad de forma local o en red, en discos o en cintas, de los datos de sistemas Linux/Unix o Windows.

**Bacula** es un programa con licencia GPL que permite crear copias de seguridad de forma local o en red, en discos o en cintas, de los datos de sistemas Linux/Unix o Windows.

**BackupPC** es un programa con licencia GPL que permite crear copias de seguridad de forma local o en red, en discos o en cintas, de los datos de sistemas Linux/Unix o Windows.



### Revisión de filesystems

**fsck** verifica la integridad del sistema de ficheros. Utiliza un comando distinto dependiendo del tipo  de sistema de ficheros a analizar:

- `e2fsck` para familia ext
- `dosfsckl` para dos/fat
- `reiserfsck` para raiserFS
- `xfs_check, xfs_repair` para xfs

Opciones fsck:

```bash
-A verifica todos los sistemas de fstab
-C indica el progreso
-V salida detallada
-N simular verificación
-f fuerza verificación
-p repara sin preguntar
```

Para verificar un sistema de ficheros la partición a de estar desmontada obligatoriamente

```bash
sudo fsck.ext4  /dev/particion
```



**dumpe2fs** muestra información técnica sobre el sistema de ficheros que le pasemos como parametro. es recomendabl usar la opción `-h` para mostrar unicamente la información más importante `dumpe2fs -h /dev/particion`

**tune2fs** Modifica opciones del sistema de ficheros, es muy extensa y técnica esta orden ya que modificar las opciones del sistema de ficheros puede ser en algunos casos peligroso. Las opciones más sencillas serian:

```bash
-l # ver parametros actuales
-c # numero maximo de montajes tras los que se hara una verificación
-i # periodo maximo entre comprobaciones, se usa d,w y m para dia, semana y mes
tune2fs -i 1m /dev/sdb1

-m # porcentaje de espacio reservado para root
-L # estblece etiqueta del volumen
-U [uuid|random|time]# añadir UUID

-j  dispositivo # convertir de ext2 a ext3
-0 extents,uninit_bs,div_index dispositivo # convertir de ext3 a ext4

# cambiar espacio reservado de root a 1% y aññadir label buster
sudo tune2fs -m 1 -L buster /dev/sda3
```



**XFS** tiene sus propios comandos para verificar su sistema de archivos:

- `xfs_repair` es el equivalente a fsck, para sistemas XFS `xfs_repair /dev/sdaX` 

- `xfs_db` es una herramienta de depuracion de xfs, contiene sus propios subcomandos

- `xfs_fsr` defragmenta el sistema de ficheros, reorganiza sus trozos para que estén juntos `xfs_fsr /dev/sdaX` 

```bash
xfs-info device|puntoMontaje

xfs_reapir -n /dev/sda1	# buscar errores
-m N # limita la memoria que puede utilizar repair, default 75% del sistema
-d	# reparación de sistemas montados en lectura
-v	# vervose

xfs_admin 
-L etiqueta device	# asignar etiqueta max 12 caracteres
-U uuid device		# añadir uuid

xfs_growfs -D Nuevotamaño device	# aumentar filesistem a tamaño indicado
xfs_growfs -d device	# aumentar tamaño al max permitido

xfs_fsr device	# defragmentar

mkfs.xfs -f -d size=25g /dev/sdb	# crear filesistem xfs de 25G
```

`xfsdump`  El comando gestiona niveles de copia de seguridad, lo que permite implementar estrategias de copias incrementales. Solo se puede hacer una copia de seguridad de un sistema de archivos si está montado. 

```bash
xfsdump -F -f /var/datassave.dump /dev/sdb  
-f file	# archivo donde se crea la copia
-F	# modo desatendido

xfsrestore 
-t -f /var/datassave.dump	# muestra objetos del dump
-f /var/datassave.dump .	# restaurar
```





## 203.3 Crear y configurar opciones

### Encriptación de datos

Una manera simple de protejer los datos es cifrando y descifrando manualmente el contenido con datos sensibles.

```bash
cencrypt file -K pass
ccat file
cdecrypt file -K pass
```

Otra forma de protejer los datos es cifrar directamente una partición, siempre teniendo cuidado de no cifrar la partición que contenga el kernel.

```bash
cryptsetup luksFormat /dev/vdb1 	# formatear particion como encrypt_luks
cryptsetup luksOpen /dev/vdb1 cryptpart	# crear volumen y generar pasword
mkfs.ext4 /dev/mapper/cryptpart 	# formatear volumen
mount /dev/mapper/cryptpart /mnt/secret	# montar volumen en el sistema

cryptsetup luksDump /dev/vd1	# ver informacion
```



El mejor compromiso entre la flexibilidad y la eficiencia lo aporta el cifrado a nivel de sistema de archivos.

En el siguente ejemplo se creasn dos directorios y se montan uno encima del otro. los archivos creados en datos se trabaja como siempre, pero al desmontar todos esos archivos estan encriptados en `.datos`

```bash
mkdir .datos datos	
mkdir -t ecryptfs .datos datos
umount datos
```





### Administración de datos almacenados

`udev` funciona en segundo plano por su cuenta, pero en ocasiones queremos gestionar algún comportamiento especifico y esto es posible hacerlo mediante reglas

La ubicación de estas reglas se precisa en el archivo de configuración de udev: **/etc/udev/udev.conf**. En el supuesto de que no se haya informado, su valor por defecto es **/etc/udev/rules.d**.

```bash
udevadm info /dev/sda	# información de cdisco
udevmonitor	# monitorización
lsdev	# ver perifericos reconocidos
ls /dev/disk/	# directorios de reconocimiento de discos
by-id  by-partuuid  by-path  by-uuid
```

**El rendimiento** de discos lo checkeamos con `hdparm`, también se puede cambiar algunas opciones de disco.

```bash
hdparm /dev/sda	# ver opciones 
-c	# acceso 32bits
-d	# acceso DMA
-a	# lectura canticipada
```

Los **fallos en disco** debido a bloques defectuosos se comprueba con `badblocks` una vez detectados se tendrán que gestionar mediante ordenes como `e2fsck o mke2fs`

```bash
badblocks -b tamaño_bloke -o archivo_salida
badblocks /dev/sdb1
```



### Gestión de discos iSCSI

**SCSI** (Small Computer System Interface) es una familia de protocolos de comunicación destinados a los dispositivos de entrada/salida. . Es un protocolo cliente servidor, que permite al cliente (el sistema) enviar peticiones al servidor (el controlador SCSI), que se encarga de gestionar las unidades de almacenamiento.

**iSCSI** (Internet SCSI) es una extensión de red del protocolo SCSI, que permite transferir comandos SCSI a través de una red TCP/IP. De este modo se pueden gestionar a distancia accesos a discos de bajo nivel, sobre una topología de tipo Ethernet.

**Open-iSCSI** es una implementación de este protocolo sobre Linux. Este software permite a un sistema Linux utilizar este protocolo como cliente (acceder a los servidores de almacenamiento de disco iSCSI).



Los nombres iSCSI utilizan una nomenclatura de tipo WWN (World Wide Name), de manera que asegure que sea única:

**iqn.**: prefijo que especifica el espacio de nombres (iSCSI qualified name).

**AAAA-MM.**: fecha (Año-Mes) prevista que corresponderá al primer mes de asignación del nombre de dominio utilizado por la autoridad administradora de este WWN.

**Dominio**: nombre de dominio, en orden inverso, de la autoridad administradora de este WWN.

**:cadena_ident**: eventualmente, identificador del elemento designado para este nombre. La unicidad de este identificador es responsabilidad de la autoridad administradora del WWN.

```bash
iqn.2014-01.net.pas:cloud1.target1
```



### 

**La implementación de un cliente** iSCSI en Linux, para permitir al sistema utilizar discos remotos a través de una red TCP/IP, se hace mediante tres conjuntos de elementos:

- Un módulo central que gestiona las interfaces de red TCP/IP.
- Un módulo servidor que garantice la comunicación con los servidores de almacenamiento de destino.
- Comandos de gestión que permiten gestionar las unidades lógicas de almacenamiento de los servidores de destino iSCSI.

El archivo de configuración por defecto del servidor **iscsid** es `/etc/iscsi/iscsid.conf`. 

El descubrimiento de un servidor iSCSI se hace mediante su portal de red, identificado por una dirección IP.

```bash
iscsiadm -m discovery -t sendtargets -p 192.168.0.39 	# descubrir servidor
# conectar servidor
iscsiadm -m node -T iqn.2008-09.com.ejemplo:server.target1 -p 192.168.0.39 --login  
# desconectar servidor
iscsiadm -m node -T iqn.2008-09.com.ejemplo:server.target1 -p 192.168.0.39 -logout 
```



**Linux como servidor** iSCSI arranca como servicio, se pone a la escucha de las peticiones de los clientes iSCSI (los iniciadores) y por defecto en el puerto 3260. Este servidor gestiona uno o varios destinos y, para cada uno de ellos, una o más unidades lógicas (LUN).

En el archivo de configuración `/etc/tgt/targets.conf`:

```bash
<target iqn.2008-09.com.ejemplo:server.target1> 
    backing-store /dev/sdf 
</target>
```

```bash
service tgtd start 
tgtadm --mode target --op show # ver 
```



### Duplicación y sincronización de datos

El comando de copia bloque a bloque `dd` permite realizar copias de bajo nivel de un periférico.

```bash
dd if=entrada of=salida bs=tamaño_del_bloque count=número_de_bloques 

if=origen
of=destino
bs 	# tamaño del bloque a copiar
count	# cantidad de bloques a copiar

dd if=/dev/sdb1 of=/home/alumno/usb.img
dd if=/dev/zero of=fichero bs=1024 count=100000 # archivo 100M
```



`mkisofs o genisoimage` genera archivos  ISO.  Puede ser útil generar imágenes ISO a partir de una estructura de directorios.

```bash
genisoimage -J -o imagen.iso directorio
-J	# opcional: Mejora la compatibilidad con los sistemas Windows.
-o	# archivo imagen a generar
-r	# permisos de lectura a todos los archivos

mount -t iso9660 -o loop archivo_de_imagen punto_de_montaje 
```



Sincronización de datos con `rsync`

```bash
rsync -a m04-lm  /tmp/proves/ # copia el directorio
rsync -a --delete  m04-lm/  /tmp/proves/ # sincronizar borrando si hay cambios

rsync -a m04-lm/  localhost:/tmp/proves/ # remoto
-n --dry-run # acer test
rsync -a ~/dir1 username@remote_host:destination_directory

rsync -av --delete -e ssh /root/data root@192.168.200.106:/root/svg # conexion segura
```



rsync puede funcionar como servidor añadiendo ciertos permisos al archivo `/etc/rsyncd.conf `

```bash
log file = /var/log/rsync.log
pid file = /var/run/rsyncd.pid

[public]
        comment = recurso publico
        path = /home/debian/rsync/public

[read]
        comment = recurso solo lectura
        path = /home/debian/rsync/read
        read only = yes

[privat]
        comment = recurso de escritura
        path = /home/debian/rsync/privat
        list = no
        read only = no
        write only = no
        auth users = jorge
        secrets file = /etc/rsyncd.secrets

[write]
        comment = recurso de escritura
        path = /home/debian/rsync/write
        read only = no
        write only = yes
```

> `read only = no` Imprescindible para que el servicio pueda escribir en el disco.

Para el modo servidor tiene algunas ordenes adicionales

```bash
rsync  localhost:: # listar recursos
rsync  localhost::public  # listar contenido de public
rsync  -a file localhost::write # subir contenido
rsync  -a localhost::public . # descargar contenido
```

