# 206 Mantenimiento del sistema

## 206.1 Compilar e instalar programas desde el código fuente

En el mundo open source el código fuente de todos los programas está disponible y puede ser frecuente que el usuario final tenga que compilar él mismo su aplicación. De este modo, se ha definido un procedimiento de compilación estándar para que cualquier usuario pueda realizar esta operación.

Preferiblemente las fuentes se extraen y compilan en `/usr/src`, pero no es obligatorio.

### Configuración de la compilación

La compilación tiene una serie de requisitos: 

- la existencia del compilador
- la posible presencia de librerías necesarias para compilar el programa
- un archivo de respuesta que será leído por el compilador en la compilación.

En el procedimiento estándar de compilación GNU, debe haber un script llamado **configure** en el directorio raíz que se encarga de realizar estas tres opciones.

Al mejecutar el archivo `configure` con sus opciones correspondientes, en caso de exito este generará archivos `makefile` (uno por cada subdirectorio del directorio de fuentes).

Estos archivos se crean a partir de las opciones pasadas a `configure`más las opciones por defecto de `makefile.in` 

Las opciones de configure se encontrarán siempre en `./configure --help`

### Compilación

La compilación se realiza simplemente con el comando **make**, sin parámetros ni opciones desde el directorio raíz de las fuentes donde se encuentran los archivos **Makefile** y **Makefile.in**.

Si todo va bien, en la generación de archivos binarios compilados.

El comando **make install** desencadena la instalación de archivos binarios compilados en sus directorios de destino en el interior de la estructura de carpetas del sistema de archivos Linux.

### limpieza

```bash
make clean	# elimina todos los archivos binarios compilados
make mrproper	# limpieza completa de cualquier elemento generado localmente,(binarios y makefiles)
make uninstall	# limpia el sistema de todos los archivos instalados por el comando make install.
```

### Resumen

```bash
## Instalación ##

#descargar código fuente
cd raiz del directorio
./configure (con opciones si precisa)	# generar configuracion
make			# crear binarios
make install	# instalar en el sistema

## desinstalación ##

make uninstall
make clean
make mrproper
```





## 206.2 Operaciones de Backup

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





**rsync** es una utilidad para copiar / sincronizar archivos de una ubicación a otra mientras se mantiene bajo el ancho de banda requerido. 

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



**dd**  el comando de copia bloque a bloque permite realizar copias de bajo nivel de un periférico.

```bash
dd if=entrada of=salida bs=tamaño_del_bloque count=número_de_bloques 

if=origen
of=destino
bs 	# tamaño del bloque a copiar
count	# cantidad de bloques a copiar

dd if=/dev/sdb1 of=/home/alumno/usb.img
dd if=/dev/zero of=fichero bs=1024 count=100000 # archivo 100M
```



## 206.3 Notificar problemas del sistema



Se pueden enviar mensajes cortos con los comandos **write** y **wall**. El comando **write** permite enviar un mensaje a un usuario conectado, mientras que **wall** (write all) difunde el mensaje a todos los usuarios conectados.

```bash
write user
(introducir el mensaje terminándolo con Ctrl-D) 
write < archivo_mensaje 

wall 
(introducir el mensaje terminándolo con Ctrl-D) 
wall < archivo_mensaje 
```



`Issue` e `issue.net` son archivos que su contenido se mostrara en la autentificación

```bash
/etc/issue 		# se muestra antes de la solicitud de identificación local 
/etc/issue.net	# se muestra antes de la autentificación de un usuario que se conecte por telnet.
```



El contenido del archivo **/etc/motd** (Message Of The Day) se visualiza después de la apertura de una sesión con éxito.

