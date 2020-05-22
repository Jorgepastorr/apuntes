# Lvm logical volum manager

Con LVM podemos re-dimensionar espacios, añadir o quitar discos estando en caliente. De las particiones físicas reales se crean  discos virtuales, y de esos virtuales creas las particiones a utilizar.

**PV**: phisical volume

- Se refiere a particiones en un disco real.

**VG**: volum group

- Discos virtuales que crea lvm partiendo de x numero de particiones PV.

**LV**: logical volum

- Particiones del disco virtual de las que montaremos nuestros datos.

## Ordenes

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
```

## Entorno de Pruebas

Se esta simulando dos discos físicos, que se convertirán en PV y estos formaran un disco virtua VG para jugar con las particiones LV.

```bash
➜  m06 dd if=/dev/zero of=disc1.img bs=1k count=100k
➜  m06 dd if=/dev/zero of=disc2.img bs=1k count=100k
104857600 bytes (105 MB, 100 MiB) copied, 0,154778 s, 677 MB/s

➜  m06 sudo losetup /dev/loop0 disc1.img 
➜  m06 sudo losetup /dev/loop1 disc2.img
➜  m06 sudo losetup -a
/dev/loop1: [2054]:5249112 (/var/tmp/m06/disc2.img)
/dev/loop0: [2054]:5248922 (/var/tmp/m06/disc1.img)
```

## Crear PV

```bash
➜  m06 sudo pvcreate /dev/loop0
  Physical volume "/dev/loop0" successfully created.
➜  m06 sudo pvcreate /dev/loop1
  Physical volume "/dev/loop1" successfully created.

➜  m06 sudo pvdisplay /dev/loop0
  "/dev/loop0" is a new physical volume of "100,00 MiB"
  --- NEW Physical volume ---
  PV Name               /dev/loop0
  VG Name               
  PV Size               100,00 MiB
  Allocatable           NO
  PE Size               0   
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               RqLfk2-OQIg-yH3z-flxD-wNVs-S9SE-omUu5G

# display en formato reducido
➜  m06 sudo pvs /dev/loop0
  PV         VG Fmt  Attr PSize   PFree  
  /dev/loop0    lvm2 ---  100,00m 100,00m
```

## Crear VG

```bash
➜  m06 sudo vgcreate diskedt /dev/loop0 /dev/loop1
  Volume group "diskedt" successfully created

➜  m06 sudo vgdisplay diskedt
  --- Volume group ---
  VG Name               diskedt
  System ID             
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               192,00 MiB
  PE Size               4,00 MiB
  Total PE              48
  Alloc PE / Size       0 / 0   
  Free  PE / Size       48 / 192,00 MiB
  VG UUID               wjjoFH-mOou-7wzb-leiN-ofVX-0Q65-Mw3PRp
```

### PE Unidad mínima de asignación

El PE es el tamaño en que divide los bloques del disco, por cada partición física o disco en este caso perdemos 4MiB que utiliza lvm para su gestión.

Se puede ver como con 2 discos de 100MiB cada uno debería obtener 200MiB y obtengo 192MiB, se pierde 4MiB por cada partición/disco real.

## Crear LV

Al haberse dividido el disco virtual en bloques  de 4MiB se podrá crear particiones lógicas con tamaño múltiple de 4, por ejemplo 148M o 152M, 150M no dejara, automáticamente se añadirá de 152M. 

```bash
➜  m06 sudo lvcreate -L 50M -n sistema /dev/diskedt
  Rounding up size to full physical extent 52,00 MiB
  Logical volume "sistema" created.

➜  m06 sudo lvcreate -l 100%FREE -n dades /dev/diskedt
  Logical volume "dades" created.

➜  m06 sudo lvdisplay /dev/diskedt/sistema
  --- Logical volume ---
  LV Path                /dev/diskedt/sistema
  LV Name                sistema
  VG Name                diskedt
  LV UUID                84OwTh-abyU-SxTZ-1uGT-Qrp7-murD-7eTayk
  LV Write Access        read/write
  LV Creation host, time pc02, 2020-02-03 19:26:09 +0100
  LV Status              available
  # open                 0
  LV Size                52,00 MiB
  Current LE             13
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0
```

Se puede ver como esta partición LV ocupa 52MiB y utiliza 13 bloques "Current LE" . 

`-l 100%FREE` especifica que el tamaño del lv sera el 100% del espacio disponible.

## Estructura

Se puede ver como el VG diskedt contiene dos PV loop0 y loop1, y hay dos LV particiones lógicas en diskedt,  con la gracia que dades se a repartido automáticamente en 2 particiones físicas.

```bash
➜  m06 sudo lsblk   
NAME              MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
loop0               7:0    0   100M  0 loop 
├─diskedt-sistema 253:0    0    52M  0 lvm  
└─diskedt-dades   253:1    0   140M  0 lvm  
loop1               7:1    0   100M  0 loop 
└─diskedt-dades   253:1    0   140M  0 lvm  

➜  m06 sudo lvs
  LV      VG      Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  dades   diskedt -wi-a----- 140,00m                                                    
  sistema diskedt -wi-a-----  52,00m    
```

El matiz es que el sistema ve un disco *diskedt* con 2 particiones *sistema y dades*, y lo que haya por debajo no le importa demasiado.

## Formatear particiones y montar

```bash
➜  m06 sudo mkfs.ext4 /dev/diskedt/dades   
➜  m06 sudo mount /dev/diskedt/dades /mnt/dades 

➜  m06 sudo df -h
S.ficheros                  Tamaño Usados  Disp Uso% Montado en
...
/dev/mapper/diskedt-dades     132M   1,6M  121M   2% /mnt/dades
/dev/mapper/diskedt-sistema    47M   1,1M   42M   3% /mnt/sistema
```

## Añadir disco

Simulo que necesito mas espacio para el sistema y añado un disco físico al pc, y lo añado al disco virtual diskedt.

```bash
➜  m06 dd if=/dev/zero of=disk3.img bs=1k count=100k
➜  m06 sudo losetup /dev/loop2 disc3.img

➜  m06 sudo pvcreate /dev/loop2
  Physical volume "/dev/loop2" successfully created.

# extender vg
➜  m06 sudo vgextend diskedt /dev/loop2 
  Volume group "diskedt" successfully extended

➜  m06 sudo vgs
  VG      #PV #LV #SN Attr   VSize   VFree 
  diskedt   3   2   0 wz--n- 288,00m 96,00m
```

Podemos ver que ahora diskedt tiene 96MiB de espacio libre.

## Expandir partición

Sumamos 30MiB a los 52MiB que tenia la particion LV sistema

```bash
➜  m06 sudo lvextend -L +30 /dev/diskedt/sistema /dev/loop2
  Rounding size to boundary between physical extents: 32,00 MiB.
  Size of logical volume diskedt/sistema changed from 52,00 MiB (13 extents) to 84,00 MiB 

➜  m06 sudo lvdisplay /dev/diskedt/sistema 
  --- Logical volume ---
  LV Path                /dev/diskedt/sistema
  LV Name                sistema
  VG Name                diskedt
  LV UUID                84OwTh-abyU-SxTZ-1uGT-Qrp7-murD-7eTayk
  LV Write Access        read/write
  LV Creation host, time pc02, 2020-02-03 19:26:09 +0100
  LV Status              available
  # open                 1
  LV Size                84,00 MiB
  Current LE             21
  Segments               2
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0
```

Se puede ver que ahora ocupa 21 bloques, repartidos en 2 segmentos.

```bash
➜  m06 lsblk
NAME              MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
loop0               7:0    0   100M  0 loop 
├─diskedt-sistema 253:0    0    84M  0 lvm  /mnt/sistema
└─diskedt-dades   253:1    0   140M  0 lvm  /mnt/dades
loop1               7:1    0   100M  0 loop 
└─diskedt-dades   253:1    0   140M  0 lvm  /mnt/dades
loop2               7:2    0   100M  0 loop 
└─diskedt-sistema 253:0    0    84M  0 lvm  /mnt/sistema
```

### Expandir sistema de archivos

Estando montado se ve como expande sin problemas el sistema de ficheros

```bash
➜  m06 df -h
S.ficheros                  Tamaño Usados  Disp Uso% Montado en
...
/dev/mapper/diskedt-dades     132M   1,6M  121M   2% /mnt/dades
/dev/mapper/diskedt-sistema    47M   1,1M   42M   3% /mnt/sistema

➜  m06 sudo resize2fs /dev/diskedt/sistema 

➜  m06 df -h
S.ficheros                  Tamaño Usados  Disp Uso% Montado en
...
/dev/mapper/diskedt-dades     132M   1,6M  121M   2% /mnt/dades
/dev/mapper/diskedt-sistema    78M   1,6M   72M   3% /mnt/sistema
```



## Reducir partición

Para reducir una partición no es necesario desmontar, lvm ya se encarga del sistema de archivos el solo.

```bash
➜  m06 sudo lvreduce -L 50M -r /dev/diskedt/sistema 
➜  m06 sudo lvs
  LV      VG      Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  dades   diskedt -wi-ao---- 140,00m                                                    
  sistema diskedt -wi-ao----  52,00m          
```



## Mover datos

Para mover los datos de un disco a otro se utiliza `pvmove` pero antes de nada hay que realizar ciertos pasos.

Simulo que e añadido un disco grande y voy a prescindir de los 2 pequeños que tengo.

```bash
# creo/inserto disco
➜  m06 dd if=/dev/zero of=disk3.img bs=1k count=500k
524288000 bytes (524 MB, 500 MiB) copied, 0,705858 s, 743 MB/s
➜  m06 sudo losetup /dev/loop2 disk3.img 
# creo la marca de disco fisico
➜  m06 sudo pvcreate /dev/loop2
# lo añado al disco virtual
➜  m06 sudo vgextend diskedt /dev/loop2
# se puede ver que hay 3 pv y a crecido en tamaño
➜  m06 sudo vgs
  VG      #PV #LV #SN Attr   VSize   VFree  
  diskedt   3   2   0 wz-pn- 688,00m 496,00m
  
# muevo datos al nuevo disco
➜  m06 sudo pvmove /dev/loop0 /dev/loop2
➜  m06 sudo pvmove /dev/loop1 /dev/loop2
➜  m06 lsblk
NAME              MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
loop0               7:0    0   100M  0 loop 
loop1               7:1    0   100M  0 loop 
loop2               7:2    0   500M  0 loop 
├─diskedt-sistema 253:0    0    52M  0 lvm  /mnt/sistema
└─diskedt-dades   253:1    0   140M  0 lvm  /mnt/dades

```

Todo esto con los datos montados, el usuario ni se entera de lo que pasa por debajo.



## Reducir disco

Para extraer discos físicos  al disco virtual y por lo tanto reducir de tamaño.

```bash
➜  m06 sudo vgs
  VG      #PV #LV #SN Attr   VSize   VFree  
  diskedt   3   2   0 wz--n- 688,00m 496,00m

➜  m06 sudo vgreduce diskedt /dev/loop0 /dev/loop1
  Removed "/dev/loop0" from volume group "diskedt"
  Removed "/dev/loop1" from volume group "diskedt"

➜  m06 sudo vgs                                   
  VG      #PV #LV #SN Attr   VSize   VFree  
  diskedt   1   2   0 wz--n- 496,00m 304,00m
```



## Borrado

Para borrar y desmontar todo, primero hay que desmontar y luego ir borrando desde arriba hacia  abajo, LV, VG, PV.

```bash
# desmontar
➜  m06 sudo umount /mnt/dades /mnt/sistema 
# borrado lv
➜  m06 sudo lvremove /dev/diskedt/sistema /dev/diskedt/dades 
# borrado vg
➜  m06 sudo vgremove diskedt
# borrado pv
➜  m06 sudo pvremove /dev/loop{0..2}
```

