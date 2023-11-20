## Componentes de Red

### Dispositivos finales

Son los dispositivos a los que llegra la inmformacion como ultima instancia, hosts, imprersonas, servidores, ...

### Dispositivos intermedios

Un dispositivo intermediario interconecta dispositivos finales. Los ejemplos incluyen switches, puntos de acceso inalámbrico, routers y firewalls.

La gestión de los datos a medida que fluyen a través de una red también es la función de un dispositivo intermediario, que incluye:

- Volver a generar y transmitir las señales de datos.
- Mantener información sobre qué vías existen en la red.
- Notificar a otros dispositivos los errores y las fallas de comunicación.

### Red punto a punto

Son redes que conecta 2 dispositivos directamente.

- Ventajas: facil de configurar, menos complejo, reduce costos, se utiliza pra tareas simples
- Desventajas: La administración no esta centralizada, no son escalables, rendimientio mas lento.

### Medios de red

La comunicación a través de una red se efectúa a través de un medio que permite que un mensaje viaje desde el origen hacia el destino

| Tipos de Medios | descricion |
|:---:|:---:|
| Alambre de metal (cobre) | Utiliza impulsos electricos |
| fibra de vidrio o plastico ( cable de fibra optica) | utiliza impulsos de luz |
| Transmision inalambrica | ondas electromagnéticas |


## Representaciones de red y topologías

### Diagramas de tipología

Los diagramas de topología física ilustran la ubicación física de los dispositivos intermedios y la instalación de cables.

Los diagramas de topología lógica ilustran dispositivos, puertos y el esquema de direccionamiento de la red.

## Tipos comunes de redes

Los dos tipos de redes más comunes son los siguientes: 

- Red de área local (LAN): Una LAN es una infraestructura de la red que abarca un área geográfica pequeña.
- Red de área amplia (WAN): Una WAN es una infraestructura de la red que abarca un área geográfica extensa.

### Internet

Internet es una colección mundial de LAN y WAN interconectadas. 

- Las redes LAN se conectan entre sí mediante redes WAN.
- Las WAN pueden usar cables de cobre, cables de fibra óptica y transmisiones inalámbricas.

Internet no pertenece a una persona o un grupo. Los siguientes grupos se desarrollaron para ayudar a mantener la estructura en Internet:

- IETF
- ICANN
- IAB

### Intranet y Extranet

Una intranet es una colección privada de LAN y WAN internas de una organización que debe ser accesible solo para los miembros de la organización u otros con autorización.

Una organización puede utilizar una red extranet para proporcionar un acceso seguro a su red por parte de personas que trabajan para otra organización y que necesitan tener acceso a sus datos en su red.

## Conexiones de internet

Hay muchas formas de conectar usuarios y organizaciones a Internet, Los servicios más utilizados para los usuarios domésticos y las oficinas pequeñas incluyen banda ancha por cable, banda ancha por línea de suscriptor digital (DSL), redes WAN inalámbricas y servicios móviles.

| Conexión | Descripción |
|:---:|:---|
| Cable | Internet de alto ancho de banda, ofrecido por proveedores de servicios de television|
| DSL | Ancho de banda alto associado a traves de una línea telefonica |
| red celular | red de telefonia celular par conectarse a internet |
| satelite | Gran beneficio para zonas rurales  sin proveedores de servicios de internet |
| telefono de marcación | opción económica de bajo ancho de banda que utiliza un módem |

### Conexiones en negocios

- **Línea dedicada arrendada**: estos son circuitos reservados dentro de la red del proveedor de servicios que conectan oficionas distantes con redes privadas de voz y/o datos
- **WAN Ethernet**: extiende la tecnología de acceso LAN a la WAN
- **DSL**: Business DSL está disponible en  varios formatos, SDSL simetrica.
- **Satélite**: Cuando la cableada no esta dsponible

### Red convergente

Antes de las redes convergentes, una organización habría sido cableada por separado para el teléfono, el vídeo y los datos. Cada una de estas redes usaría diferentes tecnologías para transportar la señal. 

Las redes convergentes pueden entregar datos, voz y video a través de la misma infraestructura de red. La infraestructura de la red utiliza el mismo conjunto de reglas y normas.

## Redes confiables

Existen cuatro características básicas que las arquitecturas subyacentes deben abordar para cumplir con las expectativas del usuario:

- Tolerancia a fallas (redundancia)
- Escalabilidad
- Calidad de servicio (QoS): priorizar datos de video.
- Seguridad

### Tolerancia a fallas

Una red con tolerancia a fallas disminuye el impacto de una falla al limitar la cantidad de dispositivos afectados. Para la tolerancia a fallas, se necesitan varias rutas.

- La conmutación por paquetes divide el tráfico en paquetes que se enrutan a través de una red. 
- En teoría, cada paquete puede tomar una ruta diferente hacia el destino.

### Calidad de servicio

Las transmisiones de voz y vídeo en vivo requieren mayores expectativas para los servicios que se proporcionan. 

- La calidad de servicio (QoS) es el principal mecanismo que se utiliza para garantizar la entrega confiable de contenido a todos los usuarios. 
- Con la implementación de una política de QoS, el router puede administrar más fácilmente el flujo del tráfico de voz y de datos.

### Seguridad

Existen dos tipos principales de seguridad de la red que se deben abordar:  

- Seguridad de la infraestructura de la red
  - Seguridad física de los dispositivos de red
  - Prevenir el acceso no autorizado a los dispositivos
- Seguridad de la información
  - Protección de la información o de los datos transmitidos a través de la red

Tres objetivos de seguridad de la red:

- Confidencialidad: solo los destinatarios deseados pueden leer los datos
- Integridad: garantía de que los datos no se alteraron durante la transmisión
- Disponibilidad: garantía del acceso confiable y oportuno a los datos por parte de los usuarios autorizados

## Tendencias de red

La función de la red se debe ajustar y transformar continuamente para poder mantenerse al día con las nuevas tecnologías y los nuevos dispositivos para usuarios finales, ya que se lanzan al mercado de manera constante. 

Muchas nuevas tendencias de red que afectarán a organizaciones y consumidores:

- Traiga su propio dispositivo (BYOD)
- Colaboración en línea
- Comunicaciones de video
- Computación en la nube


### traiga su propio dispositivo

Trae tu propio dispositivo (BYOD) permite a los usuarios usar sus propios dispositivos, dándoles más oportunidades y una mayor flexibilidad. BYOD permite a los usuarios finales tener la libertad de utilizar herramientas personales para comunicarse y acceder a información

BYOD significa que se puede usar cualquier dispositivo, de cualquier persona, en cualquier lugar.

### Compuación en la nube

Cuatro tipos de nubes:

- Nubes públicas
  - Disponible para el público en general a través de un modelo de pago por uso o de forma gratuita.
- Nubes privadas
  - Destinado a una organización o entidad específica como el gobierno.
- Nubes híbridas
  - Están compuestas por dos o más tipos de nubes; por ejemplo, mitad personalizada y mitad pública. 
  - Cada parte sigue siendo un objeto distinto, pero ambas están conectadas con la misma arquitectura.
- Nubes personalizadas
  - Creado para satisfacer las necesidades de una industria específica, como la atención médica o los medios de comunicación. 
  - Puede ser privado o público.

### Banda ancha inalambrica

Además de DSL y cable, la conexión inalámbrica es otra opción utilizada para conectar hogares y pequeñas empresas a Internet. 

El proveedor de servicios de Internet inalámbrico (WISP), que se encuentra con mayor frecuencia en entornos rurales, es un ISP que conecta a los suscriptores a zonas activas o puntos de acceso designados. 

La banda ancha inalámbrica es otra solución para el hogar y las pequeñas empresas.

Utiliza la misma tecnología de red celular que utiliza un Smartphone.

Se instala una antena fuera del hogar, que proporciona conectividad inalámbrica o por cable a los dispositivos en el hogar.


