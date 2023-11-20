# Administración de redes

## Detección de dispositivos con CDP

### Descripción general de CDP

CDP es un protocolo de Capa 2 propiedad de Cisco que se utiliza para recopilar información sobre dispositivos Cisco que comparten el mismo enlace de datos. El CDP es independiente de los medios y protocolos y se ejecuta en todos los dispositivos Cisco, como routers, switches y servidores de acceso.

El dispositivo envía mensajes periódicos del CDP a los dispositivos conectados. Estos mensajes comparten información sobre el tipo de dispositivo que se descubre, el nombre de los dispositivos, y la cantidad y el tipo de interfaces.

### Configuración y verificación del CDP

Para los dispositivos Cisco, el CDP está habilitado de manera predeterminada. Para verificar el estado de CDP y mostrar información sobre CDP, ingrese el comando `show cdp` .

Para deshabilitar CDP en una interfaz específica, ingrese `no cdp enable` en el modo de configuración de la interfaz. El CDP aún se encuentra habilitado en el dispositivo; sin embargo, no se enviarán más mensajes a la interfaz. Para habilitar CDP en la interfaz específica nuevamente, ingrese `cdp enable`.

Para habilitar CDP globalmente para todas las interfaces compatibles en el dispositivo, ingrese `cdp run` en el modo de configuración global. CDP se puede deshabilitar para todas las interfaces en el dispositivo con el comando `no cdp run` en el modo de configuración global.

Utilice el comando `show cdp interface` para mostrar las interfaces que están habilitadas en CDP en el dispositivo. También se muestra el estado de cada interfaz. 

### Detección de dispositivos mediante CDP

Con CDP habilitado en la red, el comando `show cdp neighbors` se puede usar para determinar el diseño de la red, como se muestra en el ejemplo.

La salida muestra que hay otro dispositivo Cisco, S1, conectado a la interfaz G0/0/1 en R1. Además, S1 está conectado a través de su F0/5

    R1# show cdp neighbors 
    Capability Codes: R - Router, T - Trans Bridge, B - Source Route Bridge
                    S - Switch, H - Host, I - IGMP, r - Repeater, P - Phone, 
                    D - Remote, C - CVTA, M - Two-port Mac Relay 

    Device ID Local Intrfce Holdtme Capability Platform Port ID 
    S1 Gig 0/0/1 179 S I WS-C3560- Fas 0/5

El administrador de red utiliza `show cdp neighbors detail` para descubrir la dirección IP de S1. Como se muestra en la salida, la dirección de S1 es 192.168.1.2.

    R1# show cdp neighbors detail 
    ------------------------- 
    Device ID: S1 
    Entry address(es): 
    IP address: 192.168.1.2 
    Platform: cisco WS-C3560-24TS, Capabilities: Switch IGMP
    Interface: GigabitEthernet0/0/1, Port ID (outgoing port): FastEthernet0/5
    Holdtime : 136 sec 

    (output omitted)


## Detección de dispositivos con LLDP

### Descripción general de LLDP

El protocolo de detección de capa de enlace (LLDP) es un protocolo de detección de vecinos similar al CDP que es independiente del proveedor. El LLDP funciona con los dispositivos de red, como routers, switches, y puntos de acceso inalámbrico LAN. Este protocolo anuncia su identidad y capacidades a otros dispositivos y recibe la información de un dispositivo de capa 2 conectado físicamente.


### Configuración y verificación del LLDP

LLDP puede estar habilitado por defecto. Para habilitar LLDP a nivel global en un dispositivo de red Cisco, ingrese el comando `lldp run` en el modo de configuración global. Para deshabilitar el LLDP, ingrese el comando `no lldp run` en el modo de configuración global.

LLDP se puede configurar en interfaces específicas. Sin embargo, LLDP debe configurarse por separado para transmitir y recibir paquetes LLDP.

Para verificar que LLDP esté habilitado, ingrese el comando `show lldp` en modo EXEC privilegiado.

    Switch# conf t 
    Enter configuration commands, one per line. End with CNTL/Z. 
    Switch(config)# lldp run 
    Switch(config)# interface gigabitethernet 0/1 
    Switch(config-if)# lldp transmit 
    Switch(config-if)# lldp receive 
    Switch(config-if)# end
    Switch# show lldp 
    Global LLDP Information: 
    Status: ACTIVE 
    LLDP advertisements are sent every 30 seconds 
    LLDP hold time advertised is 120 seconds 
    LLDP interface reinitialisation delay is 2 seconds

### Detección de dispositivos mediante LLDP

Con LLDP habilitado, los vecinos del dispositivo se pueden descubrir mediante el comando `show lldp neighbors` .

    S1# show lldp neighbors 
    Capability codes: 
        (R) Router, (B) Bridge, (T) Telephone, (C) DOCSIS Cable Device 
        (W) WLAN Access Point, (P) Repeater, (S) Station, (O) Other 
    Device ID Local Intf Hold-time Capability Port ID 
    R1 Fa0/5 117 R Gi0/0/1 
    S2 Fa0/1 112 B Fa0/1 
    Total entries displayed: 2

Cuando se necesitan más detalles sobre los vecinos, el comando `show lldp neighbors detail` puede proporcionar información, como la versión del IOS vecino, la dirección IP y la capacidad del dispositivo.


## NTP

### Servicios de Tiempo y Calendario

El reloj del software en un router o un switch se inicia cuando se inicia el sistema. Es la principal fuente de tiempo para el sistema. Es importante sincronizar la hora en todos los dispositivos de la red. Cuando no se sincroniza la hora entre los dispositivos, será imposible determinar el orden de los eventos y la causa de un evento.

Normalmente, la configuración de fecha y hora de un router o switch se puede establecer mediante uno de los dos métodos. Puede configurarse manualmente la fecha y la hora, como se muestra en el ejemplo, o configurar el Protocolo de tiempo de red (NTP).

    R1# clock set 20:36:00 nov 15 2019 

A medida que la red crece, se hace difícil garantizar que todos los dispositivos de infraestructura estén funcionando con tiempo sincronizado utilizando el método manual.

Una mejor solución es configurar el NTP en la red. Este protocolo permite a los routers de la red sincronizar sus configuraciones de hora con un servidor NTP, lo que proporciona configuraciones de hora más consistentes. NTP puede configurarse para sincronizarse con un reloj maestro privado, o puede sincronizarse con un servidor NTP disponible públicamente en Internet. NTP utiliza el puerto 123 de UDP y se documenta en RFC 1305.

### Operación NTP

Las redes NTP utilizan un sistema jerárquico de fuentes horarias. Cada nivel en este sistema jerárquico se denomina estrato. El nivel de estrato se define como la cantidad de saltos desde la fuente autorizada. El tiempo sincronizado se distribuye a través de la red mediante NTP.

El recuento de saltos máximo es 15. El estrato 16, el nivel de estrato inferior, indica que un dispositivo no está sincronizado.


**Stratum 0**: Estas "fuentes de tiempo autorizadas" son dispositivos de cronometraje de alta precisión que se supone son precisos y con poco o ningún retraso asociado con ellos. 

**Stratum 1**: Dispositivos que están directamente conectados a las fuentes de tiempo autorizadas. Actúan como el estándar horario de la red principal.

**Stratum 2 e inferiores**: los servidores del estrato 2 están conectados a los dispositivos del estrato 1 a través de conexiones de red. Los dispositivos de stratum 2, como los clientes NTP, sincronizan su tiempo utilizando los paquetes NTP de los servidores de stratum 1. Podrían también actuar como servidores para dispositivos del stratum 3.

Los servidores en el mismo nivel de Stratum, pueden configurarse para actuar como un par con otros servidores horarios en el mismo nivel de estratos, esto con la finalidad de verificar o respaldar el horario.

### Configuración y verificación del NTP

Antes de configurar NTP en la red, el comando `show clock` muestra la hora actual en el reloj del software. Con la opción de `detail` , observe que la fuente de tiempo es la configuración del usuario. Esto significa que la hora se configuró manualmente con el comando clock .

El `comando ntp server ip-address` se emite en modo de configuración global para configurar 209.165.200.225 como el servidor NTP para R1. Para verificar que la fuente de tiempo esté establecida en NTP, use el comando `show clock detail` . 

Observe que ahora la fuente de tiempo es NTP.

    R1# show clock detail 
    20:55:10 .207 UTC Vie Nov 15 2019 
    Time source is user configuration
    R1# config t
    R1(config)# ntp server 209.165.200.225 
    R1(config)# end 
    R1# show clock detail 
    21:01:34 .563 UTC Vie Nov 15 2019 
    Time source is NTP

Los comandos `show ntp associations` y `show ntp status` se utilizan para verificar que R1 esté sincronizado con el servidor NTP en 209.165.200.225. Observe que el R1 está sincronizado con un servidor NTP de Stratum 1 en 209.165.200.225, que se sincroniza con un reloj GPS. El comando `show ntp status` muestra que R1 ahora es un dispositivo del Stratum 2 que está sincronizado con el servidor NTP en 209.165.220.225.

    R1# show ntp associations
    
    address ref clock st when poll each delay offset disp 
    *~209.165.200.225 .GPS. 		1 61 64 377 0,481 7,480 4,261 
    sys.peer, # selected, + candidate, - outlyer, x falseticker, ~ configured 

    R1# show ntp status 
    Clock is synchronized, stratum 2, reference is 209.165.200.225 
    nominal freq is 250.0000 Hz, actual freq is 249.9995 Hz, precision is 2**19
    (output omitted)

El reloj de S1 está configurado para sincronizarse con R1 con el comando `ntp server` y la configuración se verifica con el comando `show ntp associations` .

La salida del comando `show ntp associations` verifica que el reloj en S1 ahora esté sincronizado con R1 en 192.168.1.1 a través de NTP. Ahora S1 es un dispositivo de Stratum 3, que puede proporcionar el servicio NTP a otros dispositivos en la red, por ejemplo terminales.


## SNMP

SNMP fue desarrollado para permitir a los administradores administrar nodos en una red IP. Permite que los administradores de redes monitoreen y administren el rendimiento de la red, detecten y resuelvan problemas de red y planifiquen el crecimiento de la red.

SNMP es un protocolo de capa de aplicación que proporciona un formato de mensaje para la comunicación entre administradores y agentes. El sistema SNMP consta de tres elementos:

- Administrador de SNMP
- Agentes SNMP (nodo administrado)
- Base de información de administración (MIB)

SNMP define cómo se intercambia la información de administración entre las aplicaciones de administración de red y los agentes de administración. El administrador de SNMP sondea los agentes y consulta la MIB para los agentes de SNMP en el puerto UDP 161. Los agentes de SNMP envían todas las notificaciones de SNMP al administrador de SNMP en el puerto UDP 162.

El administrador de SNMP forma parte de un sistema de administración de red (NMS). El administrador SNMP puede recopilar información de un agente SNMP mediante la acción "GET" y puede cambiar las configuraciones de un agente mediante la acción "SET". Los agentes SNMP pueden reenviar información directamente a un administrador de red mediante el uso de "TRAPS".

El agente de SNMP y MIB se alojan en los dispositivos del cliente de SNMP. Las MIB almacenan datos sobre el dispositivo y estadísticas operativas y deben estar disponibles para los usuarios remotos autenticados. El agente de SNMP es responsable de brindar acceso a la MIB local.


### Operación de SNMP

Los agentes SNMP que residen en dispositivos administrados recopilan y almacenan información sobre el dispositivo y su funcionamiento localmente en la MIB. El administrador de SNMP luego usa el agente SNMP para tener acceso a la información dentro de la MIB.

Existen dos solicitudes principales de administrador de SNMP: get y set. Además de la configuración, un conjunto puede provocar que se produzca una acción, como reiniciar un router.

OperationDescriptionget-request recupera un valor de una variable específica. get-next-request recupera un valor de una variable dentro de una tabla; el administrador SNMP no necesita conocer el nombre exacto de la variable. Una busqueda sequencial es realizada para encontrar la variable dentro de una tabla.get-bulk-request recupera grandes bloques de datos, como varias filas en una tabla, que de otra manera requerirían la transmisión de muchos bloques pequeños de datos. (Sólo funciona con SNMPv2 o posterior.) Get-Response responde a un get-request, get-next-request y set-request enviados por un NMS.set-request almacena un valor en una variable específica.

get-request

- Recupera un valor de una variable específica.

get-next-request

- Recupera un valor de una variable dentro de una tabla; el administrador de SNMP no necesita saber el nombre exacto de la variable. Se realiza una búsqueda secuencial para encontrar la variable necesaria dentro de una tabla.

get-bulk-request

- Recupera grandes bloques de datos, como varias filas en una tabla, que de otra manera requerirían la transmisión de muchos bloques pequeños de datos. (Solo funciona con SNMPv2 o más reciente).

get-response

- Responde a get-request, get-next-request, y set-request enviados por un NMS.

set-request

- Almacena un valor en una variable específica.

El agente SNMP responde a las solicitudes del administrador de SNMP de la siguiente manera:

- Get an MIB variable - el agente de SNMP ejecuta esta función en respuesta a una PDU GetRequest del administrador de red. El agente obtiene el valor de la variable de MIB solicitada y responde al administrador de red con dicho valor.
- Set an MIB variable - el agente SNMP realiza esta función en respuesta a una PDU SetRequest del administrador de red. El agente de SNMP cambia el valor de la variable de MIB al valor especificado por el administrador de red. La respuesta del agente SNMP a una solicitud set incluye la nueva configuración en el dispositivo.

### Traps del agente SNMP

Las traps son mensajes no solicitados que alertan al administrador de SNMP sobre una condición o un evento en la red. Las notificaciones dirigidas a trampas reducen los recursos de la red y del agente al eliminar la necesidad de algunas solicitudes de sondeo SNMP.

La figura ilustra el uso de una trampa SNMP para alertar al administrador de la red que la interfaz G0/0/0 ha fallado. El software de NMS puede enviar un mensaje de texto al administrador de red, mostrar una ventana emergente en el software de NMS o mostrar el ícono del router en color rojo en la GUI de NMS.

### Versiones de SNMP

SNMPv1 - Estándar heredado definido en RFC 1157. Utiliza un método de autenticación simple basado en cadenas de comunidad. No debe utilizarse debido a riesgos de seguridad.

SNMPv2c - Definido en RFC 1901-1908. Utiliza un método de autenticación simple basado en cadenas de comunidad. Proporciona opciones de recuperación masiva, así como mensajes de error más detallados.

SNMPv3 - Definido en RFC 3410-3415. Utiliza la autenticación de nombre de usuario, proporciona protección de datos mediante HMAC-MD5 o HMAC-SHA y el cifrado mediante DES, 3DES o AES.

### Community Strings

SNMPv1 y SNMPv2c usan cadenas de comunidad que controlan el acceso a la MIB. Las cadenas de comunidad son contraseñas de texto no cifrado. Las cadenas de la comunidad de SNMP autentican el acceso a los objetos MIB.

Existen dos tipos de cadenas de comunidad:

- Sólo lectura (ro) - Este tipo proporciona acceso a las variables MIB, pero no permite cambiar estas variables, sólo lectura. Debido a que la seguridad es mínima en la versión 2c, muchas organizaciones usan SNMPv2c en modo de solo lectura.
- Read-write (rw) - Este tipo proporciona acceso de lectura y escritura a todos los objetos en la MIB.

Para ver o establecer variables de MIB, el usuario debe especificar la cadena de comunidad correspondiente para el acceso de lectura o escritura.

### MIB Id. de objeto

La MIB organiza variables de manera jerárquica. Formalmente, la MIB define cada variable como una ID de objeto (OID). Las OID identifican de forma exclusiva los objetos administrados. La MIB organiza las OID según estándares RFC en una jerarquía de OID, que se suele mostrar como un árbol.

El árbol de la MIB para un dispositivo determinado incluye algunas ramas con variables comunes a varios dispositivos de red y algunas ramas con variables específicas de ese dispositivo o proveedor.

Las RFC definen algunas variables públicas comunes. La mayoría de los dispositivos implementan estas variables de MIB. Además, los proveedores de equipos de redes, como Cisco, pueden definir sus propias ramas privadas del árbol para admitir las nuevas variables específicas de sus dispositivos.

### Escenario de sondeo SNMP

SNMP se puede utilizar para observar la utilización de la CPU durante un período de tiempo mediante dispositivos de sondeo. Las estadísticas de la CPU se pueden compilar en el NMS y graficar. Esto crea una línea de base para el administrador de red.

Los datos se recuperan mediante la utilidad `snmpget`, que se emite en NMS. Con la utilidad snmpget, puede recuperar manualmente datos en tiempo real o hacer que el NMS ejecute un informe. Este informe le daría un período de tiempo en el que podría utilizar los datos para obtener el promedio.

### Navegador de objeto SNMP

La utilidad snmpget da una idea de la mecánica básica de cómo funciona SNMP. Sin embargo, trabajar con nombres de variables de MIB largos como 1.3.6.1.4.1.9.2.1.58.0 puede ser problemático para el usuario promedio. Más comúnmente, el personal de operaciones de la red utiliza un producto de administración de red con una GUI fácil de usar, lo que hace que el nombre completo de la variable de datos MIB sea transparente para el usuario.

Cisco SNMP Navigator en el sitio web http://www.cisco.com  permite a un administrador de red investigar detalles sobre un OID en particular.


## Syslog

Syslog utiliza el puerto UDP 514 para enviar mensajes de notificación de eventos a través de redes IP a recopiladores de mensajes de eventos, como se muestra en la figura.

El servicio de registro de syslog proporciona tres funciones principales:

- La capacidad de recopilar información de registro para el control y la solución de problemas
- La capacidad de escoger el tipo de información de registro que se captura
- La capacidad de especificar los destinos de los mensajes de syslog capturados

### Operación Syslog

El protocolo syslog comienza enviando mensajes del sistema y resultados de debug a un proceso de registro local. La configuración de Syslog puede enviar estos mensajes a través de la red a un servidor syslog externo, donde se pueden recuperar sin necesidad de acceder al dispositivo. 

Por otra parte, los mensajes de syslog se pueden enviar a un búfer interno. Los mensajes enviados al búfer interno solo se pueden ver mediante la CLI del dispositivo.

El administrador de red puede especificar que solo se envíen ciertos tipos de mensajes del sistema a varios destinos. Los destinos populares para mensajes de syslog incluyen los siguientes:

- Búfer de registro (RAM dentro de un router o switch)
- Línea de consola
- Línea de terminal
- Servidor de syslog

### Formato de mensaje de Syslog

Los dispositivos de Cisco generan mensajes de syslog como resultado de los eventos de red. Cada mensaje de syslog contiene un nivel de severidad y su origen.

Cuanto más bajos son los números de nivel, más fundamentales son las alarmas de syslog. El nivel de severidad de los mensajes se puede establecer para controlar dónde se muestra cada tipo de mensaje (es decir, en la consola o los otros destinos). La lista completa de niveles de syslog se muestra en la tabla.


| Nombre de la gravedad | Nivel de gravedad | Explicación                       |
| :-------------------- | :---------------- | :-------------------------------- |
| Emergencia            | Nivel 0           | El sistema no se puede usar.      |
| Alerta                | Nivel 1           | Se necesita una acción inmediata. |
| Crítico               | Nivel 2           | Condición crítica.                |
| Error                 | Nivel 3           | Condición de error.               |
| Advertencia           | Nivel 4           | Condición de advertencia.         |
| Notificación          | Nivel 5           | Condición normal pero importante. |
| Informativo           | Nivel 6           | Mensaje informativo.              |
| Depuración            | Nivel 7           | Mensaje de depuración.            |


### Servicios de Syslog 

Además de especificar la gravedad, los mensajes de syslog también contienen información sobre el sistema/proceso que lo origino. Estos últimos, son identificadores de servicios que identifican y categorizan los datos de estado del sistema para informar los mensajes de error y de eventos. Las opciones registro disponibles son específicas del dispositivo de red.

Algunas registros comunes de mensajes de syslog que se informan en los routers con IOS de Cisco incluyen los siguientes:

- IP
- Protocolo OSPF
- Sistema operativo SYS
- Seguridad IP (IPsec)
- IP de interfaz (IF)

### Configurar Syslog Timestamp

De manera predeterminada, los mensajes no tienen marca de hora. Los mensajes deben tener marcas de hora, así cuando se envían a otro destino, como un servidor syslog, haya un registro del momento en el que se generó el mensaje. Use el comando `service timestamps log datetime` para forzar que los eventos registrados muestren la fecha y la hora. 

    R1(config)# service timestamps log datetime 
    R1(config)# interface g0/0/0 
    R1(config-if)# no shutdown 
    *1 de mar 11:52:42: %LINK-3-UPDOWN: Interface GigabitEthernet0/0/0, changed state to down 
    *Mar 1 11:52:45: %LINK-3-UPDOWN: Interface GigabitEthernet0/0/0, changed state to up 
    *Mar 1 11:52:46: %LINEPROTO-5-UPDOWN: Line protocol on Interface GigabitEthernet0/0/0, changed state to up 


## Mantenimiento de routers y switches

### Sistemas de archivos del router

El Sistema de archivos Cisco IOS (IFS) permite al administrador navegar a diferentes directorios y enumerar los archivos en un directorio. El administrador también puede crear subdirectorios en memoria flash o en un disco. Los directorios disponibles dependen del dispositivo.

El ejemplo muestra la salida del comando `show file systems` , que enumera todos los sistemas de archivos disponibles en un router Cisco 4221.

Ya que la memoria flash es el sistema de archivos predeterminado, el comando `dir` enumera el contenido de flash. La última lista es de interés específico. Se trata del nombre del archivo de imagen de Cisco IOS actual, que se ejecuta en la memoria RAM.

Para ver el contenido de NVRAM, debe cambiar el sistema de archivos predeterminado actual mediante el comando `cd` (cambiar directorio), como se muestra en el ejemplo.

El comando actual del directorio de trabajo es `pwd`. Este comando verifica que estamos viendo el directorio NVRAM. Finalmente, el comando dir enumera los contenidos de NVRAM. Si bien se enumeran varios archivos de configuración, el de mayor interés específicamente es el archivo de configuración de inicio.

### Archivo de texto para realizar una copia de seguridad de una configuración

Los archivos de configuración se pueden guardar en un archivo de texto utilizando Tera Term:

1. En el menú Archivo (File menu), haga clic en Log.
2. Elija la ubicación para guardar el archivo. Tera Term comenzará a capturar texto.
3. Después de iniciar la captura, ejecute el comando show running-config o show startup-config en el indicador EXEC privilegiado. El texto que aparece en la ventana del terminal se dirigirá al archivo elegido.
4. Cuando se complete la captura, seleccione Close en la ventana Tera Term: Log.
5. Observe el archivo para verificar que no esté dañado.

### Usar un archivo de texto para restaurar una configuración

Además, es posible que desee agregar enable y configure terminal al comienzo del archivo o entrar en el modo de configuración global antes de pegar la configuración. En lugar de copiar y pegar, una configuración se puede restaurar a partir de un archivo de texto utilizando Tera Term. 

Al usar Tera Term, los pasos son los siguientes:

1. En el menú File (Archivo), haga clic en Send file (Enviar archivo).
2. Ubique el archivo que debe copiar en el dispositivo y haga clic en Open (Abrir).
3. Tera Term pegará el archivo en el dispositivo.

El texto en el archivo se aplicará en forma de comandos en la CLI y pasará a ser la configuración en ejecución en el dispositivo.

### Creación de copias de seguridad y restauración mediante TFTP

Siga estos pasos para realizar una copia de respaldo de la configuración en un servidor TFTP:

1. Introduzca el comando copy running-config tftp .
2. Introduzca la dirección IP del host en el cual se almacenará el archivo de configuración.
3. Introduzca el nombre que se asignará al archivo de configuración.
4. Presione Entrar para confirmar cada elección.

Siga estos pasos para restaurar la configuración en ejecución desde un servidor TFTP:

1. Introduzca el comando copy tftp running-config .
2. Introduzca la dirección IP del host en el que está almacenado el archivo de configuración.
3. Introduzca el nombre que se asignará al archivo de configuración.
4. Presione Enter para confirmar cada elección.


    R1# copy running-config tftp 
    Remote host []? 192.168.10.254 
    Name of the configuration file to write[R1-config]? R1-Jan-2019
    Write file R1-Jan-2019 to 192.168.10.254? [confirm] 
    Writing R1-Jan-2019 !!!!!! [OK

### USB para realizar copias de seguridad y restaurar una configuración

Ejecute el comando `show file systems` para verificar que la unidad USB está allí y confirmar su nombre. Para este ejemplo, el sistema de archivos USB se denomina `usbflash0:`.

Utilice el comando `copy run usbflash0:/` para copiar el archivo de configuración en la unidad flash USB. Asegúrese de utilizar el nombre de la unidad flash tal como se indica en el sistema de archivos. La barra es optativa, pero indica el directorio raíz de la unidad flash USB.

El IOS le solicitará el nombre de archivo. Si el archivo ya existe en la unidad flash USB, el router solicitará que se sobrescriba.

    R1# copy running-config usbflash0: 
    Destination filename [running-config]? Configuración R1- 
    %Warning:There is a file already existing with this name 
    Do you want to over write? [confirm] 

    5024 bytes copiados en 1.796 segundos (2797 bytes/seg) 
    R1#


Para restaurar configuraciones con una unidad flash USB, será necesario editar el archivo USB R1-Config con un editor de texto. Suponiendo que el nombre del archivo es R1-Config, use el comando `copy usbflash0:/R1-Config running-config` para restaurar una configuración en ejecución.

### Procedimientos de recuperación de contraseña

Las contraseñas de los dispositivos se utilizan para evitar el acceso no autorizado. Las contraseñas encriptadas, como las contraseñas generadas mediante "enable secret", se deben reemplazar después de su recuperación. Dependiendo del dispositivo, el procedimiento detallado para la recuperación de contraseña varía. 

Sin embargo, todos los procedimientos de recuperación de contraseña siguen el mismo principio:

1. Ingrese en el modo ROMMON.
2. Cambie el registro de configuración.
3. Copie el startup-config en la running-config.
4. Cambie la contraseña.
5. Guarde el running-config como el nuevo startup-config. 
6. Reinicie el dispositivo.


## Administración de imágenes de IOS

### Servidores TFTP como ubicación de copia de seguridad

A medida que una red crece, las imágenes y los archivos de configuración del software IOS de Cisco pueden almacenarse en un servidor TFTP central. Esto ayuda a controlar la cantidad de imágenes del IOS y las revisiones a dichas imágenes del IOS, así como los archivos de configuración que deben mantenerse.

Las internetworks de producción suelen abarcar áreas extensas y contienen varios routers. Para cualquier red, es una buena práctica mantener una copia de seguridad de la imagen del software Cisco IOS en caso de que la imagen del sistema en el router se dañe o se borre accidentalmente.

Los routers distribuidos ampliamente necesitan una ubicación de origen o de copia de seguridad para las imágenes del software IOS de Cisco. Utilizar un servidor TFTP de red permite cargar y descargar imágenes y configuraciones por la red. El servidor TFTP de la red puede ser otro router, una estación de trabajo o un sistema host.

### Ejemplo de copia de seguridad de la imagen del IOS en el servidor TFTP

Para mantener las operaciones de red con el mínimo tiempo de inactividad, es necesario implementar procedimientos para realizar copias de seguridad de las imágenes del IOS de Cisco. Esto permite que el administrador de red copie rápidamente una imagen a un router en caso de que la imagen esté dañada o borrada. 

Utilice los siguientes pasos:

1. Haga ping al servidor TFTP: Haga ping al servidor TFTP para probar la conectividad.
2. Verifique el tamaño de la imagen en flash: Verifique que el servidor TFTP tenga suficiente espacio en disco para admitir la imagen del software IOS de Cisco. Use el comando `show flash0:` en el router para determinar el tamaño del archivo de imagen Cisco IOS. 
3. Copie la imagen al servidor TFTP: Copie la imagen en el servidor TFTP mediante el comando `copy source-url destination-url` . Después de emitir el comando utilizando las URL de origen y destino especificadas, se le solicita al usuario el nombre del archivo de origen, la dirección IP del host remoto y el nombre del archivo de destino. A continuación, se inicia la transferencia.

    R1# copy tftp: flash: 
    Address or name of remote host []? 2001:DB8:CAF:100: :99 
    Source filename []? isr4200-universalk9_ias.16.09.04.SPA.bin 
    Destination filename [isr4200-universalk9_ias.16.09.04.SPA.bin]? 
    Accessing tftp://2001:DB8:CAFE:100::99/ isr4200- universalk9_ias.16.09.04.SPA.bin... Loading isr4200-universalk9_ias.16.09.04.SPA.bin from 2001:DB8:CAFE:100::99 (via GigabitEthernet0/0/0): !!!!!!!!!!!!!!!!!!!! 

    [OK - 517153193 bytes] 
    517153193 bytes copied in 868.128 secs (265652 bytes/sec)


### Comando boot system

Durante el inicio, el código de arranque analiza el archivo de configuración de inicio en NVRAM para los comandos `boot system` que específican el nombre y la ubicación de la imagen del software Cisco IOS para cargar. Si no hay comandos `boot system` de manera secuencial para proporcionar un plan de arranque que tenga tolerancia a fallas.

Si no hay comandos `boot system` en la configuración, de manera predeterminada, el router carga y ejecuta la primera imagen válida del IOS de Cisco en la memoria flash.

Para actualizar a la imagen IOS copiada después de que esa imagen se guarde en la memoria flash del router, configure el router para cargar la nueva imagen mediante el comando `boot system` . Guarde la configuración. Vuelva a cargar el router para que arranque con la nueva imagen.

    R1# configure terminal 
    R1 (config) # boot system flash0:isr4200-universalk9_ias.16.09.04.SPA.bin 
    R1(config)# exit 
    R1# copy running-config startup-config 
    R1# reload




