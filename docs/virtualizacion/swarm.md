# Swarm

Swarm es el conjunto de nodos que forman la orquestra. Como mínimo hay un nodo que hace de manager y worker, los demás nodos que se añadan serán workers a no ser que se añada mas de un manager pero se especificará uno como lider.

La gestión de las tareas y donde repartirlas, se encarga el manager, siempre se trabaja contra el manager.

Swarm trabaja con el puerto `2377` para su comunicación interna.

**Stack**: Es una app que corre dentro de swarm ( un docker-compose.yml forma una stack ), los contenedores que forman la app corren dentro de los nodos.

**Service**: ( routing mesh ) red de todos a todos es la manera que tiene swarm de gestionar  los puertos  y el repartidor de carga en un stack, una vez expuesto un puerto puedes consultar cualquier nodo que te contestaran por igual.

## Comandos básicos

```bash
#  swarm ------------------------------------------------
docker swarm init # iniciar swarm
# iniciar worker
docker swarm join --token SWMTKN-1-4qagsse8jlngffwmce3epujd7ws8supro93iik25cu634w9szv-a94ktkie6xekc9xp883sj0jbv 192.168.88.2:2377

docker node ls  # ver nodos
docker swarm join-token manager # token para añadir managers
docker swarm join-token worker # token para añadir worker

# stack ----------------------------------------------------
docker stack deploy -c docker-compose.yml app # desplegar stack con nombre app

docker stack ps app # visualizar contenedores
docker stack ls # visualizar stack
docker stack services app # visualizar servicios de stack
docker service ps app_hello # visualizar contenedores de un servicio
docker service inspect app_hello # visualizar servicio detallado

docker service scale app_hello=4 # escalar numero de replicas
docker stack rm app # borrar stack

# nodos --------------------------------------------------
docker node ls
docker node inspect pc02 --pretty

docker node update --availability pause pc03
docker node update --availability drain pc03 # vaciar nodo
docker node update --availability active pc03

docker node update --label-add lloc=local pc03 # añadir label

docker node rm node-2
docker swarm leave # quitar worker
docker swarm leave --force # quitar manager
```

## Iniciar swarm

Al iniciar el manager indica el token con el que agrupar los workers

```bash
➜ docker swarm init
Swarm initialized: current node (yuc0or5k3izprm0go81keye7u) is now a manager.
To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-4qagsse8jlngffwmce3epujd7ws8supro93iik25cu634w9szv-a94ktkie6xekc9xp883sj0jbv 192.168.88.2:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

iniciar worker 

```bash
[jorge@pc03 ~]$  docker swarm join --token SWMTKN-1-4qagsse8jlngffwmce3epujd7ws8supro93iik25cu634w9szv-a94ktkie6xekc9xp883sj0jbv 192.168.88.2:2377
This node joined a swarm as a worker.
```

nodos activos

```bash
➜ docker node ls 
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
yuc0or5k3izprm0go81keye7u *   pc02                Ready               Active              Leader              19.03.6
retgjptxz1di57xc85qym6atv     pc03                Ready               Active                                  19.03.7
```

```bash
➜ docker swarm join-token manager # token para añadir managers
➜ docker swarm join-token worker # token para añadir worker
```

## Gestión stack

```yaml
version: "3"
services:
  hello:
    image: edtasixm11/k19:hello
    deploy:
      replicas: 3
    ports:
      - "80:80"
    networks:
      - mynet
  portainer:
    image: portainer/portainer
    ports:
      - "9000:9000"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
    networks:
      - mynet
networks:
  mynet:
```

```bash
# desplegar stack con nombre app
➜ docker stack deploy -c docker-compose.yml app

# visualizar contenedores
➜ docker stack ps app
ID                  NAME                IMAGE                             NODE                DESIRED STATE       CURRENT STATE              ERROR               PORTS              
oan9jbh0co9w        app_portainer.1     portainer/portainer:latest        pc02                Running             Running 7 seconds ago                          
wp48mobq8uve        app_hello.1         edtasixm11/k19:hello              pc03                Running             Preparing 43 seconds ago                       
ps1wx40lopar        app_hello.2         edtasixm11/k19:hello              pc02                Running             Running 7 seconds ago                          
ltiaa8qrz1kp        app_hello.3         edtasixm11/k19:hello              pc03                Running             Preparing 43 seconds ago          

# visualizar stack
➜ docker stack ls                              
NAME                SERVICES            ORCHESTRATOR
app                 3                   Swarm

# visualizar servicios de stack
➜ docker stack services app
ID                  NAME                MODE                REPLICAS            IMAGE                             PORTS
nxo472jynnbt        app_visualizer      replicated          1/1                 dockersamples/visualizer:stable   *:8080->8080/tcp
y1feo3pbnb83        app_hello           replicated          3/3                 edtasixm11/k19:hello              *:80->80/tcp
ybau52gmcszq        app_portainer       replicated          1/1                 portainer/portainer:latest        *:9000->9000/tcp

# visualizar contenedores de un servicio
➜ docker service ps app_hello
ID                  NAME                IMAGE                  NODE                DESIRED STATE       CURRENT STATE           ERROR               PORTS
wp48mobq8uve        app_hello.1         edtasixm11/k19:hello   pc03                Running             Running 8 minutes ago                       
ps1wx40lopar        app_hello.2         edtasixm11/k19:hello   pc02                Running             Running 8 minutes ago                       
ltiaa8qrz1kp        app_hello.3         edtasixm11/k19:hello   pc03                Running             Running 8 minutes ago    

# visualizar servicio detallado
➜  docker service inspect app_hello

# escalar numero de replicas
➜ docker service scale app_hello=4
app_hello scaled to 4
overall progress: 4 out of 4 tasks 
1/4: running   [==================================================>] 
2/4: running   [==================================================>] 
3/4: running   [==================================================>] 
4/4: running   [==================================================>] 
verify: Service converged 
```

## Gestión nodos

```bash
➜  docker node ls # listar nodos
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
yuc0or5k3izprm0go81keye7u *   pc02                Ready               Active              Leader              19.03.6
retgjptxz1di57xc85qym6atv     pc03                Ready               Active                                  19.03.7

# pausar nodo, en modo pausa no acepta nuevas tareas pere ejcuta las existentes.
➜ docker node update --availability pause pc03 
pc03

➜ docker node ls                              
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
yuc0or5k3izprm0go81keye7u *   pc02                Ready               Active              Leader              19.03.6
retgjptxz1di57xc85qym6atv     pc03                Ready               Pause                                   19.03.7

# nodo drain,  se desace de todos sus contenedores pasandolos a otros nodos
➜ docker node update --availability drain pc03
# nodo active, se reactiva el nodo.
➜ docker node update --availability active pc03
```

Cuando vuelve a configurar el nodo en Disponibilidad activa, puede recibir nuevas tareas:

- durante una actualización de servicio para escalar
- durante una actualización continua
- cuando configura otro nodo para Drenar disponibilidad
- cuando una tarea falla en otro nodo activo

### Labels

```yaml
 # añadir label a nodo
➜ docker node update --label-add lloc=local pc03
 ...
 visualizer:
    image: dockersamples/visualizer:stable
    ports:
      - "8080:8080"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
    deploy:
      placement:
        constraints: [node.labels.lloc == local]
    networks:
      - mynet
 ...
deploy:
  placement:
    constraints:
       - node.role == manager
       - engine.labels.operatingsystem == ubuntu 14.04
       - node.labels.lloc == local
```

apagar stack y quitar nodos

```bash
# borrar stack
➜ docker stack rm app
Removing service app_hello
Removing service app_portainer
Removing service app_visualizer
Removing network app_mynet

# quitar worker
[jorge@pc03 ~]$ docker swarm leave
Node left the swarm.

# quitar manager y parar swarm
➜ docker swarm leave --force
```

## puertos

```
Obrir ports en el worker:
● 80
● 8080
● 9000
● 2377 per gestio de nodes
● Port 7946 UDP for container network discovery.
● Port 7946 TCP for container network discovery.
● Port 4789 UDP for the container ingress network.
Obrir ports en manager:
● Port 7946 UDP for container network discovery.
● Port 7946 TCP for container network discovery.
● Port 4789 UDP for the container ingress network.
```

## Modo global

El modo global es un modo en el que se hará un despliegue de un contenedor en cada nodo,  si hay 3 nodos se crearán tres replicas.

```yaml
version: "3.7"
services:
  worker:
    image: dockersamples/examplevotingapp_worker
    deploy:
      mode: global
```
