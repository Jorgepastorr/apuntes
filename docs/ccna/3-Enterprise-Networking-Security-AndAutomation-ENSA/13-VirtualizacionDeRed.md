# Virtualización de Red

## Computación en la Nube

### Computación en la nube

La computación en la nube permite abordar una variedad de problemas de administración de datos:

- Permite el acceso a los datos de organización en cualquier momento y lugar.
- Optimiza las operaciones de TI de la organización, suscribiendo únicamente a los servicios necesarios.
- Elimina o reduce la necesidad de equipos, mantenimiento y administración de TI en las instalaciones.
- Reduce el costo de equipos y energía, los requisitos físicos del sistema y las necesidades de capacitación del personal.
- Permite respuestas rápidas a los crecientes requisitos de volumen de datos.

### Servicios en la nube

Los tres servicios principales de computación en la nube definidos por el Instituto Nacional de Normas y Tecnología (NIST) de los Estados Unidos en la Publicación especial 800-145 son:

- **Software como un Servicio (SaaS):** El proveedor de la nube es responsable del acceso a los servicios, que se proporcionan por Internet.
- **Plataforma como un Servicio (PaaS):** El proveedor de la nube es responsable del acceso a las herramientas y los servicios de desarrollo utilizados para distribuir las aplicaciones. 
- **Infraestructura como un Servicio (IaaS):** El proveedor de la nube es responsable del acceso a los equipos de la red, los servicios de red virtualizados y el soporte de infraestructura de la red.

Los proveedores de servicios en la nube han extendido este modelo y también proporcionan asistencia de TI para cada uno de los servicios de computación en la nube (ITaaS). Para las empresas, ITaaS puede ampliar la capacidad de la red, sin requerir inversiones en nueva infraestructura, capacitación de personal, ni licencias de software nuevas.

### Computación en la nube

Los cuatro modelos principales en la nube son:

**Nubes públicas**: Las aplicaciones basadas en la nube y los servicios que se ofrecen en una nube pública están a disposición de la población en general. 

**Nubes privadas**: Las aplicaciones y los servicios basados en una nube privada que se ofrecen en una nube privada están destinados a una organización o una entidad específica, como el gobierno. 

**Nubes híbridas**: Una nube híbrida consta de dos o más nubes (por ejemplo, una parte privada y otra parte pública); donde cada una de las partes sigue siendo un objeto separado, pero ambas están conectadas a través de una única arquitectura.

**Nubes comunitarias**: Una nube comunitaria se crea para el uso exclusivo de una comunidad específica. Las diferencias entre nubes públicas y las comunitarias son las necesidades funcionales que han sido personalizadas para la comunidad. Por ejemplo, las organizaciones de servicios de salud deben cumplir las políticas y leyes (por ejemplo, la HIPAA) que requieren una autenticación y una confidencialidad especiales.

### Computación en la Nube versus Centro de Datos

A continuación se brindan las definiciones correctas de "centro de datos" y "computación en la nube":

- Centro de datos: Habitualmente es una instalación de procesamiento y almacenamiento de datos que es ejecutada por un departamento de TI interno o arrendado fuera de las instalaciones. Por lo general, la creación y el mantenimiento de centros de datos son muy costosos. 
- Computación en la nube: Habitualmente es un servicio fuera de las instalaciones que ofrece acceso a solicitud de un grupo y donde son compartidos recursos de computación, los mismos son configurables. Estos recursos se pueden aprovisionar y liberar rápidamente con un esfuerzo mínimo de administración.

Los centros de datos son las instalaciones físicas que proporcionan las necesidades informáticas, de red y de almacenamiento de los servicios de cloud computing. Los proveedores de servicios en la nube usan los centros de datos para alojar los servicios en la nube y los recursos basados en la nube.

## Virtualización

### Computación en la nube y virtualización

Los términos "computación en la nube" y "virtualización" suelen usarse de manera intercambiable; no obstante, significan dos cosas distintas. La virtualización es la base de la computación en la nube. Sin esta base, la computación en la nube que se implementa masivamente no sería posible.

La virtualización separa el sistema operativo del hardware. Varios proveedores ofrecen servicios virtuales en la nube que permiten aprovisionar servidores de manera dinámica según sea necesario. Estas instancias virtualizadas de los servidores se crean a pedido. 

### Ventajas de la virtualización de servidores

Una de las ventajas más importantes de la virtualización es un menor costo total:

- Se requieren menos equipos
- Se consume menos energía 
- Se requiere menos espacio 

Estos son los beneficios adicionales de la virtualización:

- Facilita la creacion de prototipos
- Provisionamiento más rápido de servidores
- Incremento del tiempo de actividad del servidor 
- Mejor recuperación tras desastres
- Soporte heredado (Legacy)

### Capas de abstracción

Un sistema informático consta de las siguientes capas de abstracción: aplicaciones, SO, firmware y hardware.

En cada una de estas capas de abstracción, se utiliza algún tipo de código de programación como interfaz entre la capa inferior y la capa superior. 

Un hypervisor se instala entre el firmware y el OS. El hypervisor puede admitir varias instancias de SO.

### Hypervisores de Tipo 2

Un hypervisor, tipo 2, es un software que crea y ejecuta instancias de VM. La computadora, en la que un hypervisor está ejecutando una o más VM, es un host. Un hypervisor de tipo 2 también se denomina alojado (hosted hypervisor). 

Una gran ventaja de el hypervisor de tipo 2 es que el software de consola de administración no es necesario.

## Infraestructura de red virtual

El hypervisor de tipo 1 también se denomina  infraestructura física (bare metal), porque el hypervisor está instalado directamente en el hardware. Generalmente este tipo de hypervisor se instala en los servidores empresariales y los dispositivos de redes para centros de datos.

### Instalación de una VM en un Hypervisor

El hypervisor de tipo 1 requiere una “consola de administración” para administrarlo. El software de administración se utiliza para administrar varios servidores con el mismo hypervisor. La consola de administración puede consolidar los servidores automáticamente y encender o apagar los servidores, según sea necesario.

La consola de administración proporciona la recuperación ante las fallas de hardware. Si falla un componente del servidor, la consola de administración mueve la VM a otro servidor automáticamente y sin inconvenientes. Cisco UCS Manager controla varios servidores y administra los recursos de miles de VM.

Algunas consolas de administración también permiten la sobre-asignación. La sobre-asignación se produce cuando se instalan varias instancias de SO, pero su asignación de memoria excede la cantidad total de memoria que tiene un servidor. Este tipo de asignación excesiva es habitual porque las cuatro instancias de SO requieren todo el recurso.

### La Complejidad de la Virtualización de la Red

La virtualización del servidor oculta los recursos del servidor. Esta práctica puede crear problemas si el centro de datos está utilizando las arquitecturas de red tradicionales.

Sin embargo, las VM son trasladables, y el administrador de la red debe poder agregar, descartar y cambiar los recursos y los de la red, para soportar esta característica. Este proceso sería manual y llevaría mucho tiempo con los switches de red tradicionales.

El tráfico dinámico en constante cambio requiere un enfoque flexible para la administración de recursos de red. Las infraestructuras de red existentes pueden responder a los requisitos cambiantes relacionados con la administración de los flujos de tráfico utilizando las configuraciones de calidad de servicio (QoS) y de ajustes de nivel de seguridad para los flujos individuales. Sin embargo, en empresas grandes que utilizan equipos de varios proveedores, cada vez que se activa una nueva VM, la reconfiguración necesaria puede llevar mucho tiempo.

La infraestructura de red también puede verse beneficiada gracias a la virtualización. Funciones de Red que pueden ser virtualizadas. Cada dispositivo de red se puede segmentar en varios dispositivos virtuales, los cuales funcionan como dispositivos independientes. Entre los ejemplos se incluyen subinterfaces, interfaces virtuales, VLAN y tablas de enrutamiento. El enrutamiento virtualizado se denomina enrutamiento y reenvío virtuales (VRF).


## Redes definidas por software

### Plano de control y plano de datos

Un dispositivo de red contiene los siguientes planos:

- **Plano de control**  Suele considerarse el cerebro del dispositivo. Se utiliza para tomar decisiones de reenvío. El plano de control contiene los mecanismos de reenvío de ruta de Capa 2 y Capa 3, como las tablas de vecinos de protocolo de routing y las tablas de topología, las tablas de routing IPv4 e IPv6, STP, y la tabla ARP. La información que se envía al plano de control es procesada por la CPU.

- **Plano de datos**  También conocido como plano de reenvío, este plano suele ser la estructura de switch que conecta lo varios puertos de red de un dispositivo. El plano de datos de cada dispositivo se utiliza para reenviar los flujos de tráfico. Los routers y los switches utilizan la información del plano de control para reenviar el tráfico entrante desde la interfaz de egreso correspondiente. Por lo general, la información del plano de datos es procesada por un procesador especial del plano de datos, sin que se involucre a la CPU.

CEF es una tecnología de switching de IP de capa 3 que permite que el reenvío de los paquetes ocurra en el plano de datos sin que se consulte el plano de control. 

SDN consiste básicamente en la separación del plano de control y el plano de datos. La función del plano de control es eliminada de cada dispositivo, y la misma es realizada desde un controlador central. El controlador centralizado comunica las funciones del plano de control a cada dispositivo. Cada dispositivo ahora puede enfocarse en el envío de datos mientras el controlador centralizado administra el flujo de datos, mejora la seguridad y proporciona otros servicios.

El plano de administración se utiliza para administrar un dispositivo a través de su conexión a la red. 

Los administradores de red utilizan aplicaciones como Secure Shell (SSH), Trivial File Transfer Protocol (TFTP), Secure FTP y Secure Hypertext Transfer Protocol (HTTPS) para acceder al plano de administración y configurar un dispositivo. 

El plano de administración es la forma en que ha accedido y configurado los dispositivos en sus estudios de redes. Además, protocolos como Simple Network Management Protocol (SNMP), utilizan el plano de administración.

### SDN

Se han desarrollado dos arquitecturas de red principales para admitir la virtualización de la red:

Redes definidas por software (SDN) : una arquitectura de red que virtualiza la red, ofreciendo un nuevo enfoque para la administración y administración de redes que busca simplificar y optimizar el proceso de administración. 

Infraestructura centrada en aplicaciones (ACI) de Cisco: Solución de hardware diseñada específicamente para integrar la computación en la nube con la administración de centros de datos.

### Tecnologías de Virtualización 

Los componentes de SDN pueden incluir los siguientes:

**OpenFlow**: Este enfoque se desarrolló en la Universidad de Stanford para administrar el tráfico entre routers, switches, puntos de acceso inalámbrico y un controlador. El protocolo OpenFlow es un elemento básico en el desarrollo de soluciones de SDN. 

**OpenStack**: Este enfoque es una plataforma de virtualización y coordinación disponible para armar entornos escalables en la nube y proporcionar una solución de infraestructura como servicio (IaaS). OpenStack se usa frecuentemente en conjunto con Cisco ACI. La organización en la red es el proceso para automatizar el aprovisionamiento de los componentes de red como servidores, almacenamiento, switches, routers y aplicaciones. 

**Otros componentes**: otros componentes incluyen la interfaz a Routing System (I2RS), la interconexión transparente de varios enlaces (TRILL), Cisco FabricPath (FP) e IEEE 802.1aq Shortest Path Bridging (SPB).

### Arquitectura de SDN

En un router o una arquitectura de switches tradicionales, el plano de control y las funciones del plano de datos se producen en el mismo dispositivo. Las decisiones de routing y el envío de paquetes son responsabilidad del sistema operativo del dispositivo. En SDN, la administración del plano de control se mueve a un controlador SDN centralizado. 

### Arquitectura tradicional y de SDN 

El controlador de SDN es una entidad lógica que permite que los administradores de red administren y determinen cómo el plano de datos de switches y routers debe administrar el tráfico de red. Coordina, media y facilita la comunicación entre las aplicaciones y los elementos de red.

El marco SDN completo se muestra en la figura. Observe el uso de interfaces de programación de aplicaciones (API) Una API es un conjunto de solicitudes estandarizadas que definen la forma adecuada para que una aplicación solicite servicios de otra aplicación. 

El controlador de SDN usa los API ascendentes para comunicarse con las aplicaciones ascendentes, ayudando al administrador a configurar servicios. El controlador de SDN también utiliza interfaces API descendentes para definir el comportamiento de los switches y routers virtuales descendentes. OpenFlow es la API original descendente ampliamente implementada.

## Controladores

### Controlador de SDN y operaciones

El controlador SDN define los flujos de datos entre el plano de control centralizado y los planos de datos en routers y switches individuales.

Cada flujo que viaja por la red debe primero obtener permiso del controlador SDN, que verifica que la comunicación esté permitida según la política de red.

El controlador realiza todas las funciones complejas. El controlador completa las tablas de flujo. Los switches administran las tablas de flujo. 

Dentro de cada switch, se utiliza una serie de tablas implementadas en el hardware o el firmware para administrar flujos de paquetes a través del switch. Para el switch, un flujo es una secuencia de paquetes que coincide con una entrada específica en una tabla de flujo.

Los tres tipos de tablas que se muestran en la figura anterior son los siguientes:

- Tabla de flujo - Esta tabla asigna los paquetes entrantes a un flujo determinado y especifica las funciones que deben realizarse en los paquetes. Puede haber tablas de flujo múltiples que funcionan a modo de canalización.
- Tabla de grupos - Una tabla de flujo puede dirigir un flujo a una tabla de grupos, que puede alimentar una variedad de acciones que afecten a uno o más flujos.
- Tabla de medidor - Esta tabla activa una variedad de acciones relacionadas con el funcionamiento en un flujo.


### Vídeo de controladores - Cisco ACI

Muy pocas organizaciones tienen realmente el deseo o las habilidades para programar la red utilizando las herramientas de SDN. Sin embargo, la mayoría de las organizaciones desea automatizar la red, acelerar la implementación de aplicaciones y alinear sus infraestructuras de TI para cumplir mejor con los requisitos empresariales. Cisco desarrolló la Infraestructura centrada en aplicaciones (ACI) para alcanzar los siguientes objetivos de maneras más avanzadas y más innovadoras que antes los enfoques de SDN.

Cisco ACI es una solución de hardware diseñada específicamente para integrar la computación en la nube con la administración de centros de datos. En un nivel alto, el elemento de políticas de la red se elimina del plano de datos. Esto simplifica el modo en que se crean redes del centro de datos.

### Componentes principales de ACI

Estos son los tres componentes principales de la arquitectura de ACI:

- Perfil de aplicación de red (ANP) - Un ANP es una colección de grupos de terminales (EPG) con sus conexiones y las políticas que definen dichas conexiones. 
- Controlador de infraestructura de política de aplicación (APIC) - El APIC es un controlador centralizado de software que administra y opera una estructura agrupada ACI escalable. Está diseñado para la programabilidad y la administración centralizada. Traduce las políticas de las aplicaciones a la programación de la red.
- Switches de la serie 9000 de Cisco Nexus - Estos switches proporcionan una estructura de switching con reconocimiento de aplicaciones y operan con un APIC para administrar la infraestructura virtual y física de la red.

El APIC se ubica entre el APN y la infraestructura de red habilitada con ACI. El APIC traduce los requisitos de aplicaciones a una configuración de red para cumplir con esas necesidades.

### Topología Spine-Leaf

La estructura Cisco ACI está compuesta por la APIC y los switches de la serie 9000 de Cisco Nexus mediante topología de nodo principal y secundario de dos niveles, como se muestra en la figura. Los switches de nodo secundario siempre se adjuntan a los nodos principales, pero nunca se adjuntan entre sí. De manera similar, los switches principales solo se adjuntan a la hoja y a los switches de núcleo (no se muestran). En esta topología de dos niveles, todo está a un salto de todo lo demás.

En comparación con una SDN, el controlador de APIC no manipula la ruta de datos directamente. En cambio, el APIC centraliza la definición de políticas y programas a los que cambia el nodo secundario para reenviar tráfico según las políticas definidas.

### Tipos de SDN

El Módulo empresarial del Controlador de infraestructura de política de aplicación (APIC-EM) de Cisco amplía las capacidades de ACI para las instalaciones empresariales y de campus. Para entender mejor APIC-EM, es útil obtener una perspectiva más amplia de los tres tipos de SDN:

**SDN basada en dispositivos**: Los dispositivos son programables mediante aplicaciones que se ejecutan en el dispositivo mismo o en un servidor en la red, como se muestra en la figura.

**SDN basado en controlador**: Este tipo de SDN usa un controlador centralizado que tiene conocimiento de todos los dispositivos de la red, como se ve en la figura. Las aplicaciones pueden interactuar con el controlador responsable de administrar los dispositivos y de manipular los flujos de tráfico en la red. El controlador SDN Cisco Open es una distribución comercial de Open Daylight.

**SDN basada en políticas**: Este tipo de SDN es parecido al SDN basado en controlador, ya que un controlador centralizado tiene una vista de todos los dispositivos de la red, como se ve en la figura El SDN basado en políticas incluye una capa de políticas adicional que funciona a un nivel de abstracción mayor. Usa aplicaciones incorporadas que automatizan las tareas de configuración avanzadas mediante un flujo de trabajo guiado y una GUI fácil de usar. No se necesitan conocimientos de programación. Cisco APIC-EM es un ejemplo de este tipo de SDN.

### Funciones de APIC-EM 

Cisco APIC-EM proporciona una interfaz única para la administración de red que incluye:

- Descubrir y acceder a inventarios de dispositivos y hosts.
- Visualización de la topología (como se muestra en la figura).
- Rastreo de una ruta entre los puntos finales.
- Establecer directivas.
