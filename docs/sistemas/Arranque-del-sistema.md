## Arranque del sistema

Anaconda: grub, systemd

### Master Boot Record ( MBR ) 

Es un **registro de arranque maestro** , el primer sector de un dispositivo de almacenamiento de dados, contiene la tabla de particiones primarias del disco, el arranque y la firma de la unidad de arranque. Este registro se esta quedando en desuso, con la actualización al registro UEFI.

**Tabla particiones:**

- índice de la tabla de las particiones primarias del dispositivo.

**Arranque ( bootstrap )**

- proceso de inicio del ordenador, u pequeño programa que arranca el sistema operativo, por ejemplo Grup, Lilo en Gnu/linux y BCD o NTLDR en Windows. En el caso de Grup y similares bootstrap del MBR solo es un acceso (link) a la partición que contiene todo me contenido de grub.

**Información**

- Firma del MBR 2 bytes



### Pasos del arranque

1. **post ( decectar hardware )** 

- Autoprueba el arranque, testea todo el harware conectado a la placa madre, en caso de error emite sonidos como código de error.

2. **bios** 

- El propósito fundamental del BIOS es iniciar y probar el *hardware* del sistema y cargar un gestor de arranque.

3. **setup ( prioridad de arranque ), hda, cdrom, red, etc..** 

- fallback ( pasar siguiente opción en caso de fallo )

4. **disco hda -> mbr ->**  

   - antes tabla de particiones activa
   - ahora boot loader: Grub 

5. **grub de mbr carga grub de particion x**   

   - Muestra el menú de opciones de arranque

   - carga kernel

   - carga initramfs

6. **systemd ( antes initd )** 

   La mejora de systemd respecto a initd es que trabaja con concurencia, todos los módulos se encieden a la vez y se esperan si dependen de otro para iniciarse. Esto mejora el rendimiento de arranque.

   - arranca módulos necesarios



>  `systemd-analyze blame` muestra el tiempo que a tardado en arrancar cada módulo, muy útil para detectar problemas de arranque. 



### Grub

Instalar grub en el mbr

```
grub2-install /dev/sda # link de mbr apunte a partición actual

# link del mbr apunte a partición montada en /mnt
grub2-install --boot-directory=/mnt/boot /dev/sda 
```

Leer sistemas operativos instalados en el sistema y generar grub.cfg

```bash
grub2-mkconfig -o /boot/grub2/grub.cfg
```

#### Edición grub

Al generar un *grub.cfg* en cada entrada lo importante para arrancar son las siguientes lineas:

-  `insmod`para cargar los módulos necesarios.
-  `set root` ruta de disco y partición donde buscar archivos.
-  `linux16, initrd16` cargar kernel en partición indicada y ramdisk

``` bash
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

##### Submenus

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



Parámetros adicionales

```bash
set default=0 # arranca por defecto la primera entrada del menu
set timeout=-1 # tiempo de espera para la entrada por defecto, -1 espera interación
```



#### Sticks de arranque

En el caso que el enlace del bootstrap hasta el directorio /boot funcione pero por alguna razón, no encuentre el archivo grub.cfg, aparecerá el prompt del grub `#grub>` desde el que podemos arrancar el sistema de diferentes maneras. 

1. Tunear una entrada existente de grub

   - El el caso de querer arrancar un sistema que no esta en el grub.cfg.

2. Escribir en modo comando una entrada.

   - Sabiendo donde esta el sistema operativo podemos arrancar escribiendo manualmente los comandos de la edición de grub del apartado anterior.

3. En modo comando llamar a algún fichero grub.cfg de alguna partición existente.

   ```bash
   #grub> configfile (hd0,msdos5)/boot/grub2/grub.cfg
   ```



En el caso del link del mbr a la partición donde se encuentra el directorio grub este roto. Grub no podrá acceder a los módulos, por lo tanto aparecerá `grub rescue>` al arrancar.

La solución indicar en que partición se encuentra los archivos de grub, añadir raiz de destino, y arrancar con el modulo normal.

```bash
grub recue> set prefix=(hd0,msdos5)/boot/grub2
grub recue> set root=(hd0,msdos5)
grub recue> insmod normal
grub recue> normal
```



### Arranque del sistema

Para arrancar el sistema lo realmente necesario es el kernel y la imagen de inicio del sistema.

```bash
linux vmlinuz...  root=/dev/sda1 ro quiet 3
initrd initramfs..img
```

En la linea del kernel se le pasan las opciones de arranque en este caso `ro, quiet, 3`:

- runlevel 1, 3, 5 son los mas habituales  y esta en fase deprecated, siendo substituido por `systemd.unit=nombre`



#### Systemd

Systemd es la actualización de init, este proceso se encarga de arrancar todos los servicios, targets y componentes necesarios para poder trabajar con la terminal. La mejora de systemd respecto a init es que en el  arranque del sistema inicia todos los demonios a la vez y trabajan en paralelo, a esto se le denomina ( concurrencia ).



```bash
system-analyze blame # analizar tiempos de arranque
systemd-analyze dot "basic.target" | dot -Tsvg > /tmp/basic.svg
```


grafico de dependencias

```bash
systemd-analyze dot "basic.target" | dot -Tsvg > /tmp/basic.svg
systemd-analyze dot --to-pattern="*.target" --from-pattern="httpd.service" | dot -Tsvg > /tmp/gpm.svg
```



##### Units

Systemd se configura exclusivamente a trabes de archivos de texto, registra las instrucciones de inicialización para cada daemon en un archivo de configuración (conocido como 'unit file'). 

Estos ficheros de configuración se encuentran en:

- Redhad y derivados: `/usr/lib/systemd/system/`  
- Debian: `/lib/systemd/system/` 


Algunos tipos de units:

```
.service
.target
.socket
.mount
.automount
.path
.slice
.timer
```

Información sobre los units

```bash
systyemctl list-units
systemctl list-unit-files
```

El contenido de estos archivos unit tienen una estructura simple, una descripción, que ejecutar, antes o después de quien voy  si es que dependen de algún otro demonio es lo mas básico.



##### Niveles de arranque

| unit           | systemd                                 | Description                |
| -------------- | --------------------------------------- | -------------------------- |
| `0`            | `runlevel0.target`, `poweroff.target`   | apagar sistema             |
| `1`            | `runlevel1.target`, `rescue.target`     | Modo rescate               |
| `2`            | `runlevel2.target`  `multi-user.target` | rescat con red             |
| `3`            | `runlevel3.target`, `multi-user.target` | Multi usuario sin grafico  |
| `4`            | `runlevel4.target`  `multi-user.target` | custom                     |
| `5`            | `runlevel5.target`, `graphical.target`  | Multi usuario con grafico  |
| `6`            | `runlevel6.target`, `reboot.target`     | apagar y reiniciar sistema |
| init=/bin/bash | `emergency.target`                      | shell root                 |

Por defecto en una máquina de usuario la opción esta indicada en `graphical.target`, lo podemos mirar con.

La opción `init=/bin/bash` y `emergency.target` no son quivalentes ya que emergenci arranca systemd y init solo arranca el kernel y el bash.

```bash
debian  ➜  systemctl get-default
graphical.target
# modificar la opcion por defecto
systemctl set-default multi-user.target
# cambiar al modo rescue
systemctl isolated rescue.target
```

Todos estos target u objetivos, dependen  de diferentes units para su ejecución completa. Para alcanzar el objetivo x hay que arrancar primero n units que son sus dependencias.

```bash
systemctl list-dependencies multi-user.target
```



El directorio targe.wants es el que define la estructura del arranque, es decir para arrancar multi-user tienes que arrancar primero todos los units incluidos en el directorio `multi-user.target.wants`.

```bash
ls /etc/systemd/system/multi-user.target.wants/
abrtd.service
abrt-journal-core.service
abrt-oops.service
abrt-vmcore.service
abrt-xorg.service
atd.service
auditd.service
avahi-daemon.service
chronyd.service
crond.service
cups.path
dbxtool.service
gpm.service
libvirtd.service
mcelog.service
mdmonitor.service
ModemManager.service
NetworkManager.service
nfs-client.target
postgresql.service
remote-fs.target
rngd.service
sssd.service
vmtoolsd.service
```

Son demonios a arrancar en ese target, todos estos archivos que se ven son enlaces simbólicos a `/usr/lib/systemd/system/` , que es realmente donde se encuentra el demonio.







##### Demonios

Los demonios ( servicios ) son programas tipo especial de proceso no interactivo, es decir, que se ejecuta en segundo plano.

Actualmente los demonios se gestionan con `systemctl`  podemos ver si un demonio esta activo o no con `is-active` o si esta habilitado con `is-enable`.

```bash
systemctl is-active httpd
```

Al instalar un demonio crea un archivo unit `.service`dentro de `/usr/lib/systemd/system/` ,en el archivo de configuración .service la opción `wantedby` indica en que objetivo se añadirá al habilitarlo.



###### Archivo de servicio

El archivo de configuración de un demonio denominado *unit file*  con extensión `.service` .

archivo básico:

```bash
[Unit]
Description=Descripcion corta del programa

[Service]
ExecStart=binario o script que ejecuta
PidFile=escrivir un pid para dominarlo

[install]
WantedBy=donde instalarse multi-user.target, rescue.target etc..
```



Existen muchas opciones para este tipo de archivos por ejemplo:

`ExecStop`: que quieres que haga al apagar el servicio.

`RemainAfterExit=true`: una vez ejecutado muestra que esta activo ( esto sirve para ejecuciones que no son continuas )

`Type=oneshot` : se ejecuta solo una vez



Cada vez que modifiquemos algún servicio, objetivo o archivo unit es muy recomendable ejecutar `systemctl daemon-reload` para asegurarse que lee correctamente los demonios.





##### Targets  

Targets son los objetivos que se marca el arranque en el inicio del sistema. Los target guardan su configuración en `/usr/lib/systemd/system/` en archivos `.target` y la lista de unitsa arrancar en ese objetivo se guarda en `/etc/systemd/system/objetivo.target.wants/` .

Ejemplo configuración. 

```bash
[Unit]
Description=Rescue Mode
Documentation=man:systemd.special(7)
Requires=sysinit.target rescue.service
After=sysinit.target rescue.service
AllowIsolate=yes

[Install]
Alias=kbrequest.target
```

- `Requires`:  exige que las opciones indicadas estén activas para iniciarse
- `After`: me tengo que arrancar después de las opciones dadas
- `allowisolate`:  yes, indica si es un punto de sesión, es decir asociado a un target indica al sistema que una vez llegado a este objetivo puede ofrecer una sesión de usuario.











