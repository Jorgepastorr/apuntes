#!/bin/bash
# jorge Pastor

# ip-09-DMZ2.sh:  DMZ amb servidors nethost, ldap, kerberos i samba
#     (1) des d'un host exterior accedir al servei ldap de la DMZ. Ports 389, 636.
#     (2) des d'un host exterior, engegar un container kclient i obtenir un tiket kerberos del servidor de la DMZ. Ports: 88, 543, 749.
#     (3) des d'un host exterior muntar un recurs samba del servidor de la DMZ.

#     Per engegar:
#         docker network create netA netB netZ
#         docker run --rm --name hostA1 -h hostA1 --net netA --privileged -d edtasixm11/net18:nethost
#         docker run --rm --name hostA2 -h hostA2 --net netA --privileged -d edtasixm11/net18:nethost
#         docker run --rm --name hostB1 -h hostB1 --net netB --privileged -d edtasixm11/net18:nethost
#         docker run --rm --name hostB2 -h hostB2 --net netB --privileged -d edtasixm11/net18:nethost
#         docker run --rm --name dmz1 -h dmz1 --net netDMZ --privileged -d edtasixm11/net18:nethost
#         docker run --rm --name dmz2 -h dmz2 --net netDMZ --privileged -d edtasixm06/ldapserver:18group
#         docker run --rm --name dmz3 -h dmz3 --net netDMZ --privileged -d edtasixm11/k18:kserver
#         docker run --rm --name dmz4 -h dmz4 --net netDMZ --privileged -d edtasixm06/samba:18detach
#         docker run --rm --name dmz5 -h dmz5 --net netDMZ --privileged -d edtasixm11/tls18:ldap

#     Per verificar:
#         ldapsearch -x -LLL  -h profen2i -b 'dc=edt,dc=org' dn
#         ldapsearch -x -LLL  -ZZ -h profen2i -b 'dc=edt,dc=org' dn 
#             #(falta configurar certificat CA en el client)
#         ldapsearch -x -LLL  -H  ldaps://profen2i -b 'dc=edt,dc=org' dn  
#             #(falta configurar certificat CA en el client

#         docker run --rm -it edtasixm11/k18:khost
#         kinit anna

#         smbclient //profen2i/public


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

# (1) des d'un host exterior accedir al servei ldap de la DMZ. Ports 389, 636.

iptables -t nat -A PREROUTING -i enp3s0 -p tcp --dport 389 -j DNAT --to 172.21.0.3:389
iptables -t nat -A PREROUTING -i enp3s0 -p tcp --dport 636 -j DNAT --to 172.21.0.3:636

# [jorge@pc03 ~]$ ldapsearch -x -LLL -b 'dc=edt,dc=org' -h 192.168.88.2 dn
# dn: dc=edt,dc=org
# dn: ou=grups,dc=edt,dc=org
# dn: ou=usuaris,dc=edt,dc=org
# dn: cn=hisx1,ou=grups,dc=edt,dc=org
...

# (2) des d'un host exterior, engegar un container kclient i obtenir un tiket 
#    kerberos del servidor de la DMZ. Ports: 88, 543, 749.

iptables -t nat -A PREROUTING -i enp3s0 -p tcp --dport 88 -j DNAT --to 172.21.0.4:88
iptables -t nat -A PREROUTING -i enp3s0 -p tcp --dport 543 -j DNAT --to 172.21.0.4:543
iptables -t nat -A PREROUTING -i enp3s0 -p tcp --dport 749 -j DNAT --to 172.21.0.4:749

# [jorge@pc03 ~]$ sudo vim /etc/hosts
# [jorge@pc03 ~]$ docker run --rm --name khost -h khost --net host  -it jorgepastorr/k19:khost
# [root@khost docker]# kinit anna
# Password for anna@EDT.ORG: 
# [root@khost docker]# klist
# Ticket cache: FILE:/tmp/krb5cc_0
# Default principal: anna@EDT.ORG

# Valid starting     Expires            Service principal
# 04/18/20 10:26:02  04/19/20 10:26:02  krbtgt/EDT.ORG@EDT.ORG

# (3) des d'un host exterior muntar un recurs samba del servidor de la DMZ.

iptables -t nat -A PREROUTING -i enp3s0 -p tcp --dport 139 -j DNAT --to 172.21.0.5:139
iptables -t nat -A PREROUTING -i enp3s0 -p tcp --dport 445 -j DNAT --to 172.21.0.5:445

# [jorge@pc03 ~]$ smbclient //SAMBA/public -I 192.168.88.2
# Enter anna@EDT.ORG's password: 
# Anonymous login successful
# Try "help" to get a list of possible commands.
# smb: \> ls
#   .                                   D        0  Sat Apr 18 10:33:41 2020
#   ..                                  D        0  Sat Apr 18 10:34:24 2020
#   install.sh                          A      572  Sat Apr 18 10:33:41 2020
#   smb.conf                            N     1400  Sat Apr 18 10:33:41 2020
#   README.md                           N     1909  Sat Apr 18 10:33:41 2020
#   startup.sh                          A      154  Sat Apr 18 10:33:41 2020
#   Dockerfile                          N      379  Sat Apr 18 10:33:41 2020
