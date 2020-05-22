## kickstart ( Es solo compatible con el instalador anaconda )  

Para generar una imagen de una instalación  desatendida, primero hay que generar un archivo de los pasos a seguir en la instalación, insertarlo en la imagen y modificar el menu de la imagen para que lo detecte.



## Generar pasos de instalación

Hay que generar un archivo con los pasos de la instalación, lo llamare  `kicktart.cfg` .

Tenemos 2 maneras  una aplicación gráfica en derivados de Red Had o manualmente.

**La aplicación:** 

- Esta en los repositorios `sudo dnf install -y system-config-kickstart` .
- Es muy intuitiva solo hay que indicar lo que quieres, red, paswords, paquetes, modo de instalación, etc.. al guardar genera el archivo que necesitamos.

**Manualmente:**  

- Pues tienes mas trabajo, pero también mas opciones, lo mejor es un combo de la aplicación, y añadirle algún parámetro mas.

- Documentación:
  - [wiki fedora](https://fedoraproject.org/wiki/Anaconda/Kickstart/es)
  - [kickstart docs](https://pykickstart.readthedocs.io/en/latest/kickstart-docs.html)





### Ejemplo archivo ks.cfg

```bash
#platform=x86, AMD64 o Intel EM64T
#version=DEVEL
# Install: tipo de instalacion  url: netinst
install
url --url="ftp://ftp.cica.es/fedora/linux/releases/29/Workstation/x86_64/os"

# Keyboard layouts
keyboard 'es'

# Root password
rootpw --iscrypted $6$dtciO6uRuALooO.4$0oFR1GxiI0W57fXywalmIKLtILbCSoeI2JqMuztbhq135NPnEzyq8O56RpwjLvAns5qx03KeI1kk7OrX4IuFE

# user
user --name=jorge --groups=wheel --iscrypted $6$dtciO6uRuALooO.4$0oFR1GxiI0W57fXywalmIKLtILbCSoeI2JqMuztbhq13

# network dhcp
network --onboot yes --device eth0 --bootproto dhcp --noipv6

# System language
lang es_ES.UTF-8

# Firewall configuration
firewall --disabled

# Reboot after installation
reboot

# System timezone
timezone --utc  Europe/Madrid

# System authorization information
authconfig --enableshadow --passalgo=sha512 --enablefingerprint

# Modo de instalacion 
text
#graphical 

firstboot --disable

# SELinux configuration
selinux --permissive

# Que particiones borrar
clearpart --all 

# Tabla de particiones
part swap --fstype="swap" --recommended
part / --fstype="ext4" --grow --size=1

# System bootloader configuration
bootloader --location=mbr --driveorder=vda --append="rhgb quiet"

# Que ejecutar al acabar la instalacion
%post
systemctl set-default graphical.target  # por defecto arranque gráfico
dnf -y update
dnf install -y nano
dnf install -y grub-customizer
%end

# Paquetes que se instalaran en la instalacion
%packages
@base-x    # x windows
@gnome-desktop    # Escritorio deseado
%end
```

- Para encriptar las contraseñas manualmente:

  ```bash
  python3 -c 'import crypt,getpass;pw=getpass.getpass();print(crypt.crypt(pw) if (pw==getpass.getpass("Confirm: ")) else exit())'
  ```





### Editar iso

Para editar la iso tenemos que montarla en el sistema o usar algún programa como **isomaster**. Lo dejo al gusto.



#### Editar archivo `isolinux.cfg`

Este archivo se encuentra dentro de la iso, en la ruta `/isolinux/isolinux.cfg` y contiene el menú de inicio para la instalación.

Lo que hago es crear un nuevo label para indicar la instalación desatendida. 

-  Copio el label de la instalación normal y le añado al final la ruta  donde se encontrara el archivo kickstart  **ks=cdrom:/isolinux/ks.cfg**  .

```
label desatendida
  menu label ^Install desatendida Fedora 29
  kernel vmlinuz
  append initrd=initrd.img inst.stage2=hd:LABEL=Fedora-WS-dvd-x86_64-29 ks=cdrom:/isolinux/kickstart.cfg

label linux
  menu label ^Install Fedora 29
  kernel vmlinuz
  append initrd=initrd.img inst.stage2=hd:LABEL=Fedora-WS-dvd-x86_64-29 quiet
```



#### Insertar kickstart

Ahora solo queda insertar el archivo `kickstart.cfg` en la ruta que he indicado dentro de la imagen `/isolinux/kickstart.cfg` y volver a montar la imagen.


