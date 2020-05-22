#!/bin/bash
# jorge Pastor

# ip-08-DMZ.sh:  DMZ
#     Plantejat el model de DMZ, al readme hi ha les ordres per engegar els containers.
#     xarxaA: hostA1 i hostA2. xarxaB hostB1 i hostB2. xarxaDMZ host dmz1(nethost) dmz2(ldapserver), 
#            dmz3(kserver), dmz4(samba)
#     aplicar les regles que es descriuen al readme:
#         de la xarxaA només es pot accedir del router/fireall als serveis: ssh i daytime(13)
#         de la xarxaA només es pot accedir a l'exterior als serveis web, ssh i daytime(2013)
#         de la xarxaA només es pot accedir serveis que ofereix la DMZ al servei web
#         redirigir els ports perquè des de l'exterior es tingui accés a: 3001->hostA1:80, 
#                3002->hostA2:2013, 3003->hostB1:2080,3004->hostB2:2007
#         S'habiliten els ports 4001 en endavant per accedir per ssh als ports ssh de: hostA1, hostA2,
#             hostB1, hostB2.
#         S'habilita el port 4000 per accedir al port ssh del router/firewal si la ip origen és 
#            del host i26.
#         Els hosts de la xarxaB tenen accés a tot arreu excepte a la xarxaA.


# Borrar reglas actuales
/sbin/iptables -F
/sbin/iptables -X
/sbin/iptables -Z
/sbin/iptables -t nat -F

# definir política per defecte accept.
/sbin/iptables -P INPUT ACCEPT
/sbin/iptables -P OUTPUT ACCEPT
/sbin/iptables -P FORWARD ACCEPT
/sbin/iptables -t nat -P PREROUTING ACCEPT
/sbin/iptables -t nat -P POSTROUTING ACCEPT

# obrir al lo i la pròpia ip les connexions locals.
/sbin/iptables -A INPUT -i lo -j ACCEPT
/sbin/iptables -A OUTPUT -o lo -j ACCEPT

/sbin/iptables -A INPUT -s 192.168.88.2 -j ACCEPT
/sbin/iptables -A OUTPUT -d 192.168.88.2 -j ACCEPT

# xarxaA: hostA1 i hostA2. 172.19.0.0
# xarxaB hostB1 i hostB2.   172.20.0.0
# xarxaDMZ host dmz1(nethost) dmz2(ldapserver),dmz3(kserver), dmz4(samba) 172.21.0.0

# netA
➜  ~ docker run --rm --name hostA1 -h hostA1 --net netA -it debian:buster /bin/bash
➜  ~ docker run --rm --name hostA2 -h hostA2 --net netA -it debian:buster /bin/bash
# netB
➜  ~ docker run --rm --name hostB1 -h hostB1 --net netB -it debian:buster /bin/bash
➜  ~ docker run --rm --name hostB2 -h hostB2 --net netB -it debian:buster /bin/bash
# DMZ
➜  ~ docker run --rm --name nethost -h nethost --net netDMZ -d jorgepastorr/net19:nethost
➜  ~ docker run --rm --name ldap.edt.org -h ldap.edt.org --net netDMZ -d jorgepastorr/ldapserver19:final
➜  ~ docker run --rm --name kserver -h kserver --net netDMZ -d jorgepastorr/k19:kserver
➜  ~ docker run --rm --name samba -h samba --net netDMZ -d jorgepastorr/samba19:base


# hacer nat de las redes poder salir exterior
# iptables -t nat -A POSTROUTING -s 172.19.0.0/16 -o enp3s0 -j MASQUERADE
# iptables -t nat -A POSTROUTING -s 172.20.0.0/16 -o enp3s0 -j MASQUERADE
# iptables -t nat -A POSTROUTING -s 172.21.0.0/16 -o enp3s0 -j MASQUERADE

# de la xarxaA només es pot accedir del router/firewall als serveis: ssh i daytime(13)

iptables -A FORWARD -s 172.19.0.0/16  -p tcp --dport 22  -j ACCEPT
iptables -A FORWARD -s 172.19.0.0/16  -p tcp --dport 13  -j ACCEPT
iptables -A FORWARD -s 172.19.0.0/16  -p tcp  -j DROP

# de la xarxaA només es pot accedir a l'exterior als serveis web, ssh i daytime(2013)

iptables -t nat -A POSTROUTING -s 172.19.0.0/16 -o enp3s0 -j MASQUERADE
iptables -A FORWARD -s 172.19.0.0/16 -o enp3s0 -p tcp --dport 22  -j ACCEPT
iptables -A FORWARD -s 172.19.0.0/16 -o enp3s0 -p tcp --dport 2013  -j ACCEPT
iptables -A FORWARD -d 172.19.0.0/16 -o enp3s0 -p tcp --sport 80 -m state --state ESTABLISHED,RELATED -j ACCEPT 
iptables -A FORWARD -d 172.19.0.0/16 -o enp3s0 -p tcp --sport 443 -m state --state ESTABLISHED,RELATED -j ACCEPT 
iptables -A FORWARD -s 172.19.0.0/16 -o enp3s0 -p tcp --dport 80  -j ACCEPT
iptables -A FORWARD -s 172.19.0.0/16 -o enp3s0 -p tcp --dport 443  -j ACCEPT
iptables -A FORWARD -s 172.19.0.0/16 -o enp3s0 -p tcp  -j DROP

# de la xarxaA només es pot accedir serveis que ofereix la DMZ al servei web

iptables -A FORWARD -d 172.19.0.0/16  -p tcp --sport 80 -m state --state ESTABLISHED,RELATED -j ACCEPT 
iptables -A FORWARD -s 172.19.0.0/16  -p tcp --dport 80  -j ACCEPT
iptables -A FORWARD -s 172.19.0.0/16  -p tcp  -j DROP

# redirigir els ports perquè des de l'exterior es tingui accés a: 
#    3001->hostA1:80, 
#    3002->hostA2:2013, 
#    3003->hostB1:2080,
#    3004->hostB2:2007

iptables -t nat -A PREROUTING -i enp3s0 -p tcp --dport 3001 -j DNAT --to 172.19.0.2:80
iptables -t nat -A PREROUTING -i enp3s0 -p tcp --dport 3002 -j DNAT --to 172.19.0.3.2013
iptables -t nat -A PREROUTING -i enp3s0 -p tcp --dport 3003 -j DNAT --to 172.20.0.2:2080
iptables -t nat -A PREROUTING -i enp3s0 -p tcp --dport 3004 -j DNAT --to 172.20.0.3:2007

# S'habiliten els ports 4001 en endavant per accedir per ssh als ports ssh de: hostA1, hostA2,
#     hostB1, hostB2.

iptables -t nat -A PREROUTING -i enp3s0 -p tcp --dport 4001 -j DNAT --to 172.19.0.2:22
iptables -t nat -A PREROUTING -i enp3s0 -p tcp --dport 4002 -j DNAT --to 172.19.0.3.22
iptables -t nat -A PREROUTING -i enp3s0 -p tcp --dport 4003 -j DNAT --to 172.20.0.2:22
iptables -t nat -A PREROUTING -i enp3s0 -p tcp --dport 4004 -j DNAT --to 172.20.0.3:22


# S'habilita el port 4000 per accedir al port ssh del router/firewal si la ip origen és 
#    del host i26.

iptables -t nat -A PREROUTING -s i26 -p tcp --dport 4000 -j DNAT --to 192.168.88.2:22

# Els hosts de la xarxaB tenen accés a tot arreu excepte a la xarxaA.

iptables -t nat -A POSTROUTING -s 172.20.0.0/16 -o enp3s0 -j MASQUERADE
iptables -A FORWARD -s 172.20.0.0/16 -d 172.19.0.0/16 -p tcp  -j REJECT