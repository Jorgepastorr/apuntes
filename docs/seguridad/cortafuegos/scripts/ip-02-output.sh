#!/bin/bash
# jorge Pastor

# ip-02-output.sh: regles bàsiques de output
#     S'ha engegat el host i26 i i27 (els alumnes només un segon host) on s’hi han engegat 
        # els serveis https i xinetd (amb tota la pesca!).
#     accedir a qualsevol host/port extern
#     accedir a qualsevol port extern 13.
#     accedir a qualsevol port 2013 excepte el del i26.
#     denegar l’accés a qualsevol port 3013, però permetent accedir al 3013 de i26.
#     permetre accedir al port 4013 de tot arreu, excepte dels hosts de la xarxa hisx2, 
        # però si permetent accedir al port 4013 del host i26.
#     xapar l’accés a qualsevol port 80, 13, 7.
#     no permetre accedir als hosts i26 i i27.
#     no permetre accedir a les xarxes hisx1 i hisx2.
#     no permetre accedir a la xarxa hisx2 excepte per ssh.


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


# accedir a qualsevol host/port extern
/sbin/iptables -A OUTPUT  -j ACCEPT

# accedir a qualsevol port extern 13.
/sbin/iptables -A OUTPUT  -p tcp --dport 13 -j ACCEPT


# accedir a qualsevol port 2013 excepte el del i26.
/sbin/iptables -A OUTPUT -d i26 -p tcp --dport 2013 -j DROP
/sbin/iptables -A OUTPUT -p tcp --dport 2013 -j ACCEPT

# denegar l’accés a qualsevol port 3013, però permetent accedir al 3013 de i26.
/sbin/iptables -A OUTPUT -d i26 -p tcp --dport 3013 -j ACCEPT
/sbin/iptables -A OUTPUT -p tcp --dport 3013 -j DROP

# permetre accedir al port 4013 de tot arreu, excepte dels hosts de la xarxa hisx2, 
# però si permetent accedir al port 4013 del host i26.
/sbin/iptables -A OUTPUT -d i26 -p tcp --dport 4013 -j ACCEPT
/sbin/iptables -A OUTPUT -d 192.168.2.0/24 -p tcp --dport 4013 -j DROP
/sbin/iptables -A OUTPUT -p tcp --dport 4013 -j ACCEPT

# xapar l’accés a qualsevol port 80, 13, 7.
/sbin/iptables -A OUTPUT -p tcp --dport 80 -j DROP
/sbin/iptables -A OUTPUT -p tcp --dport 13 -j DROP
/sbin/iptables -A OUTPUT -p tcp --dport 7 -j DROP

# no permetre accedir als hosts i26 i i27.
/sbin/iptables -A OUTPUT -d i26 -j DROP
/sbin/iptables -A OUTPUT -d i27 -j DROP

# no permetre accedir a les xarxes hisx1 i hisx2.
/sbin/iptables -A OUTPUT -d 192.168.88.3.0/24 -j DROP
/sbin/iptables -A OUTPUT -d 192.168.88.2.0/24 -j DROP

# no permetre accedir a la xarxa hisx2 excepte per ssh.
/sbin/iptables -A OUTPUT -d 192.168.2.0/24 -p tcp --dport 22 -j DROP