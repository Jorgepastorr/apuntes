# Server mensajeria instantanea



En este documento se explica como desplegar un servidor de mensajeria instantanea sobre un Debian9 muy similar a **Slack**, pero en este caso utilizo **Synapse**, **Element** (riot) y **Jitsi**.

- [matrix-synapse](https://github.com/matrix-org/synapse/blob/develop/INSTALL.md#debianubuntu) [Matrix](https://matrix.org/) es un estándar abierto para comunicaciones sobre IP en tiempo real interoperables y descentralizadas. Este ara de servidor de mensajeria instantanea  con comunicaciones cifradas punto a punto y llamadas de audio/vídeo.

- [Element](https://github.com/vector-im/element-web) hace de cliente para acceder a los servidores de Matrix.

- [jitsi](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-quickstart) es  el servidor que se encargara de proporcionar las videollamadas.



## Prerrequisitos

Para esta practica es  necesario tener:

- un dominio o almenos simularlo, usare el dominio `ojoaldato.tk`
- subdominios para las diferentes aplicaciones `matrix.ojoaldato.tk`, `riot.ojoaldato.tk`,  `jitsi.ojoaldato.tk` en mi caso.
- Los siguientes puertos deben estar abiertos en su firewall para permitir el tráfico al servidor Jitsi Meet:
  -  80/tcp 
  - 443/tcp
  - 10000/udp
  - 22/tcp
  - 3478/udp
  - 5349/tcp



## Instalar nginx

Todas las aplicaciones correran sobre nginx, así que instalo y configuro el alojamienta de cada una.

```bash
sudo apt update
sudo apt install nginx -y
```

### Configurar nginx

Creo una configuración simple para  redirijir las peticiones desde mi dominio `ojoaldato.tk` hasta la página de inicio del server nginx.

```bash
sudo vim /etc/nginx/sites-enabled/ojoaldato.tk
server {
	listen 80;
	listen [::]:80;

	server_name ojoaldato.tk;

	root /var/www/ojoaldato.tk;
	index index.html;

	location / {
		try_files $uri $uri/ =404;
	}
}
```

#### Alojamiento Matrix

Creo una configuración para el alojamiento de Matrix, esta configuración una vez instale matrix redirigira las peticiones que entren de `matrix.ojoaldato.tk` hacia el servidor de matrix en `localhost:8008`

```bash
sudo vim /etc/nginx/sites-enabled/matrix.ojoaldato.tk 

server {
	listen 80;
	listen [::]:80;

	server_name matrix.ojoaldato.tk;

	root /var/www/ojoaldato.tk;
	index index.html;

	location / {
		proxy_pass http://localhost:8008
	}
}
```

#### Alojamiento Element

Creo una configuración para el alojamiento de Element, esta configuración una vez instale element redirigira las peticiones que entren de `riot.ojoaldato.tk` hacia la aplicacion de riot

```bash
sudo vim /etc/nginx/sites-enabled/riot.ojoaldato.tk 

server {
	listen 80;
	listen [::]:80;

	server_name riot.ojoaldato.tk;

	root /var/www/riot.ojoaldato.tk/riot;
	index index.html;

	location / {
		try_files $uri $uri/ =404;
	}
}
```



### Generar certificados

Estas aplicaciones necesitan un cifrado que conseguiremos gracias a los certificados de **LetsEncript** con **certbot** y así poder acceder al server mediante `https` 

```bash
sudo apt install python3-certbot-nginx
sudo certbot --nginx -d ojoaldato.tk -d matrix.ojoaldato.tk -d riot.ojoaldato.tk 
```

Esta instrucció automaticamente genera los certificados y modifica la configuración de nginx para el redireccionamiento de `http` a `https` , se puede ver abriendo de nuevo los archivos creados anteriormente, y probandolo desde el navegador con nuestro dominio `http://ojoaldato.tk` 



## Instalar Matrix

La [instalación de Matrix](https://github.com/matrix-org/synapse/blob/develop/INSTALL.md#debianubuntu)  requiere añadir su repositorio e instalar.

```bash
# dependencias para añadir repo
sudo apt install -y lsb-release wget apt-transport-https

# añadir el repositorio
sudo wget -O /usr/share/keyrings/matrix-org-archive-keyring.gpg https://packages.matrix.org/debian/matrix-org-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/matrix-org-archive-keyring.gpg] https://packages.matrix.org/debian/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/matrix-org.list

# actualizar e instalar
sudo apt update
sudo apt install matrix-synapse-py3
```

En la instalación de matrix te requiere insertar tu dominio, en este caso `ojoaldato.tk`  y decir si quieres que recoja estadisticas de tu servidor ( ya que es una herramienta opensource y queremos que puedan mejorar su código gracias a ello diremos que YES)



Esta  configuración es opcional pero recomendable, lo que permite es reconocer a los usuarios por `@user:servername`  y asi facilitar la vbusqueda entre servidores.

```bash
# creamos en la ruta donde aloja matrix el siguente archivo
sudo mkdir -p /var/www/ojoaldato.tk/.well-known/matrix
sudo vim /var/www/ojoaldato.tk/.well-known/matrix/server
{ "m.server": "matrix.ojoaldato.tk:443" } 

# comprobamos que se puede acceder desde el exterior
curl -L https://ojoaldato.tk/.well-known/matrix/server
{ "m.server": "matrix.ojoaldato.tk:443" } 
```

TODO

> **Nota:** queda pendiente configurar mail



## Instalar Element

[Element](https://github.com/vector-im/element-web) es el cliente que usaremos para acceder a nuestro servidor matrix, realmente no se instala, simplemente se descarga y luego se configura.

```bash
# creo el directorio donde se alojara element (riot)
sudo mkdir /var/www/riot.ojoaldato.tk

# accedo al directorio y descargo element
cd /var/www/riot.ojoaldato.tk/
sudo wget https://github.com/vector-im/element-web/releases/download/v1.7.16/element-v1.7.16.tar.gz
sudo wget https://github.com/vector-im/element-web/releases/download/v1.7.16/element-v1.7.16.tar.gz.asc

# este paso es opcional, solo verifica la descarga
sudo gpg --verify element-v1.7.16.tar.gz.asc 
sudo wget https://packages.riot.im/element-release-key.asc
sudo gpg --import element-release-key.asc 
sudo gpg --verify element-v1.7.16.tar.gz.asc  
 
# descomprimo el archivo descargado
sudo tar xvzf element-v1.7.16.tar.gz 

# creo un link al directorio desde donde nginx lo reconocera
sudo ln -s element-v1.7.16 riot
```



### Configurar Element

En los archivos descargados ya nos proporciona una configuración de ejemplo que copiaremos y modificaremos algunos parametros.

- `base_url` : dominio donde vse encuentra el servidor matrix
- `server_name`: nuestro dominio
- `jitsi.preferredDonmain` : dominio de nuestro server jitsi que instalaremos a continuación. Esta instrucción lo que hace es indicar nuestro servidor jitsi para las videoconferencias.

```bash
sudo cp /var/www/riot.ojoaldato.tk/riot/config.sample.json /var/www/riot.ojoaldato.tk/riot/config.json
sudo vim /var/www/riot.ojoaldato.tk/riot/config.json 

{
    "default_server_config": {
        "m.homeserver": {
            "base_url": "https://matrix.ojoaldato.tk",
            "server_name": "ojoaldato.tk"
        },
...
    },
    "jitsi": {
        "preferredDomain": "jitsi.ojoaldato.tk"
    }
}
```

Habilitar los registros de usuario y ya podemos acceder a nuestro servidor matrix.

```bash
sudo vim /etc/matrix-synapse/homeserver.yaml 

...
enable_registration: true
...

# reiniciar/reload server matrix para recargar configuración
sudo systemctl restart matrix-synapse
```

En este punto ya podemos acceder a https://riot.ojoaldato.tk y chatear, pero queremos añadir las videoconferencias de nuestro server jitsi.



## Instalar Jitsi

[Jitsi](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-quickstart) es un server de videoconferencias opensource que vamos a integrar a element. 

Para su instalación tenemos que añadir su repositorio, abrir el firewall para los puertos necesarios en su funcionamiento.

```bash
# instalar openjdk requerido y añadir repo

sudo apt install openjdk-8-jdk
curl https://download.jitsi.org/jitsi-key.gpg.key | sudo sh -c 'gpg --dearmor > /usr/share/keyrings/jitsi-keyring.gpg'
echo 'deb [signed-by=/usr/share/keyrings/jitsi-keyring.gpg] https://download.jitsi.org stable/' | sudo tee /etc/apt/sources.list.d/jitsi-stable.list > /dev/null
```

The following ports need to be open in your firewall, to allow traffic to the Jitsi Meet server: 

- 80 TCP - for SSL certificate verification / renewal with Let's Encrypt 
- 443 TCP - for general access to Jitsi Meet 
- 10000 UDP - for general network video/audio communications 
- 22 TCP - if you access you server using SSH (change the port accordingly if it's not 22) 
- 3478 UDP - for quering the stun server (coturn, optional, needs config.js change to enable it) 
- 5349 TCP - for fallback network video/audio communications over TCP (when UDP is blocked for example), served by coturn

```bash
sudo ufw allow 80/tcp 
sudo ufw allow 443/tcp
sudo ufw allow 10000/udp
sudo ufw allow 22/tcp
sudo ufw allow 3478/udp
sudo ufw allow 5349/tcp
sudo ufw enable
sudo ufw status verbose
```

**Instalar**

En la instalación pide el dominio que usar para acceder a jitsi `jitsi.ojoaldato.tk` , y si quieres generar certificados automaticamente o si quieres asignar los tuyos propios, en mi caso que se genere automaticamente.

```bash
sudo apt update
sudo apt install jitsi-meet
```

Comprobar desde el navegador http://jitsi.ojoaldato.tk



### Posibles Houps

**Posibles errores** en la instalación de jitsi

En mi caso no hacia la redirección automatica de `http` a `https` y la he tenido que configurar manualmente, en el archivo de configuración generado por jitsi.

```bash
sudo cat /etc/nginx/sites-enabled/jitsi.ojoaldato.tk.conf 

server_names_hash_bucket_size 64;

server {

    if ($host = jitsi.ojoaldato.tk) {
        return 301 https://$host$request_uri;
    } 


    listen 80;
    listen [::]:80;
    server_name jitsi.ojoaldato.tk;
....

sudo systemctl restart nginx
```

Por alguna razon no se han generado los certificados bien,  y jitsi ya a pensado en ello, porque trae un script para generarlos.

```bash
sudo /usr/share/jitsi-meet/scripts/install-letsencrypt-cert.sh
```



Y el server Element con videoconferencias https://riot.ojoaldato.tk 

![Screenshot from 2021-01-02 11-32-47](https://raw.githubusercontent.com/Jorgepastorr/apuntes/master/images/mensajeria/riot-jitsi.png)

