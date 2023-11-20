# Conceptos de QoS

## Calidad de la transmisión de red

### Priorización del tráfico

Cuando el volumen de tráfico es mayor de lo que se puede transportar a través de la red, los dispositivos ponen en cola (retienen) los paquetes en la memoria hasta que los recursos estén disponibles para transmitirlos.

Los paquetes en cola causan retrasos, dado que los nuevos paquetes no se pueden transmitir hasta que no se hayan procesado los anteriores.

Si sigue aumentando la cantidad de paquetes que se pondrán en cola, la memoria del dispositivo se llenará y los paquetes se descartarán. 

Una técnica de QoS que puede ayudarlo con este problema es la clasificación de datos en varias colas, como se muestra en la figura.

### Ancho de banda, Congestión, Demora, y Jitter

El ancho de banda de la red es la medida de la cantidad de bits que se pueden transmitir en un segundo, es decir, bits por segundo (bps).

La congestión de la red produce demoras. Una interfaz experimenta congestión cuando tiene más tráfico del que puede gestionar. Los puntos de congestión de la red son candidatos ideales para los mecanismos de QoS.

Los puntos de congestión típicos son agregación, desajuste de velocidad y LAN a WAN.

La demora o la latencia se refiere al tiempo que demora un paquete en viajar de origen a destino.
  
- El retraso fijo es la cantidad de tiempo que tarda un proceso específico, como el tiempo que lleva colocar un bit en el medio de transmisión. 
- El retraso variable lleva una cantidad de tiempo no especificada y se ve afectado por factores como la cantidad de tráfico que se procesa.
- Jitter es la variación del retraso de los paquetes recibidos.

| Demora                               | Descripción                                                                                                                                               |
| :----------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Demora de código                     | La cantidad fija de tiempo que lleva comprimir datos en la fuente antes transmitiendo al primer dispositivo de interconexión, generalmente un conmutador. |
| Demora de paquetización              | El tiempo fijo que lleva encapsular un paquete con todo lo necesario información del encabezado                                                           |
| Demora de asignación de cola         | La cantidad variable de tiempo que una trama o paquete espera para transmitirse el enlace.                                                                |
| Demora de serialización              | La cantidad fija de tiempo que lleva transmitir una trama al cable.                                                                                       |
| Demora de propagación                | La cantidad variable de tiempo que tarda el fotograma en viajar entre origen y destino.                                                                   |
| Demora de eliminación de fluctuación | La cantidad fija de tiempo que lleva almacenar un flujo de paquetes en el búfer y luego enviarlos a intervalos espaciados uniformemente.                  |


### Pérdida de paquetes

Sin mecanismos de QoS, los paquetes sensibles al tiempo, como el video y la voz en tiempo real, se descartan con la misma frecuencia que los datos que no son sensibles al tiempo.

Cuando un router recibe una transmisión de audio digital del Protocolo en tiempo real (RTP) para Voz sobre IP (VoIP), compensa el Jitter que se encuentra al usar un búfer de retardo de reproducción. 

El búfer de retardo de reproducción almacena estos paquetes y luego los reproduce en un flujo constante.

Si el jitter es tan grande que hace que los paquetes se reciban fuera del rango del búfer de reproducción, los paquetes fuera del rango se descartan y se escuchan abandonos en el audio.

En el caso de pérdidas pequeñas de un paquete, el procesador de señales digitales (DSP) extrapola la información faltante del audio para que el usuario pueda escucharlo sin problemas. 

Cuando el jitter excede lo que el DSP puede hacer para compensar los paquetes faltantes, se escuchan problemas de audio.

##  Características del tráfico

### Voz

El tráfico de voz es predecible y fluido y muy sensible a retrasos y paquetes descartados. 

- Los paquetes de voz deben recibir una prioridad mayor a la de otros tipos de paquetes. 
- Los productos de Cisco utilizan el rango de puerto de 16384 a 32767 de RTP para priorizar el tráfico de voz. 

La voz puede tolerar una cierta cantidad de latencia, jitter y pérdida sin ningún efecto notable.

- La latencia no debe superar los 150 milisegundos (ms). 
- El jitter no debe superar los 30 ms y la pérdida de paquetes no debe superar el 1%. 
- El tráfico de voz requiere al menos 30 Kbps de ancho de banda. 

Características del tráfico de voz	

- Fluida
- Favorable
- Sensible a las caídas
- Sensible al retraso
- Prioridad UDP

Requerimientos de sentido único

- Latencia ≤ 150 ms
- Fluctuación ≤ 30 ms
- Pérdida ≤ 1% de ancho de banda (30 - 128 Kbps)

### Video

El tráfico de video tiende a ser impredecible, inconsistente y explosivo. En comparación con la transmisión de voz, el video es menos resistente a pérdidas y tiene un mayor volumen de datos por paquete. 

La cantidad y el tamaño de los paquetes de video varían cada 33 ms según el contenido del video.

Los puertos UDP, como el 554, se utilizan para el Protocolo de transmisión en tiempo real (RSTP) y se les debe dar prioridad sobre otro tráfico de red menos sensible al retraso.

La latencia no debe ser superior a 400 milisegundos (ms). El jitter no deben ser de más de 50 ms, y la pérdida de paquetes de video no debe ser superior al 1%. El tráfico de video requiere al menos 384 Kbps de ancho de banda.

Características del tráfico de video	

- Con ráfagas
- Voraz
- Sensible a las caídas
- Sensible al retraso
- Prioridad UDP

Requerimientos de sentido único

- Latencia ≤ 200-400 ms
- Jitter ≤ 30-50 ms
- Pérdida ≤ 0,1-1%
- Ancho de banda (384 Kbps -> 20 Mbps


### Datos

Las aplicaciones de datos que no toleran la pérdida de datos, como el correo electrónico y las páginas web, utilizan TCP para garantizar que si los paquetes se pierden en tránsito, se reenviarán. 

- El tráfico de datos puede ser fluido o puede tener estallidos. 
- El tráfico de control de red generalmente es elegante y predecible.

Algunas aplicaciones TCP pueden consumir una gran parte de la capacidad de la red. El FTP ocupará tanto ancho de banda como pueda obtener cuando usted descargue un archivo grande, como una película o un juego.

Características del tráfico de datos

- Fluido o con ráfagas
- Benigno/voraz
- Insensible a las caídas
- Insensible al retraso
- Retransmisiones de TCP

El tráfico de datos es relativamente insensible a las caídas y demoras en comparación con la voz y el video. La calidad de la experiencia o QoE es importante tener en cuenta con el tráfico de datos.

- ¿Los datos provienen de una aplicación interactiva?
- ¿Es la misión de datos crítica?

| Factor         | De uso crítico                                                                                                | No misión crítica                                                                                                                          |
| :------------- | :------------------------------------------------------------------------------------------------------------ | :----------------------------------------------------------------------------------------------------------------------------------------- |
| Interactivo    | Priorice la demora más baja de todo el tráfico de datos y luche por un 1 a 2 segundos de tiempo de respuesta. | Las aplicaciones podrían beneficiarse con una demora más baja.                                                                             |
| No interactivo | El retraso puede variar mucho, siempre que el ancho de banda mínimo necesario sea suministrado                | Obtiene cualquier ancho de banda restante después de todos los datos de voz, video y otros se satisfacen las necesidades de la aplicación. |


## Algoritmos de puesta en cola

### Resumen de colas

La política de la QoS implementada por el administrador de la red se activa cuando se produce una congestión en el enlace. La puesta en cola es una herramienta administrativa para la congestión que puede almacenar en búfer, priorizar, y, si corresponde, reordenar los paquetes antes de que estos se transmitan al destino.

Hay varios algoritmos de colas disponibles:

- Primero en entrar, primero en salir (FIFO)
- Mecanismo de cola equitativo ponderado (WFQ)
- Mecanismo de cola de espera equitativo y ponderado basado en clases (CBWFQ)
- Mecanismo de cola de baja latencia (LLQ)

### Primero en entrar, primero en salir

Primero en entrar, primero en salir (FIFO) almacenando buffers y reenviando paquetes en el orden de llegada.

FIFO no tiene concepto de prioridad ni clases de tráfico, por lo que no toma decisiones sobre la prioridad de los paquetes.

Hay una sola cola, y todos los paquetes se tratan por igual. 

Los paquetes se envían a una interfaz en el orden de llegada.

### Mecanismo de cola equitativo ponderado (WFQ)

Las colas justas ponderadas (WFQ) son un método de programación automatizado que proporciona una asignación justa de ancho de banda a todo el tráfico de red. 

WFQ aplica prioridad, o pesos, al tráfico identificado, lo clasifica en conversaciones o flujos y, a continuación, determina cuánto ancho de banda se permite cada flujo en relación con otros flujos.

WFQ clasifica el tráfico en diferentes flujos según las direcciones IP de origen y destino, las direcciones MAC, los números de puerto, el protocolo y el valor del Tipo de servicio (ToS).

WFQ no se utiliza con los túneles y el encriptado porque estas funciones modifican la información de contenido de paquete requerida por WFQ para la clasificación.

### Mecanismo de Cola de Espera Equitativo y Ponderado Basado en Clases (CBWFQ)

La ponderación equitativa ponderada basada en clases (CBWFQ) amplía la funcionalidad estándar WFQ para proporcionar soporte para las clases de tráfico definidas por el usuario. 

- Las clases de tráfico se definen en función de criterios de coincidencia que incluyen protocolos, listas de control de acceso (ACL) e interfaces de entrada. 
- Los paquetes que cumplen los criterios de coincidencia para una clase constituyen el tráfico para esa clase.
- Se reserva una cola FIFO para cada clase, y el tráfico que pertenece a una clase se dirige a la cola para esa clase.
- Se pueden asignar características a una clase, como ancho de banda, peso y límite máximo de paquetes. El ancho de banda asignado a una clase es el ancho de banda garantizado entregado durante la congestión.
- Los paquetes que pertenecen a una clase están sujetos a los límites de ancho de banda y de cola, que es el número máximo de paquetes que se permite acumular en la cola, que caracterizan a la clase.

Una vez que una cola haya alcanzado su límite de cola configurado, el agregado de más paquetes a la clase hace que surtan efecto el descarte de cola o el descarte de paquetes, según cómo esté configurada la política de clase. 

- La caída de cola descarta cualquier paquete que llegue al final de una cola que haya agotado completamente sus recursos de retención de paquetes. 
- Esta es la respuesta de espera predeterminada para la congestión. El descarte de extremo final trata a todo el tráfico de la misma manera y no diferencia entre clases de servicios.

### Mecanismo de cola de baja latencia (LLQ)

La función de cola de baja latencia (LLQ) trae cola de prioridad estricta (PQ) a CBWFQ. 

La estricta PQ permite que los paquetes sensibles al retraso, como la voz, se envíen antes que los paquetes en otras colas. 

LLQ permite que los paquetes sensibles al retraso, como la voz, se envíen primero (antes que los paquetes en otras colas), dando a los paquetes sensibles al retraso un tratamiento preferencial sobre otro tráfico.

Cisco recomienda que sólo el tráfico de voz se dirija a la cola de prioridad.

## Modelos de QoS

### Selección de un modelo adecuado de política de la QoS

Existen tres modelos para implementar QoS. QoS se implementa en una red utilizando IntServ o DiffServ. 

- IntServ ofrece la mayor garantía de QoS, requiere muchos recursos y, por lo tanto, no es fácilmente escalable. 
- DiffServ requiere menos recursos y es más escalable. 
- IntServ y DiffServ a veces se implementan conjuntamente en implementaciones de QoS de red.

Modelo de mejor esfuerzo	

- Esto no es realmente una implementación ya que QoS no está configurado explícitamente.
- Use esto cuando no se requiera QoS.

Servicios integrados (IntServ)	

- IntServ proporciona paquetes QoS a IP muy altos con entrega garantizada.
- Definir un proceso de señalización para las aplicaciones señaladas a la red que requirió QoS especial por un período y que debe reservarse el ancho de banda.
- IntServ puede limitar severamente la escalabilidad de una red.

Servicios diferenciados (DiffServ)	

- DiffServ proporciona alta escalabilidad y flexibilidad en la implementación de QoS.
- Los dispositivos de red reconocen las clases de tráfico y proporcionan diferentes niveles de QoS a diferentes clases de tráfico.

### Mejor Esfuerzo

El diseño básico de Internet es la entrega de paquetes de mejor esfuerzo y no ofrece garantías.

El modelo de mejor esfuerzo trata todos los paquetes de red de la misma manera, por lo que un mensaje de voz de emergencia se trata de la misma manera que se trata una fotografía digital adjunta a un correo electrónico.

Beneficios e inconvenientes del modelo de mejor esfuerzo:

| Beneficios                                                                                                                         | Desventajas                                                                                |
| :--------------------------------------------------------------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------- |
| Este modelo es el más escalable.                                                                                                   | No hay garantías de entrega.                                                               |
| La escalabilidad solo está limitada por el ancho de banda disponible, en cuyo caso todos los el tráfico se ve igualmente afectado. | Los paquetes llegarán siempre que puedan y en el orden que sea posible, si llegar a todos. |
| No se requieren mecanismos de QoS especiales.                                                                                      | Ningún paquete tiene trato preferencial.                                                   |
| Es el modelo más fácil y rápido de implementar.                                                                                    | Los datos críticos se tratan del mismo modo que el correo electrónico informal.            |

### Servicios integrados

IntServ ofrece la QoS end-to-end que requieren las aplicaciones en tiempo real. 

Administra explícitamente los recursos de red para proporcionar QoS a flujos o flujos individuales, a veces denominados microflujos. 

Utilizan la reserva de recursos y mecanismos de control de admisión como módulos de construcción para establecer y mantener la QoS.

Utiliza un enfoque orientado a la conexión. Cada comunicación individual debe especificar explícitamente su descriptor de tráfico y los recursos solicitados a la red. 

El router perimetral realiza el control de admisión para garantizar que los recursos disponibles son suficientes en la red. 

En el modelo de IntServ, la aplicación solicita a un tipo específico de servicio a la red antes de enviar datos. 

La aplicación informa a la red su perfil de tráfico y solicita a un tipo particular de servicio que puede abarcar requisitos de ancho de banda y retraso. 

IntServ utiliza el Protocolo de reserva de recursos (RSVP) para señalar las necesidades de la QoS del tráfico de una aplicación junto con los dispositivos en la ruta de extremo a extremo a través de la red. 

Si los dispositivos de red a lo largo de la ruta pueden reservar el ancho de banda necesario, la aplicación de origen puede comenzar a transmitir. Si reserva solicitada falla a lo largo de la ruta, la aplicación de origen no envía ningún dato.

Beneficios:

- Control explícito de admisión de recursos de extremo a extremo
- Control de admisión de políticas por solicitud
- Señalización de números de puerto dinámicos

Desventajas:

- Uso intensivo de recursos debido al requisito de arquitectura con estado para señalización continua.
- Enfoque basado en el flujo no escalable a implementaciones grandes como el Internet.

### Servicios diferenciados

El modelo de QoS de servicios diferenciados (DiffServ) específica un mecanismo simple y escalable para clasificar y gestionar el tráfico de red.

No es una estrategia de QoS de extremo a extremo porque no puede hacer cumplir las garantías de extremo a extremo.

Los hosts reenvían el tráfico a un router que clasifica los flujos en agregados (clases) y proporciona la política de QoS adecuada para las clases. 

Refuerza y aplica mecanismos de QoS salto por salto, aplicando de manera uniforme el significado global a cada clase de tráfico para proporcionar flexibilidad y escalabilidad.

DiffServ divide el tráfico de red en clases según los requisitos de la empresa. Se puede asignar a un nivel diferente de servicio a cada una de las clases. 

A medida que los paquetes atraviesan una red, cada uno de los dispositivos de red identifica la clase de paquete y brinda servicios al paquete según esa clase. 

Con DiffServ, es posible elegir muchos niveles de servicio. 

Beneficios:

- Gran escalabilidad
- Proporciona distintos niveles de calidad

Desventajas

- Sin garantía absoluta de la calidad del servicio
- Requiere un conjunto de mecanismos complejos para trabajar en conjunto en la red


## Técnicas de implementación de QoS

### Prevención de la pérdida de paquetes

La pérdida de paquetes es generalmente el resultado de la congestión en una interfaz. La mayoría de las aplicaciones que utilizan el TCP experimentan una disminución de velocidad debido a que el TCP se ajusta automáticamente a la congestión en la red. Los segmentos caídos del TCP hacen que las sesiones del TCP reduzcan su tamaño de ventana. Algunas aplicaciones no utilizan TCP y no pueden manejar las caídas (flujos frágiles).

Los enfoques siguientes pueden prevenir los descartes en las aplicaciones sensibles:

- Aumenta la capacidad de enlace para facilitar o evitar la congestión.
- Garantiza el suficiente ancho de banda y aumenta el espacio en búfer para acomodar las ráfagas de tráfico de flujos frágiles. WFQ, CBWFQ y LLQ pueden garantizar ancho de banda y proporcionar reenvío priorizado a aplicaciones sensibles a caídas.
- Los paquetes de baja prioridad de descartan antes de que se presente la congestión. Cisco IOS QoS proporciona mecanismos de colas, como la detección temprana aleatoria ponderada (WRED), que comienzan a descartar paquetes de menor prioridad antes de que ocurra la congestión.

### Herramientas de QoS

Herramientas de clasificación y marcación	

- Las sesiones, o flujos, se analizan para determinar qué clase de tráfico a los que pertenecen.
- Cuando se determina la clase de tráfico, se marcan los paquetes.

Herramientas para evitar la congestión	

- Las clases de tráfico son porciones asignadas de recursos de red, como definido por la directiva QoS.
- La política de QoS también identifica cómo parte del tráfico puede ser selectivamente caído, retrasado o remarcado para evitar la congestión.
- La herramienta principal de prevención de congestión es WRED y se utiliza para regular el tráfico de datos TCP de manera eficiente con el ancho de banda antes se producen caídas de cola causadas por desbordamientos de cola.

Herramientas de administración de congestión	

- Cuando el tráfico excede los recursos de red disponibles, el tráfico se pone en cola esperar la disponibilidad de recursos.
- Las herramientas comunes de administración de congestión basadas en Cisco IOS incluyen CBWFQ y AlgoritmosLLQ.


### Clasificación y Marcación

Antes de que a un paquete se le pueda aplicar una política de la QoS, el mismo tiene que ser clasificado.

La clasificación determina la clase de tráfico al cual los paquetes o tramas pertenecen. Solo pueden aplicarse las políticas al tráfico después del marcado.

Cómo se clasifica un paquete depende de la implementación de la QoS. 

- Los métodos de clasificación de flujos de tráfico en la capa 2 y 3 incluyen el uso de interfaces, ACL y mapas de clase. 
- El tráfico también se puede clasificar en las capas 4 a 7 mediante el uso del Reconocimiento de Aplicaciones Basado en la Red (NBAR).

La forma en la que se marca el tráfico generalmente depende de la tecnología. La decisión de marcar el tráfico de las capas 2 o 3 (o ambos) no es despreciable y debe tomarse tras considerar los siguientes puntos:

- Se puede marcar la Capa 2 de las tramas para el tráfico no IP.
- El marcado en la capa 2 de las tramas es la única opción de la QoS disponible para los switches que no tienen "reconocimiento de IP".
- El marcado de Capa 3 llevará la información de la QoS de extremo a extremo.

| Herramientas de la QoS    | Capa | Campo de marcación                                | Ancho en bits |
| :------------------------ | :--- | :------------------------------------------------ | :------------ |
| Ethernet (802.1Q, 802.1p) | 2    | Clase de servicio (CoS)                           | 3             |
| 802.11 (Wi-Fi)            | 2    | Identificador de tráfico (TID) de Wi-Fi           | 3             |
| MPLS                      | 2    | Experimental (EXP)                                | 3             |
| IPv4 e IPv6               | 3    | Precedencia de IP (IPP)                           | 3             |
| IPv4 e IPv6               | 3    | Punto de código de servicios diferenciados (DSCP) | 6             |


### Marcación en la capa 2

802.1Q es el estándar IEEE que admite etiquetado VLAN en la capa 2 de las redes Ethernet. Cuando se implementa 802.1Q, se insertan dos campos en la trama Ethernet que sigue al campo de la dirección MAC de origen.

El estándar 802.1Q también incluye el esquema de priorización de la QoS conocido como IEEE 802.1p. El estándar 802.1p usa los tres primeros bits del campo de información de control de etiqueta (TCI). Conocido como campo de prioridad (PRI), este campo de 3 bits identifica las marcas de clase de servicio (CoS).

Tres bits significa que una trama Ethernet de capa 2 se puede marcar con uno de los ocho niveles de prioridad (valores 0-7).

| Valor de CoS | Valor binario de CoS | Descripción                      |
| :----------- | :------------------- | :------------------------------- |
| 0            | 000                  | Datos de mejor esfuerzo          |
| 1            | 001                  | Datos de prioridad media         |
| 2            | 010                  | Datos de alta prioridad          |
| 3            | 011                  | Señalización de llamadas         |
| 4            | 100                  | Videoconferencia                 |
| 5            | 101                  | Portador de voz (tráfico de voz) |
| 6            | 110                  | Reservado                        |
| 7            | 111                  | Reservado                        |


### Marcación en la capa 3

IPv4 e IPv6 especifican un campo de 8 bits en sus encabezados de paquetes para marcar los paquetes. 

Tanto IPv4 como IPv6 admiten un campo de 8 bits para marcar: el campo Tipo de servicio (ToS) para IPv4 y el campo Clase de tráfico para IPv6.

### Tipo de servicio y campo de clase de tráfico

El tipo de servicio (IPv4) y la clase de tráfico (IPv6) llevan el marcado de paquetes según lo asignado por las herramientas de clasificación de QoS.

RFC 791 especificó el campo de precedencia de IP de 3 bits (IPP) que se utilizará para las marcas de QoS.

RFC 2474 reemplaza a RFC 791 y redefine el campo ToS renombrando y extendiendo el campo IPP a 6 bits.

Conocido como campo de punto de código de servicios diferenciados (DSCP), estos seis bits ofrecen un máximo de 64 clases de servicio posibles.

Los dos bits restantes de notificación de congestión extendida (ECN) de IP pueden usarse en los routers con reconocimiento de ECN para marcar paquetes en vez de descartarlos. 

### Valores DSCP

Los 64 valores de DSCP se organizan en tres categorías:

**Mejor esfuerzo (BE)** - Este es el valor predeterminado para todos los paquetes IP. El valor de DSCP es 0. El comportamiento por salto es enrutamiento normal. Cuando un router experimenta congestión, estos paquetes se descartan. No se implementa plan de la QoS.

**Reenvío Acelerado (EF)** - RFC 3246 define EF como el valor decimal DSCP 46 (binario101110). Los primeros 3 bits (101) se asocian directamente al valor 5 de CoS de capa 2 que se utiliza para el tráfico de voz. En la capa 3, Cisco recomienda que EF solo se use para marcar paquetes de voz.

**Reenvío asegurado (AF)** - Reenvío asegurado (AF): RFC 2597 define el AF para usar los 5 bits DSCP más significativos para indicar las colas y la preferencia de descarte. 


### Bits selectores de clase

Bits de selector de clase (CS):

- Los primeros 3 bits más significativos del campo DSCP e indican la clase.
- Asigne directamente a los 3 bits del campo CoS y el campo IPP para mantener la compatibilidad con 802.1p y RFC 791.

### Límites de confianza

El tráfico se debe clasificar y marcar lo más cerca su origen como sea técnicamente y administrativamente posible. Esto define el límite de confianza.

1. Los terminales confiables tienen las capacidades y la inteligencia para marcar el tráfico de aplicaciones con las CoS de capa 2 apropiadas y/o los valores de DSCP de la Capa 3. 
1. Los terminales seguros pueden hacer que el tráfico se marque en el switch de la capa 2.
1. El tráfico también puede marcarse en los switches/routers de la capa 3.

### Prevención de la congestión

Las herramientas para evitar la congestión monitorean las cargas de tráfico de la red en un esfuerzo por anticipar y evitar la congestión en la red común y los cuellos de botella entre redes antes de que la congestión se convierta en un problema.

- Las cargas de tráfico de la red, en un esfuerzo por anticipar y evitar la congestión en los cuellos de botella de la red común y de internetwork antes de que la congestión se convierta en un problema.
- Ellas monitorean la profundidad promedio de la cola. Cuando la cola está por debajo del umbral mínimo, no hay descartes. A medida que la cola alcanza el umbral máximo, se descarta un pequeño porcentaje de paquetes. Cuando se supera el umbral máximo, se descartan todos los paquetes.

Algunas técnicas para evitar la congestión brindan un tratamiento preferencial para el cual los paquetes se descartan.

- La detección temprana aleatoria ponderada (WRED) permite evitar la congestión en las interfaces de red al proporcionar una gestión de la memoria intermedia y permitir que el tráfico TCP disminuya o se acelere antes de que se agoten las memorias intermedias.
- WRED ayuda a evitar caídas de cola y maximiza el uso de la red y el rendimiento de las aplicaciones 
basadas en TCP. 

### Modelado y políticas

Las políticas de modelado y de vigilancia del son dos mecanismos proporcionados por el software Cisco IOS QoS para evitar la congestión.

El modelado del tráfico conserva los paquetes en exceso en una cola y luego programa el exceso para la transmisión posterior en incrementos de tiempo. El modelado del tráfico da como resultado una tasa de salida de paquetes suavizada.

El modelado es un concepto saliente; los paquetes que salen de una interfaz se almacenan en cola y pueden modelarse. Por el contrario, la vigilancia se aplica al tráfico entrante de la interfaz. 

Se puede aplicar la vigilancia al tráfico entrante en una interfaz. Los proveedores de servicios suelen implementar la vigilancia para aplicar una tasa de información de clientes (CIR) por contrato. Sin embargo, el proveedor de servicios también puede permitir el estallido por CIR si la red del proveedor de servicios no tiene congestión en la actualidad.

### Pautas de política de QoS

Las directivas QoS deben tener en cuenta la ruta completa desde el origen hasta el destino.

Algunas pautas que ayudan a garantizar la mejor experiencia para los usuarios finales incluyen las siguientes:

- Habilite la puesta en cola en todos los dispositivos de la ruta entre el origen y el destino.
- Clasifique y marque el tráfico lo más cerca posible de la fuente.
- Modele (Shape) y controle (police) el flujo del tráfico tan cerca del origen como sea posible