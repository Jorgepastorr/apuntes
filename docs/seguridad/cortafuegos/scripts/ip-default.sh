#!/bin/bash
# jorge Pastor

# ip-default.sh:
#     fer flush de totes les regles.
#     definir política per defecte accept.
#     obrir al lo i la pròpia ip les connexions locals.
#     llistar les regles

# Borrar reglas actuales
/sbin/iptables -F
/sbin/iptables -X
/sbin/iptables -Z
/sbin/iptables -t nat -F

# definir política per defecte accept.
/sbin/iptables -P INPUT ACCEPT
/sbin/iptables -P OUTPUT ACCEPT
/sbin/iptables -P FORWARD ACCEPT

# obrir al lo i la pròpia ip les connexions locals.
/sbin/iptables -A INPUT -i lo -j ACCEPT
/sbin/iptables -A OUTPUT -o lo -j ACCEPT

/sbin/iptables -A INPUT -s 192.168.88.2 -j ACCEPT
/sbin/iptables -A OUTPUT -d 192.168.88.2 -j ACCEPT

# llistar
/sbin/iptables -L -n