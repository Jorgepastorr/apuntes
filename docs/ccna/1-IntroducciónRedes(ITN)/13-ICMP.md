# ICMP

## Mensajes ICMP

Internet Control Message Protocol (ICMP) proporciona información sobre problemas relacionados con el procesamiento de paquetes IP bajo ciertas condiciones.

El protocolo de mensajes para IPv4 es ICMPv4. ICMPv6 es el protocolo de mensajería para IPv6 e incluye funcionalidad adicional.

Los mensajes ICMP comunes a ICMPv4 e ICMPv6 incluyen:

- Accesibilidad al host
- Destino o servicio inaccesible
- Tiempo superado

### Destino o servicio inalcanzable

Se puede utilizar un mensaje de destino inalcanzable ICMP para notificar al origen que un destino o servicio no es accesible. 

Algunos códigos de destino inalcanzable para ICMPv4 son los siguientes:

- 0: red inalcanzable
- 1: host inalcanzable
- 2: protocolo inalcanzable
- 3: puerto inalcanzable

Algunos códigos de destino inalcanzables para ICMPv6 son los siguientes:

- 0: No hay ruta para el destino
- 1: La comunicación con el destino está prohibida administrativamente (por ejemplo, firewall)
- 2: Más allá del alcance de la dirección de origen
- 3: No se puede alcanzar la dirección
- 4: Puerto inalcanzable

### Mensajes ICMPv6

ICMPv6 tiene nuevas características y funcionalidad mejorada que no se encuentra en ICMPv4, incluyendo cuatro nuevos protocolos como parte del protocolo de detección de vecinos (ND o NDP).

Los mensajes entre un router IPv6 y un dispositivo IPv6, incluida la asignación dinámica de direcciones, son los siguientes:

- Mensaje de solicitud de router (RS)
- Mensaje de anuncio de router (RA)

Los mensajes entre dispositivos IPv6, incluida la detección de direcciones duplicadas y la resolución de direcciones, son los siguientes:

- Mensaje de solicitud de vecino (NS)
- Mensaje de anuncio de vecino (NA)

#### detección de direcciones duplicadas (DAD)

Un dispositivo asignado a una unidifusión IPv6 global o dirección unidifusión local de vínculo puede realizar la detección de direcciones duplicadas (DAD) para asegurarse de que la dirección IPv6 es única. 

Para verificar la unicidad de una dirección, el dispositivo enviará un mensaje NS con su propia dirección IPv6 como la dirección IPv6 objetivo.

Si otro dispositivo en la red tiene esta dirección, responderá con un mensaje de NA notificando al dispositivo emisor que la dirección está en uso. 


## Pruebas de ping y traceroute

### Ping

El comando ping es una utilidad de pruebas IPv4 e IPv6 que utiliza mensajes de solicitud de eco y respuesta de eco ICMP para probar la conectividad entre hosts y proporciona un resumen que incluye la tasa de éxito y el tiempo medio de ida y vuelta al destino.

### Traceroute

Traceroute (tracert) es una utilidad que se usa para probar la ruta entre dos hosts y proporcionar una lista de saltos que se alcanzaron con éxito a lo largo de esa ruta.

Traceroute proporciona tiempo de ida y vuelta para cada salto a lo largo del camino e indica si un salto no responde. Se utiliza un asterisco (*) para indicar un paquete perdido o sin respuesta.

#### Funcionamiento

El primer mensaje enviado desde traceroute tendrá un valor de campo TTL de 1. Esto hace que el TTL expire en el primer router. Este router responde con un mensaje ICMPv4 Tiempo excedido. 

A continuación, Traceroute incrementa progresivamente el campo TTL (2, 3, 4...) para cada secuencia de mensajes. Esto proporciona el rastro con la dirección de cada salto a medida que los paquetes caducan más adelante en la ruta. 

El campo TTL sigue aumentando hasta que se alcanza el destino, o se incrementa a un máximo predefinido.