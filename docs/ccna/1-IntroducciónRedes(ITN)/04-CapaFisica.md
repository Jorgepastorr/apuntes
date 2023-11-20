# Capa Física

## Propósito de la capa física

### La conexión física

- Antes de que pueda ocurrir cualquier comunicación de red, se debe establecer una conexión física a una red local.
- Esta conexión puede ser cableada o inalámbrica, dependiendo de la configuración de la red.
- Una tarjeta de interfaz de red (NIC) conecta un dispositivo a la red.
- Algunos dispositivos pueden tener una sola NIC, mientras que otros pueden tener varias NIC (por ejemplo, cableadas y/o inalámbricas).
- No todas las conexiones físicas ofrecen el mismo nivel de rendimiento.

### La capa física

- Transporta bits a través de los medios de red.
- Acepta una trama completa de la capa de enlace de datos y la codifica como una serie de señales que se transmiten a los medios locales.
- Este es el último paso en el proceso de encapsulación.

## Características de la capa física

### Componentes físicos

Los estándares de capa física abordan tres áreas funcionales:
- Componentes físicos
- Codificación
- Señalización

**Los componentes** físicos son los dispositivos de hardware, medios y otros conectores que transmiten las señales que representan los bits.

**La codificación** convierte la secuencia de bits en un formato reconocible por el siguiente dispositivo en la ruta de red.
Esta 'codificación' proporciona patrones predecibles que pueden ser reconocidos por el siguiente dispositivo.

**El método de señalización** es cómo se representan los valores de bits, «1» y «0» en el medio físico.
El método de señalización variará en función del tipo de medio que se utilice.

### Ancho de banda

El ancho de banda digital mide la cantidad de datos que pueden fluir de un lugar a otro en un período de tiempo determinado; cuántos bits se pueden transmitir en un segundo.

| Unidad de ancho de banda | Abreviatura | Equivalencia |
|:---|:---:|:---|
| Bits por segundo | bps | 1 bps = unidad fundamental de ancho de banda |
| Kilobits por segundo | Kbps | 1 Kbps = 1,000 bps = 103 bps |
| Megabits por segundo | Mbps | 1 Mbps = 1,000,000 bps = 106 bps |
| Gigabits por segundo | Gbps | 1 Gbps – 1,000,000,000 bps = 109 bps |
| Terabits por segundo | Tbps | 1 Tbps = 1,000,000,000,000 bps = 1012 bps |

### Terminología de ancho de banda

Latencia: Cantidad de tiempo, incluidos los retrasos, para que los datos viajan de un punto a otro

Rendimiento: La medida de la transferencia de bits a través de los medios durante un período de tiempo determinado

Capacidad de transferencia útil
- La medida de los datos utilizables transferidos durante un período de tiempo determinado
- Goodput = Rendimiento - sobrecarga de tráfico

## Cableado de cobre

Limitaciones:
- Atenuación: cuanto más tiempo tengan que viajar las señales eléctricas, más débiles se vuelven. 
- La señal eléctrica es susceptible a la interferencia de dos fuentes, que pueden distorsionar y dañar las señales de datos (Interferencia Electromagnética (EMI) e Interferencia de Radiofrecuencia (RFI) y Crosstalk).

Mitigación
- El estricto cumplimiento de los límites de longitud del cable mitigará la atenuación.
- Algunos tipos de cable de cobre mitigan EMI y RFI mediante el uso de blindaje metálico y conexión a tierra.
- Algunos tipos de cable de cobre mitigan la diafonía girando cables de par de circuitos opuestos juntos.

### Directo y Crossover Cables UTP 

| tipo de cable | estandar | aplicación |
|:---|:---|:---|
| Cable directo de Ethernet | Ambos extremos T568A o T568B          | Host a dispositivo de red |
| Ethernet Crossover *      | Un extremo T568A, otro extremo T568B. | Host a host, conmutador a conmutador, enrutador a enrutador |


## Medios inalámbricos

Los estándares de la industria IEEE y de telecomunicaciones para comunicaciones de datos inalámbricas
cubren tanto el vínculo de datos como las capas físicas. En cada uno de estos estándares, las especificaciones de la capa física dictan:
- Métodos de codificación de datos a señales de radio
- Frecuencia e intensidad de la transmisión
- Requisitos de recepción y decodificación de señales
- Diseño y construcción de antenas

Estándares inalámbricos:
- **Wi-Fi (IEEE 802.11)** Tecnología de LAN inalámbrica (WLAN)
- **Bluetooth (IEEE 802.15)** Estándar de red inalámbrica de área personal (WPAN)
- **WiMAX (IEEE 802.16)** utiliza una topología punto a multipunto para proporcionar acceso inalámbrico de banda ancha
- **Zigbee (IEEE 802.15.4)** Comunicaciones de baja velocidad de datos y bajo consumo de energía, principalmente para aplicaciones de Internet de las cosas (IoT)

