#!/bin/bash
# jorge Pastor

# ip-10-drop.sh:  DROP política drop per defecte

# Implementar DROP per defecte a un host de l’aula i que funcioni normalment. Exemple fitxer https://drive.google.com/open?id=1vqjOJfLSt0McfJg7AuIRdqwR_6dbCR_X 
# A tenir en compte en el DROP:
#     dns 53
#     dhclient (68)
#     ssh (22)
#     rpc 111, 507
#     chronyd 123, 371
#     cups 631
#     xinetd 3411
#     postgresql 5432
#     x11forwarding 6010, 6011
#     avahi 368
#     alpes 462
#     tcpnethaspsrv 475
#     pxe 761

# permetre servei local de: echo-stream, daytime-stream, telnet, pop3, imap, tftp
# accedir als serveis externs de: echo-stream, ssh, tftp.

# Borrar reglas actuales
/sbin/iptables -F
/sbin/iptables -X
/sbin/iptables -Z
/sbin/iptables -t nat -F

# definir política per defecte accept.
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP
# /sbin/iptables -t nat -P PREROUTING ACCEPT
# /sbin/iptables -t nat -P POSTROUTING ACCEPT

# obrir al lo i la pròpia ip les connexions locals.
/sbin/iptables -A INPUT -i lo -j ACCEPT
/sbin/iptables -A OUTPUT -o lo -j ACCEPT

/sbin/iptables -A INPUT -s 192.168.88.2 -j ACCEPT
/sbin/iptables -A OUTPUT -d 192.168.88.2 -j ACCEPT

# consulta dns primari
/sbin/iptables -A INPUT   -s 10.1.1.200     -p udp  --sport 53 -j ACCEPT
/sbin/iptables -A OUTPUT  -d 10.1.1.200     -p udp  --dport 53 -j ACCEPT

# dhclient (68)
iptables -A INPUT -p udp -m udp --dport 68 -j ACCEPT
iptables -A OUTPUT -p udp -m udp --sport 68 -j ACCEPT

# ssh (22)
# servei ssh
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT

# Servidor local: servei rpc
iptables -A INPUT   -p tcp --dport 111 -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 111 -j ACCEPT

# chronyd 123, 371
# consulta ntp
iptables -A INPUT -p udp -m udp --dport 123 -j ACCEPT
iptables -A OUTPUT -p udp -m udp --sport 123 -j ACCEPT

# chronyd
iptables -A INPUT   -p udp --dport 371 -j ACCEPT
iptables -A OUTPUT  -p udp --sport 371 -j ACCEPT

# cups 631
iptables -A INPUT   -p tcp --dport 631  -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 631  -j ACCEPT

# xinetd 3411
iptables -A INPUT   -p tcp --dport 3411 -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 3411 -j ACCEPT

# postgresql 5432
iptables -A INPUT   -p tcp --dport 5432 -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 5432 -j ACCEPT

# x11forwarding 6010, 6011
iptables -A INPUT   -p tcp --dport 6010 -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 6010 -j ACCEPT
iptables -A INPUT   -p tcp --dport 6011 -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 6011 -j ACCEPT

# avahi 368
iptables -A INPUT   -p udp --dport 368   -j ACCEPT
iptables -A OUTPUT  -p udp --sport 368   -j ACCEPT

# alpes 462
iptables -A INPUT   -p udp --dport 463   -j ACCEPT
iptables -A OUTPUT  -p udp --sport 463   -j ACCEPT

# tcpnethaspsrv 475
iptables -A INPUT   -p udp --dport 475   -j ACCEPT
iptables -A OUTPUT  -p udp --sport 475   -j ACCEPT

# pxe 761
iptables -A INPUT   -p tcp --dport 761 -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 761 -j ACCEPT

# permetre servei local de: echo-stream, daytime-stream, telnet, pop3, imap, tftp

# echo-stream
iptables -A INPUT   -p tcp --dport 7   -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 7   -j ACCEPT

# daytime-stream
iptables -A INPUT   -p tcp --dport 13   -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 13   -j ACCEPT

# telnet
iptables -A INPUT   -p tcp --dport 23  -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 23  -j ACCEPT

# pop3
iptables -A INPUT   -p tcp --dport 110  -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 110  -j ACCEPT
# cifrado
iptables -A INPUT   -p tcp --dport 995  -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 995  -j ACCEPT

# imap
iptables -A INPUT   -p tcp --dport 143   -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 143   -j ACCEPT
# imap3
iptables -A INPUT   -p tcp --dport 220   -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 220   -j ACCEPT
# imaps
iptables -A INPUT   -p tcp --dport 993   -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 993   -j ACCEPT

# tftp
iptables -A INPUT   -p udp --dport 69   -j ACCEPT
iptables -A OUTPUT  -p udp --sport 69   -j ACCEPT

# accedir als serveis externs de: echo-stream, ssh, tftp.

# echo-stream
iptables -A INPUT    -p tcp --sport 7   -j ACCEPT
iptables -A OUTPUT   -p tcp --dport 7   -j ACCEPT

# ssh
iptables -A INPUT    -p tcp --sport 22   -j ACCEPT
iptables -A OUTPUT   -p tcp --dport 22   -j ACCEPT

# tftp
iptables -A INPUT   -p udp --sport 69   -j ACCEPT
iptables -A OUTPUT  -p udp --dport 69   -j ACCEPT

# -----------------------------------------

# Personal navegar por http/s, puertos de usuario abiertos

# http/s
/sbin/iptables -A INPUT -p tcp -m tcp --sport 80 -m state --state RELATED,ESTABLISHED -j ACCEPT
/sbin/iptables -A OUTPUT -p tcp -m tcp --dport 80 -j ACCEPT

/sbin/iptables -A INPUT  -p tcp -m tcp --sport 443 -m state --state RELATED,ESTABLISHED -j ACCEPT
/sbin/iptables -A OUTPUT -p tcp -m tcp --dport 443 -j ACCEPT

# puertos usuario abiertos
/sbin/iptables -A INPUT -p tcp -m tcp --sport 1024:65535 --dport 1024:65535 -m state \
							--state ESTABLISHED -j ACCEPT
/sbin/iptables -A OUTPUT -p tcp -m tcp --dport 1024:65535 -m state \
                            --state NEW,RELATED,ESTABLISHED -j ACCEPT

# habilitar ping
iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT
iptables -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT


# barrera drop por si cambio modo acept
/sbin/iptables -A INPUT -p tcp -m tcp --dport 1:1024 -j DROP
/sbin/iptables -A INPUT -p udp -m udp --dport 1:1024 -j DROP
