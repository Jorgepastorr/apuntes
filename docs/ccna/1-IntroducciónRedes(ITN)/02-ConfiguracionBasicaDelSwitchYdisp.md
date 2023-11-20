# Configuración básica del Switch y dispositivo final

## Acceso a Cisco IOS

### Modos de acceso

**Consola:** Puerto de administración física utilizado para acceder a un dispositivo con el fin de proporcionar mantenimiento, como realizar las configuraciones iniciales. 

**Secure Shell (SSH):** Establece una conexión CLI remota segura a un dispositivo, a través de una interfaz virtual, a través de una red. (Nota: Este es el método recomendado para conectarse remotamente a un dispositivo.) 

**Telnet:** Establece una conexión CLI remota insegura a un dispositivo a través de la red.  (Nota: La autenticación de usuario, las contraseñas y los comandos se envían por la red en texto simple.) 

## Navegación del IOS

### Modos de comando principales

Modo EXEC de usuario 

- Permite el acceso solamente a una cantidad limitada de comandos básicos de monitoreo.
- El modo EXEC de usuario se identifica porque el indicador de la CLI que finaliza con el símbolo `>`.

Privileged EXEC Mode: 

- Permite el acceso a todos los comandos y funciones.
- Identificado por la solicitud de CLI que termina con el símbolo `#`

### Modo de configuración y modos de subconfiguración

- Modo de configuración global: Se utiliza para acceder a las opciones de configuración del dispositivo 
- Modo de configuración de línea: Se utiliza para configurar el acceso a la consola, SSH, Telnet o AUX
- Modo de configuración de interfaz: Se utiliza para configurar un puerto de switch o una interfaz de router

### Navegación entre modos IOS

Modo EXEC privilegiado:

- Para pasar del modo EXEC del usuario al modo EXEC con privilegios, ingrese el comando `enable`.

Modo de configuración global: 

- Para entrar y salir del modo de configuración global, use el comando `configure terminal`  Para volver al modo EXEC privilegiado, use el comando exit 

Modo de configuración de línea: 

- Para entrar y salir del modo de configuración de línea, utilice el comando `line` seguido del tipo de línea de administración. `line console 0`

Resumen:

    Router> enable   # acceder modo privilegiado
    exit            # salir del modo actual
    end             # volver al modo privilegiado
    Router# configure terminal      # acceder modo configuración
    Router(config)# line console 0  # acceder modo configuraccion de linea
    Router(config)# interface FastEthernet 0/1  # acceder modo configuraccion de interfaz


## Configuración básica de dispositivos

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

### Banner

Un mensaje de banner es importante para advertir al personal no autorizado de intentar acceder al dispositivo.

    R1(config)# banner motd "WARNING!! Solo personal autorizado"

### Hora

    Router# show clock
    Router# clock set 13:00:00 february 2023

## Guardar las configuraciones

Existen dos archivos de sistema que almacenan la configuración de dispositivos.

- running-config: es la configuración que estas corriendo en el momento
- startup-config: la configuración guardada en el router/switch

    Router# show running-config
    Router# show startup-config
    Router# copy running-config startup-config  # guardar configuración
    Router# wr  # guardar configuración abreviado

### Eliminar configuración 

    Router# reload  # eliminar configuración running
    Router# erase startup-config    # borrar configuración


## Configuración de direcciones de IP

    R1# show interfaces
    R1# configure terminal 
    R1(config)# interface GigabitEthernet0/0/0
    R1(config-if)# ip address 192.168.1.1 255.255.255.0
    R1(config-if)# no shutdown

    R1(config-if)#
    %LINK-5-CHANGED: Interface GigabitEthernet0/0/0, changed state to up

Para acceder al switch de manera remota, se deben configurar una dirección IP y una máscara de subred en la SVI. (switch virtual inmterface)

    Switch# show run
    ...
    interface Vlan1
    no ip address
    shutdown
    ...

    Switch# configure terminal
    Switch(config)# interface Vlan1
    Switch(config-if)# ip address 192.168.1.10 255.255.255.0
    Switch(config-if)# no shutdown
