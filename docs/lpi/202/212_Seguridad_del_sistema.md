# 212 Seguridad del sistema

## 212.1 Configurar un router

La función de enrutamiento se integra de forma nativa en el núcleo de Linux.  Cualquier máquina Linux es un router en potencia. Sin embargo, esta función no está activada por defecto tras el arranque.

```bash
echo 1 > /proc/sys/net/ipv4/ip_forward	# activar enrutamientio
echo 0 > /proc/sys/net/ipv4/ip_forward	# desactivar enrutamientio
```

Hay otros métodos como utilizar  `sysctl`  que permite modificar dinámicamente los parámetros funcionales del núcleo.

```bash
sysctl net.ipv4.ip_forward=1	# activación temporal
```

Para hacer esta acción permanente habrá que añadir  `net.ipv4.ip_forward = 1`  al fichero `/etc/sysctl.conf` 

Consultar la tabla de enrrutamiento

```bash
ip r 
route -n
netstat -nr
```

Gestionar rutas

```bash
# route add default gw router 
route add -net 0.0.0.0 gw 192.168.50.1
# route add -net red_objetivo netmask máscara gw router 
route add -net 10.0.0.0 netmask 255.0.0.0 gw 192.168.1.99  
# route del -net red_objetivo netmask máscara 
route del -net 10.0.0.0 netmask 255.0.0.0  

ip route show   # ver tabla enrutamiento
ip route add default via 192.168.1.1    # añadir puerta de enlace
ip route add 10.10.50/24 via 192.168.1.1 dev enp3s0 # añadir ruta
ip route del 10.10.50/24        # eliminar ruta
ip route save > ./route_backup  # hacer backup de tabla enrutamieno
ip route restore < ./route_backup   # resaurar bckup
```

### IpTables

Iptables se utiliza para gestionar el filtrado de paquetes IP en un sistema Linux. Iptables puede filtrar el tráfico que transita por un router Linux, pero también el tráfico entrante y saliente de cualquier servidor o estación de trabajo en una sola interfaz.

Iptables se basa en **tablas** asociadas a un modo funcional. Según el tipo de regla que se desea añadir en el funcionamiento de iptables, se precisará la tabla asociada.

- `filter` (por defecto)  objetivo filtrar paquetes.
- `nat`  traducción de direcciones entre una red privada y una red pública. 

Una **cadena** de iptables representa un tipo de tráfico desde el punto de vista de su circulación por una máquina. Las cadenas permiten especificar si una regla debe aplicarse al tráfico que entra en una máquina, que sale o que la cruza.

- `input` identifica el trafico entrante
- `output` identifica el trafico saliente
- `forwarxd`  identifica el tráfico que atraviesa la máquina, entrando por una interfaz y saliendo por otra.
- `postrouting`  se utiliza en NAT y tiene como objetivo tratar paquetes después de una operación de enrutamiento.
- `prerouting`  se utiliza en NAT y tiene como objetivo tratar paquetes antes de una operación de enrutamiento.

Cuando se satisface una regla, el sistema genera una **acción** sobre el paquete comprobado.

| Acciones de FILTER                            | Acciones de NAT                                              |
| --------------------------------------------- | ------------------------------------------------------------ |
| `accept` permite el paso del paquete          | `masquerade` enmascara una ip interna, permite compartir una ip pública entre varias internas |
| `drop` destruye el paquete                    | `dnat` redirige los ip:puertos                               |
| `reject` destruye e informa de la eliminación | `snat` enmascara una ip publica a una ip interna fija (Static NAT) |

El **tratamiento** de reglas se hace secuencial. Se aplican las reglas una por una para cada paquete filtrado. Si se satisface una regla, se genera una acción sobre el paquete y finaliza su tratamiento. Si no se satisface, se comprueba la siguiente regla. En caso de que ninguna regla se haya satisfecho, el paquete recibe un tratamiento por defecto configurado con una regla específica llamada  (policy).

Visualizar las reglas activas con:

```bash
iptables -L	
iptables -S	# comandos aplicados para las reglas activas
```

#### Política por defecto

Existen dos políticas por defecto ACCEPT y DROP, generalmente se  establece en el inicio de los scripts cual sera su política,  aceptar  todo por defecto o denegar todo por defecto.

`ACCEPT` permitirá todo excepto lo que se deniegue explícitamente. `DROP` justo lo contrario, se deniega todo excepto lo permitido explícitamente

```bash
# politica accept
sudo iptables -P INPUT ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -t nat -P PREROUTING ACCEPT
sudo iptables -t nat -P POSTROUTING ACCEPT

# politica drop
sudo iptables -P INPUT DROP
sudo iptables -P OUTPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -t nat -P PREROUTING DROP
sudo iptables -t nat -P POSTROUTING DROP
```

#### Creación de reglas

```bash
# iptables -A cadena -s ip_origen -d ip_destino -p protocolo --dport puerto -j acción 
iptables -A FORWARD -s 192.168.1.0/24 -p tcp -dport 80 -j ACCEPT 
```

|                  | iptables: creación de reglas                                 |
| ---------------- | ------------------------------------------------------------ |
| `-A` cadena      | Se añade una regla en la cadena cadena (INPUT, OUTPUT o FORWARD). |
| `-s` ip_origen   | Opcional: la dirección IP origen de donde provienen los paquetes sometidos a la regla. Si la dirección es una dirección de red, hay que especificar la máscara. |
| `-d` ip_destino  | Opcional: la dirección IP destino a la que van los paquetes sometidos a la regla. Si la dirección es una dirección de red, hay que especificar la máscara. |
| `-p` protocolo   | Indica el protocolo utilizado en el paquete sometido a la regla. Valores comunes: udp, tcp, icmp. Se puede indicar cualquiera de `/etc/protocols` |
| `--dport` puerto | Opcional: indica el puerto de destino del paquete sometido a la regla. |
| `-j` acción      | Indica cómo tratar el paquete sometido a la regla (ACCEPT o DROP). |

Aceptar paquetes de ping

```bash
iptables -A OUTPUT -p icmp -j ACCEPT 
iptables -A INPUT -p icmp -j ACCEPT 
```



#### Gestión de reglas

Las reglas se aplican en su orden de creación y el sistema les asigna automáticamente un número de orden.

```bash
# iptables -L cadena --line-numbers -n
iptables -L INPUT --line-numbers -n

# iptables -D cadena número  (eliminar regla)
iptables -D INPUT 2

# iptables -I cadena número condiciones -j acción (insertar regla en posición determinada)
iptables -I FORWARD 2 -s 192.168.1.0/24 -p tcp --dport 22 -j ACCEPT 
```



#### Flujos de retorno

En la mayoría de las aplicaciones de red, un host envía un paquete con destino otro host que le responde. Por lo tanto, se establece una comunicación bidireccional. La comunicación de ida siempre será tipo 80 o 443, pero de vuelta será un puerto aleatorio superior al 1024 entonces te obliga a abrir todos los puertos superiores a 1024 a no ser que se utilice un cortafuegos ""stateful"

Los cortafuegos llamados "stateful" (con estado) son capaces de autorizar dinámicamente los flujos de retorno siempre que sean respuesta a un flujo de salida explícitamente autorizado.

```bash
# iptables -A cadena -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp --sport 80 -m state \
                    --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT

iptables -A INPUT -p tcp --sport 443 -m state \
                    --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT
```

- `ESTABLISHED` significa que el paquete está asociado con una conexión que  ha visto paquetes en ambos direcciones
- `RELATED` significa  que el paquete está  iniciando una nueva conexión, pero está asociado con una conexión  existente, como una transferencia de datos FTP o un ICMP

#### Gestion NAT

NAT consiste en reescribir la cabecera IP de un paquete que viaja de una red pública a una red privada y viceversa.

Las cadenas que se tratan en la tabla NAT son **PREROUTING**, **POSTROUTING** y **OUTPUT**, que representan el tráfico que hay que modificar antes del enrutamiento, después del enrutamiento o directamente en la salida de la máquina.

```bash
iptables -t nat -L 
iptables -t nat -S
```

En esta configuración, que también es la más corriente, la dirección IP del emisor de los hosts de la red privada se reemplaza por la dirección pública del router NAT.

```bash
# iptables -t nat -A POSTROUTING -o tarjeta_exterior -j acción_nat 
iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE  
```

|                     |                                                              |
| ------------------- | ------------------------------------------------------------ |
| -t nat              | La regla afecta a la tabla NAT.                              |
| -A POSTROUTING      | Se añade una regla a la cadena POSTROUTING, para el procesado después del enrutamiento. |
| -o tarjeta_exterior | Identifica la tarjeta de red por la cual salen los paquetes del cortafuegos. |
| -i tarjeta_interior | Identifica la tarjeta de red por la cual entran los paquetes del cortafuegos. |
| -j acción_nat       | Identifica el modo de acción de NAT: <br />SNAT si la dirección pública es fija, <br />DNAT redirige el puerto `ip:puerto -> ip:puerto`,  <br />MASQUERADE si la dirección pública es dinámica. |

```bash
# SNAT:
# NAT con eth0 como interna y eth1 como externa - dirección IP pública fija 
iptables -t nat -A POSTROUTING  -o eth1 -j SNAT --to-source 81.2.3.4 
# gestión de paquetes devueltos 
iptables -A FORWARD -i eth1 -o eth0 -m state --state ESTABLISHED,RELATED -j ACCEPT 

# DNAT:
# dirigir tot el tràfic http port 80 a un altre host de la LAN
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j DNAT --to 192.168.10.12:80

# MASQUERADE:
# lo que salga de la red interna 172.16.10.0/24 sacalo por eth0
iptables -t nat -A POSTROUTING -s 172.16.10.0/24 -o eth0 -j MASQUERADE
```

#### Scripts de configuración

Añadir vlas reglas una a una es tedioso, para ello utilizamos un script que primero borre todas las reglas y seguidamente valla ejecutando las treglas que queremos 

```bash
#!/bin/bash 
# Borrado de reglas 
iptables -F 
iptables -t nat -F 
# Política permisiva 
iptables -P INPUT ACCEPT 
iptables -P OUTPUT ACCEPT 
iptables -P FORWARD ACCEPT

# mis reglas
iptables -A INPUT -p tcp --dport 20:21 -j DROP
iptables -A INPUT -p tcp --dport 80 -j DROP
...
```

Guardar reglas

```bash
iptables-save > /etc/sysconfig/iptables	# guardar iptables (solo Red Had y deribados)
iptables-save > arxiu.regles.iptables # exportar backup
iptables-restore < arxiu.regles.iptables # inportar backup
```



## 212.2 Gestionar servidores FTP

FTP (File Transfer Protocol) es un protocolo cliente/servidor bastante antiguo que fue uno de los primeros que permitía compartir archivos entre ordenadores. Hoy en día es utilizado  especialmente por los servicios de alojamiento web que ofrecen a sus clientes accesos FTP para actualizar sus páginas web.

El nivel de transporte de FTP es TCP y funciona por el puerto 21 para la transmisión de comandos. El puerto 20 es el que se usa tradicionalmente para transmitir datos, pero no es un comportamiento universal.

El **modo activo**, la sesión se establece en el puerto 21 del servidor y los datos se envian por iniciativa del servidor desde el puerto 20 a un puerto cualquiera del cliente. En este modo el cliente inicia la conexión de control y el servidor inicia la conexión de datos. 

En **modo pasivo** el puerto utilizado para los datos es uno cualquiera que lo anuncia el servidor en modo comando y lo utiliza el cliente para abrir la sesión de datos. En modo pasivo, el cliente inicia ambas conexiones.

### vsftpd

vsftpd es un servidor FTP muy popular, versátil, rápido y seguro.

Configuración mínima para cargas y descargas anóninas:

```bash
listen=NO
local_enable=YES
write_enable=YES
anonymous_enable=YES
anon_root=/var/ftp/pub
anon_upload_enable=YES
anon_world_readable_only=NO
```

Crear usuario FTP

```bash
useradd --home /var/ftp --shell /bin/false ftp
mkdir -p --mode 733 /var/ftp/pub/incoming
```

### FTPd pure

Pure-FTPd es un servidor FTP muy flexible, seguro y rápido.

A diferencia de muchos demonios, Pure-FTPd no lee ningún archivo de configuración (excepto LDAP y SQL cuando se usan). En su lugar, usa opciones de línea de comandos. Para mayor comodidad, se proporciona un contenedor que lee un archivo de  configuración e inicia Pure-FTPd con las opciones de línea de comandos  correctas.

Opciones básicas  linea de comando:

```bash
/usr/local/sbin/pure-ftpd -S 42	# puerto de escucha
/usr/local/sbin/pure-ftpd -S 192.168.0.42,21	# interfaz y puerto de escucha
/usr/local/sbin/pure-ftpd -c 50 &	# limitar numero de conexiones simultaneas
```

Configuración mínima descargas anónimas:

```bash
    useradd --home /var/ftp --shell /bin/false ftp
    # Set the proper permissions to disable writing
    mkdir -p --mode 555 /var/ftp
    mkdir -p --mode 555 /var/ftp/pub
    # Set the proper permissions to enable writing
    mkdir -p --mode 755 /var/ftp/pub/incoming

    chown -R ftp:ftp /var/ftp/
    192552    0 dr-xr-xr-x   3 ftp      ftp            16 Mar 11 11:54 /var/ftp
    192588    0 dr-xr-xr-x   3 ftp      ftp             8 Mar 11 11:07 /var/ftp/pub
    192589    0 drwxr-xr-x   2 ftp      ftp             8 Mar 11 11:55 /var/ftp/pub/incoming
```



## 212.3 Secure shell (SSH)

### Comunicaciones SSH

Es un protocolo (y  programa) que permite acceder a un servidor  remoto de una forma segura  cifrando la información que se intercambia con el cliente.

La función más usada es ejecutar comandos mediante terminal en una máquina remota, pero puede usarse para copiar `scp` , `sftp` y para crear túneles seguros usados por multitud de aplicaciones.

Para cifrar la comunicación utiliza claves públicas y privadas.

```bash
/etc/ssh/ssh_config     # conf cliente
/etc/ssh/sshd_config    # conf servidor
```

Se puede iniciar sesión con el usuario y la contraseña o usando las claves instaladas en el cliente y el servidor.

`~/.ssh/known_hosts`  contiene los hash de los hosts conocidos, es decir los que ya se a establecido una conexión.

#### Directivas destacadas de sshd_config

```bash
Port            # puerto a la escucha por defecto 22
PermitRootLogin # perrmitir acceso remoto a root
X11Forwarding   # permitir tunel para usar entorno gráfico
AllowTcpForwarding  # permitir tuneles

sshAllowUsers 
sshDenyUsers
sshAllowGroups
sshDenyGroups
```

#### Ficheros  de claves

Según el sistema de cifrado obtendremos un fichero u otro.

| cliente           | servidor                      |
| ----------------- | ----------------------------- |
| ~/.ssh/id_rsa     | /etc/ssh/ssh_host_rsa_key     |
| ~/.ssh/id_dsa     | /etc/ssh/ssh_host_dsa_key     |
| ~/.ssh/id_ecdsa   | /etc/ssh/ssh_host_ecdsa_key   |
| ~/.ssh/id_ed25519 | /etc/ssh/ssh_host_ed25519_key |

> las claves públicas se encuentran en los mismos directorios con extensión `.pub`, Ademas los permisos de las claves privadas sera de `600`y las públicas `644`

 

#### Generar claves

`ssh-keygen` genera un par de claves pública y privada. por defecto usa RSA.

```bash
ssh-keygen
-t  # metodo de cifrado dsa, ecdsa, ed25519, rsa
-b  # bits usados para el cifrado 2048 suficiente
-A  # generar llaves de todos los metodos de cifrado
-R  # borrar claves de un hostname
-l [-f file_key]    # ver fingerprint
...

ssh-keygen -t rsa -b 2048
ssh-keygen -f "~/.ssh/known_hosts" -R "192.168.0.25"
```

Para acceder a un servidor remoto este tiene que tener guardada la clave pública en el archivo `~/.ssh/autorized_keys`. Esto se puede hacer con el comando `ssh-copy-id user@host`  

 

#### ssh-agent

gestiona las claves privadas mientras dure la sesión. Útil cuando se trabaja con varios servidores y se quiere agilizar la repetitiva identificación en  cada uno de ellos.

Primero tenemos que ejecutar el comando para iniciarlo y después utilizar `ssh-add` para añadir todas las claves que queremos gestionar. De esta manetra si nuestras llaves tienen passfrase solo las tendremos que añadir una vez.

```bash
carol@debian:~/.ssh$ ssh-agent /bin/bash
carol@debian:~/.ssh$ ssh-add
Enter passphrase for /home/carol/.ssh/id_ecdsa:
Identity added: /home/carol/.ssh/id_ecdsa (carol@debian)

carol@debian:~/.ssh$ ssh-add -l # mostrar claves guardadas
carol@debian:~/.ssh$ ssh-agent -k # cerrar la sesion de agent
```

 

#### Tuneles

Es una conexión cifrada entre dos puntos que se establece con la intención de que sea utilizada para transmitir los datos de otra aplicación o  servicio de forma segura.

```bash
ssh 
-N  # no se ejecuta un comando
-f  # segundo plano
-L  # tuner estatico directo
-R  # tunel estatico inverso
-D  # tunel dinamico
```

**Local-destino**: Creo un túnel  que abre el puerto 9001 local y me envía al puerto 80 de la interficie localhost de destino

```bash
➜ ssh -L 9001:localhost:80 jorge@portatil
➜ curl http://localhost:9001
bienvenido apache bla bla...
```

**local - destino - remoto:**  En este ejemplo simulo que desde el  host-local no tengo  acceso al  server (host-remoto), pero desde portatil (host-desti)  si.  Creo un  tunel que abre el puerto 9001 del host-local que me envía al  portatil y el portatil me reenvía al puerto 22 del server.

```bash
# creo tunel
➜ ssh -L 9001:server:22 jorge@portatil
# me conecto al puerto 9001  local con ssh y el usuario pi del server
➜ ssh -p 9001 pi@localhost
# el tunel me reenvia al server.
pi@raspberrypi:~ $
```

##### Inversos

**local-destino**: host-local (aws) corre un servicio de daytime en el puerto 13, pero es  solo local el firewall corta todas las entradas. Entonces desde aws  conecto con host-destino (casa) y abro el  puerto 3035 donde conecta con el localhost:13 de aws.

```bash
[fedora@aws ~]$ ssh -R 3035:localhost:13 pi@casa
pi@casa:~ $ curl http://localhost:3035
17 MAR 2020 17:19:08 UTC
```

**local-destino-remoto**: En este ejemplo El firewall  bloquea todas las entradas del exterior,  entonces desde casa establezco  una conexión inversa con aws para que  desde el puerto aws:3035 pueda  acceder a casa y la redirijo al  portatil:13  que tiene el servidor  daytime.

```bash
casa ➜ ssh -R 3035:portatil:13 fedora@aws
[fedora@aws ~]$ curl http://localhost:3035
17 MAR 2020 17:38:34 UTC
```

## 212.4 Tareas de seguridad

`Fail2ban` analiza archivos de registro como `/var/log/pwdfail` o  `/var/log/apache/error_log` y prohíbe las direcciones IP que provocan demasiados intentos de  contraseña rechazados. Actualiza las reglas del firewall para bloquear  las direcciones IP. También pueden configurar  la forma en que se utilizan las llamadas "jail" en Fail2Ban para bloquear direcciones IP. Un jail Fail2Ban es una combinación de un filtro y  toma una o varias acciones.

`nmap`es una herramienta de exploración de redes y un escáner de seguridad nmap. Se puede utilizar para escanear una red, determinar qué hosts están activos y qué servicios ofrecen.

```bash
nmap -sT localhost	# escanear puertos tcp
nmap -sU localhost	# escanear puertos udp
nmap -p 1-65535 localhost	# escaneat todos los puertos ( por defecto solo 1000 mas comunes)
nmap -A remoteHost	# toma de huellas, sacar max info posible
```



### Sistemas IDS

Para evitar la protección que aportan los cortafuegos, muchas aplicaciones usan puertos comunes (especialmente el 80 tcp) para lograr transmitir su propio tráfico. Los cortafuegos, a menudo configurados para que dejen pasar los datos por estos puertos comunes, no detectan el peligro.

Sistemas IDS (Intrusion Detection System)  sirve para proporcionar un mejor control hay que utilizar un equipamiento más elaborado, capaz de examinar y analizar el tráfico a nivel de aplicación, de forma directa y sin caer en este engaño del puerto erróneo.

Los IDS usan tres técnicas: 

- **La detección de anomalías** tiene como objetivo detectar un comportamiento anormal, como por ejemplo un volumen de tráfico ICMP desmesurado
- **El análisis de protocolos** busca un tráfico de aplicación que no cumple el estándar del protocolo al pie de la letra. 
- **El análisis de firmas** permite identificar ataques o comportamientos perjudiciales ya publicados.

Estas técnicas requieren de una actualización constante en el paso del tiempo ya que los invasores van evolucionando es sus técnicas. Para la constante actualización existen organizaciones que proporcionan bases de datos. 

Las principales organizaciones son: `Bugtraq, CERT, CIAC`

### Snort

Snort es el más conocido de los IDS libres. Analiza todo el tráfico y aporta un complemento de seguridad apreciable (incluso indispensable) en la red. Snort se compone de un motor de análisis y de un conjunto de reglas.

La configuración de Snort se encuentra en `/etc/snort/snort.conf`  y sus reglas en `/etc/snort/rules`, utiliza el comando `oinkmaster` que tiene su propio archivo `oinkmaster.conf`

Snort utiliza archivos de reglas que deben descargarse del sitio web del editor.

*oinkmaster.conf*

```
url = http://www.snort.org/snort-rules/archivo_reglas 
```

```bash
# oinkmaster -o dir_reglas 
oinkmaster -o /etc/snort/rules
```

Cuando Snort detecta tráfico perjudicial, deja una traza en el archivo de registro a través de **syslog** y envía una copia del paquete en un archivo con formato tcpdump. También se puede enviar la información a una base de datos.

Ejemplo de declaración de uso de syslog en snort.conf

```
output alert_syslog: host=ip_servidor, LOG_ALERT
```

- Esta declaración indica que los elementos deben enviarse al servidor syslog, cuya dirección IP es ip_servidor con la categoría "alerta".

### OpenVas

OpenVAS (Open Vulnerability Assessment Scanner) es una variante del escáner de vulnerabilidades Nessus

El servidor es el corazón de la suite OpenVAS. Escanea y analiza los hosts de red en busca de vulnerabilidades conocidas

Los clientes OpenVAS son aplicaciones por línea de comandos o con interfaz gráfica que realizan el análisis de los hosts de la red en busca de vulnerabilidades para devolver los resultados al servidor.

OpenVas ofrece una fuente pública de vulnerabilidades conocidas con el nombre de OpenVas NVT Feed. Permite a los servidores estar al corriente de las últimas vulnerabilidades conocidas y contiene más de 15000 NVT.

## 212.5 OpenVPN

OpenVPN es un programa open source para la creación de túneles seguros (VPN). Contrariamente a las VPN habituales, no se basa en IPsec sino en SSL. Proporciona servicios de autentificación, de confidencialidad y de control de la integridad.

Los dos modos más comunes de autentificación son la autentificación por compartición de claves y la autentificación con certificados digitales X509. 

Dispone de varios modos de funcionamiento:

- `punto a punto` : en el que los dos protagonistas de la VPN son los que deben comunicarse de forma segura.
- `sitio a sitio`: se conectan dos redes entre si. Dos servidores OpenVPN proporcionan entonces un túnel, pero los extremos del tráfico son las dos redes conectadas

El nivel de transporte de los paquetes cifrados usa por defecto UDP, aunque también se puede usar TCP.

### Túnel punto a punto

```bash
openvpn --genkey --secret secret.key # generar clave compartida
```

> Este archivo tiene que existir en el servidor y en el cliente, y por tanto copiarse mediante algún método seguro

```bash
alfa:/etc/openvpn# cat server.conf 
dev tun 
ifconfig 10.8.0.1 10.8.0.2 
secret secret.key

beta:/etc/openvpn# cat client.conf 
remote alfa 	# servidor remoto
dev tun 		# encapsulación de tipo tunel
ifconfig 10.8.0.2 10.8.0.1 	# dirección local y remota
secret secret.key 
route 192.168.1.0 255.255.255.0 # dirección de red privada detrás del servidor
```



