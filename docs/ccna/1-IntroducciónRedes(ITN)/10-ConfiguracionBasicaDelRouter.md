# Configuración básica del router

## Pasos básicos

### Hostname

El primer comando de configuración en cualquier dispositivo debe ser darle un nombre de host único. 

    Router(config)# hostname R1

### Contrasenyas

Todos los dispositivos de red deben limitar el acceso administrativo asegurando EXEC privilegiado

    Router(config)#  password mipassword        # añadir password texto plano
    Router(config)#  enable secret miotrapass   # añadir password encriptada
    Router(config)# login   # guardar password
    Router(config)# no <cualquier orden>    # "no" al principio elimina cualquier orden guardada

    R1(config)# service password-encryption # encriptar todas las contraseñas guardadas

Contraseña en consolas

    Router(config)# line console 0  # acceder modo configuraccion de linea
    Router(config)#  enable secret miotrapass   
    Router(config)# login   

    Router(config)# line vty 0 4
    Router(config)#  enable secret miotrapass   
    Router(config)# login   
    Router(config)# transport input {ssh | telnet} 

### Banner

Un mensaje de banner es importante para advertir al personal no autorizado de intentar acceder al dispositivo.

    R1(config)# banner motd "WARNING!! Solo personal autorizado"

### Guardar las configuraciones

Existen dos archivos de sistema que almacenan la configuración de dispositivos.

- running-config: es la configuración que estas corriendo en el momento
- startup-config: la configuración guardada en el router/switch

    Router# show running-config
    Router# show startup-config
    Router# copy running-config startup-config  # guardar configuración
    Router# wr  # guardar configuración abreviado

    Router# show flash

### Hora

    Router# show clock
    Router# clock set 13:00:00 february 2023


## Configurar interfaces

### Configuración de direcciones IP

    R1# show interfaces
    R1# configure terminal 
    R1(config)# interface GigabitEthernet0/0/0
    R1(config-if)# description description-text # opcional
    R1(config-if)# ip address 192.168.1.1 255.255.255.0
    R1(config-if)# ipv6 address 2001::1/64  # añadir ipv6
    R1(config-if)# no shutdown

Verificación de configuracion

    R1# show ip interface brief
    ¿Interface IP-Address OK? Method Status Protocol 
    GigabitEthernet0/0/0 192.168.10.1 YES manual up up 
    GigabiteThernet0/0/1 209.165.200.225 YES manual up up 
    Vlan1 unassigned YES unset administratively down down 

    R1# show ipv6 interface brief
    GigabitEthernet0/0/0 [up/up]
        FE80::201:C9FF:FE89:4501
        2001:DB8:ACAD:10::1
    GigabitEthernet0/0/1 [up/up]
        FE80::201:C9FF:FE89:4502
        2001:DB8:FEED:224::1
    Vlan1 [administratively down/down]
        unassigned 

### comandos de verificación

    show ip interface brief
    show ipv6 interface brief

    show ip route
    show ipv6 route

    show interfaces

    show ip interfaces
    show ipv6 interfaces

## Configuración de la puerta de enlace predeterminada en switch

    Switch# configure terminal
    Switch(config)# interface Vlan1
    Switch(config-if)# ip address 192.168.1.10 255.255.255.0
    Switch(config-if)# no shutdown
    Switch(config-if)# ip default-gateway 192.168.1.1