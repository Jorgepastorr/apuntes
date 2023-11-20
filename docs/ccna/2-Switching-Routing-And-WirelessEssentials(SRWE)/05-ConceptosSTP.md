# Conceptos STP

Tener rutas físicas alternativas para que los datos atraviesen la red permite que los usuarios accedan a los recursos de red, a pesar de las interrupciones de la ruta. Sin embargo, las rutas redundantes en una red Ethernet conmutada pueden causar bucles físicos y lógicos en la capa 2.

Las LAN Ethernet requieren una topología sin bucles con una única ruta entre dos dispositivos. Un bucle en una LAN Ethernet puede provocar una propagación continua de tramas Ethernet hasta que un enlace se interrumpe y interrumpa el bucle.

### Problemas con vínculos de switch redundantes

La redundancia de ruta proporciona múltiples servicios de red al eliminar la posibilidad de un solo punto de falla. Cuando existen múltiples rutas entre dos dispositivos en una red Ethernet, y no hay implementación de árbol de expansión en los switch, se produce un bucle de capa 2. Un bucle de capa 2 puede provocar inestabilidad en la tabla de direcciones MAC, saturación de enlaces y alta utilización de CPU en switch y dispositivos finales, lo que hace que la red se vuelva inutilizable.

Un router disminuirá el TTL (Tiempo de vida) en cada paquete IPv4 y el campo Límite de saltos en cada paquete IPv6. Cuando estos campos se reducen a 0, un router dejará caer el paquete. 

Los switch Ethernet y Ethernet no tienen un mecanismo comparable para limitar el número de veces que un switch retransmite una trama de Capa 2. STP fue desarrollado específicamente como un mecanismo de prevención de bucles para Ethernet de Capa 2.

### El algoritmo de árbol de expansión (Spanning Tree)

STP se basa en un algoritmo inventado por Radia Perlman mientras trabajaba para Digital Equipment Corporation, y publicado en el artículo de 1985 "Un algoritmo para la computación distribuida de un árbol de expansión en una LAN extendida". Su algoritmo de árbol de expansión (STA) crea una topología sin bucles al seleccionar un único puente raíz donde todos los demás switch determinan una única ruta de menor costo.

STP evita que ocurran bucles mediante la configuración de una ruta sin bucles a través de la red, con puertos “en estado de bloqueo” ubicados estratégicamente. Los switch que ejecutan STP pueden compensar las fallas mediante el desbloqueo dinámico de los puertos bloqueados anteriormente y el permiso para que el tráfico se transmita por las rutas alternativas.

#### ¿Cómo crea STA una topología sin bucles?

1. Selección de un puente raíz: Este puente (switch) es el punto de referencia para que toda la red cree un árbol de expansión alrededor.
2. Bloquear rutas redundantes: STP garantiza que solo haya una ruta lógica entre todos los destinos de la red al bloquear intencionalmente las rutas redundantes que podrían causar un bucle. Cuando se bloquea un puerto, se impide que los datos del usuario entren o salgan de ese puerto.
3. Crear una topología sin bucle: un puerto bloqueado tiene el efecto de convertir ese vínculo en un vínculo no reenvío entre los dos switch. Esto crea una topología en la que cada switch tiene una única ruta al puente raíz, similar a las ramas de un árbol que se conectan a la raíz del árbol.
4. Vuelva a calcular en caso de falla de enlace: las rutas físicas todavía existen para proporcionar redundancia, pero estas rutas están deshabilitadas para evitar que ocurran los bucles. Si alguna vez la ruta es necesaria para compensar la falla de un cable de red o de un switch, STP vuelve a calcular las rutas y desbloquea los puertos necesarios para permitir que la ruta redundante se active. Los recálculos STP también pueden ocurrir cada vez que se agrega un nuevo switch o un nuevo vínculo entre switches a la red.
   
##  Operaciones STP

### Pasos para una topología sin bucles

Usando STA, STP crea una topología sin bucles en un proceso de cuatro pasos:

1. Elige el puente raíz.
2. Seleccione los puertos raíz.
3. Elegir puertos designados.
4. Seleccione puertos alternativos (bloqueados).

Durante las funciones STA y STP, los switch utilizan unidades de datos de protocolo de puente (BPDU) para compartir información sobre sí mismos y sus conexiones. Las BPDU se utilizan para elegir el puente raíz, los puertos raíz, los puertos designados y los puertos alternativos. 

Cada BPDU contiene una ID de puente (BID) que identifica qué switch envió la BPDU. El BID participa en la toma de muchas de las decisiones STA, incluidos los roles de puente raíz y puerto. 

El BID contiene un valor de prioridad, la dirección MAC del switch y un ID de sistema extendido. El valor de BID más bajo lo determina la combinación de estos tres campos.

**Prioridad de puente:** el valor de prioridad predeterminado para todos los switch Cisco es el valor decimal 32768 El rango va de 0 a 61440 y aumenta de a 4096. Es preferible una prioridad de puente más baja. La prioridad de puente 0 prevalece sobre el resto de las prioridades de puente.

**ID del sistema extendido:** el valor de ID del sistema extendido es un valor decimal agregado al valor de prioridad del puente en el BID para identificar la VLAN para esta BPDU.

**Dirección MAC:** cuando dos switch se configuran con la misma prioridad y tienen la misma ID de sistema extendida, el switch que tiene la dirección MAC con el valor más bajo, expresado en hexadecimal, tendrá el BID más bajo.


### Determinar el costo de la ruta raíz

Cuando se ha elegido el puente raíz para una instancia de árbol de expansión dado, el STA comienza a determinar las mejores rutas al puente raíz desde todos los destinos en el dominio de difusión. La información de la ruta, conocida como el costo interno de la ruta raíz, está determinada por la suma de todos los costos de los puertos individuales a lo largo de la ruta desde el switch hasta el puente raíz.

Los costos de los puertos predeterminados se definen por la velocidad a la que funcionan los mismos. La tabla muestra los costos de puerto predeterminados sugeridos por IEEE. Los switch Cisco utilizan de forma predeterminada los valores definidos por el estándar IEEE 802.1D, también conocido como costo de ruta corta, tanto para STP como para RSTP. 

| Velocidad de enlace | STP Cost: IEEE 802.1D-1998 | Costo de RSTP: IEEE 802.1w-2004 |
| :------------------ | :------------------------- | :------------------------------ |
| 10Gbps              | 2                          | 2000                            |
| 1Gbps               | 4                          | 20000                           |
| 100Mbps             | 19                         | 200000                          |
| 10 Mbps             | 100                        | 2000000                         |


### Elegir un puerto raíz a partir de múltiples rutas de igual costo

Cuando un switch tiene varias rutas de igual costo al puente raíz, el switch determinará un puerto utilizando los siguientes criterios:

- Oferta de remitente más baja
- Prioridad de puerto del remitente más baja
- ID de puerto del remitente más bajo

### Temporizadores STP y Estados de puerto

La convergencia STP requiere tres temporizadores, como sigue:

- Hello Timer: el tiempo de saludo es el intervalo entre BPDU. El valor predeterminado es 2 segundos, pero se puede modificar entre 1 y 10 segundos.
- Temporizador de demora directa: la demora directa es el tiempo que se pasa en el estado de escucha y aprendizaje. El valor predeterminado es 15 segundos, pero se puede modificar a entre 4 y 30 segundos. 
- Temporizador de edad máxima: la antigüedad máxima es la duración máxima de tiempo que un switch espera antes de intentar cambiar la topología STP. El valor predeterminado es 20 segundos, pero se puede modificar entre 6 y 40 segundos.

> Nota: Los tiempos predeterminados se pueden cambiar en el puente raíz, que dicta el valor de estos temporizadores para el dominio STP. 

### Detalles operativos de cada estado de puerto

STP facilita la ruta lógica sin bucles en todo el dominio de difusión. El árbol de expansión se determina a través de la información obtenida en el intercambio de tramas de BPDU entre los switch interconectados. Si un puerto de switch pasa directamente del estado de bloqueo al de reenvío sin información acerca de la topología completa durante la transición, el puerto puede crear un bucle de datos temporal. Por esta razón, STP tiene cinco estados de puertos, cuatro de los cuales son estados de puertos operativos.


La tabla se resumen los detalles operativos de cada estado de puerto.

| Estado del puerto | BPDU                         | Tabla de direcciones MAC  | Reenvío de framesde datos |
| :---------------- | :--------------------------- | :------------------------ | :------------------------ |
| Bloqueo           | Recibir solo                 | No hay actualización      | No                        |
| Escucha           | Recibir y enviar             | No hay actualización      | No                        |
| Aprendizaje       | Recibir y enviar             | Actualización de la tabla | No                        |
| Reenvío           | Recibir y enviar             | Actualización de la tabla | Sí                        |
| Deshabilitado     | No se ha enviado ni recibido | No hay actualización      | No                        |


### Árbol de expansión por VLAN


STP se puede configurar para operar en un entorno con varias VLAN. En el árbol de expansión por VLAN (PVST) versión para STP,  hay un puente raíz ha elegir por cada instancia de árbol de expansión. 

Esto hace posible tener diferentes puentes raíz para diferentes conjuntos de VLAN. STP opera una instancia independiente de STP para cada VLAN individual. Si todos los puertos de todos los switch pertenecen a la VLAN 1, solo se da una instancia de árbol de expansión.


## Evolución del STP

### Diferentes versiones de STP

Muchos profesionales usan genéricamente árbol de expansión (spanning tree) y STP para referirse a las diversas implementaciones de árbol de expansión, como Rapid Spanning Tree Protocol (RSTP) y Multiple Spanning Tree Protocol (MSTP). Para comunicar los conceptos del árbol de expansión correctamente, es importante hacer referencia a la implementación o al estándar del árbol de expansión en contexto.

El documento más reciente del IEEE acerca del árbol de expansión (IEEE-802-1D-2004) establece que “STP se reemplazó con el protocolo de árbol de expansión rápido (RSTP)”. El IEEE utiliza “STP” para referirse a la implementación original del árbol de expansión y “RSTP” para describir la versión del árbol de expansión especificada en IEEE-802.1D-2004. 

Debido a que los dos protocolos comparten gran parte de la misma terminología y métodos para la ruta sin bucles, el enfoque principal estará en el estándar actual y las implementaciones propietarias de Cisco de STP y RSTP.

Los switch de Cisco con IOS 15.0 o posterior ejecutan PVST+ de manera predeterminada. Esta versión incluye muchas de las especificaciones IEEE 802.1D-2004, como puertos alternativos en lugar de los puertos no designados anteriores. Los switch deben configurarse explícitamente para el modo de árbol de expansión rápida para ejecutar el protocolo de árbol de expansión rápida.


**STP**	Esta es la versión original de IEEE 802.1D (802.1D-1998 y versiones anteriores) que proporciona una topología sin bucles en una red con enlaces redundantes. También llamado Common Spanning Tree (CST), asume una instancia de árbol de expansión para toda la red puenteada, independientemente de la cantidad de VLAN.

**PVST+**	El árbol de expansión por VLAN (PVST +) es una mejora de Cisco de STP que provides a separate 802.1D spanning tree instance for each VLAN Configure la red PVST+ soporta PortFast, UplinkFast, BackboneFast, BPDU guard, BPDU filter, root guard, y loop guard.

**802.1D-2004**	Esta es una versión actualizada del estándar STP, que incorpora IEEE 802.1w.

**RSTP**	Protocolo de Árbol de Expansión Rápido (RSTP), o IEEE&nbsp;802.1w, es una evolución de STP que proporciona una convergencia más veloz de STP. Proporciona una convergencia más rápida de STP.

**PVST+** rápido	Esta es una mejora de Cisco de RSTP que utiliza PVST + y proporciona un instancia separada de 802.1w por VLAN. Cada instancia independiente admite PortFast, BPDU guard, BPDU filter, root guard, y loop guard.

**MSTP**	El Protocolo de árbol de expansión múltiple (MSTP) es un estándar IEEE inspirado en el STP de instancia múltiple (MISTP) anterior propietario de Cisco de Cisco. MSTP asigna varias VLAN en la misma instancia de árbol de expansión. VRF.

**Instancia**	Múltiple Spanning Tree (MST) es la implementación de MSTP de Cisco, que proporciona hasta 16 instancias de RSTP y combina muchas VLAN con el misma topología física y lógica en una instancia RSTP común. Cada instancia aparte admite PortFast, protección de BPDU, filtro de BPDU, protección de raíz y protección de bucle. loop guard.


### Conceptos de RSTP

RSTP (IEEE 802.1w) reemplaza al 802.1D original mientras conserva la compatibilidad con versiones anteriores. La terminología de STP 802.1w sigue siendo fundamentalmente la misma que la de STP IEEE 802.1D original. La mayoría de los parámetros se han dejado sin cambios. Los usuarios que estén familiarizados con el estándar STP original pueden configurar fácilmente RSTP. El mismo algoritmo de árbol de expansión se utiliza tanto para STP como para RSTP para determinar los roles de puerto y la topología.

RSTP aumenta la velocidad del recálculo del árbol de expansión cuando cambia la topología de la red de Capa 2. RSTP puede lograr una convergencia mucho más rápida en una red configurada en forma adecuada, a veces sólo en unos pocos cientos de milisegundos. Si un puerto está configurado para ser un puerto alternativo, puede cambiar inmediatamente a un estado de reenvío sin esperar a que la red converja.

> Nota: Rapid PVST + es la implementación de Cisco de RSTP por VLAN. Con Rapid PVST + se ejecuta una instancia independiente de RSTP para cada VLAN.

### PortFast y BPDU Guard

Cuando un dispositivo está conectado a un puerto del switch o cuando un switch se enciende, el puerto del switch pasa por los estados de escucha y aprendizaje, esperando cada vez que expire el temporizador de retardo de reenvío. Este retraso es de 15 segundos para cada estado durante un total de 30 segundos. Esto puede presentar un problema para los clientes DHCP que intentan detectar un servidor DHCP porque el proceso DHCP puede agotarse. El resultado es que un cliente IPv4 no recibirá una dirección IPv4 válida.

Cuando un puerto de switch está configurado con PortFast, ese puerto pasa de un estado de bloqueo al de reenvío inmediatamente, evitando el retraso de 30 segundos. Puede utilizar PortFast en los puertos de acceso para permitir que los dispositivos conectados a estos puertos accedan a la red inmediatamente. PortFast sólo debe utilizarse en puertos de acceso. Si habilita PortFast en un puerto que se conecta a otro switch, corre el riesgo de crear un bucle de árbol de expansión. 

Un puerto de switch habilitado para PortFast nunca debería recibir BPDU porque eso indicaría que el switch está conectado al puerto, lo que podría causar un bucle de árbol de expansión. Los switch Cisco admiten una característica denominada “protección BPDU”. Cuando está habilitado, inmediatamente pone el puerto del switch en un estado errdisabled (error-disabled) al recibir cualquier BPDU. Esto protege contra posibles bucles al apagar eficazmente el puerto. El administrador debe volver a poner manualmente la interfaz en servicio.

### Alternativas a STP

A lo largo de los años, las organizaciones requerían una mayor resiliencia y disponibilidad en la LAN. Las LAN Ethernet pasaron de unos pocos switch interconectados conectados conectados a un único enrutador, a un sofisticado diseño de red jerárquica que incluía switch de acceso, distribución y capa central.

Dependiendo de la implementación, la capa 2 puede incluir no solo la capa de acceso, sino también la distribución o incluso las capas principales. Estos diseños pueden incluir cientos de switch, con cientos o incluso miles de VLAN. STP se ha adaptado a la redundancia y complejidad añadida con mejoras, como parte de RSTP y MSTP.

Un aspecto importante del diseño de red es la convergencia rápida y predecible cuando se produce un error o un cambio en la topología. El árbol de expansión no ofrece las mismas eficiencias y predictibilidades proporcionadas por los protocolos de enrutamiento en la Capa 3.

El enrutamiento de capa 3 permite rutas y bucles redundantes en la topología, sin bloquear puertos. Por esta razón, algunos entornos están en transición a la capa 3 en todas partes, excepto donde los dispositivos se conectan al switch de capa de acceso. En otras palabras, las conexiones entre los switch de capa de acceso y los switch de distribución serían Capa 3 en lugar de Capa 2.



