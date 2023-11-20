# Capa de enlace de datos

## Propósito de la capa de enlace de datos

La capa enlace de datos es responsable de las comunicaciones entre las tarjetas de interfaz de red del dispositivo final.

Permite que los protocolos de capa superior accedan a los medios de capa física y encapsula los paquetes de capa 3 (IPv4 e IPv6) en tramas de capa 2.

También realiza la detección de errores y rechaza las tramas corruptas.

### subcapa de enlace de datos

La capa de enlace de datos consta de dos subcapas. Control de enlaces lógicos (LLC) y Control de acceso a medios (MAC). 

- La subcapa LLC se comunica entre el software de red en las capas superiores y el hardware del dispositivo en las capas inferiores.
- La subcapa MAC es responsable de la encapsulación de datos y el control de acceso a los medios.

### Proporciona acceso a los medios

En cada salto a lo largo de la ruta, un router realiza cuatro funciones básicas de Capa 2:

- Acepta una trama del medio de red.
- Desencapsula la trama para exponer el paquete encapsulado.
- Vuelve a encapsular el paquete en una nueva trama.
- Reenvía la nueva trama en el medio del siguiente segmento de red.

## Topologías

La topología de una red es la disposición y relación de los dispositivos de red y las interconexiones entre ellos.

**Topología física :** muestra las conexiones físicas y cómo los dispositivos están interconectados. 

**Topología lógica :** identifica las conexiones virtuales entre dispositivos mediante interfaces de dispositivos y esquemas de direccionamiento IP. 

### Topologías WAN

Existen tres topologías WAN físicas comunes: 

- Punto a punto: la topología WAN más simple y común. Consiste en un enlace permanente entre dos puntos finales.
- Hub and spoke: similar a una topología en estrella donde un sitio central interconecta sitios de sucursal a través de enlaces punto a punto.
- Malla: proporciona alta disponibilidad pero requiere que cada sistema final esté conectado a cualquier otro sistema final.

### Tipologías LAN

Los dispositivos finales de las LAN suelen estar interconectados mediante una topología de estrella o estrella extendida. 
En esta tipoloía los dispositivos finales estan conectados a un switch en forma de estrella.

Las tecnologías Early Ethernet y Token Ring heredado proporcionan dos topologías adicionales:
- Bus: Todos los sistemas finales se encadenan entre sí y terminan de algún modo en cada extremo.
- Anillo: Cada sistema final está conectado a sus respectivos vecinos para formar un anillo. 

### Comunicación dúplex half y full

Comunicación semidúplex (half-duplex)

- Solo permite que un dispositivo envíe o reciba a la vez en un medio compartido.
- Se utiliza en WLAN y topologías de bus heredadas con hubs Ethernet.

Comunicación dúplex completo (full-duplex)

- Permite que ambos dispositivos transmitan y reciban simultáneamente en un medio compartido.
- Los switches Ethernet funcionan en modo full-duplex.

## Métodos de control de acceso

Acceso basado en la contención

Todos los nodos que operan en semidúplex, compitiendo por el uso del medio. Pueden citarse como ejemplo:

- Carrier sense multiple access with collision detection (CSMA/CD) como se usa en Ethernet de topología de bus heredada.
- Carrier sense multiple access with collision avoidance (CSMA/CA) como se usa en LAN inalámbricas.

Acceso controlado
- Acceso determinista donde cada nodo tiene su propio tiempo en el medio.
- Se utiliza en redes heredadas como Token Ring y ARCNET.

### CSMA/CD

- Utilizado por LAN Ethernet heredadas. 
- Funciona en modo semidúplex, donde solo un dispositivo envía o recibe a la vez.
- Utiliza un proceso de detección de colisión para controlar cuándo puede enviar un dispositivo y qué sucede si varios dispositivos envían al mismo tiempo.

Proceso de detección de colisiones CSMA/CD:

- Los dispositivos que transmiten simultáneamente provocarán una colisión de señal en el medio compartido.
- Los dispositivos detectan la colisión.
- Los dispositivos esperan un período aleatorio de tiempo y retransmiten datos

### CSMA/CA

- Utilizado por WLAN IEEE 802.11.
- Funciona en modo semidúplex donde solo un dispositivo envía o recibe a la vez.
- Utiliza un proceso de prevención de colisiones para determinar cuándo puede enviar un dispositivo y qué sucede si varios dispositivos envían al mismo tiempo.

Proceso de prevención de colisiones CSMA/CA:

- Al transmitir, los dispositivos también incluyen la duración de tiempo necesaria para la transmisión.
- Otros dispositivos del medio compartido reciben la información de duración del tiempo y saben cuánto tiempo el medio no estará disponible.


## Trama del enlace de datos 

Los datos son encapsulados por la capa de enlace de datos con un encabezado y un remolque para formar una trama.

Una trama de enlace de datos consta de tres partes:

- Encabezado
- Datos
- Tráiler

### Campos de trama

| campo | descripcion |
|:---|:---|
| trama de Inicio y Alto    | Identifica el inicio y el final de la trama |
| direccionamiento          | Indica los nodos de origen y destino. |
| Tipo                      | Identifica el protocolo de capa 3 encapsulado |
| Control                   | Identifica los servicios de control de flujo  |
| Datos                     | Contiene la carga útil de la trama |
| Detección de errores      | Se utiliza para determinar errores de transmisión |

### tramas LAN y WAN

La topología lógica y los medios físicos determinan el protocolo de enlace de datos utilizado:

- Ethernet
- 802.11 inalámbrico
- Point-to-Point (PPP)
- Control de enlace de datos de alto nivel (HDLC, High-Level Data Link Control)
- Frame-Relay

Cada protocolo realiza control de acceso a medios para topologías lógicas específicas.



