# Que es mutt?

mutt es un programa pra enviar correos desde terminal, en el siguiente ejemplo lo usare para notificar a diversos usuarios que se elimina su cuenta.

#### Install mutt

**CentOS**

```bash
sudo yum install mutt
```

**Ubuntu**

```bash
sudo apt-get install mutt
```



#### Configure Mutt

**Create**

```bash
mkdir -p ~/.mutt/cache/headers
mkdir ~/.mutt/cache/bodies
touch ~/.mutt/certificates
```



**Create mutt configuration file muttrc**

```bash
touch ~/.mutt/muttrc
```



**Open muttrc**

***vim ~/.mutt/muttrc***

```bash
set ssl_starttls=yes
set ssl_force_tls=yes
set imap_user = 'jorge@gmail.com'
set imap_pass = '(123456789)'
set from='jorge@gmail.com'
set realname='Jorge '
set folder = imaps://imap.gmail.com/
set spoolfile = imaps://imap.gmail.com/INBOX
set postponed="imaps://imap.gmail.com/[Gmail]/Drafts"
set header_cache = "~/.mutt/cache/headers"
set message_cachedir = "~/.mutt/cache/bodies"
set certificate_file = "~/.mutt/certificates"
set smtp_url = 'smtps://jorge@smtp.gmail.com:465/'
set smtp_pass = "(123456789)"
set move = no
set imap_keepalive = 900
```



#### script

El siguiente escript cogera una lista de correos de un fihero y les enviara una nottificación

fichero de correos a enviar:

***correos.txt***

```bash
ism477@correu.org
ism238@correu.org
ism587@correu.org
```

***script-correo.sh***

```bash
#!/bin/bash

ism=`cat correos.txt | sed -r 's/^([^@]*)@.*/\1/'`
vueltas=`cat correos.txt | wc -l`
correo=`cat correos.txt `

lista_ism=()
lista_correos=()

# añado a una lista los usuarios de correo.txt
cont=0
for i in $ism;
do
      lista_ism[$cont]=$i
      let cont+=1
done

# añado a una lista los correos de correo.txt
cont=0
for i in $correo;
do
      lista_correos[$cont]=$i
      let cont+=1
done

# mando email masivo
cont=0
for i in `seq 1 $vueltas`;
do
      echo "Se comunica que al usuario ${lista_ism[$cont]} se borrara su cuenta" | mutt -s 'borrado usuario' ${lista_correos[$cont]}
      let cont+=1
done
```

