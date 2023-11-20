# Conceptos de VPN e IPsec

## Tecnología VPN

### Redes privadas virtuales

Redes privadas virtuales (VPNs) para crear conexiones de red privada de punto a punto (end-to-end).

Una VPN es virtual porque transporta la información dentro de una red privada, pero, en realidad, esa información se transporta usando una red pública.

Una VPN es privada porque el tráfico se encripta para preservar la confidencialidad de los datos mientras se los transporta por la red pública.

### Beneficios VPN

Las VPN modernas ahora admiten funciones de encriptación, como la seguridad de protocolo de Internet (IPsec) y las VPN de capa de sockets seguros (SSL) para proteger el tráfico de red entre sitios.

Los principales beneficios de las VPN se muestran en la tabla.

Ahorro de costos:	Con la llegada de tecnologías rentables y de gran ancho de banda, las organizaciones pueden usar VPN para reducir sus costos de conectividad mientras incrementa simultáneamente el ancho de banda de la conexión remota.

Seguridad: 	Las VPN proporcionan el mayor nivel de seguridad disponible, mediante el uso de encriptación avanzada y protocolos de autenticación que protegen los datos de acceso no autorizado.

Escalabilidad: 	Las VPN permiten a las organizaciones usar Internet, lo que facilita la adición de nuevos usuarios sin agregar infraestructura significativa.

Compatibilidad: 	Las VPN se pueden implementar en una amplia variedad de opciones de enlace WAN incluidas todas las tecnologías populares de banda ancha. Los trabajadores remotos pueden aprovechar estas conexiones de alta velocidad para obtener acceso seguro a sus redes corporativas.

###  de sitio a sitio y acceso remoto

Una VPN de sitio a sitio finaliza en las puertas de enlace VPN. El tráfico VPN solo se cifra entre las puertas de enlace. Los hosts internos no tienen conocimiento de que se está utilizando una VPN.

Una VPN de acceso-remoto se crea dinámicamente para establecer una conexión segura entre un cliente y un dispositivo de terminación de VPN.

### VPN para empresas y proveedores de servicios

Las VPN se pueden administrar e implementar como:

**VPN empresariales**: solución común para proteger el tráfico empresarial a través de Internet. Las VPN de sitio a sitio y de acceso remoto son creadas y administradas por la empresa utilizando tanto VPN IPsec como SSL.

**VPN de proveedores de servicios**: creados y administrados por la red de proveedores. El proveedor utiliza la conmutación de etiquetas multiprotocolo (MPLS) en la capa 2 o la capa 3 para crear canales seguros entre los sitios de una empresa, segregando efectivamente el tráfico del tráfico de otros clientes. 


## Tipos de VPN

### VPN de acceso remoto

Las VPN de acceso remoto permiten a los usuarios remotos y móviles conectarse de forma segura a la empresa. 

Las VPN de acceso remoto generalmente se habilitan dinámicamente por el usuario cuando es necesario y se pueden crear utilizando IPsec o SSL. 

Conexión VPN sin cliente - La conexión se asegura utilizando una conexión SSL de navegador web. 

Conexión VPN basada en el cliente - El software de cliente VPN, como Cisco AnyConnect Secure Mobility Client, debe instalarse en el dispositivo final del usuario remoto.


### SSL VPNs

SSL utiliza la infraestructura de llave pública y los certificados digitales para autenticar a sus pares. El tipo de método VPN implementado se basa en los requisitos de acceso de los usuarios y en los procesos de TI de la organización. La tabla compara las implementaciones de acceso remoto IPsec y SSL. 


| Característica           | IPsec                                                                                         | SSL                                                                                |
| :----------------------- | :-------------------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------- |
| Aplicaciones soportadas: | Extensiva - Todas las aplicaciones basadas en IP son compatibles.                             | Limitada - Solo aplicaciones y archivos basados en la web compartidos y soportados |
| Fuerza de autenticación  | Fuerte - Utiliza autenticación bidireccional con llaves compartidas o certificados digitales. | Moderado - Uso de autenticación unidireccional o bidireccional.                    |
| Fuerza de encriptación   | Fuerte - Utiliza longitudes de llave de 56 bits a 256 bits.                                   | Moderado a fuerte - Con longitudes de llave de 40 bits a 256 bits.                 |
| Complejidad de conexión  | Medio - Porque requiere un cliente VPN preinstalado en un usuario.                            | Bajo - Solo requiere un navegador web en una terminal.                             |
| Opción de conexión       | Limitado - Solo se pueden conectar dispositivos específicos con configuraciones específicas.  | Extensivo - Cualquier dispositivo con un navegador web puede conectarse.           |

### VPN de IPsec de sitio a sitio

Las VPN de sitio a sitio se utilizan para conectar redes a través de otra red no confiable como Internet.

Los hosts finales envían y reciben tráfico TCP / IP sin cifrar normal a través de una puerta de enlace VPN.

La puerta de enlace VPN encapsula y cifra el tráfico saliente de un sitio y envía el tráfico a través del túnel VPN a la puerta de enlace VPN en el sitio de destino. Al recibirlo, la puerta de enlace VPN receptora despoja los encabezados, desencripta el contenido y retransmite el paquete hacia el usuario de destino dentro de su red privada.

### GRE sobre IPsec

Generic Routing Encapsulation (GRE) es un protocolo de túnel de VPN de sitio a sitio básico y no seguro.

Un túnel GRE puede encapsular varios protocolos de capa de red, así como tráfico multicast y broadcast.

Sin embargo, GRE no admite de forma predeterminada el encriptado; y por lo tanto, no proporciona un túnel VPN seguro.

Un paquete GRE puede encapsularse en un paquete IPsec para reenviarlo de forma segura a la puerta de enlace VPN de destino.

Una VPN IPsec estándar (no GRE) solo puede crear túneles seguros para el tráfico de unicast.

Encapsular GRE en IPsec permite asegurar las actualizaciones del protocolo de enrutamiento de multidifusión a través de una VPN.

Los términos utilizados para describir la encapsulación de GRE sobre el túnel IPsec son protocolo pasajero (passenger protocol), protocolo operador (carrier protocol) y protocolo transporte (transport protocol).

- Protocolo del Pasajero – Este es el paquete original que debe ser encapsulado por GRE. Podría ser un paquete IPv4 o IPv6, una actualización de enrutamiento y más.
- Protocolo del Operador – GRE es el protocolo del operador que encapsula el paquete original de pasajeros.
- Protocolo de transporte: – Este es el protocolo que realmente se usará para reenviar el paquete. Esto podría ser IPv4 o IPv6.

Por ejemplo, Branch y HQ necesitan intercambiar información de enrutamiento OSPF sobre una VPN IPsec. Por lo tanto, GRE sobre IPsec se usa para admitir el tráfico del protocolo de enrutamiento sobre la VPN de IPsec. 

Específicamente, los paquetes OSPF (es decir, el protocolo del pasajero) serían encapsulados por GRE (es decir, el protocolo del operador) y posteriormente encapsulados en un túnel VPN IPsec.

### VPN dinámicas multipunto

Las VPN de IPsec de sitio a sitio y GRE sobre IPsec no son suficientes cuando la empresa agrega muchos más sitios. La VPN dinámica multipunto (DMVPN) es una solución de Cisco para crear VPN múltiples de forma fácil, dinámica y escalable.

- DMVPN simplifica la configuración del túnel VPN y proporciona una opción flexible para conectar un sitio central con sitios de sucursales. 
- Utiliza una configuración de hub-and-spoke para establecer una topología de malla completa (full mesh). 
- Los sitios de spoke establecen túneles VPN seguros con el sitio central, como se muestra en la figura.
- Cada sitio se configura usando Multipoint Generic Routing Encapsulation (mGRE). La interfaz del túnel mGRE permite que una única interfaz GRE admita dinámicamente múltiples túneles IPsec.
- Los sitios de radios también pueden obtener información unos de otros y, alternativamente, construir túneles directos entre ellos (túneles de radio a radio).

### Interfaz de túnel virtual IPsec

Al igual que los DMVPN, IPsec Virtual Tunnel Interface (VTI) simplifica el proceso de configuración requerido para admitir múltiples sitios y acceso remoto.

Las configuraciones de IPsec VTI se aplican a una interfaz virtual en lugar de la asignación estática de las sesiones de IPsec a una interfaz física.

IPsec VTI es capaz de enviar y recibir tráfico IP encriptado de unicast y multicast. Por lo tanto, los protocolos de enrutamiento son compatibles automáticamente sin tener que configurar túneles GRE.

IPsec VTI se puede configurar entre sitios o en una topología de hub-and-spoke.

### VPN de MPLS del proveedor de servicios

Hoy, los proveedores de servicios usan MPLS en su red principal. El tráfico se reenvía a través de la red troncal MPLS mediante etiquetas. Al igual que las conexiones WAN heredadas, el tráfico es seguro porque los clientes del proveedor de servicios no pueden ver el tráfico de los demás.

MPLS puede proporcionar a los clientes soluciones VPN administradas; por lo tanto, aseguran el tráfico entre los sitios del cliente es responsabilidad del proveedor del servicio. 

Hay dos tipos de soluciones VPN MPLS compatibles con los proveedores de servicios:

**VPN MPLS Capa 3** -El proveedor de servicios participa en el enrutamiento del cliente al establecer un intercambio entre los enrutadores del cliente y los enrutadores del proveedor. 

**VPN MPLS Capa 2** -El proveedor de servicios no participa en el enrutamiento del cliente. En cambio, el proveedor implementa un servicio de LAN privada virtual (VPLS) para emular un segmento LAN de acceso múltiple de Ethernet a través de la red MPLS. No hay enrutamiento involucrado. Los enrutadores del cliente pertenecen efectivamente a la misma red de acceso múltiple.


## IPsec

### Tecnologías IPsec

IPsec es un estándar IETF (RFC 2401-2412) que define cómo se puede asegurar una VPN a través de redes IP. IPsec protege y autentica los paquetes IP entre el origen y el destino y proporciona estas funciones de seguridad esenciales:

**Confidencialidad** - IPsec utiliza algoritmos de encriptación para evitar que los delincuentes cibernéticos lean el contenido del paquete.

**Integridad** - Psec utiliza algoritmos de hash para garantizar que los paquetes no se hayan modificado entre el origen y el destino.

**Autenticación de Origen** - IPsec utiliza el protocolo de intercambio de claves de Internet (IKE) para autenticar el origen y el destino. 

**Diffie-Hellman** – se utiliza para asegurar el intercambio de claves.

IPsec no está sujeto a ninguna regla específica para comunicaciones seguras.

IPsec puede integrar fácilmente nuevas tecnologías de seguridad sin actualizar los estándares existentes de IPsec.

Las ranuras abiertas que se muestran en el marco de IPsec en la figura pueden llenarse con cualquiera de las opciones disponibles para esa función de IPsec para crear una asociación de seguridad (SA) única.

### Protocolo de Encapsulación IPsec

La elección del protocolo de encapsulación IPsec es el primer bloque de construcción del marco.

IPsec encapsula paquetes usando el Encabezado de autenticación (AH) o el Protocolo de seguridad de encapsulación (ESP).

La elección de AH o ESP establece que otros bloques de construcción están disponibles:

- AH es apropiado solo cuando la confidencialidad no es requerida o permitida.
- ESP proporciona confidencialidad y autenticación.


### Confidencialidad

El grado de confidencialidad depende del algoritmo de encriptación y la longitud de la llave utilizada en el algoritmo de encriptación. 

La cantidad de posibilidades para intentar hackear la clave es una función de la longitud de la clave: cuanto más corta es la clave, más fácil es romperla.

Los algoritmos de encriptación resaltados en la figura son todos criptosistemas de llave simétrica:

- DES usa una llave de 56 bits.
- 3DES utiliza tres claves de cifrado independientes de 56 bits por bloque de 64 bits.
- AES ofrece tres longitudes de llave diferentes: 128 bits, 192 bits y 256 bits.
- SEAL es un cifrado de flujo, lo que significa que encripta datos continuamente en lugar de encriptar bloques de datos. SEAL utiliza una llave de 160 bits.

### Integridad

La integridad de los datos significa que los datos no han cambiado en tránsito.

Se requiere un método para probar la integridad de los datos. 

El Código de autenticación de mensajes hash (HMAC) es un algoritmo de integridad de datos que garantiza la integridad del mensaje utilizando un valor hash:

- Message-Digest 5 (MD5) utiliza una llave secreta compartida de 128 bits.
- El algoritmo de seguro de hash (SHA por sus siglas en inglés) utiliza una llave secreta de 160 bits.

### Autenticación

Existen dos métodos de autenticación de pares de IPsec:

1. (PSK) Un valor de llave secreta precompartida- (PSK) se ingresa manualmente en cada par.

- Fácil de configurar manualmente.
- No escala bien.
- Debe configurarse en cada par.

2. Rivest, Shamir y Adleman (RSA):- la autenticación utiliza certificados digitales para autenticar a los pares.

- Cada par debe autenticar a su par opuesto antes de que el túnel se considere seguro.


### Intercambio seguro de llaves con Diffie-Hellman

DH proporciona que dos pares puedan establecer una clave secreta compartida a través de un canal inseguro.

Las variaciones del intercambio de llaves DH se especifican como grupos DH:

- Los grupos DH 1, 2 y 5 ya no deberían usarse.
- Los grupos DH 14, 15 y 16 usan tamaños de clave más grandes con 2048 bits, 3072 bits y 4096 bits, respectivamente.
- Los grupos DH 19, 20, 21 y 24 con tamaños de llave respectivos de 256 bits, 384 bits, 521 bits y 2048 bits admiten la criptografía de curva elíptica (ECC), que reduce el tiempo necesario para generar llaves. 
