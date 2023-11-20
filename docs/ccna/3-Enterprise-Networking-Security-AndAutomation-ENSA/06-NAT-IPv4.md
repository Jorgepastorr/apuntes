# NAT para IPv4

##  Características de NAT

Las redes suelen implementarse mediante el uso de direcciones IPv4 privadas, según se definen en RFC 1918.

Las direcciones IPv4 privadas no se pueden enrutar a través de Internet y se usan dentro de una organización o sitio para permitir que los dispositivos se comuniquen localmente.

Para permitir que un dispositivo con una dirección IPv4 privada acceda a recursos y dispositivos fuera de la red local, primero se debe traducir la dirección privada a una dirección pública.

NAT proporciona la traducción de direcciones privadas a direcciones públicas.

###  ¿Qué es NAT?

El uso principal de NAT es conservar las direcciones IPv4 públicas.

NAT permite que las redes utilicen direcciones IPv4 privadas internamente y las traduce a una dirección pública cuando sea necesario.

En general, los routers NAT funcionan en la frontera de una red de rutas internas.

Cuando un dispositivo dentro de la red auxiliar desea comunicarse con un dispositivo fuera de su red, el paquete se reenvía al enrutador fronterizo que realiza el proceso NAT, traduciendo la dirección privada interna del dispositivo a una dirección pública, externa y enrutable.

###  ¿Cómo funciona es NAT?

PC1 quiere comunicarse con un servidor web externo con dirección pública 209.165.201.1.

1. La PC1 envía un paquete dirigido al servidor web. 
1. R2 recibe el paquete y lee la dirección IPv4 de origen para determinar si necesita traducción.
1. R2 agrega la asignación de la dirección local a la global a la tabla NAT.
1. El R2 envía el paquete con la dirección de origen traducida hacia el destino.
1. El servidor web responde con un paquete dirigido a la dirección global interna de la PC1 (209.165.200.226).
1. El R2 recibe el paquete con la dirección de destino 209.165.200.226. El R2 revisa la tabla de NAT y encuentra una entrada para esta asignación. El R2 usa esta información y traduce la dirección global interna (209.165.200.226) a la dirección local interna (192.168.10.10), y el paquete se reenvía a la PC1.

### Terminología de NAT

NAT incluye cuatro tipos de direcciones:

- Dirección local interna
- Dirección global interna
- Dirección local externa
- Dirección global externa

La terminología NAT siempre se aplica desde la perspectiva del dispositivo con la dirección traducida:

- Dirección interna: La dirección del dispositivo que NAT está traduciendo.
- Dirección externa: La dirección del dispositivo de destino.
- Dirección local: Una dirección local es cualquier dirección que aparece en la parte interna de la red.
- Dirección global: Una dirección global es cualquier dirección que aparece en la parte externa de la red.

**Dirección local interna**

La dirección de la fuente vista desde dentro de la red. Normalmente, es una dirección IPv4 privada. La dirección local interna de PC1 es 192.168.10.10.

**Direcciones globales internas**

La dirección de origen vista desde la red externa. La dirección global interna de PC1 es 209.165.200.226

**Dirección global externa**

La dirección del destino vista desde la red externa. La dirección global externa del servidor web es 209.165.201.1

**Dirección local externa**

La dirección del destino como se ve desde la red interna. La PC1 envía tráfico al servidor web en la dirección IPv4 209.165.201.1. Si bien es poco frecuente, esta dirección podría ser diferente de la dirección globalmente enrutable del destino.


## Tipos de NAT

### NAT estático

La NAT estática utiliza una asignación uno a uno de direcciones locales y globales configuradas por el administrador de la red que permanecen constantes.

La NAT estática es útil para servidores web o dispositivos que deben tener una dirección coherente a la que se pueda acceder desde Internet, como un servidor web de la empresa. 

También es útil para dispositivos que deben ser accesibles por personal autorizado cuando se encuentra fuera del sitio, pero no por el público en general en Internet.

### NAT Dinámica

La NAT dinámica utiliza un conjunto de direcciones públicas y las asigna según el orden de llegada. 

Cuando un dispositivo interno solicita acceso a una red externa, la NAT dinámica asigna una dirección IPv4 pública disponible del conjunto.

Las otras direcciones del grupo todavía están disponibles para su uso. 

> Nota: NAT dinámica requiere que haya suficientes direcciones públicas disponibles para satisfacer el número total de sesiones de usuario simultáneas.

### NAT con sobrecarga (PAT)

La traducción de la dirección del puerto (PAT), también conocida como “NAT con sobrecarga”, asigna varias direcciones IPv4 privadas a una única dirección IPv4 pública o a algunas direcciones.

Con PAT, cuando el router NAT recibe un paquete del cliente, utiliza el número de puerto de origen para identificar de forma exclusiva la traducción NAT específica.

PAT garantiza que los dispositivos usen un número de puerto TCP diferente para cada sesión con un servidor en Internet.

#### Siguiente puerto disponible

PAT intenta conservar el puerto de origen inicial. Si el puerto de origen original ya está en uso, PAT asigna el primer número de puerto disponible a partir del comienzo del grupo de puertos apropiado 0-511, 512-1,023 o 1,024-65,535.

Cuando no hay más puertos disponibles y hay más de una dirección externa en el conjunto de direcciones, 

PAT avanza a la siguiente dirección para intentar asignar el puerto de origen inicial. 
El proceso continúa hasta que no haya más puertos disponibles o direcciones IPv4 externas en el grupo de direcciones.

### Comparacion NAT y PAT

La tabla proporciona un resumen de las diferencias entre NAT y PAT.

| NAT                                                                                                  | PAT                                                                                                                    |
| :--------------------------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------- |
| Mapeo uno a uno entre las direcciones Inside Local y Inside Global.                                  | Una dirección global interna se puede asignar a muchas direcciones locales internas.                                   |
| Utiliza sólo direcciones IPv4 en el proceso de traducción.                                           | Utiliza direcciones IPv4 y números de puerto de origen TCP o UDP en la traducción proceso.                             |
| Se requiere una dirección única de Inside Global para cada host interno accediendo a la red externa. | Una única dirección única de Inside Global puede ser compartida por muchos hosts internos accediendo a la red externa. |


### Paquetes sin un segmento de capa 4

Algunos paquetes no contienen un número de puerto de Capa 4, como mensajes ICMPv4. PAT maneja cada uno de estos tipos de protocolos de manera diferente.

Por ejemplo, los mensajes de consulta, las solicitudes de eco y las respuestas de eco de ICMPv4 incluyen una ID de consulta. ICMPv4 utiliza la ID de consulta para identificar una solicitud de eco con su respectiva respuesta.

> Nota: Otros mensajes ICMPv4 no usan la ID de consulta. Estos mensajes y otros protocolos que no utilizan los números de puerto TCP o UDP varían y exceden el ámbito de este currículo.


## Ventajas y desventajas de NAT

NAT proporciona muchos beneficios:

- NAT conserva el esquema de direccionamiento legalmente registrado al permitir la privatización de las intranets. 
- NAT conserva las direcciones mediante la multiplexación de aplicaciones en el nivel de puerto. 
- NAT aumenta la flexibilidad de las conexiones a la red pública.
- NAT proporciona coherencia a los esquemas de direccionamiento de red interna. 
- NAT permite mantener el esquema de direcciones IPv4 privadas existente a la vez que facilita el cambio a un nuevo esquema de direccionamiento público. 
- NAT oculta las direcciones IPv4 de los usuarios y otros dispositivos. 

NAT tiene inconvenientes:

- NAT aumenta los retrasos de reenvío.
- Se pierde el direccionamiento de extremo a extremo.
- Se pierde la trazabilidad IPv4 de extremo a extremo.
- NAT complica el uso de protocolos de túnel, como IPSec.
- Los servicios que requieren que se inicie una conexión TCP desde la red externa, o “protocolos sin estado”, como los servicios que utilizan UDP, pueden interrumpirse. 

## NAT estática

### Configurar NAT estático

Hay dos tareas básicas al configurar traducciones NAT estáticas:

1. Crear una asignación entre la dirección local interna y las direcciones globales internas utilizando el comando ip nat inside source static. 
2. Las interfaces que participan en la traducción se configuran como dentro o fuera en relación con NAT con los comandos ip nat inside y ip nat outside. 

    R2(config)# ip nat inside source static 192.168.10.254 209.165.201.5
    R2(config)#
    R2(config)# interface serial 0/1/0
    R2(config-if)# ip address 192.168.1.2 255.255.255.252
    R2(config-if)# ip nat inside
    R2(config-if)# exit
    R2(config)# interface serial 0/1/1
    R2(config-if)# ip address 209.165.200.1 255.255.255.252
    R2(config-if)# ip nat outside

### Verificación de NAT estática

Para verificar la operación NAT, emita el comando `show ip nat translation.`

Este comando muestra las traducciones NAT activas. 

Debido a que el ejemplo es una configuración NAT estática, siempre figura una traducción en la tabla de NAT, independientemente de que haya comunicaciones activas.

Si el comando se emite durante una sesión activa, la salida también indica la dirección del dispositivo externo.

Otro comando útil es `show ip nat stats`.

Muestra información sobre el número total de traducciones activas, los parámetros de configuración de NAT, el número de direcciones en el grupo y el número de direcciones que se han asignado.

Para verificar que la traducción NAT está funcionando, es mejor borrar las estadísticas de cualquier traducción anterior utilizando el comando `clear ip nat statistics` antes de realizar la prueba.


## NAT dinámica

### Configurar NAT dinámico

Hay cinco tareas para configurar las traducciones NAT dinamicas.

1. Defina el conjunto de direcciones que se utilizarán para la traducción con el comando ip nat pool. 
2. Configure una ACL estándar para identificar (permitir) solo aquellas direcciones que se traducirán.
3. Enlazar la ACL al grupo, utilizando el  comando ip nat inside source list. 
4. Identifique qué interfaces están dentro.  
5. Identifique qué interfaces están fuera.  

    R2(config)# ip nat pool NAT-POOL1 209.165.200.226 209.165.200.240 netmask 255.255.255.224
    R2(config)# access-list 1 permit 192.168.0.0 0.0.255.255
    R2(config)# ip nat inside source list 1 pool NAT-POOL1

    R2(config)# interface serial 0/1/0
    R2(config-if)# ip nat inside
    R2(config-if)# interface serial 0/1/1
    R2(config-if)# ip nat outside


### Analizar NAT dinámico: interior a exterior

Proceso de traducción de NAT dinámica:

1. PC1 y PC2 envían paquetes solicitando una conexión al servidor.
2. R2 recibe el primer paquete de PC1, comprueba el ALC para determinar si el paquete debe traducirse, selecciona una dirección global disponible y crea una entrada de traducción en la tabla NAT.
3. El R2 reemplaza la dirección de origen local interna de la PC1, 192.168.10.10, por la dirección global interna traducida 209.165.200.226 y reenvía el paquete. (El mismo proceso ocurre para el paquete de PC2 usando la dirección traducida de 209.165.200.227.)
4. El servidor recibe el paquete de PC1 y responde con la dirección de destino 209.165.200.226. El servidor recibe el paquete de PC2, responde utilizando la dirección de destino 209.165.200.227.
5. opcion
   - (a) Cuando R2 recibe el paquete con la dirección de destino 209.165.200.226; realiza una búsqueda de tabla NAT y traduce la dirección de vuelta a la dirección local interna y reenvía el paquete hacia PC1.
    - (b) Cuando R2 recibe el paquete con la dirección de destino 209.165.200.227; realiza una búsqueda de tabla NAT y traduce la dirección de vuelta a la dirección local interior 192.168.11.10 y reenvía el paquete hacia PC2.
6. La PC1 y la PC2 reciben los paquetes y continúan la conversación. El router lleva a cabo los pasos 2 a 5 para cada paquete.


## PAT

### Configurar PAT para usar una única dirección IPv4

Para configurar PAT para que utilice una sola dirección IPv4, agregue la palabra clave overload al comando `ip nat inside source` .

En el ejemplo, todos los hosts de la red 192.168.0.0/16 (coincidencia ACL 1) que envían tráfico a través del router R2 a Internet se traducirán a la dirección IPv4 209.165.200.225 (dirección IPv4 de la interfaz S0 / 1/1). Los flujos de tráfico se identificarán mediante números de puerto en la tabla NAT porque la palabra clave de  overload está configurada.

    R2(config)# ip nat inside source list 1 interface serial 0/1/1 overload
    R2(config)# access-list 1 permit 192.168.0.0 0.0.255.255
    R2 (config) # interfaz serial0/1/0
    R2(config-if)# ip nat inside
    R2(config-if)# exit
    R2 (config) # interfaz Serial0/1/1
    R2(config-if)# ip nat outside

### Configurar PAT para usar un grupo de direcciones

Un ISP puede asignar más de una dirección IPv4 pública a una organización. En este escenario, la organización puede configurar PAT para utilizar un grupo de direcciones públicas IPv4 para la traducción.
Para configurar PAT para un grupo de direcciones NAT dinámico, simplemente agregue la palabra clave overload al comando `ip nat inside source` .

En el ejemplo, NAT-POOL2 está enlazado a una ACL para permitir la traducción de 192.168.0.0/16. Estos hosts pueden compartir una dirección IPv4 del grupo porque PAT está habilitado con la palabra clave overload. 

    R2(config)# ip nat pool NAT-POOL2 209.165.200.226 209.165.200.240 netmask 255.255.255.224
    R2(config)# access-list 1 permit 192.168.0.0 0.0.255.255
    R2(config)# ip nat inside source list 1 pool NAT-POOL2 overload
    R2(config)# interface serial0/1/0
    R2(config-if)# ip nat inside
    R2 (config-if) # interfaz serial0/1/1
    R2(config-if)# ip nat outside


## NAT64

### ¿NAT 64 para IPv6? 

IPv6 se desarrolló con la intención de que la NAT para IPv4 con su traducción entre direcciones IPv4 públicas y privadas resulte innecesaria. 

Sin embargo, IPv6 sí incluye su propio espacio de direcciones privadas IPv6, direcciones locales únicas (ULA).

Las direcciones IPv6 locales únicas (ULA) se asemejan a las direcciones privadas en IPv4 definidas en RFC 1918, pero con un propósito distinto. 

Las direcciones ULA están destinadas únicamente a las comunicaciones locales dentro de un sitio. Las direcciones ULA no están destinadas a proporcionar espacio de direcciones IPv6 adicional ni a proporcionar un nivel de seguridad.
IPv6 proporciona la traducción de protocolos entre IPv4 e IPv6 conocida como NAT64.

### NAT64

NAT para IPv6 se usa en un contexto muy distinto al de NAT para IPv4. 

Las variedades de NAT para IPv6 se utilizan para proporcionar acceso transparente entre redes de solo IPv6 e IPv4, como se muestra. No se utiliza como forma de traducción de IPv6 privada a IPv6 global.

NAT para IPv6 no debe usarse como una estrategia a largo plazo, sino como un mecanismo temporal para ayudar en la migración de IPv4 a IPv6. 



