# Grub



### Cambiar grub a partición dedicada.

Primero de todo creamos una partición de unos 500M.

```bash
sudo fdisk /dev/sda
```

- Damos por hecho que crea por ejemplo sda2.



La formateamos.

```bash
sudo mkfs.ex4 /dev/sda2
```



Copiamos el contenido de nuestra carpeta boot en ella. ( antes tendremos que montarla por ejemplo como /mnt)

- Montamos /mnt en sda2 ( futuro boot ).

  ```bash
  sudo mount /dev/sda2 /mnt
  ```

- Copiamos /boot a /mnt.

  ```bash
  sudo cp -af /boot  /mnt
  ```

  

Indicamos al MBR donde se encuentra los archivos del nuevo grub.

```bash
 grub2-install --boot-directory=/mnt/boot /dev/sda 
```





### Ficheros de configuración de grub y grub2-install

<u>*grub2-install*</u>  

- Lo que hace es decirle al gestor de arranque donde se encuentra la configuración de grub.
- Hay que permanecer dentro de la carpeta /boot con todo su contenido para que grub-install haga su correcta instalación.

<u>*configuración grub*</u>

- podemos encontrar el fichero de configuración de grub en:
- /boot/grub2/grub.cfg
- /boot/grub2/menu.lst → sistemas antiguos.
- Ahí nos muestra la ruta que tiene asignada el gestor de arranque al archivo grub.cfg en prefix=(disco,partición)/ruta

<u>*grub2-mkconfig*</u>

- Nos permite regenerar el archivo grub.cfg. Crea una imagen de la tabla de particiones actual y genera un nuevo grub.cfg. 


- `grub2-mkconfig -o /boot/grub2/grub.cfg`



#### Sticks de arranque

En el caso que el enlace del bootstrap hasta el directorio /boot funcione pero por alguna razón, no encuentre el archivo grub.cfg, aparecerá el prompt del grub `#grub>` desde el que podemos arrancar el sistema de diferentes maneras. 

1. Tunear una entrada existente de grub

   - El el caso de querer arrancar un sistema que no esta en el grub.cfg.

2. Escribir en modo comando una entrada.

   - Sabiendo donde esta el sistema operativo podemos arrancar escribiendo manualmente los comandos de la edición de grub del apartado anterior.

   - ```bash
      insmod gzio
      insmod part_msdos
      insmod ext2
      set root='hd0,msdos5'
      linux16 /boot/vmlinuz-5.0.... root=/dev/sda5 
      initrd16 /boot/initrd-5.0.. .img
     ```

   

3. En modo comando llamar a algún fichero grub.cfg de alguna partición existente.

   ```bash
   grub> configfile (hd0,msdos5)/boot/grub2/grub.cfg
   ```



En el caso del link del mbr a la partición donde se encuentra el directorio grub este roto. Grub no podrá acceder a los módulos, por lo tanto aparecerá `grub rescue>` al arrancar.

La solución indicar en que partición se encuentra los archivos de grub, añadir raiz de destino, y arrancar con el modulo normal.

```bash
grub recue> set prefix=(hd0,msdos5)/boot/grub2
grub recue> set root=(hd0,msdos5)
grub recue> insmod normal
grub recue> normal
```



### 

### Re-instalar gestor de arranque windows

- Iniciamos con una live de hirens o dlcb.
- Desde partition wizard o similar buscamos la opción rebuild mbr
- Asegurándonos que señalamos a nuestro disco regeneramos mbr

Puede que con hirens al ser un mini xp no detecte el disco, es mejor dlcb arrancar con un win10 o una iso de gandalf



### Edición grub

Al generar un *grub.cfg* en cada entrada lo importante para arrancar son las siguientes lineas:

- `insmod`para cargar los módulos necesarios.
- `set root` ruta de disco y partición donde buscar archivos.
- `linux16, initrd16` cargar kernel en partición indicada y ramdisk

```bash
menuentry 'fedora mati' {
    insmod gzio
    insmod part_msdos
    insmod ext2
    set root='hd0,msdos5'
    linux16 /boot/vmlinuz-5.0.... root=/dev/sda5 
    initrd16 /boot/initrd-5.0.. .img
}
```

```bash
menuentry 'win2' {
    insmod part_msdos
    insmod ntfs # en el caso de partición vfat insmod vfat
    set root=(hd0,2)
    chainloader +1
}
```

```bash
# Passar el control a un altre carregador
menuentry 'cahinloader' {
insmod gzio
insmod part_msdos
insmod ext2
set root=(hd0,8)
chainloader +1
}
```

#### Submenus

Crear un submenú es tan sencillo como englobar todos los menuentry que desees dentro de los claudators    de un submenú.

```bash
submenu 'submenu mini' {
	menuentry 'fed 1 min' {
	....
	}
	menuentry 'fed 1 min rescue' {
	....
	}
}
```



#### Contraseña grub

**Parámetros  de grub**

definir superusuario

```bash 
set superusers="master"
password master 12345
```



Definir usuarios extra

```bash
password jane 123
password peter 321
```



Encriptar contraseña

```bash
# grub2
sudo grub2-mkpasswd-pbkdf2
# grub
sudo grub-mkpasswd-pbkdf2
```



Definir parámetros dentro del menuentry

```bash
 --unrestricted  (no demana cap contrasenya)
 --users jane (només pot iniciar l’usuari jane)
 --users jane,peter (només poden iniciar els usuaris jane i peter)
 “No posem res” (només el superuser pot iniciar)
```



ejemplo grub.cfg

```bash
########################
set superusers="root"
password root "root"
password jorge "jorge"

# contraseña encriptada
password_pbkdf2 debian grub.pbkdf2.sha512.10000.7D616BB6FF7F0A69226417E3EDC25AA$
#####################


#####################
# pueden entrar todos
menuentry 'Debian GNU/Linux' --users unrestricted --class debian --class gnu-linux --$

# pueden entrar debian
menuentry 'Debian GNU/Linux' --users debian --class debian --class gnu-linux --$

# pueden entrar debian y jorge
menuentry 'Debian GNU/Linux' --users debian,jorge --class debian --class gnu-linux --$

# pueden entrar solo superuser
menuentry 'Debian GNU/Linux' --class debian --class gnu-linux --$
```



Todos estos cambios se perderán al hacer **grub2-mkconfig -o /boot/grub2/grub.cfg**



Si queremos que sean permanentes hay que modificar las plantillas del grub

Si o esta el siguiente archivo crearlo

***/etc/grub.d/01_users***

```bash
#!/bin/sh
cat << EOF
set superusers="root"
password root "root"
password debian "debian"
EOF
```



***/etc/grub.d/10_linux***

```bash
...
CLASS="--class gnu-linux --class gnu --class os --users debian"
...
```



buscar fila siguiente y añadir user o la opción que os guste

  Executar:

- grub2-mkconfig -o /boot/grub2/grub.cfg



Al generar el grub añadirá lo indicado en los archivos anteriores

```bash
### BEGIN /etc/grub.d/01_users ###
set superusers="root"
password root "root"
password debian "debian"
### END /etc/grub.d/01_users ###
```

