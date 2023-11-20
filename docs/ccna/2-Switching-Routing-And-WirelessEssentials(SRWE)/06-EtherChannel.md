# EtherChannel

## Funcionamiento de EtherChannel

Hay escenarios en los que se necesita más ancho de banda o redundancia entre dispositivos que lo que puede proporcionar un único enlace. Se pueden conectar varios enlaces entre dispositivos para aumentar el ancho de banda. Sin embargo, el protocolo de árbol de expansión (STP), que está habilitado en dispositivos de capa 2 como switches Cisco de forma predeterminada, bloqueará enlaces redundantes para evitar bucles de conmutación.

Se necesita una tecnología de agregación de enlaces que permita vínculos redundantes entre dispositivos que no serán bloqueados por STP. Esa tecnología se conoce como EtherChannel.

**EtherChannel** es una tecnología de agregación de enlaces que agrupa varios enlaces físicos Ethernet en un único enlace lógico. Se utiliza para proporcionar tolerancia a fallos, uso compartido de carga, mayor ancho de banda y redundancia entre switches, routers y servidores.

La tecnología de EtherChannel hace posible combinar la cantidad de enlaces físicos entre los switches para aumentar la velocidad general de la comunicación switch a switch.

### Ventajas de la operación EtherChanne

La tecnología EtherChannel tiene muchas ventajas, incluidas las siguientes:

- La mayoría de las tareas de configuración se pueden realizar en la interfaz EtherChannel en lugar de en cada puerto individual, lo que asegura la coherencia de configuración en todos los enlaces.
- EtherChannel depende de los puertos de switch existentes. No es necesario actualizar el enlace a una conexión más rápida y más costosa para tener más ancho de banda.
- El equilibrio de carga ocurre entre los enlaces que forman parte del mismo EtherChannel. 
- EtherChannel crea una agregación que se ve como un único enlace lógico. Cuando existen varios grupos EtherChannel entre dos switches, STP puede bloquear uno de los grupos para evitar los bucles de switching. Cuando STP bloquea uno de los enlaces redundantes, bloquea el EtherChannel completo. Esto bloquea todos los puertos que pertenecen a ese enlace EtherChannel. Donde solo existe un único enlace EtherChannel, todos los enlaces físicos en el EtherChannel están activos, ya que STP solo ve un único enlace (lógico).
- EtherChannel proporciona redundancia, ya que el enlace general se ve como una única conexión lógica. Además, la pérdida de un enlace físico dentro del canal no crea ningún cambio en la topología. 

### Restricciones de implementación

EtherChannel tiene ciertas restricciones de implementación, entre las que se incluyen las siguientes:

- No pueden mezclarse los tipos de interfaz. Por ejemplo, Fast Ethernet y Gigabit Ethernet no se pueden mezclar dentro de un único EtherChannel.
- En la actualidad, cada EtherChannel puede constar de hasta ocho puertos Ethernet configurados de manera compatible. El EtherChannel proporciona un ancho de banda full-duplex de hasta 800 Mbps (Fast EtherChannel) u 8 Gbps (Gigabit EtherChannel) entre un switch y otro switch o host.
- El switch Cisco Catalyst 2960 Layer 2 soporta actualmente hasta seis EtherChannels. 
- La configuración de los puertos individuales que forman parte del grupo EtherChannel debe ser coherente en ambos dispositivos. Si los puertos físicos de un lado se configuran como enlaces troncales, los puertos físicos del otro lado también se deben configurar como enlaces troncales dentro de la misma VLAN nativa. Además, todos los puertos en cada enlace EtherChannel se deben configurar como puertos de capa 2.
- Cada EtherChannel tiene una interfaz de canal de puertos lógica La configuración aplicada a la interfaz de canal de puertos afecta a todas las interfaces físicas que se asignan a esa interfaz.

### Protocolos denegociación automática

Los EtherChannels se pueden formar por medio de una negociación con uno de dos protocolos: Port Aggregation Protocol (PAgP) o Link Aggregation Control Protocol (LACP). Estos protocolos permiten que los puertos con características similares formen un canal mediante una negociación dinámica con los switches adyacentes.

> Nota: también es posible configurar un EtherChannel estático o incondicional sin PAgP o LACP.


#### Funcionamiento PAgP

PAgP (pronunciado “Pag - P”) es un protocolo patentado por Cisco que ayuda en la creación automática de enlaces EtherChannel. Cuando se configura un enlace EtherChannel mediante PAgP, se envían paquetes PAgP entre los puertos aptos para EtherChannel para negociar la formación de un canal. Cuando PAgP identifica enlaces Ethernet compatibles, agrupa los enlaces en un EtherChannel. El EtherChannel después se agrega al árbol de expansión como un único puerto.

Cuando se habilita, PAgP también administra el EtherChannel. Los paquetes PAgP se envían cada 30 segundos. PAgP revisa la coherencia de la configuración y administra los enlaces que se agregan, así como las fallas entre dos switches. Cuando se crea un EtherChannel, asegura que todos los puertos tengan el mismo tipo de configuración.

> Nota: en EtherChannel, es obligatorio que todos los puertos tengan la misma velocidad, la misma configuración de dúplex y la misma información de VLAN. Cualquier modificación de los puertos después de la creación del canal también modifica a los demás puertos del canal.

PAgP ayuda a crear el enlace EtherChannel al detectar la configuración de cada lado y asegurarse de que los enlaces sean compatibles, de modo que se pueda habilitar el enlace EtherChannel cuando sea necesario. Los modos de PAgP de la siguiente manera:

- Encendido: este modo obliga a la interfaz a proporcionar un canal sin PAgP. Las interfaces configuradas en el modo encendido no intercambian paquetes PAgP.
- PAgP desirable - Este modo PAgP coloca una interfaz en un estado de negociación activa en el que la interfaz inicia negociaciones con otras interfaces al enviar paquetes PAgP.
- PAgP auto - este modo PAgP coloca una interfaz en un estado de negociación pasiva en el que la interfaz responde a los paquetes PAgP que recibe, pero no inicia la negociación PAgP.


| S1         | S2                     | Establecimiento del canal |
| :--------- | :--------------------- | :------------------------ |
| Activo     | Activo                 | Sí                        |
| Activado   | Desdeseable/Automático | No                        |
| Deseado    | Deseado                | Sí                        |
| Deseado    | Automático             | Sí                        |
| Automático | Deseado                | Sí                        |
| Automático | Automático             | No                        |


#### Funcionamiento LACP 

LACP forma parte de una especificación IEEE (802.3ad) que permite agrupar varios puertos físicos para formar un único canal lógico. LACP permite que un switch negocie un grupo automático mediante el envío de paquetes LACP al otro switch. Realiza una función similar a PAgP con EtherChannel de Cisco. Debido a que LACP es un estándar IEEE, se puede usar para facilitar los EtherChannels en entornos de varios proveedores. En los dispositivos de Cisco, se admiten ambos protocolos.

LACP proporciona los mismos beneficios de negociación que PAgP. LACP ayuda a crear el enlace EtherChannel al detectar la configuración de cada lado y al asegurarse de que sean compatibles, de modo que se pueda habilitar el enlace EtherChannel cuando sea necesario. Los modos para LACP son los siguientes:

- On - Este modo obliga a la interfaz a proporcionar un canal sin LACP. Las interfaces configuradas en el modo encendido no intercambian paquetes LACP.
- LACP active - Este modo de LACP coloca un puerto en estado de negociación activa. En este estado, el puerto inicia negociaciones con otros puertos mediante el envío de paquetes LACP.
- LACP passive - Este modo de LACP coloca un puerto en estado de negociación pasiva. En este estado, el puerto responde a los paquetes LACP que recibe, pero no inicia la negociación de paquetes LACP.


| S1       | S2            | Establecimiento del canal |
| :------- | :------------ | :------------------------ |
| Activo   | Activo        | Sí                        |
| Activado | Activo/pasivo | No                        |
| Activo   | Activo        | Sí                        |
| Activo   | Pasivo        | Sí                        |
| Pasivo   | Activo        | Sí                        |
| Pasivo   | Pasivo        | No                        |


## Configuración de EtherChannel

### Pautas para la configuración

Las siguientes pautas y restricciones son útiles para configurar EtherChannel:

- EtherChannel support - Todas las interfaces Ethernet deben admitir EtherChannel, sin necesidad de que las interfaces sean físicamente contiguas
- Speed and duplex - Configure todas las interfaces en un EtherChannel para que funcionen a la misma velocidad y en el mismo modo dúplex.
- VLAN match - Todas las interfaces en el grupo EtherChannel se deben asignar a la misma VLAN o se deben configurar como enlace troncal (mostrado en la figura).
- Rango de VLAN: un EtherChannel admite el mismo rango permitido de VLAN en todas las interfaces de un EtherChannel de enlace troncal. Si el rango permitido de VLAN no es el mismo, las interfaces no forman un EtherChannel, incluso si se establecen en modo auto o desirable .

### Ejemplo de LACP

    S1(config)# interface range FastEthernet 0/1 - 2
    S1(config-if-range)# channel-group 1 mode active
    Creating a port-channel interface Port-channel 1
    S1(config-if-range)# exit
    S1(config)# interface port-channel 1
    S1(config-if)# switchport mode trunk
    S1(config-if)# switchport trunk allowed vlan 1,2,20


---

show etherchannel summary
show interfaces port-channel
show etherchannel port-channel
show interfaces etherchannel

    S1(config)# interface range FastEthernet 0/1 - 2
    S1(config-if-range)# channel-group 1 mode active
    Creating a port-channel interface Port-channel 1
    S1(config-if-range)# exit
    S1(config)# interface port-channel 1
    S1(config-if)# switchport mode trunk
    S1(config-if)# switchport trunk allowed vlan 1,2,20
