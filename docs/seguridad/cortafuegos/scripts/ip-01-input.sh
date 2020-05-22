#!/bin/bash
# jorge Pastor

# ip-01-input.sh: regles bàsiques de input
#     en el host local s’han obert els ports 80 i redirigit a ell els 2080, 3080, 4080, 5080. 
# Tots amb xinetd.
#     port 80 obert a tothom
#     port 2080 tancat a tothom (reject)
#     port 2080 tancat a tothom (drop)
#     port 3080 tancat a tothom però obert al i26
#     port 4080 obert a tohom però tancat a i26
#     port 5080 tancat a tothom, obert a hisx2 (192.168.2.0/24) i tancat a i26.


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


# port 80 obert a tothom
/sbin/iptables -A INPUT  -p tcp --dport 80 -j ACCEPT

# port 2080 tancat a tothom (reject)
/sbin/iptables -A INPUT  -p tcp --dport 2080 -j REJECT

# port 2080 tancat a tothom (drop)
/sbin/iptables -A INPUT  -p tcp --dport 2080 -j DROP

# port 3080 tancat a tothom però obert al i26
/sbin/iptables -A INPUT  -s i26 -p tcp --dport 3080 -j ACCEPT
/sbin/iptables -A INPUT  -p tcp --dport 3080 -j DROP

# port 4080 obert a tohom però tancat a i26
/sbin/iptables -A INPUT  -s i26 -p tcp --dport 4080 -j DROP
/sbin/iptables -A INPUT  -p tcp --dport 4080 -j ACCEPT

# port 5080 tancat a tothom, obert a hisx2 (192.168.2.0/24) i tancat a i26.
/sbin/iptables -A INPUT  -s i26 -p tcp --dport 5080 -j DROP
/sbin/iptables -A INPUT -s 192.168.2.0/24 -p tcp --dport 5080 -j ACCEPT
/sbin/iptables -A INPUT  -p tcp --dport 5080 -j DROP