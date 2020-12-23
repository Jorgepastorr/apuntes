
# APUNTS DE XARXES

## Capa de Aplicació  

#### OSI i TCP/IP  


<table class="tg">
  <tr>
    <th>Model OSI</th>
    <th>Model TCP/IP</th>
  </tr>
  <tr>
    <td class="tg-0pky">7. Aplicació</th>
    <td class="tg-0pky" rowspan="3">Aplicacio</th>
  </tr>
  <tr>
    <td class="tg-0pky">6. Presentacio</td>
  </tr>
  <tr>
    <td class="tg-0pky">5. Sesio</td>
  </tr>
  <tr>
    <td class="tg-0pky">4. Transport</td>
    <td class="tg-0pky">Transport</td>
  </tr>
  <tr>
    <td class="tg-0pky">3. Red</td>
    <td class="tg-0pky">Internet</td>
  </tr>
  <tr>
    <td class="tg-0pky">2. Enllaç de dades</td>
    <td class="tg-0pky" rowspan="2">Acces a la xarxa</td>
  </tr>
  <tr>
    <td class="tg-0pky">1. Fisica</td>
  </tr>
</table>
​     

#### Funcio model TCP/IP

| Capa             | Protocol       | Dades Relatioves | Funció            |
| ---------------- | -------------- | ---------------- | ----------------- |
| Acces a la xarxa | Ethernet       | MAC              | Trama             |
| Internet         | IP             | IP               | Paquet            |
| Transport        | TCP/UDP        | Port             | Segment/Datagrama |
| Aplicació        | http/s, ftp... |                  | Dades             |



#### Aplicacions i serveis

- Aplicacions:
  - Les aplicacions en aquesta capa les utilitzan les persones, son tipos navegador, skype, ect...
- El serveis:
  - Molts dels servers sidentifican en aquesta capa: BBDD, ftp, DNS, Web, DHCP, etc...   



## Capa de Transport

La capa de transport treballa a nivell de port, amb el protocol TCP/UDP la seva funcio es segmentar les dades que l'arriben de la capa aplicació.

#### Protocol

- TCP: segment
- UDP: datagrama

#### Funció  

- Permetre múltiples conexions.
  - Gracies a la segmentacio i a la distribucio de ports pot fer arrivar a diferents aplicación informacio a l'hora pel seu correcte funcionament  fent multiples converse al mateix temps. aixo s'anomena **Multiplexació** .
- Assegurar que les dades arriven correctament:
  - Amb el protocol TCP i el seu flag ACK, permet asegurarse de larribada de cada paquet enviat.
- Gestionar els errors posibles:

#### Windows Size Value:

Ens permet saber quantes dades pot rebre un dispositiu sense col·lapsar-se.

#### Control de Fluxe: 

Amb el valor de la finestra Window Size Value, el TCP pot gestionar el màxim d'enviament 
de dades possible segons les capacitats del medi i dels dispositius que 
hi están participant, és a dir, adapta la velocitat d'enviament a la capacitat del
dispositiu final o a l'estat del medi per on s'hi transmeten. 

#### Checksum 

Es una operació matemàtica de manera que molta informació l'agrupem a un nombre molt petit
L'objectiu és saber si la transferencia s'ha fet correctament, no és 100% fiable ja que 
la simplificació potser no és perfecte però si que és molt aproximada. 

1500 Bytes --> 8 Bytes 

Si el checksum no coincideix en res vol dir que no s'ha rebut bé el paquet hi ha hagut 
algun error.

L'algoritme és diu MD5.

#### Relació entre els números dels paquets. 

TCP Segment Lenght + Sequence Number = Next Sequence Number 

#### netstat -putona

Mostra informació dels Shockets actius / connexions totals del sistema. 

-p programa 
-u udp
-t tcp
-n nombre de ports --> numeric, HTTP NO, 80 SI.
-a Tots els processos

#### nc o netcat 

nc -lv 1500 --> Escolta i espera una connexió per el port 1500

nc 192.168.3.8 1500 --> Intenta connectar-se a aquella IP i per aquell port. 

#### Contingut d'una direcció web

http://www.google.com:1500/index.html  
protocol, nom de domini, port, recurs o pàgina.

#### Flags del protocol TCP

+ URG: Indica que el segment URGENT  
+ ACK: Indica que el segment es un avís de rebut (Acknowlegment)  
+ PSH: Indica que la petició que a fet no la apili al bufer i laprocesi de forma mes inmediata posible ( demana l'enviament del segment *(push)*).
+ RST: Indica que el segment demana reiniciar la sessió (reset)
+ SYN: Indica que el segment demana fer una 
  sincronització del numero de seqüència entre els 
  dispositius origen i destí (syncronization)
+ FIN: indica que el segment  demana finalitzar la sessió

#### Sincronització 

Al fer una sincronització el que realment estem fent es establir un número de secuencia. 

també sestableix el socket ip:port local ip:port destí.  

  

## Capa d'Internet TCP/IP o de Xarxa OSI

Rep les dades de la capa de transport:  
Encapsula  
Crea la PDU que en aquest cas s'anomena PAQUET  
Les envia a la capa d'accés a la xarxa.  

Rep les dades de la capa d'accès a la xarxa:  
Fa la mateixa operació però a l'inversa.

#### Funcions

Identifica tots els dispositius amb una IP  

Enruta les dades per tal que aquestes arribin al destí de manera correcta.  

#### IPv4 

És independent de les dades que transporta, és a dir, que ignora l'aplicació que les ha
generat o el significat que tenen.  
També és independent del medi, cablejat, WIFI o llum, tot i que la mida màxima del paquet 
si que depen del medi. (Exemple: Ethernet 1500B, WLAN 2304B)  

#### Dades més rellevants a la capçalera

+ Adreça origen i destí
  
+ TTL --> Time To Live, quantitat de routers per els quals el paquet pot passar fins que 
al final es destrueixi. Comanda:  

Traceroute, mostra tots els routers per els quals passa un paquet fins que 
arriba al destí possible o ha passat per 30 routers.

Envia un paquet amb TTL 1, aleshores torna a enviar un amb TTL 2, fins que no deixa de
rebre avisos conforme els paquets es destrueixen va enviant i sumant TTL fins al final
quedar la quantitat de routers per la qual ha passat el paquet.
Ho intenta 3 vegades per router, en cas de que falli algún d'aquests hi afegeix un *.
També pot ser que el router no estigui configurat per a identificar-se i per això al 
no donar la seva informació traceroute afegeix * * *.  

+ Versió 4 o 6.

+ Protocol de la capa superior (Transport, TCP o UDP)

+ Checksum, per comprovar que no hi hagin errors.


#### Switch VS Router

+ Switch  
Treballa a la capa 2 del model OSI (Enllaç de dades), amb les MAC, nomes pot manipular trames amb origen i destí dins de la mateixa LAN. 

+ Router  
Treballa a la capa 3 del model OSI (Xarxa), amb les IP, enruta paquets entre xarxes diferents, permet sortir a altres xarxes com a gateway o porta d'enllaç.  

#### ip r 

Ens mostra el nostre gateway configurat per defecte.

#### MAC

La MAC només té sentit utilitzar-la dins de la meva xarxa local.

#### A tenir en compte

El GATEWAY ha d'estar a la mateixa xarxa que el dispositiu  
Les IP han de coincidir en el rang d'adreces de xarxa  
Cada dispositiu ha de saber quin és el seu gateway (Manualment o amb DHCP)  
Cada router ha de seaber com redirigir una adreça IP (Taules d'enrutament)  
Els routers entre ells creen una xarxa sense dispositius finals

#### Comandes bàsiques

```
[isx46420653@j07 Xarxes]$ ip a 
2: enp2s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 14:da:e9:b6:e5:13 brd ff:ff:ff:ff:ff:ff
    inet 192.168.3.7/16 brd 192.168.255.255 scope global dynamic enp2s0
       valid_lft 12863sec preferred_lft 12863sec
    inet6 fe80::16da:e9ff:feb6:e513/64 scope link 
       valid_lft forever preferred_lft forever

[isx46420653@j07 Xarxes]$ ip route
default via 192.168.0.1 dev enp2s0 proto static metric 100 
192.168.0.0/16 dev enp2s0 proto kernel scope link src 192.168.3.7 metric 100 

[isx46420653@j07 Xarxes]$ route
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
default         router.informat 0.0.0.0         UG    100    0        0 enp2s0
192.168.0.0     0.0.0.0         255.255.0.0     U     100    0        0 enp2s0
```

#### Tipus d'enrutament

+ Manual  
Implica que qualsevol canvi a la xarxa obliga a modificar els taules d'enrutament

+ Automàtic  
Els routers es comuniquen entre ells per a saber on enviar la informació i per quin camí pot ser més ràpid,
utilitzen el RIP (Routing Information Protocol) que és el més utilitzat.



### Adreçament ip  

En totes les xarxes n'hi h'an 2 ip que no es poden utilitzar:

- la mes petita ( la de xarxa )
- la mes gran ( la de brodcast )



#### Broadcast

existeixen 2 tipus de brodcast

**Dirigit:**  quan enviem el misatge bradcast a un altre xarxa, cal configurar el ruter perque es permeti.

**Limitada:**  limitada a la propia xarxa, els rutes descarten l'enrutament dels missatges dirigits a aquesta ip.



#### Rangs ip's

Dispositius:

- 0.0.0.0 a la 223.255.255.255

Multicast:

- 224.0.0.0 a la 239.255.255.255

Experimentals:

- 240.0.0.0 a la 255.255.255.254



##### Privades

Poden repetirse entre diferents xarxes locals, i mai surten de la xarxa local, si cal sortir s'utilitzara un NAT o PAT.

##### Publiquers

Dispositius que han de sortir a internet, principalment routers o servidors.

##### Adreces especials

Son les adreses que no es poden asignar a un dispositiu.

- adreses de xarxa o brodcast
- rutes per defecte (0.0.0.0/0)
  - les que s'utilitcen en les taules d'enrutament com a opció per defecte.
- loopback (127.0.0.0/8)
  - es una ip reservada per enviarse trafic a si mateix.
- D'enllaç local
  - En xarxas punt a punt o quan no hem obtungut adreaça DHCP



##### Classes

---

**Classe A** 

de 0.0.0.0/8 a 127.0.0.0/8

xarxes grans 16·10**6 dispositius

En la seva representació binaria sempre comencen per 0



**Classe B**

de 128.0.0.0/16 a 191.255.0.0/16

xarxes mitjanes-grans 65000 dispositius

En la seva representació binaria sempre comencen per 10



**Classe C**

de 192.0.0.0/24 a 223.255.255.255/24

xarxes petites 254 dispositius

En la seva representació binaria sempre comencen per 0



Classfull

....



#### Divisio subxarxes  

A partir duna xarxa mare, podem agafar bits a la part de hosts per crear subxarxes. 

El numero de subxarxes depen del número de bits que agafas.

Exemple:

xarxa mare: 192.168.4.0/24, si agafem 2 bits 192.168.4.0/26

amb 2**2 podem fer 4 subxarxes.

```bash
00
01
10
11
```



## Capa acceso a la red

interactua con dos capas del modelo OSI, capa enlace de datos y física. 

***Enlace de datos:*** interactua con la capa de internet obtiene el paquete lo encapsula y crea una nueva PDU denominada trama,  el dato mas importante que añade es la vmac origen y destino.

***Física:*** codifica/descodifica los bits según el medio. impulsos electricos, ondas electromagneticas o luz.  El objetivo de la capa física es crear o interpretar las señales que representan los bits de la trama.



### Mac

La mac es una dirección del protocolo internet, identifica de forma unica una interficie de red, en principo no la podemos cambiar al estar grabada en la ROM de la NIC.

las comunicaciones dentro de una misma red se realizan mediante la mac, por tanto necesitamos el protocolo ARP.



#### ARP, permet la comunicació mitjançant un protocol

Adress Resolution Protocol --> Troba la direcció MAC que correspon a una IP

El protocolo ARP hace la traducción de ip a mac, lo hace mandando un brodcast en formato MAC y solo respondera el  que tiene la ip asociada a esa mac especifica.

esta la guarda en una cache para en futuras conexiones no tener que repetir el proceso.

`arp` comando parta ver la cache.



### Estàndards

Hi han uns determinats estàndards que permeten que diversos elements de diversos fabricants puguin ser compatibles entre ells. 

Ethernet: Connector RJ45 i el medi és el UTP, Unshielded TwistedPair o Parell Trenat (de coure)

UTP amb RJ45:

10BASE-T (10Mbps)

100BASE-TX (100Mbps)

1000BASE-T (1Gbps)

Wireless:

Bluetooth 502.15 --> Velocitats baixes <1 Mbps, distàncies curtes i entre dispositius propers.

802.11 (a,b,g,n) --> Velocitats altes(fins a 54 Mbps), distàncies mitjanes, popularment és el Wi-Fi.

GSM,GPRS,3G i 4G --> Distàncies llargues, s'utilitzen als mòbils.

Hem de tenir en compte que existeixen les interferències, ja siguin en medis wireless o en medis cablejats. 

### Interficies

#### Cables

El cable mas habitual es UTP Unshielded ( desprotegido ) o Parell trenat ( de cobre ) Este cable no tiene mucho rebestimiento para evitar interferencias.

El formato de creación actualmente es el directo, los 2 extremos seran iguales. Antiguamente en una conexión dfe host a host, se utilizaba un cable cruzado para que no coincida salida con salid o entrada con entrada. Hoy en dia las targetas de red ya reconocen las  entradas y salidas y las reordenan automaticamente.

###### STP

Es un cable UTP con un blindage extra para minimizar interferencias

##### Fibra

Ancho de banda alto y distancias de mas de 100m



#### Inalambrico

##### Bluethooth

Bajo consumo de energía, distancias cortas, frecuencia baja.

##### Wifi

802.11 (a,b,g,n)

Velocidades altas ( de 54 Mbps a 5 Gbps) , distancias medianas









## Planificació i Administració de Xarxes

### Adreçament ip

#### Adreça de Xarxa

- AX = Adreaça de xarxa

- MX = Màscara de Xarxa  

- AX = IP AND MX  



**Exemple:  ** 
IP --> 10.10.10.65/26  
MX --> 255.255.255.192  
AX --> 10.10.10.64  



#### Adreça de Broadcast

És la última adreça disponible de la xarxa, la més gran.  
S'utilitza per a enviar missatges a TOTS els dispositius d'una xarxa.   
A la pràctica, tots els bits de host són 1.  

- AB = adreça de broadcast

AB = IP OR (NOT MX)  

**Exemple (Octets perfectes):**   

IP --> 10.10.10.7/24  
MX --> 255.255.255.0  
AX --> 10.10.10.0  
AB --> 10.10.10.255

**Exemple (Octets imperfectes): **  

Recordar: (A la pràctica, tots els bits de host són 1.)  

IP --> 10.10.10.7/26  
MX --> 255.255.255.192  
AX --> 10.10.10.0  
AB --> 10.10.10.63 

#### Comunicació de dispositius

**Unicast:** Comunicació entre 2 dispositius  

**Broadcast:** Comunicació amb tota la xarxa.   

- Dirigit: que enviem el missatge broadcast a una altra xarxa ( sutilitza ip de la xarxa externa )
- limitat: en la propia xarxa

**Multicast:** Comunicació amb un conjunt de dispositius.  

- s'hi ha de tenir un grup multicast asignat, en un rang d'adresses  224.0.0.0 a la 239.255.255.255. Els clients que participen en el grup tenen dues adresses, la seva i la multicast.



#### Rang d'adreçes IP

De dispositius: Van de la 0.0.0.0 a la 223.255.255.255  
Multicast: 224.0.0.0 a la 239.255.255.255  
Experimentals: 240.0.0.0 a la 255.255.255.254

#### Classificació d'adreçes IP

***Privades*:** Poden repetir-se dins de les xarxes locals, i mai surten d'ella. Existeixen 3 rangs: (Estàndard)  
Xarxes grans: 10.0.0.0/8 a 10.255.255.255  
Xarxes mitjanes: 172.16.0.0/12 a 172.32.255.255  
Xarxes petites: 192.168.0.0/16 a 192.168.255.255  

***Públiques:*** Han de sortir a internet, normalment les tenen els routers o servidors, són úniques.  

***Adreces especials:*** Adreces de xarxa o Broadcast, 

- la 0.0.0.0/8 és la ruta per defecte
- el 127.0.0.0/8 és el loopback 
- la 169.254.0.0/16 és la d'enllaç local, en xarxes P2P o quan no hem obtingut adreça del DHCP.



#### Classes d'IP

***Classe A*:** Xarxes MOLT grans, permeten `16*10**6` dispositius, van de la 0.0.0.0/8 a la 127.0.0.0/8, en binari sempre comencen per 0.  
***Classe B:*** Xarxes mitjanes, permeten uns 65000 dispositius, van de la 128.0.0.0/16 a la 191.255.0.0/16, en binari sempre comencen per 10.  
***Classe C:*** Xarxes petites, permeten uns 254 dispositius, van de la 192.0.0.0/24 a la 223.255.255.255/24, en binari sempre comencen per 110.



#### Assignació d'IP

**[IANA]** es l'organisme encarregat d'assignar ip's

A dia d'avui l'assignació la delega als [RIR], els [RIR] assignen les IP disponibles als [ISP] de la zona, que les distribueixen als seus clients.

[IANA]: https://es.wikipedia.org/wiki/Internet_Assigned_Numbers_Authority	"Proveidor de serveis d'internet"
[ISP]:https://es.wikipedia.org/wiki/Proveedor_de_servicios_de_Internet  "Proveidor de serveis d'internet"
[RIR]: https://es.wikipedia.org/wiki/Registro_Regional_de_Internet "Registres regionals d'Internet"





### Resum de rutes



Per no haver d'afegir 2 entrades a la taula d'enrutament podem fer:

```bash
192.168.1.0/24
192.168.2.0/24

x.x.00000001.x
x.x.00000010.x
```

L'entrada 192.168.0.0/22 afecta a les xarxes 192.168.1.0, 192.168.2.0 i 192.168.3.0, tenint en compte que totes elles surten per la mateixa interfície. 



Alguns routers tenen en compte sempre la màscara de xarxa més alta, de manera que si hi han 2 entrades a la taula d'enrutament amb la mateixa IP, una resumida i l'altra individual, el router funcionarà amb l'entrada individual perquè la màscara és més gran. Exemple:

192.168.0.0/22 192.168.x.x

192.168.3.0/24 192.168.x.x --> Aquesta té prioritat al router.



### Enrutamentamiento

#### Rip

Rip es un protocolo para enrutar dinamicamente, esto se produce en mensages tipo broadcast que envian los routes. En dicho mensage cada router envia que redes tiene e sus interficies, y van rellenando las tablas de enrutamientos con ellas.

**versión 1:** *classful*, acepta subneting pero no superneting. 

- *clasful* se basa en clases de ip por lo tanto es incapaz de enrutar redes con superneting.

**version 2:** lessful, envia ip con mascara

- `auto-summary`: Es la opcion por defecto, crea resumen de rutas.
- `no auto-sumary`: No crea resumen de rutas, en ocasiones hay que habilitarlo para evitar algún conflicto con el resumen de rutas.



Tanto la versión 1 como la 2, a no ser que este el `auto-summary` desactivado el protocolo rip ará resumenes de rutas automaticamente.



### Switches

Un switch  trabaja con macs en protocolo ARP, capa 2 modelo tcp/ip. El protocolo ARP evita colisiones segmentando cada paquete y redirigiendolo al dispositivo pertinente.

El switch es la actualización de hub donde el hub es un replicador de datos y el switch redirige cada mensage por la interfaz concreta. hub capa1, switch capa 2.

switch evita colisiones en la medida de lo posible.

- **opcion1:**  utilizada por el hub, CSMA/CD, espera a que la linea quede bacia para poder transmitir.

- **opcion2:** utilizada por switch, Segmentación de paquetes junto al protocolo ARP, para distribuir cada segmento al dispositivo indicado.

**mirroring port**: Es una practica para detectar todos los paquetes entrantes y salientes de una red, consiste en  conectarse por encima de la conexión del switch y así poder recibir todos los paquetes entrantes y salientes.

Metodo sticky: convierte asignacion mac de arp dinamica en estática

**Spanning Tree Protocol:** Es un protocolo de switches que evita la tormenta de broadcast.

### CSMA/CD

Es un mecanismo que incorporan algunos dispositivos, y funciona que si en un medio físico se quieren transmitir datos se escucha y se espera a que el medio este libre para transmitir. csma/cd no segmenta las tramas.



### Dominio de colisión

Es un grupo de dispositivos conectados al mismo medio físico, de tal manera que si dos dispositivos acceden al mismo medio a la vez se produce una colision.



### Dominio de difusión 

Un dominio de difusión englova todos los dispositivos de una LAN o VLAN, es el area donde puede acceder un broadcast.



## Administración Avanzada de Redes

### Vlan

Una vlan sirve para dividir una red en múltiples redes y así poder romper un área de dominio de difusión en múltiples de colisión. La ventaja es que no necesitamos un router para la división de redes, si no que el mismo switch puede hacer estas divisiones, así ahorrando costes y con un mayor rendimiento.

La vlan por defecto *( nativa )*  es la 1 aún que se puede modificar al gusto.



**Funciona en 2  pasos:** 

- crear las vlan identificándolas con un número
- Asignando la interficie a la vlan



#### Enlaces Troncales

Los enlaces troncales se asignan  a interficies entre dos switches o de switch a router, en la que se comunicaran diferentes vlans por la misma interficie. Si no existiese este tipo de enlace se tendría que conectar dos dispositivos tantas veces como vlans tuviera configuradas. 

##### 802.1Q ( DOT1Q)

En los enlaces troncales se asigna una etiqueta o *tagged*  para diferenciar las tramas que pertenecen a cada vlan, en caso de que no fuera así el switch no podría saber que trama pertenece a que vlan.

Las tramas de la vlan nativa son las únicas que pasan por el enlace trunck sin la etiqueta adicional dot1q



#### Enrutamiento Vlan

En el modo tradicional cada vlan tiene que estar conectado a una interficie del router pero esto consume muchas interficies y no es rentable, por eso se combina modo trunk *(router on a stick)* con el tradicional según nuestras necesidades.

##### Router On A Stick

Se configura una interficie que acepte diversas vlan.

```bash
#Creació de la interfície 10 associada a la fa0/0
Router (config)# interface fa0/0.10
Router (config-subif)# encapsulation dot1q 10
Router (config-subif)# ip address 192.168.1.129 255.255.255.224

Router (config)# interface fa0/0.20
Router (config-subif)# encapsulation dot1q 20
Router (config-subif)# ip address 192.168.1.65 255.255.255.224
Router (config)# interface fa0/0
Router (config)# no shutdown
```

- En este caso la interface 0/0 englova 2 vlans la 10 y la 20.

**Pros y Contras** 

Tradicional:

- utiliza muchas interficies físicas.
- cada vlan tiene todo el ancho de banda de la interficie

Stick:

- se puede gestionar muchas vlan en pocas interficies
- todas las vlan de la misma interficie comparten ancho de banda



#### STP

Stp ( Spanning Tree Protocol ), tiene la función de gestionar bucles en topologías de red, evitando tormentas de broadcast. El protocolo permite a los dispositivos activar o desactivar automáticamente los enlaces de red.

El protocolo establece un switch  como raíz ( Root Bridge )  y los demás switch de la topología establecen la ruta mas corta hacia la raíz como Root Port, en el extremo contrario del enlace de Root Port siempre estará Designed Port.

En el caso de que en un enlace no haya ningún RP, por lo tanto queda un enlace con dos extremos DP designed port, en el que tenga la mac mas alta se establecerá como BP blocked port para evitar bucles.

El Root Bridge se establece en el switch que tiene la mac mas baja en la vlan en uso, esta prioridad de raíz es modificable mediante comandos al router deseado.

