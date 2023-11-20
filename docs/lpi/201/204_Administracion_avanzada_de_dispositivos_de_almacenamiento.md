# 204 Administración avanzada de dispositivos de almacenamiento



## 204.1 Configuración RAID



### Tipos de raid

**Firmware** El modo de raid firmware es el raid basado en la BIOS, la propia BIOS tiene su controladora para gestionar la raid .

**Hardware** El modo Hardware, consiste en una tarjeta pinchada en la placa que controla la raid.

**Software** El modo Software es el propio sistema operativo que gestiona la raid.



**Principales niveles de raid**

`RAID 0` tiene como único objetivo la rapidez de acceso a los datos y no gestiona de modo alguno la tolerancia a los fallos. El espacio utilizable en un volumen RAID 0 es igual a la suma de los espacios de disco utilizados.

`RAID 1`, al contrario que RAID 0, no busca en ningún caso mejorar el rendimiento, sino únicamente asegurar los datos.  El espacio utilizable en un volumen RAID 1 es igual al espacio disponible en un solo disco.

`RAID 5` reúne las ventajas de RAID 0 y de RAID 1. Hay que disponer de al menos 3 discos para configurarlo. El espacio explotable en un volumen RAID 5 es igual a la suma de los espacios de disco usados menos uno y menos un posible disco de reserva (spare).

`RAID 10`  Son dos raid 1 unidas por una raid 0 , nivel de seguridad alto 1  disco por mirror pero se reduce la capacidad total de almacenamiento al  50% total.

`RAID 50` Dos raid 5 unidas por raid 0 velocidad excelente de lectura con nivel de seguridad alto de 2 discos de fallo.



| Nivel | nº discos | nº discos que pueden fallar | capacidad | capacidad leer y escribir |
| ----- | --------- | --------------------------- | --------- | ------------------------- |
| R0    | 2         | 0                           | 100%      | excelente                 |
| R1    | 2 max     | 1                           | 50%       | L.MuyBuena / E.Buena      |
| R5    | 3 min     | 1                           | 67% - 94% | L.Muy buena / E.Buena     |
| R6    | 4 min     | 2                           | 50% - 88% | L.Buena / E.Buena         |
| R10   | 4 min     | 1 por cada mirror           | 50%       | L.Muy buena / E.Buena     |
| R50   | 6 min     | 1 por cada mirror           | 67% - 94% | L.Excelente / E.Muy buena |
| R60   | 8 min     | 2 por cada mirror           | 50% - 88% | L.Muy buena / E.Buena     |



### Configurar raid

la gestión de los Raid se hace mediante vla orden `mdadm`  tiene su configuración, especialmente el orden de escaneo de todas las particiones encontradas en /proc/partitions, en su archivo de configuración /etc/mdadm/mdadm.conf.

```bash
mdadm acción volumen -l nivel -n número_de_discos almacenes 
-C	# crear volumen raid
-S	# desactivar volumen

# crear raid
mdadm --create /dev/md0  --level=1 --raid-devices=3 /dev/loop0 /dev/loop1 /dev/loop2
mdadm  --create /dev/md/dades  --level=1 --raid-devices=2 /dev/loop0 /dev/loop1 --spare-devices=2 /dev/loop2 /dev/loop3

# estado del raid
sudo mdadm --detail /dev/md0 # ver estado del raid
sudo mdadm --detail --scan  # ver si existe alguna raid
sudo mdadm --examine /dev/loop0  # ver datos del bloque raid en disco
sudo mdadm --query /dev/loop0 
sudo mdadm --query /dev/md0
cat /proc/mdstat # ver estado de raid

# Extraer disco
sudo mdadm /dev/md0 --fail /dev/loop1
sudo mdadm /dev/md0 --remove /dev/loop1

# Añadir disco
sudo mdadm --manage /dev/md0 --add /dev/loop1

# Añadir disco spare
sudo mdadm /dev/md0 --add-spare /dev/loop2

# Parar Raid
sudo mdadm --stop /dev/md0 # parar raid  md0
sudo mdadm --stop --scan # para todas las raid

# guardar raid
sudo mdadm --examine --scan > /etc/mdadm.conf

# recontruir raid
mdadm --assemble --scan # automatico, si existe /etc/mdadm.conf no escaneara todos los discos.
mdadm --assemble /dev/md0 --run /dev/loop0 /dev/loop1 /dev/loop2 # indicando discos
mdadm --assemble /dev/md0 # siempre que exista el archivo /etc/mdadm.conf y este md0 dentro

# limpiar superbloque
sudo mdadm --zero-superblock /dev/loop0

# aumentar discos en raid añadiendo uno
sudo mdadm --grow /dev/md/raid1 --raid-devices 3 --add /dev/loop2  
```





## 204.2 Ajustar acceso dispositivos almacenamiento

## 204.3 Gestor de volumenes LVM

El sistema de particionamiento tradicional de los discos impone ciertas restricciones, tales como un número máximo de 4 particiones o el carácter obligatoriamente contiguo del espacio particionado.

Los volúmenes lógicos permiten crear un número ilimitado de volúmenes y extenderlos a voluntad, incluso a partir de espacios de almacenamiento que se encuentran en discos y controladoras distintos.



`PV` (phisical volume) Se refiere a particiones en un disco real.

`VG` (volum group) Discos virtuales que crea lvm partiendo de x numero de particiones PV.

`LV` (logical volum) Particiones del disco virtual de las que montaremos nuestros datos.

```bash
# display
lsblk # para ver nuestros discos
sudo pvs # ver volumens fisicos
sudo pvdisplay
sudo vgs # ver discos virtuales
sudo vgdisplay
sudo lvs # ver particiones logicas
sudo lvdisplay

# accion
sudo pvcreate /dev/<disco> # crear volumen fisico
sudo vgcreate <nombre de grupo> /dev/<disco>... # crear disco virtual

# crear  particion logica
sudo lvcreate -L +<tamaño que quieres 200M> -n <nombre partición> <grupo VG a asignar>
# Si quieres todo el espacio del disco 
sudo lvcreate -l <tamaño que quieres 100%free> -n <nombre partición> <grupo VG a asignar>

sudo mkfs.ext4 /dev/<grupo>/<partición> # formatear partición
sudo mount /dev/<grupo>/<partición> /mnt # montar

sudo vgextend <grupo> /dev/<disco> # añadir PV a disco virtual
sudo lvextend -L +<tamaño a aumentar M,G> /dev/<grupo>/<partición> # extender particion logica
# Si queremos aumentar a todo el disco disponible
sudo lvextend -l +100%free /dev/<grupo>/<partición>           

# aumentar el sistema de ficheros al completo de la partición
sudo resize2fs /dev/<grupo>/<partición>  # en modo ext4
sudo xfs_growfs /dev/<grupo>/<partición>  # en modo xfs                                   

# reducir
sudo e2fsck -f /dev/<grupo>/<partición> # reducir fs solo en ext algo 2,3,4 
sudo resize2fs /dev/<grupo>/<partición> <tamaño a reducir (500M)> # reducir fs 
sudo lvresize -L -<tamaño a quitar (500M)> /dev/<grupo>/<partición> # reducir particion logica

# snapshot
lvcreate -L tamaño -s -n nombre_snapshot lv_origen # -s = --snapshot
lvcreate -L 1G -s -n mysnap1 /dev/vg1/data1 
```

