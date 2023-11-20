# DHCPv4

## Conceptos DHCPv4

### Servidor y cliente


Dynamic Host Configuration Protocol v4 (DHCPv4) asigna direcciones IPv4 y otra información de configuración de red dinámicamente. Dado que los clientes de escritorio suelen componer gran parte de los nodos de red, DHCPv4 es una herramienta extremadamente útil para los administradores de red y que ahorra mucho tiempo.

Un servidor de DHCPv4 dedicado es escalable y relativamente fácil de administrar. Sin embargo, en una sucursal pequeña o ubicación SOHO, se puede configurar un router Cisco para proporcionar servicios DHCPv4 sin necesidad de un servidor dedicado. El software Cisco IOS admite un servidor DHCPv4 con funciones completas opcional.


El servidor DHCPv4 asigna dinámicamente, o arrienda, una dirección IPv4 de un conjunto de direcciones durante un período limitado elegido por el servidor o hasta que el cliente ya no necesite la dirección.

Los clientes arriendan la información del servidor durante un período definido administrativamente. Los administradores configuran los servidores de DHCPv4 para establecer los arrendamientos, a fin de que caduquen a distintos intervalos. El arrendamiento típicamente dura de 24 horas a una semana o más. Cuando caduca el arrendamiento, el cliente debe solicitar otra dirección, aunque generalmente se le vuelve a asignar la misma.

### Operación DHCPv4


DHCPv4 funciona en un modo cliente/servidor. Cuando un cliente se comunica con un servidor de DHCPv4, el servidor asigna o arrienda una dirección IPv4 a ese cliente. 

- El cliente se conecta a la red con esa dirección IPv4 arrendada hasta que caduque el arrendamiento. El cliente debe ponerse en contacto con el servidor de DHCP periódicamente para extender el arrendamiento. 
- Este mecanismo de arrendamiento asegura que los clientes que se trasladan o se desconectan no mantengan las direcciones que ya no necesitan. 
- Cuando caduca un arrendamiento, el servidor de DHCP devuelve la dirección al conjunto, donde se puede volver a asignar según sea necesario.

### Pasos para obtener una concesión

Cuando el cliente arranca (o quiere unirse a una red), comienza un proceso de cuatro pasos para obtener un arrendamiento:

1. Detección de DHCP (DHCPDISCOVER)
2. Oferta de DHCP (DHCPOFFER)
3. Solicitud de DHCP (DHCPREQUEST)
4. Acuse de recibo de DHCP (DHCPACK)

### Pasos para renovar una concesión

Antes de la expiración de la concesión, el cliente inicia un proceso de dos pasos para renovar la concesión con el servidor DHCPv4, como se muestra en la figura:

1. Solicitud de DHCP (DHCPREQUEST)

Antes de que caduque el arrendamiento, el cliente envía un mensaje DHCPREQUEST directamente al servidor de DHCPv4 que ofreció la dirección IPv4 en primera instancia. Si no se recibe un mensaje DHCPACK dentro de una cantidad de tiempo especificada, el cliente transmite otro mensaje DHCPREQUEST de modo que uno de los otros servidores de DHCPv4 pueda extender el arrendamiento.

2. Acuse de recibo de DHCP (DHCPACK)

Al recibir el mensaje DHCPREQUEST, el servidor verifica la información del arrendamiento al devolver un DHCPACK.

## Configurar un servidor DHCPv4 del IOS de Cisco

### Pasos para configurar un servidor DHCPv4 de Cisco IOS


Utilice los siguientes pasos para configurar un servidor DHCPv4 del IOS de Cisco:

1. Excluir direcciones IPv4, Se puede excluir una única dirección o un rango de direcciones especificando la dirección más baja y la dirección más alta del rango. Las direcciones excluidas deben incluir las direcciones asignadas a los routers, a los servidores, a las impresoras y a los demás dispositivos que se configuraron o se configurarán manualmente. También puede introducir el comando varias veces. El comando es `ip dhcp excluded-address low-address [high-address]`

2. Defina un nombre de grupo DHCPv4. El comando `ip dhcp pool pool-name` crea un conjunto con el nombre especificado y coloca al router en el modo de configuración de DHCPv4.

3. Configure el grupo DHCPv4. El conjunto de direcciones y el router de gateway predeterminado deben estar configurados. Utilice la instrucción network para definir el rango de direcciones disponibles. Utilice el comando default-router para definir el router de gateway predeterminado. Estos comandos y otros comandos opcionales se muestran en la tabla. 

    Router(config)# ip dhcp pool RED-1
    Router(dhcp-config)#?
    default-router  Default routers
    dns-server      Set name server
    domain-name     Domain name
    exit            Exit from DHCP pool configuration mode
    network         Network number and mask
    no              Negate a command or set its defaults
    option          Raw DHCP options

#### ejemplo de configuración

    Router(config)# ip dhcp excluded-address 192.168.1.1 192.168.1.10

    Router(config)# ip dhcp pool RED-1
    Router(dhcp-config)# network 192.168.1.0 255.255.255.0
    Router(dhcp-config)# default-router 192.168.1.1
    Router(dhcp-config)# dns-server 1.1.1.1
    Router(dhcp-config)# domain-name ccna.org

### Desactivar el servidor DHCPv4


El servicio DHCPv4 está habilitado de manera predeterminada. Para deshabilitar el servicio, use el comando `no service dhcp` global configuration mode. Utilice el comando del modo de configuración del global `service dhcp` para volver a activar el proceso del servidor de DHCPv4. Si los parámetros no se configuran, active el servicio no tiene ningún efecto. 

> Nota: Si se borra los enlaces DHCP o se detiene y reinicia el servicio DHCP, se pueden asignar direcciones IP duplicadas en la red.

    Router(config)# no service dhcp
    Router(config)# service dhcp

### Relay DHCPv4

En una red jerárquica compleja, los servidores empresariales suelen estar ubicados en una central. Estos servidores pueden proporcionar servicios DHCP, DNS, TFTP y FTP para la red. Generalmente, los clientes de red no se encuentran en la misma subred que esos servidores. Para ubicar los servidores y recibir servicios, los clientes con frecuencia utilizan mensajes de difusión.

Si un host intenta adquirir una dirección IPv4 de un servidor de DHCPv4 mediante un mensaje de difusión y el servidor DHCP esta en otyra red y el router no está configurado como servidor de DHCPv4 y no reenvía el mensaje de difusión. Dado que el servidor de DHCPv4 está ubicado en una red diferente, el host no puede recibir una dirección IP mediante DHCP. El router debe configurarse para retransmitir mensajes DHCPv4 al servidor DHCPv4.


Configure el router con el comando de configuración `ip helper-address address interface`. Esto hará que R1 retransmita transmisiones DHCPv4 al servidor DHCPv4. la interfaz en R1 que recibe la difusión desde PC1 está configurada para retransmitir la dirección DHCPv4 al servidor DHCPv4 en 192.168.11.6.

Cuando se configura el R1 como agente de retransmisión DHCPv4, acepta solicitudes de difusión para el servicio DHCPv4 y, a continuación, reenvía dichas solicitudes en forma de unidifusión a la dirección IPv4 192.168.11.6. El administrador de red puede utilizar el comando `show ip interface` para verificar la configuración.

    Router(config)# interface g0/0/0
    Router(config-if)# ip helper-address 192.168.11.6

### Otras transmisiones de servicio retransmitidas

DHCPv4 no es el único servicio que puede configurarse para que retransmita el router. De manera predeterminada, el comando `ip helper-address` reenvía los siguientes ocho siguientes servicios UDP:

- Puerto 37: Tiempo
- Puerto 49: TACACS
- Puerto 53: DNS
- Puerto 67: servidor de DHCP/BOOTP
- Puerto 68: cliente DHCP/BOOTP
- Puerto 69: TFTP
- Puerto 137: servicio de nombres NetBIOS
- Puerto 138: servicio de datagrama NetBIOS

## Configurar un cliente DHCPv4

### Router Cisco como cliente DHCPv4. 

Hay escenarios en los que puede tener acceso a un servidor DHCP a través de su ISP. En estos casos, puede configurar un router Cisco IOS como cliente DHCPv4. 

Para configurar una interfaz Ethernet como cliente DHCP, utilice el comando del modo de configuración de interfaz `ip address dhcp`.

Suponga que un ISP ha sido configurado para proporcionar a clientes seleccionados direcciones IP del rango de red `209.165.201.0/27` después de que la interfaz `G0/0/1` es configurada con el comando `ip address dhcp` .

#### Ejemplo de Configuración de Cliente DHCPv4

Para configurar una interfaz Ethernet como cliente DHCP, utilice comando del modo de configuración de interfaz `ip address dhcp` como se muestra en el ejemplo. Esta configuración supone que el ISP se ha configurado para proporcionar a los clientes seleccionados información de direcciones IPv4.

    SOHO(config)# interface G0/0/1
    SOHO(config-if)# ip address dhcp
    SOHO(config-if)# no shutdown

    SOHO# show ip interface g0/0/1
    GigabitEthernet0/0/1 is up, line protocol is up
    Internet address is 209.165.201.12/27
    Broadcast address is 255.255.255.255
    Address determined by DHCP
    (output omitted)
