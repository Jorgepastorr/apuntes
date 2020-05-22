# The crazy thing!

- [Ejercicio15 Ldap-remot i phpldapadmin-local](#ejercicio15-ldap-remot-i-phpldapadmin-local)
  - [Desplegar el servei ldap](#desplegar-el-servei-ldap)
  - [Desplegar el servei phpldapadmin](#desplegar-el-servei-phpldapadmin)
- [Ejercicio16: Ldap-local i phpldapadmin-remot](#ejercicio16-ldap-local-i-phpldapadmin-remot)
  - [Engegar ldap i phpldapadmin i que tinguin connectivitat](#engegar-ldap-i-phpldapadmin-i-que-tinguin-connectivitat)

## Ejercicio15 Ldap-remot i phpldapadmin-local

Desplegem dins d’un container Docker (host-remot) en una AMI (host-destí) el servei ldap amb el firewall de la AMI només obrint el port 22. Localment al host de l’aula (host-local) desplegem un container amb phpldapadmin. Aquest container ha de poder accedir a les dades ldap. des del host de l’aula volem poder visualitzar el phpldapadmin.

**Desplegar el servei ldap** 

- en el host-remot AMI AWS EC2 engegar un container ldap sense fer map dels ports.
-  en la ami cal obrir únicament el port 22
-  També cal configurar el /etc/hosts de la AMI per poder accedir al container ldap per nom de host (preferentment). 
-  verificar que des del host de l’aula (host-local) podem fer consultes ldap. 



**Desplegar el servei phpldapadmin**

-  engegar en el host de l’aula (host-local) un container docker amb el servei phpldapadmin fent map del seu port 8080 al host-local (o no).
- crear el túnel directe ssh des del host de l’aula (host-local) al servei ldap (host-remot) connectant via SSH al host AMI (host-destí).
-  configurar el phpldapadmin per que trobi la base de dades ldap accedint al host de l’aula al port acabat de crear amb el túnel directe ssh.
-  Ara ja podem visualitzar des del host de l’aula el servei phpldapadmin, accedint al
  port 8080 del container phpldapadmin o al port que hem fet map del host de l’aula (si
  és que ho hem fet).





### Desplegar el servei ldap

Despliego el servicio ldap en un docker de aws .

```bash
[fedora@aws ~]$ docker run --rm --name ldap.edt.org -h ldap.edt.org --net mynet -d jorgepastorr/ldapserver19 initdbedt
```

Asigno la resolución del contenedor en `/etc/hosts` de la instancia ami 

```bash
[fedora@aws ~]$ echo '192.168.16.2 ldap.edt.org' | sudo tee -a /etc/hosts
```

Compruebo que en la ami solo esta abierto el puerto 22

```bash
[fedora@aws ~]$ nmap localhost
PORT   STATE SERVICE
22/tcp open  ssh
```

Desde casa creo un túnel directo, abre puerto 50000 del host-local hacia el host-destino (ami) que redirige el túnel al container ldap en el puerto 389. Y compruebo que desde host-local (casa) que puedo acceder a la base de datos ldap desde el puerto 50000.

```bash
casa ➜ ssh -i key-aws-educate.pem  -L 50000:ldap.edt.org:389  fedora@3.91.49.124

casa ➜ ldapsearch -x -LLL -h localhost -p 50000 -b 'dc=edt,dc=org' dn
dn: dc=edt,dc=org
dn: ou=grups,dc=edt,dc=org
dn: ou=usuaris,dc=edt,dc=org
dn: cn=hisx1,ou=grups,dc=edt,dc=org
dn: cn=hisx2,ou=grups,dc=edt,dc=org
dn: cn=hisx3,ou=grups,dc=edt,dc=org
...
```



### Desplegar el servei phpldapadmin

En aws existe un ldap desplegado pero no tengo acceso directo desde casa solo ssh. 

pasos para incorporar phpldapadmin local hacia aws:



Abro un túnel directo desde hot-local (casa) en la interficie mynet (172.19.0.1) puerto 50000 hacia host-destino (aws) y este redirecciona a host-remoto (container ldap) en el puerto 389.

```bash
casa ➜ ssh -i key-aws-educate.pem  -L 172.19.0.1:50000:ldap.edt.org:389  fedora@3.91.49.124
```



Despliego el container phpldapadmin en interactivo, por que tengo que cambiar la configuración. (También exporto puerto 80 a 8080 pero no es necesario, solo por comodidad.)

```bash
casa ➜ docker run --rm --name php -h php -p 8080:80 --net mynet -it jorgepastorr/phpldapadmin /bin/bash
```



Cambio la configuración del archivo `config.php`  a la entrada del túnel creado para que redireccione hasta el container ldap de aws

```bash
[root@php] vim config.php
$servers->setValue('server','host','172.19.0.1');
$servers->setValue('server','port',50000);

# enciendo el servicio phpldapadmin con la nueva configuración
[root@php] bash startup.sh
```



Desde el navegador de casa accedemos al puerto expuesto por el container phpldapadmin, y accedemos a la base de datos ldap.

```bash
browser localhost:8080/phpldapadmin
login --> user 'cn=Manager,dc=edt,dc=org'
	  --> password 'secret'
```





## Ejercicio16: Ldap-local i phpldapadmin-remot


Obrir localment un ldap al host. Engegar al AWS un container phpldapadmin que usa el ldap del host de l’aula. Visualitzar localment al host de l’aula el phpldapadmin del container de AWS EC2. Ahí ez nà.

**Engegar ldap i phpldapadmin i que tinguin connectivitat:**

- Engegar localment el servei ldap al host-local de l’aula.

-  Obrir un túnel invers SSH en la AMI de AWS EC2 (host-destí) l ligat al servei ldap del host-local de l’aula.
  
-  Engegar el servei phpldapadmin en un container Docker dins de la màquina AMI. cal confiurar-lo perquè connecti al servidor ldap indicant-li la ip de la AMI i el port obert per el túnel SSH.
  
-  **nota** atenció al binding que fa ssh dels ports dels túnels SSH (per defecte són
  només al localhost).



**Ara** cal accedir des del host de l’aula al port 8080 del phpldapadmin per visualitzar-lo. Per fer-ho cal:

- en la AMI configutat el /etc/hosts per poder accedir per nom de host (per exemple php) al port apropiat del servei phpldapadmin.
- establir un túnel directe del host de l’aula (host-local) al host-remo t phpldapadmin passant pel host-destí (la AMI).
-  Ara amb un navegador ja podem visualitzar localment des del host de l’aula el phpldapadmin connectant al pot directe acabat de crear.
- **nota** atenció al binding que fa ssh dels ports dels túnels SSH (per defecte són
      només al localhost).





### Engegar ldap i phpldapadmin i que tinguin connectivitat

En esta practica enciendo un ldap local, un phpldapadmin en aws que mira los datos del ldap local mediante un tunel inverso ssh, y con otro tunel directo de local a aws puedo ver el phpldapadmin desde mi navegador local.



Despliego en local  el server ldap con puertos mapeados en 389 localhost (no es necesario mapear puertos, peri si cómodo)

 ```bash
casa ➜ docker run --rm --name ldap.edt.org -h ldap.edt.org -p 389:389 --net mynet  -d jorgepastorr/ldapserver19:entrypoint initdbedt
 ```



En aws configuro el servidor sshd para que los túneles inversos puedan hacer bind en diferentes interficies , por defecto solo permite localhost.

```bash
[fedora@aws ~]$ vi /etc/ssh/sshd_config
...
GatewayPorts yes
...
```



En aws arranco un contenedor con phpldapadmin y en la configuración le asigno que recoja los datos de ldap en el gateway de su red y el puerto 50000 que abriré un túnel en el siguiente paso.

```bash
[fedora@aws ~]$ docker run --rm --name php -h php --net mynet  -it jorgepastorr/phpldapadmin /bin/bash

[root@php] vim config.php
$servers->setValue('server','host','192.168.16.1');
$servers->setValue('server','port',50000);

[root@php] bash startup.sh 
```



Desde local abro un túnel inverso desde el servicio local ldap `localhost:389` hasta el host-destino (aws) que hace un bind de interficie `192.168.16.1:50000`. esta interficie es el gateway de phpldapadmin de aws. Para que phpldapadmin pueda hacer consultas de la base de datos ldap.

```bash
casa ➜ ssh -i key-aws-educate.pem  -R 192.168.16.1:50000:localhost:389  fedora@3.91.49.124
```

Compruebo, que el bind esta bien echo:

```bash
[fedora@aws ~]$ netstat -tan4
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State      
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN     
tcp        0      0 0.0.0.0:50000           0.0.0.0:*               LISTEN  
```



Creo una resolución de nombre para el docker phpldapadmin

```bash
[fedora@aws ~]$ echo '192.168.16.2 ldapadmin' | sudo tee -a /etc/hosts
```



Para finalizar desde local creo un túnel directo que abre el puerto `localhost:8080` del host-local pasando por el host-desti (aws) y este redireccionando a host-remoto `ldapadmin:80` contenedor de aws.

```bash
casa ➜ ssh -i key-aws-educate.pem  -L 8080:ldapadmin:80  fedora@3.91.49.124
```



Desde el navegador de casa accedemos a phpldapadmin de aws, por el túnel creado directo.

```bash
browser localhost:8080/phpldapadmin
login --> user 'cn=Manager,dc=edt,dc=org'
	  --> password 'secret'
```



