# 205 configuración de red

## 205.1 Configuración básica

### Protocolos de red



**Modelo OSI**

| Num  | Capa            | Unidad              | Función                                                      |
| ---- | --------------- | ------------------- | ------------------------------------------------------------ |
| 7    | Aplicación      | Datos               | Apis de alto nivel                                           |
| 6    | Prestación      | Datos               | Traducción de datos entre un servicio de red y una aplicación |
| 5    | Sesión          | Datos               | Manejo de sesiones de comunicación, por ejemplo el continuo intercambio de información en  forma de múltiples transmisiones hacia ambos lados entre dos nodos |
| 4    | Transporte      | Segmento, Datagrama | Transmisión de segmentos de datos confiable entre puntos de red PUERTOS (TCP/UDP, ...) |
| 3    | Red             | Paquete             | Estructura y manejo de una red multinodo (IP)                |
| 2    | Enlace de datos | Trama               | transmisión de datos entre dos nodos (Ethernet)              |
| 1    | Física          | Bit                 | Transmisión y recepción de flujos de bits (el cable)         |



**Modelo TCP/IP**

| Capa             | Protocol         | Dades              | Funció                                                       |
| ---------------- | ---------------- | ------------------ | ------------------------------------------------------------ |
| Acces a la xarxa | Ethernet (MAC)   | Trama              | transmisión de datos entre dos nodos                         |
| Internet         | IP               | Paquet             | Estructura y manejo de una red multinodo                     |
| Transport        | TCP/UDP (PUERTO) | Segment, Datagrama | Transmisión de segmentos de datos confiable entre puntos de red |
| Aplicació        | http/s, ftp...   | Datos              | Traducción de datos entre un servicio de red y una aplicación |



Algunos Protocolos:

**IP** (internet Protocol) Su principal función es transmitir datos entre un origen y un destino que tendrán un identificador asignado (dirección IP). 

**TCP** (Transmissión Control Protocol) Garantiza que los paquetes lleguen correctamente sin errores y en orden. También dispone de control de flujo.

**UDP** (User Datagram Protocol) Permite el envió de paquetes sin establecer antes una conexión. No proporciona ninguna de las garantías de funcionamiento de TCP. Al ser más lijero, aumenta su velocidad.

**ICMP** Se utiliza para transmitir datos de estado y mensajes de error. (ej: Ping)



#### IPv4

Una dirección IPv4 está formada por un conjunto de 32 bits separados en 4  grupos de 8 bits, representados en forma decimal, denominados  “cuadrícula de puntos”. Por ejemplo:

Formato binario (4 grupos de 8 bits)  `11000000.10101000.00001010.00010100`                 

Formato decimal `192.168.10.20`  



**Clases de direcciones**

Teóricamente, las direcciones IP están separadas por clases, que se definen por el rango del primer octeto.

Clase A `1.0.0.0` - `126.255.255.255` sus primeros 3 bit son `000`

Clase B `128.0.0.0 - 191.255.255.255` sus primeros tres bit son `100`

Clase C `192.0.0.0 - 223.255.255.255` sus primeros 3 bit son `110`

| Clase | Primer octeto | ip publica                      | ip privadas                   |
| ----- | ------------- | ------------------------------- | ----------------------------- |
| A     | 1-126         | `1.0.0.0` - `126.255.255.255`   | 10.0.0.0 - 10.255.255.255     |
| B     | 128-191       | `128.0.0.0` - `191.255.255.255` | 172.16.0.0 - 172.31.255.255   |
| C     | 192-223       | `192.0.0.0` - `223.255.255.255` | 192.168.0.0 - 192.168.255.255 |



**Conversiones**

Es importante saber cómo convertir direcciones IP entre formatos binarios y decimales.

La conversión de formato decimal a binario se realiza mediante divisiones consecutivas entre 2 hasta que el cociente sea igual a 1.

```bash
105/2 = 52 resto = 1
52/2  = 26 resto = 0
26/2  = 13 resto = 0
13/2  = 6  resto = 1
6/2   = 3  resto = 0
3/2   = 1  resto = 1
```

Agrupamos todos los restos mas el último cociente, y completamos con 0 a la izquierda hasta llegar a 8 bits.

```bash
1101001	# agrupacion de divisiones
01101001	# Añadir 0 izquierda hasta tener 8 bits
```



En este ejemplo, usaremos el valor binario `10110000` para convertirlo a decimal.

| 128  | 64   | 32   | 16   | 8    | 4    | 2    | 1    |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| 2**7 | 2**6 | 2**5 | 2**4 | 2**3 | 2**2 | 2**1 | 2**0 |
| 1    | 0    | 1    | 1    | 0    | 0    | 0    | 0    |

Ahora solo queda sumar los bits activos `128 + 32 + 16 = 176`  por lo tanto el binario `10110000` es igual a 176 en decimal.



**Máscara de red (CIDR)**

**CIDR** (Clasless Inter-Domain Routing)  Para separar la parte de la IP que hace referencia a la red y la parte destinada al host se utiliza la **máscara de red**.

La mascara es un *filtro* de bits que indica con un `1` lo que pertenece a la red y con un `0` la parte de host

Ejemplo: Dirección privada tipo C `192.168.1.55` con mascara `255.255.255.0`  , que también se puede representar como `192.168.1.55/24` . En binario seria:

```bash
11000000.10101000.00000001.00110111	# ip
11111111.11111111.11111111.00000000	# máscara
```



**Subneting**

Es la división de una red en varias subredes usando una máscara de red destinada para ello.

Si tengo una red madre `192.168.0.0/24` y dentro de esta red quiero 4 subredes, aumento la máscara `/26`

descripción:

```bash
11111111.11111111.11111111.00000000	# máscara original
11111111.11111111.11111111.11000000	# máscara nueva
# subredes nuevas
11111111.11111111.11111111.00000000
11111111.11111111.11111111.01000000
11111111.11111111.11111111.10000000
11111111.11111111.11111111.11000000
```

Esto me asigna `2**2 = 4`  nuevas subredes 



**Identificar dirección de red y broadcast**

Suponiendo que tenemos la ip `192.168.8.12` y la mascara `255.255.255.192`  y queremos saber la dirección de red y de broadcast.

Para identificar la dirección de red hay que superponer la ip y la mascara, entonces miramos los bits coincidentes por debajo de la máscara, es decir a partir del bit `/26` en este caso

```bash
11000000.10101000.00001000.00001100	(192.168.8.12)
11111111.11111111.11111111.11000000 (255.255.255.192)
# dirección de red
11000000.10101000.00001000.00000000	(192.168.8.0)
```

Ahora para obtener la dirección de broadcast "debemos usar la dirección de  red donde todos los bits relacionados con la dirección del host son 1:

```bash
11000000.10101000.00001000.00000000	(192.168.8.0)
11111111.11111111.11111111.11000000 (255.255.255.192)
# dirección broadcast
11000000.10101000.00001000.00111111	(192.168.8.63)
```





#### IPv6

**Utiliza 128 bits** divididos en 8 grupos de 16 bits: admite 350 sextillones de IP's distintas

**Notación Hexadecimal**: Esta representado por ocho grupos de cuatro dígitos en hexadecimal.

- Los grupos se separan por `:`
- Si hay varios ceros seguidos se pueden quitar (pero solo una vez) `:0000:0000: = ::`
- Los ceros a la izquierda se pueden quitar `:0001:000F: = :1:F:`

```bash
20a0:1234:5678::1 es equivalente a 20a0:1234:5678:0000:0000:0000:0000:0001
20a0:1:2:3:4:5:6:7 es equivalente a 20a0:0001:0002:0003:0004:0005:0006:0007
```

La parte host en 64 bits de una dirección IPv6 se genera localmente en la mayoría de los casos a partir de la dirección MAC de la interfaz física. (`fffe` se añade para completar los 64 bits)

```bash
2: enp3s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether b4:2e:99:48:ad:b6 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::b62e:99ff:fe48:adb6/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
```



**Autoconfigurable**: Puede asignarse un valor basándose en la MAC

**Sin máscara de red**: la parte de red siempre son los cuatro primeros grupos y el resto es el host

**Más seguro**: Incorpora opciones sobre seguridad. IPsec está integrado y permite autenticar y cifrar los paquetes.



**Tipo de direcciones**

`Unidifusión`: Identifica una única interfaz de red. De forma predeterminada, los 64 bits de la izquierda identifican la red y los 64 bits de la derecha identifican la interfaz.                  

`Multidifusión` : Identifica un conjunto de interfaces de red. Un paquete enviado a una dirección de multidifusión se enviará a todas las interfaces que pertenecen a ese grupo. Aunque es similar, no debe confundirse con la transmisión, que no existe en el protocolo IPv6.                  

`Anycast`:  Esto también identifica un conjunto de interfaces en la red, pero el paquete reenviado a una dirección *anycast* se entregará a una sola dirección en ese conjunto, no a todos.                  

### Configuración de red

Las interfaces de red se pueden visualizar con:

```bash
ip link show
nmcli device
```

De mayor a menor prioridad, el sistema operativo utiliza las siguientes reglas para nombrar y numerar las interfaces de red:

1. Nombra la interfaz según el índice proporcionado por el BIOS o por el firmware de los dispositivos integrados, por ejemplo `eno1`.
2. Nombra la interfaz después del índice de la ranura PCI Express, como lo indica el BIOS o el firmware, por ejemplo `ens1`.
3. Asigne un nombre a la interfaz según su dirección en el bus correspondiente,  `enp3s5`.  Ej `lspci -s 03:05.0` 
4. Nombre la interfaz después de la dirección MAC de la interfaz, por ejemplo `enx78e7d1ea46da`.
5. Nombra la interfaz usando la convención heredada, por ejemplo `eth0`.



**Ficheros principales:** 

`/etc/hostname` fichero que guarda el nombre de host. Se puede editar o utilizar el comando `hostname`

```bash
hostname nuevo_nombre
-s	# consulta nombre
-f	# consulta nombre y dominio
```

 `/etc/hosts` Fichero para asociar nombres a IP's. Cada linea contiene una IP seguida de uno o mas nombres asociados a dicha ip.

`hostnamectl`  comando del ecosistema Systemd para modificar el nombre de host  y otros valores.

```bash
hostnamectl	# consultar hostname, kerner, arquitectura, ...
hostnamectl status # idem anterior
hostnamectl set-hostname nuevo_nombre
```

`/etc/resolv.conf` Fichero en el que tradicionalmente se han configurado las Ip de los servidores DNS

```bash
nameserver 1.1.1.1	# dns de salida a buscar
domain mydomain.org	# dominio local
search mydominio.net mydominio.com	# idem anterior pero en lista
```

> los dominios locales se asignan automáticamente al utilizar nombres cortos Ej `ping server`  sera resuelto como `ping server.mydomain.org` 



`/etc/nsswitch.conf` especifica el orden en el que se buscará información en una serie de datos. 

Por ejemplo la resolución de nombres de IP, consultara antes el archivo `hosts` que el `resolv.conf`

```bash
...
hosts: files dns
...
```



####  Networking

`/etc/network/interfaces` fichero de configuración en distribuciones derivadas debian.

```bash
# ip dinamica
auto enp3s0	# activar tarjeta de red en el arranque
iface enp3s0 inet dhcp	# config con dhcp

# ip statica
iface enp2s1 inet static
address 192.168.0.5/24
gateway 192.168.0.1
```



`/etc/sysconfig/network-script/ifcfg-nombre-interfaz`   fichero de configuración en distribuciones derivadas Red Had.

```bash
TYPE=Ethernet			# tipo de interfaz
DEVICE=enp3s0			# nombre de interfaz
NM_CONTROLLED="no"		# ignorado por NetwoerkManager
ONBOOT=yes				# iniciar al arrancar el sistema
BOOTPROTO=none			# usar config statica (dhcp)
HWADDR=01:0A:03:1F:67:10	# direccion MAC
IPADDR=192.168.0.5		
NETMASK=255.255.255.0
NETWORK=192.168.0.0
GATEWAY=192.168.0.1
```

El kernel ejecutas en el arranque `ifup -a` y levanta todas las interfaces configuradas en `/etc/network/interfaces`

```bash
ifup "interface"	# activar
ifdown "interface"	# desactivar
-a 	# todas las interfaces
```



#### NetworkManager

Este programa para gestionar la red creado por Red Had se popularizó por su integración en l entorno gráfico y la fácil gestión de redes inalámbricas.



`nmcli` es su comando principal para gestionar la red desde la shell. Este separa todas las propiedades relacionadas con la red controladas por NetworkManager en categorías llamadas *objetos* :

`general` Estado y operaciones generales

`networking` control general de red

`radio` Conmutadores de radio 

`connection` conexiones

`device` dispositivos gestionados

`agent` agente secreto de networkmanager o agente polkit

`monitor` supervise los cambios de networkmanager

```bash
nmcli
dev status					# muestra el stado de las interfaces
dev show "interface"		# opciones de la interfaz
con edit "interface"		# editar propiedades conexion
con modify "interface" propiedad valor # cambiar una opción de la interfaz
dev connect "interface"		# activar interfaz
dev disconect "interface"	# desactivar interfaz

radio wifi [on|off]		# apagar o encender adaptador wifi
dev wifi list			# muestra conexiones posibles de wifi
dev wifi connect SSID password contraseña	# conectar a wifi seleccionada
dev wifi connect SSID password contraseña hidden yes	# conectar a wifi oculta
connection down SSID # desconectar wifi seleccionada
connection up SSID # volver a conectar de nuevo a wifi
```

`nmtui` tiene una interfaz basada en curses. Es una interfaz semi gráfica para terminal muy fácil de utilizar.



#### Systemd-networkd

Los sistemas que ejecutan systemd pueden usar opcionalmente sus demonios integrados para administrar la conectividad de la red: `systemd-networkd` controla las interfaces de red y `systemd-resolved` administra la resolución de nombres local.

Los archivos de configuración utilizados por systemd-networkd para  configurar las interfaces de red se pueden encontrar en cualquiera de  los siguientes tres directorios:

`/etc/systemd/network`  El directorio de la red de administración local. 

`/run/systemd/network`  El directorio de red de tiempo de ejecución volátil. 

`/lib/systemd/network`  El directorio de red del sistema. 

los directorios nombrados tienen prioridad entre ellos donde `/etc` es tiene la más alta y `/lib` la más baja. El proposito de los archivos de configuración dentro de estos directorios dependen de su `.sufijo`:

`.netdev` son utilizados por systemd-networkd para crear dispositivos de red virtual

`.link` configuraciones establecidas de bajo nivel para la interfaz de red correspondiente. 

`.network`  Los archivos que utilizan este sufijo se pueden utilizar para configurar direcciones y rutas de red

Ejemplo `/etc/systemd/network/30-lan.network`

```bash
[Match]
MACAddress=00:16:3e:8d:2b:5b
#Name=enp3s5
#Name=enp3s5 enp3s4
#Name=enp*

[Network]
Address=192.168.0.100/24
Gateway=192.168.0.1
```

> Una misma configuración se puede utilizar para diferentes interfaces pero siempre es mejor especificar la MAC



Configuración con dhcp

```bash
[Match]
MACAddress=00:16:3e:8d:2b:5b

[Network]
DHCP=yes
```

La opción `DHCP` acepta valores de `ipv4` o `ipv6` si se quiere especificar un dhcp concreto

##### redes  inalámbricas

Las interficies wifi son muy similares el único cambio es que además de crear el archivo `.network` se a de crear uno adicional con las credenciales.

`/etc/systemd/network/20-wifi.network`

```bash
[Match]
Name=wlo1

[Network]
DHCP=yes
```

Crear archivo con las credenciales `MyWifi` es el `SSID` y la contraseña se introduce en el stdin generado

```bash
wpa_passphrase MyWifi > /etc/wpa_supplicant/wpa_supplicant-wlo1.conf
```

Para acabar habilitamos la conexión inalámbrica en el arranque

```bash
systemctl start wpa_supplicant@wlo1.service
systemctl enable wpa_supplicant@wlo1.service
```



#### TCP wrappers

Es un sistema para conceder o denegar acceso según las reglas que contienen los ficheros:

- `/etc/hosts.allow` contiene los hosts que tienen permitido el acceso

- `/etc/hosts.deny`  contiene los hosts que tienen denegado el acceso

> Si una regla está en ambos archivos, siempre tendrá prioridad el archivo `hosts.allow`



El contenido de estos ficheros son reglas de tipo `lista_servicios:lista_host` donde *lista_servicios* son uno o más servicios de los que figuran en `/etc/services` y *lista_host* se puede indicar con nombres, direcciones IP o redes completas.

En ambas se pueden usar comodines como ALL, LOCAL, ...

```bash
# lista-servicios:lista_hosts
ALL:*.example.com	# todos los que pertenezcan a el subdominio de example.com
sshd:192.168.1.10	# un host concreto
sshd:192.168.1.		# una red concreta
```



**Saber si un servicio está utilizando TCP Wrappers** 

Buscar la directiva *hosts_access* con el comando `strings`

```bash
strings /usr/sbin/sshd | grep hosts_access
strings -f /usr/sbin/* | grep hosts_access
```

Comprobar si utiliza la librería `libwrap`

```bash
ldd /usr/bin/sshd | grep libwrap
```





## 205.2 Configuración avanzada

### VPN

Una **VPN** (red privada virtual) le permite conectar VPN dos o más redes  remotas de forma segura a través de una conexión insegura, por ejemplo, a través de la Internet pública. 

Tipos de VPN: `IPSEC, VPND, SSH, SSL/TLS,`  enrutadores cisco privativos.

**IPSEC** proporciona servicios de encriptación y autenticación a nivel de IP  (Protocolo de Internet) de la pila de protocolos de red IPSEC. 

Protocolos que se utilizan en IPSEC:

- `ESP` Cifra y/o autentica datos
- `AH` Proporciona un servicio de autenticación de paquetes
- `IKE` Negocia los parámetros de conexión, incluidas las claves, para los protocolos mencionados anteriormente.  normalmente genera un dominio que trabaja en 500/udp



### Rastreo de Red

**libpcap** se creó a partir de los primeros desarrollos de un comando de captura llamado **tcpdump**. Posteriormente, fue utilizada por muchos programas de análisis de red, entre los cuales el célebre **wireshark**.

`tcpdump` es una herramienta que devuelve por la salida estándar un resumen de las capturas realizadas por la tarjeta de red. 

```bash
tcpdump -w archivo -i interfaz -s ventana -n filtro 
tcpdump -w archivo.cap -i eth0 -s 0 -n port 80 and host 192.168.50.24 
```



### Funcionamiento DHCP

DHCP (Dynamic Host Configuration Protocol) es un protocolo cliente/servidor que tiene como objetivo asignar automáticamente una dirección IP, así como los parámetros funcionales a los equipos de la red. 

`DHCPDISCOVER` Descubrimiento de servidor: el cliente envia un brodcast a la red para ver si existe algún servidor DHCP

`DHCPOFFER` Respuesta de servidor: como el cliente aun no tiene ip se envia un broadcast con la configuración.

`DHCPREQUEST` Aceptación: el cliente envia una aceptación de la configuración en broadcast.

`DHCPACK` Acuse de recibo: El servidor realiza la asignación de la dirección y cierra la transacción enviando un acuse de recibo. 

El archivo de configuración  `/etc/dhcpd/dhcpd.conf` se basa en una configuración global y a partir de ahí se asignan opciones por subred o host.

```bash
# Configuració general
default-lease-time 86400;
max-lease-time 259200;
option routers 192.168.88.1;
option subnet-mask 255.255.255.0;
option broadcast-address 192.168.88.255;
option domain-name-servers 8.8.8.8, 1.1.1.1;
option domain-name-servers 192.168.88.4;
option domain-search "local.lan";

# Aquest servidor dhcp sera el principal la subxarxa
authoritative;

# Subxarxa
subnet 192.168.88.0 netmask 255.255.255.0 {
  range 192.168.88.10 192.168.88.25;
}

# (Torre [Ethernet])
host torreEthernet {
  option host-name "pc02";
  hardware ethernet b4:2e:99:48:ad:b6;
  fixed-address 192.168.88.2;
}
```

El servidor DHCP conserva la información de cada una de las concesiones asignadas en el archivo **dhcpd.leases**, que se encuentra en el directorio **/var/lib/dhcp/**.

```bash
dhclient enp3s0		# pedir configuracion
dhclient -r enp3s0	# eliminar configuración
```





## 205.3 resolución de problemas

### Resolución de problemas básicos de red

#### Obsoletos

El paquete de comandos de **net-tools**  se considera su obsoleto pero se puede seguir utilizando si descargas el paquete de los repositorios, algunos de sus comandos son:

**ifconfig**

administra interfaces de red

```bash
ifconfig
ifconfig "interfaz"
ifconfig "interfaz" [up|down]
ifconfig "interfaz" 192.168.0.6/24
ifconfig "interfaz" netmask 255.255.255.0
ifconfig enp3s0 add 2001:db8::10/64 # con ipv6 se utiliza add
```

**netstat**

muestra las conexiones de red, tablas de enrutamiento y estadísticas de tráfico.

```bash
netstat
-t	# conexiones tcp
-u	# conexiones udp
-6|-4	# ipv4 o ipv6
-l	# puestos a la escucha
-p	# nombre del programa
-n	# no hacer resolucion de nombres
-r	# ver tabla de enrutamiento
```

**route**

administra las tablas de enrutamiento ip.

```bash
route
route add default gw 192.168.1.1	# ruta predeterminada
route -n	# traza ruta con ip's, no haxce resolución de nombres
```



La tabla de las versiones nuevas a estos comandos son:

| Comandos Obsoletos | actuales equivalentes                      |
| ------------------ | ------------------------------------------ |
| arp                | ip n (ip neighbor)                         |
| ifconfig           | ip a (ip addr), ip link, ip -s (ip -stats) |
| netstat            | **ss**, ip route, ip -s link, ip maddr     |
| route              | ip r (ip route)                            |

**iw**

se utiliza para configurar dispositivos inalámbricos. Solo es compatible con el estándar nl80211 (netlink)

```bash
iw command
iw [options] [object] command

iw dev wlan0 link	# estado del dispositivo
iw dev wlan0 scan	# busca puntos de acceso
iw dev wlan0 connect "Access Point"         
iw dev wlan0 connect "Access Point" 2432        
iw dev wlan0 connect "Access Point"  0:"Your Key"
iw dev wlan0 set type ibss            
iw dev wlan0 ibss join "Access Point" 2432
iw dev wlan0 ibss leave
iw dev wlan0 set power_save on
```



#### Actualidad

**Rastreo  de rutas**

para rastrear una ruta existen diferentes  herramientas como:

`tracepath/tracepath6`  muestra el camino recorrido hasta llegar al destino indicado

`traceroute/traceroute6` parecido a tracepath pero con más opciones. este por defecto envía paquetes UDP basura al puerto `33434` 

```bash
traceroute learning.lpi.org
sudo traceroute -I learning.lpi.org # trazar ruta con ICMP (ping)
sudo traceroute -T -p 80 learning.lpi.org # trazar ruta con TCP al puerto 80
traceroute -i enp2s0 learning.lpi.org	# utilizar interfaz diferente
sudo traceroute -I --mtu learning.lpi.org # informar del MTU (unidad transmision máxima)
```

`ping/ping6` Envía un paquete icmp para comprobar que el destino responde.



**ip**

Remplaza los comandos ifconfig, route y arp. Además aporta otras muchas funciones.

Sintaxis: `ip [OPCIONES] OBJETO [comando [argumentos]]`

Objetos:

- **link**: para configurar los objetos físicos o lógicos de la red
- **address**: manejo de direcciones asociadas a los diferentes dispositivos
- **neighbour**: administrar los enlaces de vecindad (ARP) las resoluciones MAC a IP
- **rule**: ver las políticas de enrutado y cambiarlas
- **route**: ver las tablas de enrutado y cambiar las reglas de las tablas.
- **tunnel**: administrar los túneles ip
- **maddr**:  ver las direcciones multienlace, sus propiedades y cambiarlas
- **mroute**: establecer, cambiar o borrar el enrutado multienlace.
- **monitor**: monitorizar continuamente el estado de los dispositivos, direcciones y rutas.

```bash
ip addr show	# mostrar interfaces
ip -c a			# mostrar interfaces con colorines
ip link set enp3s0 up/down	# des/activar interfaz
ip link set dev enp3s0 arp on/of	# des/activar arp
ip addr add 192.168.0.10/24 dev enp3s0	# añadir dirección ip
ip addr del 192.168.0.10/24 dev enp3s0	# eliminar dirección ip

ip route show	# ver tabla enrutamiento
ip route add default via 192.168.1.1	# añadir puerta de enlace
ip route add 10.10.50/24 via 192.168.1.1 dev enp3s0 # añadir ruta
ip route del 10.10.50/24		# eliminar ruta
ip route save > ./route_backup	# hacer backup de tabla enrutamieno
ip route restore < ./route_backup	# resaurar bckup

ip neighbour	# ver tabla arp
```

**arp**

Protocolo de resolución de direcciones ARP crea un mapeo entre una dirección IP y la dirección MAC donde se configura la dirección IP.

```bash
arp
```



**ss**

Socket statistics obtiene información sobre los sockets (internos y de red). 

Sus **opciones** principales son muy similares a `netstat`

```bash
ss [options] [filter]
-t	# conexiones tcp
-u	# conexiones udp
-6|-4	# ipv4 o ipv6
-l	# puestos a la escucha
-p	# nombre del programa
-n	# no hacer resolucion de nombres
-r	# intentar hacer resolucion
```

Los **filtros**  son muy potentes en `ss` y una vez dominados generan una gran ayuda para encontrar los sockets requeridos

`filtro := [state ESTADO-TCP] [exclude ESTADO-TCP] [expresión]`

Con `state` los sockets deben estar en: `ESTABLISHED, LISTENNING, CLOSED, CONNECTED, TIME-WAIT, ...`

Con `exclude` se excluirán los que estén en el estado indicado.

`expresión` se puede construir con:

- los operadores `and` (por defecto), `or` y `not`
- (origen y/o destino) `{src|dst} [IP[/prefijo]][:puerto]`
- (puerto origen/destino) `{dport|spor} {eq|neq|gt|ge|lt|le} [IP]:puerto`

```bash
ss state establised '( sport = :http or sport = :https )' src 192.168.1.0/24
ss sport neq :21 and sport neq :https or not dst 192.168.1.10
```

Explicación segundo comando:  no me muestres la ip destino `192.168.1.10` que tenga como puertos de salida de mi host  `21 o 443` 



**netcat** 

abre un puerto en un host (que hará de servidor) y recoge todo lo que envía un cliente.

```bash
nc
-l	# abre un puerto a la escucha, acepta un solo cliente
-p	# indica puerto
-k	# multiples conexiones
-u	# puerto udp en vez de tcp
-e	# indica ruta de fichro que se ejecutara al establcer la conexion
-v	# vervose
-z	# escanear puertos

nc -zv 192.168.0.4 10-500
```



