#!/bin/bash
# jorge Pastor

# ip-05-nat.sh:  NAT
#     Crear dues xarxes docker (netA i netB). 
#     Engegar dos hosts a cada xarxa (fer-los privileged per poder practicar el ping). 
#     Verificar que els hosts poden accedir al exterior i(i26 i 8.8.8.8) perquè docker 
#        posa les seves regles.
#     Esborra amb ip-default.sh les regles i observar que ara els containers docker 
#        NO tenen connectivitat a l’exterior, no es fa NAT.
#     Activar NAT per a les dues xarxes privades locals xarxaA i xarxaB. 
#        Verificar que tornen a tenir connectivitat a l’exterior.

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

# Activar NAT per a les dues xarxes privades locals xarxaA i xarxaB. 
# Verificar que tornen a tenir connectivitat a l’exterior.
iptables -t nat -A POSTROUTING -s 172.18.0.0/24 -o enp3s0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 172.19.0.0/24 -o enp3s0 -j MASQUERADE