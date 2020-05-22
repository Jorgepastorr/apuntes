# Tunel SSH



## Elementos tipologia

**host-local**: Host des del que trabajas y estableces un tunel ssh. Por ejemplo el ordenador de casa hacendo un ssh al router de la empresa.

**host-desti**:  El host destino es el host al que conectas via ssh `user@hostdesti` , este host normalmente es un router si se hace una conexión remota, de casa a la empresa. En caso de ser una conexión local el host desti será un host de tu misma lan.

**host-remot**: El host remoto, es el que de una conexión de casa a la empresa el host de la empresa que esta dentro de la red local privada.

```
      Casa                             Empresa
                                    +----------------------+
    +-----------------+             |                      |
    |                 |             |         host-remoto  |
    |                 |           +---+          +---+     |
    |   host-local    |           | | | +----->            |
    |  +------+       |           | | |          |   |     |
    |  |      |   +------------>  | | |          +---+     |
    |  +------+       |           +---+                    |
    |                 |       router host-desti            |
    +-----------------+             |                      |
                                    +----------------------+
```



## Tipos de túneles

**Túnel directo a host-desti**: Es el túnel mas usado, de un host-local a un host-destino, una vez en el host-desti rebotas a localhost, así puedes acceder a servicios no publicados y solo disponibles para localhost del destino. `-L 9001:localhost:80`

```bash
ssh -L [interficie-local]:puerto-local:hist-destino:puerto-destino    user@destino
```



**Túnel directo a host-desti para acceder a host-remot**:  En este modelo desde el host-local queremos acceder al host-remoto. Pero como lo hacemos si no tiene acceso?. Es necesario acceder desde el host-local a un host-destino y de este rebotar al host-remoto. `-L 9001:ldap:389`

```bash
 ssh -L [interficie-local]:puerto-local:host-remoto:puerto-remoto    user@destino
```



**Túnel reverse al host-desti**: Es exactamente lo contrario a un túnel directo a host-desti. Desde host-local abres un túnel a host-desti que deja la puerta abierta a host-desti para acceder a host-local, es una manera de saltarte el firewall exterior. `-R 9001:localhost:80`

```bash
ssh -R [interficie-destino]:puerto-destino:host-local:puerto-local  user@destino
```



**túnel reverse al host-remoto**: En este caso el host-local abre un túnel a host-destino, para que destino pueda entrar desde el puerto abierto en host-destino pasando por host-local y este redireccionará a un host-remoto `-R 9001:ldap:389`

```bash
 ssh -L [interficie-destino]:puerto-destino:host-remoto:puerto-remoto    user@destino
```



**Binding**: Es asignar un puerto a una interficie en concreto, por defecto el puerto que se abre se en localhost, pero esto es posible cambiarlo. Por ejemplo:  `0.0.0.0:9001:localhost:80` , en este caso se esta asignando el puerto `9001` a todas las interficies.

Hay que tener en cuenta en el binding si es un túnel directo, el binding se hará perfectamente por que el puerto se abre en la maquina local. Pero si es un binding inverso el servidor sshd del host-destino tiene que tener la siguiente configuración activada, en caso contrario no dejara abrir puertos en interficies que no sean localhost.

```bash
vim /etc/ssh/sshd_config
...
GatewayPorts yes
...
```





## Ejemplos:

### Directos

**Local-destino**: Creo un túnel  que abre el puerto 9001 local y me envía al puerto 80 de la interficie localhost de destino

```bash
➜  ~ ssh -L 9001:localhost:80 jorge@portatil
➜  ~ curl http://localhost:9001
bienvenido apache bla bla...

# lo mismo pero con el cambio de interficie local
➜  ~ ssh -L 192.168.88.2:9001:localhost:80 jorge@portatil
➜  ~ curl http://192.168.88.2:9001
bienvenido apache bla bla...
```



**local - destino - remoto:**

Ejemplo1: Creo un túnel que me envía desde mi puerto local 9001 a el host destino portatil y este me reenvía a remoto `yahoo.com:80`

```bash
➜  ~ ssh -L 9001:yahoo.com:80 jorge@portatil
➜  ~ curl http://localhost:9001
bienvenido yahoo ...
```

Ejemplo2: En este ejemplo simulo que desde el  host-local no tengo acceso al server (host-remoto), pero desde portatil (host-desti)  si. Creo un tunel que abre el puerto 9001 del host-local que me envía al portatil y el portatil me reenvía al puerto 22 del server.

```bash
# creo tunel
➜  ~ ssh -L 9001:server:22 jorge@portatil
# me conecto al puerto 9001  local con ssh y el usuario pi del server
➜  ~ ssh -p 9001 pi@localhost
# el tunel me reenvia al server.
pi@raspberrypi:~ $
```



Ejemplo3: Quien hace la resolución?  el host-local hace la resolución de host-destino,  host-destino hace la resolución de host-remoto. Así aun que host-local no sabe la resolución de portatil, no importa por que la hará host-destino.

```bash
[fedora@aws ~]$ ssh   -L 3034:portatil:13 pi@casa
```



### Inversos

**local-destino**: host-local (aws) corre un servicio de daytime en el puerto 13, pero es solo local el firewall corta todas las entradas. Entonces desde aws conecto con host-destino (casa) y abro el puerto 3035 donde conecta con el localhost:13 de aws.

```bash
[fedora@aws ~]$ ssh -R 3035:localhost:13 pi@casa
pi@casa:~ $ curl http://localhost:3035
17 MAR 2020 17:19:08 UTC
```



**local-destino-remoto**: En este ejemplo El firewall bloquea todas las entradas del exterior, entonces desde casa establezco una conexión inversa con aws para que desde el puerto aws:3035 pueda acceder a casa y la redirijo al portatil:13  que tiene el servidor daytime.

```bash
casa ➜ ssh -R 3035:portatil:13 fedora@aws
[fedora@aws ~]$ curl http://localhost:3035
17 MAR 2020 17:38:34 UTC
```

diagrama:

```bash
                 +-+        +----+
                 | |        |    | portatil
            firewall        |    | P:13
                 | |        +----+
     aws         | |            ^
                 | |            |
     +---+       | |       +-----+
     |   |       | |       |     |
     |   |  <-----------+  |     |
     +---+       | |       +-----+
      P:3035     +-+
                             casa
```



### dinamicos

```bash
ssh -D 9000 home
```



