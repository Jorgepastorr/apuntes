```python
# usage prog hostname
from socket import gethostbyname
hostname = sys.argv[1]
ip = gethostbyname(hostname)
print("%s"%(ip,))
```

file:///usr/share/doc/python3-docs/html/library/socket.html

other functions

python3-docs

# DNS

dns es protocolo binario

Dns utiliza el paquete `bind` , que este contiene el servicio `named` y a dicho servicio se puede interactuar en caliente con el comando `rndc`.

Algunas opciones de `named`.

```bash
named -c config-file
named -d debug-level [0-15]
named -f -g  logs en foreground   convinado con debug level puede ayudar
named -L /dev/sdtderr
named -u (user)  por defecto named
```

## Configuración

```bash
/etc/named/
/var/named/
```

## Utilidades para resoluciones de dns.

```bash
dnf install -y bind-utils
```

nslookup y host por defecto no miran el archivo `/etc/hosts` 

```bash
dig yahoo.es +short
# poner por defecto salida corta
~/.digrc
+short
```

```bash
dig -x 8.8.8.8 @server
```

## Documentación oficial

Al instalar el paquete bind, este descarga toda su documentación 

```bash
doc original
/usr/share/doc/bind/Bv9ARM.html
/usr/share/doc/bind/Bv9ARM.pdf
ejemplos
/usr/share/doc/bind/shample
```

## Estadísticas

Generar estadísticas del trafico del dns

Siempre que este la siguiente opción en `/etc/named.conf`

```bash
...
    statistics-file "/var/named/data/named_stats.txt";
...
```

```bash
systemctl start named # con el servicio activo
rndc stats    # activar estadisticas
```

observar resultado en el archivo indicado `cat /var/named/data/named_stats.txt ` 

## acl

Definir un alias a una o varias series de ip

```bash
acl aula {10.200.243.0/24;};
options {
    listen-on port 53 { 127.0.0.1; 10.200.243.209; };
    directory     "/var/named";
    dump-file     "/var/named/data/cache_dump.db";
    statistics-file "/var/named/data/named_stats.txt";
    memstatistics-file "/var/named/data/named_mem_stats.txt";
    allow-query     { localhost; aula; };
```

## Reenvío forwarder

```bash
forward only;
forwarders {10.1.1.200;};    
recursion yes;
```

La opción de `forward` , con `only` mandara automáticamente las peticiones al servidor externo sin intentarlas resolver el mismo, se puede añadir `first` opción por defecto y si no encuentra respuesta exteriormente busca en las zonas internas.

## Barrar cache

```bash
rndc flush
```

## Zonas

Un fichero de zona es una lista de *resource-records*. que llega a ser una lista de resoluciones ip-dominio y viceversa.

En el archivo `named.conf` se definen dos zonas la directa y la inversa:

```bash
# directa
zone "lacasitos.com" IN {
    type master;
    file "lacasitos.com.zone";
}
# inversa
zone "243.200.10.in-addr.arpa" IN {
    type master;
    file "lacasitos.com.rev.zone";
}
```

**Importante**: Zona directa se define con el dominio principal, esta se encargara de resolver dominios a ip. mientras que la zona inversa se define con la ip del servidor  del revés  hasta el octeto cambiante seguido de `in-addr.arpa`, esta  zona se encarga de las resoluciones ip a dominio.

los archivos de zona si se definen con ruta parcial se devén encontrar en el directorio establecido por  `directory     "/var/named";` .

Las lineas de archivos de zona se definen por los elementos `name, ttl, record class, record type, record data`  si no se especifica un campo se recoge el definido global mente al inicio del archivo o el de la linea anterior.

- `name` 
- `TTL` tiempo de vida 
- `record class` clase de registro 
- `record type` tipo de registro `SOA,  A, AAAA, CNAME, PTR, MX ...`
- `record data` los datos de registro podrán consistir de uno o mas elementos de información dependiendo de el tipo de registro.

Como mínimo un archivo de zona debe especificar el inicio de autoridad (SOA) con el nombre  de servidor maestro la dirección de correo de la persona responsable y la lista de argumentos de tiempo de caducidad.

```bash
# origin    class    type    server-fqdn                 mail                    arguments
@            IN        SOA        jorge.lacasitos.com.    mailhost.lacasitos.com. ( 0 1D 1H 1W    3H )
```

*lacasitos.com.zone*

```bash
; file  lacasitos.com
$ORIGIN lacasitos.com.
$TTL 1D
@    IN    SOA    jorge.lacasitos.com.    mailhost.lacasitos.com. (
                    0    ; serial
                    1D    ; refresh
                    1H    ; retry
                    1W    ; expire
                    3H )    ; minimum

; DNS NS Records
@        IN        NS        jorge.lacasitos.com.

; DND A records
marc    IN        A        10.200.243.208
jorge    IN        A        10.200.243.209
pau        IN        A        10.200.243.210
supertux    IN    CNAME    jorge
```

**Características de archivo** 

- El punto final especifica que es un nombre completo en el caso de no estar se le añadirá el dominio seguidamente.
  - ` @ IN NS jorge.lacasitos.com.`= ` @ IN NS jorge`
  - ` @ IN NS jorge.lacasitos.com` = ` @ IN NS jorge.lacasitos.com.lacasitos.com.`
- Si no se define `$ORIGIN` se cogerá el valor del nombre de zona
- La @ es substituye por el valor de ORIGIN
- El nombre del servidor a de estar definido tanto en el `SOA, NS, A` .

El archivo de zona inversa los registros SOA y NS serán exactamente iguales, y añadiremos la lista de resoluciones inversas con el octeto/s faltan-te en el nombre de la zona seguido de su dominio.

*lacasitos.com.rev.zone*

```bash
; file zone 243.200.10
$TTL 1D
@    IN SOA    jorge.lacasitos.com. mailhost.lacasitos.com. (
                    0    ; serial
                    1D    ; refresh
                    1H    ; retry
                    1W    ; expire
                    3H )    ; minimum

; DNS NS records
@    NS    jorge.lacasitos.com.

; DNS PTR records
208    IN    PTR        marc.lacasitos.com.
209    IN    PTR        jorge.lacasitos.com.
210    IN    PTR        pau.lacasitos.com.
```

### backup zonas

Se puede hacer un backup de zonas y visualizar las zonas con:

```bash
rndc dumpdb -zones
less /var/named/data/cache_dump.db
```

- Este archivo puede variar de localización según el parámetro `dump-file` en el archivo `named.conf`.

O a una sola zona con:

```bash
# directa
named-compilezone -o backup_zona.txt informatica.escoladeltreball.org informatica.escoladeltreball.org.zone 
# inversa
named-checkzone -o backup_zona.txt 200.10.in-addr.arpa informatica.escoladeltreball.org.rev.zone  
```

### Generate

En ocasiones tenemos muchos registros muy similares y repetitivos, con generate podemos ahorrar de escribir múltiples registros y escribir solo uno.

```
$ORIGIN informatica.escoladeltreball.org.
$TTL 1D
@    IN    SOA    jorge.informatica.escoladeltreball.org.    adminmail.informatica.escoladeltreball.org. 0 1D 1H 1W 3H 

; DNS NS Records
@        IN        NS        jorge.informatica.escoladeltreball.org.

; DND A records
jorge    IN        A        10.200.243.209

; Eestacions aula N2H  (30 ordinadors)
h01 IN A 10.200.242.201
h02 IN A 10.200.242.202
h03 IN A 10.200.242.203
...
```

Es lo mismo que:

```
$ORIGIN informatica.escoladeltreball.org.
$TTL 1D
@    IN    SOA    jorge.informatica.escoladeltreball.org.    adminmail.informatica.escoladeltreball.org. 0 1D 1H 1W 3H 

; DNS NS Records
@        IN        NS        jorge.informatica.escoladeltreball.org.

; DND A records
jorge    IN        A        10.200.243.209

; Eestacions aula N2H  (30 ordinadors)
$GENERATE 1-30 h${0,2,d} IN A 10.200.242.2${0,2,d}
```

Sintaxis :` $GENERATE range lhs[ttl] [class]type rhs[comment]`

- `range`  acepta saltos en la secuencia 2-10/2  suma de dos en dos

`${offset[,width[,base]]}`

Por  defecto la generación es `${0,0,d}` es decir `{0 valores a sumar o restar, 0 longitud del valor, base decimal}`.

# Http

una transmision consiste en 2 mensajes

primera linea especial seguida de 0 o mas cabeceras

`GET /path/file HTTP/1.0`  metodo get es siempre sin cuerpo, final de linea es cd y rf `\r\n` 

```bash
curl -s -D /dev/stderr http://seat.es > /dev/null
HTTP/1.1 301 Moved Permanently
Date: Tue, 19 Nov 2019 10:57:53 GMT
Location: https://www.seat.es/
Content-Length: 228
Content-Type: text/html; charset=iso-8859-1
Set-Cookie: TS0177e393=012f656eaa20722a90edef1d916342e21c1021f54ea8f278cfb73d1720c7998c2394aea1eb5368826345d7be0f88e1232fd6f8f377; Path=/
```

/usr/share/doc/python3-docs/html/index.html

## Directorios

```bash
/usr/share/httpd/manual/index.html # manual
/etc/httpd/conf/httpd.conf # configuración
/etc/httpd/modules  # modulos instalados
/var/www/html # directorio publicación por defecto
```

## logs

```bash
sudo tail -f /etc/httpd/logs/error_log
sudo tail -f /etc/httpd/logs/access_log
```

## Configuración

include a directorio en el home

apachectl -t   verifica ficheros de configuración

execcgi quitar si no quiero ejecutables

### Alias

https://httpd.apache.org/docs/2.4/es/mod/mod_alias.html

https://httpd.apache.org/docs/2.4/es/mod/core.html#options

```bash
Alias "/python" "/usr/share/doc/python3-docs/html"
<Directory "/usr/share/doc/python3-docs/html">
    Options +Indexes -ExecCGI -FollowSymLinks
    Require all granted
</Directory>
```

### Userdir

https://httpd.apache.org/docs/2.4/es/mod/mod_userdir.html#userdir

https://httpd.apache.org/docs/2.4/es/howto/public_html.html

```
<IfModule mod_userdir.c>
    UserDir  "public_html"
    UserDir enabled isx47787241
</IfModule>

<Directory "/home/users/inf/hisx2/isx47787241/public_html">
    AllowOverride FileInfo AuthConfig Limit Indexes
    Options MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec
    Require method GET POST OPTIONS
</Directory>
```

verificar que tenemos los permisos de acceso, almenos 711 hasta el home. y el directorio `public_html`  755.

Ya podemos acceder desde `localhost/~jorge`

Para evitar poner la tilde, usar la expresión regular siguiente en la configuración.

```bash
RewriteEngine on 
RewriteRule  ^/personal/([a-z0-9]+)         /~$1    [R]
```

### Includes

https://httpd.apache.org/docs/2.4/es/mod/mod_include.html

```bash
Alias "/data" "/home/users/inf/hisx2/isx47787241/public_data"
<Directory "/home/users/inf/hisx2/isx47787241/public_data">
    AddType text/html .html
    AddOutputFilter INCLUDES;DEFLATE .html
    Options +Indexes -ExecCGI -FollowSymLinks +IncludesNoExec
    Require all granted
</Directory>
```

```bash
public_data
├── head.html
└── index.html
```

*index.html*

```html
 <!--#include file="head.html" --> 
 <!--#fsize file="head.html" -->
 <p>hola mundo</p>
 <pre> <!--#printenv --> </pre> 
```

### VirtualHost

https://httpd.apache.org/docs/current/mod/core.html#virtualhost

https://httpd.apache.org/docs/2.4/vhosts/examples.html

Virtualhost permite servir diferentes paginas desde un mismo host, esto lo hace mirando que tipo de servername le llega en la url, y desde ahí, distribuye la pagina adecuada.

Añadir a `/etc/hosts` o dns  la ip de virtual host y el alias.

```bash
...
192.168.88.2    jorge.com 
```

añadir sede virtual al archivo `/etc/httpd/conf/httpd.conf`

```bash
# sede virtal
<VirtualHost 192.168.88.2:80>
    ServerName jorge.com
    DocumentRoot "/home/debian/apache/vhost"
</VirtualHost>

# permisos de acceso al directorio
<Directory "/home/debian/apache/vhost">
    Options +Indexes -ExecCGI -FollowSymLinks
    Require all granted
</Directory>
```

### Indexes

La opción `Indexes` permite en el caso de no encontrar un archivo index.html mostrar la página como si fuera un ftp. Es necesario comentar o renombrar el archivo `/etc/http/conf.d/welcom.conf` ya que por defecto, si no encuentra la página index.html lo redirige a la página de muestra apache2.

```bash
<Directory "/home/users/inf/hisx2/isx47787241/public_data">
    AddType text/html .html
    AddOutputFilter INCLUDES;DEFLATE .html
    Options +Indexes -ExecCGI -FollowSymLinks +IncludesNoExec
    Require all granted
</Directory>
```

### Directorio de ejecutables

`ExecCGI` permite ejecutar archivos y `ScriptAlias` define un directorio de ejecutables.

```bash
# conf directorio ejecutable
ScriptAlias "/a" "/home/users/inf/hisx2/isx47787241/apache/scripts"
<Directory "/home/users/inf/hisx2/isx47787241/apache/scripts">
    Options +ExecCGI
    AddHandler cgi-script .sh .py
    Require all granted
</Directory>
```

#### Mezcla

directorio donde se mezclan archivos ejecutbles con normales html.

```bash

Alias "/app" "/home/users/inf/hisx2/isx47787241/apache/app1"
<Directory "/home/users/inf/hisx2/isx47787241/apache/app1">
    Options +Indexes +ExecCGI -FollowSymLinks
    AddHandler cgi-script .sh 
    Require all granted
</Directory>
```

### http-referer

get acaba en cr lf y post en cos body

tipo mime de post CONTENT_TYPE=application/x-www-form-urlencoded

get

 curl --silent --dump-header /dev/stderr http://www.escoladeltreball.org > /dev/null

post

 clear;curl --silent --dump-header --data -d  @filename http://localhost/app2/script/dump.py

### Auth usuarios

Generar archivo de contraseñas de usuarios.

```bash
htpasswd -b -c passwd pepe contrasena
Adding password for user pepe
htpasswd -b  passwd pepe2 contrasena
Adding password for user pepe2
```

configuración directorio

```bash
Alias "/data" "/home/users/inf/hisx2/isxXXXXXXX/public_data"
<Directory "/home/users/inf/hisx2/isxXXXXXXX/public_data">
    Options +Indexes -ExecCGI -FollowSymLinks
    Authtype Basic
    AuthName "Acces a usuarios"
    AuthBasicProvider file
    AuthUserFile /home/users/inf/hisx2/isxXXXXXXX/apache/passwd
    Require valid-user
</Directory>
```

### Auto detectar idioma

Con esta configuración el navegador recogerá el `index.html` con el idioma predefinido por el mismo.

```bash
idiomas
├── index.html.en
├── index.html.es
└── index.html.ca
```

Las opciones que hacen funcioar esto son `+MultiViews, LanguagePriority, ForceLanguagePriority`

```bash
Alias "/idiomas" "/home/debian/apache/idiomas"
<Directory "/home/debian/apache/idiomas">
    LanguagePriority en ca es
    ForceLanguagePriority Fallback
    Options -Indexes -ExecCGI -FollowSymLinks +MultiViews
    Require all granted
</Directory>
```

### Likes

el enlace img llama a un script para ejecutar algo antes de mistrarte la imagen



apache.conf

```bash
Alias "/like" "/home/users/inf/hisx2/isx47787241/apache/like"
<Directory "/home/users/inf/hisx2/isx47787241/apache/like">
    AddType text/html .html
    Options +Indexes +ExecCGI -FollowSymLinks -IncludesNoExec
    Require all granted
</Directory>
```



index.html

```bash
<p>hola like</p>
<img src='/cgi-bin/dump.sh'/>
```



dump.sh

```bash
#!/usr/bin/bash
echo $REMOTE_ADDR >> /var/likes/bigdata
echo 'Content-Type: image/png; charset=UTF-8'
echo
cat /home/users/inf/hisx2/isx47787241/Descargas/index.png
```

```bash
#!/usr/bin/bash
echo $REMOTE_ADDR >> /var/likes/bigdata
echo 'Status: 302'
echo 'Location: https://upload.wikimedia.org/wikipedia/commons/1/13/Facebook_like_thumb.png'
echo
```
