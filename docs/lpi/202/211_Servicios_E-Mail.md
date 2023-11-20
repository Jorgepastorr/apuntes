# 211 Servicios de E-Mail

## 211.1 Utilizando servidores de e-mail

Los MTA (Mail Transfer Agent) son los servidores que se encargan del envío y la recepción de correo electrónico y constituyen la espina dorsal de cualquier sistema de correo en redes IP. Cada servidor de correo público es un MTA y todos los MTA se comunican entre ellos mediante el protocolo SMTP.

El **protocolo SMTP** (Simple Mail Transfer Protocol) se utiliza para transmitir correos electrónicos a servidores de correo.  SMTP puede utilizarse desde un cliente de correo (Outlook, Thunderbird, etc.) para enviar un mensaje electrónico a su servidor de correo, pero también entre los servidores de correo del emisor y los del destinatario.

La lectura del correo puede realizarse directamente en el servidor o a través de un **MDA** (Mail Delivery Agent) con un protocolo de recepción de correo (POP o IMAP).

```bash
alfa:~# telnet 192.168.199.10 25 
Trying 192.168.199.10... 
Connected to 192.168.199.10. 
Escape character is 'ˆ]'. 
ehlo usuario.com 
220 alfa.localdomain ESMTP Postfix 
250-alfa.localdomain 
250-PIPELINING 
250-SIZE 1000 
250-VRFY 
250-ETRN 
250-ENHANCEDSTATUSCODES 
250-8BITMIME 
250 DSN 
MAIL FROM: <usuario@usuario.com> 
250 2.1.0 Ok 
RCPT TO: <usuario> 
250 2.1.5 Ok 
DATA 
354 End data with <CR><LF>.<CR><LF> 
. 
Buenas 
¿Qué tal estás? 
. 
250 2.0.0 Ok: queued as E264474E02 
QUIT 
221 2.0.0 Bye 
Connection closed by foreign host. 
alfa:~#
```

**Sendmail** es el más antiguo y puede que el más famoso MTA utilizado en Internet de la historia. Debido a su antiguedad y su falta de opciones de seguridad en su dia ha participado en la retransmisión de millones de spam. 

Hoy en día se puede depositar total confianza y es  uno de los MTA más potentes y rápidos del mercado. Por otro lado, las dificultades derivadas de la configuración de Sendmail pueden desalentar a los más entusiastas.

**Exim** es un MTA relativamente reciente  que tiene como objetivos la robustez y la flexibilidad. Es el MTA ofrecido por defecto en las distribuciones Debian y en la mayoría de sus derivadas.

**Postfix** es, en el mundo del open source, el MTA más popular y casi el más fácil de configurar. Muchos servicios de alojamiento y proveedores de servicios de Internet utilizan Postfix para administrar las cuentas de correo de sus clientes.

### Configuración Postfix

la configuración de postfix se encuentra en `/etc/postfix`  los dos archivos principales son `main.cf y master.cf` 

`main.cf` especifica un subconjunto de todos los parámetros que controlan el funcionamiento del sistema de correo Postfix.  Los parámetros que no se muestran se obtiene el valor por defecto **postconf(5)** muestra todos los parámetros o `postconf -d`.

En Debian tiene diferentes ejemplos de configuración en `/usr/share/postfix/man.cf.*` 

`master.cf` define cómo un programa cliente se conecta a un servicio y qué programa demonio se ejecuta cuando se solicita un servicio.

Antes de que se pueda utilizar postfix, necesita saber:

```bash
myorigin = dominio_origen 	# qué nombre de dominio usar para el correo saliente
mydestination = dominio_destino # para qué dominios recibir correo 
mynetwork = red/máscara_de_bits 
relayhost = relays_MTA 	# qué método de entrega usar 
```

|                     | Archivo main.cf: parámetros principales                      |
| ------------------- | ------------------------------------------------------------ |
| dominio_origen      | Es el dominio visto desde el exterior.                       |
| dominio_destino     | El servidor gestiona correos con destino a este dominio.     |
| red/máscara_de_bits | El servidor permite reenviar los correos provenientes directamente de esta red. |
| relays_MTA          | Si se usa el parámetro relayhost, los correos se envían al exterior exclusivamente a través del MTA relays_MTA. |

Con esta configuración mínima el servidor es capaz de realizar sus tareas de MTA. Los mensajes se almacenan en el directorio `/var/spool/mail/<username>` con el nombre del usuario destinatario.

```bash
# comprobar configuración
postfix check
postconf -n
```



|        | Comando postfix: acciones comunes                            |
| ------ | ------------------------------------------------------------ |
| status | Muestra el estado funcional del servicio.                    |
| stop   | Detiene el servicio de manera controlada. Los procesos en ejecución están autorizados para finalizar su ejecución. |
| start  | ealiza comprobaciones e inicia el servicio.                  |
| check  | Comprueba la validez del entorno de funcionamiento del servicio. |
| reload | Recarga la configuración. Preferible a un stop/start.        |
| abort  | Detiene el servicio inmediatamente. Los procesos en ejecución se detienen bruscamente. |
| flush  | Intenta mandar todos los correos pendientes: los que ya han dado error y los que están a la espera de un nuevo intento. |

#### 

#### Usuarios

Un MTA tiene que gestionar las cuentas de correo de su dominio, lo que implica que el servidor tiene que gestionar la lista de usuarios que tienen una cuenta de correo en el dominio.

Para gestionar usuarios puede utilizar cuentas locales, ldap, bases de datos, ...

La solución más simple, siempre disponible y que no necesita ninguna configuración particular, es utilizar directamente las cuentas de usuario del sistema Linux.

#### Alias

Puede que un usuario tenga varias cuentas de correo, y por eso utilizamos los alias.

Postfix utiliza el archivo de declaración de alias `/etc/aliases` y lo hace base de datos mediante el comando `postalias`

> cualquier modificación del archivo `/etc/aliases` ira acomañada de la ejecución de `postalias /etc/aliases`

```
# /etc/aliases 
mailer-daemon: postmaster 
postmaster: root 
hostmaster: root 
usenet: root 
news: root 
webmaster: root 
root: usuario


alfa:~# postalias /etc/aliases 
```



### Dominios Virtuales

Puede suceder que se desee gestionar varios dominios de correo. Esta tarea la cumplen a la perfección los dominios virtuales.

Anteriormente en la directiva **mydestination** del archivo `main.cf` se a asignado el dominio principal, coherente con el nombre completo de servidor, se llama dominio canónico.  Si se desea administrar otros dominios, habrá que declararlos primeramente usando la directiva **virtual_alias_domain**.

```
virtual_alias_domain dominio2, dominio3 
```

Hay que especificar qué cuenta de usuario se asigna a qué cuenta de correo y para qué dominio. Esto se hace mediante un archivo especificado en la configuración de `main.cf`

```
 virtual_alias_maps = hash:/etc/postfix/virtual
```

```bash
root@servidor# cat /etc/postfix/virtual 
toto@dominio.com toto 
titi@dominio.com titi 
usuario@dominio.com usuario 

root@servidor# postmap /etc/postfix/virtual 
root@servidor# postfix reload
```

### Cuotas

Se puede limitar el espacio de disco consumido por las cuentas de correo.

```
mailbox_size_limit = tamaño_máx_cuenta 
message_size_limit = tamaño_máx_correo 
```

### Logs

Postfix utiliza syslog para su registro

```
    mail.err    /dev/console
    mail.debug  /var/log/maillog
```

El uso `egrep '<reject|warning|error|fatal|panic>' /var/log/maillog` le ayudará a encontrar cualquier problema que pueda encontrar el postfix. También hay utilidades de terceros `pflogsumm` que pueden generar estadísticas a partir del registro de Postfix.

### Comandos de la capa de emulación de Sendmail

Ciertos comandos que se incluyeron originalmente con el paquete sendmail también están disponibles con Postfix.

```bash
mailq| sendmail -bp| postqueue -q # ver cola de correo
newaliases	# generar archivo de alias
```



## 211.2 Gestionar la entrega

Tareas como la redacción de correos o la lectura de los correos entrantes se realizan desde un cliente de correo. Sin embargo, hasta que se configure un cliente de correo para enviar correos, es práctico poder utilizar el comando tradicional **mail** directamente desde el servidor.

```bash
# enviar correo
mail [-v] [-s asunto] [-c direcciones] [-b direcciones] destinatario
-v  # activa modo depuración
-s  # el asunto del mensaje
-c  # destinatarios en copia
-b  # destinatarios en copia oculta
-a  # archivo adjunto

# enviar en modo script
mail -s "asunto" < /tmp/aviso.txt destinatario@mail.org

# visualizar correo
mail 
mail -u user
n   # leer siguiente mensaje
h   # ver lista de mensaje
q   # salir y guardar cambios
x   # salir sin guardar cambios
r [num_message] #responder mensaje actual (indicado por >) o indicar nuúmero 
p   # mostrar el mmensaje otra vez
d [num_message o lista] # borrar mensaje actual o indicado por un número 2  4,9 1-4
```

> El comando mail usa únicamente el formato mbox. Por lo tanto, no se puede utilizar si se usa el formato maildir.

### mbox y maildir

Una vez que un mensaje ha sido recibido por un MTA, se tiene que almacenar a la espera de la recepción por parte de un usuario. 

**mbox**  Es un formato rudimentario y bastante antiguo, en el que todos los mensajes se concatenan y un único archivo contiene todos los correos recibidos. Esto puede probocar situaciones catastroficas si dos programas intentas editar el mismo archivo.

El formato **maildir** utiliza una estructura de directorios para almacenar los correos recibidos por un usuario. Cualquier operación realizada en un mensaje no afecta, por tanto, al resto de los datos y así solucionando los problemas de mbox.

Declarar formato maildir en `main.cf`

```
home_mailbox = Maildir/
```

### Procmail

Se puede indicar al MTA que procese los mensajes entrantes antes de almacenarlos. Postfix puede designar a un programa de terceros para este propósito. El más conocido de todos ellos es procmail. 

procmail se encarga de procesado de correos entrantes como. reorganización, filtrado, llamar a otro programa para aplicar procesados mas complejos.

Declaración de uso de procmail en `main.cf`

```
mailbox_command = /usr/local/bin/procmail
```

Procmail lee su configuración del archivo **.procmailrc**, que se encuentra en el directorio local del usuario.

```
:0 flags 
condición 
acción 
```

| :0        | Señal comienzo de una regla                                  |
| --------- | ------------------------------------------------------------ |
| flags     | Opcional. sobre que debe aplicarse la búsqueda. H cabecera (por defecto), B para el cuerpo |
| condición | Expresión regular que permite aislar los correos que se verán afectados por la regla. |
| acción    | Qué hacer con los mensajes seleccionados.                    |

```
:0 
* ˆFrom.*toto 
amigos/toto
```

### Sieve

Dovecot Sieve es un lenguaje de secuencias de comandos que se puede utilizar  para preprocesar y clasificar el correo electrónico entrante. También se puede utilizar para clasificar el correo electrónico de las listas  de correo, filtrar el correo no deseado y enviar respuestas automáticas.

Declaración de uso de sieve en `main.cf`

```
mailbox_command = /usr/lib/dovecot/dovecot-lda -a "$RECIPIENT"
```

Habilitar el soporte de sieve en dovecot `15-lda.conf`

```
    lda_mailbox_autocreate = yes
    lda_mailbox_autosubscribe = yes
    protocol lda {
      mail_plugins = $mail_plugins sieve
    }
```

El archivo de configuración `90-sieve.conf`necesita los siguientes ajustes:

```
    plugin {
        sieve = ~/.dovecot.sieve
        sieve_dir = ~/sieve
        sieve_default = /var/lib/dovecot/sieve/default.sieve
        sieve_global_dir = /var/lib/dovecot/sieve
    }
```

|         | Comandos de control de sieve                                 |
| ------- | ------------------------------------------------------------ |
| address | referencia a una dirección de correo                         |
| allof   | "and Y" logico, todas las condiciones han de ser positivas   |
| anyof   | "or O" logico, alguna a de ser verdadera                     |
| exists  | comando prueba si un encabezado sale con el mensaje.         |
| false   | El `false`comando simplemente devuelve falso                 |
| header  | prueba si un encabezado coincide con la condición establecida |
| not     | debe usarse junto con otro control                           |
| size    | junto con `:over` o `:under` especifica un tamaño            |
| true    | El `true`comando simplemente devuelve verdadero.             |

|          | Comandos de acción                                           |
| -------- | ------------------------------------------------------------ |
| keep     | hacen que el mensaje se guarde en la ubicación predeterminada. |
| redirect | redirige el mensaje a la dirección que se especifica en el argumento sin alterar el mensaje |
| discard  | elimine silenciosamente sin enviar ninguna notificación      |

Ejemplos:

```
    if size :over 2M { 
      discard; 
    }
  
    if exists "x-virus-found" {
      redirect "admin@example.com";
    }
```

### Alternativas al correo

Se pueden enviar mensajes cortos con los comandos **write** y **wall**. El comando **write** permite enviar un mensaje a un usuario conectado, mientras que **wall** (write all) difunde el mensaje a todos los usuarios conectados.

```bash
write user
(introducir el mensaje terminándolo con Ctrl-D) 
write < archivo_mensaje 

wall 
(introducir el mensaje terminándolo con Ctrl-D) 
wall < archivo_mensaje 
```

`Issue` e `issue.net` son archivos que su contenido se mostrara en la autentificación

```bash
/etc/issue      # se muestra antes de la solicitud de identificación local 
/etc/issue.net  # se muestra antes de la autentificación de un usuario que se conecte por telnet.
```

El contenido del archivo **/etc/motd** (Message Of The Day) se visualiza después de la apertura de una sesión con éxito.

## 211.3 Gestionar la salida

Un MTA se limita a recibir mensajes y guardarlos, el MUA  (cliente de correo) funciona con protocolos IMAP o POP y el MTA no los gestiona, por lo tanto se necesita un MDA para gestión de dichos protocolos y la recepción de correo al usuario.

El **protocolo POP3** funciona a través del puerto 110 y usa TCP como protocolo de transporte. Descarga los mensajes desde un buzón de usuario a un cliente de correo. Sin embargo, cada vez es más frecuente configurar POP desde el cliente para que deje una copia de los correos en el servidor.

El protocolo **IMAP4** funciona a través del puerto 143 y usa TCP como protocolo de transporte. Descarga las cabeceras de los correos desde el servidor y el cliente decide a continuación la acción que desea realizar con estos mensajes.

### Courier

El agente de transferencia de correo Courier (MTA) es un servidor que se ha creado para proporcionar el conjunto de servicios comunes de gestión de correo electrónico, es modular sus componentes pueden utilizarse solos para proporcionar un servicio concreto. Proporciona servicios ESMTP, IMAP, POP3, correo web y listas de correo dentro de un marco único y coherente.

Courier es solo compatible con el formato maildir.

#### Configuración

Por defecto viene con la configuración listo para su funcionamiento en una situación estándar. Su configuración se encuentra  en `/etc/courier/` en los archivos `pop3d y imapd`.

Si se  ha modificado la dirección de maildir para los usuarios habrá que especificarla en:

```
MAILDIRPATH=nombredirmaildir 
```

Si se tiene diferentes interfaces físicas y solo queremos servir en una se modificará:

```
address = dirección_interfaz 
```

Courier tiene la herramienta `authtest` para simular la identificación de un cliente

```
authtest usuario contraseña 
```



### Dovecot

Dovecot es un servidor de correo electrónico IMAP y POP3 , Se ha desarrollado con el objetivo de proporcionar el máximo rendimiento y seguridad. Su despliege es simple, pero las  posibilidades de configuración son innumerables y, a menudo, desalentadoras.

Dovecot soporta de forma nativa los formatos de buzón mbox y maildir.

#### Configuración

Su archivo de configuración se encuentra en `/etc/dovecot/dovecot.conf y conf.d` se puede configurar el cliente de correo para utilizar los protocolos POP o IMAP sobre SSL, aportando confidencialidad al tramo cliente/servidor, aun que la verdadera seguridad en el contenido de los mensajes solo puede obtenerse con un protocolo que gestione de extremo a extremo, como SMIME.

El archivo de configuración es muy extenso, para comprobar un parámetro de configuración te puedes ayudar con `dovecot -a`

```bash
alfa:/etc/dovecot# dovecot -a | wc -l 
139  
alfa:/etc/dovecot# dovecot -a | head -20 
# 1.0.15: /etc/dovecot/dovecot.conf  
base_dir: /var/run/dovecot  
log_path:  
...
```

Para su utilizar Dovecot  necesitamos configurar varios parámetros: autenticación, ubicación del  buzón, configuración SSL y la configuración como servidor POP3.

Dovecot admite los siguientes mecanismos de autentificación que no son de texto sin  formato: `CRAM-MD5, DIGEST-MD5, SCRAM-SHA1, SCRAM-SHA-256, APOP, NTLM,  GSS-SPNEGO, GSSAPI, RPA, ANONYMOUS, OTP y SKEY, OAUTHBEARER, XOATH2 y  EXTERNAL` .  

Por defecto solo viene habilitado PLAIN en `10-auth.conf`

```
auth_mechanisms = plain login cram-md5
```

En `10-mail.conf` podemos configurar qué ubicación de buzón queremos usar:

```
mail_location = maildir:~/Maildir
mail_location = mbox:~/mail:INBOX=/var/mail/%u
```



##### SSL

Dovecot incluye un script `/usr/share/dovecot/mkcert.sh` para crear certificados SSL autofirmados.

Las opciones importantes de configuración de SSL se pueden encontrar en el archivo: 10-ssl.conf

```bash
ssl = required
ssl_cert = </etc/dovecot/dovecot.pem
ssl_key = </etc/dovecot/private/dovecot.pem

ssl_cipher_list = AES256+EECDH:AES256+EDH	# que tipo de cifrado admitir
ssl_prefer_server_ciphers = yes
ssl_dh_parameters_length = 2048

```



Una vez configurado SSL se define por donde escuchar en `10-master.conf`

```bash
    service imap-login {
      inet_listener imap {
            port = 0
       #port = 143
     }
      inet_listener imaps {
          port = 993
          ssl = yes
     }
    }

    service pop3-login {
      inet_listener pop3 {
            port = 0
       #port = 110
     }
      inet_listener pop3s {
            port = 995
            ssl=yes
     }
    }
```

