#!/bin/bash
# ASIX M11-Seguretat i alta disponibilitat
# @edt 2015
# ==============================================
# Exemples de regles DROP
# host i19 (192.168.2.49)
# paquets: xinetd, telnet, telnet-server, httpd, uw-imap
# fets amb xinetd: echo-stream(7), daytime-stream(13),
# daytime2(82), ipop3(110), imap(143), https2(81)
# stand-alone: httpd, xinetd
# ===============================================
# Activar si el host ha de fer de router
#echo 1 > /proc/sys/net/ipv4/ip_forward

# Regles Flush: buidar les regles actuals
iptables -F
iptables -X
iptables -Z
iptables -t nat -F

# Establir la politica per defecte (ACCEPT o DROP)
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP
#iptables -t nat -P PREROUTING ACCEPT
#iptables -t nat -P POSTROUTING ACCEPT

# Permetre totes les pròpies connexions via localhost
iptables -A INPUT   -i lo -j ACCEPT
iptables -A OUTPUT  -o lo -j ACCEPT

# Permetre tot el trafic de la pròpia ip(192.168.1.49))
iptables -A INPUT   -s 192.168.1.49   -j ACCEPT
iptables -A OUTPUT  -d 192.168.1.49   -j ACCEPT
# -----------------------------------------------------------
# Obrir tràfic DNS
/sbin/iptables -A INPUT   -s 192.168.0.10   -p udp  --sport 53 -j ACCEPT
/sbin/iptables -A OUTPUT  -d 192.168.0.10   -p udp  --dport 53 -j ACCEPT
/sbin/iptables -A INPUT   -s 10.1.1.200     -p udp  --sport 53 -j ACCEPT
/sbin/iptables -A OUTPUT  -d 10.1.1.200     -p udp  --dport 53 -j ACCEPT
/sbin/iptables -A INPUT   -s 193.152.63.197 -p udp  --sport 53 -j ACCEPT
/sbin/iptables -A OUTPUT  -d 193.152.63.197 -p udp  --dport 53 -j ACCEPT
#
# obrir dhclient (67 server-port, 68 client-port)
iptables -A INPUT   -p udp --dport 68   -j ACCEPT
iptables -A OUTPUT  -p udp --sport 68   -j ACCEPT
#
# Servidor local: servei ssh
iptables -A INPUT   -p tcp --dport 22   -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 22   -j ACCEPT
#
# Servidor local: servei rpc
iptables -A INPUT   -p tcp --dport 111 -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 111 -j ACCEPT
#
# Port local: servei chronyd
iptables -A INPUT   -p tcp --dport 123 -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 123 -j ACCEPT
#
# Servidor local: servei cups
iptables -A INPUT   -p tcp --dport 631  -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 631  -j ACCEPT
#
# Port local: port xinetd
iptables -A INPUT   -p tcp --dport 3411 -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 3411 -j ACCEPT
#
# Servidor local: postgresql
iptables -A INPUT   -p tcp --dport 5432 -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 5432 -j ACCEPT
#
# port x11-x-forwarding
iptables -A INPUT   -p tcp --dport 6010 -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 6010 -j ACCEPT
iptables -A INPUT   -p tcp --dport 6011 -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 6011 -j ACCEPT
# ---------------------------------------------------------
# altres ports que hi ha oberts
#
# chronyd
iptables -A INPUT   -p udp --dport 371 -j ACCEPT
iptables -A OUTPUT  -p udp --sport 371 -j ACCEPT
#
# avahi
iptables -A INPUT   -p udp --dport 368   -j ACCEPT
iptables -A OUTPUT  -p udp --sport 368   -j ACCEPT
#
# alpes
iptables -A INPUT   -p udp --dport 463   -j ACCEPT
iptables -A OUTPUT  -p udp --sport 463   -j ACCEPT
#
# tcpnethaspsrv
iptables -A INPUT   -p udp --dport 475   -j ACCEPT
iptables -A OUTPUT  -p udp --sport 475   -j ACCEPT
#
# rpc.stad
iptables -A INPUT   -p tcp --dport 507 -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 507 -j ACCEPT
# rxe
iptables -A INPUT   -p tcp --dport 761 -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 761 -j ACCEPT
# 
# --------------------------------------------------------
#
# Server local:  servei echo-stream (7,82)
iptables -A INPUT   -p tcp --dport 7   -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 7   -j ACCEPT
iptables -A INPUT   -p tcp --dport 82  -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 82  -j ACCEPT
#
# Server local: servei daytime-stream (13,83)
iptables -A INPUT   -p tcp --dport 13   -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 13   -j ACCEPT
iptables -A INPUT   -p tcp --dport 83   -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 83   -j ACCEPT
#
# Server local: servei telnet (23,84)
iptables -A INPUT   -p tcp --dport 23  -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 23  -j ACCEPT
iptables -A INPUT   -p tcp --dport 84  -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 84  -j ACCEPT
#
# Server local: servei pop3 (110,85)
iptables -A INPUT   -p tcp --dport 110  -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 110  -j ACCEPT
iptables -A INPUT   -p tcp --dport 85   -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 85   -j ACCEPT
#
# Server local: servei imap (143,88)
iptables -A INPUT   -p tcp --dport 143   -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 143   -j ACCEPT
iptables -A INPUT   -p tcp --dport 88    -j ACCEPT
iptables -A OUTPUT  -p tcp --sport 88    -j ACCEPT
#
# Server local: servei tftp (69)
iptables -A INPUT   -p udp --dport 69   -j ACCEPT
iptables -A OUTPUT  -p udp --sport 69   -j ACCEPT
#
# =========================================================
# Accedir a serveis externs
# =========================================================
#
# Accés extern al servei echo-stream
iptables -A INPUT   -s 192.168.2.50 -p tcp --sport 7   -j ACCEPT
iptables -A OUTPUT  -d 192.168.2.50 -p tcp --dport 7   -j ACCEPT
iptables -A INPUT   -p tcp --sport 82  -j ACCEPT
iptables -A OUTPUT  -p tcp --dport 82  -j ACCEPT
#
# Accés extern al servei ssh (però no a i19)
iptables -A INPUT   -s 192.168.2.50 -p tcp --sport 22   -j REJECT
iptables -A OUTPUT  -d 192.168.2.50 -p tcp --dport 22   -j REJECT
iptables -A INPUT   -p tcp --sport 22  -j ACCEPT
iptables -A OUTPUT  -p tcp --dport 22  -j ACCEPT
#
# Accés extern al servei tftp
iptables -A INPUT   -s 192.168.2.51 -p udp --dport 69 -j ACCEPT
iptables -A OUTPUT  -d 192.168.2.51 -p udp --dport 69 -j ACCEPT


# ----------------------------------------------------------
iptables -L 


