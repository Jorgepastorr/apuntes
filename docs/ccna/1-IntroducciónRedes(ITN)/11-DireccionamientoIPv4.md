# Direccionamiento IPv4

## Estructura de direcciones IPv4

Una dirección IPv4 es una dirección jerárquica de 32 bits que se compone de una porción de red y una porción de host. 

Se utiliza una máscara de subred para determinar las porciones de red y host. 


### mascara de subred

El proceso real utilizado para identificar las porciones de red y host se llama ANDing.

    192     . 168    . 10      .    | 10    
    11000000  1010100  00001010       00001010

    255     . 255    . 255     .    | 0
    11111111  1111111  11111111       00000000

### longitud de prefijo

| mascara         | direccion de 32 bits                | prefijo |
| :-------------- | :---------------------------------- | :------ |
| 255.255.255.0   | 11111111.11111111.11111111.00000000 | /24     |
| 255.255.255.128 | 11111111.11111111.11111111.10000000 | /25     |
| 255.255.255.192 | 11111111.11111111.11111111.11000000 | /26     |
| 255.255.255.224 | 11111111.11111111.11111111.11100000 | /27     |
| 255.255.255.240 | 11111111.11111111.11111111.11110000 | /28     |
| 255.255.255.248 | 11111111.11111111.11111111.11111000 | /29     |
| 255.255.255.252 | 11111111.11111111.11111111.11111100 | /30     |


### Determinación de la red: AND lógica

Una operación lógica AND booleana se utiliza para determinar la dirección de red.

Y lógico es la comparación de dos bits donde sólo un 1 AND 1 produce un 1 y cualquier otra combinación resulta en un 0.

    192     . 168    . 10      .    | 10        IPv4 host
    11000000  1010100  00001010       00001010

    255     . 255    . 255     .    | 0         Mascara
    11111111  1111111  11111111       00000000

    ------------------------------------------

    11000000  1010100  00001010   
    RED : 192.168.10.0

Ahora un caso un poco mas complicado

    192     . 168    . 10      .    | 130        IPv4 host
    11000000  1010100  00001010       10000010

    255     . 255    . 255     .    | 240       Mascara
    11111111  1111111  11111111       11110000

    ------------------------------------------

    11000000  1010100  00001010       10000000
    RED : 192.168.10.128


## IPv4 Unicast, Broadcast, y Multicast

La transmisión **Unicast** está enviando un paquete a una dirección IP de destino.

La transmisión de **Broadcast** está enviando un paquete a todas las demás direcciones IP de destino.

La transmisión de **multicast** está enviando un paquete a un grupo de direcciones de multicast.

- Por ejemplo, el PC en 172.16.4.1 envía un paquete de multicast a la dirección del grupo de multicast 224.10.10.5.
- Multicast tiene reservado el rango de IP  224.0.0.0 hasta 239.255.255.255

## Tipos de direcciones IPv4

### Direcciones IPv4 públicas y privadas

Como se define en RFC 1918, las direcciones IPv4 públicas se enrutan globalmente entre routers de proveedores de servicios de Internet (ISP). 

Las direcciones privadas son bloques comunes de direcciones utilizadas por la mayoría de las organizaciones para asignar direcciones IPv4 a hosts internos.


| Prefijo | Rango direcciones privadas de RFC 1918 |
| :------ | :------------------------------------- ||
| 10.0.0.0/8     | 10.0.0.0 a 10.255.255.255              |
| 172.16.0.0/12  | 172.16.0.0 a 172.31.255.255            |
| 192.168.0.0/16 | 192.168.0.0 a 192.168.255.255          |

Los siguientes rangos estan reservados:

- Loopback 127.0.0.0/8 (de 127.0.0.1 a 127.255.255.254) 
- direccion enlace local 169.254.0.0/16 (de 169.254.0.1 a 169.254.255.255)
  - Usado por los clientes DHCP de Windows para autoconfigurarse cuando no hay servidores DHCP disponibles.

### Enrutamiento a Internet

La traducción de direcciones de red (NAT) traduce las direcciones IPv4 privadas a direcciones IPv4 públicas.

Traduce la dirección privada interna a una dirección IP global pública.



### Direccionamiento con clase Legacy

| Clase | Rango válido del Primer Octeto | Redes válidas                     |
| :---- | :----------------------------- | :-------------------------------- |
| A     | 0 a 126                        | 0.0.0.1/8 a 126.255.255.255/8     |
| B     | 128 a 191                      | 128.0.0.0/16 a 191.255.255.255/16 |
| C     | 192 a 223                      | 192.0.0.0/24 a 223.255.255.255/24 |
| D     | 224 a 239                      | 224.0.0.0 a 239.0.0.0             |
| E     | 240 a 255                      | 240.0.0.0 a 255.0.0.0             |

Los siguientes rangos estan reservados:

- Reservado 0.0.0.0/8 (de 0.0.0.0 a 0.255.255.255)
- Reservado 127.0.0.0/8 (de 127.0.0.0 a 127.255.255.255)

La asignación de direcciones con clase se reemplazó con direccionamiento sin clase que ignora las reglas de las clases (A, B, C). 

## Subnetear una red IPv4

### División en subredes en el límite del octeto

Consulte la tabla para ver seis formas de subred una red /24.

| Prefijo | mascara         | mascara en binario                  | subredes | hosts |
| :------ | :-------------- | :---------------------------------- | :------- | :---- |
| /25     | 255.255.255.128 | 11111111.11111111.11111111.10000000 | 2        | 126   |
| /26     | 255.255.255.192 | 11111111.11111111.11111111.11000000 | 4        | 62    |
| /27     | 255.255.255.224 | 11111111.11111111.11111111.11100000 | 8        | 30    |
| /28     | 255.255.255.240 | 11111111.11111111.11111111.11110000 | 16       | 14    |
| /29     | 255.255.255.248 | 11111111.11111111.11111111.11111000 | 32       | 6     |
| /30     | 255.255.255.252 | 11111111.11111111.11111111.11111100 | 64       | 2     |

## Subred para cumplir requisitos

Existen dos factores que se deben tener en cuenta al planificar las subredes: 

- El número de direcciones de host requeridas para cada red 
- El número de subredes individuales necesarias

### Ejemplo:

En este ejemplo, su ISP ha asignado una dirección de red pública de 172.16.0.0/22 (10 bits de host) a su sede central que proporciona 1.022 direcciones de host.

Hay cinco sitios y, por lo tanto, cinco conexiones a Internet, lo que significa que la organización requiere 10 subredes con la subred más grande requiere 40 direcciones.

Asignó 10 subredes con una máscara de subred /26 (es decir, 255.255.255.192).

## VLSM

La aplicación de un esquema de división en subredes tradicional a esta situación no resulta muy eficiente y genera desperdicio.

VLSM fue desarrollado para evitar el desperdicio de direcciones al permitirnos subred una subred.

Cuando utilice VLSM, comience siempre por satisfacer los requisitos de host de la subred más grande y continúe la subred hasta que se cumplan los requisitos de host de la subred más pequeña.

### Ejemplo:

De la red `192.168.72.0/24` tenemos que extraer 5 redes con diferentes host en cada una:

| host necesarios | red  | mascara | host disponibles |
| :-------------- | :--- | :------ | :--------------- |
| 58              |      |         |                  |
| 29              |      |         |                  |
| 15              |      |         |                  |
| 7               |      |         |                  |
| 2               |      |         |                  |

Calculos para extraer las redes necesarias

    192.168.72.0 /26
        192.168.72.0 /26 60 host disponibles para Red de 58 hosts

    192.168.72.64 /26
        192.168.72.64 /27 30 host disponibles para Red de 29 hosts
        192.168.72.96 /27 30 host disponibles para Red de 15 hosts

    192.168.72.128 /26
        192.168.72.128 /28 14 host disponibles para Red de 7 hosts
        192.168.72.144 /28
            192.168.72.144 /30 2 host disponibles para Red de 2 hosts

    # Las siguientes redes quedan disponibles:
            192.168.72.148 /30
            192.168.72.152 /30
            192.168.72.156 /30

        192.168.72.160 /28
        192.168.72.176 /28

    192.168.72.192 /26


Tabla completa

| host necesarios | red            | mascara | host disponibles   |
| :-------------- | :------------- | :------ | :----------------- |
| 58              | 192.168.72.0   | /26     | 60 desde 1 - 62    |
| 29              | 192.168.72.64  | /27     | 30 desde 65 - 94   |
| 15              | 192.168.72.96  | /27     | 30 desde 97 - 126  |
| 7               | 192.168.72.128 | /28     | 14 desde 129 - 142 |
| 2               | 192.168.72.144 | /30     | 2  desde 145 - 146 |
