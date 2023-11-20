# ordenes

## hostname

    Switch# configure terminal
    Switch(config)# hostname Sw-Floor-1

## desactibar busqueda DNS

Cuando te equibocas de comando enpieza una busqueda muy tediosa, con esto se evita

    Router(config)# no ip domain-lookup

## Contraseñas

Contraseña de consola 

    Sw-Floor-1# configure terminal
    Sw-Floor-1(config)# line console 0
    Sw-Floor-1(config-line)# password cisco
    Sw-Floor-1(config-line)# login

Contraseña de modo privilegiado

    Sw-Floor-1# configure terminal
    Sw-Floor-1(config)# enable secret class
    Sw-Floor-1(config)# exit

Encriptar todas las contraseñas

    Sw-Floor-1# configure terminal
    Sw-Floor-1(config)# service password-encryption

Proteger el acceso remoto ssh

    Router#  show ip ssh
    Router(config)# hostname R1
    Router(config)# ip domain-name cisco.com
    Router(config)# crypto key generate rsa
    Router(config)# username admin secret superpassword
    Router(config)# line vty 0 4
    Router(config-line)# transport input ssh
    Router(config-line)# login local

## show

    Sw-Floor-1# show running-config
    Sw-Floor-1# show startup-config
    S1# show ip interface brief     # El resultado muestra todas las interfaces, sus direcciones IP y su estado actual.
    R1# show ipv6 interface brief   
    R1# show ip route   # Muestra el contenido de la tabla de routing IP que se almacena en la RAM.
    R1# show interfaces # Muestra estadísticas de todas las interfaces del dispositivo.
    R1# show ip interfaces  # Muestra las estadísticas de IPv4 correspondientes a todas las interfaces de un router.
    R1# show ipv6 interfaces
    R1# show  flash:
    R1# show ip ports all

    # ver informacion de vecinos cdp (cisco) lldp (codigo abierto)
    R1# show cdp
    R1# show cdp neighbors
    R1# show cdp neighbors detall
    R1(config)# no cdp run

    R1# show history
    R1#  terminal history size 256

### filtrado

    R1# show running-config | section line vty
    R1# show ip interface brief | include up
    R1# show ip interface brief | exclude unassigned
    R1# show ip route | begin Gateway

## Banner

    Sw-Floor-1# configure terminal
    Sw-Floor-1(config)# banner motd #Authorized Access Only#

### Hora

    Router# show clock
    Router# clock set 13:00:00 february 2023

## Guardar las configuraciones

Existen dos archivos de sistema que almacenan la configuración de dispositivos.

- running-config: es la configuración que estas corriendo en el momento
- startup-config: la configuración guardada en el router/switch

    Router# copy running-config startup-config  # guardar configuración
    Router# wr  # guardar configuración abreviado

### Eliminar configuración 

    Router# reload  # eliminar configuración running
    Router# erase startup-config    # borrar toda la configuración


borrar confiuracion switch

    S1# erase startup-config
    S1# delete vlan.dat
    S1# reload


## Configuración de direcciones de IP

Ip interfaz de router

    R1# show interfaces
    R1# configure terminal 
    R1(config)# interface GigabitEthernet0/0/0
    R1(config-if)# description Link to LAN
    R1(config-if)# ip address 192.168.1.1 255.255.255.0
    R1(config-if)# ipv6 address 2001:db8:acad:10::1/64
    R1(config-if)# no shutdown

link-local en ipv6

    R1(config)# interface gigabitethernet 0/0/1
    R1(config-if)# ipv6 address fe80::2:1 link-local
    R1(config-if)# exit

IP interfaz virtual de switch

    Switch# show run
    ...
    interface Vlan1
    no ip address
    shutdown
    ...

    Sw-Floor-1# configure terminal
    Sw-Floor-1(config)# interface vlan 1
    Sw-Floor-1(config-if)# ip address 192.168.1.20 255.255.255.0
    Sw-Floor-1(config-if)# no shutdown
    Sw-Floor-1(config-if)# exit
    Sw-Floor-1(config)# ip default-gateway 192.168.1.1

Interfaz loopback

    R1(config)# interface loopback 0
    R1(config-if)# ip address 10.0.0.1 255.255.255.0
    R1(config-if)# exit

## interfaz router on a stick

Habilitar interfaz fisica

    R1(congig)# interface gigabitethernet 0/0
    R1(congig-if)# no shutdown
    R1(congig-if)#  description trunk link

Creat interfaz virtual e habilitar encapsulacion

    R1(congig)# interface gigabitethernet 0/0.10
    R1(congig-if)# description default Gateway for VLAN 10
    R1(congig-if)# encapsulation dot1Q 10
    R1(congig-if)# ip address 192.168.10.1 255.255.255.0

## Denegar broadcast

     no ip directed-broadcasts
    
## enrutador IPv6

Ser enrutador IPv6 quiere decir que se enviara el mensage RA cada 200 segundos a la red para que los host finales configuren su IPv6 adecuada.

    ipv6 unicast-routing 


## copiar archivos mediante tftp

    show  flash:
    copy flash: tftp:
    copy  tftp: flash:

## especificar con que configuración IOS arrancar

    S1# show  flash:
    S1(config)# boot system nombre-archivo
    S1(config)# boot system flash:/"archivo de IOS.bin"

## Seguridad basica

caracteres minimos en contraseñas

    R1(config)# security passwords min-length 8 
    
cerrar sesion inactiva a los 5:20 segundos

    R1(config-line)# exec-timeout 5 20 # 5 minutos 20 segundos

bloquear acceso durante 120 segundos si en 60 segundos fallas 3 veces el login

    R1(config)# login block-for 120 attempts 3 within 60

Seguridad basica inicial de cisco, cisco por defecto viene con una serie de puertos abiertos, ...
Con auto secure, te hace una serie de preguntas para autoconfigurar la seguridad.

    Router# auto secure



## auto-mdix

MDIX es la configuración para negociar el tipo de cable y así no tener que estar mirando si as conectado uno directo o cruzado.

    S1(config-if)# mdix auto
    S1# show controllers    # ver tipo de cableado
    S1# show controllers ethernet-controller fa0/1 phy | include MDIX   # mvr MIX habilitado

## DHCP

Lo primero es excluid las ip que seran estaticas en cada red

    Router(config)# ip dhcp excluded-address 192.168.1.1 192.168.1.10

Crear pool para cada red 

    Router(config)# ip dhcp pool RED-1
    Router(dhcp-config)#?
    default-router  Default routers
    dns-server      Set name server
    domain-name     Domain name
    exit            Exit from DHCP pool configuration mode
    network         Network number and mask
    no              Negate a command or set its defaults
    option          Raw DHCP options

    Router(dhcp-config)# network 192.168.1.0 255.255.255.0
    Router(dhcp-config)# default-router 192.168.1.1
    Router(dhcp-config)# dns-server 1.1.1.1
    Router(dhcp-config)# domain-name ccna.org

Comandos de ayuda

    show running-config | section dhcp
    show ip dhcp binding
    show ip dhcp server statistics
    show ip dhcp conflicts

Habilitar/desabilitar dhcp

    Router(config)# service dhcp
    Router(config)# no service dhcp

Interfaz router como cliente

    SOHO(config)# interface G0/0/1
    SOHO(config-if)# ip address dhcp
    SOHO(config-if)# no shutdown

### relay

el agente relay reenvia solicitudes dhcp de una red a otra.

Interfaz donde se recibira el brodcast dhcp, e ip del servidor dhcp

    Router(config)# interface g0/0/0
    Router(config-if)# ip helper-address 192.168.2.6

## SLAAC DHCPv6

ordenes de ayuda

    show ipv6 dhcp pool
    show ipv6 dhcp binding
    show ipv6 dhcp interfaces

Estados

    ipv6 unicast-routing # activar slaac
    ipv6 nd other-config-flag # slaac +dhcpv6 stateless (sin estado)
    ipv6 nd managed-config-flag # dhcpv6 stateful (con stado)

### SLAAC + DHCPv6 Stateless

Configurar Router como slaac y dhcpv6 stateless

SLAAC proporcionara prefijo y puerta de enlace y el DHCPv6 la informacion complementaria


    R1(config)# ipv6 unicast-routing
    R1(config)# ipv6 dhcp pool IPV6-STATELESS

    R1(config-dhcpv6)# dns-server 2001:db8:acad:1::254
    R1(config-dhcpv6)# domain-name example.com
    R1(config-dhcpv6)# exit

    R1(config)# interface GigabitEthernet0/0/1
    R1(config-if)# description Link to LAN
    R1(config-if)# ipv6 address fe80::1 link-local
    R1(config-if)# ipv6 address 2001:db8:acad:1::1/64
    R1(config-if)# ipv6 nd other-config-flag
    R1(config-if)# ipv6 dhcp server IPV6-STATELESS
    R1(config-if)# no shut


### Cliente DHCPv6 stateless

    R3(config)# ipv6 unicast-routing

    R3(config)# interface g0/0/1
    R3(config-if)# ipv6 enable
    R3(config-if)# ipv6 address autoconfig

    R3# show ipv6 interface brief
    R3# show ipv6 dhcp interface g0/0/1

### servidor DHCP Stateful

Configurar router como SLAAC y DHCPv6 stateful

SLAAC proporciona Puerta de enlace y el DHCPv6 proporciona: prefijo, red, información complementaria y hace seguimiento de irecciones asignadas.

    R1(config)# ipv6 unicast-routing
    R1(config)# ipv6 dhcp pool IPV6-STATEFUL

    R1(config-dhcpv6)# address prefix 2001:db8:acad:1::/64
    R1(config-dhcpv6)# dns-server 2001:4860:4860: :8888
    R1(config-dhcpv6)# domain-name example.com

    R1(config)# interface GigabitEthernet0/0/1
    R1(config-if)# description Link to LAN
    R1(config-if)# ipv6 address fe80::1 link-local
    R1(config-if)# ipv6 address 2001:db8:acad:1::1/64
    R1(config-if)# ipv6 nd managed-config-flag
    R1(config-if)# ipv6 nd prefix default no-autoconfig
    R1(config-if)# ipv6 dhcp server IPV6-STATEFUL
    R1(config-if)# no shut

### cliente DHCPv6 stateful

    R3(config)# ipv6 unicast-routing

    R3(config)# interface g0/0/1
    R3(config-if)# ipv6 enable
    R3(config-if)# ipv6 address dhcp

    R3# show ipv6 interface brief
    R3# show ipv6 dhcp interface g0/0/1

### DHCPv6 relay

    Router(config-if)# ipv6 dhcp relay destination ipv6-address [interface-type interface-number]

    R1(config)# interface gigabitethernet 0/0/1
    R1(config-if)# ipv6 dhcp relay destination 2001:db8:acad:1::2 G0/0/0
    R1(config-if)# exit


## FHRP

FHRP es un protocolo de reundancia entre routers, donde se cre un router virtual en un grupo de routers fisicos

    R1(config)# interface g0/0
    R1(config-if)# standby version 2
    R1(config-if)# standby 1 ip 192.168.1.254
    R1(config-if)# standby 1 priority 150  # por defecto prioridad 100, rango 0-255
    R1(config-if)# standby 1 preempt # este router sera el activo predeterminado

    show standby
    show standby brief

## Enrutamiento 

### estatico


    show ip route
    show ip route static
    show ip route network

de siguinte salto

    ip  route 10.0.4.0 255.255.255.0 10.0.3.2
    ipv6 route 2001:db8:acad:4::/64 2001:db8:acad:3::2

conectada directamente

    ip  route 10.0.4.0 255.255.255.0 g0/1
    ipv6 route 2001:db8:acad:4::/64 s0/0

totalmente especificada

    R1(config)# ip route 172.16.1.0 255.255.255.0 GigabitEthernet 0/0/1 172.16.2.2 
    R1(config)# ipv6 route 2001:db8:acad:1::/64 s0/1/0 fe80::2

### predeterminadas

    Router(config)# ip route 0.0.0.0 0.0.0.0 {ip-address | exit-intf}
    Router (config) # ipv6 route ::/0 {ipv6-address | exit-intf}

    R1 (config) # ip route 0.0.0.0 0.0.0.0 172.16.2.2
    R1 (config) # ipv6 route ::/0 2001:db8:acad:2::2

Las rutas predeterminadas flotantes, son rutas de respaldo se aumenta la distancia administrativa 
para que si la ruta principal falla, esta se assigne

    R1(config)# ip route 0.0.0.0 0.0.0.0 10.10.10.2 5 
    R1 (config)# ipv6 route ::/0 2001:db8:feed:10::2 5

## OSPF enrutamiento dinamico


Ordenes de ayuda

    show ip ospf neighbor
    show ip ospf database
    show ip ospf inteface g0/0
    show ip route
    show ip route ospf
    show ip protocols
    
    debug ip ospf adj 

recargar protocolo

    clear ip ospf process

assignar prioridad de DR

    R1(config)# interface GigabitEthernet 0/0/0 
    R1(config-if)# ip ospf priority 255
    R1#  clear ip ospf process

Assignar ID

    R1(config)# router ospf 1
    R1(config-if)# router-id 2.2.2.2
    R1#  clear ip ospf process

Añadir network mediante red

    router ospf 1
    Router(config-router)# network network-address wildcard-mask area area-id
    network 192.168.1.0 0.0.0.255 area 0

Añadir network mediante ip

    R1(config)# router ospf 10 
    R1 (config-router)# network 10.10.1.1 0.0.0.0 area 0 

Añadir network mediante interface

    R1(config-if)# interface GigabitEthernet 0/0/1 
    R1(config-if) # ip ospf 10 área 0 

interfaz passiva

La inerfaz passiva no envia mensages continuos de verificación, ...

    R1(config)# router ospf 10 
    R1 (config-router)# passive-interface loopback 0

    # todas las interfaces pasivas
    R1(config)# router ospf 10 
    R1 (config-router)# passive-interface default

interfaz punt a punto

    R1(config)# interface GigabitEthernet 0/0/0 
    R1(config-if)# ip ospf network point-to-point

modificar costo de interfaz

    R1 (config) # interfaz g0/0/1
    R1 (config-if) # ip ospf cost 30

    # reajustar costo
    R1(config)# router ospf 10
    R1(config-router)# auto-cost reference-bandwidth 1000

modificar tiempo paquetes hello

    R1(config)# interface g0/0/0 
    R1(config-if)# ip ospf hello-interval 5 
    R1(config-if)# ip ospf dead-interval 20 

publicar ruta predeterminada

    R2(config)# ip route 0.0.0.0 0.0.0.0 s0/0/1
    R2(config)# router ospf 10 
    R2(config-router)# default-information originate 


## ACL

show

    show access-list
    show ip interface g0/0/0

Limpiar registros

    clear access-list counters

assignar lista acl a interfaz

    interface g0/0
    Router(config-if) # ip access-group {access-list-number | access-list-name} {in | out}

### estandar

las ACL estandar trabajan en capa 3 IP Ethernet

ejemplo estandar numerada

    R1(config)# access-list 10 remark ACE permits all host in LAN 2
    R1(config)# access-list 10 permit 192.168.20.0 0.0.0.255

    R1(config)# interface Serial 0/1/0
    R1(config-if)# ip access-group 10 out


ejemplo estandar nombrada

    R1(config)# ip access-list standard PERMIT-ACCESS

    R1(config-std-nacl)# remark ACE permits host 192.168.10.10
    R1(config-std-nacl)# permit host 192.168.10.10

    R1(config-std-nacl)# remark ACE permits all hosts in LAN 2
    R1(config-std-nacl)# permit 192.168.20.0 0.0.0.255

    R1(config)# interface Serial 0/1/0
    R1(config-if)# ip access-group PERMIT-ACCESS out
    R1(config-if)# end

modificar

    R1(config)# ip access-list standard NAME-LIST
    R1(config-std-nacl)# no 10
    R1(config-std-nacl)# 10 deny host 192.168.10.10


### Extendidas

numeradas

    access-list 100 permit tcp 192.168.20.0 0.0.0.255 192.168.30.0 0.0.0.255 eq 80
    access-list 100 permit tcp 192.168.20.0 0.0.0.255 any eq 443

    R1(config)# access-list 100 permit tcp any any eq 22
    R1(config)# access-list 100 permit tcp any any eq 443

numerada established

    R1(config)# access-list 120 permit tcp any 192.168.10.0 0.0.0.255 established
    R1(config)# interface g0/0/0 
    R1(config-if)# ip access-group 120 out 

nombradas 

    R1(config)# ip access-list extended FTP-FILTER 
    R1(config-ext-nacl)# permit tcp 192.168.10.0 0.0.0.255 any eq ftp 
    R1(config-ext-nacl)# permit tcp 192.168.10.0 0.0.0.255 any eq ftp-data



    R1(config)# ip access-list extended SURFING
    R1(config-ext-nacl)# Remark Permits inside HTTP and HTTPS traffic 
    R1(config-ext-nacl)# permit tcp 192.168.10.0 0.0.0.255 any eq 80
    R1(config-ext-nacl)# permit tcp 192.168.10.0 0.0.0.255 any eq 443
    R1(config-ext-nacl)# exit
    
    R1(config)# ip access-list extended BROWSING
    R1(config-ext-nacl)# Remark Only permit returning HTTP and HTTPS traffic 
    R1(config-ext-nacl)# permit tcp any 192.168.10.0 0.0.0.255 established
    R1(config-ext-nacl)# exit
    
    R1(config)# interface g0/0/0
    R1(config-if)# ip access-group SURFING in
    R1(config-if)# ip access-group BROWSING out

editar 

    R1# configure terminal
    R1(config)# ip access-list extended SURFING 
    R1(config-ext-nacl)# no 10
    R1(config-ext-nacl)# 10 permit tcp 192.168.10.0 0.0.0.255 any eq www
    R1(config-ext-nacl)# end


### asegurar VTY con ACL

    R1(config)# username ADMIN secret class
    R1(config)# ip access-list standard ADMIN-HOST
    R1(config-std-nacl)# remark This ACL secures incoming vty lines
    R1(config-std-nacl)# permit 192.168.10.10
    R1(config-std-nacl)# deny any
    R1(config-std-nacl)# exit

    R1(config)# line vty 0 4
    R1(config-line)# login local
    R1(config-line)# transport input ssh
    R1(config-line)# access-class ADMIN-HOST in




## NAT

ayuda

    show ip nat translations
    show ip nat stats
    show ip nat statistics

borrar estadisticas

    clear ip nat statistics


Estatico

    R2(config)# ip nat inside source static 192.168.10.254 209.165.201.5

    R2(config)# interface GigabitEthernet 0/1/0
    R2(config-if)# ip nat inside
    R2(config-if)# exit
    R2(config)# interface serial 0/1/1
    R2(config-if)# ip nat outside

Dinamico

    R2(config)# ip nat pool NAT-POOL1 209.165.200.226 209.165.200.240 netmask 255.255.255.224
    R2(config)# access-list 1 permit 192.168.0.0 0.0.255.255
    R2(config)# ip nat inside source list 1 pool NAT-POOL1
    
    R2(config)# interface serial 0/1/0
    R2(config-if)# ip nat inside
    R2(config-if)# interface serial 0/1/1
    R2(config-if)# ip nat outside

tiempo valido de traducciones

    ip nat translation timeout <timeout-seconds> # por defecto 24h

    # limpiar traducciones
    clear ip nat translation *
    clear ip nat translation insideglobal-ip local-ip [outside local-ip global-ip]
    clear ip nat translation protocolinsideglobal-ip global-port local-ip local-port [ fuera delocal-ip local-port global-ip global-port]

> esta opcion solo funciona con traducciones dinamicas

### PAT

Una unica direccion IPv4

    R2(config)# ip nat inside source list 1 interface serial 0/1/1 overload
    R2(config)# access-list 1 permit 192.168.0.0 0.0.255.255
    R2 (config) # interfaz serial0/1/0
    R2(config-if)# ip nat inside
    R2(config-if)# exit
    R2 (config) # interfaz Serial0/1/1
    R2(config-if)# ip nat outside

Grupo de direcciones

    R2(config)# ip nat pool NAT-POOL2 209.165.200.226 209.165.200.240 netmask 255.255.255.224
    R2(config)# access-list 1 permit 192.168.0.0 0.0.255.255
    R2(config)# ip nat inside source list 1 pool NAT-POOL2 overload
    R2(config)# interface serial0/1/0
    R2(config-if)# ip nat inside
    R2 (config-if) # interfaz serial0/1/1
    R2(config-if)# ip nat outside



## CDP/LLDP

deteccion de vecinos, cdp y lldp es lo mismo, pero cdp es propietario de cisco y lldp es libre

    show cdp ?
    show cdp neighbords
    show cdp neighbords detail
    show cdp interface

    show lldp ?
    show lldp neighbords
    show lldp neighbords detail
    show lldp interface

Habilitr/deshabilitar cdp en una interfaz

    R1(config-if)# cdp enable
    R1(config-if)# no cdp enable

    R1(config)# interface gigabitethernet 0/1 
    R1(config-if)# lldp transmit 
    R1(config-if)# lldp receive 

habilitar/deshabilitar cdp global (todas las interfaces)

    R1(config)# cdp run
    R1(config)# no cdp run

    R1(config)# lldp run 

## NTP

Servidor de tiempo

    R1# show clock detail 
    R1# show ntp associations
    R1# show ntp status 

configurar fecha manualmente

    R1# clock set 20:36:00 nov 15 2019 

configurar fecha mediante seridor ntp

    R1(config)# ntp server 209.165.200.225 


## Syslog

Logs con tiempo 

    R1(config)# service timestamps log datetime msec

Enviar logs a servidor remoto

    R1(config)# logging 10.0.1.10

## Backups y systema de archivos

moverse en systemas de archivos

    show file systems
    dir
    cd
    pwd

copiar archivo de configuracion por tftp

    R1# copy running-config tftp:
    Remote host []? 192.168.10.254 
    Name of the configuration file to write[R1-config]? R1-Jan-2019
    Write file R1-Jan-2019 to 192.168.10.254? [confirm] 
    Writing R1-Jan-2019 !!!!!! [OK]

Copiar config en USB

    R1# copy running-config usbflash0: 
    Destination filename [running-config]? Configuración R1- 
    %Warning:There is a file already existing with this name 
    Do you want to over write? [confirm] 

Restaurar desde USB

    R1# copy usbflash0:/R1-Config running-config

Arrancar desde otra imagen IOS

    R1# configure terminal 
    R1 (config) # boot system flash0:isr4200-universalk9_ias.16.09.04.SPA.bin 
    R1(config)# exit 
    R1# copy running-config startup-config 
    R1# reload

### Cambio contraseña enable

Si te has olvidado de la contraseña de un router/switch y tienes que acceder
Desde cable consola seguir los siguientes pasos


    # Entrar modo rommon 

    mientras arranca el router Ctrl + C
    rommon 1 >

    # canviar numero de registro

    rommon 1 > confreg 0x2142 
    rommon 2 > reset 

    # copiar configuracin antigua

    Router# copy startup-config running-config

    # cambiar contraseñas

    R1(config)# enable secret cisco

    # volver a poner registro antiguo y copiar configuracion

    R1(config)# config-register 0x2102
    R1(config)# end 
    R1# copy running-config startup-config 


































    

---

## Switch


    # añadir gateway para acceso remoto
    S1# configure terminal
    S1(config)# ip default-gateway 192.168.1.1
    S1(config)# end
    S1# copy running-config startup-config

Comprobar

    show ip interface brief
    show ipv6 interface brief 

ver plantillas disponibles, estas plantillas definiran que redireccionamiento puede hacer

    show sdm prefer
    sdm prefer dual-ipv4-and-ipv6 default

### creacion de vlan

    # crear y activar vlan 99
    S1(config)# vlan 99
    S1(config-vlan)# name mandarinas


### assignar VLAN a puerto

    S1(config)# interface fastethernet 0/1
    S1(config-if)# switchport mode access
    S1(config-if)# switchport access vlan 10

    # si la vlan sera para voz
    S1(config-if)# switchport voice vlan 100
    S1(config-if)# mls qos trust cos

### eliminar vlan

    # antes de borrar una vlan mover los puertos assignados
    S1(config)# no vlan 99

### activar puerto como troncal

Un puerto troncal es un puerta que comunica diferentes VLAN entre switches o routers

    # activar modo troncal
    S1(config)# interface fastEthernet 0/1
    S1(config-if)# switchport mode trunk

    # assignar troncal a nativa diferente
    S1(config-if)# switchport trunk native vlan 99

    # en caso de que no cojamlas VLAN automatcamente
    S1(config-if)# switchport trunk allowed vlan 10,20,30,99

    S1# show interfaces trunk
    S1# show interfaces fa0/1 switchport

Modos de troncales

    Switch(config)# switchport mode { access | dynamic { auto | desirable } | trunk }
    show dtp interface fa 0/1

eliminar troncal

    S1(config)# interface fa0/1
    S1(config-if)# no switchport trunk allowed vlan
    S1(config-if)# no switchport trunk native vlan
    S1(config-if)# end

### rescate switch cisco

- conectar por consola 
- despues apagar y encender switch
- apretar el boton mode durante 15 en el arranque
- en la ventana de consola aparecera "The boot loader switch"

    switch: set
    BOOT=flash:/c2960-lanbasek9-mz.122-55.SE7/c2960-lanbasek9-mz.122-55.SE7.bin
    (output omitted)
    switch: flash_init  # inicialice el sistema de archivos flash

    switch: dir flash: 
    switch: BOOT=flash:c2960-lanbasek9-mz.150-2.SE8.bin
    switch: set
    BOOT=flash:c2960-lanbasek9-mz.150-2.SE8.bin
    (output omitted)
    
    switch: boot


### configuracion duplex

Duplex es la configuración de datos bidireccional

    S1(config)# interface FastEthernet 0/1
    S1(config-if)# duplex {full|half|auto}
    S1(config-if)# speed {10|100|auto}

### switch capa 3

convertir interfaz en capa 3 para enlazar con router u otro switch capa 3

    D1(config)# interface GigabitEthernet1/0/1
    D1(config-if)# description routed Port Link to R1
    D1(config-if)# no switchport
    D1(config-if)# ip address 10.10.10.2 255.255.255.0
    D1(config-if)# no shut

Habilitar enrutamiento

    Switch(config)# ip routing
    Switch# show ip route

puerto  SVI

    D1(config)# interface vlan 10
    D1(config-if)# description Default Gateway SVI for 192.168.10.0/24
    D1(config-if)# ip add 192.168.10.1 255.255.255.0
    D1(config-if)# no shut
    D1(config-if)# exit

puerto de acceso

    D1(config)# interface GigabitEthernet1/0/6
    D1(config-if)# description Access port to PC1
    D1(config-if)# switchport mode access
    D1(config-if)# switchport access vlan 10
    D1(config-if)# exit

configurar el enrutamiento

    D1(config)# router ospf 10
    D1(config-router)# network 192.168.10.0 0.0.0.255 area 0
    D1(config-router)# network 192.168.20.0 0.0.0.255 area 0
    D1(config-router)# network 10.10.10.0 0.0.0.3 area 0

### VTP

VTP es un protocolo de comunicación entre switches donde se define un servidor y x clientes 
que se replicará la configuración dinamicamente

- configurar todos los switches con conexiones trunk entre ellos con naive 99 por ejemplo
- configurar switch que ara de servidor
- configurar clientes

> Cuidado! al añadir un nuevo switch a la red, por defecto vienen en modo server y si tiene el `Configuration Revision` mas alto que el servidor actual el nuevo server ara de principal y sobreescribira la configuración existente

    # configurar como server
    show vtp status
    vtp mode server
    vtp domain Cisco
    vtp password miputopassword
    show vtp password

    # configurar en cliente
    vtp mode client
    vtp domain Cisco
    vtp password miputopassword
    show vtp status

    # configuracion transparente, estoy en la red pero no hago caso.
    vtp mode transparent

### STP spaning-tree

Spaning-tree es el protocolo para evitar bucles entre switches

    show spaning-tree

    # activar RSTP
    spaning-tree pvst 
    spaning-tree mode rapid-pvst

    # asignar raiz automaticamente
    spaning-tree vlan 1,10,20,30 root primary 
    
    # asignar secundario
    spaning-tree vlan 1,10,20,30 root secondary

#### PortFast y bpduGuard

Cuando un puerto de switch está configurado con PortFast, ese puerto pasa de un estado de bloqueo al de reenvío inmediatamente, evitando el retraso de 30 segundos. 

Un puerto de switch habilitado para PortFast nunca debería recibir BPDU porque eso indicaría que el switch está conectado al puerto

    S1(config)# interface fa0/1
    S1(config-if)# switchport mode access
    S1(config-if)# spanning-tree portfast
    S1(config-if)# spanning-tree bpduguard enable

### EtherChannel

EtherChannel es un protocolo para unir logicamente varios puertos en uno y asi duplicar hasta 8 su rendimiento.

    show etherchannel summary
    show interfaces port-channel
    show etherchannel port-channel
    show interfaces etherchannel

    S1(config)# interface range FastEthernet 0/1 - 2
    S1(config-if-range)# channel-group 1 mode active
    Creating a port-channel interface Port-channel 1
    S1(config-if-range)# exit
    S1(config)# interface port-channel 1
    S1(config-if)# switchport mode trunk
    S1(config-if)# switchport trunk allowed vlan 1,2,20



### Seguridad

#### seguridad a nivel de puerto

Asignar mac a un puerto

    S1(config)# interface f0/1
    S1(config-if)# switchport mode access
    S1(config-if)# switchport port-security

    S1(config-if)# switchport port-security mac-address <mac>
    S1(config-if)# switchport port-security mac-address sticky

Para poner el numero máximo de direcciones MAC permitidas en un puerto

    Switch(config-if)# switchport port-security maximum value 
    Switch(config-if)# switchport port-security maximum 1-8192

Que hacer cuando detecte una MAC que no toca en un puerto

    S1(config-if)# switchport port-security violation {protect|restrict|shutdown}

ayudas

    S1# show port-security interface f0/1
    S1# show port-security address
    S1# show port-security

#### seguridad paquetes dhcp

interfaz  dhcp confiable

    S1(config)# ip dhcp snooping
    S1(config)# interface f0/1
    S1(config-if)# ip dhcp snooping trust
    S1(config-if)# exit

interfaz con limite de solicitudes dhcp

    S1(config)# interface range f0/5 - 24
    S1(config-if-range)# ip dhcp snooping limit rate 6
    S1(config-if-range)# exit

vlan que puede pasar dhcp

    S1(config)# ip dhcp snooping vlan 5,10,50-52

    S1# show ip dhcp snooping


#### activar DAI inspeccion dinamica de paquetes

    S1(config)# ip dhcp snooping
    S1(config)# ip dhcp snooping vlan 10
    S1(config)# ip arp inspection vlan 10
    S1(config)# interface fa0/24
    S1(config-if)# ip dhcp snooping trust
    S1(config-if)# ip arp inspection trust

    S1(config)# ip arp inspection validate ?
    dst-mac  Validate destination MAC address
    ip       Validate IP addresses
    src-mac  Validate source MAC address
