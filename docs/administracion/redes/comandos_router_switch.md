# Configuració de Routers

Habilitar redireccionamiento ip en un pc.

`echo 1 > /proc/sys/net/ipv4/ip_forward`

 Software per a crear connexions entre el PC i el router, el Minicom funciona amb text, farem servir el **Putty**.

Instal·lem **Putty**:

```
sudo dnf -y install putty
```

S'executa simplement amb la comanda: **putty**

Connectem el router amb el cable de consola cap a l'ordinador amb l'adaptador USB, automàticament Linux crea el fitxer de la connexió a /dev/ttyUSB0, aquest fitxer només té permisos per a Root i per al grup *dialout*, si el volem utilitzar hem de fer: 

1. Canviar els permisos i posar-los per a others també, tenint en compte que ho haurem de fer cada vegada que connectem de nou el router, ja que el fitxer s'esborra al desconnectar l'aparell i es crea de nou amb els valors per defecte al connectar-lo de nou.

2. Afegir-nos al grup dialout amb la comanda:

```
usermod -G dialout isx46.....
Cal fer un logout després d'afegir-se al grup!!
```

Obrim **Putty**

Creem els valors /dev/ttyUSB0 a Serial Line, guardem la configuració amb algun nom qualsevol i obrim la finestra.

Al obrir la finestra es mostra una pantalla negra, **NO** s'ha penjat, premèm enter i ja comença a mostrar informació, si no surt res, comprovar sobretot el cable de consola que estigui ben connectat.

## Comandos configuración router

```bash
Router> enable            # entrar en el router            
Router# configure terminal        # entrar en la configuración
Router(config)# erase startup-config    # resetear configuración 
Router(config)# hostname R3            # establecer hostame
Router(config)# banner motd #!!ACCESO SOLO A PERSONAS AUTORIZADAS
```

#### Guardar configuración

```bash
Router# copy run start
```

#### Asignar ip

```bash
Router(config)# interface f0/0
Router(config-if)# ip address 192.168.0.1 255.255.255.0
Router(config-if)# no shutdown
```

En cables serial puede que tengas o no que indicar el marcador de tiempo según el cable.

```bash
Router(config)# interface serial0/0/0
Router(config-if)# ip address 192.168.0.1 255.255.255.0
Router(config-if)# clock rate 64000 # opcional si es macho o hembra
Router(config-if)# no shutdown
```

##### Vlan

Asignar diferentes vlan en una misma interficie física. 

```bash
Router(config)# interface f0/0.10
Router(config-subif)# encapsulation dot1q 10
Router(config-subif)# ip address 192.168.10.1 255.255.255.0

Router(config)# interface f0/0.20
Router(config-subif)# encapsulation dot1q 20
Router(config-subif)# ip address 192.168.20.1 255.255.255.0

Router(config)# interface f0/0
Router(config-if)# no shutdown
```



#### dhcp

```bash
Router(confi)# ip dhcp pool red_local1
Router(confi)# ip dhcp excluded-address 172.16.3.1
Router(dhcp-confi)# default-router 172.16.3.1
Router(dhcp-confi)# network 172.16.3.0 255.255.255.0
Router(dhcp-confi)#end
Router# show ip dhcp binding
```

#### Enrutar

Para enrutar indicamos **red destino**, **mascara de dicha red** y por que **ip de router** debe salir.

```bash
Router(config)# ip route 172.16.10.0 255.255.255.0 10.10.1.2
```

#### Rip

rip permite automatizar las rutas de enrutamiento, en cada router se le indica que red tiene asignadas y el mismo, va hablando con los demas routers, para automatizar la tablas.

```bash
Router0(confi)# Router rip
Router0(dhcp-confi)# network 163.27.176.0
Router0(dhcp-confi)# network 163.27.240.0
Router0(dhcp-confi)# Passive-interface f0/0
Router0(dhcp-confi)# Passive-interface f0/1
Router0(dhcp-confi)# version 2
```

- `passive-interface` nos ofrece el no mandar mensages por esa interficie, se utiliza en redes finales.

- `show ip rip database` consultar la base de datos.

#### Contraseñas

**Contraseña en el login de entrada**

```bash
R1(config)#line console 0
R1(config-line)#password passcon
R1(config-line)#login
```

#### Contraseña de la configuración

```bash
Router(config)# enable secret XXXX    # establecer password cifrada a configuración
```

**Contraseña acceso al router remotamente.**

si no establecemos una contraseña por esta via no se podrá acceder remotamente.

```bash
R1(config)#line vty 0 4
R1(config-line)#password passvty
R1(config-line)#login
```

#### Información configuración

```bash
Router# show ? # indica que comandos existen con show
Router# show interfaces # muestra interfaces
Router# show interfaces serial 0/0/0 # muestra interfaces serial
Router# show versión # muestra versión del cisco.
Router# show ip interfaces serial 0/0/0 # muestra interfaces serial
Router# show ip interfaces brief # muestra las conexiones ( activadas, desactivadas)
Router# show arp     # tabla de macs, ips     
Router# startup-config # muestra la configuración guardada.
Router# show ip route # muestra tablas de enrutamiento
Router# show ip dhcp binding #  conf de dhcp
Router# show ip rip database    # consultar base de datos rip
```

## Tablas de enrutamiento

Conectadas directamente

- Las que detecta el router directamente por que estan conectadas directamente

Estaticas

- Las que añado manualmente

Dinamicas

- Se comunican tre routers y establecen sus tablas

Por defecto

- la ruta de salir si no conoce la red `0.0.0.0/0` 

communtacion.

pc1 se comunica con pc2 en otra red.

pc1 mira si la ip pertenece a su red

mira si tiene la mac en la cache de arp, si no, busca al geatwey.

- si no pertenece busca la red en el gateway

- los gateways tienen unav mac por cada interficie



## Comandos switch

Los comandos de switch son como el router con algunos extras.

```bash
interface range fastEthernet 0/5 - 24    # acceder a un rango de interficies ( util para cerrar puertos )
mac-address-table static 0010.1112.39A3 vlan 1 interface f0/1     # asignar mac statica en puerto
show mac-address-table        # mostrar tabla arp

```

### Configuracio i consulta de la Taula MAC

```bash
#Modificaci ́o del temps d’expiraci ́o de les MAC din`amiques
Switch (config) mac-address-table aging-time NUM
#Configuraci ́o d’una MAC est`atica (MAC en format XXXX.YYYY.ZZZZ)
Switch (config) mac-address-table static MAC vlan {1-4096, ALL} interface NOM
#Eliminaci ́o d’una MAC est`atica
Switch (config) no mac-address-table static MAC vlan {1-4096, ALL} interface NOM
Switch(config) show mac-address-table
```



### Vlan

**Crear vlan**

```bash
Switch (config)# vlan ID        
Switch (config-vlan)# name NOM
#Creaci ́o d’un conjunt de VLANs
Switch (config)# vlan ID1, ID2, ID3
#Creaci ́o d’un rang de VLANs
Switch (config)# vlan ID1-ID2
```



#### Mode acces

```bash
Switch (config)# interface NOM
Switch (config-if)# switchport mode access
Switch (config-if)# switchport access vlan ID
```

##### Eliminar access

```bash
Switch (config)# interface NOM
Switch (config-if)# no switchport access vlan
```





#### Trunk

```bash
Switch (config) interface NOM
Switch (config-if) switchport mode trunk
Switch (config-if) switchport trunk native vlan ID #Opcional
#Nomes permet l’acces a la VLAN ID
Switch (config-if) switchport trunk allowed vlan ID
#Nomes permet l’acces a les VLANs ID1, ID2 i ID3
Switch (config-if) switchport trunk allowed vlan ID1,ID2,ID3
#Nomes permet l’acces a les VLANs del rang ID1-ID2
Switch (config-if) switchport trunk allowed vlan ID1-ID2
#Afegeix la VLAN ID a les ja permeses en el trunk
Switch (config-if) switchport trunk allowed vlan add ID
# quitar vlan de puerto trunk
Switch (config-if) switchport trunk allowed vlan remove ID
```

##### Eliminar trunk

```bash
Switch (config)# interface NOM
Switch (config-if)# no switchport trunk allowed vlan
Switch (config-if)# no switchport trunk native vlan
Switch (config-if)# switchport mode access
```



#### Stp

Añadir Bridge Root, cabeza en arbol de prioridad.

```bash
Switch0(config)#spanning-tree vlan 1 root primary 

Switch0#show spanning-tree active
Switch0#show spanning-tree detail
```



#### Ip switch  

asignar una ip a un switch

```bash
config t
interface vlan 1
ip address 192.168.1.1 255.255.255.0
```



#### Mostrar

```bash
Switch# show vlan
Switch# show vlan brief
Switch# show interface trunk
Switch# show interface vlan 1
```

