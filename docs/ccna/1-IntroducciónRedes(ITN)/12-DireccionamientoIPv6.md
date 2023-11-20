# Direccionamiento IPv6

Tanto IPv4 como IPv6 coexistirán en un futuro próximo y la transición llevará varios años.

El IETF creó diversos protocolos y herramientas para ayudar a los administradores de redes a migrar las redes a IPv6. Las técnicas de migración pueden dividirse en tres categorías:

- Dual stack: Los dispositivos ejecutan pilas de protocolos IPv4 e IPv6 de manera simultánea.
- Tunneling: Es un método para transportar un paquete IPv6 a través de una red IPv4. El paquete IPv6 se encapsula dentro de un paquete IPV4.
- Translation: Network Address Translation 64 (NAT64) permite que los dispositivos con IPv6 habilitado se comuniquen con dispositivos con IPv4 habilitado mediante una técnica de traducción similar a la NAT para IPv4. 

> Nota: La tunelización y la traducción son para la transición a IPv6 nativo y solo deben usarse cuando sea necesario. El objetivo debe ser las comunicaciones IPv6 nativas de origen a destino.

##  Representación de dirección IPv6

Las direcciones IPv6 tienen 128 bits de longitud y están escritas en hexadecimal.

Las direcciones IPv6 no distinguen entre mayúsculas y minúsculas, y pueden escribirse en minúsculas o en mayúsculas.

El formato preferido para escribir una dirección IPv6 es x: x: x: x: x: x: x: x, donde cada "x" consta de cuatro valores hexadecimales.

En IPv6, un “hexteto” es el término no oficial que se utiliza para referirse a un segmento de 16 bits o cuatro valores hexadecimales.

Ejemplos de direcciones IPv6 en el formato preferido:

    2001:0db8:0000:1111:0000:0000:0000:0200 
    2001:0db8:0000:00a3:abcd:0000:0000:1234 

### Filtrado de ipv6 reducciones

La primera regla para ayudar a reducir la notación de las direcciones IPv6 es omitir los 0s (ceros) iniciales

- `01ab` se puede representar como `1ab`
- `00b2` se puede representar como `b2`
- `0b00` se puede representar como `b00`
- `0000` se puede representar como `0`

Los dos puntos dobles (::) pueden reemplazar cualquier cadena única y contigua de uno o más segmentos de 16 bits (hextetos) que estén compuestas solo por ceros

> Nota: Los dos puntos dobles (::) se pueden utilizar solamente una vez dentro de una dirección; de lo contrario, habría más de una dirección resultante posible.

    2001:0db8:0000:1111:0000:0000:0000:0200
    2001:db8:0:1111::200


## Tipos de direcciones IPv6

Existen tres categorías amplias de direcciones IPv6:

- Unicast: Identifica de manera única una interfaz de un dispositivo habilitado para IPv6.
- Multicast: Se usan para enviar un único paquete IPv6 a varios destinos.
- Anycast: Esta es cualquier dirección unicast de IPv6 que puede asignarse a varios dispositivos. Los paquetes enviados a una dirección de anycast se enrutan al dispositivo más cercano que tenga esa dirección.

> Nota: A diferencia de IPv4, IPv6 no tiene una dirección broadcast. Sin embargo, existe una dirección IPv6 de multicast de todos los nodos que brinda básicamente el mismo resultado.


### Longitud de prefijo IPv6

La longitud de prefijo puede ir de 0 a 128. 
La longitud de prefijo IPv6 recomendada para LAN y la mayoría de los otros tipos de redes es / 64. 
64 bits para red y 64 para host.

> Nota: Se recomienda encarecidamente utilizar un ID de interfaz de 64 bits para la mayoría de las redes. Esto se debe a que la autoconfiguración de direcciones sin estado (SLAAC) utiliza 64 bits para el Id. de interfaz. También facilita la creación y administración de subredes. 


### Tipos de direcciones Unicast de IPv6

#### En Global Unicast Addresses (GUA) publicas

Las direcciones IPv6 unicast globales (GUA), son globalmente únicas y enrutables en Internet IPv6.

Actualmente, solo se están asignando GUAs con los primeros tres bits de `001` o `2000::/3`.

Las GUAs disponibles actualmente comienzan con un decimal 2 o un 3 (Esto es sólo 1/8 del espacio total de direcciones IPv6 disponible).

- los 3 primeros bits los asigna iana
- los 45 bits siguientes es el prefijo del ISP (telefonica, vodafone, ...)
- los 16 bits siguientes son para subneting
- y los 64 restantes de host


#### Link-Local Unicast Addresses (LLA)

Se requiere para cada dispositivo con IPv6 y se usa para comunicarse con otros dispositivos en el mismo enlace local. 

Los paquetes con una LLA de origen o destino no se pueden enrutar.

Son las IPv6 generadas automaticamente por el host en la interfaz de red

- Siempre comienzan por `FE80::/10`
- seguido de 54 bits a 0
- seguido de 64 bits de interface ID

---

#### Unique Local Unicast Addresses (privadas)

Equivalen a IPv4 direcciones privadas, requieren un identificador de organización aleatorio.
Estas IPv6 nunca saldran al exterior, se utilizaran en redes internas exclusivamente.

Se representan como `fc00:/7 - fsff::/7` 

- Las direcciones locales únicas se utilizan para el direccionamiento local dentro de un sitio o entre una cantidad limitada de sitios.
- Se pueden utilizar direcciones locales únicas para dispositivos que nunca necesitarán acceder a otra red.
- Las direcciones locales únicas no se enrutan o traducen globalmente a una dirección IPv6 global.

---

## Configuración estática GUA y LLA

La mayoría de los comandos de configuración y verificación IPv6 de Cisco IOS son similares a sus equivalentes de IPv4. En la mayoría de los casos, la única diferencia es el uso de ipv6 en lugar de ip dentro de los comandos.

    R1(config)# ipv6 unicast-routing # habilitar enrutamiento ipv6
    R1# show ipv6 interface brief
    R1# show ipv6 route

    R1(config)# interface gigabitethernet 0/0/0
    R1(config-if)# ipv6 address 2001::1/64  # añadir ipv6
    R1(config-if)# ipv6 address fe80::1 link-local  # configurar link local
    R1(config-if)# no shutdown 

    R1# show ipv6 neighbors # tabla mac ipv6
    R1# clear ipv6 neighbors


## Direccionamiento dinámico para GUA IPv6

Los dispositivos obtienen direcciones GUA dinámicamente a través de mensajes de Internet Control Message Protocol version 6 (ICMPv6).

Los mensajes de solicitud de router (RS) son enviados por dispositivos host para descubrir routers IPv6

Los routers envían mensajes de anuncio de router (RA) para informar a los hosts sobre cómo obtener un GUA IPv6 y proporcionar información útil de red, como:

- Prefijo de red y longitud del prefijo
- Dirección del gateway predeterminado
- Direcciones DNS y nombre de dominio

El RA puede proporcionar tres métodos para configurar un GUA IPv6:

- SLAAC
- SLAAC con servidor DHCPv6 stateless
- Stateful DHCPv6 (no SLAAC)


### SLAAC

SLAAC permite a un dispositivo configurar un GUA sin los servicios de DHCPv6. 

Los dispositivos obtienen la información necesaria para configurar un GUA a partir de los mensajes RA ICMPv6 del router local.

El RA del router le proporciona la puerta de enlace y el prefijo, el dispositivo utiliza el método EUI-64 o de generación aleatoria para crear un ID de interfaz.


### SLAAC y DHCP sin estado

El mensaje RA sugiere que los dispositivos utilicen lo siguiente:

- SLAAC para crear su propio IPv6 GUA
- La dirección link-local del router, la dirección IPv6 de origen del RA para la dirección de gateway predeterminado 
- Un servidor DHCPv6 stateless, que obtendrá otra información como la dirección del servidor DNS y el nombre de dominio

### DHCPv6 con estado

DHCPv6 Stateful es similar a DHCP para IPv4. Un dispositivo puede recibir automáticamente un GUA, la longitud de prefijo y las direcciones de los servidores DNS desde un servidor DHCPv6 Stateful.

El mensaje RA sugiere que los dispositivos utilicen lo siguiente:

- La dirección LLA del router, que es la dirección IPv6 de origen del RA, para la dirección de gateway predeterminado
- Un servidor DHCPv6 Stateful, para obtener una GUA, otra información como la dirección del servidor DNS y el nombre de dominio


### Proceso EUI-64

El IEEE definió el Identificador único extendido (EUI) o el proceso EUI-64 modificado que realiza lo siguiente:

- Un valor de 16 bits de fffe (en hexadecimal) se inserta en el centro de la dirección MAC Ethernet de 48 bits del cliente.
- El 7º bit de la dirección MAC del cliente se invierte del binario 0 al 1.

Por ejemplo:

    fc:99:47:75:ce:e0   # MAC 48 bits

    fc:99:47:       75:ce:e0
             ff:fe:
    fc = 1111 1100 Se invierte el 7º bit 1111 1110 = fe

    fe:99:47:ff:fe:75:ce:e0    # id de intefaz EUI-64


> Nota: Para garantizar la exclusividad de cualquier dirección unicast de IPv6, el cliente puede usar un proceso denominado "detección de direcciones duplicadas" (DAD) Es similar a una solicitud de ARP para su propia dirección. Si no se obtiene una respuesta, la dirección es única.


## Dirección Multicast de IPv6

Las direcciones multicast de IPv6 tienen el prefijo `FF00::/8`. Existen dos tipos de direcciones multicast de IPv6:

- Dirección de red multicast conocida
- Dirección multicast de nodo solicitado

### Multicast de IPv6 conocidas

Se asignan direcciones IPv6 multicast conocidas y se reservan para grupos de dispositivos predefinidos.

Hay dos grupos comunes de direcciones IPv6 multicast asignadas:

- Grupo de multicast `FF02::1` para todos los nodos - Este es un grupo multicast al que se unen todos los dispositivos con IPv6 habilitado. Los paquetes que se envían a este grupo son recibidos y procesados por todas las interfaces IPv6 en el enlace o en la red. 
- `ff02::2` Grupo de multicast de todos los routers - Este es un grupo multicast al que se unen todos los dispositivos con IPv6 habilitado. Un router comienza a formar parte de este grupo cuando se lo habilita como router IPv6 con el comando de configuración global ipv6 unicast-routing. 

### Direcciones multicast de IPv6 de nodo solicitado

Una dirección multicast de nodo solicitado es similar a una dirección multicast de todos los nodos.

Una dirección multicast de nodo solicitado se asigna a una dirección especial de multicast de Ethernet.

Esto permite que la NIC Ethernet filtre la trama al examinar la dirección MAC de destino sin enviarla al proceso de IPv6 para ver si el dispositivo es el objetivo previsto del paquete IPv6.

Este proceso es similar a un ARP en IPv4


## División de subredes de una red IPv6

IPv6 se diseñó teniendo en cuenta las subredes. 

Se utiliza un campo ID de subred independiente en IPv6 GUA para crear subredes. 

El campo ID de subred es el área entre el Prefijo de enrutamiento global y la ID de interfaz. justo despues de los primeros 48 bits del Global Routing Prefix se encuenmtran los 16 bits para subneting.

### Ejemplo

Dado el prefijo de enrutamiento global `2001:db8:acad::/48` con un ID de subred de 16 bits.

- Permite 65.536 /64 subredes
- El prefijo de enrutamiento global es igual para todas las subredes.
- Solo se incrementa el hexteto de la ID de subred en sistema hexadecimal para cada subred.

Para la red `2001:db8:acad::/48` las subredes serian

    2001:db8:acad:0001:/64
    2001:db8:acad:0002:/64
    2001:db8:acad:0003:/64
    ...
    2001:db8:acad:ffff:/64


