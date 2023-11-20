# Capa de transporte

## Transporte de datos

La capa de transporte es responsable de las comunicaciones lógicas entre aplicaciones que se ejecutan en diferentes hosts.
También es el enlace entre la capas de aplicación y las capas inferiores que se encargan de la transmisión a través de la red.


### Tareas de la capa de transporte

La capa de transporte tiene las siguientes responsabilidades:

- Seguimiento de conversaciones individuales
- Segmentación de datos y rearmado de segmentos
- Agregar información de encabezado
- Identificar, separar y administrar múltiples conversaciones
- Utiliza segmentación y multiplexación para permitir que diferentes conversaciones de comunicación se intercalen en la misma red

### Protocolos de la capa de transporte

IP no especifica la manera en que se lleva a cabo la entrega o el transporte de los paquetes.

Los protocolos de capa de transporte especifican cómo transferir mensajes entre hosts y son responsables de administrar los requisitos de fiabilidad de una conversación.

La capa de transporte incluye los protocolos **TCP y UDP**.


### Transmission Control Protocol (TCP)

TCP provee confiabilidad y control de flujo Operaciones básicas TCP:

- Numere y rastree segmentos de datos transmitidos a un host específico desde una aplicación específica
- Confirmar datos recibidos (ACK)
- Vuelva a transmitir cualquier información no reconocida después de un cierto período de tiempo
- Datos de secuencia que pueden llegar en un orden incorrecto
- Enviar datos a una velocidad eficiente que sea aceptable por el receptor

### Protocolo de datagramas de usuario de datos (UDP)

El UDP proporciona las funciones básicas para entregar segmentos de datos entre las aplicaciones adecuadas, con muy poca sobrecarga y revisión de datos.

UDP es un protocolo sin conexión. 

UDP también se conoce como un protocolo de entrega de mejor esfuerzo porque no hay reconocimiento de que los datos se reciben en el destino.

## Descripción general de TCP

**Establece una sesión:** TCP es un protocolo orientado a la conexión que negocia y establece una conexión permanente (o sesión) entre los dispositivos de origen y destino antes de reenviar cualquier tráfico.

**Garantiza una entrega confiable:** Por muchas razones, es posible que un segmento se corrompa o se pierda por completo, ya que se transmite a través de la red. TCP asegura que cada segmento que envía la fuente llega al destino.

**Proporciona entrega en el mismo pedido:** Debido a que las redes pueden proporcionar múltiples rutas que pueden tener diferentes velocidades de transmisión, los datos pueden llegar en el orden incorrecto. 

**Admite control de flujo:** los hosts de red tienen recursos limitados (es decir, memoria y potencia de procesamiento). Cuando TCP advierte que estos recursos están sobrecargados, puede solicitar que la aplicación emisora reduzca la velocidad del flujo de datos. 

### Campos de encabezado TCP

| Campo de Encabezado TCP   | Descripción                                                                                                                   |
| :------------------------ | :---------------------------------------------------------------------------------------------------------------------------- |
| Puerto de Origen          | Campo de 16 bits utilizado para identificar la aplicación de origen por número de puerto.                                     |
| Puerto de Destino         | Un campo de 16 bits utilizado para identificar la aplicación de destino por puerto número.                                    |
| Números de Secuencia      | Campo de 32 bits utilizado para reensamblar datos.                                                                            |
| Número de Acuse de Recibo | Un campo de 32 bits utilizado para indicar que se han recibido datos y el siguiente byte esperado de la fuente.               |
| Longitud del Encabezado   | Un campo de 4 bits conocido como «desplazamiento de datos» que indica la propiedad longitud del encabezado del segmento TCP.  |
| Reservado                 | Un campo de 6 bits que está reservado para uso futuro.                                                                        |
| Bits de Control           | Un campo de 6 bits utilizado que incluye códigos de bits, o indicadores, que indican el propósito y función del segmento TCP. |
| Tamaño de la ventana      | Un campo de 16 bits utilizado para indicar el número de bytes que se pueden aceptar a la vez.                                 |
| Suma de Comprobación      | A 16-bit field used for error checking of the segment header and data.                                                        |
| Urgente                   | Campo de 16 bits utilizado para indicar si los datos contenidos son urgentes.                                                 |


## Visión general de UDP

Las características UDP incluyen lo siguiente:

- Los datos se reconstruyen en el orden en que se recibieron.
- Los segmentos perdidos no se vuelven a enviar.
- No hay establecimiento de sesión.
- El envío no está informado sobre la disponibilidad de recursos.

### Campos de Encabezado UDP

| Campo de Encabezado UDP | Descripción                                                                                          |
| :---------------------- | :--------------------------------------------------------------------------------------------------- |
| Puerto de Origen        | Campo de 16 bits utilizado para identificar la aplicación de origen por número de puerto.            |
| Puerto de Destino       | Un campo de 16 bits utilizado para identificar la aplicación de destino por puerto número.           |
| Longitud                | Campo de 16 bits que indica la longitud del encabezado del datagrama UDP.                            |
| Suma de comprobación    | Campo de 16 bits utilizado para la comprobación de errores del encabezado y los datos del datagrama. |

## Números de puerto

Los protocolos de capa de transporte TCP y UDP utilizan números de puerto para administrar múltiples conversaciones simultáneas.

El número de puerto de origen está asociado con la aplicación de origen en el host local, mientras que el número de puerto de destino está asociado con la aplicación de destino en el host remoto.

### Pares de sockets

Los puertos de origen y de destino se colocan dentro del segmento.

Los segmentos se encapsulan dentro de un paquete IP.

Se conoce como socket a la combinación de la dirección IP de origen y el número de puerto de origen, o de la dirección IP de destino y el número de puerto de destino.

Los sockets permiten que los diversos procesos que se ejecutan en un cliente se distingan entre sí. También permiten la diferenciación de diferentes conexiones a un proceso de servidor.

### Grupos de números de puerto

Los 16 bits utilizados para identificar los números de puerto de origen y destino proporcionan un rango de puertos entre 0 y 65535.

Puertos bien conocidos 0 to 1.023

- Estos números de puerto están reservados para servicios comunes o populares y aplicaciones como navegadores web, clientes de correo electrónico y acceso remoto clientes.
- Los puertos conocidos definidos para aplicaciones de servidor comunes permiten para identificar fácilmente el servicio asociado requerido.

Puertos registrados 1.024 to 49.151

- Estos números de puerto son asignados por IANA a una entidad solicitante a utilizar con procesos o aplicaciones específicos.
- Estos procesos son principalmente aplicaciones individuales que un usuario ha elegido instalar, en lugar de aplicaciones comunes que recibir un número de puerto conocido.
- Por ejemplo, Cisco ha registrado el puerto 1812 para su servidor RADIUS proceso de autenticación

Puertos privados o dinamicos 49.152 to 65.535

- Estos puertos también se conocen como puertos efímeros.
- El sistema operativo del cliente generalmente asigna números de puerto dinámicamente cuando se inicia una conexión a un servicio.
- El puerto dinámico se utiliza para identificar la aplicación del cliente. durante la comunicación

## Proceso de comunicación en TCP

### Análisis del protocolo TCP de enlace de tres vías

Funciones del enlace de tres vías:

- Establece que el dispositivo de destino está presente en la red.
- Verifica que el dispositivo de destino tenga un servicio activo y acepte solicitudes en el número de puerto de destino que el cliente de origen desea utilizar.
- Informa al dispositivo de destino que el cliente de origen intenta establecer una sesión de comunicación en dicho número de puerto

Una vez que se completa la comunicación, se cierran las sesiones y se finaliza la conexión. Los mecanismos de conexión y sesión habilitan la función de confiabilidad de TCP.

Los seis indicadores de bits de control son los siguientes:

| indicador | descripcion                                                                                                |
| :--------- | :--------------------------------------------------------------------------------------------------------- |
| URG        | Campo indicador urgente importante.                                                                        |
| ACK        | Indicador de acuse de recibo utilizado en el establecimiento de la conexión y la terminación de la sesión. |
| PSH        | Función de empuje.                                                                                         |
| RST        | Restablecer una conexión cuando ocurre un error o se agota el tiempo de espera.                            |
| SYN        | Sincronizar números de secuencia utilizados en el establecimiento de conexión.                             |
| FIN        | No más datos del remitente y se utilizan en la terminación de la session.                                  |

## Confiabilidad y control de flujo

### Pérdida y retransmisión de datos

No importa cuán bien diseñada esté una red, ocasionalmente se produce la pérdida de datos.

TCP proporciona métodos para administrar la pérdida de segmentos. Entre estos está un mecanismo para retransmitir segmentos para los datos sin reconocimiento.

Los sistemas operativos host actualmente suelen emplear una característica TCP opcional llamada reconocimiento selectivo (SACK), negociada durante el protocolo de enlace de tres vías.

Si ambos hosts admiten SACK, el receptor puede reconocer explícitamente qué segmentos (bytes) se recibieron, incluidos los segmentos discontinuos.

### tamaño de la ventana y reconocimientos

El TCP también proporciona mecanismos de control de flujo.

El control de flujo es la cantidad de datos que el destino puede recibir y procesar de manera confiable.

El control de flujo permite mantener la confiabilidad de la transmisión de TCP mediante el ajuste de la velocidad del flujo de datos entre el origen y el destino para una sesión dada.

### tamaño máximo de segmento

Tamaño máximo de segmento (MSS) es la cantidad máxima de datos que puede recibir el dispositivo de destino.

Un MSS común es de 1.460 bytes cuando se usa IPv4.

Un host determina el valor de su campo de MSS restando los encabezados IP y TCP de unidad máxima de transmisión (MTU) de Ethernet. 

1500 menos 60 (20 bytes para el encabezado IPv4 y 20 bytes para el encabezado TCP) deja 1460 bytes.
 

## Comunicación UDP

UDP no establece ninguna conexión. UDP suministra transporte de datos con baja sobrecarga debido a que posee un encabezado de datagrama pequeño sin tráfico de administración de red.

### Rearmado de datagramas UDP

UDP no realiza un seguimiento de los números de secuencia de la manera en que lo hace TCP.

UDP no puede reordenar los datagramas en el orden de la transmisión.

UDP simplemente reensambla los datos en el orden en que se recibieron y los envía a la aplicación.

### Procesos de cliente UDP

El proceso de cliente UDP selecciona dinámicamente un número de puerto del intervalo de números de puerto y lo utiliza como puerto de origen para la conversación.

Por lo general, el puerto de destino es el número de puerto bien conocido o registrado que se asigna al proceso de servidor.

Una vez que el cliente selecciona los puertos de origen y de destino, este mismo par de puertos se utiliza en el encabezado de todos los datagramas que se utilizan en la transacción.