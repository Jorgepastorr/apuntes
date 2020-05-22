#!/bin/bash
# jorge Pastor

# ip-04-icmp.sh:  ICPM (ping request(8) reply(0))
#     No permetre fer pings cap a l'exterior
#     No podem fer pings cap al i26
#     No permetem respondre als pings que ens facin
#     No permetem rebre respostes de ping


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


#  No permetre fer pings cap a l'exterior
iptables -A OUTPUT -p icmp --icmp-type 8 -j DROP

#  No podem fer pings cap al i26
iptables -A OUTPUT -d i26 -p icmp --icmp-type 8 -j DROP

#  No permetem respondre als pings que ens facin
iptables -A INPUT -p icmp --icmp-type 8 -j DROP

#  No permetem rebre respostes de ping
iptables -A INPUT -p icmp --icmp-type 0 -j DROP