# Inter-VLAN Routing

## Funcionamiento de Inter-VLAN Routing 

Las VLAN se utilizan para segmentar las redes conmutadas de Capa 2 por diversas razones. Independientemente del motivo, los hosts de una VLAN no pueden comunicarse con los hosts de otra VLAN a menos que haya un enrutador o un conmutador de capa 3 para proporcionar servicios de enrutamiento.

Inter-VLA routing es el proceso de reenviar el tráfico de red de una VLAN a otra VLAN.

Hay tres opciones inter-VLAN routing:

- Enrutamiento entre VLAN heredado - Esta es una solución heredada. No escala bien
- Router-on-a-stick - Esta es una solución aceptable para una red pequeña y mediana. 
- Conmutador de nivel 3 con interfaces virtuales conmutadas (SVIs) : esta es la solución más escalable para organizaciones medianas y grandes. 

### Inter-VLAN Routing antiguo

Cada interfaz de router administra una VLAN

La primera solución de enrutamiento entre VLAN se basó en el uso de un router con múltiples interfaces Ethernet. Cada interfaz del router estaba conectada a un puerto del switch en diferentes VLAN. Las interfaces del router sirven como default gateways para los hosts locales en la subred de la VLAN.

Inter-VLAN routing heredado, usa las interfaces fisicas funciona, pero tiene limitaciones significantes. No es razonablemente escalable porque los enrutadores tienen un número limitado de interfaces físicas. Requerir una interfaz física del router por VLAN agota rápidamente la capacidad de la interfaz física del router

> Nota: Este método de inter-VLAN routing ya no se implementa en redes de switches y se incluye únicamente con fines explicativos.


### Router-on-a-Stick Inter-VLAN Routing

El router crea subinterfaces de una física y administra las vlan en subinterfaces.

El método de enrutamiento interVLAN 'router-on-a-stick' supera la limitación del método de enrutamiento interVLAN heredado. Solo requiere una interfaz Ethernet física para enrutar el tráfico entre varias VLAN de una red.

- Una interfaz Ethernet del router Cisco IOS se configura como un troncal 802.1Q y se conecta a un puerto troncal en un conmutador de capa 2. Específicamente, la interfaz del router se configura mediante subinterfaces para identificar VLAN enrutables.
- Las subinterfaces configuradas son interfaces virtuales basadas en software. Cada uno está asociado a una única interfaz Ethernet física. Estas subinterfaces se configuran en el software del router. Cada una se configura de forma independiente con sus propias direcciones IP y una asignación de VLAN. Las subinterfaces se configuran para subredes diferentes que corresponden a su asignación de VLAN. Esto facilita el enrutamiento lógico.
- Cuando el tráfico etiquetado de VLAN entra en la interfaz del router, se reenvía a la subinterfaz de VLAN. Después de tomar una decisión de enrutamiento basada en la dirección de red IP de destino, el enrutador determina la interfaz de salida del tráfico. Si la interfaz de salida está configurada como una subinterfaz 802.1q, las tramas de datos se etiquetan VLAN con la nueva VLAN y se envían de vuelta a la interfaz física

> Nota: el método de routing entre VLAN de router-on-a-stick no es escalable más allá de las 50.


### Inter-VLAN Routing en el Switch capa 3

El método moderno para realizar el enrutamiento entre VLAN es utilizar conmutadores de capa 3 e interfaces virtuales conmutadas (SVI). Una SVI es una interfaz virtual configurada en un switch multicapa, como se muestra en la figura.

> Nota: Un conmutador de capa 3 también se denomina conmutador multicapa ya que funciona en la capa 2 y la capa 3.

Ventajas del uso de conmutadores de capa 3 para el enrutamiento entre VLAN:

- Es mucho más veloz que router-on-a-stick, porque todo el switching y el routing se realizan por hardware.
- El routing no requiere enlaces externos del switch al router.
- No se limitan a un enlace porque los EtherChannels de Capa 2 se pueden utilizar como enlaces troncal entre los switches para aumentar el ancho de banda.
- La latencia es mucho más baja, dado que los datos no necesitan salir del switch para ser enrutados a una red diferente.
- Se implementan con mayor frecuencia en una LAN de campus que en enrutadores.

Desventajas:

- La única desventaja es que los switches de capa 3 son más caros.


## Router-on-a-Stick Inter-VLAN Routing

Paso 1. Configurar VLANs en switch
Paso 2. Configurar el enlace del switch al router troncal
Paso 3. Configurar subinterfaces del router
Paso 4. Asignar subinterfaces a VLANs en el router
Paso 5. añadir IPs a cada subinterfaz del router

Para el método de router-on-a-stick, se requieren subinterfaces configuradas para cada VLAN que se pueda enrutar. Se crea una subinterfaz mediante el comando `interface interface_id.subinterface_id`  global configuration mode. La sintaxis de la subinterfaz es la interfaz física seguida de un punto y un número de subinterfaz. Aunque no es obligatorio, es costumbre hacer coincidir el número de subinterfaz con el número de VLAN.

A continuación, cada subinterfaz se configura con los dos comandos siguientes:

- `encapsulation dot1q vlan_id [native]` : Este comando configura la subinterfaz para responder al tráfico encapsulado 802.1Q desde el vlan-id especificado. La opción de palabra clave nativa solo se agrega para establecer la VLAN nativa en algo distinto de la VLAN 1.
- `ip addressip-address subnet-mask` : Este comando configura la dirección IPv4 de la subinterfaz. Esta dirección normalmente sirve como puerta de enlace predeterminada para la VLAN identificada.

Repita el proceso para cada VLAN que se vaya a enrutar. Es necesario asignar una dirección IP a cada subinterfaz del router en una subred única para que se produzca el routing. Cuando se hayan creado todas las subinterfaces, habilite la interfaz física mediante el comando de configuración no shutdown. Si la interfaz física está deshabilitada, todas las subinterfaces están deshabilitadas.

    R1(congig)# interface gigabitethernet 0/0
    R1(congig-if)# no shutdown
    R1(congig-if)#  description trunk link
    R1(congig)# interface gigabitethernet 0/0.10
    R1(congig-if)#  description default Gateway for VLAN 10
    R1(congig-if)# encapsulation dot1Q 10
    R1(congig-if)# ip address 192.168.10.1 255.255.255.0

## Inter-VLAN Routing using Layer 3 Switches

Las LAN de campus empresariales utilizan conmutadores de nivel 3 para proporcionar enrutamiento entre VLAN. Los switches de nivel 3 utilizan conmutación basada en hardware para lograr velocidades de procesamiento de paquetes más altas que los enrutadores. Los conmutadores de capa 3 también se implementan comúnmente en armarios de cableado de capa de distribución empresarial.

Las capacidades de un conmutador de capa 3 incluyen la capacidad de hacer lo siguiente:

- Ruta de una VLAN a otra mediante múltiples interfaces virtuales conmutadas (SVIs).
- Convierta un puerto de conmutación de capa 2 en una interfaz de capa 3 (es decir, un puerto enrutado). Un puerto enrutado es similar a una interfaz física en un router Cisco IOS.
- Para proporcionar enrutamiento entre VLAN, los conmutadores de capa 3 utilizan SVIs. Los SVIs se configuran utilizando el mismo comando interface vlanvlan-id utilizado para crear el SVI de administración en un conmutador de capa 2. Se debe crear un SVI de Capa 3 para cada una de las VLAN enrutables.

### Conmutadores de Capa 3

Complete los siguientes pasos para configurar switch layer 3 con VLAN y trunking

1. Cree las VLAN.
2. Cree las interfaces VLAN SVI. La dirección IP configurada servirá como puerta de enlace predeterminada para los hosts de la VLAN respectiva. 
3. Configure puertos de acceso. Asigne el puerto apropiado a la VLAN requerida. 
4. Habilitar routing IP. Ejecute el comando ip routing global configuration para permitir el intercambio de tráfico entre las VLANs. Este comando debe configurarse para habilitar el enrutamiento inter-VAN en un conmutador de capa 3 para IPv4.


### Enrutamiento en un conmutador de capa 3

Si se quiere que otros dispositivos de Capa 3 puedan acceder a las VLAN, deben anunciarse mediante enrutamiento estático o dinámico. Para habilitar el enrutamiento en un conmutador de capa 3, se debe configurar un puerto enrutado.

Un puerto enrutado se crea en un conmutador de capa 3 deshabilitando la entidad de puerto de conmutación en un puerto de capa 2 que está conectado a otro dispositivo de capa 3. 

Específicamente, al configurar el comando de configuración de no switchport en un puerto de Capa 2, se convierte en una interfaz de Capa 3. A continuación, la interfaz se puede configurar con una configuración IPv4 para conectarse a un enrutador u otro conmutador de capa 3.

Puerto enrutado:

    # convertir interfaz capa 2 a
     capa 3
    interface g0/0
    no switchport
    ip address <ip> <masc>


### switches de capa 3 en un conmutador de capa 3

Complete los siguientes pasos para configurar D1 para enrutar con R1:

1. Configure el puerto enrutado. Utilice el comando `no switchport` para convertir el puerto en un puerto enrutado y, a continuación, asigne una dirección IP y una máscara de subred. Habilite el puerto.
2. Activar el routing. Use el comando de modo de configuración global `ip routing` para habilitar el routing
3. Configurar el enrutamiento Utilice un método de enrutamiento adecuado. En este ejemplo, se configura OSPFv2 de área única
4. Verificar enrutamiento. Use el comando `show ip route` .
5. Verificar la conectividad Use el comando ping para verificar la conectividad.




---

    convertir interfaz en capa 3
    interface g0/0
    no switchport
    ip address <ip> <masc>

    Habilitar enrutamiento
    ip routing
    show ip route

    OSPF
    router ospf 1
    network 192.168.30.0 0.0.0.255 area 0
    network 10.10.10.0 0.0.0.255 area 0