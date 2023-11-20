# Conmutación Ethernet

## Tramas de Ethernet

Ethernet funciona en la capa de enlace de datos y en la capa física.

Los estándares 802 LAN/MAN, incluyendo Ethernet, utilizan dos subcapas separadas de la capa de enlace de datos para operar:

- Subcapa LLC: (IEEE 802.2) Coloca información en la trama para identificar qué protocolo de capa de red se utiliza para la trama.
- Subcapa MAC: (IEEE 802.3, 802.11 o 802.15) Responsable de la encapsulación de datos y control de acceso a medios, y proporciona direccionamiento de capa de enlace de datos. 

### Subcapa MAC

La subcapa MAC es responsable de la encapsulación de datos y el acceso a los medios.

La encapsulación de datos IEEE 802.3 incluye lo siguiente:
1. Trama de Ethernet - Esta es la estructura interna de la trama Ethernet. 
2. Direccionamiento Ethernet : la trama Ethernet incluye una dirección MAC de origen y destino para entregar la trama Ethernet de NIC Ethernet a NIC Ethernet en la misma LAN. 
3. Detección de errores Ethernet : la Trama Ethernet incluye un remolque de secuencia de comprobación de fotogramas (FCS) utilizado para la detección de errores. 


Acceso de medios

- Ethernet heredada que utiliza una topología de bus o concentradores, es un medio de dúplex medio compartido. Ethernet a través de un medio semidúplex utiliza un método de acceso basado en contencion, detección de accesos múltiples/detección de colisiones (CSMA/CD). 
- Las LAN Ethernet de hoy utilizan conmutadores que funcionan en dúplex completo. Las comunicaciones dúplex completo con conmutadores Ethernet no requieren control de acceso a través de CSMA/CD.

### Tamaños Permitidos

El tamaño mínimo de trama de Ethernet es de 64 bytes, y el máximo es de 1518 bytes. El campo preámbulo no se incluye al describir el tamaño de una trama.

Cualquier trama de menos de 64 bytes de longitud se considera un "fragmento de colisión" o “trama de ejecución" y se descarta automáticamente. Las tramas de más de 1500 bytes de datos se consideran “jumbos” o tramas bebés gigantes.

## Dirección MAC de Ethernet

Una dirección MAC de Ethernet es una dirección de 48 bits expresada con 12 dígitos hexadecimales o 6 bytes. Debido a que un byte equivale a 8 bits, también podemos decir que una dirección MAC tiene 6 bytes de longitud.

Una dirección MAC Ethernet consta de un código OUI de proveedor hexadecimal 6 seguido de un valor hexadecimal asignado por el proveedor 6.

Caracteisticas:

- tienen 48 bits en 12 dígitos hexadecimales
- Todas las direcciones MAC deben ser únicas para el dispositivo Ethernet o la interfaz Ethernet.
- consta de 6 digitos por fabricante seguido de 6 dígitos por proveedor


### Procesmiento de Tramas

Cuando un dispositivo reenvía un mensaje a una red Ethernet, el encabezado Ethernet incluye una dirección MAC de origen y una dirección MAC de destino.

Cuando una NIC recibe una trama de Ethernet, examina la dirección MAC de destino para ver si coincide con la dirección MAC física que está almacenada en la RAM. Si no hay coincidencia, el dispositivo descarta la trama. Si hay coincidencia, envía la trama a las capas OSI, donde ocurre el proceso de desencapsulamiento.

El proceso que utiliza un host de origen para determinar la dirección MAC de destino asociada con una dirección IPv4 se conoce como Protocolo de resolución de direcciones (ARP). 

El proceso que utiliza un host de origen para determinar la dirección MAC de destino asociada con una dirección IPv6 se conoce como Neighbor Discovery (ND).

### Dirección MAC de difusión (broadast)

Cada dispositivo de la LAN Ethernet recibe y procesa una trama de difusión Ethernet.

- Tiene una dirección MAC de destino de FF-FF-FF-FF-FF-FF en hexadecimal (48 unidades en binario).
- Está inundado todos los puertos del conmutador Ethernet excepto el puerto entrante. No es reenviado por un router.
- todos los hosts de esa red local (dominio de difusión) recibirán y procesarán el paquete.

### Dirección MAC de multidifusión (multicast)

Un grupo de dispositivos que pertenecen al mismo grupo de multidifusión recibe y procesa una trama de multidifusión Ethernet

Hay una dirección MAC de destino 01-00-5E cuando los datos encapsulados son un paquete de multidifusión IPv4 y una dirección MAC de destino de 33-33 cuando los datos encapsulados son un paquete de multidifusión IPv6.

Debido a que las direcciones de multidifusión representan un grupo de direcciones (a veces denominado “grupo de hosts”), solo se pueden utilizar como el destino de un paquete. El origen siempre tiene una dirección de unidifusión.

Al igual que con las direcciones de unidifusión y difusión, la dirección IP de multidifusión requiere una dirección MAC de multidifusión correspondiente.

##  Velocidades de Switch y métodos de reenvío

Los switches utilizan uno de los siguientes métodos de reenvío para el switching de datos entre puertos de la red:

- **Conmutación de almacenamiento y reenvío:** recibe toda la trama y garantiza que la trama es válida. Si la CRC es válida, el switch busca la dirección de destino, que determina la interfaz de salida. Luego, la trama se reenvía desde el puerto correcto.
- **Conmutación de corte:**  este método de reenvío de trama reenvía la trama antes de que se reciba por completo. Como mínimo, se debe leer la dirección de destino para que la trama se pueda enviar.

### Conmutación de corte

En este tipo de switching, el switch actúa sobre los datos apenas los recibe, incluso si la transmisión aún no se completó. El switch no lleva a cabo ninguna verificación de errores en la trama.

**Conmutación de avance rápido:** ofrece el nivel más bajo de latencia al reenviar inmediatamente un paquete después de leer la dirección de destino. Como el switching de reenvío rápido comienza a reenviar el paquete antes de recibirlo por completo, es posible que, a veces, los paquetes se distribuyan con errores. La NIC de destino descarta el paquete defectuoso al recibirlo. El switching de envío rápido es el método de corte típico.

**Conmutación sin fragmentos:** un compromiso entre la alta latencia y la alta integridad de la conmutación de almacenamiento y reenvío y la baja latencia y la integridad reducida de la conmutación de avance rápido, el conmutador almacena y realiza una verificación de error en los primeros 64 bytes de la trama antes de reenviar. Debido a que la mayoría de los errores y colisiones de red se producen durante los primeros 64 bytes, esto garantiza que no se haya producido una colisión antes de reenviar la trama. 

### Memoria intermedia de en los conmutadores

Un switch Ethernet puede usar una técnica de almacenamiento en búfer para almacenar tramas antes de reenviarlos o cuando el puerto de destino está ocupado debido a la congestión

Memoria basada en puerto

- Las tramas se almacenan en colas que se enlazan a puertos específicos de entrada y salida.
- Una trama se transmite al puerto de salida solo cuando todas las tramas por delante en la cola se han transmitido con éxito.
- Es posible que una sola trama demore la transmisión de todas las tramas almacenadas en la memoria debido al tráfico del puerto de destino.
- Esta demora se produce aunque las demás tramas se puedan transmitir a puertos de destino abiertos.

Memoria compartida

- Deposita todas las tramas en un búfer de memoria común compartido por todos los puertos del switch y la cantidad de memoria intermedia requerida por un puerto se asigna dinámicamente.
- Las tramas en el búfer están vinculadas dinámicamente al puerto de destino, lo que permite recibir un paquete en un puerto y luego transmitirlo en otro puerto, sin moverlo a una cola diferente.

### Configuración dúplex y velocidad

Dos de las configuraciones más básicas en un switch son el ancho de banda ("velocidad") y la configuración dúplex para cada puerto de switch individual. Es fundamental que la configuración de dúplex y ancho de banda coincida entre el puerto del conmutador y los dispositivos conectados.

Se utilizan dos tipos de parámetros dúplex para las comunicaciones en una red Ethernet:
- **Full-duplex:** ambos extremos de la conexión pueden enviar y recibir simultáneamente.
- **Semidúplex:** solo uno de los extremos de la conexión puede enviar datos por vez.

La autonegociación es una función optativa que se encuentra en la mayoría de los switches Ethernet y NIC, que permite que Permite que dos dispositivos negocien automáticamente las mejores capacidades de velocidad y dúplex.

También puede ocurrir cuando los usuarios reconfiguran un lado del enlace y olvidan reconfigurar el otro. Ambos lados de un enlace deben tener activada la autonegociación, o bien ambos deben tenerla desactivada. La práctica recomendada es configurar ambos puertos del switch Ethernet como dúplex completo.

### Auto-MDIX

Las conexiones entre dispositivos requerían el uso de un cable cruzado o directo. El tipo de cable requerido dependía del tipo de dispositivos de interconexión.

Actualmente, la mayor parte de los dispositivos admiten la característica interfaz cruzada automática dependiente del medio (auto-MDIX). Cuando está habilitado, el conmutador detecta automáticamente el tipo de cable conectado al puerto y configura las interfaces en consecuencia.

    Switch(config-if)# mdix auto
    Switch(config-if)# speed auto|10|100
    Switch(config-if)# duplex auto|full|half

