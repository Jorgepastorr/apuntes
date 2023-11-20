# Configuración de seguridad en el Switch

## Implementar Seguridad de Puertos (Port Security)

### Asegure los puertos no utilizados

Los ataques de Capa 2 son de los más sencillos de desplegar para los hackers, pero estas amenazas también pueden ser mitigadas con algunas soluciones comunes de capa 2.

Se deben proteger todos los puertos (interfaces) del switch antes de implementar el dispositivo para la producción. ¿Cómo se asegura un puerto dependiendo de su función?.

Un método simple que muchos administradores usan para contribuir a la seguridad de la red ante accesos no autorizados es inhabilitar todos los puertos del switch que no se utilizan. Navegue a cada puerto no utilizado y emita el comando de apagado shutdownde Cisco IOS. Si un puerto debe reactivarse más tarde, se puede habilitar con el comando no shutdown.

    S1(config)# interface range fa0/8 - 24
    S1(config-if-range)# shutdown

### Mitigar los ataques de la tabla de direcciones MAC

El método más simple y eficaz para evitar ataques por saturación de la tabla de direcciones MAC es habilitar el port security.

La seguridad de puertos limita la cantidad de direcciones MAC válidas permitidas en el puerto. Permite a un administrador configurar manualmente las direcciones MAC para un puerto o permitir que el switch aprenda dinámicamente un número limitado de direcciones MAC. Cuando un puerto configurado con port security recibe un trama, la dirección MAC de origen del trama se compara con la lista de direcciones 

MAC de origen seguro que se configuraron manualmente o se aprendieron dinámicamente en el puerto.
Al limitar a uno el número de direcciones MAC permitidas en un puerto, port security se puede utilizar para controlar el acceso no autorizado a la red.

    S1(config)# interface f0/1
    S1(config-if)# switchport mode access
    S1(config-if)# switchport port-security

### Limitar y aprender direcciones MAC

Para poner el número máximo de direcciones MAC permitidas en un puerto, utilice el siguiente comando

    Switch(config-if)# switchport port-security maximum value 

- El valor predeterminado de port security es 1. 
- El número máximo de direcciones MAC seguras que se puede configurar depende del switch y el IOS. 

El switch se puede configurar para aprender direcciones MAC en un puerto seguro de tres maneras:

1. Configuración manual: el administrador configura manualmente una dirección MAC estática mediante el siguiente comando para cada dirección MAC segura en el puerto:

    S1(config-if)# switchport port-security mac-address <mac>

2. Aprendizaje dinámico: cuando se ingresa el comando switchport port-security la fuente MAC actual para el dispositivo conectado al puerto se asegura automáticamente pero no se agrega a la configuración en ejecución. Si el switch es reiniciado, el puerto tendrá que re-aprender la direccion MAC del dispositivo.

3. Aprendizaje dinámico: – Sticky: el administrador puede configurar el switch para aprender dinámicamente la dirección MAC y "adherirla" a la configuración en ejecución mediante el siguiente comando:

    S1(config-if)# switchport port-security mac-address sticky

### activar Port Security

El vencimiento del port security puede usarse para poner el tiempo de vencimiento de las direcciones seguras estáticas y dinámicas en un puerto.

- Absoluta- Las direcciones seguras en el puerto se eliminan después del tiempo de caducidad especificado.
- Inactiva- Las direcciones seguras en el puerto se eliminan si están inactivas durante un tiempo específico.

Utilice el vencimiento para remover las direcciones MAC seguras en un puerto seguro sin necesidad de eliminar manualmente las direcciones MAC existentes. 

El vencimiento de direcciones seguras configuradas estáticamente puede ser habilitado o des-habilitado por puerto.


###  Modos de violación de Port Security

Si la dirección MAC de un dispositivo conectado a un puerto difiere de la lista de direcciones seguras, se produce una violación del puerto y el puerto entra en estado de error desactivado.

    S1(config-if)# switchport port-security violation {protect|restrict|shutdown}

#### shutdown

(predeterminados)	El puerto transiciona al estado de error-disabled inmediatamente, apaga el LED del puerto, y envía un mensaje syslog. Aumenta el contador de violaciones Contador. Cuando un puerto seguro esta en estado error-disabled un administrador debe re-habilitarlo ingresando los comandos shutdown y no shutdown .

#### restrict

El puerto bota los paquetes con direcciones MAC de origen desconocidas hasta que usted remueva un numero suficiente de direcciones MAC seguras para llegar debajo del maximo valor o incremente el máximo valor Este modo causa que el contador de violación de seguridad incremente y genere un mensaje syslog.

#### protect

Este modo es el menos seguro de los modos de violaciones de seguridad. No se realiza el tráfico de puertos los paquetes con direcciones MAC de origen desconocidas hasta que usted remueva un numero suficiente de direcciones MAC seguras para llegar debajo del valor máximo o o incremente el máximo valor No se envía ningún mensaje syslog.


## Mitigación de los ataques de VLAN

### Revisión de ataques de VLAN

Un ataque de salto de VLAN se puede iniciar de una de tres maneras:

- La suplantación de mensajes DTP del host atacante hace que el switch entre en modo de enlace troncal. Desde aquí, el atacante puede enviar tráfico etiquetado con la VLAN de destino, y el switch luego entrega los paquetes al destino.
- Introduciendo un switch dudoso y habilitando enlaces troncales. El atacante puede acceder todas las VLANs del switch víctima desde el switch dudoso.
- Otro tipo de ataque de salto a VLAN es el ataque doble etiqueta o doble encapsulado. Este ataque toma ventaja de la forma en la que opera el hardware en la mayoría de los switches.

### Pasos para mitigar los ataques de salto de VLAN

Use los siguiente pasos para mitigar ataques de salto

1. Deshabilitar las negociaciones DTP (enlace automático) en los puertos que no son enlaces mediante el comando `switchport mode access` en la interfaz del switch.
2. Deshabilitar los puertos no utilizados y colocarlos en una VLAN no utilizada.
3. Habilitar manualmente el enlace troncal en un puerto de enlace troncal utilizando el comando `switchport mode trunk`.
4. Deshabilitar las negociaciones de DTP (enlace automático) en los puertos de enlace mediante el comando `switchport nonegotiate`.
5. Configurar la VLAN nativa en una VLAN que no sea la VLAN 1 mediante el comando `switchport trunk native vlan vlan_number`.


## Mitigación de ataques de DHCP

La inspección de DHCP filtra los mensajes de DHCP y limita el tráfico de DHCP en puertos no confiables.

- Los dispositivos bajo control administrativo (por ejemplo, switches, routers y servidores) son fuentes confiables. 
- Las interfaces confiables (por ejemplo, enlaces troncales, puertos del servidor) deben configurarse explícitamente como confiables.
- Los dispositivos fuera de la red y todos los puertos de acceso generalmente se tratan como fuentes no confiables.

Se crea una tabla DHCP que incluye la dirección MAC de origen de un dispositivo en un puerto no confiable y la dirección IP asignada por el servidor DHCP a ese dispositivo. 

- La dirección MAC y la dirección IP están unidas. 
- Por lo tanto, esta tabla se denomina tabla de enlace DHCP snooping.

### Pasos para implementar DHCP Snooping

Utilice las siguientes pasos para habilitar DHCP snooping:

1. Habilite DHCP snooping usando el comando `ip dhcp snooping` en modo global
2. En los puertos de confianza, use el comando `ip dhcp snooping trust`.
3. En las interfaces que no son de confianza, limite la cantidad de mensajes de descubrimiento de DHCP que se pueden recibir con el comando `ip dhcp snooping limit rate packets-per-second` .
4. Habilite la inspección DHCP por VLAN, o por un rango de VLAN, utilizando el comando `ip dhcp snooping vlan`.

interfaz  dhcp confiable

    S1(config)# ip dhcp snooping
    S1(config)# interface f0/1
    S1(config-if)# ip dhcp snooping trust
    S1(config-if)# exit

interfaces no confiables con limite de solicitudes dhcp por segundo

    S1(config)# interface range f0/5 - 24
    S1(config-if-range)# ip dhcp snooping limit rate 6
    S1(config-if-range)# exit

vlan que puede pasar dhcp

    S1(config)# ip dhcp snooping vlan 5,10,50-52

ayuda

    S1# show ip dhcp snooping


## Mitigación de ataques de ARP

La inspección dinámica(DAI) requiere de DHCP snooping y ayuda a prevenir ataques ARP así:

- No retransmitiendo respuestas ARP invalidas o gratuitas a otros puertos en la misma VLAN.
- Intercepta todas las solicitudes y respuestas ARP en puertos no confiables.
- Verificando cada paquete interceptado para una IP-to-MAC Binding válida.
- Descarte y registre ARP Replies no válidos para evitar el envenenamiento de ARP.
- Error-disabling deshabilita la interfaz si se excede el número DAI configurado de paquetes ARP.


### Pautas de implementación de DAI

Para mitigar las probabilidades de ARP spoofing y envenenamiento ARP, siga estas pautas de implementación DAI:

- Habilite la detección de DHCP.
- Habilite la detección de DHCP en las VLAN seleccionadas.
- Habilite el DAI en los VLANs seleccionados.
- Configure las interfaces de confianza para la detección de DHCP y la inspección de ARP ("no confiable" es la configuración predeterminada).

Generalmente, es aconsejable configurar todos los puertos de switch de acceso como no confiables y configurar todos los puertos de enlace ascendente que están conectados a otros switches como confiables.

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


## Mitigar ataques STP

Recuerde que los atacantes de red pueden manipular el Protocolo de árbol de expansión (STP) para realizar un ataque falsificando el puente raíz y cambiando la topología de una red. 

Para mitigar los ataques STP, use PortFast y la protección de la unidad de datos de protocolo de puente (BPDU):

PortFast

- PortFast lleva inmediatamente un puerto al estado de reenvío desde un estado de bloqueo, sin pasar por los estados de escucha y aprendizaje. 
- Aplica a todos los puertos de acceso de usuario final. 

Protección de BPDU

- El error de protección de BPDU deshabilita inmediatamente un puerto que recibe una BPDU. 
- Al igual que PortFast, la protección BPDU sólo debe configurarse en interfaces conectadas a dispositivos finales.


    S1(config)# interface fa0/1
    S1(config-if)# switchport mode access
    S1(config-if)# spanning-tree portfast
    S1(config-if)# spanning-tree bpduguard enable

    S1(config)# spanning-tree portfast bpduguard default

