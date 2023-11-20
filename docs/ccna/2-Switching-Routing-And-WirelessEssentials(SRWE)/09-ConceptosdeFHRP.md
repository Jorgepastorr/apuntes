# Conceptos de FHRP

##  Protocolos de redundancia de primer salto

### Limitaciones del gateway predeterminado

Los dispositivos finales generalmente se configuran con una única dirección IPv4 de puerta de enlace predeterminada. 

Si falla la interfaz de router de puerta de enlace predeterminada, los hosts LAN pierden conectividad LAN externa.

Esto ocurre incluso si existe un router redundante o un switch de capa 3 que podría servir como puerta de enlace predeterminada.

Los protocolos de redundancia de primer salto (FHRP) son mecanismos que proporcionan puertas de enlace predeterminadas alternativas en redes conmutadas donde dos o más routers están conectados a las mismas VLAN. 

### Redundancia del router

Una forma de evitar un único punto de falla en la puerta de enlace predeterminada es implementar un router virtual. Para implementar este tipo de redundancia de routers, varios routers están configurados para trabajar juntos y presentar la ilusión de un solo router a los hosts en la LAN. Al compartir una dirección IP y una dirección MAC, dos o más routers pueden funcionar como un único router virtual.

La dirección IPv4 del router virtual se configura como la puerta de enlace predeterminada para las estaciones de trabajo de un segmento específico de IPv4. 

Cuando se envían tramas desde los dispositivos host hacia la puerta de enlace predeterminada, los hosts utilizan ARP para resolver la dirección MAC asociada a la dirección IPv4 de la puerta de enlace predeterminada. La resolución de ARP devuelve la dirección MAC del router virtual. El router actualmente activo dentro del grupo de routers virtuales puede procesar físicamente las tramas que se envían a la dirección MAC del router virtual. 

Los protocolos se utilizan para identificar dos o más routers como los dispositivos responsables de procesar tramas que se envían a la dirección MAC o IP de un único router virtual. Los dispositivos host envían el tráfico a la dirección del router virtual. El router físico que reenvía este tráfico es transparente para los dispositivos host.

Un protocolo de redundancia proporciona el mecanismo para determinar qué router debe cumplir la función activa en el reenvío de tráfico. Además, determina cuándo un router de reserva debe asumir la función de reenvío. La transición entre los routers de reenvío es transparente para los dispositivos finales.

### Pasos para la conmutación por error del router

Cuando falla el router activo, el protocolo de redundancia hace que el router de reserva asuma el nuevo rol de router activo, como se muestra en la figura. Estos son los pasos que se llevan a cabo cuando falla el router activo:

- El router de reserva deja de recibir los mensajes de saludo del router de reenvío.
- El router de reserva asume la función del router de reenvío.
- Debido a que el nuevo router de reenvío asume tanto la dirección IPv4 como la dirección MAC del router virtual, los dispositivos host no perciben ninguna interrupción en el servicio.

### Opciones FHRP 

Protocolo de Router de Reserva Directa (HSRP, Hot Standby Router Protocol):

HRSP es una FHRP propietaria de Cisco que está diseñada para permitir conmutación por error (failover) transparente de un dispositivo IPv4 de primer salto. HSRP proporciona alta disponibilidad de red al proporcionar redundancia de enrutamiento de primer salto para IPv4 hosts en redes configuradas con una dirección de puerta de enlace predeterminada IPv4. HSRP se utiliza en un grupo de routers para seleccionar un dispositivo activo y un dispositivo de espera. En un grupo de interfaces de dispositivo, el dispositivo activo es el dispositivo que se utiliza para enrutar los paquetes; el dispositivo de espera es el dispositivo que se hace cargo cuando el dispositivo activo falla o cuando se preconfigura se cumplen las condiciones. La función del router de espera HSRP es supervisar el estado operativo del grupo HSRP y asumir rápidamente responsabilidad de reenvío de paquetes si falla el router activo.

HSRP para IPv6	

Esta es una FHRP propietaria de Cisco que proporciona la misma funcionalidad de HSRP, pero en un entorno IPv6. Un grupo IPv6 HSRP tiene un MAC virtual derivada del número de grupo HSRP y un vínculo IPv6 virtual local derivada de la dirección MAC virtual HSRP. Router Periódico se envían anuncios (RA) para el enlace IPv6 virtual HSRP local cuando el grupo HSRP está activo. Cuando el grupo se vuelve inactivo, estos RAs se detienen después de enviar una RA final.

Virtual Router Redundancy Protocol version 2 (VRRPv2)	

Este es un protocolo electoral no propietario que asigna dinámicamente responsabilidad de uno o más routeres virtuales a los routeres VRRP en una LAN IPv4. Esto permite que varios routers en un enlace multiacceso utilicen la misma dirección IPv4 virtual. Un router VRRP está configurado para ejecutar el protocolo VRRP junto con uno o más routeres conectados a una LAN. En una configuración VRRP, se elige un router como el virtual router master, con los otros routers actuando como copias de seguridad, en caso de que el virtual router master falle.

VRRPv3	

Proporciona la capacidad de admitir direcciones IPv4 e IPv6. VRRPv3 Funciona en entornos de varios proveedores y es más escalable que VRRPv2.

Protocolo de Equilibrio de Carga del Gateway (Load Balancing Protocol, GLBP)	

Este es un FHRP propiedad de Cisco que protege el tráfico de datos de un router o circuito fallido, como HSRP y VRRP, mientras que también permite la carga equilibrada (también llamado uso compartido de carga) entre un grupo de routers.

GLBP para IPv6	

Esta es una FHRP propietaria de Cisco que proporciona la misma funcionalidad de GLBP, pero en un entorno IPv6. GLBP para IPv6 proporciona automáticamente un respaldo de router para los hosts IPv6 configurados con un único gateway predeterminado en una LAN. Múltiples routers de primer salto en la LAN se combinan para ofrecer un único router IPv6 virtual de primer salto mientras comparte el reenvío de paquetes IPv6 carga.

Protocolo de detección del router ICMP (IRDP, ICMP Router Discovery Protocol)	

Especificado en RFC 1256, IRDP es una solución FHRP heredada. IRDP permite IPv4 hosts ubiquen routers que proporcionan conectividad IPv4 a otras redes IP (no locales).

## HSRP

Cisco proporciona HSRP y HSRP para IPv6 como una forma de evitar la pérdida de acceso externo a la red si falla el router predeterminado. Es el protocolo FHRP exclusivo de Cisco diseñado para permitir la conmutación por falla transparente de los dispositivos IPv4 de primer salto.

HSRP proporciona una alta disponibilidad de red, ya que proporciona redundancia de routing de primer salto para los hosts IPv4 en las redes configuradas con una dirección IPv4 de gateway predeterminado. HSRP se utiliza en un grupo de routers para seleccionar un dispositivo activo y un dispositivo de reserva. En un grupo de interfaces de dispositivo, el dispositivo activo es aquel que se utiliza para enrutar paquetes, y el dispositivo de reserva es el que toma el control cuando falla el dispositivo activo o cuando se cumplen condiciones previamente establecidas. La función del router de suspensión del HSRP es controlar el estado operativo del grupo de HSRP y asumir rápidamente la responsabilidad de reenvío de paquetes si falla el router activo.

### Prioridad e Intento de Prioridad del HSRP

El rol de los routers activos y de reserva se determina durante el proceso de elección del HSRP. De manera predeterminada, el router con la dirección IPv4 numéricamente más alta se elige como router activo. Sin embargo, siempre es mejor controlar cómo funcionará su red en condiciones normales en lugar de dejarlo librado al azar.

- La prioridad HSRP se puede utilizar para determinar el router activo. 
- El router con la prioridad HSRP más alta será el router activo. 
- De manera predeterminada, la prioridad HSRP es 100.
- Si las prioridades son iguales, el router con la dirección IPv4 numéricamente más alta es elegido como router activo.
- Para configurar un router para que sea el router activo, utilice el comando de interfaz `standby priority`. El rango de prioridad HSRP es de 0 a 255.

De forma predeterminada, después de que un router se convierte en el router activo, seguirá siendo el router activo incluso si otro router está disponible en línea con una prioridad HSRP más alta.

Para forzar un nuevo proceso de elección HSRP a tener lugar cuando un router de mayor prioridad entra en línea, la preferencia debe habilitarse mediante el comandoen la interface standby preempt  El intento de prioridad es la capacidad de un router HSRP de activar el proceso de la nueva elección. Con este intento de prioridad activado, un router disponible en línea con una prioridad HSRP más alta asume el rol de router activo.

El intento de prioridad solo permite que un router se convierta en router activo si tiene una prioridad más alta. Un router habilitado para intento de propiedad, con una prioridad equivalente pero una dirección IPv4 más alta, no desplazará la prioridad de un router activo. Consulte la topología de la figura.

> Nota: Si el intento de prioridad está desactivado, el router que arranque primero será el router activo si no hay otros routers en línea durante el proceso de elección.

### Estados y Temporizadores de HSRP

| Estado de HSRP | Descripción                                                                                                                                                                |
| :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Inicial        | Este estado se ingresa a través de un cambio de configuración o cuando una interfaz está disponible en primer lugar.                                                       |
| Aprendizaje    | El router no ha determinado la dirección IP virtual ha visto un mensaje de saludo desde el router activo. En este estado, el router espera para escuchar al router activo. |
| Escucha        | El router conoce la dirección IP virtual, pero no es el router activo ni el router en espera. Escucha los mensajes de saludo de esos routers.                              |
| Hablar         | El router envía mensajes de saludo periódicos y participa activamente en la elección del router activo y/o en espera.                                                      |
| En             | espera	El router es candidato a convertirse en el próximo router activo y envía mensajes de saludo periódicos.                                                             |


El router HSRP activo y el de reserva envían paquetes de saludo a la dirección de multidifusión del grupo HSRP cada 3 segundos, de forma predeterminada. El router de reserva se convertirá en activo si no recibe un mensaje de saludo del router activo después de 10 segundos. Puede bajar estas configuraciones del temporizador para agilizar las fallas o el intento de prioridad. Sin embargo, para evitar el aumento del uso de la CPU y cambios de estado de reserva innecesarios, no configure el temporizador de saludo a menos de 1 segundo o el temporizador de espera a menos de 4 segundos.

