# Conceptos de OSPFv2 de área única

## Características y funciones de OSPF

### Introducción a OSPF

El protocolo OSPF  es un protocolo de routing de estado de enlace desarrollado como alternativa del protocolo de routing por vector de distancias, RIP. OSPF presenta ventajas importantes en comparación con RIP, ya que ofrece una convergencia más rápida y escala a implementaciones de red mucho más grandes.

OSPF es un protocolo de routing sin clase que utiliza el concepto de áreas para realizar la escalabilidad. Un administrador de red puede dividir el dominio de enrutamiento en áreas distintas que ayudan a controlar el tráfico de actualización de enrutamiento. 

Un vínculo es una interfaz de un router, un segmento de red que conecta dos routers o una red auxiliar, como una LAN Ethernet conectada a un único router. 

La información acerca del estado de dichos enlaces se conoce como estados de enlace. Toda la información del estado del vínculo incluye el prefijo de red, la longitud del prefijo y el costo.

### funciones de OSPF

Todos los protocolos de routing comparten componentes similares. Todos usan mensajes de protocolo de routing para intercambiar información de la ruta. Los mensajes contribuyen a armar estructuras de datos, que luego se procesan con un algoritmo de routing.

Los routers que ejecutan OSPF intercambian mensajes para transmitir información de routing por medio de cinco tipos de paquetes.

- Paquete de saludo
- Paquete de descripción de la base de datos
- Paquete de solicitud de estado de enlace
- Paquete de actualización de estado de enlace
- Paquete de acuse de recibo de estado de enlace

Estos paquetes se usan para descubrir routers vecinos y también para intercambiar información de routing a fin de mantener información precisa acerca de la red.

### Componentes de OSPF

Los mensajes OSPF se utilizan para crear y mantener tres bases de datos OSPF, como se indica a continuación

#### Base de datos de adyacencia

Tabla de vecinos

- Lista de todos los routers vecinos con los que un router estableció comunicación bidireccional.
- Esta tabla es única para cada router.
- Se puede ver con el comando show ip ospf neighbor

#### Base de datos de estado de enlace (LSDB)

Tabla de topología

- Muestra información sobre todos los otros routers en la red.
- Esta base de datos representa la topología de la red.
- Todos los routers dentro de un área tienen LSDB idénticas.
- Se puede ver con elcomando show ip ospf database

#### Base de datos de reenvío

Tabla de routing

- Lista de rutas generada cuando se ejecuta un algoritmo en la base de datos de estado de enlace.
- La tabla de routing de cada router es única y contiene información sobre cómo y dónde enviar paquetes para otros routers.
- Se puede ver con el comando show ip route.

--- 

El router arma la tabla de topología; para ello, utiliza los resultados de cálculos realizados a partir del algoritmo SPF (Primero la ruta más corta) de Dijkstra. El algoritmo SPF se basa en el costo acumulado para llegar a un destino.

El algoritmo SPF crea un árbol SPF posicionando cada router en la raíz del árbol y calculando la ruta más corta hacia cada nodo. Luego, el árbol SPF se usa para calcular las mejores rutas. OSPF coloca las mejores rutas en la base de datos de reenvío, que se usa para crear la tabla de routing.

### Operación Link-State

A fin de mantener la información de routing, los routers OSPF realizan el siguiente proceso genérico de routing de estado de enlace para alcanzar un estado de convergencia: Los siguientes son los pasos de enrutamiento de estado de vínculo que completa un router:

1. Establecimiento de adyacencias de vecinos
1. Intercambio de anuncios de estado de enlace
1. Crear la base de datos de estado de vínculo
1. Ejecución del algoritmo SPF
1. Elija la mejor ruta

### Área única y multiárea OSPF

Para que OSPF sea más eficaz y escalable, este protocolo admite el routing jerárquico mediante áreas. Un área OSPF es un grupo de routers que comparten la misma información de estado de enlace en sus LSDB. El OSPF se puede implementar de una de estas dos maneras:

- **OSPF de área única:** todos los routers están en un área. La mejor práctica es usar el área 0. 
- **Multiarea OSPF:**  OSPF se implementa mediante varias áreas, de manera jerárquica. Todas las áreas deben conectarse al área troncal (área 0). Los routers que interconectan las áreas se denominan “routers fronterizos de área” (ABR).

### Multiarea OSPF

Las opciones de diseño de topología jerárquica con OSPF multiárea pueden ofrecer estas ventajas:

Tablas de enrutamiento más pequeñas: las tablas son más pequeñas porque hay menos entradas de tabla de enrutamiento. Esto se debe a que las direcciones de red se pueden resumir entre áreas. La sumarización de ruta no está habilitada de manera predeterminada.

Sobrecarga de actualizaciones de estado de enlace reducida: el diseño de OSPF multiárea con áreas más pequeñas minimiza el procesamiento y los requisitos de memoria.

Menor frecuencia de cálculos de SPF: Multiarea OSPF localiza el impacto de un cambio de topología dentro de un área. Por ejemplo, minimiza el impacto de las actualizaciones de routing debido a que la saturación con LSA se detiene en el límite del área.

### OSPFv3

OSPFv3 es el equivalente a OSPFv2 para intercambiar prefijos IPv6. OSPFv3 intercambia información de routing para completar la tabla de routing de IPv6 con prefijos remotos.

> Nota: con la característica de familias de direcciones de OSPFv3, esta versión del protocolo es compatible con IPv4 e IPv6. En este currículo no se hablará de familias de direcciones de OSPF.

OSPFv3 tiene la misma funcionalidad que OSPFv2, pero utiliza IPv6 como transporte de la capa de red, por lo que se comunica con peers OSPFv3 y anuncia rutas IPv6. OSPFv3 también utiliza el algoritmo SPF como motor de cómputo para determinar las mejores rutas a lo largo del dominio de routing.

OSPFv3 tiene procesos diferentes de los de su equivalente de IPv4. Los procesos y las operaciones son básicamente los mismos que en el protocolo de routing IPv4, pero se ejecutan de forma independiente. 

## Paquetes de OSPF

La tabla resume los cinco tipos diferentes de paquetes de estado de enlace (LSP) utilizados por OSPFv2. OSPFv3 tiene tipos de paquetes similares.

| Tipo | nombre paquete                              | descripcion                                                           |
| :--- | :------------------------------------------ | :-------------------------------------------------------------------- |
| 1    | saludo                                      | Descubre los vecinos y construye adyacencias entre ellos              |
| 2    | Descriptores de bases de datos (DBD)        | Controla la sincronización de bases de datos entre routers.           |
| 3    | Solicitud de link-state (LSR)               | Solicita registros específicos de estado de enlace de router a router |
| 4    | Actualización de link-state (LSU)           | Envía los registros de estado de enlace específicamente solicitados   |
| 5    | Acuse de recibo de estado de enlace (LSAck) | Reconoce los demás tipos de paquetes                                  |


### Actualizaciones de estado de enlace

Los paquetes LSU también se usan para reenviar actualizaciones de routing OSPF. Un paquete LSU puede contener 11 tipos de LSA OSPFv2 OSPFv3 cambió el nombre de varias de estas LSA y también contiene dos LSA adicionales.

LSU y LSA a menudo se utilizan indistintamente, pero la jerarquía correcta es que los paquetes LSU contienen mensajes LSA.

### Paquete de saludo

El paquete OSPF de tipo 1 es el paquete de saludo. Los paquetes Hello se utilizan para hacer lo siguiente:

- Descubrir vecinos OSPF y establecer adyacencias de vecinos.
- Publicar parámetros en los que dos routers deben acordar convertirse en vecinos.
- Elige el router designado (DR) y el router designado de respaldo (BDR) en redes multiacceso, como Ethernet. Los enlaces punto a punto no requieren DR o BDR.


## Funcionamiento de OSPF

### Estados operativos de OSPF

Estado inactivo:

- Ningún paquete de saludo recibido = Down.
- El router envía paquetes de saludo.
- Transición al estado Init.

Estado Init

- Se reciben los paquetes de saludo del vecino.
- Estos contienen la ID del router emisor.
- Transición al estado Two-Way.

Estado Two-Way

- En este estado, la comunicación entre los dos routers es bidireccional.
- En los enlaces de acceso múltiple, los routers eligen una DR y una BDR.
- Transición al estado ExStart.

Estado ExStart

- En redes punto a punto, los dos routers deciden qué router iniciará el intercambio de paquetes DBD y deciden sobre el número de secuencia de paquetes DBD inicial.

Estado Intercambio

- Los routers intercambian paquetes DBD.
- Si se requiere información adicional del router, se realiza la transición a Loading; de lo contrario, - se realiza la transición al estado Full.

Estado Loading

- Las LSR y las LSU se usan para obtener información adicional de la ruta.
- Las rutas se procesan mediante el algoritmo SPF.
- Transición al estado Full.

Estado Full

- La base de datos de estado de vínculo del router está completamente sincronizada.


### Establecimiento de adyacencias de vecinos

Para determinar si hay un vecino OSPF en el vínculo, el router envía un paquete Hello que contiene su ID de router fuera de todas las interfaces habilitadas para OSPF. El paquete Hello se envía a la dirección de multidifusión IPv4 `224.0.0.5` reservada - Todos los routers OSPF. Sólo los enrutadores OSPFv2 procesarán estos paquetes. 

El proceso OSPF utiliza la ID del router OSPF para identificar cada router en el área OSPF de manera exclusiva. La ID de router es un número de 32 bits con formato similar a una dirección IP que se asigna para identificar un router de forma exclusiva entre pares OSPF.

Cuando un router vecino con OSPF habilitado recibe un paquete de saludo con una ID de router que no figura en su lista de vecinos, el router receptor intenta establecer una adyacencia con el router que inició la comunicación.


### Sincronización de las bases de datos OSPF

Después del estado Two-Way, los routers pasan a los estados de sincronización de bases de datos. Este es un proceso de tres pasos, como sigue:

- Decidir primer router: el router con el ID de router más alto envía su DBD primero.
- DBDs de Exchange: tantos como sea necesario para transmitir la base de datos. El otro router debe reconocer cada DBD con un paquete LSack.
- Enviar un LSR: Cada router compara la información DBD con el LSDB local. Si el paquete DBD tiene una entrada de estado de enlace más actual, el router pasa al estado Loading.

Después de cumplir con todas las LSR para un router determinado, los routers adyacentes se consideran sincronizados y en estado Full. Se envían actualizaciones (LSU):

- Cuando se percibe un cambio (actualizaciones incrementales).
- Cada 30 minutos.

### LSA Inundación con DR

Un aumento en el número de routers en una red multiacceso también aumenta el número de LSA intercambiados entre los routers. Esta inundación de LSA afecta significativamente el funcionamiento de OSPF.

Si cada router en una red multiacceso tuviera que saturar y reconocer todas las LSA recibidas a todos los demás routers en la misma red multiacceso, el tráfico de la red se volvería bastante caótico.

En las redes multiacceso, OSPF elige un DR como punto de recolección y distribución de las LSA enviadas y recibidas. También se elige un BDR en caso de que falle el DR. Todos los otros routers se convierten en DROTHER. Un DROTHER es un router que no funciona como DR ni como BDR.

> Nota:  El DR se utiliza solo para la transmisión de LSA. El router seguirá usando el mejor router de siguiente salto indicado en la tabla de routing para el reenvío de los demás paquetes.

