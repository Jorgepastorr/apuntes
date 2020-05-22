## Disco

Dispositivos de bloque `fd0, hd, sda`  leen y escriben de 512 bits en 512.
Dispositivos caracteres `tty, consola`

**msdos**  

- 4 particiones primarias
- 1 de ellas puede ser extendida, esta diseñada para contener mas particiones
- las particiones en el interior de la extendida se denominan logicas y la primera sera sda5.
- extendida puede contenes hasta un maximo de 16 particiones.

### fs filesystem

Existen muchos tipos de sistemas de ficheros, según que quiera administrar en ese sisema de archivos formateare con uno o otro, hay sistemas optimizados para diferentes tipos de archivos, pequeños, grandes, etc..

#### swap

El funcionamiento de la partición swap consiste en impedir que el ordenador se bloquee facilitando un espacio extra  a la ram. 

Una vez la ram se queda sin espacio o está prácticamente llena  utiliza el swap una partición del disco dedicada para insertar los procesos que cree ella menos importantes y en desuso.

Problemas del uso de swap, el principal que  la velocidad de disco es de 10 millones de veces más lenta que de ram por lo tanto se ralentiza el pc considerablemente.

Por defecto fedora empieza a utilizar swap cuando la ram está a un 40% de su capacidad, y lo ideal es cambiarlo a 10% o 0%.

En este caso tendremos un uso más fluido de nuestro pc y usará el swap cuando realmente estés forzando el pc.

**Utilidades de partición swap:** 

```bash
swapon -a	# montar swap definida en fstab
swapoff -a	# desmontar todas las swap 
mkswap /dev/sdax	# asignar sistema de fichero swap a particion
swaplabel /dev/sdax myswap	# asignar label a swap
```



**Proceso para cambiar el %:**

mirar cómo está el %.

```bash
sudo sysctl -a | grep vm.swappiness
```



modificar permanentemente.

```bash
sudo echo vm.swappiness=10 >> /etc/sysctl.conf
```

 

guardar cambio

```bash 
sudo sysctl -p
```



##### Activar / desactivar swap

Se puede activar o desactivar el swap corriendo el peligro de que si fuerces el pc te quedes colgado con el comando swapon, swapoff.

```bash
sudo swapon /dev/<disco>  # activa la partición swap
sudo swapoff /dev/<disco>  # desactiva la partición swap
```



Se puede ver que puntos de montaje hay en nuestro pc en ***/etc/fstab***, hay compruebas que realmente está el punto de montaje con el disco deseado mediante nombre de disco o UID

la opción default es el acceso estándar, se puede restringir a solo lectura o solo acceso para 1 usuario etc..

opciones en ***$ man fstab***

### Particiones

**UUID universal unic identificador**   

Las particiones se identifican con un UUID, cada vez que se crea o formatea cambiara dicho UUID.

```bash
 ls -l /dev/sda*
brw-rw---- 1 root disk 8, 0 abr  1 15:04 /dev/sda
brw-rw---- 1 root disk 8, 1 abr  1 15:04 /dev/sda1
brw-rw---- 1 root disk 8, 2 abr  1 15:04 /dev/sda2
```

- el numero 8 es el tipo de dispositivo, 0 es la partición

Existen diferentes tipos de imagenes, `raw` para  crudo, `iso` tipo cd y dvd, `qcow2, vdi, etc..` para maquinas virtuales.

```bash
dd if=/dev/zero of=disc01.img bs=1k count=500k # crear imagen de 500M
losetup -f  # primer loop disponible
losetup /dev/loop0 disc01.img # montar imagen
losetup -d /dev/loop0 /dev/loop1    # desmontar imagen
losetup -D
locate label | grep bin # identificar comandos label
e2label /dev/sda7 Home # asignar label en particion ext*
```

```bash
mount -o remount,rw /dev/loop0 /mnt/linux  # remontar un sistema de archivos
mount -o ro /dev/loop0 /mnt   # montar en read only
mount /dev/loop0 /mnt/m01 # montar loop0 en /mnt/linux
mount -r -B /mnt/m01 /mnt/linux  # montar directorio /mnt/m01 en /mnt/linux como read-only
```

`fsck` escanea devices



#### Modificaciones

```bash
resize2fs /dev/sda8         # ampliar fs maximo
resize2fs /dev/sda8 1G      # modificar a 1G de tamaño
resize2fs -M /dev/sda8      # reducir el maximo posible
e2fsck -f /dev/sda8         # comprovar errores sistema de ficheros
```



#### Ampliar parición

Para ampliar una partición primero hacemos crecer la partición y despues el sistema de archivos. para modificar la partición tiene que estar desmontada, mpero en cambio para ampliar el sistema de ficheros no es necesario.

Para hacer crecer la partición curiosamente se tiene que borrar, pero antes hay que recordar el sector donde empieza, mirar con `fdisk -l`.

```bash
/dev/sda8         614408192  618602495    4194304     2G 83 Linux
```

- en esta ejemplo la particion empieza en el sector `614408192`

Entonces eliminamos la partición , y creamos una que empieza en el sector indicado y acaba en el tamaño que quieras, siempre que este libre.

Una vez ampliada la partición hay que extender el sistema de archivos con `resize2fs /dev/sda8`.

para finalizar siempre despues de un resize comprovar fs con `e2fsck -f /dev/sda8`



#### Reducir partición

Reducir una partición no se puede hacer en caliente, por lo tanto hay que desmontarla primero.

Primero hay que reducir el sistema de archivos para no perder datos, y según hasta que tamaño se hallan reducido , sera el máximo que podremos reducir la partición.

Reducir la partición a 1G `resize2fs /dev/sda8 1G`

- En el caso de queer reducir el máximo posible `resize2fs -M /dev/sda8`

Comprovar file sistem `e2fsck -f /dev/sda8`

Pasamos a eliminar la partición y crear una nueva de 1G empezando or el primer sector de la borrada con `fdisk`

Ya tenemos nuestra particion redimensionada, solo falta montar.



### Iso 

El formato del sistema de ficheros iso es `iso9660` .

Si queremos explorar el contenido de una iso, montamos la imagen en un loop dispopnible. 

`losetup /dev/loop0 imagen_a_montar.iso`  para después montarla en `/mnt`.

Una vez montada si quieres modificarla se tiene que copiar todo el contenido en otro directorio y crear una nueva imagen.

```bash
cp -ra contenido_imagen destino
# crear nueva imagen
genisoimage -o nueva_imagen.iso directorio
```



### fstab

```bash
device		     mount-point	fs-type	 options		dump	fscheck
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
/dev/sda5 		/               ext4    errors=remount-ro 0       1
```



**Device**

Es el identificador del dispositivo que montar.

- Las diferentes formas de identificar son:

  ```bash
  /dev/sdax	# nombre particion
  UUID=854f5443... 	# Uid completo de particion
  LABEL=sistema	# label de partición 
  /dev/sr0		# cdrom/dvd
  192.168.88.10:/ruta 	# dispositivo de red  nfs
  /mnt/imagen.raw	# imagen en ruta del sistema
  ```

**Mount point**   

Punto de montaje donde se montara el sistema de ficheros.

**Fs-type**

Tipo de sistema de ficheros a montar `ext4, swap, ntfs, msdos, vfat, iso9660, etc...` `auto` intenta reconocer el sistema de ficheros.

**Options** 

Diferentes opciones de montaje de file sistem.

- `default `
  - Englova las siguientes opciones: `rw, suid, dev, exec, auto, nouser, and async `
- `ro, rw`
  - Solo lectura o lectura y escritura.
- `noauto`
  - no se montara automáticamente en el arranque del sistema ni con `mount -a` 
- `user, users`
  - `users` : cualquier usuario puede montar  y desmontar una linea la opción users, indiferentemente quien lo aya montado.
  - `user`: puede montar cualquier usuario, pero solo el usuario que lo monta puede desmontarlo.
- `noexec`
  - no se pueden ejecutar archivos en esa partición.
- `sync async`
  - `async`  utiliza bufers para el uso de tareas en el disco, `sync`  no utiliza bufers y escribe al momento.

**Dump**  

Utilizado por el programa `dump`, sirve para hacer una copia de seguridad. 

- 0 no hace respaldo
- 1 crea el respaldo siempre que tengas `dump` instalado y configurado.

**fscheck** 

Es el orden de chequear los puntos de montaje en el arranque del sistema.

- 0 no se chequea
- 1 se chequea al primero
- 2 el segundo.

En el caso de que hayan 2 discos pueden haber dos opciones 1, ya que al ser discos diferentes se pueden chequear a la vez.





