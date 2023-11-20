# 110 Seguridad

## Tareas de administración de seguridad.



### Permisos

comprobación de permisos. Un punto dónde podría haber fallos de seguridad es en los permisos de escritura para otros de un directorio. 

```bash
find / -type -d -perm -002
```

Permisos especiales se han de tener en cuenta si un programa se ejecuta con permisos de usuario o un directorio permite escribir o borrar a diferentes usuarios.

```bash
find / -perm /6000	# busca permisos de SUID o SGID
```



### Usuarios y contraseñas

Con el comando `chage` podemos establecer una política segura para la gestión de las contraseñas por parte de nuestros usuarios.



`sudo` permite ejecutar ordenes con permisos de administrador. Para gestionar los permisos que concede `sudo` se debe ejecutar `visudo`, este comando lanza un editor que al salir comprueba la sintaxis.

#### Reglas de acceso en `/etc/sudoers`

En la sintaxis de sudoers se pueden utilizar diversos alias para agrupar usuarios, grupos, comandos, etc. Si queremos referirnos a todos usamos `ALL`

sintaxis:

```bash
# user host=(user:grupo) comando/s
root   ALL=(ALL:ALL) ALL
```

Es decir el usuario  ( `root`) puede iniciar sesión desde todos los hosts ( `ALL`), como todos los usuarios y todos los grupos ( `(ALL:ALL)`), y ejecutar todos los comandos ( `ALL`).

```bash
%sudo   ALL=(ALL:ALL) NOPASSWD:ALL	# grupo sudo tiene acceso
pedro   ALL=(ALL:ALL) ALL			# pedro tiene acceso 
carol	192.168.0.6=(ALL:ALL) /usr/bin/systemctl start apache2

# permisos con un alias
User_Alias PROFESORES=carmen,paco
PROFESORES ALL=(ALL:ALL) ALL
```

Ejemplo de alias:

```bash
Host_Alias SERVERS = 192.168.1.7, server1, server2

# User alias specification
User_Alias PRIVILEGED_USERS = mimi, alex
User_Alias ADMINS = carol, PRIVILEGED_USERS

# Cmnd alias specification
Cmnd_Alias SERVICES = /usr/bin/systemctl *

# User privilege specification
ADMINS  SERVERS=SERVICES
```

Los usuarios que pertenecen al alias ADMINS podrán acceder desde los host del alias SERVERS y podrán ejecutar todos los comandos de `systemctl` 



#### Información sobre logins

`who` indica quién está identificado en el sistema

```bash
who
who -b	# ultimo inicio del sistema
who -r	# nivel de inicio actual
who -H	# imprimir encabezados de columna
```



`w` muestra quien hay y que esta ejecutando

`last` lista los últimos accesos que ha tenido el sistema, este comando obtiene la información del archivo `/var/logs/wtmp`

```bash
last
last <user>
-p 2021-04-21	# fecha determinada
-s -5day	# sinde desde cuando
-u 			# hasta cuando
```

> `lastb` muestra los intento de sesión fallidos



### Limitar el uso del sistema

En el fichero `/etc/security/limits.conf` podemos establecer diversos límites de uso del sistema a usuarios o grupos. cada fila es una limitación con el siguiente formato:

```bash
domain			type	item			value
@student        -       maxlogins       4
```

- **domain** es quién  se verá afectado por la restricción
- **type** puede ser hard (dura) o soft (blanda)
- **item** a qué recurso afecta la limitación
- **value** al valor límite

las limitaciones hard solo las podrá escribir el usuario root desde el archivo de configuración, las limitaciones soft las podrá modificar el usuario pero nunca superando los limites que impone una linea hard.

`ulimit` comando sirve para poner límites a nivel de todo el sistema

```bash
ulimit	# limites blandos del usuario actual
ulimit -a	# ver los limites del sistema blandos
ulimit -aS	# igual al anterior
ulimit -aH	# ver limites duros actuales
ulimit -f 500 # cambiar valor soft y hard de tamañom max ficheros
ulimit -Sf 500
ulimit -Hf 500
ulimit -s unlimited

-b	# tamaño máximo de búfer de socket
-f	# tamaño máximo de archivos escritor por el shell
-l	# tamaño máximo que se puede bloquear en memoria
-v	# cantidad máxima de memoria virtual
-u	# número máximo de procesos disponibles para un usuario
```



### Descubrir puertos abiertos

#### Mediante archivos

`lsof` Lista los ficheros  abiertos en el sistema, como en linux todo está basado en archivos, las conexiones de red también se podrán ver.

```bash
lsof [opciones] [ruta]
-u	# ficheros abiertos de un usuario
-p	# busca por PID
-c	# busca por nombre de proceso
-i[@ip]	# busca por IP
-i4	# conexiones ipv4
-i :22	# conxiones puerto 22 puedes establecer varios :80,443 :20-30
```

`fuser` Muestra los procesos que están usando un fichero o directorio.

```bash
fuser [opciones] [ruta]
-v	# lectura humana
-k	# mandar parar a un proceso
-n tcp 80 	# ver conexiones 80/tcp
-v 80/tcp	# ver conexiones 80/tcp
➜ fuser -v .
                     USER        PID ACCESS COMMAND
/home/debian:        debian     3615 ..c.. gdm-x-session
```

Los diferentes accesos son:

- `c` directorio actual

- `e` archivo en ejecución

- `f` archivo abierto, `F` archivo abierto para escribir

- `r` directorio raíz

- `m`  mmpap'ed archivo o biblioteca compartida

  

`iotop`  Muestra en tiempo real los procesos que están escribiendo en el disco



#### Mediante comandos de red

`netstat/ss` muestra puertos abiertos y conexiones establecidas

`nmap` escaneo de puertos y otro tipo de comprobaciones

```bash
nmap 192.168.0.3	# escanear puertos a una dirección
nmap 192.168.0.*	# permite comodines
nmap -p 20-50 192.168.0.10-20	# escanear por rango de puertos y de ip's
nmap 192.168.0.0/24 --exclude 192.168.0.7
nmap -sP 192.168.0.0/24	# ver host activos en una red

-p	# puerto
-F	# 100 puertos más comunes
-v	# vervose
-sP	# sondeo ping
```



## Configurar la seguridad del host



`/etc/nologin` si este fichero existe nadie excepto root puede iniciar sesión en el sistema. en su lugar se mostrará el contenido del fichero `nologin` al intentar iniciar sesión.

> El acceso a root solo estará permitido desde consola.



### TCP wrappers

Es un sistema para conceder o denegar acceso según las reglas que contienen los ficheros:

- `/etc/hosts.allow` contiene los hosts que tienen permitido el acceso

- `/etc/hosts.deny`  contiene los hosts que tienen denegado el acceso

> Si una regla está en ambos archivos, siempre tendrá prioridad el archivo `hosts.allow`



El contenido de estos ficheros son reglas de tipo `lista_servicios:lista_host` donde *lista_servicios* son uno o más servicios de los que figuran en `/etc/services` y *lista_host* se puede indicar con nombres, direcciones IP o redes completas.

En ambas se pueden usar comodines como ALL, LOCAL, ...

```bash
# lista-servicios:lista_hosts
ALL:*.example.com	# todos los que pertenezcan a el subdominio de example.com
sshd:192.168.1.10	# un host concreto
sshd:192.168.1.		# una red concreta
```



#### Saber si un servicio está utilizando TCP Wrappers

Buscar la directiva *hosts_access* con el comando `strings`

```bash
strings /usr/sbin/sshd | grep hosts_access
strings -f /usr/sbin/* | grep hosts_access
```

Comprobar si utiliza la librería `libwrap`

```bash
ldd /usr/bin/sshd | grep libwrap
```



### xinetd

Es un mecanismo de control de los servicios del sistema que amplia las capacidades de su sucesor `inetd`. Puede habilitarlos basándose en el tiempo, en función del origen ( como TCP Wrappers ), por interface, etc.

xinetd se utilizaba cuando los recursos de los dispositivos eran limitados y tener muchos servicios a la escucha no era recomendable, aún así hoy en día puede seguirse utilizando.

Su fichero de configuración es `/etc/xinetd.conf` donde se encontrará  la configuración global para configurar los diferentes servicios de `xinetd` se creará un archivo por cada servicio en   `/etc/xinetd.d/` 



  `/etc/xinetd.d/ssh`

```bash
service ssh
{
	disable		= no
	socket_type	= stream
	protocol	= tcp
	wait		= no
	user		= root
	server		= /usr/sbin/sshd
	server_args 	= -i
	flags		= IPv4
	interface	= 192.168.178.1
}
```

- `disable`  Si desea deshabilitar la configuración temporalmente, puede configurarla en yes.
- `socket_type`  Puede elegir stream entre sockets TCP o dgram UDP y más.
- `protocol`  Elija TCP o UDP. 
- `wait`  Para las conexiones TCP, esto se establece en no normalmente.
- `user`  El servicio iniciado en esta línea será propiedad de este usuario.
- `server`  Ruta completa al servicio que debe iniciar xinetd.
- `server_args`  Puede agregar opciones para el servicio aquí. Si lo inicia un super-servidor, muchos servicios requieren una opción especial. Para SSH, esta sería la `-i` opción.
- `flags`  Puede elegir IPv4, IPv6 y otros.
- `interface`  La interfaz de red que xinetd tiene que controlar. Nota: también puede elegir la `bind` directiva, que es solo un sinónimo de interface.

otras directivas:

- `only_from` Permitir acceso solo  a los hosts indicados

> cuando se ejecuta `startx` o algún programa que llame a `xinit`  estos buscrán la configuración de xinet en `~/.xinitrc`



### Servicios activos innecesarios

Por razones de seguridad, así como para controlar los recursos del sistema, es importante tener una descripción general de los servicios que se  están ejecutando. Los servicios innecesarios y no utilizados deben desactivarse. 

Para comprobar que servicios se están ejecutando actualmente se puede utilizar diferentes herramientas.

```bash
ss -ltp
netstat -ltp

# SysV-init
sudo service --status-all
sudo update-rc.d SERVICE-NAME remove	# Debian
sudo chkconfig SERVICE-NAME off			# Red Had

# Systemd
systemctl list-units --state active --type service
sudo systemctl disable UNIT-NAME --now
```





## Protección de datos con cifrado



### Comunicaciones SSH

Es un protocolo (y programa) que permite acceder a un servidor  remoto de una forma segura cifrando la información que se intercambia con el cliente.

La función más usada es ejecutar comandos mediante terminal en una máquina remota, pero puede usarse para copiar `scp` , `sftp` y para crear túneles seguros usados por multitud de aplicaciones.

Para cifrar la comunicación utiliza claves públicas y privadas.

```bash
/etc/ssh/ssh_config		# conf cliente
/etc/ssh/sshd_config	# conf servidor
```

Se puede iniciar sesión con el usuario y la contraseña o usando las claves instaladas en el cliente y el servidor.

`~/.ssh/known_hosts`  contiene los hash de los hosts conocidos, es decir los que ya se a establecido una conexión.

#### Directivas destacadas de sshd_config

```bash
Port			# puerto a la escucha por defecto 22
PermitRootLogin	# perrmitir acceso remoto a root
X11Forwarding	# permitir tunel para usar entorno gráfico
AllowTcpForwarding	# permitir tuneles
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
-t	# metodo de cifrado dsa, ecdsa, ed25519, rsa
-b	# bits usados para el cifrado 2048 suficiente
-A	# generar llaves de todos los metodos de cifrado
-R	# borrar claves de un hostname
-l [-f file_key]	# ver fingerprint
...

ssh-keygen -t rsa -b 2048
ssh-keygen -f "~/.ssh/known_hosts" -R "192.168.0.25"
```

Para acceder a un servidor remoto este tiene que tener guardada la clave pública en el archivo `~/.ssh/autorized_keys`. Esto se puede hacer con el comando `ssh-copy-id user@host`  



#### ssh-agent

gestiona las claves privadas mientras dure la sesión. Útil cuando se trabaja con varios servidores y se quiere agilizar la repetitiva identificación en cada uno de ellos.

Primero tenemos que ejecutar el comando para iniciarlo y después utilizar `ssh-add` para añadir todas las claves que queremos gestionar. De esta manetra si nuestras llaves tienen passfrase solo las tendremos que añadir una vez.

```bash
carol@debian:~/.ssh$ ssh-agent /bin/bash
carol@debian:~/.ssh$ ssh-add
Enter passphrase for /home/carol/.ssh/id_ecdsa:
Identity added: /home/carol/.ssh/id_ecdsa (carol@debian)
```





#### Tuneles

Es una conexión cifrada entre dos puntos que se establece con la intención de que sea utilizada para transmitir los datos de otra aplicación o servicio de forma segura.

```bash
ssh 
-N	# no se ejecuta un comando
-f	# segundo plano
-L	# tuner estatico directo
-R	# tunel estatico inverso
-D	# tunel dinamico
```

**Local-destino**: Creo un túnel  que abre el puerto 9001 local y me envía al puerto 80 de la interficie localhost de destino

```bash
➜ ssh -L 9001:localhost:80 jorge@portatil
➜ curl http://localhost:9001
bienvenido apache bla bla...
```

**local - destino - remoto:**  En este ejemplo simulo que desde el  host-local no tengo  acceso al server (host-remoto), pero desde portatil (host-desti)  si.  Creo un tunel que abre el puerto 9001 del host-local que me envía al  portatil y el portatil me reenvía al puerto 22 del server.

```bash
# creo tunel
➜ ssh -L 9001:server:22 jorge@portatil
# me conecto al puerto 9001  local con ssh y el usuario pi del server
➜ ssh -p 9001 pi@localhost
# el tunel me reenvia al server.
pi@raspberrypi:~ $
```

##### Inversos

**local-destino**: host-local (aws) corre un servicio de daytime en el puerto 13, pero es solo local el firewall corta todas las entradas. Entonces desde aws conecto con host-destino (casa) y abro el  puerto 3035 donde conecta con el localhost:13 de aws.

```bash
[fedora@aws ~]$ ssh -R 3035:localhost:13 pi@casa
pi@casa:~ $ curl http://localhost:3035
17 MAR 2020 17:19:08 UTC
```

**local-destino-remoto**: En este ejemplo El firewall  bloquea todas las entradas del exterior, entonces desde casa establezco  una conexión inversa con aws para que desde el puerto aws:3035 pueda  acceder a casa y la redirijo al portatil:13  que tiene el servidor  daytime.

```bash
casa ➜ ssh -R 3035:portatil:13 fedora@aws
[fedora@aws ~]$ curl http://localhost:3035
17 MAR 2020 17:38:34 UTC
```



### Cifrar archivos

GPG sirve para cifrar un fichero usando claves asimétricas. También puede firmar digitalmente un texto, para que el mensaje y el remitente pueden ser verificados. Su paquete es `GnuPG`

```bash
gpg --gen-key	# genera la clave pública y privada
gpg --list-key	# ver claves generadas
```

Al generar la  claves estas se almacenarán en `~/.gnupg/`

```bash
➜  ll .gnupg 
drwx------ 2 debian debian openpgp-revocs.d		# certifcado de revocación
drwx------ 2 debian debian private-keys-v1.d 	# llaves privadas
-rw-r--r-- 1 debian debian pubring.kbx	# llavero publico
-rw------- 1 debian debian trustdb.gpg
```

Exportar clave para mandársela al remitente

```bash
gpg --output pub_key_file --export 950b76c6	# exportar clave publica
gpg --export 950b76c6 > pub_key_file	# exportar desde fingerprint
gpg --export jorge > pub_key_file	# exportar desde uid
gpg --export jorge --armor > pub_key_file	# exportar en ASCII para email

# servidor de llaves
gpg --keyserver keyserver-name --send-keys KEY-ID # enviar llave al servidor
gpg --keyserver keyserver-name --recv-keys KEY-ID # recoger llave del servidor
```



El **proceso de mensaje**: El emisor necesita la clave pública del receptor para encriptar y el receptor desencripta el mensaje con su clave privada.

```bash
gpg --export jorge > pub_key_file	# exportar desde uid
gpg --import pub_key_file	# importar clave pública
gpg --encrypt --recipient jorge mensaje.txt	# cifrar mensaje
gpg [-d] mensage.txt.gpg	# descifrar mensaje
```

El **proceso de firma**:  El emisor firma con su llave privada y el receptor comprueba la autenticación del mensaje con la llave pública  del emisor.

```bash
gpg --sign documento.txt	# firmar documento
gpg --verify documento.txt.gpg	# comprobar la firma
gpg --decrypt documento.txt.gpg	# ver contenido con firma
gpg documento.txt.gpg	# extraer contenido
```

> `gpg --sing` firma el archivo en un documento binario `.gpg` mientras `gpg --clearsign` firma en un archivo de texto `.asc`

