# Protocolos y modelos

Opciones de entrega de un mensaje

La entrega de mensajes puede ser uno de los métodos siguientes: 

- Unidifusión – comunicación uno a uno.
- Multidifusión – de uno a muchos, normalmente no todos los
- Difusión — uno para todos (broadcast)

> **Nota:** Las transmisiones se utilizan en redes IPv4, pero no son una opción para IPv6. Más adelante también veremos `Anycast` como una opción de entrega adicional para IPv6. 

## Protocolos

### Funciones de protocolo de red

|          Funcion          |                          Descripción                           |
| :-----------------------: | :------------------------------------------------------------: |
|     Direccionamiento      |             Un emisor y un receptor identificados              |
|         Confianza         |                Proporciona entrega garantizada.                |
|     Control de flujo      |      Garantiza flujos de datos a una velocidad eficiente       |
|       Secuenciación       | Etiqueta de forma exclusiva cada segmento de datos transmitido |
|   Detección de errores    |    Determina si los datos se dañaron durante la transmisión    |
| Interfaz de la aplicación | Comunicaciones de proceso a proceso entre aplicaciones de red  |

### Interacción de protocolos

Protocolo de transferencia de hipertexto (HTTP)
- Rige la manera en que interactúan un servidor web y un cliente
- Define el contenido y el formato

Protocolo de control de transmisión (TCP)
- Seguimiento de conversaciones individuales
- Proporciona entrega garantizada.
- Administra el control de flujo

Protocolo de Internet (IP)
- Entrega mensajes globalmente desde el remitente al receptor 
  
Ethernet
- Entrega mensajes de una NIC a otra NIC en la misma red de área local (LAN) Ethemet


## Suites de protocolos

Hay varios conjuntos de protocolos.

- Suite de protocolos de Internet o TCP / IP - El conjunto de protocolos más común y mantenido por Internet Engineering Task Force (IETF)
- Protocolos de interconexión de sistemas abiertos (OSI) - Desarrollados por la Organización Internacional de Normalización (ISO) y la Unión Internacional de Telecomunicaciones (UIT)
- AppleTalk - Lanzamiento de la suite propietaria por Apple Inc.
- Novell NetWare - Suite propietaria desarrollada por Novell Inc.


## Modelos de referencia

### Capas de aplicación OSI i TCP/IP

| numeno |    Model OSI    |   Model TCP/IP   | Datos relativos |
| :----: | :-------------: | :--------------: | :-------------: |
|   7    |    Aplicació    |    Aplicacio     |                 |
|   6    |   Presentacio   |                  |                 |
|   5    |      Sesio      |                  |                 |
|   4    |    Transport    |    Transport     | Puerto software |
|   3    |       Red       |     Internet     |      IPv*       |
|   2    | Enllaç de dades | Acces a la xarxa |       MAC       |
|   1    |     Fisica      |                  |  Puerto fisico  |



capa del modelo OSI

7. Aplicación: Contiene protocolos utilizados para comunicaciones proceso a proceso.
6. Presentación: Proporciona una representación común de los datos transferidos entre los servicios de la capa de aplicación.
5. Sesión: Proporciona servicios a la capa de presentación y administrar el intercambio de datos.
4. Transporte: define los servicios para segmentar, transferir y reensamblar los datos para las comunicaciones individuales.
3. Red: proporciona servicios para intercambiar las porciones de datos individuales en la red.
2. Enlace de datos: describe métodos para intercambiar marcos de datos entre dispositivos en un medio común.
1. Física: Describe los medios para activar, mantener y desactivar las conexiones físicas.​

### Funcio model TCP/IP

|       Capa       |     Protocol     |   Tipo de dato    |
| :--------------: | :--------------: | :---------------: |
|    Aplicació     | http/s, ftp, ... |       Dades       |
|    Transport     |     TCP/UDP      | Segment/Datagrama |
|     Internet     |        IP        |      Paquet       |
| Acces a la xarxa |     Ethernet     |       Trama       |


Capa del modelo TCP/IP

- Aplicación: Representa datos para el usuario más el control de codificación y de diálogo. 
- Transporte: Admite la comunicación entre distintos dispositivos a través de diversas redes.
- Internet: Determina el mejor camino a través de una red.
- Acceso a la red: Controla los dispositivos del hardware y los medios que forman la red.


## Encapsulamiento de datos

### Segmentación del mensaje

- aumenta la velocidad: se pueden enviar grandes cantidades de datos a través de la red sin atar un enlace de comunicaciones. 
- Aumenta la eficiencia: solo los segmentos que no llegan al destino necesitan ser retransmitidos, no todo el flujo de datos. 

### secuenciación

La secuenciación de mensajes es el proceso de numerar los segmentos para que el mensaje pueda volver a ensamblarse en el destino.

TCP es responsable de secuenciar los segmentos individuales.

### Unidades de datos del protocolo

En cada etapa del proceso, una PDU tiene un nombre distinto para reflejar sus funciones nuevas. 

Las PDU que pasan por la pila son las siguientes:

1. Datos (corriente de datos). 
2. Segmento. (Transporte 4)
3. Paquete.  (Red 3)
4. Trama.   (enlace de datos 2)
5. Bits (secuencia de bits). (fisica 1)


## Acceso a datos

### Dirección lógica de capa 3

Los paquetes IP contienen dos direcciones IP que no se modificaran en todo el viaje
- IP origen: ip del dispositivo emisor
- IP destino: ip del dispositivo receptor final 

Un paquete IP contiene dos partes:
- Parte de red (IPv4) o Prefijo (IPv6)
- Parte del host (IPv4) o ID de interfaz (IPv6)

### Rol de las direcciones de la capa de enlace de datos. capa 2

Cuando los dispositivos están en la misma red Ethernet, el marco de enlace de datos utilizará la dirección MAC real de la NIC de destino.

Cuando los dispositivos estan en redes diferentes, inicialmente estarán las mac de origen y puerta de enlace, una vez el paquete se enrute al exterior las MAC cambiaran a las MAC de los dispositivos correspondientes.

