# Resolución de dirección

## ARP

Un dispositivo utiliza ARP para determinar la dirección MAC de destino de un dispositivo local cuando conoce su dirección IPv4.

ARP proporciona dos funciones básicas:

- Resolución de direcciones IPv4 a direcciones MAC
- Mantenimiento de una tabla ARP de asignaciones de direcciones IPv4 a MAC

### Funciones ARP

Para enviar una trama, un dispositivo buscará en su tabla ARP una dirección IPv4 de destino y una dirección MAC correspondiente.

- Si la dirección IPv4 de destino del paquete está en la misma red, el dispositivo buscará en la tabla ARP la dirección IPv4 de destino.
- Si la dirección IPv4 de destino está en una red diferente, el dispositivo buscará en la tabla ARP la dirección IPv4 de la puerta de enlace predeterminada.
- Si el dispositivo localiza la dirección IPv4, se utiliza la dirección MAC correspondiente como la dirección MAC de destino de la trama. 
- Si no se encuentra una entrada en la tabla ARP, el dispositivo envía una solicitud ARP.

### Problemas ARP

Las solicitudes ARP son recibidas y procesadas por cada dispositivo en la red local.

Las emisiones ARP excesivas pueden causar cierta reducción en el rendimiento.

Las respuestas de ARP pueden ser suplantadas por un actor de amenazas para realizar un ataque de envenenamiento ARP.

Los switches de nivel empresarial incluyen técnicas de mitigación para proteger contra ataques ARP.



## Deteccion de vecinos IPv6

El protocolo IPv6 Neighbor Discovery (ND) proporciona:

- Resolución de dirección
- Descubrimiento de Router
- Servicios de redirección
- Los mensajes de solicitud de vecino (NS) y anuncio de vecino (NA) ICMPv6 se utilizan para mensajes de dispositivo a dispositivo, como la resolución de direcciones.
- Los mensajes ICMTPV6 Router Solicitation (RS) y Router Advertisement (RA) se utilizan para la mensajería entre dispositivos y enrutadores para la detección de enrutadores.
- Los enrutadores utilizan los mensajes de redireccionamiento ICMPv6 para una mejor selección de siguiente salto.

| Paquete | significado |
|:---|:---|
| NS | similar a ARP busqueda de vecinos    |
| NA | respuesta a NS   |
| RS | solicitar al router el prefijo   |
| RA | router manda prefijo de red ipv6 cada 200s   |

### Resolución de direcciones

Los dispositivos IPv6 utilizan ND para resolver la dirección MAC de una dirección IPv6 conocida.

Los mensajes de solicitud de vecinos ICMPv6 se envían utilizando direcciones multidifusión Ethernet e IPv6 especiales. 

