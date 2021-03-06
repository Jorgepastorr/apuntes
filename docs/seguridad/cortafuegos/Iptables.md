# Iptables





## Reglas y Acciones

Las reglas se evalúan una a una secuencial mente en orden descendente, si una orden coincide con otra hace match, se aplica la primera, es decir si hay una regla que abre el puerto 5000 para la ip 1 y mas abajo hay otra regla que cierra el puerto 5000 para la ip 1,  la segunda nunca se aplicara.

## Activar host hacer router

```bash
echo 1 > /proc/sys/net/ipv4/ip_forward
```

## Borrar reglas actuales

```bash
sudo iptables -F
sudo iptables -X
sudo iptables -Z
sudo iptables -t nat -F
```

### Borrar una regla

```bash
# Primer les mostrem amb nº de línia
iptables -t filter -n -L -v --line-numbers
iptables -t nat -n -L -v --line-numbers
iptables -t mangle -n -L -v --line-numbers

# Esborrar la 4
iptables -D INPUT 4
```





## Politica por defecto

Existen dos políticas por defecto ACCEPT y DROP, generalmente se establece en el inicio de los scripts cual sera su política,  aceptar todo por defecto o denegar todo por defecto.

### Accept

En la política Accept todo esta permitido excepto lo que explícitamente se deniegue, en este caso las reglas de firewall son una lista de lo que está prohibido. Esta política es la mas fácil de configurar pero el firewall nunca será del todo seguro.

```bash
sudo iptables -P INPUT ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -t nat -P PREROUTING ACCEPT
sudo iptables -t nat -P POSTROUTING ACCEPT
```

### Drop

Esta es la política mas difícil de configurar pero es mas segura, por que por defecto todo esta denegado y se han de asignar en las reglas del firewall  todo lo que se permita, asegurándote no olvidarte ninguna opción imprescindible.

```bash
sudo iptables -P INPUT DROP
sudo iptables -P OUTPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -t nat -P PREROUTING DROP
sudo iptables -t nat -P POSTROUTING DROP
```

Uno de los errores que pueden ocurrir si las reglas no se han asignado bien, es que el sistema se quede bloqueado por haber cerrado demasiados servicios necesarios para el funcionamiento.

- toda comunicación de red tiene dos sentidos.
- hace falta permitir los dos sentidos para considerar accesible un servicio.
- el trafico de respuesta se puede identificar con modificadores tipo related, established.
- el trafico necesario para el sistema a de estar abierto
  - dns, sincronización horaria, pings, Ldap, Kerberos, NFS, samba, sgún de que dependa la máquina para su funcionamiento.

## Permitir todo vía localhost

```bash
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT
```

`-i` input-interface, `-o` output-interface

## Permitir todo en propia ip

```bash
sudo iptables -A INPUT -s 192.168.88.2 -j ACCEPT
sudo iptables -A OUTPUT -d 192.168.88.2 -j ACCEPT
```

`-s`  source(origen) `-d` destination

## Permitir una ip/red a puerto

```bash
# permitir acceder una red a un puerto
sudo iptables -A INPUT -s 192.168.88.0/24 -p tcp --dport 5432 -j ACCEPT
# permitir una ip a un rango de puertos
sudo iptables -A INPUT -s 80.37.45.194 -p tcp --dport 20:21 -j ACCEPT
# permitir una ip a un puerto
sudo iptables -A INPUT -s 80.37.45.194 -p tcp --dport 80 -j ACCEPT
```

## Cerrar puerto al exterior

```bash
sudo iptables -A INPUT -p tcp --dport 20:21 -j DROP
sudo iptables -A INPUT -p tcp --dport 5432 -j DROP
sudo iptables -A INPUT -p tcp --dport 80 -j DROP
```

## Guardar reglas actuales

```bash
sudo iptables-save > /etc/sysconfig/iptables
```

### Backup

```bash
sudo iptables-save > arxiu.regles.iptables # exportar
sudo iptables-restore < arxiu.regles.iptables # inportar
```



## sourceport

En este ejemplo quiero que el host pueda navegar por internet, pero este mismo host tiene un servidor web y  quiero que desde el exterior puedan acceder, por lo tanto añado la regla de aceptar entrada por source port (esto solo es estrictamente necesario en la política drop). 

```bash
sudo iptables -A INPUT -p tcp -m tcp --sport 80 -m state \
					--state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp -m tcp --dport 80 -j ACCEPT

sudo iptables -A INPUT -p tcp -m tcp --sport 443 -m state \
					--state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp -m tcp --dport 443 -j ACCEPT

sudo iptables -A INPUT -p tcp --dport 80 -j DROP
sudo iptables -A INPUT -p tcp --dport 443 -j DROP
```

**ESTABLECIDO** significa que el paquete está asociado con una conexión que  ha visto paquetes en ambos direcciones

**NUEVO** que significa que el  paquete ha comenzado una nueva conexión, o asociado con una conexión que no ha visto paquetes en ambas direcciones,

**RELACIONADO** que significa  que el paquete está iniciando una nueva conexión, pero está asociado con una conexión existente, como una transferencia de datos FTP o un ICMP

---

En este caso el ejemplo es de un host/firewall con política DROP que almacena un servidor web pero no tiene acceso de salida a internet, es decir el servidor web no puede hacer nuevas peticiones por http/s, pero si le permitimos que mande respuestas a las peticiones que le llegan.

```bash
iptables -A INTPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp -m tcp --sport 80 -m state \
						--state RELATED,ESTABLISHED -j ACCEPT

iptables -A INTPUT  -p tcp -m tcp --dport 443 -j ACCEPT
iptables -A OUTPUT -p tcp -m tcp --sport 443 -m state \
							--state RELATED,ESTABLISHED -j ACCEPT

iptables -A OUTPUT -p tcp --dport 443 -j DROP
iptables -A OUTPUT -p tcp --dport 80 -j DROP
```



## Permitir trafico establecido

```bash
iptables -t filter -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -t filter -A OUPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
```



## Servicios en drop

```bash
# Permetre consultes DNS (primari i secundari)
/sbin/iptables -A INPUT  -s 80.58.61.250 -p udp --sport 53 -j ACCEPT
/sbin/iptables -A OUTPUT -d 80.58.61.250 -p udp --dport 53 -j ACCEPT

/sbin/iptables -A INPUT  -s 80.58.61.254 -p udp --sport 53 -j ACCEPT
/sbin/iptables -A OUTPUT -d 80.58.61.254 -p udp --dport 53 -j ACCEPT

# Actuar de servidor web el host/firewall
/sbin/iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
/sbin/iptables -A OUTPUT -p tcp -m tcp --sport 80 -m state \
						--state RELATED,ESTABLISHED -j ACCEPT

# Permetre al host/firewall navegar per internet
/sbin/iptables -A INPUT -p tcp -m tcp --sport 80 -m state \
						--state RELATED,ESTABLISHED -j ACCEPT
/sbin/iptables -A OUTPUT -p tcp -m tcp --dport 80 -j ACCEPT

/sbin/iptables -A INPUT  -p tcp -m tcp --sport 443 -m state \
						--state RELATED,ESTABLISHED -j ACCEPT
/sbin/iptables -A OUTPUT -p tcp -m tcp --dport 443 -j ACCEPT

# Consultar al servidor de temps per permetre la sincronització horària
/sbin/iptables -A INPUT  -p udp -m udp --dport 123 -j ACCEPT
/sbin/iptables -A OUTPUT -p udp -m udp --sport 123 -j ACCEPT

# Permetre el tràfic SMTP d’entrada i sortida
iptables -A INPUT  -s 0.0.0.0/0 -p tcp --dport 25 -j ACCEPT
iptables -A OUTPUT -s 0.0.0.0/0 -p tcp --dport 25 -j ACCEPT

# Servei FTP actiu i passiu
/sbin/iptables -A INPUT -p tcp -m tcp --sport 20:21 -m state \
							--state RELATED,ESTABLISHED -j ACCEPT
/sbin/iptables -A OUTPUT -p tcp -m tcp --dport 20:21 -j ACCEPT

# puertos no sistema
/sbin/iptables -A INPUT -p tcp -m tcp --sport 1024:65535 --dport 1024:65535 -m state \
							--state ESTABLISHED -j ACCEPT
/sbin/iptables -A OUTPUT -p tcp -m tcp --dport 1024:65535 -m state \
							--state NEW,RELATED,ESTABLISHED -j ACCEPT
```

En ocasiones la política drop hace demasiado bien su trabajo y al abrir nuevos servicios, fallan por que les esta cortando el firewall y se pone en política accept temporalmente mientras se soluciona el script por prisas o etc..  por esto mismo es una buena practica al final del script  poner la barrera drop y así no exponer datos sensibles que podamos tener..

```bash
# Barrera final DROP per si es canvia a ACCEPT temporalment
# tancar tràfic no desitjat
/sbin/iptables -A INPUT -p tcp -m tcp --dport 1:1024 -j DROP
/sbin/iptables -A INPUT -p udp -m udp --dport 1:1024 -j DROP
/sbin/iptables -A INPUT -p tcp -m tcp --dport 1723 -j DROP
/sbin/iptables -A INPUT -p tcp -m tcp --dport 3306 -j DROP
/sbin/iptables -A INPUT -p tcp -m tcp --dport 5432 -j DROP
```



## Forwarding

```bash
$ echo 1 > /proc/sys/net/ipv4/ip_forward
# o be:
sysctl net.ipv4.ip_forward=1

sysctl -a | grep ip_forward
net.ipv4.ip_forward = 1
```

En un firewall por defecto la red externa suele tener todos los puertos cerrados y la interna abiertos, `eth0` interficie externa, `eth1` interficie interna.

```bash
iptables -A INPUT -s 0.0.0.0  -i eth0 -j DROP
iptables -A INPUT -s 172.16.10.0/24 -i eth1 -j ACCEPT
```



### Nat

**Network Addres Translation** se le aplica cuando en un router o host/firewall con dos o mas interficies, recibe peticiones por un red y las devuelve por otra con una ip diferente, en este proceso se a aplicado un `forward` a recibido un paquete por una red, a mirado de quien era y se lo a enviado estando en una red diferente el destinatario.

```bash
# NAT usant la IP pública de eth0
iptables -t nat -A POSTROUTING -s 172.16.10.0/24 -o eth0 -j MASQUERADE
```



### Forward

```bash
# no deixar sortir de la lan a exterior a serveis concrets
iptables -A FORWARD -s 172.16.100.0/24 -p tcp --dport 7 -j REJECT
iptables -A FORWARD -s 172.16.100.11 -p tcp --dport 13 -j REJECT

# no deixar sortir de la lan a exterior segons destí
iptables -A FORWARD -s 172.16.100.0/24 -d 192.168.1.34 -p tcp --dport 23 -j REJECT
iptables -A FORWARD -i em1 -d 192.168.1.0/24 -p tcp --dport 82 -j REJECT

# un host de la lan concret no pot accedir a un servei extern (segons destí)
iptables -A FORWARD -s 172.16.100.11 -d 192.168.1.34 -p tcp --dport 110 -j REJECT
iptables -A FORWARD -s 172.16.100.11 -d 192.168.1.0/24 -p tcp --dport 143 -j REJECT

# evitar que des de dins de la LAN es falsifiqui ip origen (spoofing)
iptables -A FORWARD ! -s 172.16.100.0/24 -i em1 -j REJECT
```



### Dnat

**Destination network address translation** es muy similar a NAT pero en DNAT se redirige el puerto a otro diferente, igual que NAT también se puede redirigir el destino. Es decir en NAT redirigimos de `ip a ip` y en DNAT de `ip:puerto a ip:puerto`.



```bash
# dirigir tot el tràfic http port 80 a un altre host de la LAN
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j DNAT --to 192.168.10.12:80
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 443 -j DNAT --to 192.168.10.12:443

# si el tràfic hhtp prové de de casa meva (221.15.15.15) enviar-lo a un altre web server
# (aquesta regla ha d’anar abans de les anteriors)
iptables -t nat -A PREROUTING -s 221.15.15.15 -i eth0 -p tcp --dport 80 -j DNAT \
							--to 192.168.10.10:80
iptables -t nat -A PREROUTING -s 221.15.15.15 -i eth0 -p tcp --dport 443 -j DNAT \
							--to 192.168.10.10:443
							
# obrir puerto 2022 e la interfaz enp3s0 y redirigir a 192.168.10.10:22
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 2022 -j DNAT --to 192.168.10.10:22

# port forwarding según la red de origen
iptables -t nat -A PREROUTING -s 172.17.0.0/24 -i eth0 -p tcp --dport 2022 -j DNAT --to 192.168.10.10:22
```



## Icmp



```bash
iptables -A FORWARD -p icmp --icmp-type 8 -j DROP

# habilitar ping
iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT
iptables -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT

# no aceptar ping
iptables -A INPUT -p ICMP -j DROP
# o
iptables -A INPUT -p icmp --icmp-type 8 -j DROP
iptables -A OUTPUT -p icmp --icmp-type 8 -j DROP

```

echo-reply (pong)

echo-request (ping)

=> **Zero** (0) is for echo-reply

=> **Eight** (8) is for echo-request.



## Ejemplo Drop

```bash

# Regles Flush: buidar les regles actuals
iptables -F
iptables -X
iptables -Z
iptables -t nat -F

# Establir la politica per defecte (ACCEPT o DROP)
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Permetre totes les pròpies connexions via localhost
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Permetre tot el trafic de la pròpia ip(192.168.1.49))
iptables -A INPUT -s 192.168.1.35 -j ACCEPT
iptables -A OUTPUT -d 192.168.1.35 -j ACCEPT
#exit 0
# -----------------------------------------------------------

# consulta dns primari
iptables -A INPUT -s 80.58.61.250 -p udp -m udp --sport 53 -j ACCEPT
iptables -A OUTPUT -d 80.58.61.250 -p udp -m udp --dport 53 -j ACCEPT

# consulta dns secundari
iptables -A INPUT -s 80.58.61.254 -p udp -m udp --sport 53 -j ACCEPT
iptables -A OUTPUT -d 80.58.61.254 -p udp -m udp --dport 53 -j ACCEPT

# consulta ntp
iptables -A INPUT -p udp -m udp --dport 123 -j ACCEPT
iptables -A OUTPUT -p udp -m udp --sport 123 -j ACCEPT

# ----------------------------------------------------------
# servei cups
iptables -A INPUT -p tcp --dport 631 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 631 -j ACCEPT

# port xinetd
iptables -A INPUT -p tcp --dport 3411 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 3411 -j ACCEPT

# port x11-x-forwarding
iptables -A INPUT -p tcp --dport 6010 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 6010 -j ACCEPT

# servei rpc
iptables -A INPUT -p tcp --dport 111 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 111 -j ACCEPT

# -----------------------------------------------------------

# icmp
iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT
iptables -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT

# -----------------------------------------------------------

# servei ssh
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT

# servei http
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 80 -j ACCEPT

# servei daytime
iptables -A INPUT -p tcp --dport 13 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 13 -j ACCEPT

# servei echo
iptables -A INPUT -p tcp --dport 7 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 7 -j ACCEPT

# servei smtp
iptables -A INPUT -p tcp --dport 25 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 25 -j ACCEPT
# exit 0

# ==============================================================
# atencio: cal millorar aquestes regles!!!          *****
# cal que nomes es permeti trafic relacionat        *****
# ==============================================================

# navegar web
#iptables -A INPUT -p tcp --sport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --sport 443 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT

# accedir a servei echo
#iptables -A INPUT -p tcp --sport 7 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 7 -j ACCEPT

# accedir al servei daytime
#iptables -A INPUT -p tcp --sport 13 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 13 -j ACCEPT

# accedir al servei ssh
#iptables -A INPUT -p tcp --sport 22 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT

iptables -A INPUT -m state --state ESTABLISHED,RELATED
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED

# -----------------------------------------------------------------
# ftp i tftp (trafic udp)               *****
# -----------------------------------------------------------------

# oferir servei tftp
iptables -A INPUT -p udp --dport 69 -j ACCEPT
iptables -A OUTPUT -p udp --sport 69 -j ACCEPT

# accedir a serveis tftp externs
iptables -A INPUT -p udp --sport 69 -j ACCEPT
iptables -A OUTPUT -p udp --dport 69 -j ACCEPT

# pendent obrir ports dinamics
# oferir servei ftp
iptables -A INPUT -p tcp --dport 20:21 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 20:21 -j ACCEPT

# accdir a serveis ftp externs
iptables -A INPUT -p tcp --sport 20:21 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 20:21 -j ACCEPT

# pendent obrir ports dinamics!
# --------------------------------------------------------------
# Barrera per tancar els serveis/ports en cas de passar a drop
# ...

```



## Ejemplo DMZ

```bash
# Activar si el host ha de fer de router
echo 1 > /proc/sys/net/ipv4/ip_forward

# Regles Flush: buidar les regles actuals
iptables -F
iptables -X
iptables -Z
iptables -t nat -F

# Establir la politica per defecte (ACCEPT o DROP)
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -t nat -P PREROUTING ACCEPT
iptables -t nat -P POSTROUTING ACCEPT

# Permetre totes les pròpies connexions via localhost
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Permetre tot el trafic de la propia ip exterior (wlan0:192.168.1.41))
iptables -A INPUT -s 192.168.1.41 -j ACCEPT
iptables -A OUTPUT -d 192.168.1.41 -j ACCEPT

# Permetre tot el trafic de la propia ip interior (em1:172.16.100.1))
iptables -A INPUT -s 172.16.100.1 -j ACCEPT
iptables -A OUTPUT -d 172.16.100.1 -j ACCEPT

# Permetre tot el trafic de la propia ip interior (em1:172.32.1.1))
iptables -A INPUT -s 172.32.1.1 -j ACCEPT
iptables -A OUTPUT -d 172.32.1.1 -j ACCEPT
#exit 0

# Ahora hacemos enmascaramiento de la red local (HACIA FUERA)
iptables -t nat -A POSTROUTING -s 172.16.100.0/24 -o wlan0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 172.32.1.0/24 -o wlan0 -j MASQUERADE
#exit 0

# ==========================================================
# Regles de: xarxa_local-(R/F)-xarxa_externa
#
# LOCAL_LAN ---(em1)Router/Firewall(wlan0)-- PUBLIC_LAN
#               |
#               DMZ (em1)
# ========================================================

# de la lan no accedir al router/fireall, excepte ssh, telnet i daytime
iptables -A INPUT -s 172.16.100.0/24 -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -s 172.16.100.0/24 -p tcp --dport 23 -j ACCEPT
iptables -A INPUT -s 172.16.100.0/24 -p tcp --dport 13 -j ACCEPT
iptables -A INPUT -s 172.16.100.0/24 -j DROP
#exit 0

# de la lan NO es pot navegar,telnet,ssh a fora
iptables -A FORWARD -s 172.16.100.0/24 -p tcp --dport 80 -j DROP
iptables -A FORWARD -s 172.16.100.0/24 -p tcp --dport 23 -j DROP
iptables -A FORWARD -s 172.16.100.0/24 -p tcp --dport 22 -j DROP

# de la lan acces al servidor web de la dmz: intranet
iptables -A INPUT -s 172.16.100.0/24 -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -s 172.16.100.0/24 -p tcp --dport 443 -j ACCEPT

# de exterior acces ports 3081:3085 redirigits a servers dins dmz
iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 3081 -j DNAT \
                                        --to 172.32.1.11:81
iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 3082 -j DNAT \
                                        --to 172.32.1.11:82
iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 3083 -j DNAT \
                                        --to 172.32.1.11:83
iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 3084 -j DNAT \
                                        --to 172.32.1.11:84
iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 3085 -j DNAT \
                                        --to 172.32.1.11:85

# des de exteriors ports 3022:3025 redirigits a ssh host de la lan
iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 3022 -j DNAT \
                                        --to 172.16.100.11:22
iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 3023 -j DNAT \
                                        --to 172.16.100.12:22
iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 3024 -j DNAT \
                                        --to 172.16.100.13:22

```

