# ACL

## Propósito de las ACL

### ¿Qué es una ACL?

Una ACL es una serie de comandos del IOS que controlan si un router reenvía o descarta paquetes según la información que se encuentra en el encabezado del paquete. De forma predeterminada, un router no tiene ninguna ACL configurada. Sin embargo, cuando se aplica una ACL a una interfaz, el router realiza la tarea adicional de evaluar todos los paquetes de red a medida que pasan a través de la interfaz para determinar si el paquete se puede reenviar.

- Una ACL es una lista secuencial de instrucciones permit (permitir) o deny (denegar), conocidas como “entradas de control de acceso” (ACE).

> Nota: Las ACE también se denominan comúnmente “instrucciones de ACL”.

Cuando el tráfico de la red atraviesa una interfaz configurada con una ACL, el router compara la información dentro del paquete con cada ACE, en orden secuencial, para determinar si el paquete coincide con una de las ACE. Este proceso se denomina filtrado de paquetes

Varias tareas realizadas por los routers requieren el uso de ACL para identificar el tráfico:

- Limitan el tráfico de la red para aumentar su rendimiento.
- Proporcionan control del flujo de tráfico.
- Proporcionan un nivel básico de seguridad para el acceso a la red.
- Filtran el tráfico según el tipo de tráfico.
- Filtran a los hosts para permitirles o denegarles el acceso a los servicios de red.
- Proporcionar prioridad a determinadas clases de tráfico de red

### Filtrado de paquetes 

El filtrado de paquetes controla el acceso a una red mediante el análisis de los paquetes entrantes y salientes y la transferencia o el descarte de estos según criterios determinados. 

El filtrado de paquetes se puede realizar en la Capa 3 o en la Capa 4.

Los routers Cisco admiten los siguientes dos tipos de ACL:

- **ACL estándar** : las ACL sólo filtran en la capa 3 utilizando únicamente la dirección IPv4 de origen. 
- **ACL extendidas** : las ACL filtran en la capa 3 mediante la dirección IPv4 de origen y/o destino. También pueden filtrar en la Capa 4 usando TCP, puertos UDP e información de tipo de protocolo opcional para un control más fino. 


### Funcionamiento de una ACL

Las ACL definen el conjunto de reglas que proporcionan un control adicional para los paquetes que ingresan por las interfaces de entrada, para los que retransmiten a través del router y para los que salen por las interfaces de salida del router.

Las listas ACL se pueden configurar para aplicarse tanto al tráfico entrante, como al tráfico saliente.

> Nota: Las ACL no operan sobre paquetes que se originan en el router mismo.

Las ACL de entrada filtran los paquetes que ingresan a una interfaz específica y lo hacen antes de que se enruten a la interfaz de salida. Las ACL de entrada son eficaces, porque ahorran la sobrecarga de enrutar búsquedas si el paquete se descarta.

Las ACL de salida filtran los paquetes después de que se enrutan, independientemente de la interfaz de entrada.

Cuando se aplica una ACL a una interfaz, sigue un procedimiento operativo específico. Estos son los pasos operativos que se utilizan cuando el tráfico ha entrado en una interfaz de router con una ACL IPv4 estándar de entrada configurada:

1. Un router configurado con una ACL de IPv4 estándar recupera la dirección IPv4 de origen del encabezado del paquete.
1. El router comienza en la parte superior de la ACL y compara la dirección con cada ACE de manera secuencial.
1. Cuando encuentra una coincidencia, el router realiza la instrucción, que puede ser permitir o denegar el paquete. Las demás entradas en el ACL  no son analizadas.
1. Si la dirección IPv4 de origen no coincide con ninguna ACE de la ACL, el paquete se descarta porque hay una ACE de denegación implícita aplicada automáticamente a todas las ACL.

La última instrucción de una ACL siempre es una instrucción deny implícita que bloquea todo el tráfico. Está oculto y no se muestra en la configuración.

> Nota: Una ACL debe tener al menos una instrucción permit, de lo contrario, se denegará todo el tráfico debido a la instrucción ACE deny implícita. 


##  Pautas para la creación de ACL

Existe un límite en el número de ACL que se pueden aplicar en una interfaz de router. Por ejemplo, una interfaz dual-stack de un router (es decir, IPv4 e IPv6) puede tener hasta cuatro ACL aplicadas, como se muestra en la figura. 

Específicamente, una interfaz de router puede tener:

- Una ACL IPv4 saliente.
- Una ACL IPv4 entrante.
- Una ACL IPv6 entrante.
- Una ACL IPv6 saliente.

> Note: las ACL no deben configurarse en ambos sentidos. El número de ACL y su dirección aplicada a la interfaz dependerá de la política de seguridad de la organización. 

### ACL Prácticas recomendadas

El uso de las ACL requiere prestar atención a los detalles y un extremo cuidado. Los errores pueden ser costosos en términos de tiempo de inactividad, esfuerzos de resolución de problemas y servicio de red deficiente. Antes de configurar una ACL, se requiere una planificación básica.


| Pautas                                                                                   | Ventaja                                                                         |
| :--------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------ |
| Fundamente sus ACL según las políticas de seguridad de la organización.                  | Esto asegurará la implementación de las pautas de seguridad de la organización. |
| Escribe lo que quieres que haga la ACL.                                                  | Esto lo ayudará a evitar crear inadvertidamente acceso potencial del switch.    |
| Utilice un editor de texto para crear, editar y guardar las ACL.                         | Esto lo ayudará a crear una biblioteca de ACL reutilizables.                    |
| Documentar las ACL mediante el comando de observación.                                   | Esto ayudará a usted (y a otros) a entender el propósito de un ACE.             |
| Pruebe las ACL en una red de desarrollo antes de implementarlas en un red de producción. | Esto lo ayudará a evitar errores costosos.                                      |


## Tipos de ACL IPv4

Existen dos tipos de ACL IPv4:

**ACL estándar** : permiten o deniegan paquetes basados únicamente en la dirección IPv4 de origen. 

**ACL extendidas** : permiten o deniegan paquetes basados en la dirección IPv4 de origen y la dirección IPv4 de destino, el tipo de protocolo, los puertos TCP o UDP de origen y destino y más. 


### ACL IPv4 numeradas y nombradas

**ACL numeradas**

- Las ACL numeradas `1-99` o `1300-1999` son ACL estándar, 
- mientras que las ACL numeradas `100-199` o `2000-2699` son ACL extendidas.

    access-list
        1-99 estandar
        100-199 extended

    access-list 1 permit 192.168.1.0 0.0.0.255

**ACL nombradas**

Las ACL con nombre son el método preferido para configurar ACL. Específicamente, las ACL estándar y extendidas se pueden nombrar para proporcionar información sobre el propósito de la ACL. Por ejemplo, nombrar un FILTRO FTP-ACL extendido es mucho mejor que tener un ACL 100 numerado.

El comando de configuración global `ip access-list` se utiliza para crear una ACL con nombre, como se muestra en el siguiente ejemplo.

    R1(config)# ip access-list extended FTP-FILTER 
    R1(config-ext-nacl)# permit tcp 192.168.10.0 0.0.0.255 any eq ftp 
    R1 (config-ext-nacl) # permit tcp 192.168.10.0 0.0.0.255 any eq ftp-data


### Dónde ubicar las ACL

Cada ACL se debe colocar donde tenga más impacto en la eficiencia.

Las ACL extendidas deben ubicarse lo más cerca posible del origen del tráfico que se desea filtrar.

Las ACL estándar deben aplicarse lo más cerca posible del destino. 

Factores que influyen en la colocaciónde ACL

El alcance del control organizacional: La ubicación de la ACL puede depender de si la organización tiene o no de las redes de origen y de destino.

Ancho de banda de las redes implicadas: Puede ser deseable filtrar el tráfico no deseado en el origen para evitar transmisión de tráfico que consume ancho de banda.

Ease of configuration	

- Puede ser más fácil implementar una ACL en el destino, pero el tráfico utilizará el ancho de banda innecesariamente.
- Se podría usar una ACL extendida en cada enrutador donde el tráfico se originó. Esto ahorraría ancho de banda filtrando el tráfico en la fuente, pero requeriría crear ACL extendidas en múltiples adyacentes.






