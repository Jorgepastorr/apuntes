# VLAN

Las VLAN son conexiones lógicas con otros dispositivos similares.

La colocación de dispositivos en varias VLAN tiene las siguientes características:

- Proporciona segmentación de los diversos grupos de dispositivos en los mismos conmutadores
- Proporcionar una organización más manejable
- Difusiones, multidifusión y unidifusión se aíslan en la VLAN individual
- Cada VLAN tendrá su propia gama única de direcciones IP
- Dominios de difusión más pequeños

Beneficios de usar VLAN:

- Dominios de difusión más pequeños: Dividir una red en VLAN reduce el número de dispositivos en el broadcast domain.
- Seguridad mejorada: Sólo los usuarios de la misma VLAN pueden comunicarse juntos.
- Mejora la eficiencia del departamento de IT: Las VLAN pueden agrupar dispositivos con requisitos similares, por ejemplo, profesores frente a estudiantes
- Reducción de costos: Un switch puede admitir varios grupos o VLAN
- Mejor rendimiento: Los dominios de difusión más pequeños reducen el tráfico innecesario en la red y mejorar el rendimiento.
- Administración más simple de proyectos y aplicaciones: Grupos similares necesitarán aplicaciones similares y otros recursos de red

## Tipos de VLAN

La VLAN 1 es la predeterminada y engloba:

- La VLAN predeterminada
- La VLAN nativa predeterminada
- La VLAN de administración predeterminada
- No se puede eliminar ni cambiar el nombre

**Nota:** Aunque no podemos eliminar VLAN1, Cisco recomendará que asignemos estas características predeterminadas a otras VLAN

VLAN de datos 

- Dedicado al tráfico generado por el usuario (correo electrónico y tráfico web). 
- VLAN 1 es la VLAN de datos predeterminada porque todas las interfaces están asignadas a esta VLAN.

VLAN nativa

- Esto se utiliza sólo para enlaces troncales. 
- Todas las tramas están etiquetadas en un enlace troncal 802.1Q excepto las de la VLAN nativa. 

VLAN de administración 

- Esto se utiliza para el tráfico SSH/Telnet VTY y no debe ser llevado con el tráfico de usuario final.
- Normalmente, la VLAN que es el SVI para el conmutador de capa 2. 

VLAN de voz  

- Se requiere una VLAN separada porque el tráfico de voz requiere:
    - Ancho de banda asegurado
    - Alta prioridad de QoS
    - Capacidad para evitar la congestión
    - Retraso menos de 150 ms desde el origen hasta el destino
- Toda la red debe estar diseñada para admitir la voz.   


## VLAN en un entorno de conmutación múltiple

### Definición de troncales

Un enlace troncal es un enlace punto a punto entre dos dispositivos de red.

El enlace troncal es aquel que se configura para que pasen X VLAN entre dispositivos

Funciones troncal de Cisco:

- Permitir más de una VLAN
- Extender la VLAN a través de toda la red
- De forma predeterminada, admite todas las VLAN
- Soporta enlace troncal 802.1Q

### Redes con VLAN

Con las VLAN, el tráfico de unidifusión, multidifusión y difusión se limita a una VLAN. Sin un dispositivo de capa 3 para conectar las VLAN, los dispositivos de diferentes VLAN no pueden comunicarse. 

### Identificación de VLAN con una etiqueta

El encabezado IEEE 802.1Q es de 4 Bytes

Cuando se crea la etiqueta, se debe volver a calcular el FCS.

Cuando se envía a los dispositivos finales, esta etiqueta debe eliminarse y el FCS vuelve a calcular su número original.

Detalles del campo VLAN Tag

- Tipo: Un valor de 2 bytes denominado “ID de Protocolo de Etiqueta” (TPID). Para Ethernet, este valor se establece en 0x8100 hexadecimal.
- Prioridad de usuario: Es un valor de 3 bits que admite la implementación de nivel o de servicio.
- Identificador de Formato Canónico (CFI): Es un identificador de 1 bit que habilita las tramas Token Ring que se van a transportar a través de los enlaces Ethernet.
- VLAN ID (VID): Es un número de identificación de VLAN de 12 bits que admite hasta 4096 ID de VLAN.


### VLAN nativas y etiquetado 802.1Q

Conceptos básicos del tronco 802.1Q:

- El etiquetado se realiza normalmente en todas las VLAN.
- El uso de una VLAN nativa se diseñó para uso heredado, como el HUB
- A menos que se modifique, VLAN1 es la VLAN nativa.
- Ambos extremos de un enlace troncal deben configurarse con la misma VLAN nativa.
- Cada troncal se configura por separado, por lo que es posible tener una VLAN nativa diferente en troncos separados.

### Etiquetado de VLAN de voz

El teléfono VoIP es un conmutador de tres puertos:

- El conmutador utilizará CDP para informar al teléfono de la VLAN de voz.
- El teléfono etiquetará su propio tráfico (Voz) y puede establecer el coste de servicio (CoS). CoS es QoS para la capa 2.
- El teléfono puede o no etiquetar marcos de la PC.

El puerto de acceso del switch envía paquetes CDP que indican al teléfono IP conectado que envíe tráfico de voz de una de las tres maneras. El método utilizado varía según el tipo de tráfico:

- El tráfico VLAN de voz debe etiquetarse con un valor de prioridad CoS de Capa 2 adecuado.
- En una VLAN de acceso con una etiqueta de valor de prioridad de CoS de capa 2
- En una VLAN de acceso sin etiqueta (sin valor de prioridad de CoS de capa 2)

##  Configuración de VLAN

### Rango Normal VLANs 1 - 1005

- Utilizado en pequeñas y medianas empresas
- 1002 — 1005 están reservados para VLAN heredadas
- 1, 1002 — 1005 se crean automáticamente y no se pueden eliminar
- Almacenado en el archivo vlan.dat en flash
- VTP puede sincronizar entre conmutadores

### Rango Extendido VLANs 1006 - 4095

- Usado por los proveedores de servicios
- Están en Running-Config
- Admite menos funciones de VLAN
- Requiere configuraciones de VTP

### configuraciones

creacion de vlan

    # crear y activar vlan 99
    S1(config)# vlan 99
    S1(config-vlan)# name mandarinas

assignar VLAN a puerto

    S1(config)# interface fastethernet 0/1
    S1(config-if)# switchport mode access
    S1(config-if)# switchport access vlan 10

informacion

    S1# show vlan [brief|id vlan|name|summary]


Puerto Troncales

    Switch# configure terminal
    Switch(config)# interface fastethernet 0/2
    Switch(config-if)# switchport trunk 
    Switch(config-if)# switchport trunk native vlan 99
    Switch(config-if)# switchport trunk allowed vlan 10,20,30


## Dynamic Trunking ProtocolProtocolo de enlace dinámico

### Introduction to DTP

El Protocolo de enlace troncal dinámico (DTP) es un protocolo propietario de Cisco.

Las características de DTP son las siguientes:

- Activado de forma predeterminada en switches Catalyst 2960 y 2950
- Dynamic-Auto es el valor predeterminado en los conmutadores 2960 y 2950
- Puede desactivarse con el comando nonegotiate
- Puede volver a activarse configurando la interfaz en dinámico automático
- Establecer un conmutador en un tronco estático o acceso estático evitará problemas de negociación con los comandos `switchport mode trunk` o `switchport mode access` .

    Switch(config-if)# switchport mode trunk
    Switch(config-if)# switchport nonegotiate

    Switch(config-if)# switchport mode dynamic auto

### Modos de interfaz negociados

El comando switchport mode tiene opciones adicionales.

- access: Pone la interfaz (puerto de acceso) en modo permanente de no trunking y negocia para convertir el enlace en un enlace no troncal.
- dynamic auto: Se convierte en una interfaz troncal si la interfaz vecina se configura en modo troncal o deseable
- dynamic desirable: Busca activamente convertirse en un tronco negociando con otras interfaces automáticas o deseables
- trunk: Modo de enlace permanente y negocia para convertir el enlace vecino en un enlace troncal

> Utilice el comando switchport nonegotiate interface configuration para detener la negociación DTP.

La tabla ilustra los resultados de las opciones de configuración DTP en extremos opuestos de un enlace troncal conectado a los puertos del switch Catalyst 2960. 

|                     | Dinámico automático | Dinámico deseado | Troncal               | Acceso                |
| :------------------ | :------------------ | :--------------- | :-------------------- | :-------------------- |
| Dinámico automático | Acceso              | Troncal          | Troncal               | Acceso                |
| Dinámico deseado    | Troncal             | Troncal          | Troncal               | Acceso                |
| Troncal             | Troncal             | Troncal          | Troncal               | Conectividad limitada |
| Acceso              | Acceso              | Acceso           | Conectividad limitada | Acceso                |

