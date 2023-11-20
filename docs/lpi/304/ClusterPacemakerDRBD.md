# Cluster Pacemaker DRBD

En esta practica se crea un cluster Pacemaker de dos nodos.
Estos nodos tendrán un servicio apache:
- Con el directorio /var/www/html sincronizado por DRBD
- Una ip virtual que se desplazara de un nodo a otro según convenga

> Intalación  de DRBD, apache, php y pacemaker en los 2 nodos

## DRBD

https://linbit.com/user-guides-and-product-documentation/


DRBD crea un cluster entre dos maquinas, se tiene que gestionar a mano quin es el primario/secundario y montar los recursos en el cliente del primario, como el primario puede cambiar es molesto.
El problema se resuelve con un controlador Pacemaker y crear ips flotantes para los recursos

### Añadir repositorio e instalar DRBD

    rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
    yum install -y https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm

    yum install -y kmod-drbd90 drbd90-utils
    cat /proc/drbd

    # Activar modulo
    modprobe drbd
    lsmod | grep drbd

    echo drbd > /etc/modules-load.d/drbd.conf


### Configurar del recurso

*/etc/drbd.d/hadisk.res*

    resource drbd0 {
        protocol C;
        on node01 {
            device /dev/drbd0;
            disk /dev/sda1;
            meta-disk internal;	
            address 192.168.55.11:7789;
        }
        on node02  {
            device /dev/drbd0;
            disk /dev/sda1;
            meta-disk internal;
            address 192.168.55.12:7789;
        }
    }

#### Chequear sintaxis configuracón

    drbdadm dump all 

#### Levantar sincronización

    drbdadm create-md drbd0
    drbdadm up drbd0

#### Añadir un nodo como primario

    drbdadm primary drbd0
    drbdadm status

**Ojo** Comprovar puerto firewall

    ss -ltn | grep 7788

---

## Instalar apache y PHP

    yum install -y httpd php

Añadir linea al archivo `/etc/httpd/conf/httpd.conf` para que pcs pueda controlarlo automaticamente

    # this is the default but is required by pcs to be defined
    PidFile /var/run/httpd/httpd.pid

Crear file a mostrar en apache `/var/www/html/index.php`

    <?php
    echo "<h2>Hola mundo soy:</h2>";
    echo gethostname();
    ?>

---

## instalar pacemaker

    yum install -y epel-release
    yum install  -y pcs fence-agents-all

    systemctl start pcsd.service
    systemctl enable pcsd.service

### autorizar acceso a nodos

    echo reverse | passwd --stdin hacluster
    pcs cluster auth node01 node02 

### iniciar cluster

    pcs cluster setup --start --name mycluster node01 node02
    pcs cluster enable --all

Desactivo stonith al no ser necesario con dos nodos

    pcs property set stonith-enabled=false 

### Recursos 

#### DRBD

Las siguientes ordenes:

- crean el recurso que gestiona el servicio DRBD 
- los datos siempre estaran en el nodo master

    pcs cluster cib drbd0_conf
    pcs -f drbd0_conf resource create web_drbd ocf:linbit:drbd drbd_resource=drbd0 op monitor interval=60s
    pcs -f drbd0_conf resource master web_drbd_clone web_drbd master-max=1 master-node-max=1 cone-max=2 clone-node-max=1 notify=true
    pcs cluster cib-push drbd0_conf
    pcs status

#### Apache

IP virtual que utilizara apache

    pcs resource create apache_vip ocf:heartbeat:IPaddr2 ip=192.168.55.100 cidr_netmask=24 op monitor interval=30s

Associar directorio de DRBD

    pcs resource create web_fs ocf:heartbeat:Filesystem device="/dev/drbd0" directory="/var/www/html" fstype="ext4"

Servicio apache

    pcs resource create apache ocf:heartbeat:apache configfile="/etc/httpd/conf/httpd.conf" 

Junto todos los recursos de apache en un grupo

    pcs resource group add apachegroup apache_vip web_fs apache



---

Si tenemos selinux activado puede que no puedas mover los nodos a master, hay quyue analizar el error 

    audit2allow -w -a
    setsebool -P daemons_enable_cluster_mode 1

    semanage fcontext -a -t httpd_sys_content_t "/var/www/html(/.*)?"
    restorecon -Rv /var/www/html

    audit2allow -a -M drbd0_acces
    semodule -i drbd0_acces.pp


---

pcs cluster cib fs_drbd0_conf
pcs -f fs_drbd0_conf constraint colocation add web_fs with web_drbd_clone INFINITY with-rsc-role=Master 
pcs -f fs_drbd0_conf constraint colocation add apachegroup with web_drbd_clone INFINITY with-rsc-role=Master 
pcs -f fs_drbd0_conf constraint order promote web_drbd_clone then start web_fs
pcs -f fs_drbd0_conf constraint colocation add apachegroup with web_fs INFINITY
pcs -f fs_drbd0_conf constraint order web_fs then apachegroup
pcs -f fs_drbd0_conf constraint
pcs cluster cib-push drbd0_conf
pcs status


