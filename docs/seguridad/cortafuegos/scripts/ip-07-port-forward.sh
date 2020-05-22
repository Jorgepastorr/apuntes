#!/bin/bash
# jorge Pastor


# ip-07-port-forwar.sh:  IP/PORT forwarding
#     expliocat que és fer un prerouting que el que fem és DNAT, modificar la adreça i/o port destí.
#     SEMPRE despres del prerouting s’aplica el routing de manera que s’aplicaran les regles input o
#          forward a continuació.
#     exemple de fer port forwarding dels ports 5001, 5002 i 5003 al port 13 de hostA1, hostA2 i
#          el pròpi router. Observar que externament accedim al port 13 de cada host.
#     posar ara una regla forwarding reject del port 13 i veiem que l’accés dels ports 5001 i 5002 
#         es rebutja, perquè després del port forwarding hi ha el routing que aplica forward.
#     treiem la regla forward i posem una regla input reject del port 13. ara és el port 5003
#          el que no funciona, perquè s’aplica input en ser el destí localhost.

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

# Exemple de fer port forwarding dels ports 5001, 5002 i 5003 al port 13 de hostA1, hostA2 i
# el pròpi router. Observar que externament accedim al port 13 de cada host.

iptables -t nat -A PREROUTING -i enp3s0 -p tcp --dport 5001 -j DNAT --to 172.19.0.2:13
iptables -t nat -A PREROUTING -i enp3s0 -p tcp --dport 5002 -j DNAT --to 172.19.0.2:13
iptables -t nat -A PREROUTING -i enp3s0 -p tcp --dport 5003 -j DNAT --to 172.19.0.2:13

pi@raspberrypi:~ $ nc 192.168.88.2 5001
17 APR 2020 11:35:03 UTC

# Posar ara una regla forwarding reject del port 13 i veiem que l’accés dels ports 5001 i 5002 
# es rebutja, perquè després del port forwarding hi ha el routing que aplica forward.

iptables -A FORWARD  -p tcp --dport 13 -j REJECT

pi@raspberrypi:~ $ nc -v 192.168.88.2 5003
nc: connect to 192.168.88.2 port 5003 (tcp) failed: Connection refused


# Treiem la regla forward i posem una regla input reject del port 13. ara és el port 5003
# el que no funciona, perquè s’aplica input en ser el destí localhost.

iptables -nL --line-numbers
iptables -D FORWARD 1

iptables -A INPUT  -p tcp --dport 13 -j REJECT