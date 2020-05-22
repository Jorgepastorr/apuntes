# Raid

## Modos de raid

### Firmware

El modo de raid firmware es el raid basado en la BIOS, la propia BIOS tiene su controladora para gestionar la raid .

### Hardware

El modo Hardware, consiste en una tarjeta pinchada en la placa que controla la raid.

### Software

El modo Software es el propio sistema operativo que gestiona la raid.

## Tipo de raid

[tipo de raid wikipedia](https://es.wikipedia.org/wiki/RAID)

## Raid software

- assemble construye la raid a partir de los superbloques
- build crea la raid sin añadir la marca de superbloque al disco
- create crea la raid añadiendo superbloques en sus discos



## Niveles de raid

[Calculadora raid](http://www.raid-calculator.com/)

| Nivel | nº discos | nº discos que pueden fallar | capacidad | capacidad leer y escribir |
| ----- | --------- | --------------------------- | --------- | ------------------------- |
| R0    | 2         | 0                           | 100%      | excelente                 |
| R1    | 2 max     | 1                           | 50%       | L.MuyBuena / E.Buena      |
| R5    | 3 min     | 1                           | 67% - 94% | L.Muy buena / E.Buena     |
| R6    | 4 min     | 2                           | 50% - 88% | L.Buena / E.Buena         |
| R10   | 4 min     | 1 por cada mirror           | 50%       | L.Muy buena / E.Buena     |
| R50   | 6 min     | 1 por cada mirror           | 67% - 94% | L.Excelente / E.Muy buena |
| R60   | 8 min     | 2 por cada mirror           | 50% - 88% | L.Muy buena / E.Buena     |

#### Raid 0

- Escribe y lee en los discos a la vez repartiéndose la faena, resultado una escritura y lectura excelente. 
- Lo malo que no tiene margen de error, si falla un disco pierdes los datos.

#### Raid 1

- Escribe en los 2 discos a la vez por si falla 1 tener el otro de backup.

#### Raid 5

- Hace una paridad de datos cada 2 bits genera un tercero de seguridad por si falla algún disco.

#### Raid 6 

- Hace lo mismo que raid 5 pero generando 2 bits de paridad, por lo tanto hay posibilidad de que fallen 2 discos sin perder datos.

#### Raid 10

- Son dos raid 1 unidas por una raid 0 , nivel de seguridad alto 1 disco por mirror pero se reduce la capacidad total de almacenamiento al 50% total.

#### Raid 50

- Dos raid 5 unidas por raid 0 velocidad excelente de lectura con nivel de seguridad alto de 2 discos de fallo.

#### Raid 60

- Dos raid 6 unidas por raid 0 máxima seguridad en raid posibilidad de que fallen 4 discos dos por cada raid 6. una probabilidad muy pequeña.



### Crear raid

```bash
sudo mdadm --create /dev/md0  --level=1 --raid-devices=3 /dev/loop0 /dev/loop1 /dev/loop2

sudo mdadm  --create /dev/md/dades  --level=1 --raid-devices=2 /dev/loop0 /dev/loop1 --spare-devices=2 /dev/loop2 /dev/loop3
```

Al crear la raid inserta un pequeño bloque de datos en cada disco para gestionar la raid.

### Ver Información Raid

```bash
sudo mdadm --detail /dev/md0 # ver estado del raid
sudo mdadm --detail --scan  # ver si existe alguna raid
sudo mdadm --examine /dev/loop0  # ver datos del bloque raid en disco
sudo mdadm --query /dev/loop0 
sudo mdadm --query /dev/md0
cat /proc/mdstat # ver estado de raid
```

### Extraer disco

```bash
sudo mdadm /dev/md0 --fail /dev/loop1
sudo mdadm /dev/md0 --remove /dev/loop1
```

### Añadir disco

```bash
sudo mdadm --manage /dev/md0 --add /dev/loop1
```

En este paso si los discos de la raid tienen datos, tardara en añadirse por que tiene que sincronizarse.

#### Añadir Spare

Spare son los discos de reserva, cuando falla un disco de datos, este se empieza a sincronizar automáticamente.

```bash
sudo mdadm /dev/md0 --add-spare /dev/loop2
```

### Parar Raid

Para, parar la raid a de estar desmontada del sistema de archivos.

```bash
sudo mdadm --stop /dev/md0 # parar raid  md0
sudo mdadm --stop --scan # para todas las raid
```

### Guardar raid

```bash
sudo mdadm --examine --scan > /etc/mdadm.conf
```

### Reconstruir raid

Como se guardan datos de la raid en cada disco es posible reconstruir una raid automáticamente.

```bash
sudo mdadm --assemble --scan # automatico, si existe /etc/mdadm.conf no escaneara todos los discos.
sudo mdadm --assemble /dev/md0 --run /dev/loop0 /dev/loop1 /dev/loop2 # indicando discos
sudo mdadm --assemble /dev/md0 # siempre que exista el archivo /etc/mdadm.conf y este md0 dentro
```

### Limpiar superbloque

```bash
sudo mdadm --zero-superblock /dev/loop0
```

### Reshape

#### Aumentar discos

Aumentar a 3 discos y añadir el tercero.

```bash
sudo mdadm --grow /dev/md/raid1 --raid-devices 3 --add /dev/loop2  
```

#### Cambiar nivel de raid

De level 1 a level 5, lvel 1 solo puede tener 2 discos.

```bash
sudo mdadm --grow /dev/md/raid1 --level 5
```

#### Aumentar tamaño

```bash
sudo mdadm --grow /dev/md/raid1 --size=max
# si esta montada se tendrá que espandir el sistem de ficheros
sudo resize2fs /dev/md127
```



## Raid y LVM

Ejercicio practico:

- un raid 1 de 2v discos de 500

- un raid 1 de 2v discos de 500

- primer raid crear pv y vg

- lv  de 200 sistema y 300 dades

- montar

- incorpoprar al vg el segundo raid

- incrementar sistema +100

- provocar fail raid1

- eliminar vel primer raid del vg

  

### Crear discos

```bash
dd if=/dev/zero of=disc1.img bs=1k count=500k
dd if=/dev/zero of=disc2.img bs=1k count=500k
dd if=/dev/zero of=disc3.img bs=1k count=500k
dd if=/dev/zero of=disc4.img bs=1k count=500k

losetup /dev/loop0 disc1.img 
losetup /dev/loop1 disc2.img 
losetup /dev/loop2 disc3.img 
losetup /dev/loop3 disc4.img 
```



### Crear raids

```bash
mdadm --create /dev/md/raid1 --level 1 --raid-devices 2 /dev/loop0 /dev/loop1
mdadm --create /dev/md/raid2  --level 1 --raid-devices 2 /dev/loop2 /dev/loop3
```



### Crear marca PV y VG

```bash
pvcreate /dev/md/raid1
pvcreate /dev/md/raid2
vgcreate mydisc /dev/md/raid2
```



### Crear LVs

crear montar y añadir datos

```bash
lvcreate -L 200M -n sistema /dev/mydisc
lvcreate -L 100M -n dades /dev/mydisc

mkfs.ext4 /dev/mydisc/sistema 
mkfs.ext4 /dev/mydisc/dades

mount /dev/mydisc/sistema /mnt/sistema
mount /dev/mydisc/dades /mnt/dades

cp -r /boot/grub2/ /mnt/sistema/s1
cp -r /boot/grub2/ /mnt/sistema/s2
cp -r /boot/grub2/ /mnt/dades/d1
cp -r /boot/grub2/ /mnt/dades/d2
cp -r /boot/grub2/ /mnt/dades/d3
```



### Extender VG a las 2 raids

```bash
vgextend mydisc /dev/md/raid2
```



### Extender  partición sistemas 

```bash
lvextend -L +100M /dev/mydisc/sistema 
resize2fs /dev/mydisc/sistema 
```



### Extraer raid1 primaria

```bash
# probocar fllo en disco
mdadm /dev/md/raid1 --fail /dev/loop0
# mover datos al segundo raid
pvmove /dev/md/raid1 /dev/md/raid2
# quitar vprimer raid del VG
vgreduce mydisc /dev/md/raid1
# parar raid1
mdadm --stop /dev/md/raid1 
```

