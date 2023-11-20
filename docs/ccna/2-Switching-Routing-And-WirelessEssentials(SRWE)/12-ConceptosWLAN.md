# Conceptos de WLAN

## Introducción a la Tecnología Inalámbrica

### Tipos de Redes Inalámbricas


Red Inalámbrica de Área Personal (WPAN): Baja potencia y corto alcance (20-30 pies o 6-9 metros).  Basado en el estándar IEEE 802.15 y una frecuencia de 2.4 GHz. Bluetooth y Zigbee son ejemplos de WPAN.

LAN Inalámbrica (WLAN): Redes de tamaño mediano de hasta aproximadamente 300 pies. Basado en el estándar IEEE 802.11 y una frecuencia de 2.4 GHz o 5.0 GHz.

Wireless MAN (WMAN): Gran área geográfica, como ciudad o distrito. Utiliza frecuencias específicas con licencia.

WAN inalámbrica (WWAN): Área geográfica extensa para la comunicación nacional o global. Utiliza frecuencias específicas con licencia.


### Tecnologías Inalámbricas

Bluetooth – Estándar IEEE WPAN utilizado para emparejar dispositivos a una distancia de hasta 30 pies (6-9 m). 

- Bluetooth de Baja Energía (BLE) - Admite topología de malla para dispositivos de red a gran escala.
- Bluetooth velocidad básica/mejorada (BR / EDR) - Admite topologías punto a punto y está optimizada para la transmisión de audio.

WiMAX (Interoperabilidad mundial para acceso por microondas): Conexiones alternativas a Internet de banda ancha por cable. IEEE 802.16 WLAN estándar para hasta 30 millas (50 km).

Banda Ancha celular: Transporte de voz y datos. Usado por teléfonos, automóviles, tabletas y computadoras portátiles.

- Global System of Mobile (GSM) – Reconocido internacionalmente
- Code Division Multiple Access (CDMA) – Principalmente utilizado en los Estados Unidos.

Banda ancha satelital: Utiliza una antena parabólica direccional alineada con el satélite en órbita geoestacionaria. 
Necesita una línea clara del sitio. Normalmente se usa en ubicaciones rurales donde el cable y el DSL no están disponibles.


### Estándares 802.11

802.11	2,4 GHz	

    velocidades de hasta 2 Mbps

802.11a	5 GHz	

    velocidades de hasta 54 Mbps
    Área de cobertura pequeña
    menos efectivo penetrando estructuras de construcción
    No interoperable con 802.11b o 802.11g 

802.11b	2,4 GHz	

    velocidades de hasta 11 Mbps
    Mayor alcance que 802.11a
    mejor penetración en las estructuras de los edificios.

802.11g	2,4 GHz	

    velocidades de hasta 54 Mbps
    compatible con versiones anteriores de 802.11b con capacidad de ancho de banda reducida

802.11n	2.4 GHz 5 GHz	

    las velocidades de datos varían de 150 Mbps a 600 Mbps con un rango de distancia de hasta 70 m (230 pies)
    Los AP y los clientes inalámbricos requieren múltiples antenas usando MIMO Tecnología
    Es compatible con dispositivos 802.11a/b/g con datos limitados velocidades

802.11ac	5 GHz	

    proporciona velocidades de datos que van desde 450 Mbps a 1.3 Gbps (1300 Mbps) usando tecnología MIMO
    Se pueden soportar hasta ocho antenas
    Es compatible con dispositivos 802.11a/n con datos limitados

802.11ax	2.4 GHz 5 GHz	

    lanzado en 2019 - último estándar
    también conocido como High-Efficiency Wireless (HEW)
    Mayores velocidades de transmisión de datos
    Mayor capacidad
    maneja muchos dispositivos conectados
    eficacia energética mejorada
    Capacidad de 1 GHz y 7 GHz cuando esas frecuencias estén disponibles
    Busque en Internet Wi-Fi Generación 6 para obtener más información.


### Organizaciones de Estándares Inalámbricos 

Los estándares aseguran la interoperabilidad entre dispositivos fabricados por diferentes fabricantes. A nivel internacional, las tres organizaciones que influyen en los estándares WLAN: 

- International Telecommunication Union (UIT):  Regula la asignación del espectro radioeléctrico y las órbitas satelitales.
- Institute of Electrical and Electronics Engineers (IEEE): Especifica cómo se modula una frecuencia de radio para transportar información. Mantiene los estándares para redes de área local y metropolitana (MAN) con la familia de estándares IEEE 802 LAN / MAN. 
- Alianza Wi-Fi: Promueve el crecimiento y la aceptación de las WLAN. Es una asociación de proveedores cuyo objetivo es mejorar la interoperabilidad de los productos que se basan en el estándar 802.1


## Componentes de la WLAN

### Categorías AP

Los AP se pueden categorizar como AP autónomos o AP basados en controladores. 

#### AP autónomos 

Dispositivos independientes configurados a través de una interfaz de línea de comandos o GUI. Cada AP autónomo actúa independientemente de los demás y es configurado y administrado manualmente por un administrador.

#### APs basados en controlador 

También conocidos como AP ligeros (LAPs). Utilice el Protocolo de punto de acceso ligero (LWAPP) para comunicarse con un controlador LWAN (WLC). Cada LAP es configurado y administrado automáticamente por el WLC.


### Antenas Inalámbricas

Tipos de antenas externas:

- Omnidireccional– Proporcionan cobertura de 360 grados. Ideal en áreas de viviendas y oficinas.
- Direccional– Enfoca la señal de radio en una dirección específica. Ejemplos son el Yagi y el plato parabólico.
- Multiple Input Multiple Output (MIMO) – Utiliza múltiples antenas (hasta ocho) para aumentar el ancho de banda.


## Funcionamiento de la WLAN

### 802.11 Modos de topología inalámbrica

Modo ad hoc - Se utiliza para conectar clientes de igual a igual sin un AP.

Modo de infraestructura - Se usa para conectar clientes a la red utilizando un AP.

Tethering - La variación de la topología ad hoc es cuando un teléfono inteligente o tableta con acceso a datos móviles está habilitado para crear un punto de acceso personal.


### BSS y ESS

El modo de infraestructura define dos bloques de topología:

Conjunto de Servicios Básicos (BSS)

- Utiliza un AP único para interconectar todos los clientes inalámbricos asociados.
- Los clientes en diferentes BSS no pueden comunicarse.

Conjunto de Servicios Extendidos (ESS)

- Una unión de dos o más BSS interconectados por un sistema de distribución por cable.
- Los clientes en cada BSS pueden comunicarse a través del ESS.


### CSMA/CA

Las WLAN son semidúplex y un cliente no puede "escuchar" mientras envía, por lo que es imposible detectar una colisión. 

Las WLAN utilizan el acceso múltiple con detección de operador con evitación de colisiones (CSMA / CA) para determinar cómo y cuándo enviar datos. Un cliente inalámbrico hace lo siguiente:

1. Escucha el canal para ver si está inactivo, es decir, no hay otro tráfico actualmente en el canal.
1. Envía un mensaje Ready to Send (RTS) al AP para solicitar acceso dedicado a la red.
1. Recibe un mensaje Clear to Send (CTS) del AP que otorga acceso para enviar.
1. Espera una cantidad de tiempo aleatoria antes de reiniciar el proceso si no se recibe un mensaje CTS.
1. Transmite los datos.
1. Reconoce todas las transmisiones. Si un cliente inalámbrico no recibe el reconocimiento, supone que ocurrió una colisión y reinicia el proceso.


## Funcionamiento de la CAPWAP

### Introducción a CAPWAP


CAPWAP es un protocolo estándar IEEE que permite que un WLC administre múltiples AP y WLAN.

Basado en LWAPP pero agrega seguridad adicional con Datagram Transport Layer Security (DLTS).

Encapsula y reenvía el tráfico del cliente WLAN entre un AP y un WLC a través de túneles utilizando los puertos UDP 5246 y 5247.

Opera sobre IPv4 e IPv6. IPv4 usa el protocolo IP 17 e IPv6 usa el protocolo IP 136.


### Cifrado DTLS

DTLS proporciona seguridad entre el AP y el WLC.

Está habilitado de manera predeterminada para proteger el canal de control CAPWAP y cifrar todo el tráfico de administración y control entre AP y WLC.

El cifrado de datos está deshabilitado de manera predeterminada y requiere que se instale una licencia DTLS en el WLC antes de que se pueda habilitar en el AP.

### Conexión flexible a AP

FlexConnect permite la configuración y el control de Aps a través de un enlace WAN.
Hay dos modos de opción para la Conexión flexible a AP:

- Modo conectado – El WLC es accesible. La Conexión flexible a AP tiene conectividad CAPWAP con el WLC a través del túnel CAPWAP. El WLC realiza todas las funciones CAPWAP.
- Modo independiente – El WLC es inalcanzable. La Conexión flexible a AP ha perdido la conectividad CAPWAP con el WLC. La Conexión Flexible a AP puede asumir algunas de las funciones de WLC, como cambiar el tráfico de datos del cliente localmente y realizar la autenticación del cliente localmente.


## Gestión de Canales

Si la demanda de un canal inalámbrico específico es demasiado alta, el canal puede sobresaturarse, degradando la calidad de la comunicación.
La saturación de canales se puede mitigar utilizando técnicas que usan los canales de manera más eficiente.

Direct-Sequence Spread Spectrum (DSSS) - Una técnica de modulación diseñada para extender una señal sobre una banda de frecuencia más grande. Usado por dispositivos 802.11b para evitar interferencias de otros dispositivos que usan la misma frecuencia de 2.4 GHz.

Frequency-Hopping Spread Spectrum (FHSS) - Transmite señales de radio cambiando rápidamente una señal portadora entre muchos canales de frecuencia. El emisor y el receptor deben estar sincronizados para "saber" a qué canal saltar. Usado por el estándar 802.11 original.

Orthogonal Frequency-Division Multiplexing (OFDM) -  Subconjunto de multiplexación por división de frecuencia en el que un solo canal utiliza múltiples subcanales en frecuencias adyacentes. Una serie de sistemas de comunicación, incluidos los estándares 802.11a/g/n/ac, usa OFDM. 


## WLAN seguras

### Métodos de autenticación de clave compartida

Actualmente hay cuatro técnicas de autenticación de clave compartida disponibles, como se muestra en la tabla. 
Hasta que la disponibilidad de dispositivos WPA3 se vuelva omnipresente, las redes inalámbricas deben usar el estándar WPA2.


Privacidad equivalente al cableado (WEP) 

- La especificación original 802.11 designada para proteger los datos usando el Rivest Cipher 4 (RC4) Método de cifrado con una llave estática. Sin embargo, La llave nunca cambia cuando se intercambian paquetes. Esto lo hace fácil de hackear. WEP ya no se recomienda y nunca debe usarse.

Acceso Wi-Fi protegido (WPA) 	

- Un estándar de alianza Wi-Fi que usa WEP, pero asegura los datos con un cifrado más sólido que el Protocolo de integridad de clave temporal (TKIP). generación de hash. El TKIP cambia la clave para cada paquete, lo que hace que sea mucho más difícil de hackear

WPA2

- WPA2 es un estándar de la industria para proteger las redes inalámbricas. Suele Utilizar el Estándar de cifrado avanzado (AES) para el cifrado. AES es actualmente se considera el protocolo de cifrado más sólido.

WPA3

- La próxima generación de seguridad Wi-Fi. Todos los dispositivos habilitados para WPA3 usan los últimos métodos de seguridad, no permiten protocolos heredados obsoletos y requieren el uso de Tramas de administración protegidas (PMF). Sin embargo, los dispositivos con WPA3 no están disponibles fácilmente.


### Autenticando a un Usuario Doméstico

Los routers domésticos suelen tener dos opciones de autenticación: WPA y WPA2. Con WPA 2 tenemos dos métodos de autenticación.

- Personal: Destinados a redes domésticas o de pequeñas oficinas, los usuarios se autentican utilizando una clave precompartida (PSK). Los clientes inalámbricos se autentican con el enrutador inalámbrico utilizando una contraseña previamente compartida. No se requiere ningún servidor de autenticación especial.
- Empresa: Destinado a redes empresariales. Requiere un servidor de autenticación de Servicio de usuario de acceso telefónico de autenticación remota (RADIUS). El servidor RADIUS debe autenticar el dispositivo y, a continuación, se deben autenticar los usuarios mediante el estándar 802.1X, que usa el protocolo de autenticación extensible (EAP).


### Métodos de encriptación

WPA y WPA2 incluyen dos protocolos de encriptación:

- Protocolo de integridad de clave temporal (Temporal Key Integrity Protocol (TKIP)): Utilizado por WPA y proporciona soporte para equipos WLAN heredados. Hace uso de WEP pero encripta la carga útil de Capa 2 usando TKIP.
- Estándar de cifrado avanzado (Advanced Encryption Standard (AES)): Utilizado por WPA2 y utiliza el modo de cifrado de contador con el protocolo de código de autenticación de mensajes de encadenamiento de bloque (CCMP) que permite a los hosts de destino reconocer si los bits cifrados y no cifrados han sido alterados.


### Autenticación en la empresa

La elección del modo de seguridad empresarial requiere un servidor RADIUS de autenticación, autorización y contabilidad (AAA).
Allí se requieren piezas de información:

- Dirección IP del servidor RADIUS: Dirección IP del servidor.
- Números de puerto UDP: Los puertos UDP 1812 para la autenticación RADIUS y 1813 para la contabilidad RADIUS, pero también pueden funcionar utilizando los puertos UDP 1645 y 1646.
- Llave compartida: Se utiliza para autenticar el AP con el servidor RADIUS.

> Nota: La autenticación y autorización del usuario se maneja mediante el estándar 802.1X, que proporciona una autenticación centralizada basada en el servidor de los usuarios finales.


### WPA 3

Debido a que WPA2 ya no se considera seguro, se recomienda WPA3 cuando esté disponible. WPA3 incluye cuatro características:

- WPA3 Personal: Frustra los ataques de fuerza bruta mediante el uso de la autenticación simultánea de iguales (Simultaneous Authentication of Equals, SAE).
- WPA3 Empresa: Utiliza la autenticación 802.1X / EAP. Sin embargo, requiere el uso de una suite criptográfica de 192 bits y elimina la combinación de protocolos de seguridad para los estándares 802.11 anteriores.
- Redes Abiertas: No usa ninguna autenticación. Sin embargo, utiliza el cifrado inalámbrico oportunista (OWE) para cifrar todo el tráfico inalámbrico.
- Incorporación de IoT : Utiliza el Protocolo de aprovisionamiento de dispositivos (DPP) para incorporar rápidamente dispositivos IoT.

