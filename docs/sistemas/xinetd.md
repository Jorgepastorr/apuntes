# xinetd

Xinetd es un servicio standalone, que hace de escucha de otros servicios. Xinetd siempre esta escuchando y cuando le llegan peticiones, arranca el servicio demandado y redirige la petición. Esto sirve para bajar el consumo de la cpu, ya que si no estuviera estarían todos los servicios encendidos continuamente.

los archivos de demonios dentro de xinetd se encuentran en el directorio `/etc/xinetd.d` y se specifica que es UDP o TCP con stream tcp, dgram udp.

```bash
-rw------- 1 root root 1156 Mar 12 18:23 chargen-dgram
-rw------- 1 root root 1158 Mar 12 18:24 chargen-stream
-rw------- 1 root root 1156 Mar 12 18:23 daytime-dgram
-rw------- 1 root root 1158 Mar 12 18:23 daytime-stream
...
```



**Dato:** hoy en día las máquinas tienen suficiente cpu para no utilizar este servicio, pero en el caso de correr una máquina con pocos recursos es recomendable.

Ejemplo de servicio xinetd `/etc/xinetd.d/pop3`

```
service pop3
{
        socket_type             = stream
        wait                    = no
        user                    = root
        server                  = /usr/sbin/ipop3d
        log_on_success  += HOST DURATION
        log_on_failure  += HOST
        disable                 = no
}
```



## Opciones

`disable`: Indica que un servicio espere apagado o no. `yes` permanece apagado hasta que se le necesite.

`wait`: Indica si el servicio es multithread. opción  `yes --> no es multithread` y `no --> es multithread`

- Un servicio multithread es el que acepta múltiples peticiones simultaneas, crea un fork de su servicio principal y sigue escuchando. Un servicio que no es multithread solo puede aceptar una petición al mismo tiempo, si hay mas peticiones serán rechazadas por estar en uso.

`server`: Demonio a arrancar cuando reciba una petición.

`user`: Usuario con el que se ejecuta el demonio.

`instances`: Número de conexiones simultaneas que acepta.

`only_from`:  Hosts remotos desde donde se puede conectar

`no_access`:   Hosts remotos desde donde se puede conectar

- Tanto en  `only_from y no_acces` se puede especificar el host como `192.168.0.1 | 192.168.2.0 | 192.168.0.2/24 | .domain.com`  los 0 a la derecha se trata como comodín, es decir es lo mismo ` 192.168.2.0` que `192.168.2.0/24`.

`access_times `: rango de tiempo en el que esta permitido el acceso. Las horas pueden variar de 0 a 23 y los minutos de 0 a 59. `8:00-14:00`

`cps`: Número de conexiones por segundo

`redirect`: ip y puerto a la que redirigir la petición

`bind`: interficie por la que escucha la petición

`port`:  puerto de la interficie que escucha la petición

Existen mas opciones, estas son las más usadas y básicas, para mas información [man xinetd.conf](https://linux.die.net/man/5/xinetd.conf)



## Bind

Bind indica la interficie por donde escuchar `0.0.0.0`  son todas las interficies del equipo, `127.0.0.1`  interficie loopback.

```bash
# escucha en todas las interficies
service http-switch
{
disable  = no
type = UNLISTED
socket_type = stream
protocol = tcp
wait = no
redirect = 127.0.0.1 13
bind = 0.0.0.0
port = 1013
user = nobody
}

# escucha solo en localhost
service http-switch
{
disable  = no
type = UNLISTED
socket_type = stream
protocol = tcp
wait = no
redirect = 127.0.0.1 13
bind = 127.0.0.1
port = 2013
user = nobody
}
```



## Redirect

La redirección no tiene por que ser a una interficie local, también acepta dispositivos externos.

```bash
# redirecciona a  localhost:80
service http-bis
{
disable  = no
type = UNLISTED
socket_type = stream
protocol = tcp
wait = no
redirect = 127.0.0.1 80
bind = 0.0.0.0
port = 1080
user = nobody
}

# redirecciona a una web externa
service http-bis
{
disable  = no
type = UNLISTED
socket_type = stream
protocol = tcp
wait = no
redirect = www.escoladeltreball.org 80
bind = 0.0.0.0
port = 1080
user = nobody
}
```



## Only_from/no_access

```bash
# se permite el acceso solo a la ip 172.17.0.3
{
disable  = no
type = UNLISTED
socket_type = stream
protocol = tcp
wait = no
redirect = 127.0.0.1 13
bind = 127.0.0.1
port = 2007
user = nobody
only_from = 172.17.0.3
}

# permitir acceso a una red menos un equipo de la misma
{
        disable  = no
        type = UNLISTED
        socket_type = stream
        protocol = tcp
        wait = no
        redirect = 127.0.0.1 13
        bind = 172.17.0.2
        port = 14
        user = nobody
        only_from = 172.17.0.0/24
        no_access = 172.17.0.1
}
```



## access_times

```bash
# permitir acceso de 8 a 13
{
	disable  = no
	type = UNLISTED
	socket_type = stream
	protocol = tcp
	wait = no
	redirect = 127.0.0.1 13
	bind = 172.17.0.2
	port = 14
	user = nobody
	access_times = 8:00-13:00
}
```



## instances

```bash
# permitir solo 2 conexiones simultaneas
{
        disable  = no
        type = UNLISTED
        socket_type = stream
        protocol = tcp
        wait = no
        redirect = 127.0.0.1 7
        bind = 172.17.0.2
        port = 8
        user = nobody
        instances = 2
}
```



## cpu

```bash
# establecer 2 conexiones máximo por segundo y una espera de 20s para la proxima
{
        disable  = no
        type = UNLISTED
        socket_type = stream
        protocol = tcp
        wait = no
        redirect = 127.0.0.1 7
        bind = 172.17.0.2
        port = 8
        user = nobody
        cps = 2 20
}
```

