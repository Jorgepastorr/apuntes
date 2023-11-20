# 200 Planificación de la capacidad



## 200.1Medir y solucionar problemas relacionados con la utilización de recursos



### Gestión de los recursos

El administrador del sistema debe ser capaz de identificar los recursos disponibles para el sistema y controlar su uso por parte del sistema y de las aplicaciones

Principales tipos de recursos:

- El proceso de lo procesos
- La memoria RAM
- El espacio de almacenamiento
- La red



#### Fuentes de información sobre los recursos

Para  poder cuantificar cada tipo de recurso y controlar en tiempo real su uso. Linux proporciona diferentes fuentes de información, que son interfaces de comunicación con el núcleo, comandos o archivos de registro.

##### Pseudosistemas de archivos procfs y sysfs

Los pseudosistemas de archivos **procfs** y **sysfs** (también llamados **proc** y **sys**). Se trata de una interfaz, en forma de árbol de directorios y de archivos especiales, gestionada por el núcleo.

```bash
➜ mount                     
sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
...
```

El pseudosistema de archivos **sysfs** permite la gestión unificada de los bus, controladores y dispositivos desde una arborescencia virtual. Sobre todo lo utilizan los controladores de dispositivos y aplicaciones especializadas.

El directorio `/proc` contiene todos los procesos del sistema entre otras caracteristicas

```bash
/proc/sys		# Información general sobre los recursos de la máquina y de su uso.
/proc/version 	# version del nucleo
/proc/sys		# configuración del nucleo (algunos se pueden modificar dinamicamnte)

/proc/1*			# procesos del sistema
/proc/2700/cmdline	# comando ejecutado
/proc/2700/environ	# variables de entorno
/proc/2700/fd		# info archivos abiertos
/proc/2700/fd/3		
/proc/2700/status	# info estado del proceso
```

> Muchos de clos archivos dentro de `/proc` se pueden modificar, pero esta información se perdera al reiniciar



##### Los registros del sistema

El sistema y las aplicaciones utilizan los servicios de un demonio de gestión de registros, **syslogd** (o uno de sus derivados).

**udev**: Es responsable de la identificación y configuración de los dispositivos en el arranque del sistema. En el arranque muestra en consola el informe y lo almacena en memoria. 

Es un sistema de archivos virtual en `/dev/` donde se crearán o eliminaran ficheros que representan dispositivos según estén disponibles o no.



##### Comandos de control instantáneo

`ps` y sus derivados

```bash
ps		# visualizar
pstree	 # visualizar en arbol
pgrep	# visualizar pid y nombre
pidof	# visualizar pid de proceso
```

`top` herramienta interactiva para gestion de procesos en tiempo real

El paquete `sysstat` proporciona diferentes herramientas

```bash
mpstat			# rendimiento del systema
mpstat -P ALL	# rendimieno de todas las CPU
pidstat			# rendimiento de cada proceso, simil a top
pidstat -C "mysql"	# filtrar por un proceso
pidstat -t -C "mysql"	# modo arbol
pidstat -C "mysql" -d	# rendimiento de proces en disco
iostat	# rendimiento de discos
```

Herramientas graficas:

- Monitor del systema
- `collectd` demonio que utiliza un website para mostrar los recursos del sistema



#### Seguimiento y control de recursos del procesador

Los recursos del procesador de la máquina permiten gestionar correctamente las aplicaciones, ejecutando el código con un rendimiento satisfactorio.

Para ello es preciso que la **potencia del prodesador** sea suficiente y que las colas de **acceso al procesador** no sean muy grandes.



##### Información sobre los recursos del procesador

`/proc/cpuinfo` Muestra el número y tipo de procesadores. También es posible ver esta información desde `dmesg` o el monitor del sistema.



##### Uso de los recursos del procesador

El comando `ps` 

```bash
ps 
-u [user o UID] # procesos de un usuario
-t[0-9] # procesos conectados tty indicada
-l 	# visualización larga
-w	# visualización detallada
-e	# todos los procesos

U Users	# procesos de un usuario
a	# procesos asociados a terminal
x	# procesos desasociados
l	# visualización larga
u	# visualización larga, usuario
aux # opcion mas usual  

pstree -ps <num proceso>  
-p  # proceso
-s  # arbol  
-a  # mostrar todo sin agrupaciones
```

El comando **top** (o cualquiera de sus variantes) permite controlar a intervalos regulares la evolución de los procesos y el consumo de recursos del sistema 

```bash
top -hv|-bcHisS -d tiempo -n límite -u|U user -p PIDs -w [columnas]
```

El comando `strace` permite visualizar todas las lamadas al sistema que produce un proceso.

```bash
strace comando [arg ...]
strace -p pid

strace ls -l /etc/hosts
strace -p 3879 
```



#### Seguimiento y control de la memoria

**Información sobre la memoria**

```bash
/proc/meminfo	# inf en tiempo real de la memoria
# info de swap
swapon -s	# deprecated
/proc/swaps	
swapon --show
```



**Uso de la memora**

```bash
free
-[bkmg] # output del tamaño a mostrar
-h		# formato humano Gi

vmstat 
-S unidad	#  1000 (k), 1024 (K), 1000000 (m), or 1048576 (M) bytes
-s 	# formato tabla
-t N	# timestamps cada Numero de segundos

➜ vmstat -S M 
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd   free  inact active   si   so    bi    bo   in   cs us sy id wa st
 0  0      0   8660   1638   3538    0    0    53    63   64  704 11  3 86  0  0
 
 top -m
 ps -o user,size,rss,pcpu,pmem,vsz,cmd 7222	# datos de memoria de un proceso
 /proc/7222/status	# datos de memoria de un proceso, desde archivo
```



#### Seguimiento y control de recursos en disco

**Información sobre recursos de discos**

```bash
fdisk -l		
fdisk /dev/sda
gdisk /dev/sda
lsusb	# detectar dispositivos usb

# deteccion de discos desde archivos
/sys/block	# su contenido es un link al lugar pinchado en la placa	
sda -> ../devices/pci0000:00/0000:00:01.3/0000:01:00.1/ata1/host0/target0:0:0/0:0:0:0/block/sda
/sys/block/sda/size

/proc/partitions	# particiones detectadas
```

**smartdmontools**  instala herramientas muy potentes de control de los recursos de los discos. 

Su archivo de configuración generalmente es `/etc/smartd.conf` (y `/etc/default/smartmontools` para configurar el arranque en el caso de una distribución Debian).

Una vez arrancado, el demonio controla los discos que ha detectado y envía mensajes al superusuario en caso de que encuentre algún problema.

```bash
smartctl [opciones] disco 
--scan		# Detecta los discos.
-a disco	# Toda la información sobre el disco.
-i disco	# Información sobre el disco (modelo, n.º de serie, etc.).
-H disco	# Información sobre el estado de fiabilidad (Health) del disco. Si indica que el disco tiene algún problema, hay que hacer una copia de seguridad de los datos con urgencia y preparar su sustitución.
-c disco			# Información sobre la capacidad de supervisión SMART del disco.
-l error disco		# Mensajes de logs de tipo error del disco.
-t tipo disco		# Realiza un autotest del disco en modo tipo (short, long...).
-l selftest disco	# Resultados del autotest del disco.
```



**Utilización de los recursos de los discos**

Hay numerosos comandos que permiten seguir en tiempo real el consumo de los recursos de disco por parte del sistema y de las aplicaciones.

`Iostat` Este comando proporciona información sobre la actividad de los discos desde el arranque. forma parte del paquete `sysstat`

```bash
iostat
-h
5 3 # hacer tres mediciones en intervalos de 5 segundos

$ iostat
Linux 4.19.0-16-amd64 (pc02) 	10/06/21 	_x86_64_	(12 CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          12,41    0,02    3,67    0,06    0,00   83,84

Device             tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda               3,00        24,38        41,33    3031787    5140389
sdb               0,00         0,05         0,00       6405         24
```



`iotop`  Este comando, incluido en el paquete **iotop**, muestra la actividad de los discos proceso por proceso.

```bash
iotop # programa interactivo
```



`lsof`  Este comando proporciona la lista de los archivos abiertos.

```bash
lsof	# todos los archivos abiertos del sistema
lsof /dev/sda1		# archivos abiertos en sda1
lsof /etc/passwd	# comprovar que ese archivo est abierto
lsof -u user	# archivos abiertos de user
lsof -i			# todos los sockets abiertos
```



#### Seguimiento y control de los recursos de red

**Información sobre los recursos** 

```bash
ifconfig
ip
lspci
```

El directorio `/proc/net` contiene archivos especiales que proporcionan información sobre la actividad de red.

```bash
/proc/net
/proc/net/dev	# actividad de interfaces
/proc/net/arp	# tabla arp
/proc/net/sockstat	# sockets en red
```

`/proc/sys/net/ipv4` directorio que contiene archivos especiales de lectura /escritura que permiten modificar dinámicamente la configuración de red del núcleo.



**Control y diagnostico de los recursos en red**

```bash
netstat
ip
traceroute
ss

netstat
-t	# conexiones tcp
-u	# conexiones udp
-6|-4	# ipv4 o ipv6
-l	# puestos a la escucha
-p	# nombre del programa
-n	# no hacer resolucion de nombres
-r	# ver tabla de enrutamiento

ss [options] [filter]
-t	# conexiones tcp
-u	# conexiones udp
-6|-4	# ipv4 o ipv6
-l	# puestos a la escucha
-p	# nombre del programa
-n	# no hacer resolucion de nombres
-r	# intentar hacer resolucion

ip addr show	# mostrar interfaces
ip -c a			# mostrar interfaces con colorines
ip link set enp3s0 up/down	# des/activar interfaz
ip link set dev enp3s0 arp on/of	# des/activar arp
ip addr add 192.168.0.10/24 dev enp3s0	# añadir dirección ip
ip addr del 192.168.0.10/24 dev enp3s0	# eliminar dirección ip

ip route show	# ver tabla enrutamiento
ip route add default via 192.168.1.1	# añadir puerta de enlace
ip route add 10.10.50/24 via 192.168.1.1 dev enp3s0 # añadir ruta
ip route del 10.10.50/24		# eliminar ruta
ip route save > ./route_backup	# hacer backup de tabla enrutamieno
ip route restore < ./route_backup	# resaurar bckup

ip neighbour	# ver tabla arp
```





## 200.2 Predecir la necesidad de futuros recursos

### Planificación de los recursos

`sysstat`   proporciona un conjunto de herramientas de control del estado de los recursos gestionados por el sistema.

Una vez se ha instalado el paquete, hay que configurarlo para que la herramienta **sysstat** recoja la información a intervalos regulares.

```bash
/etc/default/sysstat (Enabled true) # debian
/etc/sysconfig/sysstat # redhad
```

La recogida de información se inicia mediante una tarea cron `/etc/cron.d/sysstat` y guarda la información en `/var/log/sysstat o /var/log/sa` 

```bash
sar	# uso del systema cpu
sar 3 5 # 5 consultas en intervalos de 3 segundos
sar -r 	# uso de la memoria
sar -b 	# uso de discos
sar -A	# toda la info recogida (demasiada)
sar -s desde -e hasta	# limitr el periodo a controlar
sar -r -s 14:30.00 -e 14:50:00
sar -f file # especificar file donde recoger los datos
```



`collectd`  es un programa open source de recogida de datos de la actividad del sistema. Se trata de un demonio que mide a intervalos regulares (10 segundos por defecto) los valores de diferentes ordenadores que reflejan el rendimiento del sistema y los guarda en archivos.

collectd no permite explotar la información obtenida, pero puede producir archivos de recogida en diferentes formatos estándar que se pueden abrir con aplicaciones de presentación de datos.

```bash
/etc/collectd.conf
/etc/collectd/collectd.conf
/var/lib/collectd/rrd	# directorio de salida de datos
```

**collectd** no puede utilizar directamente la información obtenida. Así pues, hay que visualizarla con aplicaciones de presentación de datos o software específico. Se pueden generar gráficos o tablas mediante programas como **RRDtool**, **kcollectd** o **drraw**, o mediante programas específicos que utilizan bibliotecas especializadas (Python, Perl, C, Java…).

```bash
/usr/share/doc/collectd/examples # ejemplos scripts para generar graficos
```

