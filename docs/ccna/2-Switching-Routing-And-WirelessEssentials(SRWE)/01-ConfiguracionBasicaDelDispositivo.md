# Configuración básica del dispositivo

##  Configurar un switch con parámetros iniciales

### Secuencia de arranque de un switch

Paso 1: Primero, el switch carga un programa de autocomprobación de encendido (POST) almacenado en la ROM. El POST verifica el subsistema de la CPU. Este comprueba la CPU, la memoria DRAM y la parte del dispositivo flash que integra el sistema de archivos flash.

Paso 2: A continuación, el switch carga el software del cargador de arranque. El cargador de arranque es un pequeño programa almacenado en la memoria ROM que se ejecuta inmediatamente después de que el POST se completa correctamente.

Paso 3:El gestor de arranque realiza la inicialización de CPU de bajo nivel. Inicializa los registros de la CPU, que controlan dónde está asignada la memoria física, la cantidad de memoria y su velocidad.
Paso 4: El cargador de arranque inicializa el sistema de archivos flash en la placa del sistema.

Paso 5: Finalmente, el cargador de arranque localiza y carga una imagen de software del sistema operativo IOS predeterminado en la memoria y le da el control del cambio al IOS.

### comando boot system

Después de encender un switch Cisco, pasa por la siguiente secuencia de inicio de cinco pasos: Si no se establece esta variable, el switch intenta cargar y ejecutar el primer archivo ejecutable que puede encontrar.

El sistema operativo IOS luego inicializa las interfaces utilizando los comandos Cisco IOS que se encuentran en el archivo de configuración de inicio. El archivo startup-config se llama `config.text` y se encuentra en flash.

En el ejemplo, la variable de entorno BOOT se establece utilizando el comando del modo de configuración global boot system. Observe que el IOS se ubica en una carpeta distinta y que se especifica la ruta de la carpeta. Use el comando show boot para ver la configuración actual del archivo de arranque de IOS.

    S1(config)# boot system flash:/"archivo de IOS.bin"
    S1# show boot

### Recuperación tras un bloqueo del sistema

El cargador de arranque proporciona acceso al switch si no se puede usar el sistema operativo debido a la falta de archivos de sistema o al daño de estos. El cargador de arranque tiene una línea de comando que proporciona acceso a los archivos almacenados en la memoria flash. Se puede acceder al cargador de arranque mediante una conexión de consola con los siguientes pasos:

Paso 1. Conecte una computadora al puerto de consola del switch con un cable de consola. Configure el software de emulación de terminal para conectarse al switch.

Paso 2. Desconecte el cable de alimentación del switch.

Paso 3. Vuelva a conectar el cable de alimentación al switch, espere 15 segundos y, a continuación, presione y mantenga presionado el botón Mode mientras el LED del sistema sigue parpadeando con luz verde.

Paso 4. Continúe oprimiendo el botón Mode hasta que el LED del sistema se torne ámbar por un breve instante y luego verde, después suelte el botón Mode 

Paso 5. The boot loader switch: aparece en el software de emulación de terminal en la PC.

La línea de comandos de boot loader admite comandos para formatear el sistema de archivos flash, volver a instalar el software del sistema operativo y recuperar una contraseña perdida u olvidada. Por ejemplo, el comando dir  puede usar para ver una lista de archivos dentro de un directorio específico.

### Ejemplo de configuración de SVI

De manera predeterminada, el switch está configurado para controlar su administración a través de la VLAN 1. Todos los puertos se asignan a la VLAN 1 de manera predeterminada. Por motivos de seguridad, se recomienda usar una VLAN de administración distinta de la VLAN 1.

**Paso 1: Configure la interfaz de administración:** Desde el modo de configuración de la interfaz VLAN, se aplica una dirección IPv4 y una máscara de subred a la SVI de administración del switch.

**Nota:** El SVI para VLAN 99 no aparecerá como "activo / activo" hasta que se cree VLAN 99 y haya un dispositivo conectado a un puerto de switch asociado con VLAN 99.

> Es posible que el switch deba configurarse para IPv6. Por ejemplo, antes de que pueda configurar el direccionamiento IPv6 en un Cisco Catalyst 2960 con IOS versión 15.0, deberá ingresar el comando de configuración global sdm, preferir `dual-ipv4-and ipv6 default` y, a continuación, reiniciar el switch. 


    # añadir direccion a vlan 99
    S1# show vlan
    S1# configure terminal
    S1(config)# interface vlan 99
    S1(config-if)# ip address 192.168.1.30 255.255.255.0
    S1(config-if)# no shutdown

    # crear y activar vlan 99
    S1(config)#vlan 99

    # añadir gateway para acceso remoto
    S1# configure terminal
    S1(config)# ip default-gateway 192.168.1.1
    S1(config-if)# end
    S1# copy running-config startup-config

Comprobar

    show ip interface brief
    show ipv6 interface brief 

ver plantillas disponibles

    show sdm prefer
    sdm prefer dual-ipv4-and-ipv6 default

## Configuración de puertos de un switch

### Comunicación en dúplex

Las LAN microsegmentadas se crean cuando un puerto de switch tiene solo un dispositivo conectado y funciona en modo dúplex completo. No hay dominio de colisión asociado con un puerto de switch que funcione en modo dúplex completo.

Gigabit Ethernet y NIC de 10 Gb requieren conexiones full-duplex para funcionar. En el modo dúplex completo, el circuito de detección de colisiones de la NIC se encuentra inhabilitado. Dúplex completo ofrece el 100% de eficacia en ambas direcciones (transmisión y recepción). Esto da como resultado una duplicación del uso potencial del ancho de banda establecido.

### Configurar puertos de switch en la capa física

Los puertos de switch se pueden configurar manualmente con parámetros específicos de dúplex y de velocidad. Los comandos de configuración de interfaz respectivos son dúplex y velocidad .

La configuración predeterminada de dúplex y velocidad para los puertos de switch en los switches Cisco Catalyst 2960 y 3560 es automática. Los puertos 10/100/1000 funcionan en modo semidúplex o semidúplex cuando están configurados en 10 o 100 Mbps y operan solo en modo dúplex completo cuando está configurado en 1000 Mbps (1 Gbps). 

La negociación automática es útil cuando la configuración de velocidad y dúplex del dispositivo que se conecta al puerto es desconocida o puede cambiar. Cuando se conecta a dispositivos conocidos como servidores, estaciones de trabajo dedicadas o dispositivos de red, la mejor práctica es establecer manualmente la configuración de velocidad y dúplex.

Al solucionar problemas de puertos del switch, es importante que se verifiquen las configuraciones de dúplex y velocidad.

**Nota:** Todos los puertos de fibra óptica, como los puertos 1000BASE-SX, solo funcionan a una velocidad predefinida y siempre son dúplex completo.

    S1(config)# interface FastEthernet 0/1
    S1(config-if)# duplex {full|half|auto}
    S1(config-if)# speed {10|100|auto}

### Auto-MDIX

Cuando se habilita el crossover automático de interfaz dependiente del medio (auto-MDIX), la interfaz del switch detecta automáticamente el tipo de conexión de cable requerido (directo o cruzado) y configura la conexión adecuadamente. 

Al conectarse a los switches sin la función auto-MDIX, los cables directos deben utilizarse para conectar a dispositivos como servidores, estaciones de trabajo o routers. Los cables cruzados se deben utilizar para conectarse a otros switches o repetidores.

Con la característica auto-MDIX habilitada, se puede usar cualquier tipo de cable para conectarse a otros dispositivos, y la interfaz se ajusta de manera automática para proporcionar comunicaciones satisfactorias. 

En los switches Cisco más modernos, el comando del modo de configuración de interfaz mdix auto habilita la característica. Cuando se usa auto-MDIX en una interfaz, la velocidad y el modo dúplex de la interfaz se deben establecer en auto para que la característica funcione correctamente.

    S1(config-if)# mdix auto
    R1# show  controlers    # ver tipo de cableado

### Problemas en la capa de acceso a la red 

| Tipo de error          | Descripción                                                                                                                                                                               |
| :--------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Errores de entrada     | Cantidad total de errores. Incluye runts, gigantes, sin buffer, CRC, , desbordamiento y recuentos ignorados.                                                                              |
| Fragmentos de colisión | Paquetes que se descartan porque son más pequeños que el mínimo tamaño del paquete para el medio. Por ejemplo, cualquier paquete Ethernet que sea menos de 64 bytes se considera un runt. |
| Gigantes               | Paquetes que se descartan porque exceden el tamaño máximo de paquete para el medio. Por ejemplo, cualquier paquete de Ethernet que sea mayor que 1.518 bytes se considera un gigante.     |
| CRC                    | Los errores de CRC se generan cuando la suma de comprobación calculada no es la misma que la suma de comprobación recibida.                                                               |
| Errores de salida      | Suma de todos los errores que impidieron la transmisión final de datagramas de la interfaz que se está examinando.                                                                        |
| Colisiones             | Cantidad de mensajes retransmitidos debido a una colisión de Ethernet.                                                                                                                    |
| Colisiones tardías     | Una colisión que ocurre después de 512 bits de la trama han sido Transmitido                                                                                                              |

### Errores de entrada y salida de interfaz

“Input errors” indica la suma de todos los errores en los datagramas que se recibieron en la interfaz que se analiza. Estos incluyen los recuentos de fragmentos de colisión, de fragmentos gigantes, de los que no están almacenados en buffer, de CRC, de tramas, de saturación y de ignorados. Los errores de entrada informados del comando show interfaces incluyen lo siguiente:

- Runt Frames - las tramas Ethernet que son más cortas que la longitud mínima permitida de 64 bytes se llaman runts. La NIC en mal funcionamiento son la causa habitual de las tramas excesivas de fragmentos de colisión, pero también pueden deberse a colisiones.
- Giants -Las tramas de Ethernet que son más grandes que el tamaño máximo permitido se llaman gigantes.
- CRC errors -En las interfaces Ethernet y serie, los errores de CRC generalmente indican un error de medios o cable. Las causas más comunes incluyen interferencia eléctrica, conexiones flojas o dañadas o cableado incorrecto. Si aparecen muchos errores de CRC, hay demasiado ruido en el enlace, y se debe examinar el cable. También se deben buscar y eliminar las fuentes de ruido.

“Output errors” es la suma de todos los errores que impiden la transmisión final de los datagramas por la interfaz que se analiza. Los errores de salida informados del comando show interfaces incluyen lo siguiente:

- Colisión - Las colisiones en operaciones half-duplex son normales. Sin embargo, nunca debe observar colisiones en una interfaz configurada para la comunicación en dúplex completo.
- Colisiones tardías -Una colisión tardía se refiere a una colisión que ocurre después de que se han transmitido 512 bits de la trama. La longitud excesiva de los cables es la causa más frecuente de las colisiones tardías. Otra causa frecuente es la configuración incorrecta de dúplex. 


 