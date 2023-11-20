# Configuración OSPFv2 de área única

## Router ID de OSPF

OSPFv2 se habilita con el comando `router ospf process-id` del modo de configuración global. 
El valor de *process-id* representa un número entre 1 y 65535, y lo elige el administrador de redes. 
El valor de process-id es localmente significativo. 
Se considera una práctica recomendada utilizar el mismo process-id en todos los routers OSPF.

### Router ID

El router ID de OSPF es un valor de 32 bits, representado como una dirección IPv4. Se utiliza para identificar de forma única un router OSPF y todos los paquetes OSPF incluyen el router ID del router de origen. 

Para participar en un dominio OSPF, cada router requiere de un router ID. Puede ser definido por un administrador o asignado automáticamente por el router. El router ID es utilizado por un router habilitado por OSPF para hacer lo siguiente:

- Participar en la sincronización de bases de datos OSPF : durante el estado de Exchange, el router con el router ID más alto enviará primero sus paquetes de descriptor de base de datos (DBD). 
- Participar en la elección del router designado (DR) - En un entorno LAN multiacceso, el router con el router ID más alto se elige el DR. El dispositivo de enrutamiento con el segundo router ID más alto, se elige como el router designado de respaldo (BDR).

### Orden de precedencia del Router ID

Los routers Cisco derivan el router ID según uno de los tres criterios, en el siguiente orden preferencial:

- El router ID se configura explícitamente utilizando el comando router-id rid router de modo de configuración. Este es el método recomendado para asignar un router ID
- El router elige la dirección IPv4 más alta de cualquiera de las interfaces de loopback configuradas.
- El router elige la dirección IPv4 activa más alta de cualquiera de sus interfaces físicas.

### Configure explícitamente un Router ID

Utilice el comando `router-id rid` router para asignar manualmente un router ID.
Utilice el comando show ip protocols para verificar el router ID.

    R1(config)# router ospf 10 
    R1(config-router)# router-id 1.1.1.1 

    R1# show ip protocols

Después de que un router selecciona el router ID, un router OSPF activo no permitirá que el router ID cambie, hasta que el router se reinicie o el proceso de OSPF sea restablecido.

El método preferido para restablecer el router ID es borrar el proceso OSPF.

    R1# clear ip ospf process 


## Redes punto a punto OSPF

Puede especificar las interfaces que pertenecen a una red punto a punto configurando el comando network. 
También puede configurar OSPF directamente en la interfaz con el comando ip ospf.

La sintaxis básica del comando network es la siguiente:

    Router(config-router)# network network-address wildcard-mask area area-id

La sintaxis de *wildcard mask* de dirección de red se utiliza para habilitar OSPF en las interfaces. Cualquier interfaz en un router que coincida con esta parte del comando está habilitada para enviar y recibir paquetes OSPF.

La sintaxis del area area-id se refiere al área OSPF. Al configurar OSPFv2 de área única, el comando `network` debe configurarse con el mismo valor de area-id en todos los routers. Si bien se puede usar cualquier ID de área, es aconsejable utilizar una ID de área 0 con OSPFv2 de área única. Esta convención facilita la tarea si posteriormente se modifica la red para admitir OSPFv2 multiárea.

### El Wildcard Mask

El wildcard mask suele ser la inversa de la máscara de subred configurada en esa interfaz. 

El método más fácil para calcular un wildcard mask es restar la máscara de subred de red de 255.255.255.255, como se muestra para las máscaras de subred /24 y /26 en la figura.

    255.255.255.255
    255.255.255.0   subnet /24
    ---------------
    0.0.0.255       wildcard

    255.255.255.255
    255.255.255.192 subnet /26
    ---------------
    0.0.0.63        wildcard

### Configurar OSPF mediante el comando network

Dentro del modo de configuración de enrutamiento, hay dos formas de identificar las interfaces que participarán en el proceso de enrutamiento OSPFv2.

En el primer ejemplo, el wildcard mask identifica la interfaz en función de las direcciones de red. Cualquier interfaz activa configurada con una dirección IPv4 perteneciente a esa red participará en el proceso de enrutamiento OSPFv2.

> Nota: Algunas versiones de IOS permiten introducir la máscara de subred en lugar del wildcard mask. Luego, IOS convierte la máscara de subred al formato del wildcard mask.

    R1(config)# router ospf 10 
    R1 (config-router)# network 10.10.1.0 0.0.0.255 area 0 
    R1(config-router)# network 10.1.1.4 0.0.0.3 area 0

Como alternativa, OSPFv2 se puede habilitar especificando la dirección IPv4 exacta de la interfaz usando un wildcard mask cuádruple cero. Al ingresar `network 10.1.1.5 0.0.0.0 area 0` en R1 le dice al router que habilite la interfaz Gigabit Ethernet 0/0/0 para el proceso de enrutamiento. 

La ventaja de especificar la interfaz es que no se necesita calcular el wildcard mask. Observe que en todos los casos, el argumento area específica el área 0.

    R1(config)# router ospf 10 
    R1 (config-router)# network 10.10.1.1 0.0.0.0 area 0 
    R1 (config-router)# network 10.1.1.5 0.0.0.0 area 0 

### Configure OSPF mediante el comando ip ospf

Para configurar OSPF directamente en la interfaz, utilice el comando en modo de configuración `ip ospf interface`. 

La sintaxis es la siguiente:

    Router(config-if)# ip ospf process-id area area-id

    R1(config-if)# interface GigabitEthernet 0/0/1 
    R1(config-if) # ip ospf 10 área 0 


### Configurar interfaces pasivas

De manera predeterminada, los mensajes OSPF se reenvían por todas las interfaces con OSPF habilitado. Sin embargo, estos mensajes solo necesitan enviarse por las interfaces que se conectan a otros routers con OSPF habilitado.

El envío de mensajes innecesarios en una LAN afecta la red de tres maneras:

- **Uso ineficaz del ancho de banda:** se consume el ancho de banda disponible con el transporte de mensajes innecesarios.
- **Uso ineficaz de los recurso:** Todos los dispositivos en la LAN deben procesar el mensaje y, finalmente, descartarlo.
- **Mayor riesgo de seguridad:** sin configuraciones de seguridad OSPF adicionales, los mensajes OSPF se pueden interceptar con software de detección de paquetes. Las actualizaciones de routing se pueden modificar y enviar de regreso al router, lo que daña la tabla de routing con métricas falsas que direccionan erróneamente el tráfico.

    R1(config)# router ospf 10 
    R1(config-router)# passive-interface loopback 0


### OSPF Punto a Punto

De forma predeterminada, los routers Cisco eligen DR y BDR en las interfaces Ethernet, incluso si solo hay otro dispositivo en el enlace. 
Puede verificarlo con el comando `show ip ospf interface`. 
El proceso de elección de DR/BDR es innecesario ya que solo puede haber dos routers en la red punto a punto entre R1 y R2. 

Para cambiar esto a una red punto a punto, utilice el comando de configuración de interfaz `ip ospf network point-to-point` en todas las interfaces en las que desee deshabilitar el proceso de elección DR/BDR.

    R1(config)# interface GigabitEthernet 0/0/0 
    R1(config-if)# ip ospf network point-to-point

### loopbacks 

Utilice loopbacks para proporcionar interfaces adicionales para una variedad de propósitos. De forma predeterminada, las interfaces loopback se anuncian como rutas de host /32.

Para simular una LAN real, la interfaz de loopback se puede configurar como una red punto a punto para anunciar la red completa.

    R1(config-if)# interface Loopback 0 
    R1(config-if)# ip ospf network point-to-point


## Redes OSPF de acceso múltiple

### Tipos de red OPSF

Otro tipo de red que utiliza OSPF es la red OSPF multiacceso. Las redes OSPF multiacceso son únicas, ya que un router controla la distribución de los LSA. 

El router elegido para este rol debe ser determinado por el administrador de red a través de la configuración adecuada.

### Router designado

En redes multiacceso, OSPF elige un DR y un BDR. El DR es responsable de recolectar y distribuir los LSA enviados y recibidos. El DR usa la dirección multicast de IPv4 224.0.0.5 que está destinada a todos los routers OSPF.

También se elige un BDR en caso de que falle el DR. El BDR escucha este intercambio en forma pasiva y mantiene una relación con todos los routers. Si el DR deja de producir paquetes Hello, el BDR se asciende a sí mismo y asume la función de DR.

Todos los demás routers se convierten en DROTHER (un router que no es DR ni BDR). Los dispositivos de acceso múltiple utilizan la dirección 224.0.0.6 (todos los routers designados) para enviar paquetes OSPF a DR y BDR. Sólo DR y BDR escuchan 224.0.0.6.


### Verifique adyacencias DR/BDR

Para comprobar las adyacencias OSPFv2, utilice comando show ip ospf neighbor  El estado de los vecinos en las redes de acceso múltiple puede ser el siguiente:

- **FULL/DROTHER**: Este es un router DR o BDR que está completamente adyacente con un router que no sea DR o BDR Estos dos vecinos pueden intercambiar paquetes Hello, actualizaciones, consultas, respuestas y acuses de recibo.
- **FULL/BDR**: El router está completamente adyacente con el vecino DR indicado Estos dos vecinos pueden intercambiar paquetes Hello, actualizaciones, consultas, respuestas y acuses de recibo.
- **FULL/DR**: El router es completamente adyacente con el vecino BDR indicado. Estos dos vecinos pueden intercambiar paquetes Hello, actualizaciones, consultas, respuestas y acuses de recibo.
- **2-WAY/DROTHER**: El router que no es DR o BDR tiene una relación vecina con otro router no DR o BDR Estos dos vecinos intercambian paquetes Hello.


En general, el estado normal de un router OSPF es FULL. Si un router está atascado en otro estado, es un indicio de que existen problemas en la formación de adyacencias. La única excepción a esto es el estado 2-WAY, que es normal en una red broadcast multiacceso. 

### Proceso de elección de DR/BDR predeterminado

La decisión de elección del DR y el BDR OSPF se hace según los siguientes criterios, en orden secuencial:

1. Los routers en la red seleccionan como DR al router con la prioridad de interfaz más alta. El router con la segunda prioridad de interfaz más alta se elige como BDR. 

- La prioridad puede configurarse para que sea cualquier número entre 0 y 255. 
- Si el valor de prioridad de la interfaz se establece en 0, esa interfaz no se puede elegir como DR ni BDR. 
- La prioridad predeterminada de las interfaces broadcast de acceso múltiple es 1.

2. Si las prioridades de interfaz son iguales, se elige al router con la ID más alta como DR. El router con el segundo router ID más alto es el BDR.

- El proceso de elección tiene lugar cuando el primer router con una interfaz habilitada para OSPF está activo en la red. Si no terminaron de arrancar todos los routers en la red multiacceso, es posible que un router con un router ID más bajo se convierta en el DR.
- La adición de un router nuevo no inicia un nuevo proceso de elección.

### Error y recuperación de DR

Una vez que se elige el DR, permanece como tal hasta que se produce una de las siguientes situaciones:

- El DR falla.
- El proceso OSPF en el DR falla o se detiene.
- La interfaz multiacceso en el DR falla o se apaga.

Si el DR falla, el BDR se asciende automáticamente a DR. Esto ocurre así incluso si se agrega otro DROTHER con una prioridad o router ID más alta a la red después de la elección inicial de DR/BDR. 
Sin embargo, después del ascenso de un BDR a DR, se lleva a cabo otra elección de BDR y se elige al DROTHER con la prioridad o la ID de router más alta como el BDR nuevo.

### El comando ip ospf priority

Si las prioridades de interfaz son iguales en todos los routers, se elige al router con la ID más alta como DR. 

En vez de depender del router ID, es mejor controlar la elección mediante el establecimiento de prioridades de interfaz. Esto también permite que un router sea el DR en una red y un DROTHER en otra. 

Para establecer la prioridad de una interfaz, utilice el comando `ip ospf priority value` , donde value es de 0 a 255. 

- Un valor de 0 no se convierte en DR o BDR. 
- Un valor de 1 a 255 en la interfaz hace más probable que el router se convierta en DR o BDR.

    R1(config)# interface GigabitEthernet 0/0/0 
    R1(config-if)# ip ospf priority 255
    R1#  clear ip ospf process


## Modifique OSPFv2

### Modifique la métrica de costos OSPFv2

Recuerde que un protocolo de enrutamiento utiliza una métrica para determinar la mejor ruta de un paquete a través de una red. El protocolo OSPF utiliza el costo como métrica. Un costo más bajo indica un mejor camino.

El costo de Cisco de una interfaz es inversamente proporcional al ancho de banda de la interfaz. Por lo tanto, cuanto mayor es el ancho de banda, menor es el costo. La fórmula que se usa para calcular el costo de OSPF es la siguiente:

	Costo = ancho de banda de referencia / ancho de banda de la interfaz

El ancho de banda de referencia predeterminado es 108 (100,000,000); por lo tanto, la fórmula es la siguiente:

	Costo = 100.000.000 bps/ancho de banda de la interfaz en bps

Debido a que el valor del costo OSPF debe ser un número entero, las interfaces FastEthernet, Gigabit Ethernet y 10 GigE comparten el mismo costo. Para corregir esta situación, puede:

- Ajuste el ancho de banda de referencia con el comando `auto-cost reference-bandwidth` en cada router OSPF.
- Establezca manualmente el valor de coste OSPF con el comando `ip ospf cost` en las interfaces necesarias.


### Ajustar el ancho de banda de referencia

El valor de coste debe ser un entero. Si se calcula un valor menor que un número entero, OSPF redondea al número entero más cercano. Por lo tanto, el costo OSPF asignado a una interfaz Gigabit Ethernet con el ancho de banda de referencia predeterminado de 100.000.000 bps equivaldría a 1, porque el entero más cercano para 0.1 es 0 en lugar de 1.

	Costo = 100.000.000 bps/1.000.000.000 = 1

Por esta razón, todas las interfaces más rápidas que Fast Ethernet tendrán el mismo valor de costo de 1 que una interfaz Fast Ethernet. 

Para ayudar a OSPF a determinar la ruta correcta, se debe cambiar el ancho de banda de referencia a un valor superior a fin de admitir redes con enlaces más rápidos que 100 Mbps.

El cambio del ancho de banda de referencia en realidad no afecta la capacidad de ancho de banda en el enlace, sino que simplemente afecta el cálculo utilizado para determinar la métrica. 

Para ajustar el ancho de banda de referencia, use el comando de configuración del router `auto-cost reference-bandwidth Mbps`

- Se debe configurar este comando en cada router en el dominio OSPF. 
- Observe en el comando que el valor se expresa en Mbps; por lo tanto, para ajustar los costos de Gigabit Ethernet, utilice el comando `auto-cost reference-bandwidth 1000`.  Para 10 Gigabit Ethernet, use el comando `auto-cost reference-bandwidth 10000`.
- Para volver al ancho de banda de referencia predeterminado, use el comando auto-cost reference-bandwidth 100.

Otra opción es cambiar el costo en una interfaz específica mediante el comando `ip ospf cost` .

### costo OSPF

Las razones para establecer manualmente el valor de costo incluyen:

- Es posible que el Administrador desee influir en la selección de rutas dentro de OSPF, lo que provoca que se seleccionen rutas diferentes de lo que normalmente daría costos predeterminados y acumulación de costos.
- Conexiones a equipos de otros proveedores que utilizan una fórmula diferente para calcular el costo OSPF.

Para cambiar el valor de costo notificado por el router OSPF local a otros routers OSPF, utilice el comando de configuración de interfaz ip ospf cost value.

    R1 (config) # interfaz g0/0/1
    R1 (config-if) # ip ospf cost 30

### Paquetes Hello

Los paquetes Hello OSPFv2 se transmiten a la dirección multicast 224.0.0.5 (todos los routers OSPF) cada 10 segundos. Este es el valor predeterminado del temporizador en redes multiacceso y punto a punto.

> Nota: Los paquetes Hello no se envían en las interfaces configuradas como pasivas mediante el comando passive-interface

El intervalo Dead es el período que el router espera para recibir un paquete Hello antes de declarar al vecino como inactivo. 
Si el intervalo Dead caduca antes de que los routers reciban un paquete Hello, OSPF elimina ese vecino de su base de datos (LSDB). 
El router satura la LSDB con información acerca del vecino inactivo por todas las interfaces con OSPF habilitado. 
Cisco utiliza un intervalo predeterminado de cuatro veces el intervalo Hello: Esto es 40 segundos en redes de acceso múltiple y punto a punto.

    Router(config-if)# ip ospf hello-interval segundos
    Router(config-if)# ip ospf dead-interval seconds


##  Propagación de la ruta predeterminada

Para propagar una ruta predeterminada, el router de borde (R2) debe configurarse con lo siguiente:

- Una ruta estática predeterminada, mediante el comando `ip route 0.0.0.0 0.0.0.0 [next-hop-address | exit-intf]`
- El comando de configuración del router `default-information originate`. Esto ordena al R2 que sea el origen de la información de la ruta predeterminada y que propague la ruta estática predeterminada en las actualizaciones OSPF.

En el ejemplo, R2 se configura con un loopback para simular una conexión a Internet. Se configura una ruta predeterminada y se propaga a todos los demás routers OSPF del dominio de enrutamiento.

> Nota: Al configurar rutas estáticas, se recomienda utilizar la dirección IP de salto siguiente. Sin embargo, al simular una conexión a Internet, no hay dirección IP de salto siguiente. Por lo tanto, usamos el argumento exit-intf.

    R2 (config) # interface lo1 
    R2 (config-if) # ip address 64.100.0.1 255.255.255.252 
    R2(config-if)# exit 
    R2(config)# ip route 0.0.0.0 0.0.0.0 loopback 1 
    R2(config)# router ospf 10 
    R2(config-router)# default-information originate 


## Verifique OSPFv2

Dos routers pueden no formar una adyacencia OSPFv2 si ocurre lo siguiente:

- Las máscaras de subred no coinciden, esto hace que los routers se encuentren en redes separadas.
- Los temporizadores de tiempo de Hello y Dead del protocolo OSPFv2 no coinciden.
- Los tipos de redes OSPFv2 no coinciden.
- Falta un comando de red OSPFv2 o es incorrecto.

Puede utilizar los siguientes comandos para verificar el estado de OSPF

    show ip ospf neighbor
    show ip ospf database
    show ip ospf inteface g0/0
    show ip route
    show ip route ospf
    show ip protocols

