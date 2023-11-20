# Cluster en centos con pacemaker/corosync

[doc Red Hat High Availability](https://access.redhat.com/documentation/es-es/red_hat_enterprise_linux/6/html/configuring_the_red_hat_high_availability_add-on_with_pacemaker/index)

## Paquetes

Los paquetes deberan estar instalados en todos los nodos

    yum install -y epel-release
    yum install  -y pcs fence-agents-all

## Puertos requeridos

- Para TCP: Puertos 2224, 3121, 21064
- Para UDP: Puertos, 5405 

    firewall-cmd --permanent --add-service=high-availability
    firewall-cmd --add-service=high-availability

## Servicio de pcs

    systemctl start pcsd.service
    systemctl enable pcsd.service

## configuración de nodos

Los diferentes nodos se tienen que poder ver, ya vsea por DNS o archivo host

    127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
    ::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
    192.168.33.11 node01.lpic.lan node01
    192.168.33.12 node02.lpic.lan node02
    192.168.33.13 node03.lpic.lan node03

PCS utiliza el usuario `hacluster` para comunicarse con los diferentes nodos

    echo reverse | passwd --stdin hacluster

    pcs cluster auth node01 node02 node03
    
    Username: hacluster
    Password: 
    node02: Authorized
    node03: Authorized
    node01: Authorized

>  La autorización de identificadores se almacena en el archivo `~/.pcs/tokens` (o `/var/lib/pcsd/tokens`). 

## Desplegar cluster

    pcs cluster setup --start --name mycluster node01 node02 node03
    pcs cluster enable --all

## Estado del cluster

    pcs cluster status
    pcs status

## Logs

    ls /var/log/cluster/corosync.log

- crmd: servicio de gestionar servicios entre maquinas
- lrmd: servicio en gestionar servicios en local

    crm_mon # ver recursos en tempo release
    crm_verify -L -V # sintaxi de corosync


## GUI pcs

Acceder al servicio GUI de cluster pcs https://node01:2224

## Propiedades

    pcs property
    pcs property --all
    pcs property set stonith-enabled=false # propiedad exclusiva para dispositivos fending

## Recursos

    pcs resource list
    pcs resource describe <resource>
    pcs resource create virtual_ip ocf:heartbeat:IPaddr2 ip=192.168.33.100 cidr_netmask=24
    
    pcs resource
    pcs resource show virtual_ip

    pcs resource move apachegroup node03


### Recurso apache

    yum install -y httpd php

    /etc/httpd/conf/httpd.conf
    <Location /server-status>
        SetHandler server-status
        Order deny,allow
        Deny from all
        Allow from 127.0.0.1
    </location>

    /var/www/html/index.php
    <?php
    echo gethostname();
    ?>

    pcs resource create apache ocf:heartbeat:apache configfile="/etc/httpd/conf/httpd.conf" \
    statusurl="http://127.0.0.1/server-status"
    
    pcs resource

## Crear grupo para los dos recursos

    pcs resource group add apachegroup virtual_ip apache
    pcs resource

    curl http://192.168.33.100
    
## gestion nodos

    pcs cluster standby node01
    pcs cluster unstandby node01

## Destruir cluster

    pcs cluster destroy
