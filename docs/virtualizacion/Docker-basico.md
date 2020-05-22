# Docker

## Instalar

Debian y raspbian.

Para otras distros mirar el enlace.

https://docs.docker.com/install/linux/docker-ce/debian/#set-up-the-repository

```bash
sudo apt-get update

# dependencias necesarias
sudo apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common

# añadir clave oficial del repositorio
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
```

<!-- tabs:start -->

#### **debian**

```bash
# añadir repositorio
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
```

#### **raspbian**

```bash
# añadir repositorio
echo "deb [arch=armhf] https://download.docker.com/linux/debian \
     $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list
```

<!-- tabs:end -->

```bash
# instalar docker y docker compose
sudo apt-get update
sudo apt-get install docker-ce docker-compose
```

**Añadir usuario al grupo docker**

```bash
sudo usermod -aG docker $(whoami)
```

## Comandos básicos

### Visualización

```bash
# contenedores
docker ps        # ver contenedores en ejecucion
docker ps -a     # Todos los contenedores
docker inspect docker-nginx    # informacion del contenedor
docker network inspect joomla_default  # informacion de la red del contenedor
docker stats contenedor        # ver gasto del contenedor, mem, cpu, net.
docker logs -f contenedor        # logs

# imagenes
docker images             # ver imagenes
docker search nginx        # buscar imagenes de https://hub.docker.com/r/library/
docker pull nginx            # descargar imagen    
docker pull docker.io/nginx    # descargar imagen
docker history -H apache-centos    # informacion delas capas de la imagen, run, cmd, etc...

# volumenes
docker volume ls     # listar volumenes
docker volume ls -f dangling=true    # listar volumenes huérfanos
```

### Acciones

```bash
docker rmi imagen        # borrar imagen
docker rm contenedor    # borrar contenedor
docker rm -f contenedor # borrar contenedor en marcha
docker rm -fv contenedor # borrar contenedor con sus volumenes
docker start docker-nginx    # arrancar contenedor ( tiene que estar creado )
docker stop docker-nginx    # para contenedor
docker restart docker-nginx    # reiniciar contenedor
docker pause docker-nginx    # pausar
docker unpause docker-nginx    # despausar
docker rename old-nombre new-nombre    # renombrar contenedor

docker volume rm                  # borrar volumen 
docker create volume my-volume    # crear volumen

docker build -t nombre-conenedor .    # crear imagen con dockfile
docker attach docker-nginx         # acceder a contenedor (si está en marcha)
docker exec -i -t docker-nginx /bin/bash    # acceder a un contenedor o mandar orden
```

#### Limpieza

```bash
docker images -f dangling=true    # ver imágenes huérfanas 
docker images -f dangling=true -q | xargs docker rmi    # eliminar imágenes huérfanas
docker rm $(docker ps -a -q)    # borrar todos los contenedores
docker rmi $(docker images -q)    # borrar todas las imagenes
```

## Dockerfile

Dockerfile es un archivo de texto donde introducimos  la configuración para crear imágenes docker.

```bash
docker build -t nombre-conenedor .
```

La sintaxis de configuración mínima es la siguiente.

```dockerfile
FROM centos
RUN yum install httpd -y
CMD apachectl -DFOREGROUND
```

- `from` imagen base donde correr
- `run` ordenes a ejecutar, actualizaciones , instalaciones, etc...
- `cmd` activación del servicio en primer plano.

### Contenido

```bash
FROM     # imagen base
RUN        # ejecucion de ordenes
COPY/ADD    # copiar archivos locales dentro de la imagen
ENV        # definir variables de entorno que utilizaras en la creación de la imagen
WORKDIR    #  moverse a un directorio de trabajo ( un cd )
EXPOSE    # exponer puertos
LABEL    # etiquetas a añadir, version, autor, descripción, etc..
USER    # cabiar de usuario, ( tiene que existir )
VOLUME    # Punto de montage  anonimo
CMD        # ejecucion de servicio, o script final
```

- `COPY/ADD` : hacen prácticamente lo mismo, la diferencia es que `ADD`  permite descargar los archivos desde una url, sin tener que tenerlos localmente.

`.dockerignore`  es un archivo de texto plano donde le indicamos que directorios o archivos ignorar cuando creamos una imagen con `docker build`.

#### Buenas practicas

Respecto a la creación de archivos dockerfile hay unas normas sociales de construcción.

El Dockerfile tiene que ser:

- Efímero:  se tiene que poder destruir con facilidad.
- Un servicio por contenedor, siempre que sea posible.
- Mínimo peso posible, y no agregar paquetes innecesarios.
- Buena legibilidad usar multilínea `\` si es necesario.
- Añadir labels, autor, versión, descripción.

### Multi Stage Build

Multi stage build es una forma de ahorrar espacio en una imagen, copiando contenido de una imagen a otra.

En este ejemplo creare un app en una imagen esta generará contenido adicional que no quiero tener, por lo tanto copiare la app compilada en otra imagen para ahorrar espacio.

```dockerfile
FROM maven:3.5-alpine as builder
COPY app /app
RUN cd /app && mvn package

FROM openjdk:8-alpine
COPY --from=builder /app/target/my-app-1.0-SNAPSHOT.jar /opt/app.jar
CMD java -jar /opt/app.jar
```

```bash
debian  ➜ docker build -t multi-stage .
```

```bash
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
multi-stage         latest              3051e85589f3        21 seconds ago      105MB
<none>              <none>              6b149ba281fe        37 seconds ago      131MB
openjdk             8-alpine            e9ea51023687        2 days ago          105MB
maven               3.5-alpine          fb4bb0d89941        4 months ago        119MB
```

Explicación de todo esto. Obviamente tenemos las imágenes oficiales de maven, y openjdk que hemos utilizado de base.

Después tenemos la 2ª línea una imagen huérfana, que es la utilizada para compilar la app, podemos ver que se a inflado 11MB en dependencias de su base maven.

Por ultimo tenemos la imagen multi-stage donde hemos copiado la app compilada, por lo tanto podríamos borrar todas las demás imágenes y ahorrar ese espacio de mas que no necesitamos de nada.

## Contenedores

Los contenedores se crean a partir de una imagen y son los encargados de mantener activos los servicios.

```bash
--name nombre-contenedor
-p 8000:80        # exponer puerto 8000 puerto local 80 puerto contenedor
-v ./path/local:/path/to/image    # punto de montage comun --volume=host-dir:container-dir:options
-it    centos /bin/bash    # tty interactive
-e "prueba1=1234"        # añadir variable de entorno
-cp archivo contenedor:ruta    # copiar archivo dentro de un contenedor
--rm -it    # genera contenedores temporales, una vez sales de la onsola se elimina


# limitar recursos
-m "500mb"        # limitar MiB de memoria ue puede usar
--cpuset-cpus 0-1    # numeros de cpu permito usar
```

**Sintaxis:**

```bash
#            nombre contenedor     puertos   nombre de imagen
docker run --name docker-nginx   -p 8000:80      nginx
```

Ejemplos crear contenedores

```bash
# contendor interactivo, puedes acceder a el
docker run -dti --name centos1 centos

# Crear contenedor con directorio local montado en contenedor
docker run --name docker-nginx -p 8000:80 -v ~/docker-nginx/html:/usr/share/nginx/html nginx

# contenedor con red especifica
docker run -dti --name centos3 --network test1 centos

# contenedor con red e ip concreta, solo podras asignar ip si es una subred
docker run -dti --name centos3 --network test1 --ip 172.30.0.10 centos
```

Acceder a un contenedor

```bash
docker exec -ti docker-nginx /bin/bash # acceder a un contenedor
docker exec -u root -ti docker-nginx /bin/bash # acceder a un contenedor con user esecífico
```

Generar imagen desde un contenedor

```bash
docker commit --change='CMD ["apache2ctl", " -D FOREGROUND"]' -c "EXPOSE 80"  nueva-imagen-apache
```

- no es necesario sobreescribir el CMD aun que es recomendable.

### Volumenes

Un volumen es un punto de montage desde un contenedor a nuestro host. xisten diferentes tipo de volumenes.

**Host:**

- Volumen host es el mas útil y facil de utilizar `-v /path/host:path/container` de esta manera todo lo que se crea en el directorio del contenedor montado, se respalda en el host.

**Anonimo:**

- volumnen anonimo es lo mismo pero crea ese punto de montage en el directorio volmes de docker, por defecto `/var/lib/docker/volumes`, el problema de este es que crea un directorio con un nombre de x digitos y es poco amigable de trabajar con el e identificarlo. utilización `-v /path/container` 

- Al crear un volumen en Dockerfile se crea como anonimo.

**Nombrado:** 

- volumen nombrado es un punto de montage con un volumen creado con anterioridad. Estos volumenes se crean en `/var/lib/docker/volumes`, a diferencia de los anonimos estos se crean con un nombre especifico.

- ```bash
  docker volume create my-volumen
  ls /var/lib/docker/volumes
  my-volumen
  
  docker run -d --name nginx-web -p 80:80 -v my-volumen:/var/www/html nginx
  ```

## Redes

La red por defecto al instalar docker es `docker0`, crea una red virtual en modo bridge donde todos los contenedores por defecto se conectaran a ella.

En ocasiones quremos que diversos servicios no esten en la misma red, para ello podemos crear diferentes redes o subredes para aislarlos.

**Tios de red:** 

- `Bridge:`Es una red virtual dentro de nuestra red de host, donde crea un puente para salir al exterior mediante la ip de host local. ( red default de los contenedores )

- `Host:`El contenedor utilizara la misma ip que el servidor real, red `eth0`  o la que tenga el dispositivo, incluso hostname.

- `None:`Se utiliza para indicar que el contenedor no tiene red asignada.

- `Overlay:` 

```bash
docker network ls                    # listar redes 
docker network inspect nombre-red    # iformación de la red
docker network create test-network    # crear nueva red por defecto bridge

docker run -dti --network test-network --name test1 centos #    crear contenedor con una red concreta
docker run -dti --network host --name test2 centos    # crear contenedor con red local: ip, hostname, interfaces.
docker run -dti --network none --name test3 centos    # contenedor sin red



# para crear un contenedor con una ip concreta, primero a de crearse una subred
docker network create -d bridge --subnet 172.124.10.0./24 --gateway 172.124.10.1 nueva-subred # crear subred
docker run -dti --name centos3 --network test1 --ip 172.30.0.10 centos    # crear contenedo con ip especifica

docker network connect red-a-conectar contenedor    # añadir red a contenedor
docker network disconnect red-a-conectar contenedor    # eliminar red de contenedor

docker network rm red    # eliminar red creada, no tiene que estar utilizada por ningun contenedor
docker network prune     # eliminasr redes en desuso
```

```bash
docker run -d -p 127.0.0.1:8081:80 nginx
```


​    

## Subir imagen a dockerhub

```bash
docker login
docker commit nombre-container nombre-nueva-imagen
docker commit lunch_mirie mychispas
docker tag mychispas:latest jorgepastorr/mychispas:latest
docker push jorgepastorr/mychispas:latest
```

ver imagenes en el repositorio remoto  

```bash
docker search jorgepastorr
```





## Entrypoints

entripoint permite tratar un contenedor como un script, de esta manera se puede asignar argumentos a el arranque de un contenedor.

si un Dockerfile comparte entrypoint con cmd el cmp se sumara como argumento al entripoint

```bash
FROM ubuntu
ENTRYPOINT ["top", "-b"]
CMD ["-c"]
```

```bash
$ docker exec -it test ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  2.6  0.1  19752  2352 ?        Ss+  08:24   0:00 top -b -c
```

En cambio si desde la linea de comandos al arrncar el docker especifico un argumento el cmd se anula

```bash
docker run -it --rm --name test  top -H
$ docker exec -it test ps aux
USER PID %CPU %MEM VSZ RSS TTY STAT START TIME COMMAND
root 1 2.6 0.1 19752 2352 ? Ss+ 08:24 0:00 top -b -H
```

Se puede sobreescrivir el entripoint manualmente desde linea de comandos

```bash
docker run --rm --entrypoint /usr/bin/cal -it test
```

el `0.0.0.0` significa que en todas las interficies de red del host esta escuchando por el puerto 389

```bash
ldap.edt.org      /bin/sh -c /opt/docker/sta ...   Up      0.0.0.0:389->389/tcp                                          
```





## docker-compose

### Instalar

[web oficial docker compose](https://docs.docker.com/compose/install/)

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

[documentacion oficial compose](https://docs.docker.com/compose/compose-file/)

### Desplegar docker compose

```bash
docker-compose up -d # crear, actualizar contenedor
docker-compose -p webtest up -d    # ombrar proyecto, red sera webtest-default
docker-compose -f docker-compose-nginx.yml up -d    # desplegar en nombre archivo distinto
docker-compose build     # crear imagen 
docker-compose logs -f    # ver logs de los contenedores corriendo 
docker compose <Enter>     # todas las opciones

docker-compose down  # eliminar contenedor

docker-compose pause ldap # parar container
docker-compose unpause ldap # pausar container
docker-compose stop ldap
docker-compose start ldap
docker-compose ps 
docker-compose top ldap
docker-compose images
```

### Estructura

#### Estructura básica

```yaml
version: '3'
services:
    web:
        image: nginx
        container_name: nginx
        ports:
            - "80:80"
```

#### Variables de entorno

Se pueden definir en el mismo yaml o en un archivo externo que recogemos.

```yaml
environment:
  - RACK_ENV=development
  - SHOW=true
  - SESSION_SECRET

env_file: .env

env_file:
  - ./common.env
  - ./apps/web.env
  - /opt/secrets.env
```

#### Volumenes

**Nombrados** 

Estos volumenes por defecto se crean nen `/var/lib/docker/volumes`

```yaml
version: '3'
services:
    web:
        image: nginx
        container_name: nginx
        ports:
            - "80:80"
        volumes:
            - "vol2:/usr/share/nginx/html"
volumes:
    vol2:
```



**Host**  

Se añade ruta relativa o absoluta  donde se quiere que se cree el volumen

```yaml
version: '3'
services:
  web:
    image: nginx
    container_name: nginx
    ports:
      - "80:80"
    volumes:
      - "./html:/usr/share/nginx/html"
```





#### Redes-Compose

Las redes dentro de compose sirve para crear uno o varios contenedores dentro de una red especifica.

```yaml
version: '3'
services:
    web:
        image: nginx
        container_name: nginx
        ports:
            - "80:80"
        networks:
            - net-test
networks:
    net-test:
```

#### Crear imagen

`build` indica donde se encuentra el `Dockerfile` que tiene que fabricar. 

En este ejemplo, primero fabricara una imagen nombrada web-centos  y luego creara un contenedor web-centos

```yaml
version: '3'
services:
  web:
    image: web-centos
    build: .
    command: python -m SimpleHTTPServer 8080
    container_name: web-centos
    ports:
      - "8080:8080"
```

```bash
docker-compose up --build -d
```

#### Sobreescribir CMD

En ocasiones queremos sobreescribir el cmd de una imagen, en el siguiente ejemplo vemos como una imagen centos que su cmd por defecto es `/bin/bash` ,  ahora es una instrucción de python.

```yaml
version: '3'
services:
    web:
        image: centos
        command: python -m SimpleHTTPServer 8080
        ports:
            - "8080:8080"
```

```bash
CONTAINER ID       IMAGE                 COMMAND                             
f4e99be647702b   web-centos          "python -m SimpleHTTPServer 8080"
```



#### Politica reinincio

- `no`: si el contenedor se apaga por alguna razon, no se reiniciara. ( por defecto ) 

- `on-failure`:  si el contenedor se a caido por algún error se reiniciara.

- `unless-stopped`: cada vez que el contenedor se apage o caiga se reiniciara, a no ser que lo apages manualmente.

- `always` : cada vez que el contenedor se apage o caiga  se reiniciara

```yaml
version: '3'
services:
    web:
        image: nginx
        container_name: nginx
        ports:
            - "80:80"
        restart: always
```

#### Múltiples servicios

la gracia de compose es desplegar multiples servicios de golpe, en el siguiente ejemplo se ve como e ejecuta joomla junto con mysql en una red conjunta.

```yaml
version: '3'
services:
  db:
    container_name: joomla-db
    image: mysql:5.7
    volumes:
      - $PWD/data:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: example
      MYSQL_USER: joomla
      MYSQL_DATABASE: joomla
      MYSQL_PASSWORD: joomla
    networks:
      - my_net
  
  web:
    container_name: joomla-web
    image: joomla
    depends_on:
      - db
    volumes:
      - $PWD/html:/var/www/html
    ports:
      - 80:80
    environment:
      JOOMLA_DB_HOST: db
      JOOMLA_DB_PASSWORD: joomla
      JOOMLA_DB_USER: joomla
      JOOMLA_DB_NAME: joomla
    networks:
      - my_net

networks:
  my_net:
```



## DockerHub

```bash
docker login    # logearse
```

> Obviamente hay que tener una cuenta.

Cambiar de nombre a una imagen y subir

```bash
docker tag mi-debian-imagen jorgepastorr/debian-update # por ejemplo
docker push jorgepastorr/debian-update    # subir la imagen
```
