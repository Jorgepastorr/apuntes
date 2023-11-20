# Diseño de redes

## Redes jerárquicas

### La necesidad de escalar la red

Las empresas recurren cada vez más a su infraestructura de red para proporcionar servicios esenciales. 

Las organizaciones en evolución requieren redes que puedan escalar y soportar:

- Tráfico de redes convergentes.
- Critical applications
- Diverse business needs
- Centralized administrative control

Los diseños de red en campus incluyen desde redes de tamaño pequeño que emplean un único switch de LAN hasta redes de gran tamaño que comprenden muchísimas conexiones.

### Redes conmutadas sin bordes

Cisco Borderless Network es una arquitectura de red que permite que las organizaciones se conecten con cualquier persona, en cualquier lugar, en cualquier momento y en cualquier dispositivo de forma segura, confiable y sin inconvenientes.

- Proporciona el marco para unificar el acceso por cable e inalámbrico, basado en una infraestructura jerárquica de hardware que es escalable y resistente.
- Las redes conmutadas sin bordes son jerárquicas, modulares, resistentes y flexibles.

Las redes jerárquicas utilizan un diseño por niveles de acceso, distribución y capas principales, con cada capa que desempeña un rol bien definido en la red del campus. 

### Funciones de acceso, distribución y capa principal

Capa de acceso

- La capa de acceso otorga a los puntos de acceso y a los usuarios acceso directo a la red.
- Los switches de capa de distribución se conectan a los switches de capa de acceso y capa central.

Capa de distribución

- La capa de distribución implementa el enrutamiento, la calidad del servicio y la seguridad.
- Agrega redes de armarios de cableado a gran escala y limita los dominios de difusión de Capa 2.
- Los switches de capa de distribución se conectan a los conmutadores de capa de acceso y capa central.

Capa de núcleo central

- La capa principal es la red troncal y conecta varias capas de la red. 
- La capa de núcleo brinda aislamiento de fallas y conectividad de la red troncal de alta velocidad.

### redes jerárquicasde tres niveles y dos niveles

Red de campus de tres niveles

- Utilizado por organizaciones que requieren acceso, distribución y capas principales. 
- La recomendación es construir una topología de red física de estrella extendida desde una ubicación centralizada del edificio a todos los demás edificios en el mismo campus.

Red de campus de dos niveles

- Se utiliza cuando no se requiere una distribución separada y capas de núcleo. 
- Útil para ubicaciones de campus más pequeñas, o en sitios de campus que consistan en un solo edificio.
- También conocido como el diseño de red central colapsado .


##  Redes escalables

### Diseño de redes escalables para escalabilidad

La escalabilidad es el término para una red que puede crecer sin perder disponibilidad y confiabilidad.

Los diseñadores de redes deben desarrollar estrategias para permitir que la red esté disponible y escalar de manera efectiva y fácil.

Esto se logra usando:

- Redundancia
- Múltiples Vínculos
- Protocolo de Enrutamiento Escalable
- Conectividad inalámbrica

### Plan de redes escalables para redundancia

La redundancia es una parte importante del diseño de la red para prevenir interrupciones de los servicios de la red al minimizar la posibilidad de un punto único de falla:

- Instalación de equipos duplicados 
- Proporcionar servicios de conmutación por error para dispositivos críticos

Las rutas redundantes ofrecen rutas físicas alternativas para que los datos atraviesen la red y admitan alta disponibilidad.

- Sin embargo, las rutas redundantes en una red Ethernet conmutada pueden causar bucles físicos y lógicos en la capa 2.
- Por esta razón, se necesita el protocolo de árbol de expansión (STP).

### Reducen el tamaño del dominio de errores

Una red bien diseñada controla el tráfico y limita el tamaño de los dominios de error (es decir, el área de una red que se ve afectada cuando la red experimenta problemas).

- En el modelo de diseño jerárquico, los dominios de error se terminan en la capa de distribución. 
- Cada router funciona como una puerta de enlace para un número limitado de usuarios de la capa de acceso.

Los routers, o switches multicapa, generalmente se implementan en pares en una configuración denominada bloque de switch de edificio o departamento. 

- Cada bloque de switches funciona de manera independiente. 
- Como resultado, la falla de un único dispositivo no desactiva la red.

### aumentan el ancho de banda

EtherChannel es una forma de agregación de enlaces que permite que el administrador de redes aumente la cantidad de ancho de banda entre los dispositivos mediante la creación de un enlace lógico fuera de varios enlaces físicos..

EtherChannel combina los puertos de switch existentes en un enlace lógico mediante una interfaz de canal de puerto. 

La mayoría de las tareas de configuración se realizan en la interfaz EtherChannel en lugar de en cada puerto individual, lo que asegura la coherencia de configuración en todos los enlaces.

EtherChannel puede equilibrar la carga entre enlaces.

### Expandir la capa de acceso

Una opción cada vez más popular para extender la conectividad de la capa de acceso es a través de la conexión inalámbrica. 

- Las LAN inalámbricas (WLAN) brindan una mayor flexibilidad, costos reducidos y la capacidad de crecer y adaptarse a los cambiantes requisitos comerciales y de red.
- Para comunicarse de forma inalámbrica, los dispositivos finales requieren una NIC inalámbrica para conectarse a un enrutador inalámbrico o a un punto de acceso inalámbrico (AP).

A la hora de implementar una red inalámbrica se incluyen las siguientes consideraciones:

- Tipos de dispositivos inalámbricos que se conectan a la WLAN
- Requisitos de cobertura inalámbrica
- Consideraciones de interferencia
- Consideraciones sobre seguridad

### sintonizan protocolos de enrutamiento

Los protocolos de enrutamiento avanzados, como Open Shortest Path First (OSPF) se utilizan en redes grandes.

OSPF es un protocolo de enrutamiento de estado de vínculo que utiliza áreas para admitir redes jerárquicas. 

OSPF routers establecen y mantienen adyacencias con OSPF routers vecinos conectados.

Los routers OSPF sincronizan su base de datos de estado de vínculo. 

Cuando se produce un cambio de red, se envían actualizaciones de estado de vínculo, informando a otros enrutadores OSPF del cambio y estableciendo una nueva mejor ruta, si hay una disponible.

