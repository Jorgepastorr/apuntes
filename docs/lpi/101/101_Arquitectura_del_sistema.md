# 101 Arquitectura del sistema



## Selección y configuración del hardaware



**IRQ**: Es una señal que se envía a la CPU para  que gestione una petición de hardaware (ratón, teclado, etc...). Se muestran en `/proc/interrupts`

**DMA**:  ( Direct Memory Acces ) El dispositivo puede acceder a bloques de memoria sin que sea necesaria la CPU. Fichero: `/proc/dma`

**Direcciones E/S:** Trozos de memoria para los dispositivos se comuniquen con la CPU. fichero: `/proc/ioports`

**coldplug/hotplug**: Son los dispositivos que se tienden a conectar en frío o en caliente.

**Sysfs**: Es un sistema virtual de ficheros que se encuentra en `/sys/`, donde puede acceder a información sobre los dispositivos.

**D-Bus**: Permite que los procesos se comuniquen y se notifiquen eventos. ( por ejemplo, se a conectado un USB)

**udev**: Es responsable de la identificación y configuración de los dispositivos. Es un sistema de archivos virtual en `/dev/` donde se crearán o eliminaran ficheros que representan dispositivos según estén disponibles o no.



- **/proc** El  sistema de archivos `/proc`  almacena información de procesos activos en el sistema

- **/sys** El sistema de archivos virtual  `/sys` es creado para desaogar a `/proc`  y dividir la información dejando a `/sys`  solamente la información sobre los dispositivos.

- **/dev** El sistema de archivos `/dev` hace referencia a los dispositivos según esten disponibles



Comandos de gestión hardware:

**lspci**: muestra información sobre los buses PCI y los dispositivos que tienen conectados

```bash
-v -vv	# vervose
-s [[[[<domain>]:]<bus>]:][<slot>][.[<func>]] # información solo del dispositivo seleccionado
-b 	# muestra todos los numeros y direcciones IRQ
-t	# muestra diagram de todos los buses, bridges y devices
```



```bash
➜ lspci -v -s 06:00.0 
06:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Redwood PRO [Radeon HD 5550/5570/5630/6510/6610/7570] (prog-if 00 [VGA controller])
	Subsystem: PC Partner Limited / Sapphire Technology Radeon HD 5570
	Flags: bus master, fast devsel, latency 0, IRQ 74
	Memory at e0000000 (64-bit, prefetchable) [size=256M]
	Memory at fe920000 (64-bit, non-prefetchable) [size=128K]
	I/O ports at e000 [size=256]
	Expansion ROM at 000c0000 [disabled] [size=128K]
	Capabilities: <access denied>
	Kernel driver in use: radeon
	Kernel modules: radeon
```



**lsusb**: muestra información sobre los buses y dispositivos usb conectados

`-v, -vv, -s, -t`  igual que lspci muestra en arbol y velocidad del usb`-t`

```bash
➜ lsusb -t
/:  Bus 04.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/4p, 5000M
/:  Bus 03.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/4p, 480M
/:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/4p, 10000M
/:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/10p, 480M
    |__ Port 6: Dev 2, If 0, Class=Human Interface Device, Driver=usbhid, 1.5M
    |__ Port 7: Dev 3, If 0, Class=Vendor Specific Class, Driver=rt2800usb, 480M
```



### Modulos

Los modulos son partes del kernel que podemos activar o desactivar para añadir o quitar funcionalidades. tiene una relación muy estrecha con los driver

Son archivos terminados con la extensión `.ko` que se almacenan en `/lib/modules/version_del_kernel/`



```bash
lsmod	# muestra moddulos cargados en el sistema
modinfo	# aplia informacion del modulo
insmod	# carga un fichero .ko en nel sistema
rmmod 	# quita un modulo
	-w	# espera a que deje de utilizarse
	-f	# fuerza el borrado

# actualizacion de los anteriores
modprobe # carga y resuelve dependencias
	-f 	# fuerza la carga del modulo aun que no sea la version correspondiente.
	-r  # elimina modulo
	-v 	# muestra información adicional de lo que realiza
	-n 	# hace una simulación
```

Los modulos tienen opciones personalizables que podemos observar con `modinfo -p modulo`  para hacer estas opciones persistentes se crea un archivo de configuración en `/etc/modprobe.d/module-name.conf`

```bash
$ cat /etc/modprobe.d/mdadm.conf
# mdadm module configuration file
options md_mod start_ro=1
```

Si un módulo está causando problemas, el archivo `/etc/modprobe.d/blacklist.conf` puede usarse para bloquear la carga del módulo. Por ejemplo, para evitar la carga automática del módulo `nouveau`, la línea `blacklist nouveau` debe agregarse al archivo `/etc/modprobe.d/blacklist.conf`.



## Arranque del sistema



**BIOS** Basic Input/Output System. Es un Firmware en ROM ( o PROM )

Su dos partes  fundamentales:

- Setup: Para configurar las opciones. 
- POST: Revisa que funcionen los componentes principales para poder arrancar.



**UEFI** Unified Extensible Firmware Interface

- Compatibilidad y emulación del BIOS
- Soporte para tabla de particiones GUID (GPT)
- Capacidad de gestionar y arrancar desde unidades de almacenamiento grandes ( MBR no soporta más de 2 TB )
- Entorno amigable y flexible, incluyendo capacidades de red.
- Diseño modular
- Opción de arranque seguro ( Secure Boot )



### Funcionamiento del arranque

- Al encender el PC se ejecuta el firmware de la BIOS o UEFI
- El POST comprueba que el hardware básico esté bien
- Se busca un cargador de arranque por orden en las unidades que hayamos indicado en la secuencia de arranque del setup
- Si es BIOS se lee el primer sector de la unidad (MBR) donde se encuentra el código para buscar el gestor de arranque
- Si es UEFI se ejecuta el gestor de arranque que se encuentra en una partición especial (ESP)



### MBR y GPT

**MBR** (Master boot record)

- se encuentra en el primer sector del disco
- Contiene una tabla de solo 4 particiones primarias
  - Primaria, extendida o lógica
- No es capaz de manejar particiones de más de 2TB

**GPT**  (GUID Partition Table)

- Es compatible con MBR
- No funciona con BIOS, necesita EFI o UEFI
- Soporta tamaños de disco de hasta 9,4 zettabytes
- Puede gestionar todas las particiones que soporte el Sistema Operativo ( normalmente 128)
- Gestiona mejor el arranque del S.O.



### Proceso de inicio

- BIOS > MBR > lilo/grub/grub2   o   UEFI > lilo/grub/grub2
- Arranque del kernel
- inicio de Init, proceso numero 1 que es el primero en una larga lista de demonios etc...



Podemos encontrar tres tipos de procesos encargados de iniciar y gestionar los servicios o demonios de entorno Linux:

**SysVinit** Un administrador de servicios basado en el estándar SysVinit controla  qué demonios y recursos estarán disponibles empleando el concepto de *runlevels* 

**Systemd** Desde 2015, las principales distribuciones lo han adoptado como su sistema de inicio. Agrupa los servicios en `target` en lugar de runlevel, estableciendo en ellos dependencias y el orden de ejecución de los procesos.

**Upstar** Utiliza eventos para gestionar el arranque o parada de los procesos.



#### SysVinit

- El fichero `/etc/inittab` tiene la configuración básica como el nivel de ejecución por defecto y las acciones a tomar en determinadas situaciones.
- Se definen niveles de ejecución y qué se hará en cada uno de ellos en el directorio `/etc/rcN.d`  `N` es el número de ejecución, este directorio directorio esta formado por difrentes archivos de dominios los cuales muchos sonm enlaces a `/etc/init.d` que es donde se encuentran los dominios.
- **rc** ejecuta los ficheros que hay en el directorio `/etc/rcN.d/` por orden numérico (siendo **N** el nivel de ejecución). Estos ficheros serán enlaces que empiezan por **S** o **K** y que apuntan a script que están en `/etc/init.d/`
- Si el enlace empieza por **S, rc** le pasará el comando **start** y si empieza por **K** le pasará **stop**



comandos

- **runlevel** indica el nivel de ejecucion actual
- **init o telinit** cambia de un nivel de ejecución a otro
- **update-rc.d** establece los script que se inician en cada nivel.

```bash
# sintaxis: update-rc.d  script enable/disable  level/s
update-rc.d  mi-servicio enable 2

telinit 
  1, s, S	# Entrar modo rescate
  q, Q      # recargar configuración del demonio /etc/inttab 
  u, U      # reejecutar el demonio
```



#### Systemd

- Se ejecuta un único programa que utilizará ficheros de configuración para cada servicio a gestionar
- utiliza **unidades** que pueden ser de diversos tipos: automont, devices, mount, path, service, snapshot, socket y target.
- Los services se agrupan en target, donde también podemos definir el orden de ejecución y las dependencias con otros target o services. Son los equivalentes a los runlevels en SysVinit
- Cada unidad se define en un fichero con el nombre de dicha unidad y en la extensión se indica el tipo de unidad, por ejemplo **ssh.service** 
- Estos ficheros pueden estar en distintos directorios como: `/usr/lib/systemd/system/`, `/lib/systemd/system/` o `/etc/systemd/system/`

| unidad    | descripcion                                                  |
| --------- | ------------------------------------------------------------ |
| service   | El tipo de unidad más común, para recursos activos del sistema que se pueden iniciar, interrumpir y recargar. |
| socket    | El tipo de unidad de socket puede ser un socket de sistema de archivos o un socket de red. Todas las unidades de socket tienen una unidad de  servicio correspondiente, cargada cuando el socket recibe una solicitud. |
| device    | Una unidad de dispositivo está asociada con un dispositivo de hardware identificado por el núcleo. |
| mount     | Una unidad de montaje es una definición de punto de montaje en el sistema de archivos, similar a una entrada en `/etc/fstab`. |
| automount | Una unidad de montaje automático también es una definición de punto de  montaje en el sistema de archivos, pero se monta automáticamente. |
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
```



#### Upstart

Los scripts de inicialización utilizados por Upstart se encuentran en el directorio `/etc/init/`. Los servicios del sistema se pueden enumerar con el comando `initctl list`, que también muestra el estado actual de los servicios y, si está disponible, su número PID.

```bash
# initctl list
avahi-cups-reload stop/waiting
avahi-daemon start/running, process 1123
mountall-net stop/waiting
...
```

Cada acción de Upstart tiene su propio comando independiente. 

```bash
# start tty6

# status tty6
tty6 start/running, process 3282

# stop tty6
```

Upstart no usa el archivo `/etc/inittab` para definir los niveles de ejecución, pero los comandos heredados `runlevel` y `telinit` todavía pueden usarse para verificar y alternar entre los niveles de ejecución.

> Upstart fue desarrollado para la distribución Ubuntu Linux para ayudar a facilitar el inicio paralelo de los procesos. Ubuntu ha dejado de usar  Upstart desde 2015 cuando cambió de Upstart a systemd.





#### Logs del sistema

##### journalctl

Es la manera que tiene Systemctl de consultar los logs del sistema

- **-S -U**: permite especificar desde (since) y/o  hasta cuando (until)
  - YYYY-MM-DD [ HH:MM:SS], yesterday, today, tomorrow, N day ago, - / + NhMmin (-1h15min)
- **-u** unit: mensage de una unidad en concreto
- **-k** : mensajes del kernel
- **-p** por tipo ( emerg, alert, crit, err, warning, notice, info, debug )
- PARAM=VALUE : parametros como `_PID, _UID, _COMM`  ( man systemd.journal-fields )
- **-D --directory** leer un archivo de log de journal



```bash
sudo journalctl

# filtrar entre dias, o horas
sudo journalctl -S 2021-02-14 -U 2021-02-16
sudo journalctl -S today
sudo journalctl -S yesterday
sudo journalctl -S '2 day ago'
sudo journalctl -S -1h10min

# filtrar por servicio
sudo journalctl -u networking.service

# logs del kernel
sudo journalctl -k

# filtrar po tipo de alerta
sudo journalctl -p err
sudo journalctl -p warning
sudo journalctl -p emerg
sudo journalctl -p alert
sudo journalctl -p info

# filtrar por parametro
sudo journalctl _COMM=anacron
sudo journalctl _UID=1000

# filtrar los ultimos logs, con una corta esplicación
sudo journalctl -xe

# leer logs de un directorio alternativo
sudo journalctl --directory /mnt/var/log/journal
```



##### dmesg

Al arrancar el sistema se muestran mensajes según se van cargando controladores o funciones del sistema. para revisarlos se usa **dmesg**

- **-T** Muestra las marcas de tiempo mas claramente
- **-k** solo mensajes del kernel
- **-l** filtra por niveles  de aviso ( warn, err, etc...)
- **-H**  salida para lectura humana, es equivalnte a `dmesg | less`

Este comando es equivalente a `journalctl -b -k`



#### Initramfs

Initramfs ( initial ram file system)


Es el sistema de archivos ram inicial (ramdisk). Es un archivo comprimido normalmente en formato gzip que contiene un pequeño **sistema de archivos que se cargará en la memoria RAM en el proceso de arranque** del núcleo.

El kernel lo necesita para completar tareas relacionadas con módulos y controladores de dispositivos antes de poder arrancar el verdadero sistema de archivos raíz instalado en el disco duro e invocar al proceso init.

En el fichero de configuración del GRUB figura una linea como esta:
`	initrd	/boot/initrd.img-4.19.0-14-amd64`



#### /proc/cmdline

En este archivo se registran los argumentos que sde le han añadido al kernel en el arranque, así que se puede describir como log.



## Apagado del sistema

Desde el terminal tenemos diferentes opciones para el apagado del sistema.

- **shutdown**: apaga el sistema de forma planificada
- **halt**: apaga el sistema sin enviar señal ACPI de apagado  de alimntación electrica
- **poweroff**: apaga el sistema con señal ACPI
- **reboot**: reinicia el sistema



| Reiniciar      | reboot   | shutdown -r | halt --reboot |
| -------------- | -------- | ----------- | ------------- |
| Cerrar sistema | halt     | shutdown -H | reboot --halt |
| Apagar         | poweroff | shutdown -P | halt -p       |

Aún que hay diferentes comandos para gestional el apagado, en realidad todos son enlaces a systemctl con diferentes opciones a pasar.

```bash
➜  ~ ll /sbin/* | grep systemctl
lrwxrwxrwx 1 root root     14 ene 29 15:16 /sbin/halt -> /bin/systemctl
lrwxrwxrwx 1 root root     14 ene 29 15:16 /sbin/poweroff -> /bin/systemctl
lrwxrwxrwx 1 root root     14 ene 29 15:16 /sbin/reboot -> /bin/systemctl
lrwxrwxrwx 1 root root     14 ene 29 15:16 /sbin/runlevel -> /bin/systemctl
lrwxrwxrwx 1 root root     14 ene 29 15:16 /sbin/shutdown -> /bin/systemctl
lrwxrwxrwx 1 root root     14 ene 29 15:16 /sbin/telinit -> /bin/systemctl
```



**shutdown** [opcion] TIEMPO [mensaje]

El tiempo se puede expresar en horas y minutos (**HH:MM**), en minutos que faltan para el apagado: **+M**  o con la palabra **now**

```bash
shutdown +5 "El  sistema se apagara en 5 minutos"
shutdown -c
```



### Mensajes

En ocasiones puede que esten varios usuarios conectados a un servidor y el reinicio o apagado del mismo se tiene que avisar para no entorpecer la faena del compañero, en ese caso se envian mensajes con `wall` 

```bash
wall "Recordatorio que el servidor se apagará en 5 minutos"
```

**mesg** gestiona la admision de recepcion de mensajes: y (si) n (no), esto solo es valorable con mensajes de otros usuarios, ya que si root envia un mensaje se recibira de todas formas.  

