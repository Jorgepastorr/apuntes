# 102 Instalación de Linux y gestión de paquetes



## Particionado del disco

En Linux se suele particionar algunos directorios del sistema, por seguridad o por funcionalidad de algunas tareas, como por ejemplo backups, redimensionamiento de discos, etc...

Los directorios más habituales a separar en diferentes particiones son `/, /boot, /home, /var`

### Swap

El funcionamiento de la partición swap consiste en impedir que el ordenador se bloquee facilitando un espacio extra  a la ram. 

Una vez la ram se queda sin espacio o está prácticamente llena   utiliza el swap una partición del disco dedicada para insertar los  procesos que cree ella menos importantes y en desuso.

El tamaño de la partición de swap depende mucho del administrador de sistemas y del tipo de equipo.

Que hay que tener en cuenta:

- Si el equipo  va a hibernar
- cantidad de ram que dispone el equipo

Por lo general poner más de 4 GB de Swap no es rentable, pero si el equipo va a hivernar y es un equipo con mucha RAM igual puede ser factible. 

La norma general es poner la mitad de GB que RAM tiene tu sistema, aún que es cierto que leer más de 2-4 GB de  datos en disco destinados a RAM tarda una barvaridad.



### Directorios

Los directorios de inux siguen el estandar de jerarquía del sistema de archivos ( o FHS Filesistem Hierarchy Standard )

| Directorio | Descripción Simple                                           |
| ---------- | ------------------------------------------------------------ |
| /          | la raíz o root, o contenedor de todo el sistema de jerarquía. |
| /bin/      | Aplicaciones binarias                                        |
| /boot/     | Archivos cargadores de arranque                              |
| /dev/      | Contiene archivos especiales asociados a dispositivos hardware. |
| /etc/      | Contiene archivos de configuración del sistema               |
| /home/     | Contiene los directorios de trabajo de los usuarios          |
| /lib/      | Contiene todas las bibliotecas                               |
| /media/    | Contiene los puntos de montaje de los medios extraíbles      |
| /mnt/      | Sistema de archivos montados temporalmente.                  |
| /opt/      | Contiene Paquetes de programas opcionales de aplicaciones    |
| /proc/     | sistema de archivos virtuales que documentan al núcleo       |
| /root/     | Directorio raíz del usuario root.                            |
| /sbin/     | Sistema de binarios esencial, comandos y programas           |
| /srv/      | Lugar específico de datos que son servidos por el sistema.   |
| /sys/      | Evolución de proc. Sistema de archivos virtuales que documentan al núcleo pero de forma jerarquizada. |
| /tmp/      | Archivos temporales                                          |
| /usr/      | Jerarquía secundaria de los datos de usuario; contiene la mayoría de las utilidades y aplicaciones multiusuario |
| /var/      | Archivos variables, tales como logs, archivos spool, bases de datos, archivos de e-mail temporales, y algunos archivos temporales en general. |
| /run/      | Datos variables en tiempo de ejecución.                      |



**Directorios separables**

- **/boot**: se tiene que separar si usamos LVM.Ext (250MB)
- **/boot/efi**: Particion ESP para UEFI. FAT (150MB)
- sistemas multiusuario
  - **/var**
  - **/home**
- **/usr**: Si se van a instalar muchos programas que no son parte del sistema

|              | compartibles                | no compartible       |
| ------------ | --------------------------- | -------------------- |
| **static**   | /usr  /opt                  | /etc  /boot          |
| **variable** | /var/mail   /var/spool/news | /var/run   /var/lock |

### LVM

Es un administrador de volúmenes lógicos, gracias a sus vgrupos y volúmenes lógicos tiene la caracteristica de poder crear una partición entre varios discos físicos. Esto es muy util a la hora de aumentar una partición cuando te has quedado sin espacio en un disco físico.

Caracteristicas:

- La unidad básica es el *Physical Volume* (PV), que es un dispositivo de bloque en su sistema como una partición de disco o un arreglo RAID.
- Los PV se agrupan en *Grupos de volúmenes* (VG) que abstraen los  dispositivos subyacentes y se ven como un único dispositivo lógico, con  la capacidad de almacenamiento combinada de los componentes del PV.
- Los grupos de volúmenes se pueden subdividir en volúmenes lógicos (LV),  que funcionan de forma similar a las particiones pero con más  flexibilidad.
- Después de crear un volumen lógico, el sistema operativo lo ve como un  dispositivo de bloque normal. Se creará un dispositivo en `/dev`, nombrado como `/dev/VGNAME/LVNAME`



## Gestores de arranque

LA BIOS/UEFI  pasan el control al gestor de arranque que será el programa responsable de cargar el sistema operativo.

- LILO: Linux Loader es un cargador que ya esta en desuso
- **GRUB** (legacy): el sustituto de LILO, pero también ya casi desaparecido por su sucesor GRUB2
  - Admite BIOS pero no UEFI
  - fichero de configuración `/boot/grub/menu.lst`  o `/boot/grub/grub.cfg`

**GRUB** numera las unidades y las particiones de forma especial.El primer disco será (hd0) y la primera partición (hd0,0), después 1 y así consecutivamente.

Opciones del menu de configuración:

- default: S.O. por defecto que arrancará
- timeout: segundos que espera la elección del usuario

Las entradas de cada Sistema Operativo tienen:

- title: nombre que aparece en el menú
- root: Indica con su nomenclatura, la partición que contiene el sistema operativo. Ejemplo: `root (hd1,2)`
- kernel: Ruta del fichero del kernel y opciones de arranque
- initrm: Ruta del disco RAM, con opciones y controladores para poder arrancar.

Para sistemas operativos que no son Linux:

- rootverify: Partición del S.O.
- chainloader: Para pasar el control a otro cargador de arranque. +1 significa que lee el primer sector de la partición indicada por rootrnoverify.



### GRUB2

El actual gestor de arranque en casi todas las distribuciones. Es muy versatil, puede cargar módulos según las necesidades del sistema.

- Hereda la nomenclatura de GRUP, pero las particiones empiezan en 1
- Ficheros de configuración: `/boot/grub/grub.cfg` , `/boot/grub2/grub.cfg` , `/etc/grub.d` y`/etc/default/grub` 
- Las entradas de los S.O. empiezan por la palabra reservada **menuentry** seguida  del título y el resto de opciones van dentro de llaves
- otras diferencias:
  - set root = (hd0,1)
  - **rootnoverify** se sustituye por **root**

El menú de configuración no  se deve  modificar manualmente. Las opciones se personalizan en `/etc/default/grub`

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

#### Instalación

Para crear el `/boot/grub/grub.cfg` se ejecuta `update-grub` o `grub-mkconfig -o /boot/grub/grub.cfg`

Para instalar grub2: `grub-install` en el caso de estar en el sistema. Si hemos iniciado con una LiveCD o desde otro sistema.

```bash
# identificar particiones
sudo fdisk -l /dev/sda

# montar la partición donde instalar 
sudo mkdir /mnt/tmp
sudo mount /dev/sda1 /mnt/tmp

# Si su sistema tiene una partición de arranque dedicada, el comando es:
sudo grub-install --boot-directory=/mnt/tmp /dev/sda

# Si está instalando en un sistema que no tiene una partición de arranque
sudo grub-install --boot-directory=/boot /dev/sda
```



#### arranque consola grub

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





### Opciones del kernel

- quiet: evita que se muestren todos los mensajes al arrancar
- debug: parecen mensajes de depuración
- init: indica el programa que se ejecutará al arrancar, en lugar de `/sbin/init`. Ejemplo `init=/bin/bash`
- single: se ejecuta en modo monousuario
- ro o rw: se monta en solo lectura o en lectura/escritura
- mem=size: fuerza a usar una cantidad determinada de ROM. Ejemplo `mem=1024M`

Existen muchas mas opciones, estas son las mas básicas y utilizadas.



### Contenido de la partición de arranque

El contenido de la partición `/boot` puede variar con la  arquitectura del sistema o el cargador de arranque en uso, pero en un  sistema basado en x86, generalmente encontrará los archivos a  continuación. 

**Archivo de configuración** Este archivo, generalmente llamado `config-VERSION` (vea el  ejemplo anterior), almacena los parámetros de configuración para el  núcleo de Linux.

**Mapa del sistema** Este archivo es una tabla de búsqueda que combina nombres de símbolos  (como variables o funciones) con su posición correspondiente en la  memoria. Es útil para depurar un falo de *kernel panic*, permite saber que función se estaba llamando. `System.map-4.15.0-65-generic`

**kernel linux** Este es el núcleo del sistema operativo propiamente dicho. `vmlinux-VERSION` o `vmlinuz` si a sido comprimido

**Disco RAM inicial** Esto generalmente se llama `initrd.img-VERSION` y contiene un sistema de archivos raíz mínimo, contiene utilidades y módulos del núcleo necesarios para que el núcleo pueda montar el sistema de archivos raíz real.

**Archivos relacionados con el cargador de arranque** 

En los sistemas con GRUB instalado, estos generalmente se encuentran en `/boot/grub` e incluyen:

- archivo de configuración `/boot/grub/grub.cfg` o `menu.lst`

- módulos `/boot/grub/i386-pc` 
- archivos de traducción `/boot/grub/locale`
- fuentes `/boot/grub/fonts`



## Gestión de librerias compartidas

Casi todo el software comparte funcionalidades como acceder a disco, mostrar botones, usar formularios, etc.  En lugar de que todos incluyan el código de las mismas operaciones, utilizan ficheros que las ponen a disposición del sistema. Se llaman librerías compartidas. 

**libreria estatica**  Una biblioteca estática se fusiona con el programa en el momento del  enlace. Una copia del código de la biblioteca se incrusta en el programa y se convierte en parte de él. Por lo tanto, el programa no tiene  dependencias de la biblioteca en tiempo de ejecución porque el programa  ya contiene el código de la biblioteca

**libreria dinamica** En el caso de las bibliotecas compartidas, el enlazador simplemente se  encarga de que el programa haga referencia a las bibliotecas  correctamente. Sin embargo, el vinculador no copia ningún código de  biblioteca en el archivo del programa. Sin embargo, en tiempo de ejecución, la biblioteca compartida debe estar  disponible para satisfacer las dependencias del programa.



El sistema las buscará en: 

- `/lib/ , /usr/lib/, /usr/local/lib`  (o su equivalente en 64bit) 
- Los directorios indicados en `/etc/ld.so.conf `
- Los directorios guardados en la variable **LD_LIBRARY_PATH** ( se suele usar para cambios temporales o librerías muy específicas. Tienen mayor preferencia que el resto)



**/etc/ld.so.conf** 

Suele importar con "include" todos los ficheros de `/etc/ld.so.conf.d/*.conf`, así se pueden incorporar directorios de forma más modular. 

Si modificamos alguno de esos ficheros tendremos que ejecutar la orden `ldconfig` para que los cambios tengan efecto. Esto genera  una caché de directorios y ficheros compartidos. 

El comando `ldd` nos muestra las librerías que necesita un programa del sistema. 

```bash
➜  ~ ldd /usr/lib/firefox-esr/firefox-esr
	linux-vdso.so.1 (0x00007ffe857fd000)
	libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007f9704de8000)
	libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f9704de3000)
	libstdc++.so.6 => /usr/lib/x86_64-linux-gnu/libstdc++.so.6 (0x00007f9704c5f000)
	libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007f9704c45000)
	libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f9704a84000)
	/lib64/ld-linux-x86-64.so.2 (0x00007f9704edc000)
	libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f9704901000)
```



Los ficheros de las librerías indican la versión y tienen extensión `.so` (shared object). Es frecuente que se creen enlaces entre versiones compatibles

```bash
lrwxrwxrwx   1 root root   14 ago  1  2018 libogdi.so.3 -> libogdi.so.3.2
-rw-r--r--   1 root root 135K ago  1  2018 libogdi.so.3.2
```



## Gestión de paquetes 

### Derivados debian

#### Dpkg

**Dpkg** administra los paquetes de nuestro sistema sin usar reposiorios, es quiere decir que no resuelve dependencias.

opciones mas inportantes:

```bash
dpkg -i htop_2.2.0-1_amd64.deb	# instala un paquete
dpkg -r htop	# borra el paquete dejando los ficheros de configuración
dpkg -P htop	# borra el paquete incluyendo los ficheros de configuración

dpkg -s htop	# muestra información y el estado de un paquete instalado
dpkg -I htop_2.2.0-1_amd64.deb # muestra información de un paquete antes de instalarlo
dpgk -l htop* 	# lista todos los paquetes que coincidan con un patron determinado
dpkg -L htop	# Muestra todos los ficheros que ha instalado un paquete
dpkg -S htop*	# Muestra los paquetes que contienen ficheros que coincidan con el patron indicado
```



**Dpkg-reconfigure** Se utiliza para reconfigurar un paquete instalado en el sistema. Si un paquete se a instalado mal o nos hemos equivocado en algún parametro a introducir, en vez de eliminar el paquete e instalarlo de nuevo, utilizamos por Ejemplo`dpkg-reconfigure nslcd` 



#### Apt

Apt es la actualización de `dpkg` resolviendo algunas decadencias, como por ejemplo añadir repositorios al instalador y así resolver dependencias automaticamente, o no tener que descargar paquetes manualmente.

Los **repositorios**  guardan su configuración en `/etc/apt/sources.list` y `/etc/apt/sources.list.d/`  dentro encontramos direcciones (mirror) de donde descargar paquetes.

Opciones:

- `deb`: dirección de donde descargar paquetes
- `deb-src`: dirección de donde descargar el código fuente
- `buster`: versión de la distribución
- `main`: paqueteria full open source
- `contrib`: paqueteria open-source con dependencias que pueden no ser open
- `non-free`: paqueteria no open-source

```bash
➜  ~ cat /etc/apt/sources.list
deb http://ftp.es.debian.org/debian/ buster main contrib non-free
deb-src http://ftp.es.debian.org/debian/ buster main contrib non-free
```

Cada vez que se modifica, añade o retira algún repositorio se tiene que actualizar con `apt-update`

```bash
apt update			# actualizar repositorio
apt search paquete	# buscar paquete en los repositorios
apt install paquete
apt remove paquete
apt purge paquete	# elimina los paquetes de configuracioón

apt show paquete
apt depends paquete
apt list paquete	# lista versiones de un paquete
```



#### Aptitude

Aptitude es una mejora de `apt` , funciona de manera similar, con la ventaja de dar en ocasiones mas información. Ademas si se ejecuta sin ningún parametro `aptitude` abre una ventana de texto donde gestionar facilmente los paquetes.

```bash
aptitude search paquete
	c	# existen paquetes de configuración
	p	# no esta instalado
	i	# instalado
```



### Derivados Red Had

#### RPM 

administra la paqueteria de Red Had y deribados como, Centos, Fedora, etc...

```bash
rpm -i paquete.rpm  # instala paquete
rpm -U paquete.rpm  # actualizar paquete y si no esta lo instala
rpm -F paquete.rpm	# actualiza un paquete sólo si esta instalado

# -vh permiten visualizar vel progreso en las opciones anteriores.
rpm -ih tftp-server-5.2-18.fc24.x86_64.rpm	# indica progreso de la operacion
rpm -iv tftp-server-5.2-18.fc24.x86_64.rpm	# muestra progreso por cada paquete

rpm -e paquete	  	# eliminar paquete
rpm -V paquete  	# verifica un paquete, muestra si esta instralado o modificado
rpm --rebuilddb     # actualizar base de datos rpm
```

consultas sobre paquetes

```bash
rpm -qa             # todos paquetes instalados
rpm -ql paquete     # ver contenido del paquete instalado
rpm -qlp paquete.rpm    # ver contenido de paquete sin instalar
rpm -qd paquete     # ver paquetes de documentación
rpm -qc paquete     # ver paquetes de configuración
rpm -qi paquete     # información del paquete
rpm -qp --requires paquete.rpm  # ver dependencias del paquete
rpm -qpR paquete.rpm	# ver dependencias del paquete
rpm -qp --scripts paquete.rpm   # ver scripts pre y post intalación
rpm -qf /usr/bin/useradd    # ver a que paquete pertenece un archivo
```



En el caso de querer ver el contenido de un paquete rpm con **rpm2cpio** se puede extraer los ficheros para así visualizarlos.

rpm2cio transforma un fichero rpm en formato cpio y lo muestra por salida estandar

```bash
rpm2cpio htop-2.2.0-1.fc27.x86_64.rpm > htop.cpio
```

Con el fichero `.cpio` podemos extraer el contenido  del paquete.

Es recomendable hacerlo en un directorio vacío para que no se mezcle con otro tipo de contenido.

```bash
cpio -i --make-directories < htop.cpio
```



#### Yum

Yum utiliza repositorios que se configuran en ficheros dentro del directorio `/etc/yum.repos.d/` 

Ejemplo de fichero `CentOS-Base.repo`

```bash
[base]
name=CentOS-$releasever - Base
mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os&infra=$infra
#baseurl=http://mirror.centos.org/centos/$releasever/os/$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
```

Las opciones de yum son muy parecidas a apt algunas de ellas son las siguientes.

```bash
yum update
yum search paquete
yum info paquete
yum install paquete
yum remove paquete

yum check-update	# comprueba actualizaciones de los paquetes que estan instalados
yum upgrade paquete	# actualiza la versión si esta disponible
yum clean	# limpia el directorio cache
yum makecache # generar base de datos cache

yum list [all|available|updates|installed|obsoletes|recent]

yum repolist [enabled|disabled|all]	# muestra los repositorios
yum-config-manager --disabled repo_id   # desabilitar repositorio
yum-config-manager --enabled repo_id    # habilitar reppositorio

yum-config-manager --add-repo https://rpms.remirepo.net/enterprise/remi.repo
```

En distribuciones como fedora y suse han actualizado su gestor de paquetes a `dnf` en Fedora y `zipper` en Suse, las opciones son practicamente las mismas, lo unico que estas actualizaciones son mas optimas y gestionan mejor los recursos.



#### dnf

Fedora desarrollo la evolución de YUM para gestionar su paqueteria, la cual es muy similar a YUM en parametros

```bash
dnf search PATTERN	# busca coincidencias en repositorios
dnf info paquete
dnf install paquete
dnf remove paquete
dnf upgrade paquete
dnf provides comand/filename	# a que paquete pertenece el archivo o comando
dnf list --installed
dnf repoquery -l paquete # ver contenido paquete

dnf repolist
dnf config-manager --add-repo URL
dnf config-manager --set-enabled REPO_ID
dnf config-manager --set-disabled REPO_ID
```



#### zipper

Igual que Fedora desarroyo dnf, Suse desarroyo zypper basado en YUM son todos muy similares.

```bash
zypper refresh	# actualizar
zypper search paquete
zypper search -i paquete # buscar solo paquetes instalados
zypper search -u paquete # buscar solo paquetes no instalados
zypper install paquete
zypper remove paquete
zypper search --provides comand/file
zypper info paquete

zypper repos
zypper modifyrepo -d alias-repo	# desabilitar repositorio
zypper modifyrepo -e alias-repo # habilitar repositorio
zypper modifyrepo -f alias-repo	# autorefresh
zypper modifyrepo -F alias-repo	# disable autorefresh

zypper addrepo http://packman.inode.at/suse/openSUSE_Leap_15.1/ packman
zypper removerepo packman
```



## Linux como sistema virtualizado

La virtualización es una tecnología que permite que una plataforma de software, llamada hipervisor (*hypervisor*), ejecute procesos que contienen un sistema informático completamente  emulado. El hipervisor es responsable de administrar los recursos del  hardware físico que pueden ser utilizados por máquinas virtuales  individuales. Estas máquinas virtuales se denominan *guests* del hipervisor.

Los hipervisores de uso común en Linux son:

**Xen** es un hipervisor de código abierto de tipo 1, lo que significa que  no depende de un sistema operativo subyacente para funcionar.  Se conoce como un hipervisor de *bare-metal hypervisor*, ya que la computadora puede arrancar directamente en el hipervisor.

**KVM** Kernel Virtual Machine es un módulo de kernel de Linux para  virtualización. KVM es un hipervisor tanto del hipervisor Tipo 1 como  del Tipo 2 porque, aunque necesita un sistema operativo Linux genérico para funcionar, puede funcionar perfectamente como hipervisor. KVM utiliza el demonio `libvirt` y sus utilidades asociadas.

**VirtualBox** Es una aplicación de escritorio popular que facilita la creación y administración de máquinas virtuales. Como VirtualBox requiere de un sistema operativo subyacente para ejecutarse, es un hipervisor de tipo 2.

Para utilizar estos hipervisores la CPU del host a de permitir la virtualización.

```bash
$ grep --color -E "vmx|svm" /proc/cpuinfo
```





### Tipos de Máquinas Virtuales

Hay tres tipos principales de máquinas virtuales: el *fully virtualized* guest (un invitado totalmente virtualizado), el *paravirtualized* guest (un invitado paravirtualizado) y el *hybrid* guest (un invitado híbrido).



**Totalmente virtualizado (Fully Virtualized)**

Todas las instrucciones que se espera que ejecute un sistema  operativo invitado deben poder ejecutarse dentro de una instalación de  sistema operativo totalmente virtualizada. Este sistema operativo no sabe que esta virtualizado y es completamente independiente al host.

Para que este tipo de virtualización tenga lugar en hardware basado en  x86, las extensiones de CPU Intel VT-x o AMD-V deben estar habilitadas

**Paravirtualizado (Paravirtualized)**

Un invitado paravirtualizado (o PVM) es aquel en el que el sistema  operativo invitado es consciente de que es una instancia de máquina  virtual en ejecución. Este invitado utilizará un kernel modificado y controladores especiales para utilizar recursos de software y hardware del hipervisor.

**Híbrido (Hybrid)**

La paravirtualización y la virtualización completa se pueden combinar para permitir que los sistemas operativos no modificados reciban un  rendimiento de E/S casi nativo mediante el uso de controladores  paravirtualizados en sistemas operativos completamente virtualizados.



### Principales tipos de disco

**COW**  Copy-on-write (también conocido como *thin-provisioning* o *sparse images*)  El tamaño de la imagen del disco solo aumenta a medida que se escriben nuevos datos en el disco. El formato de vla imagen de disco es `qcow2`.

**RAW**  Un tipo de disco *raw* o *full* es un archivo que tiene  todo su espacio preasignado. Por ejemplo, un archivo de imagen de disco  sin formato de 10 GB consume 10 GB de espacio real en el hipervisor. 



Si dos máquinas virtules se clonan tendrán el mismo identificador de D-Bus, esto puede causar irregularidades en el funcionamiento. Para generar un nuevo identificador:

```bash
$ dbus-uuidgen --get	# ver identificador
17f2e0698e844e31b12ccd3f9aa4d94a
# generar uno nuevo
$ sudo rm -f /etc/machine-id
$ sudo dbus-uuidgen --ensure=/etc/machine-id
```



### Contenedores

La tecnología de contenedores es similar en algunos aspectos a una  máquina virtual, donde se obtiene un entorno aislado para implementar  fácilmente una aplicación. Mientras que con una máquina virtual se emula una computadora completa, un contenedor utiliza el software suficiente  para ejecutar una aplicación. De esta manera, hay mucho menos gastos  generales.

Existen numerosas tecnologías de contenedor disponibles para Linux, como *Docker*, *Kubernetes*, *LXD/LXC*, *systemd-nspawn*, *OpenShift* y más.



