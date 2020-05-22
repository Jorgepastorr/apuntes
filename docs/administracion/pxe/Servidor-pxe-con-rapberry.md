# Servidor pxe con rapberry

[TOC]



**1-Que es PXE?**

Entorno de ejecución de prearranque, es decir, un entorno para arrancar e instalar el sistema operativo en nodos a través de la red.



**2-Que hace?**

Permite conectarte automáticamente a un servidor donde puedes descargar e instalar el sistema operativo que tenga disponible el servidor.



**3-Que necesita?**

- Servidor DHCP (Red)

- Servidor FTP (ISOS)

- Menú de previsualización.


**4-Como funciona?**

Almacena las imágenes en un servidor en el que accedes cuando te conectas por PXE mediante DHCP, y una vez conectado permite descargar e instalar dichas imágenes mediante un servidor ftp.



## Instalación 

---

**Raspberry pi 3b**

- IP: 192.168.4.103
- Mascara: 255.255.0.0
- Broadcast: 192.168.255.255
- Router: 192.168.0.1



**Instalamos dhcp, inet utils y ftp**

```bash
 sudo apt-get install -y isc-dhcp-server inetutils-inetd tftp tftpd-hpa
```

  

#### configurar dhcp

/etc/dhcp/dhcpd.conf

```bash
default-lease-time 600;
max-lease-time 7200;
ddns-update-style none;
authoritative;


allow booting;
allow bootp;

subnet 192.168.4.0 netmask 255.255.255.0 {
        option broadcast-address 192.168.4.255;  # broadcast
        range  192.168.4.100 192.168.4.240;
        option domain-name-servers 8.8.8.8;
        option routers 192.168.0.1;   # router
        next-server 192.168.4.103;   # server
           filename "pxelinux.0";
}
```



**Archivo de configuración del servicio dhcp**

/etc/default/isc-dhcp-server

```bash
INTERFACESv4="eth0"
INTERFACESv6=""
```



**Creo estructura de carpetas que luego utilizare para organizar el archivos de inicio de isos**

```bash
sudo mkdir -p /var/lib/tftpboot/debian/stretch
sudo mkdir -p /var/lib/tftpboot/windows
```



**Descargo archivo pxelinux.0 de arranque pxe de la web a /var/lib/tftpboot/**

```bash
cd /var/lib/tftpboot/
sudo wget http://ftp.uk.debian.org/debian/dists/wheezy/main/installer-i386/current/images/netboot/debian-installer/i386/pxelinux.0
```



#### Configuración inet.d

/etc/inetd.conf

```bash
tftp dgram udp wait root /usr/sbin/tcpd in.tftpd /var/lib/tftpboot
```



#### Configuración FTP

/etc/default/tftpd-hfa

```bash
TFTP_USERNAME="tftp"
TFTP_DIRECTORY="/var/lib/tftpboot"
TFTP_ADDRESS="0.0.0.0:69"
TFTP_OPTIONS="-s"
```



**Añado iso debian dentro de la carpeta debian creada.**

```bash
# descargo iso debian
wget https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-9.2.1-amd64-netinst.iso

# monto iso en /tmp/iso y lo copio a su carpeta correspondiente
mkdir /tmp/iso


# debian monto en /tmp/iso
sudo  mount -t iso9660 -o loop debian-9.2.1-amd64-netinst.iso /tmp/iso


# copio en la carpeta del ftp para que pueda acceder desde pxe.
sudo cp -arv /tmp/iso/*  /var/lib/tftpboot/debian/stretch/
sudo umount /tmp/iso
```



#### Creo menú de iniciación pxe 

**se encuentra dentro de la carpeta pxelinux.conf que creo a continuación.**

```bash
sudo mkdir /var/lib/tftpboot/pxelinux.conf
sudo touch /var/lib/tftpboot/pxelinux.conf/default

# copio archivo que permite la visualización del menú
sudo cp /usr/share/syslinux/vesamenu.c32 /var/lib/tftpboot/

# añado foto de 640*480 
sudo cp fondo.jpg  /var/lib/tftpboot/pxelinux.conf/

```



/var/lib/tftpboot/pxelinux.conf/default

```bash
ui vesamenu.c32
menu title Utilities
menu background pxelinux.cfg/fondo.jpg

label debian stretch
  menu label debian stretch

# vmlinuz se encuentra dentro de la imagen de debian
  kernel debian/stretch/install.amd/vmlinuz

# initrd.gz se encuentra dentro de la imagen de debian
  append vga=normal  initrd=debian/stretch/install.amd/initrd.gz repo=ftp://192.168.4.103/debian/stretch

PROMPT 1
TIMEOUT 0
```



**Arrancar servicios**

```bash
sudo /etc/init.d/tftpd-hpa start
sudo /etc/init.d/inetutils-inetd.service start
sudo /etc/init.d/isc-dhcp-server start

sudo systemctl enable isc-dhcp-server
sudo systemctl enable inetutils-inetd.service
```



<u>**Ya está operativo pxe con debian, seguimos con windows.**</u>

---

   

   

### Instalar samba con windows paquetes necesarios

 ```bash
sudo apt-get install -y genisoimage wimtools cabextract samba
ln -s /usr/bin/genisoimage /usr/bin/mkisofs
 ```



**Creamos los directorios**

```bash
mkdir -p /mnt/waik
mkdir -p /var/lib/tftpboot/windows
```



**Descargamos Windows Automated Installation Kit (WAIK) ISO:**

```bash
wget https://download.microsoft.com/download/8/E/9/8E9BBC64-E6F8-457C-9B8D-F6C9A16E6D6A/KB3AIK_EN.iso
```



**Montamos la imagen**

```bash
mount KB3AIK_EN.iso /mnt/waik
```



**Generamos una imagen booteable**

```bash
mkwinpeimg --iso --arch=amd64 --waik-dir=/mnt/waik /var/lib/tftpboot/winpe.iso
```



**Desmontamos**

```bash
umount /mnt/waik
```



**Editamos el fichero de samba**

Añadimos lo siguiente al final

/etc/samba/smb.conf

     [windows]
      browsable = true
      read only = yes
      guest ok = yes
      path = /var/lib/tftpboot/windows



**Descargamos un windows iso y montamos.**

```bash
sudo mount win10.iso /var/lib/tftpboot/windows
```



**Le añadimos la siguiente linea a fstab para que monte automáticamente al arrancar**

/etc/fstab

```bash
/home/pi/win10.iso /var/lib/tftpboot/windows auto loop 0 0
```



**Añadimos lo necesario al menú del pxe para arrancar windows**

/var/lib/tftpboot/pxelinux.cfg/default:

```bash
ui vesamenu.c32
menu title Utilities
menu background pxelinux.cfg/fondo.jpg

label debian stretch
  menu label debian stretch
  kernel debian/stretch/install.amd/vmlinuz
  append vga=normal  initrd=debian/stretch/install.amd/initrd.gz repo=ftp://192.168.4.103/debian/stretch

LABEL windows10
   MENU LABEL Windows 10
   KERNEL /memdisk
   INITRD /winpe.iso

PROMPT 1
TIMEOUT 0
```



**Al arrancar con pxe y seleccionando la imagen de  windows se abre una terminal donde tenemos que acceder a samba.**

```bash
# Montar samba en z
# net use Z: \\ipnuestra\carpeta
net use z: \\192.168.4.103\windows
# acceder a z
z:
# acceder a carpeta windows donde esta la imagen de samba
cd windows
# ejecutar setup.exe de la iso
setup.exe
```



***Y listo seguimos instalación de windows.***

