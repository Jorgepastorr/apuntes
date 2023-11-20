208 servicios web

## 208.1 Configuración básica de Apache

El famoso servidor web Apache es el más conocido y, por lo menos desde 1996, el más extendido en Internet. Su popularidad se debe a su gran estabilidad y a su buena tolerancia a la carga.

El archivo de configuración de Apache, que según la versión y las opciones de compilación puede ser **httpd.conf**, **apache.conf** o **apache2.conf**, se compone de directivas seguidas de valores. 

```
directiva1 valor1 
directiva2 valor2 
... 
<directiva_de_contenedor valor> 
  directiva3 valor3 
  directiva4 valor4 
  ... 
</directiva_de_contenedor>
```

De entre todas las innumerables directivas de Apache, algunas son fundamentales y deberán encontrarse en cualquier configuración de Apache.

|              |                                                              |
| ------------ | ------------------------------------------------------------ |
| ServerRoot   | Indica el directorio raíz de los archivos de configuración.  |
| User         | Determina la cuenta de usuario del proceso Apache.           |
| Group        | Determina el grupo de servicio propietario de los procesos Apache. |
| ErrorLog     | Archivo de registro de errores.                              |
| Include      | Indica un archivo de configuración anexo que se integrará en el archivo apache2.conf. |
| Listen       | Indica el puerto en el que escucha el servidor.              |
| DocumentRoot | Indica el directorio que contiene los archivos html.         |

Ejemplo simple:

```
ServerRoot /etc/apache2 
User www-data 
Group www-data 
ErrorLog /var/log/apache2/error.log 
Listen 80 
DocumentRoot /var/www
```

Las directivas de contenedor tienen dos objetivos: agrupar un conjunto de directivas de configuración y aplicarlas a una parte limitada del servidor Apache.

```
<Directory /var/www/especial> 
  Options FollowSymLinks 
</Directory>
```

**validar** la sintaxis de un archivo de configuración antes de iniciar el servicio.

```bash
apache2ctl -t
apache2ctl -k start|stop # encender o apagar servicio manualmente
```



### Módulos

El servidor web Apache tiene una estructura modular. Estos módulos requieren a menudo elementos de configuración adicionales. Las directivas asociadas a los módulos deben añadirse también al archivo de configuración.

En este ejemplo, el módulo cargado es **dir_module**, cuya función es simplificar la escritura de las URL por los usuarios y mostrar un archivo html (en general index.html) incluso si este no se ha facilitado.

```bash
# LoadModule id_módulo archivo_módulo  
# directiva valor 
LoadModule dir_module /usr/lib/apache2/modules/mod_dir.so 
DirectoryIndex index.html
```

visualizar los módulos cargados. 

```bash
apache2 -l	# modulos compilados
apache2 -M 	# modulos cargados
a2enmod modulo
a2dismod modulo
```

Una construcción que ha estado recibiendo mucho apoyo últimamente, es el uso de separado `modules-available`y `modules-enabled`directorios. Estos directorios son subdirectorios dentro del directorio de configuración de Apache. Los módulos de `modules-enabled` son enlaces simbólicos de `modules-available` 

### Hosts virtuales

Si un servidor tiene que gestionar hosts virtuales, es porque debe albergar varios contenidos o sitios web distintos. Simplemente será necesario albergar cada uno de estos contenidos en directorios diferentes y debidamente identificados. 

Los directorios donde se alojaran los archivos de configuración de los hosts virtuales son `site-available` y `site-enable`

```bash
a2ensite nombre-archivo
a2dissite nombre-archivo
apachectl -t -D DUMP_VHOSTS	# ver todos los vhosts configurados
apachectl -S	# ver sitios web que se ejecutan actualmente
```



Una vez que se configuran los hosts virtuales, todo acceso al servidor se realiza por un host virtual, incluso si es el sitio básico.

Hay dos técnicas de implementación de hosts virtuales: 

- por dirección IP
- en función del nombre de host presente en la URL 

```bash
# por ip
<VirtualHost dirección_1:80> 
ServerName nombre1 
DocumentRoot dir1 
</VirtualHost> 
 
<VirtualHost dirección_2:80> 
ServerName nombre2 
DocumentRoot dir2 
</VirtualHost>

# por nombre de host
NameVirtualHost *:80 
 
<VirtualHost *:80> 
ServerName nombre1 
DocumentRoot dir1 
</VirtualHost>  
 
<VirtualHost *:80>  
ServerName nombre2 
DocumentRoot dir2 
</VirtualHost>
```

### Rendimiento

Puede usar la `MaxClients`configuración para limitar la cantidad de hijos que su servidor puede generar, lo que reduce la huella de memoria. Se recomienda utilizar `grep` a través del archivo de configuración principal de Apache para ver todas las directivas que comienzan con `Min`o`Max`.

Los valores predeterminados deberían proporcionar un equilibrio entre la  carga del servidor en reposo por un lado y la posibilidad de manejar  cargas pesadas por el otro.

### Restricciones de acceso

Apache ofrece múltiples posibilidades de restricción de acceso a usuarios y existen muchos medios para gestionar el acceso a datos.

#### Autentificación local

```bash
htpasswd -c archivo nombre_usuario	# creación primer usuario ( -c crea el archivo )
htpasswd archivo nombre_usuario 	# añadir cuenta
htpasswd -D archivo nombre_usuario 	# eliminar usuario
```

Habrá que cargar como mínimo el módulo **auth_basic** para permitir la autentificación mediante un archivo local, el módulo **authn_file** para gestionar esta autentificación y finalmente el módulo **authz_user**, que gestiona la autorización de acceso a las páginas protegidas.

```
LoadModule auth_basic_module /ruta/mod_auth_basic.so 
LoadModule authn_file_module /ruta/mod_authn_file.so 
LoadModule authz_user_module /ruta/mod_authz_user.so
```

Un ejemplo en la configuración seria:

```
<Directory /var/www> 
  AuthType basic 
  AuthUserFile /root/httpmdp 
  AuthName "Se necesita comprobar sus credenciales" 
  Require valid-user  
</Directory>
```

#### Autentificación LDAP

Los módulos necesarios para la autentificación LDAP son los siguientes:

- auth_basic
- authn_file
- authz_user
- authnz_ldap

```
<Directory /var/www> 
AuthName "Texto" 
AuthType Basic 
Require Valid-user 
AuthLDAPUrl ldap://192.168.1.11/ou=users,dc=direc,dc=es?cn?sub?objectclass=*
</Directory>
```

#### Autentificación simple .htaccess

Para permitir este tipo de autentificación se tiene que permitir el uso del archivo .htaccess en el directorio

```
<Directory /var/www/prot> 
AllowOverride all 
</Directory> 
```

Una vez permitido su uso se agrega la configuración en su interior `/var/www/prot/.htaccess` 

```
authType basic 
AuthName "Se necesita comprobar sus credenciales" 
Require valid-user 
AuthUserFile /etc/httpd/mdp 
```

| all        | Valor por defecto: Cualquier directiva se autoriza en los archivos .htaccess. |
| ---------- | ------------------------------------------------------------ |
| none       | Ninguna directiva se autoriza en los archivos .htaccess. Los archivos .htaccess serán ignorados. |
| AuthConfig | Autoriza las directivas relativas a los mecanismos de autentificación. |

> Se recomienda encarecidamente no aplicar la directiva AllowOverride All en el directorio raíz de su servidor web (¡valor por defecto!). Es mejor definir este valor a None, y crear una directiva Directory con la directiva AllowOverride configurada solamente para el directorio que nos interesa.

## 208.2 Configuración de Apache para HTTPS

SSL (Secure Socket Layer) es un protocolo de seguridad de la capa de aplicación. Funciona con muchos protocolos, pero su uso más extendido es para asegurar http (https). SSL proporciona servicios de autentificación, de confidencialidad y de control de la integridad.

certificado autofirmado

```bash
# openssl req -x509 -days dias-aspiracion -nodes -newkey rsa:tamaño -keyout archivo_clave -out archivo_certificado 
openssl req -x509 -days 365 -nodes -newkey rsa:1024 -keyout servidor.key -out certificado.pem 
```

| Comando openssl          |                                                              |
| ------------------------ | ------------------------------------------------------------ |
| req                      | Solicitud de certificado.                                    |
| -x509                    | Se desea un certificado autofirmado y no una petición de firma. |
| -nodes                   | La clave del servidor no debe estar protegida con contraseña. |
| -newkey rsa:tamaño       | Se crean nuevas claves asimétricas RSA cuyo tamaño se proporciona en número de bits. |
| -keyout archivo_clave    | El archivo que contiene la clave privada del servidor.       |
| -out archivo_certificado | El archivo que contiene el certificado del servidor.         |

los archivos de claves generados se guardan generalmente en:

```bash
/etc/ssl/certs	# debian
/etc/ssl/private	# debian
/etc/pki/tls/certs	# redhad
/etc/pki/tls/private	# redhad
```



### Cofiguración

El módulo necesario para el funcionamiento de SSL es mod_ssl.

```
LoadModule ssl_module /ruta/mod_ssl.so
```

Se añade la direccion de los archivos del certificado en la configuración

```
SSLEngine on
SSLCertificateFile /ruta/archivo_certificado 
SSLCertificateKeyFile /ruta/archivo_clave 
```

hay que solicitar al servidor que escuche por el puerto https y reiniciar el motor SSL que, una vez realizada la autentificación, permitirá cifrar las comunicaciones entre cliente y servidor.

```
Listen 443
```

Un ejemplo de configuración en virtualhost con SSL y redirección a https

```
<VirtualHost 196.70.8.10:443>
    ServerName myweb.org                        
    CustomLog /home/jor/logs/apache/access_myweb.log common           
    ErrorLog /home/jor/logs/apache/error_myweb.log   
    ScriptAlias /cgi-bin/ /home/jor/cgi-bin/
    DocumentRoot /home/jor/webapps/myweb
    SSLEngine on
    SSLCertificateFile /etc/letsencrypt/live/myweb.org/fullchain.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/myweb.org/privkey.pem
</VirtualHost>

<VirtualHost 196.70.8.10:80>
    ServerName myweb.org                        
    CustomLog /home/jor/logs/apache/access_myweb.log common           
    ErrorLog /home/jor/logs/apache/error_myweb.log
    RewriteEngine On
    RewriteCond %{HTTPS} off
    RewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI}
</VirtualHost>
```



## 208.3 Implementando Squid como proxy cache

Un servidor proxy se encarga de realizar una petición en nombre de un cliente a otro servidor mediante un protocolo determinado.

### cache

Todas las peticiones pasan por los proxy, el proxy obtiene los datos del servidor y los retransmite al cliente. En la mayoría de los casos, el servidor conserva en su disco una copia de estos datos para responder directamente a los sucesivos clientes que hagan las mismas peticiones.

### Configuración básica

El archivo de configuración se encuentra en `/etc/squid/squid.conf` en su interior se encuentra un número considerable de listas de control de acceso (ACL), así como de reglas definidas por defecto. 

 La configuración por defecto viene de manera natural como servidor de caché de oficio y protege las redes locales mediante una ruptura del tráfico. Antes de que pueda funcionar, el servidor todavía requiere una configuración mínima.

```
http_port número_de_puerto 
cache_dir ufs directorio tamaño dir_nivel_1, dir_nivel_2 
visible_hostname nombre_servidor 
```

| configuración básica |                                                              |
| -------------------- | ------------------------------------------------------------ |
| número_de_puerto     | El número de puerto en el que el servidor está a la escucha y que debe configurarse en los navegadores. El valor por defecto es 3128, y 8080 es un valor histórico muy común. |
| directorio           | El directorio en el que se almacenarán los datos que se pondrán en caché. |
| tamaño               | Tamaño máximo en MB para los datos puestos en caché. Valor por defecto: 100 MB. |
| dir_nivel_1          | Número máximo de subdirectorios de primer nivel del directorio de caché. Valor por defecto: 16. |
| dir_nivel_2          | Número máximo de subdirectorios de segundo nivel del directorio de caché. Valor por defecto: 256. |
| nombre_servidor      | Nombre de host del servidor proxy. Este nombre aparece especialmente en los registros de actividad. |

### Gestión de acceso

A continuación se trata de especificar quién puede o quién no puede acceder a Internet a través del servidor proxy.

```bash
acl nombre_lista tipo_acl A.B.C.D/M 
# El nombre de la lista creada. Valor alfanumérico cualquiera.
# tipo_acl src|dst
# A.B.C.D/M  ip/mascara, red/mascara rango/mascara

# ejemplo
acl all src all 
acl red_local src 192.168.1.0/24 
acl servidores_prohibidos dst 172.11.5.2-172.11.5.5/24
```

Qué tiene que hacer con estas ACL.

```bash
http_access autorización nombre_acl 
# autorización allow|deny

# ejemplo
acl servidores_prohibidos dst 172.11.5.2-172.11.5.5/24 
http_access deny servidores_prohibidos 
```



