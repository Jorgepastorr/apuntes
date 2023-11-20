# Fundamentos de seguridad de red

## Amenazas y vulnerabilidades de seguridad

Una vez que el actor de la amenaza obtiene acceso a la red, pueden surgir cuatro tipos de amenazas:

- Robo de información
- Pérdida y manipulación de datos.
- Robo de identidad
- Interrupción del servicio

### Tipos de vulnerabilidades

La vulnerabilidad es el grado de debilidad en una red o un dispositivo. Algún grado de vulnerabilidad es inherente a los enrutadores, conmutadores, equipos de escritorio, servidores e incluso dispositivos de seguridad.

Existen tres vulnerabilidades o debilidades principales:

- Las vulnerabilidades tecnológicas pueden incluir debilidades del protocolo TCP/IP, debilidades del sistema operativo y debilidades del equipo de red.
- Las vulnerabilidades de configuración pueden incluir cuentas de usuario no seguras, cuentas de sistema con contraseñas fáciles de adivinar, servicios de Internet mal configurados, configuraciones predeterminadas no seguras y equipos de red mal configurados.
- Las vulnerabilidades de política de seguridad pueden incluir la falta de una política de seguridad escrita, la política, la falta de continuidad de autenticación, los controles de acceso lógico no aplicados, la instalación de software y hardware y los cambios que no siguen la política, y un plan de recuperación ante desastres inexistente.

### Seguridad física

Si los recursos de la red pueden verse físicamente comprometidos, un actor de amenazas puede negar el uso de los recursos de la red. Las cuatro clases de amenazas físicas son las siguientes:

- Amenazas de hardware - Esto incluye daños físicos a servidores, routers, switches, planta de cableado y estaciones de trabajo.
- Amenazas Ambientales - Esto incluye temperaturas extremas (demasiado calor o demasiado frío) o humedad extrema (demasiado húmedo o demasiado seco).
- Amenazas eléctricas - Esto incluye picos de voltaje, voltaje de suministro insuficiente (caídas de voltaje), energía no condicionada (ruido) y pérdida total de energía.
- Amenazas de mantenimiento - Esto incluye un manejo deficiente de los componentes eléctricos clave (descarga electrostática), falta de repuestos críticos, cableado deficiente y etiquetado deficiente.

## Ataques de red

### Tipos de malware

Virus: Un virus informático es un tipo de malware que se propaga insertando una copia de sí mismo y formando parte de otro programa. Se propaga de una computadora a otra, dejando infecciones a medida que viaja. 

Gusanos: Los gusanos informáticos son similares a los virus en que replican copias funcionales de sí mismos y pueden causar el mismo tipo de daño. A diferencia de los virus, que requieren la propagación de un archivo host infectado, los gusanos son software independiente y no requieren de un programa host ni de la ayuda humana para propagarse. 

Trojan Horses: Es un software dañino que parece legítimo. A diferencia de los virus y gusanos, los caballos de Troya no se reproducen al infectar otros archivos. Se autoreplican. Los caballos de Troya deben extenderse a través de la interacción del usuario, como abrir un archivo adjunto de correo electrónico o descargar y ejecutar un archivo de Internet.

### Ataques de reconocimiento

Además de los ataques de código malintencionado, es posible que las redes sean presa de diversos  ataques de red. Los ataques de red pueden clasificarse en tres categorías principales:

- Ataques de reconocimiento: El descubrimiento y el mapeo de sistemas, servicios o vulnerabilidades.
- Ataques de acceso: La manipulación no autorizada de datos, acceso al sistema o privilegios de usuario.
- Denegación de servicio: La desactivación o corrupción de redes, sistemas o servicios.

### Ataques de acceso

Los ataques de acceso explotan las vulnerabilidades conocidas de los servicios de autenticación, los servicios FTP y los servicios Web para obtener acceso a las cuentas Web, a las bases de datos confidenciales y demás información confidencial. 

Los ataques de acceso se pueden clasificar en cuatro categorías: 

- Ataques de contraseña: implementados usando fuerza bruta, troyanos y rastreadores de paquetes
- Explotación de confianza: Un actor de amenazas utiliza privilegios no autorizados para obtener acceso a un sistema, posiblemente comprometiendo el objetivo.
- Redireccionamiento de puertos: Un actor de amenaza utiliza un sistema comprometido como base para ataques contra otros objetivos. Por ejemplo, un actor de amenaza que usa SSH (puerto 22) para conectarse a un host A comprometido. El host B confía en el host A y, por lo tanto, el actor de amenaza puede usar Telnet (puerto 23) para acceder a él.
- Man-in-the middle: El agente de la amenaza se coloca entre dos entidades legítimas para leer o modificar los datos que pasan entre las dos partes.

### Ataques de denegación de servicio

Los ataques de denegación de servicio (DoS) son la forma de ataque más publicitada y una de las más difíciles de eliminar. Sin embargo, debido a su facilidad de implementación y daño potencialmente significativo, los ataques DoS merecen especial atención por parte de los administradores de seguridad.

Los ataques DoS tienen muchas formas. Fundamentalmente, evitan que las personas autorizadas utilicen un servicio mediante el consumo de recursos del sistema. Para prevenir los ataques de DoS es importante estar al día con las actualizaciones de seguridad más recientes de los sistemas operativos y las aplicaciones.

Los ataques de DoS son un riesgo importante porque pueden interrumpir fácilmente la comunicación y causar una pérdida significativa de tiempo y dinero. Estos ataques son relativamente simples de ejecutar, incluso si lo hace un agente de amenaza inexperto.

Un DDoS es similar a un ataque DoS, pero se origina en múltiples fuentes coordinadas. Por ejemplo, un agente de amenazas construye una red de hosts infectados, conocidos como zombies. A una red de zombies se le conoce como botnet. El actor de amenazas utiliza un programa de comando y control (CNC) para instruir a la botnet de zombies para llevar a cabo un ataque DDoS.


## Mitigaciones para ataques de red

La mayoría de las organizaciones emplean un enfoque de defensa en profundidad (también conocido como enfoque en capas) para la seguridad. Esto requiere una combinación de dispositivos y servicios de red que funcionen en conjunto.


Se implementan varios dispositivos y servicios de seguridad para proteger a los usuarios y activos de una organización contra las amenazas de TCP / IP:

- VPN
- ASA Firewall
- IPS
- ESA/WSA
- AAA Server

### Autenticar, Autorizar y Contabilizar  (AAA)

Los servicios de seguridad de red de autenticación, autorización y contabilización (AAA o "triple A") proporcionan el marco principal para configurar el control de acceso en dispositivos de red.

AAA es una forma de controlar quién tiene permiso para acceder a una red (autenticar), qué acciones realizan mientras acceden a la red (autorizar) y hacer un registro de lo que se hizo mientras están allí (contabilizar).

### Firewall


Los firewalls de red residen entre dos o más redes, controlan el tráfico entre ellas y evitan el acceso no autorizado.

Un firewall podría brindar a usuarios externos acceso controlado a servicios específicos. Por ejemplo, los servidores accesibles para usuarios externos generalmente se encuentran en una red especial denominada zona desmilitarizada (DMZ). La DMZ permite a un administrador de red aplicar políticas específicas para los hosts conectados a esa red.

Los productos de firewall vienen empaquetados en varias formas. Estos productos utilizan diferentes técnicas para determinar qué se permitirá o negará el acceso a una red. Entre otros, se incluyen:

- Filtrado de paquetes: Evita o permite el acceso basado en direcciones IP o MAC.
- Filtrado de aplicaciones: Evita o permite el acceso a tipos de aplicaciones específicos según los números de puerto.
- Filtrado de URL: Evita o permite el acceso a sitios web basados en URL o palabras clave específicas.
- Inspección de paquetes con estado (SPI): Los paquetes entrantes deben ser respuestas legítimas a las solicitudes de los hosts internos. Los paquetes no solicitados son bloqueados, a menos que se permitan específicamente. SPI también puede incluir la capacidad de reconocer y filtrar tipos específicos de ataques, como la denegación de servicio (DoS).

