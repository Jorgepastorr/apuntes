# Conceptos WAN

## Propósito de las WANs

### LANs y WANs

Una WAN es una red de telecomunicaciones que abarca un área geográfica relativamente grande y se requiere para conectarse más allá del límite de la LAN. 

Redes de área local (LAN) 	

- Las redes locales proporcionan servicios de red dentro de una pequeña área geográfica (es decir, red doméstica, red de oficinas, red de edificios o red de campus).
- Las LAN se utilizan para interconectar equipos locales, periféricos y otros dispositivos.	
- Una LAN es propiedad de una organización o un usuario doméstico y la administra.	
- Aparte de los costos de infraestructura de red, no se cobra ningún cargo por usar un LAN.	
- Las LAN proporcionan altas velocidades de ancho de banda mediante Ethernet y Wi-Fi por cable servicios de la red.	

Redes de área extensa (WAN)

- Las WAN proporcionan servicios de red en grandes áreas geográficas (es decir, en y entre ciudades, países y continentes).
- Las WAN proporcionan servicios de red en grandes áreas geográficas (es decir, en y entre ciudades, países y continentes).
- Las WAN se utilizan para interconectar usuarios, redes y sitios remotos.
- Las WAN son propiedad y administradas por servicios de Internet, teléfono, cable y proveedores de satélites.
- Los servicios de WAN se proporcionan por una tarifa.
- Los proveedores de WANs ofrecen velocidades de ancho de banda bajas a altas, a largas distancias utilizando redes físicas complejas.


### Privadas y Públicas

Una WAN privada es una conexión dedicada a un único cliente.
 
Las WAN privadas proporcionan lo siguiente:

- Nivel de servicio garantizado
- Ancho de banda consistente
- Seguridad

Normalmente, un ISP o un proveedor de servicios de telecomunicaciones que utiliza Internet proporciona una conexión WAN pública. En este caso, los niveles de servicio y el ancho de banda pueden variar, y las conexiones compartidas no garantizan la seguridad.

### Topologías WAN

Las WAN se implementan utilizando los siguientes diseños de topología lógica:

- Topología punto a punto
- Topología de estrella (hub and spoke)
- Topología de doble conexión
- Topología de malla completa
- Topología parcialmente mallada

> Nota: Las redes grandes suelen implementar una combinación de estas topologías. 

**Topología punto a punto**

- Emplea un circuito punto a punto entre dos terminales.
- Implica un servicio de transporte de capa 2 a través de la red del proveedor de servicios.
- La conexión punto a punto es transparente para la red del cliente.

**Topología de estrella (hub and spoke)**

- Permite que una sola interfaz al hub puede ser compartida por todos los circuitos de radio.
- Los sitios radiales se pueden interconectar a través del sitio de hub mediante circuitos virtuales y subinterfaces enrutadas del hub.
- Los routers radiales solo pueden comunicarse entre sí a través del router concentrador.

> Nota: El router central (concentrador) representa un punto único de falla. Si falla, la comunicación entre radios también falla. 

**Topología de doble conexión**

- Ofrecen redundancia de red mejorada, equilibrio de carga, computación o procesamiento distribuido y la capacidad de implementar conexiones del proveedor de servicio de respaldo.
- Más caro de implementar que las topologías de un solo hogar. Esto es porque requieren hardware de red, como routers y switches adicionales.
- Además, son más difíciles de implementar porque requieren configuraciones adicionales y más complejas.

**Topología de malla completa**

- Utiliza múltiples circuitos virtuales para conectar todos los sitios
- La topología más tolerante a errores

**Topología parcialmente mallada**

- Conecta muchos sitios pero no todos


### Conexiones de operador

Otro aspecto del diseño WAN es cómo una organización se conecta a Internet. Por lo general, una organización firma un acuerdo de nivel de servicio (SLA) con un proveedor de servicios. El SLA describe los servicios esperados relacionados con la fiabilidad y disponibilidad de la conexión. 

El proveedor de servicios puede o no ser el transportista real. Un transportista posee y mantiene la conexión física y el equipo entre el proveedor y el cliente. Normalmente, una organización elegirá una conexión WAN de un solo operador o de dos portadoras.

Una conexión de operador único es cuando una organización se conecta a un único proveedor de servicios. Un SLA se negocia entre la organización y el proveedor de servicios. 

Una conexión de doble operador proporciona redundancia y aumenta la disponibilidad de la red. La organización negocia acuerdos de nivel de servicio independientes con dos proveedores de servicios diferentes. 


### Evolución de las redes

Los requisitos de red de una empresa pueden cambiar significativamente a medida que la empresa crece con el tiempo.

- Una red no solo debe satisfacer las necesidades operativas diarias de la empresa, sino que debe ser capaz de adaptarse y crecer a medida que la empresa cambia. 
- Los diseñadores de redes y los administradores pueden abordar estos desafíos eligiendo cuidadosamente las tecnologías de red, los protocolos y los proveedores de servicios. 
- Las redes se pueden optimizar mediante el uso de una variedad de técnicas y arquitecturas de diseño de red.

Para ilustrar las diferencias entre el tamaño de la red, utilizaremos una empresa ficticia llamada SPAN Engineering a medida que crece de un pequeño negocio local a una empresa global.


**Redes pequeñas**

SPAN, una pequeña empresa ficticia, comenzó con unos pocos empleados en una pequeña oficina.

- Utiliza una única LAN conectada a un router inalámbrico para compartir datos y periféricos.
- La conexión a Internet se realiza a través de un servicio de banda ancha común denominado línea de suscriptor digital (DSL).
- El soporte de TI se contrata con el proveedor de DSL.

**Red de campus**

Dentro de unos años SPAN creció y requirió varios pisos de un edificio.

- La empresa necesitaba ahora una red de área de campus (CAN).
- Un firewall asegura el acceso a Internet a los usuarios corporativos.
- La empresa cuenta con personal interno de TI para dar soporte y mantenimiento a la red.

**Red de la sucursal**

Unos años más tarde, la compañía se expandió y agregó una sucursal en la ciudad, y sitios remotos y regionales en otras ciudades.

La compañía necesitaba ahora una red de área metropolitana (MAN) para interconectar sitios dentro de la ciudad. 

Para conectarse con la oficina central las sucursales que están en ciudades usan líneas privadas dedicadas a través de su proveedor de servicios local.

**Red distribuida**

SPAN Ingeniería tiene 20 años de operación y cuenta con miles de empleados distribuidos en oficinas en todo el mundo.

Las redes privadas virtuales (VPN) de sitio a sitio y de acceso remoto permiten que la empresa use Internet para conectarse de manera fácil y segura con los empleados y las instalaciones en todo el mundo.

## Funcionamiento de WAN

### Estándares WAN

Varias autoridades reconocidas definen y administran los estándares de acceso WAN:

- TIA/EIA - Asociación de la Industria de Telecomunicaciones y Alianza de Industrias Electrónicas 
- ISO - Organización Internacional de Estandarización.
- IEEE - Instituto de Ingenieros en Electricidad y Electrónica

### WAN en el modelo OSI

La mayoría de los estándares WAN se centran en la capa física y la capa de enlace de datos.

Protocolos de capa 1

- Jerarquía digital sincrónica (SDH, Synchronous Digital Hierarchy)
- Red óptica síncrona (SONET)
- Multiplexado por división de longitud de onda densa (DWDM)

Protocolos de capa 2

- Banda ancha (es decir, DSL y cable)
- Conexión inalámbrica
- WAN Ethernet (Metro Ethernet)
- Switching por etiquetas multiprotocolo (MPLS)
- Protocolo punto a punto (PPP) (menos usado).
- Control de enlace de datos de alto nivel (HDLC, High-Level Data Link Control)(menos usado).
- Frame Relay (heredado)
- Modo de transferencia asíncrona (ATM, asynchronous transfer mode)

### Terminología común WAN

Existen términos específicos utilizados para describir las conexiones WAN entre el suscriptor (es decir, la empresa/cliente) y el proveedor de servicios WAN.


Equipo terminal de datos (DTE) 	

- Este es el dispositivo que conecta las LAN de suscriptor a la WAN dispositivo de comunicación (es decir, DCE).
- El dispositivo DTE suele ser un router, pero podría ser un host o un servidor.

Equipo de comunicación de datos (DCE) 	

- Dispositivo utilizado para comunicarse con el proveedor

Equipo de las instalaciones del cliente (CPE) 	

- Estos son los dispositivos DTE y DCE (es decir, router, módem, óptico convertidor) ubicado en el perímetro empresarial.
- El suscriptor posee el CPE o arrienda el CPE del proveedor de servicios

Punto de presencia (POP) 	

- Este es el punto donde el suscriptor se conecta al servicio Red de proveedor

Punto de demarcación 	

- Esta es una ubicación física en un edificio o complejo que oficialmente separa el CPE del equipo del proveedor de servicios.

Loop local (o última milla) 	

- Este es el cable real de cobre o fibra que conecta el CPE a el CO del proveedor de servicios.

Oficina central (CO) 	

- Esta es la instalación del proveedor de servicios local o edificio que conecta el CPE a la red del proveedor.

Red con cargo 	

- Esto incluye backhaul, larga distancia, todo digital, fibra óptica líneas de comunicaciones, switches, routers y otros equipos dentro de la red del proveedor WAN.

Red de backhaul

- conectan varios nodos de acceso de la red del proveedor de servicios.

Red troncal 	

- Redes grandes y de alta capacidad utilizadas para interconectar redes de proveedores de servicios y crear una red redundante.

### Dispositivos WAN

Existen muchos tipos de dispositivos que son específicos de los entornos WAN: 


Módem de banda de voz 	

- También conocido como módem de acceso telefónico.
- Dispositivo heredado que convirtió (es decir, moduló) las señales digitales producido por una computadora en frecuencias de voz analógicas.
- Utiliza líneas telefónicas para transmitir datos. 

Módem DSL y Módem por cable 	

- Conocidos colectivamente como módems de banda ancha, estos digitales de alta velocidad se conectan al router DTE mediante Ethernet.

CSU/DSU 	

- Las líneas arrendadas digitalmente requieren una CSU y una DSU.
- Conecta un dispositivo digital a una línea digital.

Optical Converter 	

- También conocido como un convertidor de fibra óptica.
- Estos dispositivos conectan medios de fibra óptica a medios de cobre y convierten señales ópticas a impulsos electrónicos.

Router inalámbrico o Punto de Acceso 	

- Los dispositivos se utilizan para conectarse de forma inalámbrica a un proveedor WAN.

Dispositivos WAN Core 	

- La red troncal WAN consta de múltiples routers de alta velocidad y Capa 3 switches.

###  Comunicación en serie

Casi todas las comunicaciones de red se producen mediante una entrega de comunicaciones en serie. La comunicación serial transmite los bits secuencialmente a través de un solo canal.

Por el contrario, las comunicaciones paralelas transmiten simultáneamente varios bits utilizando varios cables.

A medida que aumenta la longitud del cable, la sincronización entre varios canales se vuelve más sensible a la distancia. Por esta razón, la comunicación paralela se limita a distancias muy cortas

###  Comunicación Conmutada por Circuito 

Las red de conmutación de circuitos son aquellas que establecen un circuito (o canal) dedicado entre los nodos y las terminales antes de que los usuarios se puedan comunicar.

La tecnología ATM requiere el establecimiento de una conexión a través de una red de proveedor de servicios antes de que se pueda iniciar la comunicación.

Todas las comunicaciones usan la misma ruta.

Los dos tipos más comunes de tecnologías WAN de conmutación de circuitos son la red pública de telefonía de conmutación (PSTN) y la red digital de servicios integrados (ISDN). 


###  Comunicación Conmutada por Paquetes

La comunicación de red se implementa con mayor frecuencia mediante la comunicación conmutada por paquetes.

- La conmutación por paquetes divide el tráfico en paquetes que se enrutan a través de una red compartida.
- Mucho menos costoso y más flexible que la conmutación de circuitos.
- Los tipos comunes de tecnologías WAN conmutadas por paquetes son:
    - WAN Ethernet (Metro Ethernet), 
    - Switching por Etiquetas Mltiprotocolo (MPLS)
    - Frame Relay
    - Asynchronous Transfer Mode (ATM).


### SDH, SONET y DWDM

Las redes de proveedores de servicios utilizan infraestructuras de fibra óptica para transportar datos de usuarios entre destinos. El cable de fibra óptica es muy superior al cable de cobre para transmisiones de larga distancia debido a su atenuación e interferencia mucho menor.

Hay dos estándares OSI capa 1 de fibra óptica disponibles para los proveedores de servicios:

- SDH - Synchronous Digital Hierarchy (SDH) es un estándar global para el transporte de datos a través de cable de fibra óptica. 
- SONET - Red óptica síncrona (SONET) es el estándar norteamericano que ofrece los mismos servicios que SDH. 

SDH/SONET definen cómo transferir múltiples comunicaciones de datos, voz y video a través de fibra óptica mediante láseres o diodos emisores de luz (LED) por grandes distancias.

La multiplexación por división de longitud de onda densa (DWDM) es una tecnología más reciente que aumenta la capacidad de transmisión de datos de SDH y SONET al enviar simultáneamente múltiples flujos de datos (multiplexación) utilizando diferentes longitudes de onda de luz. 


## Conectividad de la WAN tradicional

### Opciones de conectividad WAN tradicionales

Para entender las WAN de hoy, ayuda saber por dónde comenzaron. 

Cuando las LAN aparecieron en la década de 1980, las organizaciones comenzaron a ver la necesidad de interconectarse con otras ubicaciones. 

Para ello, necesitaban sus redes para conectarse al bucle local de un proveedor de servicios. 

Esto se logró mediante el uso de líneas dedicadas o mediante el uso de servicios conmutados de un proveedor de servicios.

###  Terminología WAN común

Por lo general, un proveedor de servicios arrienda las líneas punto a punto, que se llaman “líneas arrendadas”. El término "línea arrendada" hace referencia al hecho de que la organización paga una tarifa mensual de arrendamiento a un proveedor de servicios para usar la línea.

Hay líneas arrendadas disponibles de distintas capacidades y, por lo general, su precio depende del ancho de banda necesario y de la distancia entre los dos puntos conectados.

Hay dos sistemas utilizados para definir la capacidad digital de un enlace serie de medios de cobre:

- T-carrier - Utilizado en América del Norte, T-carrier proporciona enlaces T1 que admiten ancho de banda de hasta 1.544 Mbps y enlaces T3 que soportan ancho de banda de hasta 43,7 Mbps. 
- E-carrier — Utilizado en Europa, e-carrier proporciona enlaces E1 que admiten ancho de banda de hasta 2.048 Mbps y enlaces E3 que admiten ancho de banda de hasta 34.368 Mbps. 


**Ventajas**

Simplicidad: Los enlaces de comunicación punto a punto requieren una experiencia mínima para instalar y mantener.

Calidad: Los enlaces de comunicación punto a punto suelen ofrecer un servicio de alta calidad, si tienen un ancho de banda adecuado. La capacidad dedicada elimina la latencia o fluctuación entre los extremos.

Disponibilidad: La disponibilidad constante es esencial para algunas aplicaciones, como e-commerce. Los enlaces de comunicación punto a punto proporcionan permanente, capacidad dedicada que se requiere para VoIP o Video sobre IP.

**Desventajas**

Costo:	Los enlaces punto a punto son generalmente el tipo más costoso de WAN acceso. El costo de las soluciones de línea arrendada puede llegar a ser significativo cuando se utilizan para conectar muchos sitios a distancias cada vez mayores. En además, cada terminal requiere una interfaz en el router, lo que aumenta los costos de equipo.

Flexibilidad limitada:	El tráfico WAN suele ser variable, y las líneas arrendadas tienen una capacidad fija, para que el ancho de banda de la línea rara vez coincida con la necesidad exactamente. Cualquier cambio a la línea arrendada generalmente requiere una visita al sitio por parte del ISP personal para ajustar la capacidad.

###  Opciones de conexiones conmutadas por circuitos

Las conexiones conmutadas por circuitos son proporcionadas por los operadores de la Red Telefónica de Servicio Público (PSTN). El bucle local que conecta el CPE al CO es un medio de cobre. 

Hay dos opciones tradicionales de conmutación de circuito:

Conexiones para la Red de telefonía de servicio público (PSTN)

- El acceso a la WAN de acceso telefónico utiliza la RTC como su conexión WAN. Los bucles locales tradicionales pueden transportar datos informáticos binarios a través de la red telefónica de voz mediante un módem.
- Las características físicas del bucle local y su conexión a la PSTN limitan la velocidad de señal a menos de 56 kbps.
  
Red digital de servicios integrados (ISDN)

- ISDN es una tecnología de conmutación de circuitos que permite al bucle local PSTN transportar señales digitales. Esto proporcionó conexiones conmutadas de mayor capacidad que el acceso telefónico. ISDN proporciona velocidades de datos de 45 Kbps a 2.048 Mbps.

### Opciones de conmutación por paquetes

La conmutación por paquetes divide el tráfico en paquetes que se enrutan a través de una red compartida. Permite que muchos pares de nodos se comuniquen a través del mismo canal.

Hay dos opciones tradicionales (heredadas) de conmutación de paquetes:

**Frame Relay**

- La retransmisión de tramas (Frame Relay) es una tecnología WAN multiacceso sin difusión (NBMA) simple de capa 2 que se utiliza para interconectar las redes LAN de una empresa.
- Frame Relay crea PVC que se identifican únicamente por un identificador de conexión de enlace de datos (DLCI).

**Modo de Transferencia Asíncrona (ATM, asynchronous transfer mode)**

- La tecnología del Modo de Transferencia Asíncrona (ATM) puede transferir voz, video y datos a través de redes privadas y públicas. 
- ATM construye sobre una arquitectura basada en celdas, en vez de una arquitectura basada en tramas. Las celdas ATM tienen siempre una longitud fija de 53 bytes.

> Nota: Las redes de Frame Relay y ATM han sido reemplazadas en gran medida por soluciones Metro Ethernet más rápidas y basadas en Internet. 


## Conectividad WAN moderna

###  WAN Modernas

Las WANS modernas tienen más opciones de conectividad que los WAN tradicionales. 

Las empresas ahora requieren opciones de conectividad WAN más rápidas y flexibles.

Las opciones de conectividad WAN tradicionales han disminuido rápidamente en uso porque ya no están disponibles, son demasiado caras o tienen un ancho de banda limitado.

### Opciones de conectividad WAN modernas

Las nuevas tecnologías están surgiendo continuamente. La figura resume las opciones modernas de conectividad WAN.

Banda ancha dedicada

- Una organización puede instalar fibra de forma independiente para conectar ubicaciones remotas directamente entre sí. 
- La fibra oscura se puede alquilar o comprar a un proveedor. 

Conmutada por paquetes

- Metro Ethernet — Reemplazar muchas opciones WAN tradicionales. 
- MPLS: permite que los sitios se conecten al proveedor independientemente de sus tecnologías de acceso.

Banda ancha basada en Internet

- Actualmente, las organizaciones utilizan habitualmente la infraestructura global de Internet para la conectividad WAN.

### Ethernet WAN

Los proveedores de servicios ahora ofrecen servicio WAN Ethernet con cableado de fibra óptica. 

El servicio WAN Ethernet puede ir por muchos nombres, incluidos los siguientes:

- Ethernet metropolitana (MetroE)
- Ethernet sobre MPLS
- Servicio de LAN privada virtual (VPLS)

Existen varios beneficios de una WAN Ethernet:

- Gastos y administración reducidos.
- Fácil integración con las redes existentes.
- Mejoramiento de la productividad de la empresa.

### MPLS

**Multiprotocol Label Switching (MPLS)** es una tecnología de enrutamiento WAN de proveedor de servicios de alto rendimiento para interconectar clientes sin tener en cuenta el método de acceso o la carga útil.  

MPLS soporta una variedad de métodos de acceso de cliente (por ejemplo, Ethernet, DSL, Cable, Frame Relay).

MPLS puede encapsular todos los tipos de protocolos, incluido el tráfico IPv4 e IPv6.

Un router MPLS puede ser un router de borde de cliente (CE), un router de borde de proveedor (PE) o un router de proveedor interno (P).

Los routers MPLS también se denominan routers conmutados por etiquetas (LSR). Adjuntan etiquetas a paquetes que luego son utilizados por otros routers MPLS para reenviar tráfico.

MPLS también proporciona servicios para soporte QoS, ingeniería de tráfico, redundancia y VPNs.


## Conectividad basada en Internet

### Internet Opciones de conectividad basada en Internet

La conectividad de banda ancha basada en Internet es una alternativa al uso de opciones WAN dedicadas.

La conectividad basada en Internet se puede dividir en opciones cableadas e inalámbricas.

Opciones con cable

- Las opciones cableadas utilizan cableado permanente (por ejemplo, cobre o fibra) para proporcionar ancho de banda consistente y reducir las tasas de error y la latencia. Ejemplos: DSL, las conexiones de TV por cable y las redes de fibra óptica.

Opciones inalámbricas

- Las opciones inalámbricas son menos costosas de implementar en comparación con otras opciones de conectividad WAN porque utilizan ondas de radio en lugar de medios cableados para transmitir datos. Ejemplos: los servicios de Internet celulares 3G/4G/5G o satelitales.
- Las señales inalámbricas pueden verse afectadas negativamente por factores como la distancia de las torres de radio, la interferencia de otras fuentes y el clima.


###  Tecnología DSL

La tecnología DSL es una tecnología de conexión permanente que usa las líneas telefónicas de par trenzado existentes para transportar datos con un ancho de banda elevado y proporciona servicios IP a los suscriptores.

Los DSL se clasifican como DSL asimétrico (ADSL) o DSL simétrico (SDSL). 

- ADSL y ADSL2 + proporciona mayor ancho de banda descendente al usuario que el ancho de banda de carga.
- SDSL proporciona la misma capacidad en ambas direcciones.

Las velocidades de transferencia DSL dependen de la extensión real del bucle local, y del tipo y la condición del cableado.


### Conexiones DSL

Los proveedores de servicios implementan conexiones DSL en el bucle local. La conexión se configura entre el módem DSL y el multiplexor de acceso DSL (DSLAM).

El módem DSL convierte las señales Ethernet del dispositivo de teletrabajador en una señal DSL, que se transmite a un multiplexor de acceso DSL (DSLAM) en la ubicación del proveedor.

Un DSLAM es el dispositivo ubicado en la oficina central (CO) del proveedor y concentra las conexiones de varios suscriptores de DSL.

DSL no es un medio compartido. Cada usuario tiene su propia conexión directa al DSLAM. Agregar usuarios no impide el rendimiento.

### DSL y PPP

Los ISP suelen usar PPP como protocolo de enlace de datos a través de las conexiones de banda ancha.

- PPP se puede utilizar para autenticar al suscriptor.
- PPP puede asignar una dirección IPv4 pública al suscriptor.
- El PPP también incluye la función de administración de calidad de enlace.

Hay dos maneras de implementar PPP sobre Ethernet (PPPoE):

- Host con cliente PPPoE - El software cliente PPPoE se comunica con el módem DSL mediante PPPoE y el módem se comunica con el ISP mediante PPP. 
- Cliente PPPoE Router - El router es el cliente PPPoE y obtiene su configuración del proveedor.  


###  Tecnología de cable

La tecnología de cable es una tecnología de conexión siempre activa de alta velocidad que utiliza un cable coaxial de la compañía de cable para proporcionar servicios IP a los usuarios.

La especificación de interfaz del servicio de datos por cable (DOCSIS) es el estándar internacional para agregar datos de ancho de banda de alta velocidad a un sistema de cables existente.

- El nodo óptico convierte las señales de RF en impulsos de luz sobre el cable de fibra óptica. 
- El medio de fibra permite que las señales viajen a largas distancias hasta la cabecera del proveedor donde se encuentra un sistema de terminación de módem por cable (CMTS).
- El encabezado contiene las bases de datos necesarias para proporcionar acceso a Internet, mientras que el CMTS es responsable de comunicarse con los módems por cable.


> Nota:Todos los suscriptores locales comparten el mismo ancho de banda de cable.Fuzzy match 80% - Approved A medida que se unen más usuarios al servicio, es posible que el ancho de banda disponible caiga por debajo de la velocidad esperada.

### Fibra óptica

Muchos municipios, ciudades y proveedores instalan cable de fibra óptica en la ubicación del usuario. 
Esto se conoce comúnmente como Fiber to the x (FTTx) e incluye lo siguiente:

- Fiber to the Home (FTTH) - La fibra alcanza el límite de la residencia.  
- Fiber to the Building (FTTB) - La fibra alcanza el límite del edificio con la conexión final con el espacio de vida individual que se realiza a través de medios alternativos. 
- Fiber to the Node/Neighborhood (FTTN) : el cableado óptico llega a un nodo óptico que convierte las señales ópticas a un formato aceptable para par trenzado o cable coaxial a la premisa. 


### Banda ancha inalámbrica basada en Internet

Para enviar y recibir datos, la tecnología inalámbrica usa el espectro de radio sin licencia.

**Wi-Fi Municipal**: Algunas de estas redes proporcionan acceso a Internet de alta velocidad de manera gratuita o por un precio sustancialmente inferior al de otros servicios de banda ancha..

**Celular**: Cada vez se utiliza más para conectar dispositivos a Internet mediante ondas de radio para comunicarse a través de una torre de telefonía móvil cercana. 3G/4G/5G y la evolución a largo plazo (LTE) son tecnologías celulares. 

**Internet satelital**: Generalmente utilizada por usuarios en áreas rurales, donde no hay cable ni DSL. Específicamente, un router se conecta a un plato satelital que apunta al satélite de un proveedor de servicios. Los árboles y las fuertes lluvias pueden impactar la señal satelital. 

**WiMAX:** Interoperabilidad mundial para acceso por microondas que proporciona un servicio de banda ancha de alta velocidad con acceso inalámbrico y una amplia cobertura, como una red de telefonía celular, en vez de pequeñas zonas de cobertura inalámbrica Wi-Fi.


###  Opciones de conectividad de ISP

Hay diferentes maneras en que una organización puede conectarse a un ISP. La elección depende de las necesidades y el presupuesto de la organización.

**Una sola conexión**: Una sola conexión al ISP mediante un enlace. No proporciona redundancia y es la solución menos costosa. 

**Dual-homed**: Se conecta al mismo ISP mediante dos enlaces. Proporciona redundancia y equilibrio de carga. Sin embargo, la organización pierde conectividad a Internet si el ISP experimenta una interrupción. 

**Multihomed**: El cliente se conecta a dos ISP diferentes. Este diseño proporciona una mayor redundancia y permite equilibrar la carga, pero puede ser costoso. 

**Dual-MultiHomed**: Dual-MultiHomed es la topología más resistente de las cuatro mostradas. El cliente se conecta con vínculos redundantes a varios ISP. Esta topología proporciona la mayor redundancia posible. Es la opción más cara de los cuatro. 


###  Comparación de soluciones de banda ancha

Todas las soluciones de banda ancha tienen ventajas y desventajas. Si hay varias soluciones de banda ancha disponibles, se debe llevar a cabo un análisis de costos y beneficios para determinar cuál es la mejor solución.

Entre otros de los factores que se deben considerar se incluyen los siguientes:

- Cable- Ancho de banda es compartido por muchos usuarios. Por lo tanto, el ancho de banda se comparte entre diversos usuarios; las velocidades de datos ascendentes suelen ser lentas durante las horas de alto uso en áreas con sobresubscripción.
- DSL- El ancho de banda es limitado y se ve afectado por la distancia. La tasa de carga es proporcionalmente menor en comparación con la tasa de descarga. 
- Fibra hasta el hogar- Requiere la instalación de la fibra directamente en el hogar.
- Datos móviles- La cobertura a menudo representa un problema; incluso dentro de una SOHO, en donde el ancho de banda es relativamente limitado.
- Wi-Fi Municipal- la mayoría de las municipalidades no cuentan con una red de malla implementada. Si está disponible y en rango, entonces es una opción viable. 
- Satélite - Es costoso, tiene una capacidad limitada por suscriptor. Normalmente se utiliza cuando no hay otra opción disponible. 









