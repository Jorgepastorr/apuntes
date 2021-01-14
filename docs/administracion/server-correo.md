# Servidor Correo

Para crear este servidor de correo estoy utilizando Postfix, Maildir y Dovecot como cliente utilizo Thunderbird. Este servidor se esta configurando en una maquina virtual Debian10 Buster sobre VirtManager con una configuración de red Bridge sobre la targeta del Host.



```bash
                 +--------+                +--------+
                 |        |                |        |
                 |        |                |        |
  Internet       |        |                |        |
   +-----------> |  MTA   |                |  MTA   |          Servidor
   |             |        |                |        |          pop3/imap
   |             |        |     Internet   |        |          +------+
   |             |        |  +-----------> |        +------->  | MDA  |
+--+-+           +--------+                +--------+          +---+--+     +----+
|    |          Servidor MTP               Servidor MTP            |        |    |
|    |                                                             |        |MUA |
|MUA |                                                             |        |    |
+----+                                                             +---->   +----+

 Cliente correo                                                          Cliente correo
 electronico                                                             electronico

```



## Componentes

MUA ( Mail User Agent ) Thunderbird

MTA ( Mail transfer agent ) Postfix

- postfix transfire correo desde un servidor a otro mediante SMTP

MDA ( Mail Delivery Agent ) Devecot

- Devocot reparte los correos de tu servidor a los usuarios a traves de un cliente en este caso thunderbird

POP3/IMAP protocolos de acceso al buzon de correo

- IMAP accede remotamente al buzon del servidor de correo electronico para leer la correspondencia remotamente

- POP3 descarga el buzon de correo del servidor, para posteriormente leer el correo de forma local



## Funcionamiento

Para enviar un correo se utilizax  un MUA que lo transfirere a un servidor MTA con el protocolo SMTP

El MTA recibe el correo y lo envia al MTA del destinatario utilizando SMTP

El MTA destinatario almacena el correo en el buzon correspondiente, funcion que en algunos casos realiza un programa especifico denominado MDA

El mensage permanece en el buzon hasta que el destinatario utiliza su MUA para acceder al buzon mediante los protocolos POP o IMAP



## Configurar DNS 

Es necesario configurar un DNS para poder resolver las peticiones de  correo en este documento el servidor de correo se encuentra en `192.168.88.13` y el dns en `192.168.88.4` donde la LAN es `192.168.88.0/24`. 

A la hora de instalar nuestro servidor de correo, tendremos que crear los siguientes registros en el DNS:

- Un registro de tipo A que apunte a la dirección del servidor de correo.
- Un registro de tipo PTR, para que funcione la resolución inversa  (necesaria por algunos sistemas para controlar el envío de SPAM por  servidores SMTP.
- Un registro de tipo MX con la prioridad que deseemos, y que apunte al equipo servidor de correo de nuestro dominio.

```bash
cat /etc/bind/named.conf.local 
...
# especificacion de zonas

zone "mymail.com" {
	type master;
	file "db.mymail.com";
};

zone "88.168.192.in-addr.arpa" {
	type master;
	file "db.rev.mymail.com";
};
```



### Resolución directa tipo A y MX

```bash
cat  /var/cache/bind/db.mymail.com
$TTL    3600
@       IN      SOA     server.myail.com. root.mymail.com. (
                   2020122001           ; Serial
                         3600           ; Refresh [1h]
                          600           ; Retry   [10m]
                        86400           ; Expire  [1d]
                          600 )         ; Negative Cache TTL [1h]
;
@       IN      NS      server.mymail.com.
mymail.com.      IN      MX      10 correo

server     	IN      A       192.168.88.4
torre    	IN      A       192.168.88.2
portatil	IN 	    A   	192.168.88.3
correo		IN	    A	    192.168.88.13
```

### Resolución inversa tipo PTR

```bash
cat  /var/cache/bind/db.rev.mymail.com
$TTL    3600
@       IN      SOA     server.mymail.com. root.mymail.com. (
                   2020122001           ; Serial
                         3600           ; Refresh [1h]
                          600           ; Retry   [10m]
                        86400           ; Expire  [1d]
                          600 )         ; Negative Cache TTL [1h]
;
	IN      NS      server.mymail.com.

4	IN      PTR       server.mymail.com.
3	IN      PTR       portatil.mymail.com.
2	IN      PTR       torre.mymail.com.
13	IN	    PTR	      correo.mymail.com.
```

### Comprobaciones DNS

Comprobar que la sintaxis es correcta

```bash
sudo named-checkzone 88.168.192.in-addr.arpa /var/cache/bind/db.rev.mymail.com 
zone 88.168.192.in-addr.arpa/IN: loaded serial 2020122001
OK

sudo named-checkzone mymail.com /var/cache/bind/db.mymail.com 
zone mymail.com/IN: loaded serial 2020122001
OK
```

Comprobar la resolución de dominio

```bash
nslookup correo.mymail.com
Server:		192.168.88.4
Address:	192.168.88.4#53

Name:	correo.mymail.com
Address: 192.168.88.13

nslookup 192.168.88.13
13.88.168.192.in-addr.arpa	name = correo.mymail.com.
```

## Prerequisitos

Añadir ip estatica al servidor de correo e indicar donde esta el DNS

```bash
cat /etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

auto enp1s0
iface enp1s0 inet static 
	address 192.168.88.13
	netmask 255.255.255.0
	gateway 192.168.88.1
```

```bash
cat /etc/resolv.conf 
search mymail.com
nameserver 192.168.88.4
```



Las **cuentas de usuario** de correo, realmente  son usuarios creados en el servidor de correo, asi que creo un par de usuarios para pruebas.

```bash
root@debmail:~# useradd compras -m
root@debmail:~# useradd ventas -m
root@debmail:~# passwd compras
New password: 
Retype new password: 
passwd: password updated successfully
root@debmail:~# passwd ventas
New password: 
Retype new password: 
passwd: password updated successfully
```

Acceso puertos al firewall

smtp 25

imap 143

imaps 993

smtps 465

submission 587

pop3 110

syslog-ng

## Configuración básica

Esta configuración aportara un servidor de correo inseguro donde las contraseñas biajaran en texto plano, no se debe utilizar nunca este tipo de  configuración a no ser vque sea exclusivo para pruebas y entendimiento.

### Instalación de postfix

En la instalación de postfix pide indicar que tipo de servicio quieres configurar y el dominio: 

- `sitio de interner, servidor local...` en este caso indicamos sitio de internet, porque quiero que se comunique con otros mx. 

- Si queremos que nuestras direcciones sean `example@mymail.com`  deberemos indicar `mymail.com`

```bash
sudo apt install postfix
sudo postconf mail_version
mail_version = 3.4.14
```

De momento nos aseguramos de algunos parametros de la  configuración

```bash
vim /etc/postfix/main.cf
...
# my dominio completo
myhostname = correo.mymail.com
alias_maps = hash:/etc/aliases
alias_database = hash:/etc/aliases

# my origin a de tener my dominio
myorigin = /etc/mailname

# my destination añadir dominio mymail.com en mi caso
mydestination = $myhostname, mymail.com, localhost, localhost.localdomain, locall
host
relayhost =

# añado la red local en la que va a trabajar
mynetworks = 192.168.88.0/24 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
mailbox_size_limit = 0
recipient_delimiter = +

# me aseguro que trabaje en todas las interfaces y protocolos
inet_interfaces = all
inet_protocols = all

# añado maildir como lugar donde se guardaran los correos
home_mailbox = Maildir/
```

> **Nota**: La instrucción `home_mailbox = Maildir/`  cambia el lugar donde se almacenan los correos, por defecto es `/var/mail` y con maildir se almacena en el home de cada usuaro en el directorio `~/Maildir`
>
> Esta instrucción hace un poco mas eficiente el servicio.

Me aseguro que el archivo mailname este mi dominio

```bash
cat /etc/mailname 
mymail.com
```

Recargo configuración con los nuevos cambios y visualizo que esten en orden

```bash
root@debmail:~# systemctl reload postfix
root@debmail:~# postconf -n

alias_database = hash:/etc/aliases
alias_maps = hash:/etc/aliases
append_dot_mydomain = no
biff = no
compatibility_level = 2
home_mailbox = Maildir/
inet_interfaces = all
inet_protocols = all
mailbox_size_limit = 0
mydestination = $myhostname, mymail.com, localhost, localhost.localdomain, localhost
myhostname = correo.mymail.com
mynetworks = 192.168.88.0/24 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
myorigin = /etc/mailname
readme_directory = no
recipient_delimiter = +
relayhost =
smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache
smtpd_banner = $myhostname ESMTP $mail_name (Debian/GNU)
smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated defer_unauth_destination
smtpd_tls_cert_file = /etc/ssl/certs/ssl-cert-snakeoil.pem
smtpd_tls_key_file = /etc/ssl/private/ssl-cert-snakeoil.key
smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_scache
smtpd_use_tls = yes
```



#### Compruebo funcionamiento postfix

Primero compruebo que el puerto de smtp(25) este activo, y que desde otro host pueda  aceder por el mismo.

```bash
# compruebo con netstat puerto abierto
root@debmail:~# netstat -nlpt4
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name             
tcp        0      0 0.0.0.0:25              0.0.0.0:*               LISTEN      10270/master        

# establezco una conexión desde otro host al server
pi@raspberrypi:~ $ nc -zv 192.168.88.13 25
Connection to 192.168.88.13 25 port [tcp/smtp] succeeded!
```

Ahora compruebo que puedo enviar mensajes y recibirlos. 

Instalo `mailutils` para poder mandar mails desde consola con `sendmail` 

```bash
sudo apt install mailutils

# mando un mail simple desde root al usuario compras
echo "Subject: Correo Maildir 1" | sendmail compras@mymail.com

# los mails se almacenan en:
ls /home/compras/Maildir/
cur  new  tmp

# compruebo la llegada del mail al usuario compras
cat /home/compras/Maildir/new/1609175551.Vfe01I20cc3M685651.debmail 
Return-Path: <root@mymail.com>
X-Original-To: compras@mymail.com
Delivered-To: compras@mymail.com
Received: by correo.mymail.com (Postfix, from userid 0)
        id 5B0B020CC1; Mon, 28 Dec 2020 12:12:31 -0500 (EST)
Subject: Correo Maildir 1
Message-Id: <20201228171231.5B0B020CC1@correo.mymail.com>
Date: Mon, 28 Dec 2020 12:12:31 -0500 (EST)
From: root <root@mymail.com>
```

En este punto podemos mandar mails desde terminal.



### Instalación Dovecot

Instalamos Dovecot para que haga de MUA y acceder desde un cliente tipo thunderbird, etc...

```bash
apt install dovecot-core dovecot-imapd dovecot-pop3d
```

En la configuración de autentificación, estamos configurando un server básico e inseguro solo para pruebas, así que habilitamos el texto plano en la autenticación.

```bash
vim /etc/dovecot/conf.d/10-auth.conf           

# habilitamos el texto plano ( es muy inseguro !!!)
disable_plaintext_auth = no

# Este formato recoge el usuario de user@dominio.com
auth_username_format = %Ln
```

Indicamos donde guardar la correspondencia, ya que por defecto utiliza mbox.

```bash
vim /etc/dovecot/conf.d/10-mail.conf     

# directorio donde guardar la correspondencia
mail_location = maildir:~/Maildir
#   mail_location = mbox:~/mail:INBOX=/var/mail/%u
#   mail_location = mbox:/var/mail/%d/%1n/%n:INDEX=/var/indexes/%d/%1n/%n
#mail_location = mbox:~/mail:INBOX=/var/mail/%u

# dar acceso al grupo mail, para las cuentas recien creadas.
mail_access_groups = mail
```

Para que clientesvcomo outlook o thunderbird funcionen bien con pop3 necesita descomentar el formato indicado

```bash
vim /etc/dovecot/conf.d/20-pop3.conf
pop3_uidl_format = %08Xu%08Xv
```

Reiniciar servicio

```bash
systemctl reload dovecot
```



### Comprobar funcionamiento

Para comprobar el servicio se tiene que instalar thunderbird y acceder al correo desde el cliente de momento no hay certificados  y la conexión es muy insegura pero el funcionamiento se puede probar.



## Configuración cifrada SASL + TLS

La configuración **SASL** + **TLS** (Simple  Authentication Security Layer with Transport Layer Security), se utiliza principalmente para autenticar a los usuarios, antes de que envíen  correo a un servidor externo. SASL maneja la autenticación y TLS se encarga de cifrar el contnido del mensaje.

### generar llaves

Si tubieramos un dominio público se podria generar unos certificados con LetsEncrypt o similar, pero al ser un entorno de pruebas nos gisamos nuestros propios certificados.

```bash
openssl genrsa -des3 -out mymail.key 2048

openssl req -new -key mymail.key -out mymail.csr
Enter pass phrase for mymail.key:
Organizational Unit Name (eg, section) []:mymail
Common Name (e.g. server FQDN or YOUR name) []:*.mymail.com
Email Address []:webadmin@mymail.com

openssl x509 -req -days 365 -in mymail.csr -signkey mymail.key -out mymail.crt

openssl rsa -in mymail.key -out mymail.key,nopass
mv mymail.key,nopass mymail.key

openssl req  -new -x509 -extensions v3_ca -keyout cakey.pem -out cacert.pem -days 365

# una vez creados los movemos al directorio de ssl
mv mymail.key /etc/ssl/private/
mv cakey.pem /etc/ssl/private/
mv mymail.crt /etc/ssl/certs/
mv cacrt.pem /etc/ssl/certs/
```



### Conf postfix 

Respecto a la configuración de postfix anterior añadimos nuevos parametros para activar el sasl y el tls.

```bash
# usar certificados propios ---------------------
sudo postconf -e 'smtpd_tls_key_file = /etc/ssl/private/mymail.key'
sudo postconf -e 'smtpd_tls_cert_file = /etc/ssl/certs/mymail.crt'
sudo postconf -e 'smtpd_tls_CAfile = /etc/ssl/certs/cacrt.pem'

# opciones de autenticación sasl -------------------

sudo postconf -e 'smtpd_sasl_auth_enable = yes'
# comunicacion con dovecot
sudo postconf -e 'smtpd_sasl_type = dovecot'
sudo postconf -e 'smtpd_sasl_path = private/auth'
# no añadir dominio en la autenticacion del user
sudo postconf -e 'smtpd_sasl_local_domain ='
# no permitir usuarios desconocidos ni contraseñas en texto plano
sudo postconf -e 'smtpd_sasl_security_options = noplaintext,noanonymous'
sudo postconf -e 'smtpd_sasl_tls_security_options = $smtpd_sasl_security_options'
# añade un separador especifico para los clientes Outlook
sudo postconf -e 'broken_sasl_auth_clients = yes'


sudo postconf -e 'smtpd_recipient_restrictions = permit_sasl_authenticated,permit_mynetworks,reject_unauth_destination'

# configuración tls ------------------------
sudo postconf -e 'smtpd_use_tls = yes'
sudo postconf -e 'smtp_use_tls = yes'
# solo admitir comunicación por tls
sudo postconf -e 'smtpd_tls_auth_only = no'
# nivel de log 
sudo postconf -e 'smtpd_tls_loglevel = 1'
# incluir informacion de protocolo y nombre comun del cliente en el encabezado
sudo postconf -e 'smtpd_tls_received_header = yes'
# por defecto la cache es de 300s aumentar a 1h
sudo postconf -e 'smtpd_tls_session_cache_timeout = 3600s'
```

Ademas hay que modificar manualmente el archivo master.cf

#### Main.cf

Ejemplo de archivo main.cf

```bash
cat /etc/postfix/main.cf

#myorigin = /etc/mailname
smtpd_banner = $myhostname ESMTP $mail_name (Debian/GNU)
biff = no
# appending .domain is the MUA's job.
append_dot_mydomain = no

# Uncomment the next line to generate "delayed mail" warnings
#delay_warning_time = 4h

readme_directory = no

# See http://www.postfix.org/COMPATIBILITY_README.html -- default to 2 on
# fresh installs.
compatibility_level = 2

# TLS parameters
smtpd_tls_auth_only = no
smtpd_use_tls = yes
smtp_use_tls = yes
smtp_tls_note_starttls_offer = yes
smtpd_tls_key_file = /etc/ssl/private/mymail.key
smtpd_tls_cert_file = /etc/ssl/certs/mymail.crt
smtpd_tls_CAfile = /etc/ssl/certs/cacrt.pem
smtpd_tls_loglevel = 1

smtpd_tls_received_header = yes
smtpd_tls_session_cache_timeout = 3600s
smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_scache
smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache

# See /usr/share/doc/postfix/TLS_README.gz in the postfix-doc package for
# information on enabling SSL in the smtp client.

smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated defer_unauth_destination
myhostname = correo.mymail.com
alias_maps = hash:/etc/aliases
alias_database = hash:/etc/aliases
myorigin = /etc/mailname
mydestination = $myhostname, mymail.com, localhost, localhost.localdomain, localhost
relayhost = 
mynetworks = 192.168.88.0/24 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
mailbox_size_limit = 0
recipient_delimiter = +
inet_interfaces = all
inet_protocols = all

home_mailbox = Maildir/
mailbox_command =

# SASL parameters

smtpd_sasl_type = dovecot
smtpd_sasl_path = private/auth
smtpd_sasl_auth_enable = yes
smtpd_sasl_tls_security_options = $smtpd_sasl_security_options
smtpd_sasl_security_options = noanonymous
smtpd_recipient_restrictions =
        permit_mynetworks
        permit_sasl_authenticated
        reject_unauth_destination


```

#### Master.cf

```bash
master.cf

submission inet n       -       y       -       -       smtpd
  -o smtpd_tls_security_level=encrypt
  -o smtpd_sasl_auth_enable=yes
  -o smtpd_sasl_type=dovecot
  -o smtpd_sasl_path=private/auth
  -o smtpd_sasl_security_options=noanonymous
  -o smtpd_sasl_local_domain=mymail.com
#  -o smtpd_client_restrictions=permit_sasl_authenticated,reject
#  -o smtpd_sender_login_maps=hash:/etc/postfix/virtual
#  -o smtpd_sender_restrictions=reject_sender_login_mismatch
#  -o smtpd_recipient_restrictions=reject_non_fqdn_recipient,reject_unknown_recipient_domain,permit_sasl_authenticated,reject

smtps     inet  n       -       y       -       -       smtpd
  -o syslog_name=postfix/smtps
  -o smtpd_tls_wrappermode=yes
  -o smtpd_sasl_auth_enable=yes
```



### Conf dovecot 

Sección modificada de archivos de configuración dovecot.

#### dovecot.conf

```bash
...
# A comma separated list of IPs or hosts where to listen in for connections. 
# "*" listens in all IPv4 interfaces, "::" listens in all IPv6 interfaces.
# If you want to specify non-default ports or anything more complex,
# edit conf.d/master.conf.
listen = *, ::

# extender logs para depurar errores ( opcional )
auth_verbose = yes
mail_debug = yes
...
```

#### 10-auth.conf

```bash
# desabilitar autentificación en texto plano
disable_plaintext_auth = yes

# %n eliminar dominio en la autenticación, %Lu minimizar las mayusculas
auth_username_format = %Lu %n

# Space separated list of wanted authentication mechanisms:
#   plain login digest-md5 cram-md5 ntlm rpa apop anonymous gssapi otp skey
#   gss-spnego
# NOTE: See also disable_plaintext_auth setting.
auth_mechanisms = plain login
```

#### 10-mail.conf

```bash
# utilizar Maildir como buzon
mail_location = maildir:~/Maildir
#mail_location = mbox:~/mail:INBOX=/var/mail/%u


mail_privileged_group = mail
```

#### 10-master.conf

```bash
...
service imap-login {
  inet_listener imap {
    port = 143
  }
   ...
 }
 ...
 service pop3-login {
  inet_listener pop3 {
    port = 110
  }
  ...
}
...
  # Postfix smtp-auth
  unix_listener /var/spool/postfix/private/auth {
    mode = 0660
    user = postfix
    group = postfix
  }
...
```



#### 10-ssl.conf

```bash
# SSL/TLS support: yes, no, required. <doc/wiki/SSL.txt>
ssl = yes

# PEM encoded X.509 SSL/TLS certificate and private key. They're opened before
# dropping root privileges, so keep the key file unreadable by anyone but
# root. Included doc/mkcert.sh can be used to easily generate self-signed
# certificate, just make sure to update the domains in dovecot-openssl.cnf
ssl_cert = </etc/ssl/certs/mymail.crt
ssl_key = </etc/ssl/private/mymail.key
```

#### 20-pop3.conf

Esta opcion solo en caso de querer utilizar pop3

```bash
# Note that Outlook 2003 seems to have problems with %v.%u format which was
# Dovecot's default, so if you're building a new server it would be a good
# idea to change this. %08Xu%08Xv should be pretty fail-safe.
pop3_uidl_format = %08Xu%08Xv
```



### Opcional seguridad

 Requerir un comando HELO o EHLO válido con un nombre de dominio completamente calificado puede hacer precisamente eso

```bash
sudo postconf -e 'smtpd_helo_required = yes'
sudo postconf -e 'smtpd_helo_restrictions = reject_non_fqdn_helo_hostname,reject_invalid_helo_hostname,reject_unknown_helo_hostname'


# desabiliar veryfy para evitar exponer conf de usuario sensible
sudo postconf -e 'disable_vrfy_command = yes'
```

 

También es posible que desee retrasar el mensaje de rechazo para permitir que  Postfix registre la información de la dirección del destinatario cuando  el cliente conectado infringe alguna de las reglas de rechazo. Esto le  permite averiguar más tarde a quién intentaban apuntar los spammers.

```bash
sudo postconf -e 'smtpd_delay_reject = yes'
```

 

Las restricciones de destinatario de Postfix que se establecieron en la  parte de configuración de SASL son importantes para proteger el servidor al tiempo que permiten a los usuarios conectarse con clientes de correo electrónico como Thunderbird o Outlook. Mantener estos parámetros en el orden correcto conservará esta capacidad, pero puede incluir  restricciones adicionales que los mensajes entrantes deberán cumplir.

```bash
sudo postconf -e 'smtpd_recipient_restrictions = permit_sasl_authenticated,permit_mynetworks,reject_unauth_destination,reject_invalid_hostname,reject_non_fqdn_hostname,reject_non_fqdn_sender,reject_non_fqdn_recipient,reject_unknown_sender_domain,reject_rbl_client sbl.spamhaus.org,reject_rbl_client cbl.abuseat.org'
```

 

Los parámetros anteriores se explican por sí mismos, aunque un poco  difíciles de leer en un formato de terminal fácil de copiar y pegar. La  idea general es rechazar las conexiones de direcciones inventadas que no usan un nombre de dominio completo o simplemente no existen. Aquí  también es posible agregar filtros de spam externos como las listas  negras de Spamhaus o CBL. Si desea obtener más información, Postfix  tiene una documentación muy extensa sobre sus opciones de configuración.

http://www.postfix.org/postconf.5.html#smtpd_recipient_restrictions



### Comprobar funcionamiento



```bash
root@debmail:~# openssl s_client -connect correo.mymail.com:993
CONNECTED(00000003)
....

Por aqui en medio sale string sobre el certificado

....
* OK [CAPABILITY IMAP4rev1 SASL-IR LOGIN-REFERRALS ID ENABLE IDLE LITERAL+ AUTH=PLAIN AUTH=LOGIN] Dovecot (Debian) ready.
. login ventas@mymail.com ventas
. OK [CAPABILITY IMAP4rev1 SASL-IR LOGIN-REFERRALS ID ENABLE IDLE SORT SORT=DISPLAY THREAD=REFERENCES THREAD=REFS THREAD=ORDEREDSUBJECT MULTIAPPEND URL-PARTIAL CATENATE UNSELECT CHILDREN NAMESPACE UIDPLUS LIST-EXTENDED I18NLEVEL=1 CONDSTORE QRESYNC ESEARCH ESORT SEARCHRES WITHIN CONTEXT=SEARCH LIST-STATUS BINARY MOVE SNIPPET=FUZZY LITERAL+ NOTIFY SPECIAL-USE] Logged in
. select INBOX
* FLAGS (\Answered \Flagged \Deleted \Seen \Draft)
* OK [PERMANENTFLAGS (\Answered \Flagged \Deleted \Seen \Draft \*)] Flags permitted.
* 1 EXISTS
* 0 RECENT
* OK [UIDVALIDITY 1609316456] UIDs valid
* OK [UIDNEXT 5] Predicted next UID
. OK [READ-WRITE] Select completed (0.033 + 0.000 + 0.037 secs).
. logout
* BYE Logging out
. OK Logout completed (0.005 + 0.000 + 0.005 secs).
closed

```



