# 201 Kernel Linux

El kernel Linux es el responsable de la gestión del hardware. El kernel recién incluido en una distribución Linux puede gestionar directamente el conjunto de dispositivos de un sistema sin tener que instalar controladores adicionales. El kernel tiene una estructura modular y solo se cargan en memoria los módulos necesarios para el correcto funcionamiento del sistema.



## 201.1 Componentes del kernel

### Nucleo

Se puede llamar «corazón del kernel» a la parte irreductible del kernel, que es la que se carga en su totalidad en memoria. Solo contiene elementos de los que se está seguro que se necesitarán.

Se puede encontrar en `boot/vmlinuz-*`

Hay dos tipos de kernel comprimidos `zImage y bzImage` . `zImage` tiene un tamaño máximo permitido de 512 Kb mientas que `bzImage` no tiene dicha restricción.

### Módulos

Los módulos tienen un papel primordial ya que muchas de las funciones básicas se gestionan en forma de módulos.

Los módulos son archivos con la extensión `.ko`  y se encuentran en el directorio `/lib/modules/version_del_kernel`

Los modulos tienen **opciones** personalizables que podemos observar con `modinfo -p modulo`  para hacer estas opciones persistentes se crea un archivo de configuración en `/etc/modprobe.d/module-name.conf`

```bash
$ cat /etc/modprobe.d/mdadm.conf
# mdadm module configuration file
options md_mod start_ro=1
```

**Blacklist**

Si un módulo está causando problemas, el archivo `/etc/modprobe.d/blacklist.conf` puede usarse para bloquear la carga del módulo. Por ejemplo, para evitar la carga automática del módulo `nouveau`, la línea `blacklist nouveau` debe agregarse al archivo `/etc/modprobe.d/blacklist.conf`.



**Forzar la carga**

Los modulos se cargan en el arranque en función del hardware detectado. Sin embargo, se puede forzar la carga añadiendo el nombre del moulo en `/etc/modules`

**Configuración** 

El archivo **/etc/modules.conf** permite configurar algunos módulos y especialmente definir asociaciones forzadas entre dispositivos y módulos.

```bash
# Asociación forzada del controlador tg3 con la tarjeta de red 
alias eth0 tg3
```



### Alrededor del kernel

Ya se ha explicado que el kernel se constituye de una entidad indivisible y de módulos cargados en memoria bajo demanda.

Para acelerar la fase de detección del hardware y la carga de módulos asociada, la mayoría de los sistemas modernos usan un ramdisk que contiene el conjunto de módulos. Este ramdisk se genera una vez se ha compilado el kernel y se llama directamente por el gestor de arranque. `/boot/initrd.img*`



### Versiones 

El kernel lleva un número de versión de tipo A.B.C, por ejemplo 4.19.10.

- `A` determina la versión principal del kernel
- `B` representa la versión actual, pares estable e impares desarrollo.
- `C` evoluciones menores del kernel, correcciones y actualizaciones (parche)





## 201.2 Compilación de un kernel

El procedimiento de compilación siempre debe consultarse en el archivo **README** presente con las fuentes del kernel.  Los elementos específicos del kernel están documentados en el directorio **Documentation** proporcionado con las fuentes.

La fuente del kernel se puede descargar de [kernel.org](https://www.kernel.org)  y tiene su propia [documentacion](https://www.kernel.org/doc/html/latest/)

`/usr/src/linux-<version_kernel>` es el directorio donde se guardan las fuentes instaladas  por el sistema.



```bash
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.12.11.tar.xz
tar -xJf linux-5.12.11.tar.xz
cd linux-5.12.11
make defconfig
make
make modules
make modules_install
make install

wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.12.11.tar.xz
tar -xJf linux-5.12.11.tar.xz
cd linux-5.12.11
make defconfig
make
cp arch/x86/boot/bzImage /boot/vmlinuz-5.12.11
make modules
make modules_install
mkinitramfs -o /boot/initrd-5.12.11.img 5.12.11
update-grub

# limpieza antes de reconfigurar
make clean	# Elimina la mayoría de los archivos generados, pero deja lo suficiente para crear módulos externos.
make mrproper	# Elimina la configuración actual y todos los archivos generados.
make distclean 	# Elimina los archivos de copia de seguridad del editor, parchea los archivos sobrantes y similares.
```



### Generar archivo de configuración

La compilación se realiza en función de la información albergada en el archivo **.config** que se encuentra en la raíz del directorio de fuentes. Este archivo  indica para cada elemento del kerner si pertenecerá al nucleo, mododulo o sera excluido.

El archivo `.config` se puede crear de las siguientes maneras:

| make config     | Va realizando preguntas al usuario para cada uno de los módulos. |
| --------------- | ------------------------------------------------------------ |
| make menuconfig | Presenta una interfaz de texto mejorada.                     |
| make xconfig    | Presenta una interfaz gráfica.                               |
| make gconfig    | Presenta una interfaz gráfica.                               |
| make defconfig  | Genera un archivo de configuración basándose en todos los valores de compilación por defecto. |
| make oldconfig  | Genera un archivo de configuración basándose en un archivo .config ya utilizado para una versión más antigua del kernel. |

`/boot/config*` es el archivo donde se encuentra la configuración del kernel instalado en el sistema



### Compilación e intalación

Una vez generado el archivo `.config` la compilación es simple ejecutar `make` en el directorio del kernel descargado.

La ejecución del comando `make`  provoca la compilación del kernel y de sus módulos. También invoca el comando `depmod`, que genera el archivo **modules.dep** de dependencia de módulos.



**Instalación de módulos**

Los módulos se instalan con el comando específico `make modules_install`. Se copian en el directorio `/lib/modules`, en un directorio correspondiente a la versión del kernel.



**Instalación del kernel**

El kernel sin módulos se encuentra en el directorio de fuentes en la ruta relativa `arch/arquitectura/boot` para su instalación simplemente se copia en el directorio boot.

```bash
arch/x86/boot/bzImage	# kernel 32 bits
arch/i64/boot/bzImage	# kernel 64 bis
cp arch/x86/boot/bzImage /boot/vmlinuz-5.12.11
```

**Crear ramdisk**

Un disco ramdisk es una porción de memoria que el kernel ve como si fuera un disco. Puede montarse como cualquier otro disco. El kernel utiliza el ramdisk para cargar todos los módulos en el arranque.

La `initrd` imagen contiene casi todos los módulos del kernel necesarios; muy pocos se compilarán directamente en el kernel. 

```bash
mkinitrd initrd-image kernel-version	# sistemas RPM
mkinitramfs -o nombre_imagen versión 	# derivados Debian

mkinitramfs -o /boot/initrd-5.12.11.img 5.12.11
-d confdir	# directorio de configuracion alternativo
-k 	# conservar el directorio temporal utilizado para crear laimagen
-r	# Anula la "ROOT" configuracion de initramfs.conf
```

> Un sistema reciente solo debería ofrecer el comando mkinitramfs; sin embargo, si mkinitrd también está disponible, no debería usarse. mkinitrd se basa en devfs y no en udev, y no soporta los discos sata.

La configuración de mkinitramfs se realiza a través de un fichero de configuración: `/etc/initramfs-tools/initramfs.conf`. 



### Configuración del gestor de arranque

Ahora solo falta generar una entrada en el gestor de arranque para probar el nuevo kerner. La entrada puede ser similar a esta en GRUB:

`/boot/grub/menu.lst`

```bash
title           PRUEBA - módulos estáticos 
root            (hd0,0) 
kernel          /boot/vmlinuz-5.12.11 root=/dev/hda1 ro quiet 
initrd          /boot/initrd.img-5.12.11
```

O de manera automatizada  `update-grub`



## 201.3 Gestion y resolución de problemas

Para beneficiarse de un kernel reciente, se puede descargar las fuentes completas del núcleo, compilarlas e instalarlas como un kernel nuevo. Un método alternativo consiste en utilizar las fuentes del kernel antiguo y parchearlas antes de recompilarlas.

`patch` es el comando para añadir parches al kernel, estos parches se encuentran en el directorio `scripts` de la fuente del kernel descargada.

```bash
patch -pn < archivo_parche	# aplicar parche
-pn	# Sube n niveles jerárquicos en las rutas de los archivos escritos.
archivo_parche	# El archivo que contiene los parches que se aplicarán.


[root@beta linux-2.6.34]# patch -p1 < patch-2.6.34.4

patch -pn -R < archivo_parche # retirar parche
```



### Herramientas

```bash
lsmod	# muestra moddulos cargados en el sistema /proc/modules
modinfo	# aplia informacion del modulo
insmod	# carga un fichero .ko en el sistema
rmmod 	# quita un modulo
	-w	# espera a que deje de utilizarse
	-f	# fuerza el borrado

# actualizacion de los anteriores
modprobe # carga y resuelve dependencias
	-f 	# fuerza la carga del modulo aun que no sea la version correspondiente.
	-r  # elimina modulo
	-v 	# muestra información adicional de lo que realiza
	-n 	# hace una simulación
	-C  # mostrar configuración completa de modulo
	-l 	# listar
```



`depmod`  crea el `/lib/modules/kernel-version/modules.dep` archivo contiene una lista de dependencias de módulos. Que este archivo es usado por `modprobe` para gestionar las dependencias.

```bash
debmod -a
```

`kerneld` y  `kmod` ambos facilitan la carga dinámica de módulos del kernel. Ambos se utilizan `modprobe`para gestionar dependencias y carga dinámica de módulos.



`strace` muestra el seguimiemiento de llamadas al sistema. Es decir  muestra todo el procedimiento que realiza un comando para ejecutarse.

```bash
strace cat /dev/null
-o file # output en archivo indicado
-p pid 	# conectarse a un proceso en ejecucion
```



`ltrace`   Inspecciona las llamadas a bibliotecas en tiempo de ejecución en programas enlazados dinámicamente

`sysctl`  se utiliza para modificar los parámetros del kernel en tiempo de ejecución. Los parámetros disponibles son los que se enumeran a continuación `/proc/sys/`. El archivo de configuración generalmente se puede encontrar en `/etc/sysctl.conf`.

`udevadm monitor`  imprimirá los `udev`uevents del kernel a la salida estándar. Puede usarlo para analizar la sincronización de eventos comparando las marcas de tiempo del `udev`evento del kernel y el evento. 
