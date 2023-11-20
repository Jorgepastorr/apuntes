# Clusterfs

GlusterFS es un sistema de archivos de red escalable adecuado para tareas de uso intensivo de datos, como el almacenamiento en la nube y la transmisión de medios. GlusterFS es un software gratuito y de código abierto y puede utilizar hardware comercial estándar. Para obtener más información, consulte la página de inicio del [proyecto Gluster.](https://www.gluster.org/)


Resumen de ordenes glusterfs

    glusterfs --version
    gluster peer probe <Hostname> # añadir nodo
    gluster peer status
    gluster peer detach node02 # quitar nodo
    gluster pool list

    gluster volume create vol01 transport tcp node01:/glusterfs/vol01 node02:/glusterfs/vol01
    gluster volume create vol02 replica 3 transport tcp node01:/glusterfs/replica \
        node02:/glusterfs/replica \
        node03:/glusterfs/replica
    gluster volume start vol01
    gluster volume info

    mount -t glusterfs node01:/vol01 /mnt

    gluster volume stop|start|list|status|set|get|reset <name-volume>
    gluster volume stop vol01
    gluster volume delete vol01


Tipos de almacenaminto:

- Particionado: consiste en almacenar los archivos en diferentes partciones, nodos, ...
los archivos se almacenan en los dos nodos pero sin repetirse, es decir similar a un raid 0
- Replicado: consiste en duplicar los archivos en todos los nodos existentes, semejando un raid 1 ( mínimo 3 nodos )
- Convinado: convina las dos anteriores, raid10, se necesitan 6 nodos minímo

## Almacenamiento Particionado

Nodos utilizados como servidores de almacenamiento:
- node01 node02
  

### Configuración de nodos servidores

La configuración básica del servidor consiste en instalar paquetes, crear punto de almacenamiento y crear volumen sincronizado.

    yum -y install centos-release-gluster
    yum -y install glusterfs-server
    glusterfs --version

#### habilitar firewall

    firewall-cmd --add-service=glusterfs --permanent

#### Habilitar servicio

    systemctl enable --now glusterd

#### Crear particion y formatear

El almacenamiento no puede estar en la particion raíz, por lo tanto se crea una a parte.
    
    fdisk /dev/sda
    mkfs.xfs /dev/sda1

#### Crear punto de almacenamiento

    mkdir  /glusterfs
    mount /dev/sda1 /glusterfs
    mkdir /glusterfs/vol01

#### Comprobar conexión y estado

> Desde cualquira de los dos nodos

    gluster peer probe node02
    gluster peer status

#### Crear volumen de datos

    gluster volume create vol01 transport tcp node01:/glusterfs/vol01 node02:/glusterfs/vol01
    gluster volume start vol01
    gluster volume info

---

### Configuración cliente

La configuración del cliente no tiene misterio, instalar paquetes necesarios para gestionat glusterfs y montar

#### Instalación de paquetes necesarios

    yum -y install centos-release-gluster
    yum -y install glusterfs glusterfs-fuse

#### montage de volumen glusterfs

    mount -t glusterfs node01:/vol01 /mnt

---

### resultado

El cliente ve:

    [root@node03 ~]# ls /mnt/
    random01.txt  random02.txt  random03.txt  random04.txt  random05.txt  random06.txt  random07.txt  random08.txt  random09.txt  random10.txt

En los nodos se a almacendo:

    [root@node01 ~]# ls /glusterfs/vol01/
    random01.txt  random07.txt  random08.txt  random09.txt

    [root@node02 ~]# ls /glusterfs/vol01/
    random02.txt  random03.txt  random04.txt  random05.txt  random06.txt  random10.txt

---

## Almacenamiento Replicado

Nodos utilizados como servidores de almacenamiento:
- node01 node02 node03

Los paquetes necesarios son los mismos de la configuración de servidores anteriotres

    yum -y install centos-release-gluster
    yum -y install glusterfs-server
    glusterfs --version

### habilitar firewall

    firewall-cmd --add-service=glusterfs --permanent

### Habilitar servicio

    systemctl enable --now glusterd

### Crear particion y formatear

El almacenamiento no puede estar en la particion raíz, por lo tanto se crea una a parte.
    
    fdisk /dev/sda
    mkfs.xfs /dev/sda1

### Crear punto de almacenamiento

    mkdir  /glusterfs
    mount /dev/sda1 /glusterfs
    mkdir /glusterfs/replica

### Comprobar conexión y estado

> Desde cualquira de los dos nodos

    # repetir peer probe con todos los nodos
    gluster peer probe node02
    gluster peer status

### Crear volumen de datos

    gluster volume create vol02 replica 3 transport tcp node01:/glusterfs/replica \
     node02:/glusterfs/replica \
     node03:/glusterfs/replica


    gluster volume start vol02
    gluster volume info


> La conexión de cliente es igual que la sección anterior, instalar paquetes y montar