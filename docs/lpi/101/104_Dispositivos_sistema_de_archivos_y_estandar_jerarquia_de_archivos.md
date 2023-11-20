# 104 Dispositivos, sistema de archivos Linux y el estándar de jerarquia de archivos



## Particiones y sistema de archivos

las particiones las se pueden crer con `fdisk, gdisk o parted` entre otros, siendo `fdisk` y `gparted` los principales programas en crear particiones y un uso practicamente igual.

Parted se maneja algo diferente pero la esencia es la misma.

```bash
sudo  parted /dev/sdb

# crear tabla de particiones
(parted) mklabel gpt

# crear partición lnux de 500M
(parted) mkpart                                                           
Partition name?  []? linux                                                
File system type?  [ext2]? ext4
Start? 1                                                                  
End? 512                                                                  
 
# Crear particion forma corta
(parted) mkpart windows ntfs 501 1024

# listar tabla
(parted) print                                                            
Model: ATA VBOX HARDDISK (scsi)
Disk /dev/sdc: 2147MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: 

Number  Start   End     Size   File system  Name     Flags
 1      1049kB  500MB   499MB  ext4         linux
 2      501MB   1024MB  523MB  ntfs         windows

# Eliminar particion 2
(parted) rm 2     

# recuperar particion 2
(parted) rescue 490m 1035m
Information: A ext4 primary partition was found at 99.6MB -> 200MB.
Do you want to add it to the partition table?
Yes/No/Cancel? y

# redimensionar segunda particion 
(parted) resizepart 2 2048
```

Al redimensionar un partición si tiene sistema de archivos hay que redimensionarlo también.

```bash
resize2fs /dev/sda2 # redimensionar al max disponible
resize2fs -M /dev/sda2 # redimensionar al min disponible
resize2fs /dev/sda2 100m # redimensionar tamaño indicado
```





### sistema de ficheros

**FAT32 VFAT** es antiguo y sencillo, pero es el más compatible con cualqiuier sistema operativo o dispositivo hardware. Su inconveniente es que admite como máximo archivos de 4G y particiones de máximo 2T

**NTFS** actualización de fat32, capaz de soportar archivos mayores de 4G y particiones de 2T. Incluye más funcionalidades como: permisos, cifrado, copias de seguridad, cuotas, etc..

**EXT4** ultima version de sistema ext usados en linux. El tamaño de los ficheros puede llegar a los 16TB y el de la partición puede llegar a los 1024PB

**XFS** soporta todas las funcionalidades de un sistema de ficheros moderno y permite archivos  de hasta 8EB y una partición de 16EB

**BTRFS** Es uno de los mas recientes y su uso crece cada vez más debido a las ventajas que ofrece, entre ellas:

- `multi-devices`: se puede crear un unico sistema de ficheros en varias particiones `mkfs.btrfs /dev/device1 /dev/device2 /dev/device3`
- `Compresión`: se puede montar con la opción `-o compress` y los datos se guardan comprimidos de forma transparente al usuario
- `Subvolumenes`: se puede crear subvolúmenes y snapshots(instantaneas) `btrfs subvolume create /mnt/punto-montaje/subvolumen1`  
- [mas información sobre btrfs](https://juanjoselo.wordpress.com/2018/01/28/uso-de-btrfs-en-linux/)



Para crearlos sistemas de archivos el comando más utilizado es `mkfs` junto a sus diferentes extensiones adecuadas a cada sistema de archivos

```bash
mkfs.
mkfs.ext4
mkfs.vfat
mkfs.ntfs
mkfs.btrfs
mkswap
```

Simplemente hay que indicar que extensión utilizar y en que disco, despues se monta el sistema de archivos donde más conviene

```bash
sudo mkfs.ext4 /dev/sdb1
sudo mount -t ext4 /dev/sdb1 /mnt
sudo umount /mnt
```

> Si no se especifica la extensión en `mkfs` se creara el *file sistem* por defecto `ext2` 



`mke2fs` admite una amplia gama de opciones y parámetros de  línea de comandos. Éstos son algunos de los más importantes. Todos ellos también se aplican a `mkfs.ext2`, `mkfs.ext3` y `mkfs.ext4`:

```bash
-b SIZE	# establece tamaño de bloques 1024,2048 o 4096
-c 	# comprueba el dispositivo de destino en busca de bloques defectuosos
-d DIRECTORY # copia en contenido del directorio en la raiz
-F # forzar (peligro)
-L VOLUMEN_LABEL	# añadir label al volumen
-n	# test de lo que aria. es una prueba
-q 	# modo silencioso,  no produce stdout
-U ID	# añadir ID random, time, formato 8-4-4-4-12
-V	# vervose
-T	# especifica como va a ser usado el fs, tamaño de inodo, ratio, etc...
```

> Para los sistemas de ficheros XFS y FAT, VFAT los para metros son similares pero no iguales.



Ejemplo de `btrfs` con dos discos. En el siguiente ejemplo se puede ver como btrfs junta el almacenamiento de dos discos de 1G en 2G de almacenamiento.

```bash
sudo mkfs.btrfs -m single -d single  /dev/sdb2 /dev/sdc2
btrfs-progs v4.20.1 
See http://btrfs.wiki.kernel.org for more information.

Label:              (null)
UUID:               673ebbe2-0593-421e-baa1-7427bbdf70c5
Node size:          16384
Sector size:        4096
Filesystem size:    2.00GiB
Block group profiles:
  Data:             RAID0           204.50MiB
  Metadata:         RAID1           102.25MiB
  System:           RAID1             8.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata
Number of devices:  2
Devices:
   ID        SIZE  PATH
    1  1022.98MiB  /dev/sdb2
    2  1022.98MiB  /dev/sdc2
    
# se monta cualquiera de los dos discos
sudo mount -t btrfs /dev/sdb2 /mnt

# se puede ver la suma de capacidad a 2G
sudo df -ht btrfs
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdb2       2.0G   17M  1.8G   1% /mnt
```

Creación de sistema swap

```bash
sudo mkswap /dev/sdc1	# crear filesistem swap
sudo swapon /dev/sdc1	# activar swap
sudo swapoff /dev/sdc1	# desactivar swap
```



### verificar sistema de ficheros

**fsck** verifica la integridad del sistema de ficheros. Utiliza un comando distinto dependiendo del tipo  de sistema de ficheros a analizar:

- `e2fsck` para familia ext

- `dosfsckl` para dos/fat

- `reiserfsck` para raiserFS

Opciones:

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
-U # añadir UUID

# cambiar espacio reservado de root a 1% y aññadir label buster
sudo tune2fs -m 1 -L buster /dev/sda3
```



**XFS** tiene sus propios comandos para verificar su sistema de archivos:

- `xfs_repair` es el equivalente a fsck, para sistemas XFS `xfs_repair /dev/sdaX` 

- `xfs_db` es una herramienta de depuracion de xfs, contiene sus propios subcomandos

- `xfs_fsr` defragmenta el sistema de ficheros, reorganiza sus trozos para que estén juntos `xfs_fsr /dev/sdaX` 

```bash
xfs_reapir -n /dev/sda1	# buscar errores
-m N # limita la memoria que puede utilizar repair, default 75% del sistema
-d	# reparación de sistemas montados en lectura
-v	# vervose
```



## Controlar el montaje de los sistema de archivos



**mount** monta dispositivos, siempre se usa con permisos de administrador a no ser que se configure algunas acciones para el usuario sin privilegiós.

Sintaxis `mount -t <fstype> <device> <mountpoint>`:

- fstype: el sistema de ficheros que se  va a montar (ext4, ntfs, etc...)
- device: hace referencia a una partición física. Lo más habitual es que sea un  fichero dentro de `/dev` , pero también puede ser un UUID una etiqueta o ruta de un recurso de red.
- mountpoint: donde se monta el sistema de archivos, normalmente `/media o /mnt` 

Opciones de `mount`:

```bash
mount # sin argumentos, muestra los sistemas montados
-t # filtra por el sistema de archivos indicado ext4,btrfs,ntfs
-a # esto montará todos los sistemas de archivos listados en /etc/fstab
-o # lista de opciones de montaje separadas por comas 
-r o -ro # montar en solo lectura
-w o -rw # montar en escritura y lectura
```

Igual que con `mount` sin argumentos vemos todo lo montado  el sistema on las opciones, esta información sale del archivo `/etc/mtab` 

**umount** permite desmontar una partición montada por ejemplo `umount /media/usb` 

modos de identificar una partición

- fichero `/dev/`
- UUID `mount -t vfat UUID=14Y6-47TR /media/usb`
- etiqueta ( opción -L con mount ) `mount -t vfat -L myUsb  /media/usb`

```bash
-a # desmontar todo lo listado en /etc/fstab
-f # forzar el desmontaje
-r # remontar en solo lectura
```

### Tratamiento de archivos abiertos

En ocasiones quieres desmontar un dispositivo y salta el mensaje `target is busy` . Esto sucede si hay archivos abiertos. Estos archivos tendran que ser cerrados antes de desmontar el dispositivo.

`lsof` es el comando para visualzar los procesos asociados a un dispositivo.

```bash
# umount /dev/sdb1
umount: /media/carol/External_Drive: target is busy.

# lsof /dev/sdb1
COMMAND  PID   USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
evince  3135 carol   16r   REG   8,17 21881768 5195 /media/carol/External_Drive/Documents/E-Books/MagPi40.pdf
```



### Montaje en el arranque

**/etc/fstab** es el archivo donde se guardan los puntos de montaje que se haran al arrancar el  sistema

Este es un archivo de texto, donde cada línea describe un sistema de  archivos que se va a montar, con seis campos por línea en el siguiente  orden:

```bash
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
/dev/sda5       /               ext4    errors=remount-ro 0       1
```

- `fyle sistem`: hace referencia a una partición o recurso.

- `mount point`: Dónde se montará el sistema de archivos.
- `type`: El tipo de sistema de archivos. (ext4, ntfs, xfs, vfat, ...)
- `options`: las opciones para montar un dispositivo, si son varias se separan por comas. Para opciones por defcto se utiliza **defaults**
- `dump`: si se utiliza dump para hacer copias de seguridad en esta columna podemos indicar 1 para indicar que se copie la partición o un 0 para ignorarla.
- `pass`: Cuando es distinto de cero, define el orden en el que se comprobarán los sistemas de archivos durante el arranque. Normalmente es cero.



Las diferentes formas de identificar un `file system`

```bash
/dev/sdax # nombre particion
UUID=854f5443...  # Uid completo de particion
LABEL=sistema # label de partición 
/dev/sr0      # cdrom/dvd
192.168.88.10:/ruta   # dispositivo de red  nfs
/mnt/imagen.raw   # imagen en ruta del sistema
```



Diferentes opciones de montaje de file sistem.

- `default`: Englova las siguientes opciones: `rw, suid, dev, exec, auto, nouser, and async`
- `ro, rw`: Solo lectura o lectura y escritura.
- `noauto`: no se montara automáticamente en el arranque del sistema ni con `mount -a` 
- `users` : cualquier usuario puede montar  y desmontar una linea con la opción users, indiferentemente quien lo aya montado.
- `user`: puede montar cualquier usuario, pero solo el usuario que lo monta puede desmontarlo.
- `group`: Permite a un usuario montar el sistema de archivos si el usuario  pertenece al mismo grupo que posee el dispositivo que lo contiene.
- `exec, noexec`:  no se pueden ejecutar archivos en esa partición.
- `async`  utiliza bufers para el uso de tareas en el disco, `sync`  no utiliza bufers y escribe al momento.
- `atime, noatime`: por defecto, cada vez que se lee un archivo, se actualiza la información de tiempo de acceso.
- `dev, nodev`: se deben interpretarse los dispositivos de caracteres o bloques en el sistema de archivos

- `suid, nosuid`: Permite, o no, que los bits SETUID y SETGID surtan efecto.

- `remount`: sta opción no es par `/etc/fstab`  sino para el comando `mount -o remount,ro /dev/sdb1` que remontara un dispositivo en solo lectura



### Montaje de discos con Systemd

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



#### Montaje automático de una unidad de montaje

Las unidades de montaje se pueden montar automáticamente siempre que se  acceda al punto de montaje. Para hacer esto, necesita un archivo `.automount`, junto con el archivo `.mount` que describe la unidad. El formato básico es:

*mnt-external.automount*

```bash
[Unit]
Description=Automount for the external data disk

[Automount]
Where=/mnt/external

[Install]
WantedBy=multi-user.target
```

Despues de esto se debe reiniciar el demonio de systemd e inciar la unidad:

```bash
sudo systemctl daemon-reload	# recargar systemd
sudo systemctl start mnt-external.automount	# iniciar unidad de montaje
sudo systemctl enable mnt-external.automount	# habilitar unidad en el arranque
```



## Administración de los permisos y los propietarios de los archivos



```bash
$ ls -l
drwxrwxr-x 2 carol carol   4096 Dec 10 15:57 Another_Directory
-rw------- 1 carol carol 539663 Dec 10 10:43 picture.jpg
```

- La *primera* columna de la lista muestra el tipo de archivo y los permisos. Por ejemplo, en `drwxrwxr-x`:
  - El primer caracter, `d`, indica el tipo de archivo.
  - Los siguientes tres caracteres, `rwx`, indican los permisos del propietario del archivo, también conocido como *user* o `u`.
  - Los siguientes tres caracteres, `rwx`, indican los permisos del *grupo* propietario del archivo, también denominado `g`.
  - Los últimos tres caracteres, `r-x`, indican los permisos para cualquier otra persona, también conocidos como *otros* u `o`.
- Las columnas *tercera* y *cuarta* muestran información de propiedad: respectivamente, el usuario y el grupo que posee el archivo.



### Tipos de archivos

La primera letra en cada salida de `ls -l` describe el tipo de archivo.

- `-` (archivo normal)
- `d`  (directorio) contiene otros archivos o directorios y ayuda a organizar el sistema de archivos. 
- `l` (enlace simbólico) 
- `b` (dispositivo de bloque) Este archivo representa un dispositivo virtual o físico, generalmente discos u otros tipos de dispositivos de almacenamiento.
- `c` (dispositivo de caracteres) Este archivo representa un dispositivo físico o virtual. Los terminales `/dev/ttyS0` y los puertos serie, son comunes de dispositivo de caracteres
- `s` (socket) Los sockets sirven como “conductos” para pasar información entre dos programas.



### Comprension de permisos

Primero, el sistema verifica si el usuario actual es el propietario  del archivo y, si esto es cierto, solo aplica el primer conjunto de  permisos. De lo contrario, comprueba si el usuario actual pertenece al  grupo propietario del archivo. En ese caso, solo aplica el segundo  conjunto de permisos. En cualquier otro caso, el sistema aplicará el  tercer conjunto de permisos.

Esto significa que si el usuario actual es el propietario del  archivo, solo los permisos de propietario son efectivos, incluso si el  grupo u otros permisos son más permisivos que los permisos del  propietario.



Permisos de **archivo**

```bash
r-- # ver que contiene octal 4
-w- # escribir o borrar octal 2
--x # permisos de ejecucion octal 1
```



Permisos en **directorio**

```bash
r-- # ver que contiene
-w- # escribir o borrar un elemento dentro del directorio
--x # acceder al directorio
```

Si un usuario tiene el permiso `w` en un directorio, el usuario puede cambiar los permisos de cualquier archivo en el directorio (el *contenido* del directorio), incluso si el usuario no tiene permisos sobre el archivo o si el archivo es propiedad de otro usuario.

Tenga en cuenta que tener permisos de escritura en un directorio o  archivo no significa que tenga permiso para eliminar o cambiar el nombre del directorio o archivo.



### Modificación de permisos

chmod es el comando para modificar permisos, estos se pueden modificar de dos modos: simbolico y octal.

- En el modo simbolico se especifica `u` usuario, `g` grupo, `o` others seguido de `+, -, =` y los permisos que se asignaran
- El modo contal read vale 4, write vale 2, y exec vale 1, en la suma de todo seria `4+2+1 = 7` y siete el valor de permisos a ese campo

```bash
# modo simbolico
chmod +r elemento # añade lectura a todos u,g,o
chmod -r elemento # quita lectura a todos u,g,o

chmod ug+rw-x,o-rwx elemento
chmod a=rw- text.txt

# modo octal
chmod 660 elemento
```



### Modificación de propietario

`chgrp` cambia de grupo de un elemento ( fichero o directorio )

`chown` cambia el usuario y el grupo de uno o más elementos. la opción `-R` hace que sea recursivo.

 ```bash
chown usuario:grupo elemento
chown :grupo elemento
chown usuario elemento
 ```

información de grupos

```bash
getent group	# ver grupos disponibles
groups jorge	# ver grupos de vun usuario
id	
groupmems -g grupo -l # ver usuarios que pertenecen a un grupo ( como root )
```



### Permisos predeterminados

Los permisos predeterminados en el sistema suelen ser `644` para archivos y `755` para directorios.

```bash
$ ls -lh testfile
-rw-r--r-- 1 carol carol 0 jul 13 21:55 testfile
drwxr-xr-x 2 carol carol 4,0K jul 13 22:01 testdir
```

Vienen de *user mask* `umask`  que establece los permisos predeterminados.

```bash
➜ umask
0022
➜ umask -S
u=rwx,g=rx,o=rx
```

En la forma octal es confusa, ya que en vez de sumar `4+2+1 = 7` permisos a todo. En este  caso se resta, si en la posición others hay un 2 `0022`   quiere decir que a 7 se le resta 2 quedando de resultado final, un permiso de 5.

```bash
# cambiar umask temporalmente
➜ umask 0022
➜ umask u=rwx,g=rx,o=rx

# permanente
echo "umask 0022" >> ~/.bashrc
```

Para un cambio de umask permanente se han de modificar  `/etc/bash.bashrc` (para todos) o  `~/.bashrc` (para cada usuario)

Tabla de valores en permisos umask

| Valor | Permiso para archivos | Permiso para directorios |
| ----- | --------------------- | ------------------------ |
| `0`   | `rw-`                 | `rwx`                    |
| `1`   | `rw-`                 | `rw-`                    |
| `2`   | `r--`                 | `r-x`                    |
| `3`   | `r--`                 | `r--`                    |
| `4`   | `-w-`                 | `-wx`                    |
| `5`   | `-w-`                 | `-w-`                    |
| `6`   | `---`                 | `--x`                    |
| `7`   | `---`                 | `---`                    |





### Permisos especiales

Además de los permisos de lectura, escritura y ejecución para usuario, grupo y otros, cada archivo puede tener otros tres *permisos especiales* que pueden alterar la forma en que funciona un directorio o cómo se ejecuta un programa.

**Sticky Bit** o bit Adhesivo. Esto se aplica solo a los directorios y no tiene ningún efecto en los  archivos normales. En Linux, evita que los usuarios eliminen o cambien  el nombre de un archivo en un directorio a menos que sean propietarios  de ese archivo o directorio.

Se representa en forma de `t` en el campo de others o valor octal de `1`

```bash
$ ls -ld compartida
drwxr-xr-t 1 jorge jorge 4096 feb 26 12:25 compartida/

# Para asignar este bit a un directoro:
chmod o+t compartida/
chmod 1755 compartida/	# en octal

# Y para quitarlo:
chmod o-t  compartida/
chmod 0755  compartida/	# en octal
```



**SetGID** o SGID. Esto se puede aplicar a archivos o directorios ejecutables. En archivos, hará que el proceso se ejecute con los privilegios del grupo  propietario del archivo. Cuando se aplica a directorios, hará que cada  archivo o directorio creado bajo él herede el grupo del directorio  principal.

Es decir en un directorio todos los archivos creados en su interior se crearan con el grupo del directorio.

tiene valor octal de dos y se representa por una `s` en los permisos de *group* 

```bash
$ ls -l compartida
-rwxr-sr-x 1 jorge jorge  31012 2018-08-10 12:25 compartida/

# Para asignar este bit a un fichero:
chmod g+s  compartida/
chmod 2755 compartida/	# en octal

# Y para quitarlo:
chmod g-s  compartida/
chmod 0755  compartida/	# en octal
```

Ejemplo:

```bash
$ ls -l compartida
-rwxr-sr-x 1 jorge jorge  31012 2018-08-10 12:25 compartida/

# con usuario carol 
$ touch compartida/file.txt
$ ls -lh compartida/file.txt
 -rw-r--r-- 1 carol jorge 0 Jan 18 17:20 file.txt
```



**SetUID** o SUID. Con setuid aplicado en un fichero, dicho fichero se ejecutara en nombre del usuario del fichero.  Solo se aplica a archivos y no tiene ningún efecto en los directorios.

Tiene el valor octal `4` y está representado por una `s` en los permisos de *user* 

```bash
$ ls -l /bin/su
-rwsr-xr-x 1 root root 31012 2015-04-04 10:49 /bin/su

# Para asignar este bit a un fichero:
chmod u+s /bin/su
chmod 4755 /bin/su	# en octal

# Y para quitarlo:
chmod u-s /bin/su
chmod 0755 /bin/su # en octal
```



## Enlaces duros y simbolicos

**Enlaces simbólicos** También llamados *enlaces suaves*, apuntan a la ruta de otro archivo. Si borra el archivo al que apunta el enlace (llamado *target*), el enlace seguirá existiendo, pero “deja de funcionar”, ya que ahora apunta a “nada”.

Se puede crear un enlace de dos maneras con ruta completa o parcial, la diferencia es que con la ruta parcial si movemos el fichero softlink a otro directorio, no sabra encontrar el archvo original y dejara de funcionar, en cambio con la ruta completa esto no pasará.

```bash
➜ ln -s target.txt softlink
➜ ln -s $PWD/target.txt softlink_full_path

➜ ls -l
lrwxrwxrwx 1 debian debian 10 feb 28 10:08 softlink -> target.txt
lrwxrwxrwx 1 debian debian 38 feb 28 10:16 softlink_full_path -> /home/debian/Descargas/test/target.txt
-rw-r--r-- 1 debian debian 11 feb 28 09:58 target.txt
```

l crear el softlink vemos que los permisos son totales, pero en realidad se aplicarán los permisos del archivo final.



**Enlaces duros**  Piense en un enlace físico como un segundo nombre para el archivo  original. No son duplicados, sino que son una entrada adicional en el  sistema de archivos que apunta al mismo lugar (inodo) en el disco.

A diferencia de los enlaces simbólicos, solo puede crear enlaces  físicos a archivos, y tanto el enlace como el destino deben residir en  el mismo sistema de archivos.

```bash
➜ ln TARGET LINK_NAME
➜ ln target.txt /home/carol/Documents/hard_link.txt

➜ ls -li
total 8
792634 -rw-r--r-- 2 debian debian 11 feb 28 09:58 hard_link.txt
792634 -rw-r--r-- 2 debian debian 11 feb 28 09:58 target.txt
```

En el ejemplo se puede observar que los dos archivos apuntan al mismo mismo inodo `792634`, son dos caminos al mismo punto, y en la file 3 se ve el número de caminos que existen `2`.



## Encontrar archivos de sistema



### find

Para buscar archivos en un sistema Linux, puede usar el comando `find`. Esta es una herramienta muy poderosa, llena de parámetros que pueden  adaptarse a su comportamiento y modificar la salida exactamente a sus  necesidades.

```bash
find [camino] [opciones]
opciones:
 -name		# nombre de archivo es distingue mayusculas y minusculas
 -iname		# idem al anterior sin distinguir mayusculas
 -type d,f,l	# distingue directorios, files, links
 -size +/-<n>	# busqueda por tamaño  k,M,G
 -perm [-|/] octal	# busqueda por permisos
 -user user		# busqueda  archivos de usuario
 -group grupo	# busqueda archivos de grupo
 -mmin [+/-]n	# buscar modificación por minutos, -amin acceso, -cmin cambiado atributos
 -mtime [+/-]n	# igual anterior pero en dias
 -maxdepth n	# restringir niveles de subdirectorios
 -regextype type -regex # buscar vcon expresiones regulares
 -exec <comando> ;	# explicado mas abajo
 -delete	# elimina archivos encontrados (mucho cuidado)
```

Ejemplos de busqueda:

```bash
 # por nombre
 find . -name '*.jpg'
 find /home/carol/images -name '*.jpg'
 find . -iname '*al*' -type d
 
 # por permisos o tamaño
 find . -size +2M
 find . -perm 600
 find . -user pedro
 find . -group users
 
 # por tiempo 
 find . -mmin +60 # busca elementos modificadoa hace mas de 60m
 find . -mtime -10 # busca elementos modificadoa hace menos de 10 dias
 
 # profundizar solo 2 niveles
find . -maxdepth 2 -name "*.jpg"
./Descargas/foto.jpg
```

Ejemplo argumento `-perm`

```bash
➜ ll
-rw------- 1 debian debian 0 feb 28 11:13 file1
-r-------- 1 debian debian 0 feb 28 11:13 file2
-rw-rw-r-- 1 debian debian 0 feb 28 11:13 file3

➜ find . -perm 600	# permisos iguales rw- --- ---
./file1

➜ find . -perm -600	# busca que cumplan los activos, es decir rw
.
./file1
./file3

➜ find . -perm /600	# a de cumplir alguno de los activos r o w
.
./file1
./file3
./file2
```



La opción exec permite definir un ncomando a ejeccutarse para cada resulado de la búsqueda. La cadena `{}` se sustituye por el nombre de los ficheros encontrados. El caracter `;` indica la finalización del comando. Tanto  `{}` como `;` tienen que ir entre comillas `""`

```bash
# hacer copia de todos los archivos .conf de /etc de menos de 1MiB
find /etc/ -iname '*.conf' -size -1M -exec cp '{}' /home/copias/ ';'
# borrar archivos de +2G del home de usuario
find ~ -size +2G -exec rm '{}' ';'
# archivos que contengan informe ennsu interior
find . -type f  -exec grep -l informe '{}' ';'
# listar archivos de +1G
find . -size +1G -exec ls -l '{}' ';'
# listar archivos de +1G y saber el tamaño
find . -size +1G -exec du -h '{}' ';'
```



### locate

`location` y `updatedb` son comandos que pueden usarse para encontrar rápidamente un archivo que coincida con un patrón dado en un sistema Linux. Buscará en una base de datos construida ejecutando el comando `updatedb`. Esto le da resultados muy rápidos, pero pueden ser imprecisos  dependiendo de cuándo se actualizó la base de datos por última vez.

```bash
# busca un patron
$ locate jpg	
/home/carol/Downloads/Expert.jpg
/home/carol/Downloads/jpg_specs.doc

# no ignoda mayusculas
$ locate -i jpg		
/home/carol/Downloads/Mate1.jpg
/home/carol/Downloads/Mate1_old.JPG

# multiples patrones
$ locate -i zip jpg
/home/carol/Downloads/Expert.jpg
/home/carol/Downloads/gbs-control-master.zip

# multiples patrones coincidentes (and)
$ locate -A .jpg .zip
/home/carol/Downloads/Pentaro.jpg.zip

$ locate -c .jpg
1174
```

Un problema con `locate` es que solo muestra las entradas presentes en la base de datos generada por `updatedb` (ubicada en `/var/lib/mlocate.db`). Si la base de datos está desactualizada, la salida podría mostrar  archivos que se han eliminado desde la última vez que se actualizó.

El comportamiento de `updatedb` puede ser controlado por el archivo `/etc/updatedb.conf`.



### Busqueda de binarios y manuales

`which` es un comando muy útil que muestra la ruta completa a un ejecutable. Busca los ejecutables en las rutas de `$PATH`

```bash
$ which less
/usr/bin/less

$ which -a less
/usr/bin/less
/bin/less
```

`type` es un comando similar que mostrará información sobre un binario, incluyendo dónde se encuentra y su tipo. 

```bash
$ type touch    
touch is /usr/bin/touch

$ type -a touch
touch is /usr/bin/touch
touch is /bin/touch

$ type ll
ll is an alias for ls -lh
```

`whereis` es más versátil y, además de los  binarios, también se puede usar para mostrar la ubicación de las páginas de manual o incluso el código fuente de un programa (si está disponible en su sistema). 

```bash
$ whereis locate   
locate: /usr/bin/locate.findutils /usr/bin/locate /usr/lib/x86_64-linux-gnu/locate /usr/share/man/man1/locate.1.gz

$ whereis -b locate
locate: /usr/bin/locate.findutils /usr/bin/locate /usr/lib/x86_64-linux-gnu/locate

$ whereis -m locate
locate: /usr/share/man/man1/locate.1.gz
```

