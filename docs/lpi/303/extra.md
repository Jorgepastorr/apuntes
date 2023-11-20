

## 212.3 Secure shell (SSH)

### Comunicaciones SSH

Es un protocolo (y  programa) que permite acceder a un servidor  remoto de una forma segura  cifrando la información que se intercambia con el cliente.

La función más usada es ejecutar comandos mediante terminal en una máquina remota, pero puede usarse para copiar `scp` , `sftp` y para crear túneles seguros usados por multitud de aplicaciones.

Para cifrar la comunicación utiliza claves públicas y privadas.

```bash
/etc/ssh/ssh_config     # conf cliente
/etc/ssh/sshd_config    # conf servidor
```

Se puede iniciar sesión con el usuario y la contraseña o usando las claves instaladas en el cliente y el servidor.

`~/.ssh/known_hosts`  contiene los hash de los hosts conocidos, es decir los que ya se a establecido una conexión.

#### Directivas destacadas de sshd_config

```bash
Port            # puerto a la escucha por defecto 22
PermitRootLogin # perrmitir acceso remoto a root
X11Forwarding   # permitir tunel para usar entorno gráfico
AllowTcpForwarding  # permitir tuneles

sshAllowUsers 
sshDenyUsers
sshAllowGroups
sshDenyGroups
```

#### Ficheros  de claves

Según el sistema de cifrado obtendremos un fichero u otro.

| cliente           | servidor                      |
| ----------------- | ----------------------------- |
| ~/.ssh/id_rsa     | /etc/ssh/ssh_host_rsa_key     |
| ~/.ssh/id_dsa     | /etc/ssh/ssh_host_dsa_key     |
| ~/.ssh/id_ecdsa   | /etc/ssh/ssh_host_ecdsa_key   |
| ~/.ssh/id_ed25519 | /etc/ssh/ssh_host_ed25519_key |

> las claves públicas se encuentran en los mismos directorios con extensión `.pub`, Ademas los permisos de las claves privadas sera de `600`y las públicas `644`

 

#### Generar claves

`ssh-keygen` genera un par de claves pública y privada. por defecto usa RSA.

```bash
ssh-keygen
-t  # metodo de cifrado dsa, ecdsa, ed25519, rsa
-b  # bits usados para el cifrado 2048 suficiente
-A  # generar llaves de todos los metodos de cifrado
-R  # borrar claves de un hostname
-l [-f file_key]    # ver fingerprint
...

ssh-keygen -t rsa -b 2048
ssh-keygen -f "~/.ssh/known_hosts" -R "192.168.0.25"
```

Para acceder a un servidor remoto este tiene que tener guardada la clave pública en el archivo `~/.ssh/autorized_keys`. Esto se puede hacer con el comando `ssh-copy-id user@host`  

 

#### ssh-agent

gestiona las claves privadas mientras dure la sesión. Útil cuando se trabaja con varios servidores y se quiere agilizar la repetitiva identificación en  cada uno de ellos.

Primero tenemos que ejecutar el comando para iniciarlo y después utilizar `ssh-add` para añadir todas las claves que queremos gestionar. De esta manetra si nuestras llaves tienen passfrase solo las tendremos que añadir una vez.

```bash
carol@debian:~/.ssh$ ssh-agent /bin/bash
carol@debian:~/.ssh$ ssh-add
Enter passphrase for /home/carol/.ssh/id_ecdsa:
Identity added: /home/carol/.ssh/id_ecdsa (carol@debian)

# o directamente
carol@debian:~/.ssh$ ssh-add .ssh/id_ecdsa
Enter passphrase for /home/carol/.ssh/id_ecdsa:
Identity added: /home/carol/.ssh/id_ecdsa (carol@debian)

ssh-add -l # mostrar claves guardadas
ssh-agent -k # cerrar la sesion de agent
ssh-add -D  # eliminar todas las claves
ssh-add -d .ssh/id_ecdsa # eliminar clave especifica
```

 

#### Tuneles

Es una conexión cifrada entre dos puntos que se establece con la intención de que sea utilizada para transmitir los datos de otra aplicación o  servicio de forma segura.

```bash
ssh 
-N  # no se ejecuta un comando
-f  # segundo plano
-L  # tuner estatico directo
-R  # tunel estatico inverso
-D  # tunel dinamico
```

**Local-destino**: Creo un túnel  que abre el puerto 9001 local y me envía al puerto 80 de la interficie localhost de destino

```bash
➜ ssh -L 9001:localhost:80 jorge@portatil
➜ curl http://localhost:9001
bienvenido apache bla bla...
```

**local - destino - remoto:**  En este ejemplo simulo que desde el  host-local no tengo  acceso al  server (host-remoto), pero desde portatil (host-desti)  si.  Creo un  tunel que abre el puerto 9001 del host-local que me envía al  portatil y el portatil me reenvía al puerto 22 del server.

```bash
# creo tunel
➜ ssh -L 9001:server:22 jorge@portatil
# me conecto al puerto 9001  local con ssh y el usuario pi del server
➜ ssh -p 9001 pi@localhost
# el tunel me reenvia al server.
pi@raspberrypi:~ $
```

##### Inversos

**local-destino**: host-local (aws) corre un servicio de daytime en el puerto 13, pero es  solo local el firewall corta todas las entradas. Entonces desde aws  conecto con host-destino (casa) y abro el  puerto 3035 donde conecta con el localhost:13 de aws.

```bash
[fedora@aws ~]$ ssh -R 3035:localhost:13 pi@casa
pi@casa:~ $ curl http://localhost:3035
17 MAR 2020 17:19:08 UTC
```

**local-destino-remoto**: En este ejemplo El firewall  bloquea todas las entradas del exterior,  entonces desde casa establezco  una conexión inversa con aws para que  desde el puerto aws:3035 pueda  acceder a casa y la redirijo al  portatil:13  que tiene el servidor  daytime.

```bash
casa ➜ ssh -R 3035:portatil:13 fedora@aws
[fedora@aws ~]$ curl http://localhost:3035
17 MAR 2020 17:38:34 UTC
```

## fail2ban

`Fail2ban` analiza archivos de registro como `/var/log/pwdfail` o  `/var/log/apache/error_log` y prohíbe las direcciones IP que provocan demasiados intentos de  contraseña rechazados. Actualiza las reglas del firewall para bloquear  las direcciones IP. También pueden configurar  la forma en que se utilizan las llamadas "jail" en Fail2Ban para bloquear direcciones IP. Un jail Fail2Ban es una combinación de un filtro y  toma una o varias acciones.

Archivos log y configuracion

    /var/log/fail2ban.log 
    /etc/fail2ban/
    /etc/fail2ban/jail.d/*.local

Comandos basicos

    fail2ban-client status
    fail2ban-client status sshd
    fail2ban-client set sshd unbanip 192.168.33.12

### JAIL

Ejemplo de jail

*/etc/fail2ban/jail.d/sshd.local*

    [sshd]
    #mode   = normal
    enabled  = true
    port    = ssh
    logpath = %(sshd_log)s
    backend = %(sshd_backend)s

---

## rsyslog

cliente

*/etc/rsyslog.conf*

    ...
    #remote host is: name/ip:port, e.g. 192.168.0.1:514, port optional
    #*.* @@remote-host:514
    *.* @@192.168.33.12

servidor

*/etc/rsyslog.conf*

    # Provides UDP syslog reception
    $ModLoad imudp
    $UDPServerRun 514

    # Provides TCP syslog reception
    $ModLoad imtcp
    $InputTCPServerRun 514

### TLS

Instalacon de paquetes necesarios  en las 2 partes

    yum install gnutls-utils -y
    yum install rsyslog-gnutls -y

#### Cliente

Creacion de cretificados autofirmados

    certtool --generate-privkey --outfile ca-key.pem
    certtool --generate-self-signed --load-privkey ca-key.pem --outfile ca.pem

    certtool --generate-request --load-privkey centos2-key.pem --outfile centos2-request.pem
    certtool --generate-certificate --load-request centos2-request.pem --outfile centos2-cert.pem --load-ca-certificate ca.pem --load-ca-privkey ca-key.pem 

    scp centos2-*.pem ca.pem centos2:/etc/rsyslog-keys/

Fichero configuración cliente

*/etc/rsyslog.d/log-client.conf*

    $DefaultNetStreamDriverCAFile /etc/rsyslog-keys/ca.pem

    $DefaultNetStreamDriver gtls
    $ActionSendStreamDriverMode 1
    $ActionSendStreamDriverAuthMode anon
    *.*	@@(o)centos2.lpic.lan:6514

#### Server

*/etc/rsyslog.d/log-server.conf*

    $DefaultNetstreamDriver gtls
    $DefaultNetstreamDriverCAFile /etc/rsyslog-keys/ca.pem
    $DefaultNetstreamDriverCertFile /etc/rsyslog-keys/centos2-cert.pem
    $DefaultNetstreamDriverKeyFile /etc/rsyslog-keys/centos2-key.pem

    $ModLoad imtcp

    $InputTCPServerStreamDriverMode 1
    $InputTCPServerStreamDriverAuthMode anon
    $InputTCPServerRun 6514


### Filters

Con filters podemos filtrar en archivos diferentes segun el tipo de logs y de donde venga.

*/etc/rsyslog.d/remote-filter.conf*

    :fromhost, isequal, "centos1" /var/log/centos1/messages
    :msg, contains, "linus" /var/log/linus.log
    :hostname, isequal, "centos1" /var/log/centos1/hostname.log

### Outchannel

Outchanel permite ejecutar un comando cuando el archivo de log alcanza cierto tamaño

*cat /etc/rsyslog.d/remoteChanel.conf*

    # opcion  nombre_canal,arxivo_log,tamaxo_max,comando
    $outchannel canal,/var/log/linus.log,550,/sbin/logrotate /etc/logrotate.d/linus
    *.* :omfile:$canal


---

## SSH 2factors

doble autentificación al acceder mediante ssh al host

- [tutorial ubuntu](https://ubuntu.com/tutorials/configure-ssh-2fa#5-getting-help)

Instalar paquete de doble autentificador

      yum install google-authenticator

*/etc/ssh/sshd_config*

      ...
      ChallengeResponseAuthentication yes
      PasswordAuthentication yes
      ...


*/etc/pam.d/sshd*

      auth required pam_google_uthenticator.so mullok

Generar llave para el usuario.

      google-authenticator

> al generar la llave muestra un QR donde se almacena la clave de ese usuario en el movil

Hacer test de fichero de pam

    pamtester -v /etc/pam.d/sshd vagrant authenticate