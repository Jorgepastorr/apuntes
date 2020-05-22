#!/bin/bash
# jorge Pastor

# ip-03-established.sh: regles tràfic RELATED, ESTABLISHED
#     explicat el concepte de conversa: tràfic d’anada i de tornada.
#     tcp: establiment de la connexió de tres vies, tràfic d’una connexió o conversa. 
#     wireshark per monitoritzar el tràfic. Usar follow tcp stream.
#     comcepte de  “navegar per internet” → accedir a qualsevol servidor web extern i permetre la ‘resposta’.
#     configurar que sigui un servei web que accepta peticions i només permet respostes relacionades.



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

# accedir a qualsevol servidor web extern i permetre la ‘resposta’.
/sbin/iptables -A OUTPUT -p tcp -m tcp --dport 80 -j ACCEPT
/sbin/iptables -A INPUT -p tcp -m tcp --sport 80 -m state \
					--state RELATED,ESTABLISHED -j ACCEPT

/sbin/iptables -A OUTPUT -p tcp -m tcp --dport 443 -j ACCEPT
/sbin/iptables -A INPUT -p tcp -m tcp --sport 443 -m state \
					--state RELATED,ESTABLISHED -j ACCEPT

/sbin/iptables -A INPUT -p tcp --dport 80 -j DROP
/sbin/iptables -A INPUT -p tcp --dport 443 -j DROP

# servei web que accepta peticions i només permet respostes relacionades.
/sbin/iptables -A INTPUT -p tcp -m tcp --dport 80 -j ACCEPT
/sbin/iptables -A OUTPUT -p tcp -m tcp --sport 80 -m state \
						--state RELATED,ESTABLISHED -j ACCEPT

/sbin/iptables -A INTPUT  -p tcp -m tcp --dport 443 -j ACCEPT
/sbin/iptables -A OUTPUT -p tcp -m tcp --sport 443 -m state \
							--state RELATED,ESTABLISHED -j ACCEPT

/sbin/iptables -A OUTPUT -p tcp --dport 443 -j DROP
/sbin/iptables -A OUTPUT -p tcp --dport 80 -j DROP