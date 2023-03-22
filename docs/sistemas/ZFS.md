# ZFS

- [Doc oracle zfs](https://docs.oracle.com/cd/E26921_01/html/E25823/docinfo.html#scrolltoc)
- [man zpool](https://linux.die.net/man/8/zpool)
- [man zfs](https://linux.die.net/man/8/zfs)

```bash
apt install  zfsutils-linux  zfs-dkms
```

**IMPORTANTE**: No usar ZFS sobre controladoras  hardware, puesto que tienen su propia caché. ZFS necesita comunicarse  directamente con los discos.

## Niveles de RAID soportados

El sistema ZFS, soporta los siguientes tipos de RAID, los RAID-Z son una variacion de Raid5

- RAID0
- RAID1
- RAID10 
- RAIDZ-1 (min 3 discos, paridad simple)
- RAIDZ-2 (min 4 discos, paridad doble)
- RAIDZ-3 (min 5 discos, paridad triple)



## Gestión de Zpools

Visualización de zpool

```bash
zpool status	# ver estado el pool
zpool list		# ver la capacidad de los discos
zfs list		# ver los volumenes dentro de zpool
zpool history   # ver historial de comandos
zpool get all	# ver propiedades del pool
```



### Crear zpool

[doc oracle](https://docs.oracle.com/cd/E23824_01/html/821-1448/gaypw.html#gazhd) sobre esta sección

**RAID0 o "Striping"**

No añade redundancia, por lo que un fallo en un disco supone un fallo en el RAID completo. Sin embargo, si que mejora la velocidad de Lectura/Escritura.

```bash
zpool create -f <NombrePool> <Disco> <Disco> [<Disco> <Disco> <Disco> ...]
zpool create -f tank /dev/vdb /dev/vdc
```



**RAID1 o "Mirroring"**

Como mínimo necesitaremos 2 discos de la misma capacidad. La capacidad resultante será la de un solo disco.

```bash
zpool create -f <NombrePool> mirror <Disco1> <Disco2>
zpool create -f tank mirror /dev/vdb /dev/vdc
```



**RAID10**

El resultado será un RAID0 sobre varios RAID1. Su capacidad será la suma de capacidades de todos los RAID1 que lo compongan.

```bash
zpool create -f <NombrePool> mirror <Disco1> <Disco2> mirror <Disco1> <Disco2> [mirror <Disco1> <Disco2> ...]
zpool create -f tank mirror /dev/vdb /dev/vdc mirror /dev/vdd /dev/vde
```



**RAIDZ-1**

El RAID-Z1, es similar a un RAID5 con paridad simple, requiere al menos 3 discos.

```
zpool create -f <NombrePool> raidz1 <Disco1> <Disco2> <Disco3>
zpool create -f tank raidz1 /dev/vdb /dev/vdc /dev/vdd
```



**RAIDZ-2**

El RAID-Z2, es similar a un RAID5 con paridad doble, requiere al menos 4 discos.

```
zpool create -f <NombrePool> raidz2 <Disco1> <Disco2> <Disco3> <Disco4>
zpool create -f tank raidz2 /dev/vd[b-e]
```



**RAIDZ-3**

El RAID-Z3, es similar a un RAID5 con paridad triple, requiere al menos 5 discos.

```
zpool create -f <NombrePool> raidz3 <Disco1> <Disco2> <Disco3> <Disco4> <Disco5>
zpool create -f tank raidz2 /dev/vd[b-f]
```

### Visualizar estato

```bash
zpool status	# ver estado el pool
zpool list		# ver la capacidad de los discos
zfs list		# ver los volumenes dentro de zpool
zpool history   # ver historial de comandos
zpool get all	# ver propiedades del pool
```



### Discos adicionales

#### Disco de log

Podemos añadir un disco adicional para logs:

```bash
zpool create -f <NombrePool> <ElRaidQueSea> log <Disco> # crear pool con disco de log
zpool add -f <NombrePool> log <Disco>	# añadir disco cache de pool ya creado
```

#### Disco caché

Para acelerar la lectura y escritura en el RAID, podemos usar un disco caché. Obviamente esto tiene sentido con discos SSD:

```bash
zpool create -f <NombrePool> <ElRaidQueSea> cache <Disco>	# crear pool con disco de cache
zpool add -f <NombrePool> cache <Disco>	# añadir disco cache a pool ya creado
```

#### Disco spare

```bash
zpool create -f <NombrePool> <ElRaidQueSea> spare <Disco>	# crear pool con disco de spare
zpool add -f <NombrePool> spare <Disco>	# añadir disco spare a pool ya creado
```

#### Quitar disco adicional

```bash
zpool remove tank  /dev/vdg # remove solo funciona con discos spare, cache, log, ...
```



### Modificar un Zpool

#### Añadir/Quitar discos a mirror

```bash
zpool create -f tank mirrot /dev/vdb /dev/vdc # creación de mirror simple
zpool status 
...
config:
	NAME          STATE     READ WRITE CKSUM
	tank          ONLINE       0     0     0
	  mirror-0    ONLINE       0     0     0
	    vdb       ONLINE       0     0     0
	    vdc       ONLINE       0     0     0

zpool attach tank /dev/vdb /dev/vdd # añadir disco a mirror
zpool offline tank  /dev/vdd		# poner disco offline (simular un fallo)
zpool detach tank  /dev/vdd			# retirar disco
```

> La opción attach no se puede utilizar directamente sobre raidz*, se tendrá que utilizar replace

#### cambio disco fallido n raidz con spare

En este ejemplo se muestra como seria el cambio de un disco que a fallado en un raidz2 con spare

```bash
zpool create -f tank raidz2 /dev/vd[b-e] spare /dev/vd[fg]	# creación de raidz2 con 2 discos spare
zpool status
	NAME        STATE     READ WRITE CKSUM
	tank        ONLINE       0     0     0
	  raidz2-0  ONLINE       0     0     0
	    vdb     ONLINE       0     0     0
	    vdc     ONLINE       0     0     0
	    vdd     ONLINE       0     0     0
	    vde     ONLINE       0     0     0
	spares
	  vdf       AVAIL   
	  vdg       AVAIL   
---
zpool offline tank vdc # simulo fallo de disco vdc
zpool status
	NAME        STATE     READ WRITE CKSUM
	tank        DEGRADED     0     0     0
	  raidz2-0  DEGRADED     0     0     0
	    vdb     ONLINE       0     0     0
	    vdc     OFFLINE      0     0     0
	    vdd     ONLINE       0     0     0
	    vde     ONLINE       0     0     0
	spares
	  vdg       AVAIL   
	  vdf       AVAIL   
---
zpool replace tank vdc vdf # remplazo disco vdc offline por vdf en spare
zpool status
	NAME         STATE     READ WRITE CKSUM
	tank         DEGRADED     0     0     0
	  raidz2-0   DEGRADED     0     0     0
	    vdb      ONLINE       0     0     0
	    spare-1  DEGRADED     0     0     0
	      vdc    OFFLINE      0     0     0
	      vdf    ONLINE       0     0     0
	    vdd      ONLINE       0     0     0
	    vde      ONLINE       0     0     0
	spares
	  vdg        AVAIL   
	  vdf        INUSE     currently in use
---
zpool detach tank vdc	# quito disco dañado vdc
zpool status
	NAME        STATE     READ WRITE CKSUM
	tank        ONLINE       0     0     0
	  raidz2-0  ONLINE       0     0     0
	    vdb     ONLINE       0     0     0
	    vdf     ONLINE       0     0     0
	    vdd     ONLINE       0     0     0
	    vde     ONLINE       0     0     0
	spares
	  vdg       AVAIL   
---
zpool add tank spare vdc	# pongo vdc reparado como spare
zpool status
	NAME        STATE     READ WRITE CKSUM
	tank        ONLINE       0     0     0
	  raidz2-0  ONLINE       0     0     0
	    vdb     ONLINE       0     0     0
	    vdf     ONLINE       0     0     0
	    vdd     ONLINE       0     0     0
	    vde     ONLINE       0     0     0
	spares
	  vdg       AVAIL   
	  vdc       AVAIL   
```

#### Cambio de disco a raidz

En este ejemplo se muestra el cambio de un disco en un raidz2 sin spare 

Primero de todo simulamos el fallo de un disco poniendolo offline

```bash
zpool offline tank vdd
zpool status
	NAME        STATE     READ WRITE CKSUM
	tank        DEGRADED     0     0     0
	  raidz2-0  DEGRADED     0     0     0
	    vdb     ONLINE       0     0     0
	    vdc     ONLINE       0     0     0
	    vdd     OFFLINE      0     0     0
	    vde     ONLINE       0     0     0
	    vdf     ONLINE       0     0     0
	    vdg     ONLINE       0     0     0
```

En este paso ya podemos desmontar y retirar el disco de la máquina y poner uno nuevo. Una vez insertado el disco nuevo en la máquina con `zpool replace` lo volvemos a poner online en el pool

```bash
zpool replace tank /dev/vdd
zpool status
	NAME        STATE     READ WRITE CKSUM
	tank        ONLINE       0     0     0
	  raidz2-0  ONLINE       0     0     0
	    vdb     ONLINE       0     0     0
	    vdc     ONLINE       0     0     0
	    vdd     ONLINE       0     0     0
	    vde     ONLINE       0     0     0
	    vdf     ONLINE       0     0     0
	    vdg     ONLINE       0     0     0

```

#### Aumentar/Reducir raidz

Actualmente en la versio de OpenZFS 2.1 no se puede canviar el modo de raidz, aun que anuncian para 3.0 en 2022 esa  funcionalidad.

De momento solo podemos hacer un snapshot de los datos, destruir el el zpool, crear uno nuevo y volver a volcar el snapshot

```bash
zfs snapshot tank/documents@backup
zfs send -cpe tank/documents@backup > backup.documnts

zpool destroy tank
zpool create -f tank raidz2 /dev/vd[b-g] 

zfs recv tank/documents  < backup.documnts
zfs list
NAME             USED  AVAIL     REFER  MOUNTPOINT
tank             357K  7.42G     44.0K  /tank
tank/documents  90.9K  7.42G     90.9K  /tank/documents

```



### Migración

[doc oracle](https://docs.oracle.com/cd/E19253-01/820-2314/gbchy/index.html) sobre esta sección

La opción export marca los discos como que se esta iniciando una migración y entre otras cosas purga cualquier dato no escrito en el disco ( hace un sync)

```bash
zpool export tank 
```

> Una vez exportado el pool ya se pueden extraer los discos e llevarlos a otro nas

Para detectar las agrupaciones disponibles, ejecute el comando zpool import sin opciones. Por ejemplo:

```bash
zpool import	# ver pools disponibles
zpool import tank	# importar pool tank (tambien se puede indicar con nel id)
zpool import tank zelda	# importar renombrando

zfs set mountpoint=/zelda zelda	# canviar punto de montaje
```

> podrás ver el id de un pool con `zpool status` o `zpool import`

### Destrucción

```bash
zpool destroy dozer	# destruir un pool
zpool import -D		# ver pools destridos
zpool import -Df dozer	# forzar importción pool dozer
zpool status -x		# visualizar pool en mal estado
  pool: dozer
 state: DEGRADED
status: One or more devices could not be opened.  Sufficient replicas exist for
        the pool to continue functioning in a degraded state.
action: Attach the missing device and online it using 'zpool online'.
   see: http://www.sun.com/msg/ZFS-8000-2Q
 scrub: scrub completed after 0h0m with 0 errors on Thu Jan 21 15:38:48 2010
config:
        NAME         STATE     READ WRITE CKSUM
        dozer        DEGRADED     0     0     0
          raidz2-0   DEGRADED     0     0     0
            c2t8d0   ONLINE       0     0     0
            c2t9d0   ONLINE       0     0     0
            c2t10d0  ONLINE       0     0     0
            c2t11d0  UNAVAIL      0    37     0  cannot open
            c2t12d0  ONLINE       0     0     0

errors: No known data errors

zpool online dozer c2t11d0	# reactivar disco 
Bringing device c2t11d0 online

zpool status -x
all pools are healthy
```





### Añadir notificaciones por e-Mail.

Instalamos el servicio que se encargará de monitorizar los eventos  del módulo de kernel ZFS. Este servicio puede enviar emails cuando  ocurran errores en alguna pool.

```
apt-get install zfs-zed
```

Para activar el demonio, debemos configurar el correo:

```
nano /etc/zfs/zed.d/zed.rc
ZED_EMAIL_ADDR="avisos@correo.es"
```



### Propiedades de un pool

[doc oracle](https://docs.oracle.com/cd/E19253-01/819-5461/gfifk/index.html) sobre esta sección

**Definir tamaño de sector**

Para un comportamiento óptimo de la unidad ZFS, el tamaño del sector  de la Pool (ashift), debe ser mayor o igual que el tamaño del sector en  los discos que la componen. Para configurarlo, lo haríamos de la  siguiente forma:

```bash
zpool create -f -o ashift=12 <NombrePool> <ElRaidQueSea>
```

```bash
zpool create -f -m /tank tank /dev/vdb  # crear volumenes -f force vdevs
zpool scrub tank    # añadir control de fallos al volumen
zpool history   # ver historial de comandos
```

## Volumenes

### Crear volumen

```bash
zfs 
create tank/documents
zfs destroy tank/documents

zfs create -o compression=on tank/documents 
```

### Snapshot

```bash
zfs snapshot tank/documents@backup
zfs list -t snapshot
ll /tank/documents/.zfs/snapshot/backup

zfs rollback tank/documents@backup
zfs destroy tank/documents@backup
         -n no-action
         -v verbose
         -r recursive (clones...)
```

#### Enviar snapshot

```bash
zfs send -cpev tank/dana@snap1 | ssh host2 zfs recv newtank/dana	# enviar snap
# -c compress
# -p  Información verbosa sobre el paquete de transmisión generado. 
# -e  Generate a more compact stream 
# -v vervose

zfs send -i tank/dana@snap1 tank/dana@snap2 | ssh host2 zfs recv -F newtank/dana	# enviar icremental snap
# -F forzar rollback a la instantanea mas reciente antes de recibir

# enviar datast con todos los snapshots
zfs send -R tank/dataset@snapMasReciente | ssh <ip> zfs recv tank/dataset

# si no existe lista snapshots remotos 
zfs send -cpev <dataset@snapshot> | ssh <destino> zfs recv -vsd pool

# envia un incremental
zfs send -cpevI <@snapshot> <dataset@snapshot>  | ssh <destino> zfs recv -Fvd pool
```



Opciones mas usadas de send y recieve

```bash
zfs send
	-p  # enviar propiedades
	-v  # vervose
	-I  # enviar todas las instantaneas intermedias entre "snapA" y "snapB"
	-c  # comprime el envio
	-e  # comprimido optimizado
	
zfs recv
	-v  # vervose
	-e  # Utiliza el ultimo snap (de send) para determinar el nombre de la nueva instantánea
	-d  # Utilice todos menos el primer elemento de la ruta de la instantánea enviada 
	-F  # fuerza rolback en el destino al snap mas reciente
	-s  # Si se interrumpe la recepción, guarde el estado de recepción parcial, en lugar de eliminarlo.
```

### Clones

[doc oracle](https://docs.oracle.com/cd/E26921_01/html/E25823/gbcxz.html)

Crear un clon partiendo de un snap

	 zfs clone tank/test/productA@today tank/test/productAbeta

#### Sustitur clon por dataset original

Sustituir el sistema de archivos, se le asignaran al clon los snaps del original

	zfs promote tank/test/productAbeta

	# renombramos datasets 
	zfs rename tank/test/productA tank/test/productAlegacy
	zfs rename tank/test/productAbeta tank/test/productA

	# destruimos original
	zfs destroy tank/test/productAlegacy


### Propiedades

[doc oracle](https://docs.oracle.com/cd/E19253-01/819-5461/gazss/index.html) sobre esta sección

Se pueden ver todas las propiedades en `man zfsprops`

```bash
zfs get all tank/documents # ver opciones

zfs set compression=on tank/documents
zfs set atime=off  # Controla si el tiempo de acceso a los archivos se actualiza cuando se leen
zfs set atime=off relatime=on zelda
```

Una vez creada la unidad ZFS, es posible usar compresión en este almacenamiento

```bash
zfs set compression=lz4 <NombrePool>
zfs set compression=off <NombrePool>
```

> Se recomienda usar el algoritmo lz4, ya que agrega muy poca sobrecarga de CPU. También están disponibles otros algoritmos como lzjb y gzip-N, donde N es un  número entero de 1 (más rápido) a 9 (mejor relación de compresión).  Dependiendo del algoritmo y de la compresión de los datos, tener la  compresión habilitada puede incluso aumentar el rendimiento.


#### Comprimir dataset existente

En el caso de tener un dataset sin compresión activada y activarla, los archivos existentes no se comprimen, solo los nuevos. En este caso hay que sobresscribir todo el dataset.

```bash
# activar compresion
zfs set compress=on tank/dataset

# replicar dataset
zfs send -R tank/dataset | zfs recv tank/newDataset

# eliminar el antiguo y renombrar
zfs destroy -r tank/dataset
zfs rename tank/newDataset tank/dataset
```




