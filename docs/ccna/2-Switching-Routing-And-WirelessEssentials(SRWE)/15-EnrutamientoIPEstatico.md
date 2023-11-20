# Enrutamiento IP Estático

## Rutas Estáticas

### Tipos de Rutas Estáticas

Las rutas estáticas se implementan comúnmente en una red. Esto es cierto incluso cuando hay un protocolo de enrutamiento dinámico configurado. 

Las rutas estáticas se pueden configurar para IPv4 e IPv6. Ambos protocolos admiten los siguientes tipos de rutas estáticas:

- Ruta estática estándar
- Ruta estática predeterminada
- Ruta estática flotante
- Ruta estática resumida

### Opciones de siguiente salto

El siguiente salto se puede identificar mediante una dirección IP, una interfaz de salida, o ambas cuando se está configurando una ruta estática. El modo en que se especifica el destino genera uno de los siguientes tres tipos de ruta:

- Ruta del siguiente salto - Solo se especifica la dirección IP del siguiente salto.
- Ruta estática conectada directamente - Solo se especifica la interfaz de salida del router.
- Ruta estática totalmente especificada - Se especifican la dirección IP del siguiente salto y la interfaz de salida.

Las rutas estáticas IPv4 se configuran con el siguiente comando global:

    Router(config)# ip route network-address subnet-mask { ip-address | exit-intf [ip-address]} [distance]

Las rutas estáticas IPv6 se configuran con el siguiente comando global:

    Router(config) # ipv6 route ipv6-prefix/prefix-length { ipv6-address | exit-intf [ ipv6-address]} [ distance] 


## Configurar Rutas IP Estáticas

### Configurar una ruta estática de siguiente salto

En una ruta estática de siguiente salto, solo se especifica la dirección IP del siguiente salto. La interfaz de salida se deriva del próximo salto. 

    R1 (config) # ip route 172.16.1.0 255.255.255.0 172.16.2.2

    R1 (config) # ipv6 route 2001:db8:acad:1::/64 2001:db8:acad:2::2 


### Configurar una ruta estática conectada directamente 

Al configurar una ruta estática, otra opción es utilizar la interfaz de salida para especificar la dirección del siguiente salto.

> Nota: Generalmente se recomienda utilizar una dirección de salto siguiente. Solo se deben utilizar rutas estáticas conectadas directamente con interfaces seriales de punto a punto.  

    R1(config)# ip route 172.16.1.0 255.255.255.0 s0/1/0 

    R1 (config) # ipv6 route 2001:db8:acad:1::/64 s0/1/0 

### Configurar una ruta estática totalmente especificada

Una ruta estática completamente especificada tiene determinadas tanto la interfaz de salida como la dirección IP del siguiente salto. Esta forma de ruta estática se utiliza cuando la interfaz de salida es una interfaz de acceso múltiple y se debe identificar explícitamente el siguiente salto. El siguiente salto debe estar conectado directamente a la interfaz de salida especificada. El uso de una interfaz de salida es opcional, sin embargo, es necesario utilizar una dirección de salto siguiente.

    R1(config)# ip route 172.16.1.0 255.255.255.0 GigabitEthernet 0/0/1 172.16.2.2  

En IPv6, hay una situación en la cual se debe utilizar una ruta estática completamente especificada. Si la ruta estática IPv6 usa una dirección IPv6 link-local como la dirección del siguiente salto, debe utilizarse una ruta estática completamente especificada. La figura muestra un ejemplo de una ruta estática IPv6 completamente especificada a que utiliza una dirección IPv6 link-local como la dirección del siguiente salto.

    R1(config)# ipv6 route 2001:db8:acad:1::/64 s0/1/0 fe80::2


## Configurar Rutas IP Estáticas Predeterminadas

Una ruta predeterminada es una ruta estática que coincide con todos los paquetes. Una ruta predeterminada única, representa una ruta de acceso a cualquier red que no se encuentra en la tabla de enrutamiento.

Las rutas estáticas predeterminadas se utilizan comúnmente al conectar un router perimetral a una red de proveedor de servicios, o un router stub (un router con solo un router vecino ascendente).


Ruta Estática Predeterminada: La sintaxis del comando para una ruta estática predeterminada IPv4 es similar a cualquier otra ruta estática IPv4, con la excepción de que la dirección de red es 0.0.0.0 y la máscara de subred es 0.0.0.0. 0.0.0.0 0.0.0.0 en la ruta coincidirá con cualquier dirección de red. 

> Nota: una ruta estática predeterminada IPv4 suele llamarse “ruta de cuádruple cero”.

    Router(config)# ip route 0.0.0.0 0.0.0.0 {ip-address | exit-intf}
    Router (config) # ipv6 route ::/0 {ipv6-address | exit-intf}


El ejemplo muestra una ruta estática predeterminada IPv4 configurada en R1. Con la configuración del ejemplo, cualquier paquete que no coincida con entradas más específicas de la ruta se reenvía a 172.16.2.2.

    R1 (config) # ip route 0.0.0.0 0.0.0.0 172.16.2.2
    
Una ruta estática predeterminada IPv6 se configura de manera similar. Con esta configuración, cualquier paquete que no coincida con entradas más específicas de la ruta IPv6 se reenvía a R2 al 2001:db8:acad:2::2

    R1 (config) # ipv6 route ::/0 2001:db8:acad:2::2

## Configurar Rutas Estáticas Flotantes

Otro tipo de ruta estática es una ruta estática flotante. Las rutas estáticas flotantes son rutas estáticas que se utilizan para proporcionar una ruta de respaldo a una ruta estática o dinámica principal, en el caso de una falla del enlace. La ruta estática flotante se utiliza únicamente cuando la ruta principal no está disponible.

Para lograrlo, la ruta estática flotante se configura con una distancia administrativa mayor que la ruta principal. La distancia administrativa representa la confiabilidad de una ruta. Si existen varias rutas al destino, el router elegirá la que tenga una menor distancia administrativa.

De manera predeterminada, las rutas estáticas tienen una distancia administrativa de 1, lo que las hace preferibles a las rutas descubiertas mediante protocolos de routing dinámico. 

La distancia administrativa de una ruta estática se puede aumentar para hacer que la ruta sea menos deseable que la ruta de otra ruta estática o una ruta descubierta mediante un protocolo de routing dinámico. De esta manera, la ruta estática “flota” y no se utiliza cuando está activa la ruta con la mejor distancia administrativa. 

    R1(config)# ip route 0.0.0.0 0.0.0.0 10.10.10.2 5 
    R1 (config)# ipv6 route ::/0 2001:db8:feed:10::2 5

## Configurar de Rutas de Host Estáticas

Una ruta de host es una dirección IPv4 con una máscara de 32 bits o una dirección IPv6 con una máscara de 128 bits. A continuación, se muestra tres maneras de agregar una ruta de host a una tabla de routing:

- Instalarla automáticamente cuando se configura una dirección IP en el router.
- Configurarla como una ruta de host estático.
- Obtener la ruta de host automáticamente a través de otros métodos (se analiza en cursos posteriores).

### Rutas de Host Instaladas Automáticamente

El IOS de Cisco instala automáticamente una ruta de host, también conocida como ruta de host local, cuando se configura una dirección de interfaz en el router. Una ruta host permite un proceso más eficiente para los paquetes que se dirigen al router mismo, en lugar del envío de paquetes. 

Esto se suma a la ruta conectada, designada con una C en la tabla de enrutamiento para la dirección de red de la interfaz.

Las rutas locales se marcan con L en el resultado de la tabla de enrutamiento.

### Rutas Estaticas de Host

Una ruta de host puede ser una ruta estática configurada manualmente para dirigir el tráfico a un dispositivo de destino específico, como un servidor de autenticación. La ruta estática utiliza una dirección IP de destino y una máscara 255.255.255.255 (/32) para las rutas de host IPv4 y una longitud de prefijo /128 para las rutas de host IPv6.

    Branch(config)# ip route 209.165.200.238 255.255.255.255 198.51.100.2
    Branch(config)# ipv6 route 2001:db8:acad:2::238/128 2001:db8:acad:1::2





