## Instalar y configurar servidor pxe  

[TOC]

#### descargamos bind(dhcp) vsftp y selinux

Datos de mi red cambiar según se tenga cada uno.

```
192.168.88.243 server
192.168.88.1 router
192.168.88.0 red	
```

Para  que los clientes se conecten via pxe hay que desabilitar selinux y firtewall.

```
systemctl stop/disable selinux
systemctl stop/disable firewall
```

***



#### Configurar dhcp

root@fedora26-virt ~]# cat /etc/dhcp/dhcpd.conf 

```
ddns-update-style none;
default-lease-time 3600;
max-lease-time 86400;
allow booting; 
allow bootp;

subnet 192.168.88.0 netmask 255.255.255.0 {
	option broadcast-address 192.168.88.255;  # broadcas
	range  192.168.88.200 192.168.88.240;    
	option domain-name-servers 8.8.8.8;
	option routers 192.168.88.1;   # router
	next-server 192.168.88.243;   # server
	filename "pxelinux.0"; 
}
```

En el recuadro superior tenemos una configuración que solo manda direcciones ip al arrancar.  

El archivo **pxelinux.0** luego lo extraeremos de **/usr/share/syslinux/ ** es el arranque del menu syslinux.

***



#### configuración de ftp

[root@fedora26-virt ~]# cat /etc/xinetd.d/tftp

```
# default: off
# description: The tftp server serves files using the trivial file transfer 
#    protocol.  The tftp protocol is often used to boot diskless 
# workstations, download configuration files to network-aware printers, 
#   and to start the installation process for some operating systems.
service tftp
{
  socket_type     = dgram
  protocol        = udp
  wait            = yes
  user            = root
  server          = /usr/sbin/in.tftpd
  server_args     = -s /var/lib/tftpboot
  disable         = no
  per_source      = 11
  cps         = 100 2
  flags           = IPv4
}
```

En este archivo lo importante es la ruta en la que pondremos el **tftpboot** que es donde estara el menu de arranque consus archivos.



[root@fedora26-virt ~]# cat /etc/vsftpd/vsftpd.conf

```
anonymous_enable=YES
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES
listen=YES
pam_service_name=vsftpd
userlist_enable=NO
tcp_wrappers=YES
seccomp_sandbox=NO
```

por defecto **anonymous_enable=** viene en no lo cambiamos a yes, para que puedan acceder al server ftp cualquier usuario.

***



#### Configurar menu de arranque

Ahora tenemos que añadir el menu de arranque a tftpboot.

```shell
sudo cp /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot/
sudo cp /usr/share/syslinux/ldlinux.c32 /var/lib/tftpboot/
```

pxelinux.0 es el ejecutable de syslinux, ldlinux.c32 una libreria sulla que pide.



pxelinux.0 necesita una configuración para ser visto y por defecto la coge de pxelinux.cfg/default que crearemos ahora.

```shell
sudo mkdir /var/lib/tftpboot/pxelinux.cfg
sudo touch /var/lib/tftpboot/pxelinux.cfg/default	
sudo cp /usr/share/syslinux/vesamenu.c32 /var/lib/tftpboot/pxelinux.cfg/
```

también añadimos vesamenu.32 es un tipo de visualizacion del menu.

***



Añadimos al archivo default las siguientes lineas:

[root@fedora26-virt ~]# cat /var/lib/tftpboot/pxelinux.cfg/default 

```bash
# D-I config version 2.0
# ruta donde añadire mi menu
path mi-menu/
# menu de configuración
include mi-menu/menu.cfg
# tipo de visualizador
default vesamenu.c32
prompt 0
timeout 0
```

En mi caso he separado este anchivo en 3 distintos:

1. default 
2. los estilos definidos que quiero que se vea stylosmenu.cfg
3. menu de opciones menu.cfg

*no es necesario pero si mas lejible en futuras ocasiones.*

***



creo ruta a mi menu.cfg y copio algunos archivos que necesitare:

```bash
cd /var/lib/tftpboot
mkdir mi-menu
touch mi-menu/menu.cfg
touch mi-menu/stylosmenu.cfg
sudo cp /usr/share/syslinux/vesamenu.c32 /var/lib/tftpboot/mi-menu/
sudo cp /usr/share/syslinux/reboot.c32 /var/lib/tftpboot/mi-menu/
sudo cp /usr/share/syslinux/ldlinux.c32 /var/lib/tftpboot/mi-menu/
sudo cp /usr/share/syslinux/libcom32.c32 /var/lib/tftpboot/mi-menu/
sudo cp /usr/share/syslinux/libutil.c32 /var/lib/tftpboot/mi-menu/
sudo cp /home/mi-user/images/fondo.jpg /var/lib/tftpboot/mi-menu/
```

**Importante** la imagen de fondo a de ser de 640x480 y en formato .jpg o .png

*Si no quieres imagen de fondo omitirla*

***



##### Añadir los estilos al menu.

[root@fedora26-virt ~]# cat /var/lib/tftpboot/mi-menu/stylosmenu.cfg 

```bash
menu background mi-menu/fondo.jpg
menu color title	* #FFFFFFFF *
menu color border	* #00000000 #00000000 none
menu color sel		* #ffffffff #76a1d0ff *
menu color hotsel	1;7;37;40 #ffffffff #76a1d0ff *
menu color tabmsg	* #ffffffff #00000000 *
menu color help		37;40 #ffdddd00 #00000000 none
# XXX When adjusting vshift, take care that rows is set to a small
# enough value so any possible menu will fit on the screen,
# rather than falling off the bottom.
menu vshift 8
menu rows 12
# The help line must be at least one line from the bottom.
menu helpmsgrow 14
# The command line must be at least one line from the help line.
menu cmdlinerow 16
menu timeoutrow 16
menu tabmsgrow 18
menu tabmsg Press ENTER to boot or TAB to edit a menu entry
```

Es la configuración que usa la live de debian por defecto.



##### Añado entradas al menu

[root@fedora26-virt ~]# cat /var/lib/tftpboot/mi-menu/menu.cfg 

```bash
menu hshift 7
menu width 61
# include define fondo y posicionamieto de menu para reducir líneas
include mi-menu/stylosmenu.cfg

menu title Menu PXE rompe pelotas

label Arrancar de disco
	LOCALBOOT 0
        TEXT HELP
        Para arrancar desde el disco duro pulsa Enter.
        ENDTEXT

label Reiniciar
	menu label ^Reiniciar
	COM32 reboot.c32
```

de momento con esto ya deberia servir pasra arrancar y comprobar que funciona.

***

Iniciamos servicios dhcpd y vsftpd y comprobamos.

```bash
sudo systemctl start/enable dhcpd
sudo systemctl start/enable vsftpd
```

E iniciamos desde otra máquina mediante pxe y en la misma red.

***



#### Añadir distribuciones 

##### Descargar abrir y guardar

Para añadir isos tendremos que descargarlas de sus repositorios y guardarlas en /var/ftp/pub

añadiremos 3 distribuciones, debian, centos y fedora.

```bash
# creo carpetas donde las guardare
sudo mkdir /var/ftp/pub/debian9-x86_64
sudo mkdir /var/ftp/pub/centos7-x86_64
sudo mkdir /var/ftp/pub/fedora27-x86_64
# descargo isos
wget https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-9.2.1-amd64-netinst.iso 
wget http://ftp.cixug.es/CentOS/7/isos/x86_64/CentOS-7-x86_64-Minimal-1708.iso 
wget https://download.fedoraproject.org/pub/fedora/linux/releases/27/Workstation/x86_64/iso/Fedora-Workstation-netinst-x86_64-27-1.6.iso

# monto iso en /tmp/iso y lo copio a su carpeta correspondiente
mkdir /tmp/iso
# debian
sudo  mount -t iso9660 -o loop debian-9.2.1-amd64-netinst.iso /tmp/iso
sudo cp -arv /tmp/iso/*  /var/ftp/pub/debian9-x86_64/
sudo umount /tmp/iso
# centos
sudo  mount -t iso9660 -o loop CentOS-7-x86_64-Minimal-1708.iso  /tmp/iso
sudo cp -arv /tmp/iso/*  /var/ftp/pub/centos7-x86_64/
sudo umount /tmp/iso
# fedora
sudo  mount -t iso9660 -o loop Fedora-Workstation-netinst-x86_64-27-1.6.iso  /tmp/iso
sudo cp -arv /tmp/iso/*  /var/ftp/pub/fedora27-x86_64/
sudo umount /tmp/iso

#  borro isos descargadas para liberar espacio
rm Fedora-Workstation-netinst-x86_64-27-1.6.iso
rm CentOS-7-x86_64-Minimal-1708.iso
rm debian-9.2.1-amd64-netinst.iso
```

***



##### Ordenar tftpboot

Ya con la isos guardadas procedemos a estructurar nuestra carpeta tftpboot, por que tendremos que extraer de cada iso su archivo de iniciación y el kernel que usan.

- En el caso de fedora y centos initrd.img y vmlinuz. 
- En debian initrd.gz y vmlinuz.



Creo una carpeta para cada distro y dentro su version, para futuras ampliaciones.

```bash
cd /var/lib/tftpboot
mkdir -p /centos/centos7
mkdir -p /debian/stretch
mkdir -p /fedora/fedora27
```

Y de cada uno le añadimos su archivo de kernerl e iniciación

```bash
cp /var/ftp/pub/centos7-x86_64/isolinux/vmlinuz centos/centos7/
cp /var/ftp/pub/centos7-x86_64/isolinux/initrd.img centos/centos7/
cp /var/ftp/pub/fedora27-x86_64/isolinux/vmlinuz fedora/fedora27/
cp /var/ftp/pub/fedora27-x86_64/isolinux/initrd.img fedora/fedora27/
cp /var/ftp/pub/debian9-x86_64/install.amd/vmlinuz debian/stretch/
cp /var/ftp/pub/debian9-x86_64/install.amd/initrd.gz debian/stretch/
```

nos quedara el siguente arbol en la carpeta tftpboot

```bash
[root@fedora26-virt tftpboot]# tree
.
├── centos
│   └── centos7
│       ├── initrd.img
│       └── vmlinuz
├── debian
│   └── stretch
│       ├── initrd.gz
│       └── vmlinuz
├── fedora
│   └── fedora27
│       ├── initrd.img
│       └── vmlinuz
├── ldlinux.c32
├── mi-menu
│   ├── fondo.jpg
│   ├── ldlinux.c32
│   ├── libcom32.c32
│   ├── libutil.c32
│   ├── menu.cfg
│   ├── reboot.c32
│   ├── stylosmenu.cfg
│   └── vesamenu.c32
├── pxelinux.0
└── pxelinux.cfg
    ├── default
    └── vesamenu.c32
```



##### Editar menu.cfg

Ahora que ya tenemos todo ordenado y preparado. Editamos el menu.cfg y añadimos las siguientes líneas:

[root@fedora26-virt ~]# cat /var/lib/tftpboot/mi-menu/menu.cfg 

```bash
menu hshift 7
menu width 61

# include define fondo y posicionamieto de menu para reducir líneas
include mi-menu/stylosmenu.cfg

menu title Menu PXE rompe pelotas

label Arrancar de disco
	LOCALBOOT 0
        TEXT HELP
        Para arrancar desde el disco duro pulsa Enter.
        ENDTEXT

label Reiniciar
	menu label ^Reiniciar
	COM32 reboot.c32
	
#submenu isos
menu begin Imagenes
    menu label ^Imagenes
        menu title Imagenes
# al ser un submenu hay que poner fondo otra vez y cuadrar texto
        include mi-menu/stylosmenu.cfg
        label mainmenu
                menu label ^Back..
                menu exit

        label Fedora 27
                menu label ^Fedora 27
                kernel fedora/fedora27/vmlinuz
                append initrd=fedora/fedora27/initrd.img repo=ftp://192.168.88.243/pub/fedora27-x86_64

        label Debian strech
                menu label ^Debian strech
                kernel debian/stretch/vmlinuz
                append initrd=debian/stretch/initrd.gz repo=ftp://192.168.88.243/pub/debian9-x86_64

        label Centos 7
                menu label ^Centos 7
                kernel centos/centos7/vmlinuz
                append initrd=centos/centos7/initrd.img repo=ftp://192.168.88.243/pub/centos7-x86_64

menu end
# fin submenu
```



Con las siguientes líneas le decimos que inicie con el kernel de linux, inicie la imagen y coja las dependencias de nuestro repositorio ftp.

Todo esto hay que tener en cuenta que hemos creado un server ftp con poca seguridad si ponems en el navegador ftp://192.168.88.243 en nmi caso saldra el contenido de la carpeta pub.

En entornos lan privados no pasa nada, pero es un dato a tener en cuenta.

**¡Importante!** A mas a mas Fedora tiene un bug que si arrancas con una máquina con 1G de ram falla la instalacioón , mínimo a de tener 2G para que funcione bien.

***



##### Ejemplo imagen

Dejo un par de imagenes para ver como queda.

![Captura menu principal](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/pxe1.png)

![muhjni imagenbes](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/pxe2.png)





