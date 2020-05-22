### Instalación desatendida debian

Para la instalación desatendida de debian usaremos preseed.cfg básicamente es insertar un archivo en el contenido de instalación de nuestra iso, concretamente en el comprimido initrd.gz.

También usaremos isomaster para la modificación dev la iso.

#### Índice:  
[Descargar iso](#descargar-iso)    
[Extraer archivos](#extraer-archivos)     
[Descomprimir initrd\.gz y editar preseed](#descomprimir-initrd\.gz-y-editar-preseed)    
[Comprimir initrd nuevo insertar en la iso](#comprimir-initrd-nuevo-insertar-en-la-iso)    
[Editar menu de entrada e insertar en la iso](#editar-menu-de-entrada-e-insertar-en-la-iso)    
[Extraer nueva iso ](#extraer-nueva-iso)    

Empecemos:

​    

#### Descargar iso

- Descargamos una iso de debian **( Importante que no sea netinstall)** , las net  dan un problema que no encuentra los espejos y no e sabido solucionarlo.

```bash
wget https://cdimage.debian.org/debian-cd/current/amd64/iso-dvd/debian-9.3.0-amd64-DVD-1.iso
```

​	reconozco que es un poco pesada 4G pero merece la pena el resultado.

***



#### Extraer archivos

- Usando isomaster extraemos el archivo initrd.gz que se encuentra en *install.amd/* y añadimos la copia a nuestro escritorio personal.
- También extraemos archivo */isolinux/txt.cfg* para modificarlo mas adelante.

![Captura de pantalla de 2017-12-10 20-10-01](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/desatendidas/Captura%20de%20pantalla%20de%202017-12-10%2020-10-01.png?raw=true)

![Captura de pantalla de 2017-12-10 20-10-36](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/desatendidas/Captura%20de%20pantalla%20de%202017-12-10%2020-10-36.png?raw=true)

***



#### Descomprimir initrd\.gz y editar preseed

- Creamos una carpeta y lo extraemos dentro initrd.gz.

```bash
mkdir initrd
cd initrd
sudo zcat  ../initrd.gz | cpio -i -d 
```



- Creo un archivo con nombre preseed.cfg dentro de initrd que sera la configuración deseada.

```bash
touch preseed.cfg
```



- Y lo editamos con un editor, pongo el mio de muestra, y os dejo un manual para añadir los parametros deseados a vuestro gusto.

https://www.debian.org/releases/stable/i386/apb.html

```bash
# Seleccionar lenguaje y país: en mi caso Castellano:
d-i debian-installer/locale string es_ES

# Selección de teclado español:
d-i keyboard-configuration/xkb-keymap select es

# NO quiero configurar la red 
# y por ello permito que se detecte la red con DHCP 


# Si hay más de una interfaz de red (eth0, eth1)
# seleccionar automáticamente una interfaz
d-i netcfg/choose_interface select auto

# Cuando falla la detección por red indicar que no se va a
# configurar la red
d-i netcfg/dhcp_failed note
d-i netcfg/dhcp_options select Do not configure the network at this time

# Establecer el nombre de la computadora (hostname)
d-i netcfg/get_hostname string debian-desatendida

# Seleccionar la lista de repositorios
# No tiene que definir la cadena mirror/country si selecciona ftp
#d-i mirror/protocol string ftp
d-i mirror/country string manual
d-i mirror/http/hostname string  	ftp.es.debian.org/debian/
d-i mirror/http/directory string /debian
d-i mirror/http/proxy string

# Publicación a instalar.
d-i mirror/suite string testing
# Publicación a utilizar para descargar componentes de la instalación
# (opcional)
d-i mirror/udeb/suite string testing


# Utilizar el reloj con utc
d-i clock-setup/utc boolean true

# Establecer la zona horaria
d-i time/zone string  Europe/Madrid

##################################
# Indicar al partman (creador de particiones) el volumen del disco a
# utilizar para crear las particiones
# ( voy a instalar esta iso en una mv por lo tanto indico disco vda )
# en e caso de ser máquina real poner disco qiue tengais sda seguramente
d-i partman-auto/disk string /dev/vda

# Indicar al partman que vamos a particionar de manera regular
# otras opciones son lvm y crypto (para particionar encriptado)
d-i partman-auto/method string regular

# Esta tocadura de pelotas nos indica que crea tres particiones: swap, /home, / raiz.
# los números ( 5120 6000 1000000000 )indican :
# primero: tamaño mínmo de partición 
# segundo: prioridad a de estar entre el tamaño del 1º y el 3º
# tercero: tamaño máximo de partición
# el 1000000000 indica que cogera todo el espacio disponible en el disco
# para más información el manual que e dejado justo arriba.
d-i partman-auto/expert_recipe string
    boot-root ::                                            \
               5120 6000 1000000000 ext3                                  \
                       $primary{ } $bootable{ }                \
                       method{ format } format{ }              \
                       use_filesystem{ } filesystem{ ext3 }    \
                       mountpoint{ /home }                     \
               .                                               \
               5120 6000 10240  ext3                       \
                       method{ format } format{ }              \
                       use_filesystem{ } filesystem{ ext3 }    \
                       mountpoint{ / }                         \
               .                                               \
               1024 1024 100% linux-swap                          \
                       method{ swap } format{ }                \
               .
########################################################3

############################
# esta parte comentada seria si queremos la instalación de disco por defecto
#####################################
# Indicar al partman que vamos a particionar de manera regular
# otras opciones son lvm y crypto (para particionar encriptado)
#d-i partman-auto/method string regular

#d-i partman-lvm/device_remove_lvm boolean true
#d-i partman-md/device_remove_md boolean true
#d-i partman-lvm/confirm boolean true
#d-i partman-auto/chose_recipe select multi
###########################33

# Indicamos al partman que no nos pregunte más nada
d-i partman-partitioning/confirm_write_new_label boolean true
d-i partman/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true


# Indicamos que añada repositorios nonfree crontib
d-i apt-setup/non-free boolean true
d-i apt-setup/contrib boolean true
# Select which update services to use; define the mirrors to be used.
# Values shown below are the normal defaults.
d-i apt-setup/services-select multiselect security, updates
d-i apt-setup/security_host string security.debian.org


# Permitimos que se instale el grub como gestor de arranque
# como yo sólo uso debian se lo indico al instalador
# si tuviera otro sistema operativo (window$ por ejemplo) tendría
# que cambiar la instrucción
d-i grub-installer/only_debian boolean true

# indicamos que queremos el grub en el MBR de vda
d-i grub-installer/bootdev  string /dev/vda

# Saltarse el mensaje de: "instalación finalizada"
d-i finish-install/reboot_in_progress note

# Poner la prioridad del
# debconf (que es la herramienta para crear configuraciones)
# que use el nivel crítico para que
# no haga preguntas innecesarias
d-i debconf/priority select critical
debconf debconf/priority select critical

# Crear la contraseña del usuario root
passwd passwd/root-password password root
passwd passwd/root-password-again password root

# Crear un usuario con su contraseña
# en este ejemplo el usuario con username "debian"
# y contraseña "debian" muy seguro lo sé
passwd passwd/user-fullname string debian-stretch
passwd passwd/username string debian
# And their password, but use caution!
passwd passwd/user-password password debian
passwd passwd/user-password-again password debian

# indicamos escritorio a instalar ¡importante!, si no se instala sin escritorio
tasksel tasksel/first multiselect standard, desktop, cinnamon-desktop

# añado un script final de la instalacion este script lo inserto en la iso en la carpeta
# finisher y raiz de la iso 
d-i preseed/late_command string cp /cdrom/finisher/finisher.sh /target/root/; chroot /target chmod +x /root/finisher.sh; chroot /target bash /root/finisher.sh


# Paquetes individuales a instalar
#d-i pkgsel/include string openssh-server build-essential
# En caso de querer hacer actualización de paquetes después
# de debootstrap.
# Valores posibles: none, safe-upgrade, full-upgrade
#d-i pkgsel/upgrade select none


# hacer un chroot a «/target» y utilizarlo directamente o utilizar las
# órdenes «apt-install» e «in-target» para instalar fácilmente paquetes
# y ejecutar órdenes en el sistema destino
#d-i preseed/late_command string apt-install zsh; in-target chsh -s /bin/zsh
```

Es una tocadura de huevos lo sé, pero es debian.



En mi caso e añadido un script final que insertare la raiz de la iso con isomaster, en el script puedes añadir los parametros que quieras se ejecutara justo despues de la instalación y como root.

```bash
mkdir finisher
touch finisher/finisher.sh # y lo edito a my gusto
```

***



#### Comprimir initrd nuevo insertar en la iso

- una vez editado el preseed.cfg a nuestro gusto comprimir de nuevo la carpeta initrd

```bash
cd initrd
sudo  find . | cpio -o -H newc | gzip -9 > ../initrd.gz
cd ..
```

- E insertar el nuevo initrd.gz en la direccion de la iso */isolinux/* con isomaster.

![Captura de pantalla de 2017-12-10 20-11-51](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/desatendidas/Captura%20de%20pantalla%20de%202017-12-10%2020-11-51.png?raw=true)

***



#### Editar menu de entrada e insertar en la iso

- edito entrada en el menu de instalacion.

abrimos archivo de menu de las iso por defecto que se encuentra

cat /isolinux/menu.cfg

```bash
menu hshift 7
menu width 61

menu title Debian GNU/Linux installer boot menu
include stdmenu.cfg
include gtk.cfg
include txt.cfg
menu begin advanced
    menu label ^Advanced options
	menu title Advanced options
	include stdmenu.cfg
	label mainmenu
		menu label ^Back..
		menu exit
	include adgtk.cfg
	include adtxt.cfg
	include adspkgtk.cfg
	include adspk.cfg
menu end
include x86menu.cfg
label help
	menu label ^Help
	text help
   Display help screens; type 'menu' at boot prompt to return to this menu
	endtext
	config prompt.cfg
include spkgtk.cfg
include spk.cfg
```

entre todos estos archivos buscamos el que nos interesa que es **include txt.cfg** 



- lo editamos, ya que esta en nuestra carpeta personal al averlo extraido anteriormente.

```bash
sudo nano txt.cfg
```

Que añádiremos las siguentes lineas:

```bash
label install
	menu label ^Install
	kernel /install.amd/vmlinuz
	append vga=788 initrd=/install.amd/initrd.gz --- quiet 

label install2
	menu label ^Install-desatendida
	kernel /install.amd/vmlinuz
	append vga=788 initrd=/isolinux/initrd.gz --- quiet 
```

Lo que hemos hecho es añadir una nueva salida al menu, indicando kernel a arrancar por defecto y la nueva configuracion de arranque el nuevo initrd.gz que emos hañadido.

- lo añadimos a la iso. ( eliminamos primero el que hay en la iso para evitar problemas ).

![Captura de pantalla de 2017-12-10 20-11-15](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/desatendidas/Captura%20de%20pantalla%20de%202017-12-10%2020-11-15.png?raw=true)

![Captura de pantalla de 2017-12-10 20-11-33](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/desatendidas/Captura%20de%20pantalla%20de%202017-12-10%2020-11-33.png?raw=true)

***



#### Extraer nueva iso 

- Una vez echo todo lo anterior procedemos a montar la iso con todos sus archivos nuevos dentro, simplemente es guardar con isomaster.

![Captura de pantalla de 2017-12-10 20-14-03](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/desatendidas/Captura%20de%20pantalla%20de%202017-12-10%2020-14-03.png)



Pues ya tenemos nuestra iso para instalar donde queramos, ejemplo de menu de arranque:

![Captura de pantalla de 2017-12-10 19-35-36](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/desatendidas/Captura%20de%20pantalla%20de%202017-12-10%2019-35-36.png)



Una vez le demos a instalación desatendida ya podemos irnos a tomar un cafe por que no nos preguntara nada mas.

Si da algún tipo de fallo es segutramente por haber puesto algun parametro mal en el archivo preseed.cfg

