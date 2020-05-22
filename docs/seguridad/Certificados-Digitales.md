# Certificados Digitales

## TLS/SSL (HTTPS)

### Generació de claus, requests i certs

#### Certificado autofirmado

```bash
openssl req -new -x509 -days 3650 -nodes -keyout serverkey.auto1.pem -out servercert.auto1.pem
```

#### Creación de clave privada y certificado autofirmado

```bash
openssl genrsa -out serverkey.auto2.pem

openssl req -new -x509 -days 3650 -nodes -key serverkey.auto2.pem -out servercert.auto2.pem
```

#### Creación de clave privada, request i certificación

```bash
openssl genrsa -out serverkey.web1.pem
openssl req -new -key serverkey.web1.pem -out serverreq.web1.pem
openssl x509 -CAkey cakey.pem -CA cacert.pem -req -in serverreq.web1.pem -days 3650 -CAcreateserial -out servercert.web1.pem
```

#### Creación de clave provada

Petición de certificación y firma de la certificación usando fitchero de configuración

Fitxer exemple de configuració parcial de openssl:

```bash
#ca.conf
basicConstraints = critical,CA:FALSE 
extendedKeyUsage = serverAuth,emailProtection 
```

```bash
openssl genrsa -out serverkey.web2.pem
openssl req -new -key serverkey.web2.pem -out serverreq.web2.pem
openssl x509 -CAkey cakey.pem -CA cacert.pem -req -in serverreq.web2.pem -days 3650 -CAcreateserial -extfile ca.conf -out servercert.web2.pem
```



#### Request sin interactivo

```bash
# Generar el certificat + clau privada autosignats
openssl req -x509 -nodes -days 365 -sha256 \
-subj '/C=ca/ST=Barcelona/L=Barcelona/CN=www.edt.org' \
-newkey rsa:2048 -keyout mykey.pem -out mycert.pem

➜  openssl req -new -x509 -nodes -out mycrt.pem -keyout mykey.pem
Generating a RSA private key
....................................+++++
.........+++++
writing new private key to 'mykey.pem'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:ca
State or Province Name (full name) [Some-State]:barcelona
Locality Name (eg, city) []:Barcelona
Organization Name (eg, company) [Internet Widgits Pty Ltd]:escola del treball        
Organizational Unit Name (eg, section) []:departament informatica
Common Name (e.g. server FQDN or YOUR name) []:www.edt.org
Email Address []:admin@edt.org
```



#### Crear una CA propia

```bash
# generar clave privada encriptada con des3 i passfrase (formato PEM)
➜  openssl genrsa -des3 -out ca.key 2048

# generar el certificat x509 pròpi de l'entitat CA (per a 365 dies) en format PEM
➜  openssl req -new -x509 -nodes -sha1 -days 365 -key ca.key -out ca.crt
Enter pass phrase for ca.key:
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:ca
State or Province Name (full name) [Some-State]:Barcelona
Locality Name (eg, city) []:Barcelona
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Veritat absoluta
Organizational Unit Name (eg, section) []:Departament de certificats
Common Name (e.g. server FQDN or YOUR name) []:VeritatAbsoluta
Email Address []:admin@edt.org

➜ ll
-rw-r--r-- 1 debian debian 1,5K mar 30 11:24 ca.crt
-rw------- 1 debian debian 1,8K mar 30 11:17 ca.key
```



#### Contenido físico y lógico

```bash
# contenido fisico
➜ cat ca.key 
-----BEGIN RSA PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: DES-EDE3-CBC,7EB452B3EA57B216
gtG861azfOG/vZblyVumXLzx9SvFAT3shENQQxNqjW+PMUO9+aB15oNwASSgj1X2
SGRTEZtViAZdo1B5K8N3nhArTWULsIpHP5EiiS1qDYaFQcU38+Akzw==
-----END RSA PRIVATE KEY-----

# contenido logico
➜ openssl rsa -noout -text -in ca.key
Enter pass phrase for ca.key:
RSA Private-Key: (2048 bit, 2 primes)
modulus:
    00:c8:72:8a:93:51:19:0a:58:d6:45:8f:2e:1b:24:
    cd:e9:0d:5a:91:69:2f:e9:49:fb:56:78:68:9e:94:
...

# ca.crt
➜ openssl x509 -noout -text -in ca.crt 
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            56:b0:8d:ea:f1:e0:ea:b6:ca:ca:36:b1:56:35:54:9b:32:e1:87:11
        Signature Algorithm: sha1WithRSAEncryption
        Issuer: C = ca, ST = Barcelona, L = Barcelona, O = Veritat absoluta, OU = Departament de certificats, CN = VeritatAbsoluta, emailAddress = admin@edt.org
        Validity
            Not Before: Mar 30 09:24:14 2020 GMT
            Not After : Mar 30 09:24:14 2021 GMT
```



### crear certificado servidor real

```bash
# Crear una clau privada per al servidor
# és en format PEM, de 2048 bits i xifrada en 3DES. Utilitza passfrase
➜ openssl genrsa -des3 -out server.key 2048

# Generar una petició de certificat request per enviar a l'entitat certificadora CA
➜ openssl req -new -key server.key -out server.csr
Enter pass phrase for server.key:
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:ca
State or Province Name (full name) [Some-State]:Barcelona
Locality Name (eg, city) []:Barcelona
Organization Name (eg, company) [Internet Widgits Pty Ltd]:escola del treball
Organizational Unit Name (eg, section) []:dep informatica
Common Name (e.g. server FQDN or YOUR name) []:www.edt.org
Email Address []:admin@edt.org

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:request password
An optional company name []:edt

➜ ll
-rw-r--r-- 1 debian debian 1,2K mar 30 11:48 server.csr
-rw------- 1 debian debian 1,8K mar 30 11:45 server.key
```



una entidad certificadora a de firmar  la peticion request del certificado y devolver un certificado.crt, como aremos nosotros de entidad CA lo autofirmaremos.

```bash
# Fitxer de configuració de la generació de certificats: indica què certifiquen
➜ cat ca/ca.conf 
basicConstraints = critical,CA:FALSE
extendedKeyUsage = serverAuth,emailProtection

# L'autoritat CA ha de signar el certificat
➜ openssl x509 -CA ca.crt -CAkey ca.key -req -in server.csr -days 365 -sha1 -extfile ca/ca.conf -CAcreateserial -out server.crt
Signature ok
subject=C = ca, ST = Barcelona, L = Barcelona, O = escola del treball, OU = dep informatica, CN = www.edt.org, emailAddress = admin@edt.org
Getting CA Private Key
Enter pass phrase for ca.key:

# Mostrar el no de sèrie que genera la CA per a cada certificat que emet.
➜ cat ca.srl
777493C4F77FDEF98879C20B0EBE80A94E2B048E

# la entidad le enviara al cliente el archivo server.crt

# El client que ha sol·licitat el certificat pot validar el certificat respecte la seva clau privada
➜ openssl x509 -noout -modulus -in server.crt| openssl md5
(stdin)= 1e560851e07dd9c2774474a44c16abd2
➜ openssl rsa -noout -modulus -in server.key| openssl md5
Enter pass phrase for server.key:
(stdin)= 1e560851e07dd9c2774474a44c16abd2
```



### passfrase

Añadir una passfrase a una clave privada suma seguridad, ya que sin esa passfrase nadie podrá utilizar la clave privada.

**inconvenientes**: es que al arrancar el servicio apache pide la passfrase necesaria por cada certificado que tenga una.

**Ventajas**: si no roban la llave privada, si no tienen la pasfrase no podrán utilizarla.

Al hacer modificaciones en una key se genera otra nueva, después de modificar es recomendable remplazar con un `mv`.

#### Añadir

```bash
➜ openssl rsa -des3 -in server.key -out passfrase.server.key
writing RSA key
Enter PEM pass phrase:
Verifying - Enter PEM pass phrase:
➜ mv passfrase.server.key server.key 
```



#### Modificar

```bash
➜ openssl rsa -des3 -in server.key -out passfrase.new.server.key
Enter pass phrase for server.key:
writing RSA key
Enter PEM pass phrase:
Verifying - Enter PEM pass phrase:
➜ mv passfrase.new.server.key server.key 
```



#### Eliminar

```bash
➜ openssl rsa -in server.key -out delete-passfrase.server.key
Enter pass phrase for server.key:
writing RSA key
```



### Examinar contenido de certificados y llaves

```bash
# contenido certificado
➜ openssl x509 -noout -text -in autosigned.server.crt  

# contenido clave privada
➜ openssl rsa -noout -text -in autosigned.server.key 

# verificar que el certificado y la llave privada se corresponden.
➜ openssl x509 -noout -modulus -in autosigned.server.crt | openssl md5 
(stdin)= 749c4e62abb2fcc4f16325f5ccbe5d24
➜ openssl rsa -noout -modulus -in autosigned.server.key | openssl md5
(stdin)= 749c4e62abb2fcc4f16325f5ccbe5d24
```



## No se que

```bash
[root@hp01 m11]# openssl s_client -connect 172.17.0.2:443
---
GET / HTTP/1.1
Host: www.m11.cat

---
GET / HTTP/1.1
Host: www.admin.cat

[root@hp01 m11]# curl -v -ssl https://www.m11.cat

[root@https /]# openssl s_client -connect pop.gmail.com:995
USER edtasixm14
+OK send PASS
PASS xxxxx
+OK Welcome.
STAT
+OK 8 87440
LIST
+OK 8 messages (87440 bytes)
1 6928
2 7758
3 4844
4 5364
5 5071
6 35142
7 12120
8 10213
.
QUIT
DONE

# conectar con sclient a un virtual host
openssl s_client -servername www.web1.org -connect 172.17.0.2:443
openssl s_client -CAfile cacert.pem -servername www.web1.org -connect
172.17.0.2:443

# verificar
➜  tls19:https openssl verify -CAfile cacert.pem servercert.web1.pem                                      
# descargar certificado remoto
➜  tls19:https openssl s_client -servername www.web1.org -connect 172.17.0.2:443  < /dev/null 2> /dev/null | openssl x509 -outform PEM > downloaded.cert.pem
➜  tls19:https openssl x509 -noout -text -in downloaded.cert.pem

```





## Ldap tls

Ldap con conexiones seguras TLS/SSL  y startTLS.

### Generar certificados

```bash
# genrar llaves privadas, del servidor.
openssl genrsa -out cakey.pem 2048
openssl genrsa -out serverkey.pem 2048

# genrar certificado propio de la entidad CA por 365 dias
openssl req -new -x509 -nodes -sha1 -days 365 -key cakey.pem -out cacrt.pem
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:ca
State or Province Name (full name) [Some-State]:Barcelona
Locality Name (eg, city) []:Barcelona
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Varitat Absoluta
Organizational Unit Name (eg, section) []:Dep de certificats
Common Name (e.g. server FQDN or YOUR name) []:VeritatAbsoluta
Email Address []:admin@edt.org

# generar una de  certificado request para enviar a la entidad certificadora CA
openssl req -new -key serverkey.pem -out servercsr.pem 

You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:ca
State or Province Name (full name) [Some-State]:Barcelona
Locality Name (eg, city) []:Barcelona
Organization Name (eg, company) [Internet Widgits Pty Ltd]:escola de mi casa 
Organizational Unit Name (eg, section) []:dep informatica
Common Name (e.g. server FQDN or YOUR name) []:ldap.edt.org
Email Address []:admin@edt.org

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:request password
An optional company name []:edt

# Una entidad CA a de firmar el servercsr.pem y devolvernos un certificado.crt, como hago yo mismo de entidad
cat ca.conf 
basicConstraints = critical,CA:FALSE
extendedKeyUsage = serverAuth,emailProtection

# Autoridad CA firmando el certificado 
openssl x509 -CA cacrt.pem -CAkey cakey.pem -req -in servercsr.pem -days 365 -sha1 -extfile ca.conf -CAcreateserial -out servercrt.pem 

Signature ok
subject=C = ca, ST = Barcelona, L = Barcelona, O = escola de mi casa, OU = dep informatica, CN = ldap.edt.org, emailAddress = admin@edt.org
Getting CA Private Key

# archivos finales
➜  ll
total 60K
-rw-r--r-- 1 debian debian   83 abr  1 10:14 ca.conf
-rw-r--r-- 1 debian debian 1,5K abr  1 10:23 cacrt.pem
-rw-r--r-- 1 debian debian   41 abr  1 10:35 cacrt.srl
-rw------- 1 debian debian 1,7K abr  1 10:14 cakey.pem
-rw-r--r-- 1 debian debian 1,5K abr  1 10:35 servercrt.pem
-rw-r--r-- 1 debian debian 1,2K abr  1 10:32 servercsr.pem
-rw------- 1 debian debian 1,7K abr  1 10:14 serverkey.pem
```





### Configuración

```bash
slapd.conf
---
TLSCACertificateFile    /etc/openldap/certs/cacrt.pem
TLSCertificateFile      /etc/openldap/certs/servercrt.pem
TLSCertificateKeyFile   /etc/openldap/certs/serverkey.pem
TLSVerifyClient         never
TLSCipherSuite          HIGH:MEDIUM:LOW:+SSLv2
---

ldap.conf
---
TLS_CACERT /etc/openldap/certs/cacrt.pem
SASL_NOCANON	on
URI ldap://ldap.edt.org
BASE dc=edt,dc=org
---

startup.sh
---
/sbin/slapd -d0 -h "ldap:/// ldaps:/// ldapi:///" 
---
```

cliente `ldap.conf`

```bash
TLS_CACERT /etc/ldap/cacrt.pem
TLS_REQCERT allow

URI ldap://ldap.edt.org
BASE dc=edt,dc=org

SASL_NOCANON on
```



### Comprobaciones

```bash
ldapsearch -x -LLL -ZZ dn
ldapsearch -x -LLL -ZZ -h ldap.edt.org -b 'dc=edt,dc=org' dn
ldapsearch -x -LLL -H ldaps://ldap.edt.org dn
openssl s_client -connect ldap.edt.org:636
```



### Docker

```bash
➜ docker run --rm --name ldap.edt.org -h ldap.edt.org -p 389:389  -p 636:636 -d jorgepastorr/ldapserver19:tls 
```



## OpenVpn

### Generar llaves servidor

Primero creamos nuestra CA

```bash
➜  openssl genrsa -des3 -out cakey.pem 2048
➜  openssl req -new -x509 -nodes -sha1 -days 365 -key cakey.pem -out cacert.pem
Enter pass phrase for cakey.pem:
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:ca
State or Province Name (full name) [Some-State]:Barcelona
Locality Name (eg, city) []:Barcelona
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Veritat absoluta
Organizational Unit Name (eg, section) []:Departament de certificats
Common Name (e.g. server FQDN or YOUR name) []:VeritatAbsoluta
Email Address []:admin@edt.org

➜ ll
-rw-r--r-- 1 debian debian 1,5K mar 30 11:24 cacert.pem
-rw------- 1 debian debian 1,8K mar 30 11:17 cakey.pem
```



generar la llave del servidor y el request para enviar a la CA para que nos certifique.

```bash
➜ openssl dhparam -out dh2048.pem 2048

# llave del server
➜ openssl genrsa  -out serverkey.pem 2048                                 
Generating RSA private key, 2048 bit long modulus (2 primes)
.........................................+++++
................................................................+++++
e is 65537 (0x010001)

# request para la CA
➜ openssl req -new -key serverkey.pem -out serverreq.pem
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:ca
State or Province Name (full name) [Some-State]:barcelona
Locality Name (eg, city) []:barcelona
Organization Name (eg, company) [Internet Widgits Pty Ltd]:server vvpn
Organizational Unit Name (eg, section) []:VpnServer
Common Name (e.g. server FQDN or YOUR name) []:VpnServer
Email Address []:

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:request password
An optional company name []:edt
```



Como no tenemos CA externa, simulamos una y nos auto certificamos.

fichero de extensiones para servidor:

*ext.server.conf*

```bash
basicConstraints       = CA:FALSE
nsCertType             = server
nsComment              = "OpenSSL Generated Server Certificate"
subjectKeyIdentifier   = hash
authorityKeyIdentifier = keyid,issuer:always
extendedKeyUsage       = serverAuth
keyUsage               = digitalSignature, keyEncipherment
```

Generar certificado ( esto lo debería hacer una certificadora externa a nosotros )

```bash
➜ openssl x509 -CAkey cakey.pem -CA cacert.pem -req -in serverreq.pem -days 365 -CAcreateserial -extfile ext.server.conf -out servercert.pem 
Signature ok
subject=C = ca, ST = barcelona, L = barcelona, O = server vvpn, OU = VpnServer, CN = VpnServer
Getting CA Private Key
```



Archivos generados:

```bash
➜  tls19:vpn ll
total 64K
-rw-r--r-- 1 debian debian 1,4K abr  3 19:29 cacert.pem
-rw-r--r-- 1 debian debian   41 abr  3 19:40 cacert.srl
-rw------- 1 debian debian 1,7K abr  3 19:27 cakey.pem
-rw-r--r-- 1 debian debian  424 abr  4 11:39 dh2048.pem
-rw-r--r-- 1 debian debian  301 abr  3 19:12 ext.server.conf
-rw-r--r-- 1 debian debian 1,8K abr  3 19:37 servercert.pem
-rw------- 1 debian debian 1,7K abr  3 19:30 serverkey.pem
-rw-r--r-- 1 debian debian 1,1K abr  3 19:32 serverreq.pem
```



### Generar llaves cliente

Lo recomendable es que cada cliente tenga una llave propia para conectar con el servidor, por lo tanto estos pasos se deben repetir por cada cliente que quiera conectar con el servidor.



generar llave de cliente y request para certificar.

```bash
➜ openssl genrsa  -out cliekey1.pem 2048                                                                                          
Generating RSA private key, 2048 bit long modulus (2 primes)
........................................................................+++++
....................................................+++++
e is 65537 (0x010001)

# generar request ( quien soy )
➜ openssl req -new -key cliekey1.pem -out cliereq1.pem                                                                              
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:ca
State or Province Name (full name) [Some-State]:barcelona
Locality Name (eg, city) []:barcelona
Organization Name (eg, company) [Internet Widgits Pty Ltd]:cliente 1 server vpn
Organizational Unit Name (eg, section) []:cliente1
Common Name (e.g. server FQDN or YOUR name) []:cliente1
Email Address []:

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:request password
An optional company name []:edt
```



Generar certificado desde una CA, una CA verifica que eres quien dices ser.

fichero de extensiones para cliente

```bash
basicConstraints        = CA:FALSE
subjectKeyIdentifier    = hash
authorityKeyIdentifier  = keyid,issuer:always
```



```bash
➜ openssl x509 -CAkey cakey.pem -CA cacert.pem -req -in cliereq1.pem -days 365 -CAcreateserial -extfile ext.client.conf -out cliecert1.pem  
Signature ok
subject=C = ca, ST = barcelona, L = barcelona, O = cliente 1 server vpn, OU = cliente1, CN = cliente1
Getting CA Private Key
```

Archivos generados para cliente:

```bash
➜ ll
-rw-r--r-- 1 debian debian 1,4K abr  3 19:29 cacert.pem
-rw-r--r-- 1 debian debian 1,6K abr  3 19:40 cliecert1.pem
-rw------- 1 debian debian 1,7K abr  3 19:38 cliekey1.pem
-rw-r--r-- 1 debian debian 3,6K abr  3 19:15 client.conf
-rw-r--r-- 1 debian debian 1,1K abr  3 19:40 cliereq1.pem
-rw-r--r-- 1 debian debian  113 abr  3 19:13 ext.client.conf
```





### Túnel manual

Una manera  de verificar que los certificados funcionan correctamente es creando un túnel manualmente, si funcionan correctamente pasamos va configurar el servidor.

```bash
pc02 ➜  sudo openvpn --remote pc03 --dev tun1 --ifconfig 10.4.0.1 10.4.0.2 --tls-server --dh dh2048.pem --ca cacert.pem --cert servercert.pem --key serverkey.pem --reneg-sec 60

[jorge@pc03 certs]$ sudo openvpn --remote pc02 --dev tun1 --ifconfig 10.4.0.2 10.4.0.1 --tls-client --ca cacert.pem --cert cliecert1.pem --key cliekey1.pem --reneg-sec 60
```



### Configurar



#### Servidor

Primero de todo hacemos una copia del servicio y lo modificamos para tener una configuración como se ve en el siguiente recuadro

```bash
[fedora@aws ~]$ sudo cp /lib/systemd/system/openvpn-server@.service /etc/systemd/system/.

[fedora@aws ~]$ cat /etc/systemd/system/openvpn-server\@.service 
[Unit]
Description=OpenVPN service for %I hisx
After=syslog.target network-online.target

[Service]
Type=forking
PrivateTmp=true
ExecStartPre=/usr/bin/echo serveri %i %I
PIDFile=/var/run/openvpn-server/%i.pid
ExecStart=/usr/sbin/openvpn --daemon --writepid /var/run/openvpn-server/%i.pid --cd /etc/openvpn/ --config %i.conf

[Install]
WantedBy=multi-user.target
```



Cogemos el archivo de configuración de muestra y lo modificamos de la siguiente manera.

```bash
[fedora@aws ~]$ cp /usr/share/doc/openvpn/sample/sample-config-files/server.conf .
[fedora@aws ~]$ sudo cp server.conf /etc/openvpn/confserver.conf
[fedora@aws ~]$ cat /etc/openvpn/confserver.conf 

port 1194
proto udp
dev tun 	# interfaz de vpn

# nuestras llaves para el server
ca /etc/openvpn/keys/cacert.pem
cert /etc/openvpn/keys/servercert.pem
key /etc/openvpn/keys/serverkey.pem 
dh /etc/openvpn/keys/dh2048.pem

server 10.8.0.0 255.255.255.0	# red del vpn
ifconfig-pool-persist ipp.txt
client-to-client # clientes se ven entre ellos
;duplicate-cn  #  no permitir diferentes conexxiones con la misma llave

keepalive 10 120
cipher AES-256-CBC
comp-lzo	# compresion

persist-key
persist-tun

# datos de logs
status openvpn-status.log
verb 3
explicit-exit-notify 1
```



Los archivos de configuración quedan con la siguiente estructura.

```bash
[fedora@ip-172-31-92-8 ~]$ sudo tree /etc/openvpn/
/etc/openvpn/
├── client
├── confserver.conf
├── ipp.txt
├── keys
│   ├── cacert.pem
│   ├── dh2048.pem
│   ├── servercert.pem
│   └── serverkey.pem
├── openvpn-status.log
└── server
```



Poner en marcha el servidor.

Al poner en marcha el servidor Hay que tener en cuenta que hemos modificado un dominio manualmente, por eso se han de recargar. Otra cosa a tener en cuenta es que en el start, hay que indicar el nombre del archivo de configuración `openvpn-server@confserver`

```bash
# recargar los dominios
[fedora@aws ~]$ sudo systemctl daemon-reload 

# encender el servidor
[fedora@aws ~]$ sudo systemctl start openvpn-server@confserver.service

# comprovar interfaz creada
[fedora@aws ]$ ip a s tun0
8: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 100
    link/none 
    inet 10.8.0.1 peer 10.8.0.2/32 scope global tun0
       valid_lft forever preferred_lft forever
    inet6 fe80::b502:a827:5610:7c23/64 scope link stable-privacy 
       valid_lft forever preferred_lft forever
```



#### Cliente

En la configuración del cliente es mas simple, ya que solo se a de modificar el archivo de configuración, agregar las llaves del cliente en su sitio y arrancar el servicio. Todos estos pasos se han de hacer por cada cliente con sus claves propias.

Archivo de configuración:

```bash
[jorge@pc03]$ sudo cat client/confclient.conf
client
dev tun
proto udp

remote aws 1194 # ip/host port del servidor remoto
resolv-retry infinite
nobind
persist-key
persist-tun

# certificados
ca /etc/openvpn/keys/cacert.pem
cert  /etc/openvpn/keys/cliecert1.pem
key  /etc/openvpn/keys/cliekey1.pem

remote-cert-tls server
cipher AES-256-CBC
comp-lzo
verb 3
```



Se colocan las llaves en su sitio indicado

```bash
[jorge@pc03 openvpn]$ sudo tree
.
├── client
│   └── confclient.conf
├── keys
│   ├── cacert.pem
│   ├── cliecert1.pem
│   └── cliekey1.pem
└── server
```



Como no tengo resolución dns  indico la resolución en el `/etc/hosts`

```bash
[jorge@pc03]$ cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
3.86.219.56	aws
```



Arrancar y comprobar.

```bash
# arrancar servicio, con el nombre del archivo de configuración
[jorge@pc03]$ sudo systemctl start openvpn-client@confclient

# verificar que se a creado la interfaz
[jorge@pc03]$ ip a s tun0
9: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 100
    link/none 
    inet 10.8.0.6 peer 10.8.0.5/32 scope global tun0
       valid_lft forever preferred_lft forever
    inet6 fe80::7b5f:a77b:2a32:be1e/64 scope link stable-privacy 
       valid_lft forever preferred_lft forever

# comprovar que llego al otro extremo
[jorge@pc03]$ curl 10.8.0.1:13
04 APR 2020 11:26:59 UTC
```



## Extensiones



### fichero especifico de extensión

Generar un certificado de servidor ldap que correrá en un container llamado `ldap.edt.org` pero que también acepte conexiones realizadas en nip `172.17.0.2, 127.0.0.1, ldaps://mysecureldapserver.org`.

Creo un fichero de extensiones y defino el `subjectAltName` para cada uno de los nombres alternativos.

*ext.alterare.conf*

```bash
basicConstraints=CA:FALSE
extendedKeyUsage=serverAuth
subjectAltName=IP:172.17.0.2,IP:127.0.0.1,email:copy,URI:ldaps://mysecureldapserver.org
```



```bash
➜  ldap openssl x509 -CAkey cakey.pem -CA cacrt.pem -req -in serverreq.pem -days 365 -CAcreateserial  -extfile ext.alterate.conf -out servercert.alternate.pem 
Signature ok
subject=C = ca, ST = barcelona, L = barcelona, O = edt, OU = EDT, CN = ldap.edt.org
Getting CA Private Key
```



```bash
➜  ldap openssl x509 -noout -text -in servercert.alternate.pem                                                                                                  
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            7a:e9:d4:14:65:f2:8e:66:aa:9c:0f:88:33:24:8c:cb:21:02:05:dc
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: C = ca, ST = Barcelona, L = Barcelona, O = Veritat absoluta, OU = departament certificats, CN = VeritatAbsoluta
        Validity
            Not Before: Apr  6 08:54:33 2020 GMT
            Not After : Apr  6 08:54:33 2021 GMT
        Subject: C = ca, ST = barcelona, L = barcelona, O = edt, OU = EDT, CN = ldap.edt.org
        Subject Public Key Info:
...
        X509v3 extensions:
            X509v3 Basic Constraints: 
                CA:FALSE
            X509v3 Extended Key Usage: 
                TLS Web Server Authentication
            X509v3 Subject Alternative Name: 
                IP Address:172.17.0.2, IP Address:127.0.0.1, URI:ldaps://mysecureldapserver.org
```



### fichero global

fedora: `/etc/pki/tls/openssl.cnf` , debian: `/etc/ssl/openssl.cnf` 



*openssl.cnf*

```bash
...
[ my_client ]
basicConstraints		= CA:FALSE
subjectKeyIdentifier 	= hash
authorityKeyIdentifier 	= keyid,issuer:always

[ my_server ]
basicConstraints	= CA:FALSE
nsCertType			= server
nsComment			= "OpenSSL Generated Server Certificate"
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer:always
extendedKeyUsage	= serverAuth
keyUsage			= digitalSignature, keyEncipherment
...
```

Certificar usando la extensión del fichero global

```bash
# Ca utilizando extension de archivo de configuración
➜  ldap openssl x509 -CAkey cakey.pem -CA cacrt.pem -req -in serverreq.pem -days 365 -CAcreateserial  -extfile /etc/ssl/openssl.cnf -extensions my_client -out servercert.alternate.pem

# certificado autofirmado
➜  ldap openssl req -new -x509 -key cakey.pem -config openssl.cnf -extensions usr_cert -out cert1.pem
```

