#!/bin/bash
# jorge Pastor


# ip-06-forwar.sh:  Forwarding
#     forwarding: Usant el model anterior de nat aplicar regles de tràfic de xarxaA a 
#           l’exterior i de xarxaA a xarxaB. 
#     Filtrar per port i per destí.
#        xarxaA no pot accedir xarxab
#        xarxaA no pot accedir a B2.
#        host A1 no pot connectar host B1
#        xarxaA no pot accedir a port 13.
#        xarxaA no pot accedir a ports 2013 de la xarxaB
#        xarxaA permetre navegar per internet però res més a l'exterior
#        xarxaA accedir port 2013 de totes les xarxes d'internet excepte de la xarxa hisx2
#          evitar que es falsifiqui la ip de origen: SPOOFING

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

netA 172.19.0.0/16
    host1 2
    host2 3

netB 172.20.0.0/16
    host3 2
    host4 3

# forwarding: Usant el model anterior de nat aplicar regles de tràfic de xarxaA a 
#   l’exterior i de xarxaA a xarxaB. 

/sbin/iptables -t nat -A POSTROUTING -s 172.19.0.0/16 -o enp3s0 -j MASQUERADE

# xarxaA no pot accedir xarxab

iptables -A FORWARD -s 172.19.0.0/16 -d 172.20.0.0/16 -m state --state ESTABLISHED,RELATED -j ACCEPT 
iptables -A FORWARD -s 172.19.0.0/16 -d 172.20.0.0/16  -j REJECT

# xarxaA no pot accedir a host B2.

iptables -A FORWARD -s 172.19.0.0/16 -d 172.20.0.3 -m state --state ESTABLISHED,RELATED -j ACCEPT 
iptables -A FORWARD -s 172.19.0.0/16 -d 172.20.0.3  -j REJECT

# host A1 no pot connectar host B1

iptables -A FORWARD -s 172.19.0.2 -d 172.20.0.2 -m state --state ESTABLISHED,RELATED -j ACCEPT 
iptables -A FORWARD -s 172.19.0.2 -d 172.20.0.2  -j REJECT

# xarxaA no pot accedir a port 13.

iptables -A FORWARD -s 172.19.0.0/16 -p tcp --dport 13 -j REJECT

# xarxaA no pot accedir a ports 2013 de la xarxaB

iptables -A FORWARD -s 172.19.0.0/16 -d 172.20.0.0/16 -p tcp --dport 2013 -m state --state ESTABLISHED,RELATED -j ACCEPT 
iptables -A FORWARD -s 172.19.0.0/16 -d 172.20.0.0/16 -p tcp --dport 2013  -j REJECT

# xarxaA permetre navegar per internet però res més a l'exterior

/sbin/iptables -t nat -A POSTROUTING -s 172.19.0.0/16 -o enp3s0 -j MASQUERADE
/sbin/iptables -t nat -A POSTROUTING -s 172.20.0.0/16 -o enp3s0 -j MASQUERADE

iptables -A FORWARD -d 172.19.0.0/16  -p tcp --sport 80 -m state --state ESTABLISHED,RELATED -j ACCEPT 
iptables -A FORWARD -d 172.19.0.0/16  -p tcp --sport 443 -m state --state ESTABLISHED,RELATED -j ACCEPT 
iptables -A FORWARD -s 172.19.0.0/16  -p tcp --dport 80  -j ACCEPT
iptables -A FORWARD -s 172.19.0.0/16  -p tcp --dport 443  -j ACCEPT
iptables -A FORWARD -s 172.19.0.0/16  -p tcp  -j DROP

# xarxaA accedir port 2013 de totes les xarxes d'internet excepte de la xarxa hisx2
#   evitar que es falsifiqui la ip de origen: SPOOFING

iptables -A FORWARD -s 172.20.0.0/16 -d 10.200.243.0/24 -p tcp --dport 2013 -m state --state ESTABLISHED,RELATED -j ACCEPT 
iptables -A FORWARD -s 172.20.0.0/16 -d 10.200.243.0/24 -p tcp --dport 2013  -j DROP
iptables -A FORWARD ! -s 172.20.0.0/16 -i enp3s0 -j REJECT