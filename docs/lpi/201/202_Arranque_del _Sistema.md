# 202 Arranque del  Sistema



## 202.1 Customizar SysV-init

Hay siete fases que se distinguen durante el arranque:

1. Carga, configuración y ejecución del cargador de kernel
2. Configuración de registro
3. Descompresión de kernel
4. Inicialización de kernel y memoria
5. Configuración del kernel
6. Habilitación de CPU restantes
7. Inicia la creación del proceso



### Configuración del proceso init

Si se miran los procesos en ejecución en el sistema, el proceso init se encuentra en primera posición. Tiene un PPID bastante particular (0) y es el padre de bastantes otros procesos.

```bash
➜  ps -ef | head 
UID        PID  PPID  C STIME TTY          TIME CMD
root         1     0  0 jun20 ?        00:00:12 /sbin/init
root         2     0  0 jun20 ?        00:00:00 [kthreadd]
...
```



#### SysVinit

**/etc/inittab** tiene contenidos muy distintos, pero su estructura es siempre la misma.

```bash
identificador:nivel:modo_acción:comando 
```

- `identificador`: Cadena alfanumerica de 1 a 4 caracteres
- `nivel`: nivel donde se realizara dicha acción
- `modo_acción`: Define como se ejecutará el cuarto campo
  - `initdefault` solo sirve para definir el nivel de ejecución por defecto del sistema.
  - `sysinit` sirve para ejecutar scripts en la inicialización del sistema, independientemente del nivel de ejecución. (campo dos vacio)
  - `wait`  ejecuta el comando y espera el final de esta ejecución para pasar a las siguientes líneas del archivo inittab.
  - `respawn` ejecuta el comando del cuarto campo y deja el proceso ejecutándose en segundo plano. 
- `comando`: el mcomando que se ejecutará



**Directorios de los niveles.**

- Se definen niveles de ejecución y qué se hará en cada uno de ellos en el directorio `/etc/rcN.d`  `N` es el número de ejecución. Este directorio esta formado por  difrentes archivos de dominios los cuales muchos son enlaces a `/etc/init.d` que es donde se encuentran los dominios.
- **rc** ejecuta los ficheros que hay en el directorio `/etc/rcN.d/` por orden numérico (siendo **N** el nivel de ejecución). Estos ficheros serán enlaces que empiezan por **S** o **K** y que apuntan a script que están en `/etc/init.d/`
- Si el enlace empieza por **S, rc** le pasará el comando **start** y si empieza por **K** le pasará **stop**

 

comandos

```bash
runlevel	# indica el nivel de ejecucion actual
init o telinit	# cambia de un nivel de ejecución a otro
update-rc.d		# establece los script que se inician en cada nivel.

# sintaxis: update-rc.d  script enable/disable  level/s (derivados Debian)
update-rc.d  mi-servicio enable 2

telinit 
  1, s, S   # Entrar modo rescate
  q, Q      # recargar configuración del demonio /etc/inttab 
  u, U      # reejecutar el demonio
  
chkconfig
--add service	# crear enlaces simbolicos de /etc/rcN.d/
--del service
--list [service]	# ver estado de servicios en cada runlevel
--level 45 postfix on	# havilitar postfix en runlevel 4 y 5
--level 45 postfix off
```



Una vez que todos los scripts relacionados con el nivel de ejecución se han ejecutado, también lo hace el script **/etc/rc.local** 



#### Systemd

- Se ejecuta un único programa que utilizará ficheros de configuración para cada servicio a gestionar
- utiliza **unidades** que pueden ser de diversos tipos: automont, devices, mount, path, service, snapshot, socket y target.
- Los services se agrupan en target, donde también podemos definir el orden  de ejecución y las dependencias con otros target o services. Son los  equivalentes a los runlevels en SysVinit
- Cada unidad se define en un fichero con el nombre de dicha unidad y en la extensión se indica el tipo de unidad, por ejemplo **ssh.service** 
- Estos ficheros pueden estar en distintos directorios como: `/usr/lib/systemd/system/`, `/lib/systemd/system/` o `/etc/systemd/system/`

| unidad    | descripcion                                                  |
| --------- | ------------------------------------------------------------ |
| service   | El tipo de unidad más común, para recursos activos del sistema que se pueden iniciar, interrumpir y recargar. |
| socket    | El tipo de unidad de socket puede ser un socket de sistema de archivos o  un socket de red. Todas las unidades de socket tienen una unidad de   servicio correspondiente, cargada cuando el socket recibe una solicitud. |
| device    | Una unidad de dispositivo está asociada con un dispositivo de hardware identificado por el núcleo. |
| mount     | Una unidad de montaje es una definición de punto de montaje en el sistema de archivos, similar a una entrada en `/etc/fstab`. |
| automount | Una unidad de montaje automático también es una definición de punto de   montaje en el sistema de archivos, pero se monta automáticamente. |
| target    | Una unidad target es una agrupación de otras unidades, administradas como una sola unidad. |
| snapshot  | Una unidad snapshot es un estado guardado del administrador del sistema (no disponible en todas las distribuciones de Linux). |

comandos

**systemctl**: gestiona la gran mayoría de aspectos en systemd

- **get-default**: indica el target por defecto
- **start/stop/status**/etc..  unit[.service]: `systemctl restart apache2`
- **isolate** unit.target : cambia al target seleccionado
- **list-units** [--type=service] : lista las unidades cargadas
- **enable/disable**: activa o desactiva una unidad
- **cat** muestra el fichero de la unidad
- **list-dependencies**: muestra un árbol de dependencias de una unidad

 

```bash
# ver nivel de ejecución por defecto
systemctl get-default

# asignar nivel por defecto
systemctl set-default graphical.target

# gestion de servicios
systemctl start/stop/status/enable/disable ssh.service

# visualizar archivo de servicio
systemctl cat ssh.service

# cambiar de nivel de ejecucion
systemctl isolate rescue.target/multi-user.target/graphical.target

# listar dependencias
systemctl list-dependencies
systemctl list-dependencies ssh.service

# listar units
systemctl list-units --type=service
systemctl list-unit-files

 # analizar los tiempos de arranque
 systemd-analyce blame
 
 systemd-delta	#  obtener una descripción general de todas las anulaciones activas, 
```

 

## 202.2 Recuperación del sistema



### Gestor de arranque Grub

El gestor de arranque es un pequeño programa que se encuentra generalmente en el MBR (Master Boot Record) y cuya función es la de provocar la carga del kernel. Para ello hay que conocer la ubicación del archivo del kernel (incluyendo su partición) y la partición que se montará en `/`, la raíz del sistema de archivos.



#### GRUB 1

Su fichero de configuración es `/boot/grub/menu.lst`  o `/boot/grub/grub.cfg`. Grub1 Admite BIOS pero no UEFI

**GRUB** numera las unidades y las  particiones de forma especial.El primer disco será (hd0) y la primera  partición (hd0,0), después 1 y así consecutivamente.

Opciones del menu de configuración:

- `default` S.O. por defecto que arrancará
- `timeout` segundos que espera la elección del usuario

Las entradas de cada Sistema Operativo tienen:

```bash
title título 
root partición_kernel 
kernel /ruta/kernel ro root=partición_raíz opciones 
initrd /ruta/imagen_módulos 

 
title      Ubuntu 9.10, kernel 2.6.31-16-generic 
kernel     /boot/vmlinuz-2.6.31-16-generic root=UUID=52200c0b-aee8-4ae0-9492-1f488051e4a3 ro quiet splash 
initrd      /boot/initrd.img-2.6.31-16-generic  quiet
```



#### GRUB 2

Utiliza el archivo de configuración `/boot/grub/grub.cfg` este archivo no se debe modificar. El archivo `grub.cfg` se genera mediante el comando `update-grub o grub-mkconfig`. estos comandos se basan en scripts preinstalados en `/etc/grub.d` .

Las opciones modificables por el usuario se almacenan en `/etc/default/grub`

Hereda la nomenclatura de GRUP, pero las particiones empiezan en 1 ( `hd0,1`)

Las opciones se personalizan en `/etc/default/grub`

- `GRUB_DEFAULT=` define la entrada predeterminada siendo `0` la primera
- `GRUB_SAVEDEFAULT=` si es `true` y `GRUB_DEFAULT` es `saved` , la ultima opción seleccionada será la predeterminada.
- `GRUB_TIMEOUT=` tiemp de espera, anes del inicio automático, `-1` indefinido, `0` automatico, `1 - N` tiempo de espera.
- `GRUB_CMDLINE_LINUX=` opciones que se agregan a la  linea de kernel
- `GRUB_ENABLE_CRYPTODISK=`  si es `y` las comandos de instalación y configuración de grub buscarán particiones encriptadas.

Si se quiere añadir entradas personalizadas se deben agregar en `/etc/grub.d/40_custom`, un ejemplo de entrada básico es el siguiente:

```bash
menuentry "Default OS" {
    set root=(hd0,1)
    linux /vmlinuz root=/dev/sda1 ro quiet splash
    initrd /initrd.img
}
```

En el ejemplo se muestra la ruta a la partición por el nombre, es buena practica utilizar el UUID con `search --set=root --fs-uuid ae71b214-0aec-48e8-80b2-090b6986b625 --no-floppy`



#### Arranque desde consola grub

El arranque desde consola, es practicamente el mismo que en un menuentry

```bash
grub> ls
(proc) (hd0) (hd0,msdos1)

grub> set root=(hd0,msdos1)
grub> linux /vmlinuz root=/dev/sda1
grub> initrd /initrd.img
grub> boot

# otra opción indicar el archivo de configuración de grub
grub> configfile (hd0,msdos1)/boot/grub2/grub.cfg
```

**grub rescue** es muy similar al anterior.  Sin embargo, deberá cargar algunos módulos GRUB 2 para que todo funcione.

```bash
grub rescue> set prefix=(hd0,msdos1)/boot/grub
grub rescue> insmod normal
grub rescue> insmod linux

grub rescue> set root=(hd0,msdos1)
grub rescue> linux /vmlinuz root=/dev/sda1
grub rescue> initrd /initrd.img
grub rescue> boot
```

 

#### Reinstalación de Grub

El comando `grub-install` reinstala GRUB en un sistema con mucha facilidad. En cambio, este método no siempre es eficaz y funciona perfectamente en caliente.

```bash
grub-install --root-directory=dir_kernel disco_destino # Grub 1
grub-install dispositivo # Grub 2
```





## 202.3 Sistemas de arranque alternativos

Aparte de GRUB, existen otras formas de cargar un núcleo Linux. Los principales son:

- LILO: antiguo programa de Linux de carga del núcleo.
- ISOLINUX: para cargar Linux desde un CD/DVD o una llave USB.
- PXE: para cargar un nuevo sistema operativo desde un servidor de red.



### LILO

LILO (LInux LOader) es el programa original de carga del núcleo Linux. Hace tiempo era el cargador por defecto de las diferentes distribuciones, antes de ser sustituido progresivamente por GRUB

La configuración de lilo se encuentra en `/etc/lilo.conf` . Se encuentran opciones como disco de arranque, tiempo antes del arranque, posible contraseña, ...

Cada vez que se modifica el archivo de configuración se iene que ejecutar `/sbin/lilo` que modifica el cargador real enel sector de arranque del disco.



### Isolinux

ISOLINUX se utiliza para crear CD/DVD de arranque, en el formato estándar ISO9660.

Forma parte del paquete **syslinux**, que es un conjunto de componentes que gestionan métodos de carga del núcleo alternativos (CD/DVD, PXE, etc.).

La idea es preparar en un directorio los diferentes archivos que se han de almacenar en la imagen ISO de arranque, y a continuación generar esta imagen mediante el comando **mkisofs**. El archivo resultante se puede grabar en un CD/DVD.

> Lo más sencillo es partir de una imagen ISO de arranque que ya exista (un CD de instalación Linux por ejemplo), montarlo en el sistema de archivos. A continuación, modificar su contenido en función de nuestras necesidades y generar la nueva imagen con el comando **mkisofs**.



### PXE

PXE (Pre-boot eXecution Environment) es un protocolo de arranque de un sistema a través de la red. Para poder utilizarlo, la tarjeta de red tiene que ser compatible con este protocolo (la mayoría de las tarjetas modernas lo son) y que se active esta funcionalidad en la BIOS del equipo.

Este método de arranque necesita un servicio DHCP y un servicio TFTP (Trivial File Transfer Protocol) activos en la red y configurados para la descarga remota de un núcleo Linux.

