



# LXC y LXD

 

LXC es una interfaz de espacio de usuario para las funciones de contención  del kernel de Linux. A través de una poderosa API y herramientas  simples, permite a los usuarios de Linux crear y administrar fácilmente  contenedores de aplicaciones o sistemas.

La virtualización de LXC es un intermedio de una máquina virtual de virtualbox, virtmanger.. y docker. Se basa creando contenedores directamente desde el kernel del host haciendo una  paravirtualización muy eficaz y  baja en recursos.

LXD es la siguiente generación de systemas de contenedores ofrece algunas mejoras a LXC, al ser creado por Canonical en distribuciones como   debian no se encuentra en los repositorios a dia de hoy.

## Documentación

[linuxcontainers](https://linuxcontainers.org/lxc/getting-started/)

[debian wiki](https://wiki.debian.org/LXC)

[github](https://github.com/lxc/lxc)



## Instalación 

Por defecto en debian y ubuntu biene instalado, en caso contrario.

```bash
sudo apt install lxc
o
sudo snap install lxd
```



## Intefazes de red

Con LXD tiene un configurador con `lxd init` que configuras la red entre otros, con LXC se tiene que hacer manualmente.

### Independent bridge

Esta configuración crea una nueva interfaz  de red donde se alojaran los contenedores

```
➜  ~ cat /etc/default/lxc-net 
USE_LXC_BRIDGE="true"

LXC_BRIDGE="lxcbr0"
LXC_ADDR="10.0.3.1"
LXC_NETMASK="255.255.255.0"
LXC_NETWORK="10.0.3.0/24"
LXC_DHCP_RANGE="10.0.3.2,10.0.3.254"
LXC_DHCP_MAX="253"

➜  ~ cat /etc/lxc/default.conf 
lxc.net.0.type = veth
lxc.net.0.link = lxcbr0
lxc.net.0.flags = up
lxc.net.0.hwaddr = 00:16:3e:xx:xx:xx
```

Crear interfaz.

```bash
sudo systemctl start lxc-net.service
```





### Host-shared bridge

Esta configuración de red es un NAT, igual que hacen las máquinas virtuales por defecto.

```
➜  ~ cat /etc/lxc/default.conf 
lxc.net.0.type = veth
lxc.net.0.link = virbr0
lxc.net.0.flags = up
# you can leave these lines as they were:
lxc.apparmor.profile = generated
lxc.apparmor.allow_nesting = 1
```



### Host device as bridge

Con esta configuración creamos un bridge a la targeta de red física, por lo tanto los host de la LAN se podrán comunicar con el container.

```
➜  cat /etc/lxc/default.conf 
#lxc.net.0.type = empty
#lxc.apparmor.profile = generated
#lxc.apparmor.allow_nesting = 1

lxc.net.0.type = veth
lxc.net.0.link = lxcbr0
lxc.net.0.flags = up
lxc.net.0.hwaddr = 00:16:3e:xx:xx:xx

➜  cat /etc/network/interfaces
auto lxcbr0
iface lxcbr0 inet dhcp
    bridge_ports enp3s0
    bridge_fd 0
    bridge_maxwait 0
    
➜  ~ cat /etc/default/lxc-net 
USE_LXC_BRIDGE="true"

LXC_BRIDGE="lxcbr0"
LXC_ADDR="10.0.3.1"
LXC_NETMASK="255.255.255.0"
LXC_NETWORK="10.0.3.0/24"
LXC_DHCP_RANGE="10.0.3.2,10.0.3.254"
LXC_DHCP_MAX="253"
```



## LXC

### Configuración

La configuración por defecto se encuentra en `/etc/lxc/default.con`

Al crear contenedores estos se crean en `/var/lib/lxc/` y la configuración del contenedor se encuentra en `/var/lib/lxc/<nombre contenedor>/config`

La información de la vconfiguración de contenedores se encuentra en `man lxc.container.conf`



### Listar imagenes base

Las plantillas de imagenes se almacenan en `/usr/share/lxc/templates`

[listado de imagenes](https://us.images.linuxcontainers.org/)

### Comandos básicos

```bash
# crear un contenedor debian
# las diferentes opciones son para escoger release, architectiura o configuracion diferente

lxc-create --name deb --template debian 
lxc-create --name deb --template debian -- -r stretch 
lxc-create -n deb -t debian -- -r stretch -a i386
lxc-create -n deb -f config-file.conf -t debian -- -r stretch 

# listar contenedores
lxc-ls --fancy
lxc-info -n deb

# arrancar, apagar, eliminar
lxc-start -n deb
lxc-stop -n deb
lxc-destroy -n deb

# entrar al contenedor
lxc-attach -n deb bash
```



### Copiar/Renombrar contenedor

Para copiar o renombrar un contenedor debe estar parado

```bash
lxc-copy --name deb --newname debi
lxc-copy  --rename debi --newname dex
```



### Snapshot

Para crear snapshots y restaurarlo los contenedores afectados tienen que estar apagados

```bash
# crear snapshot del contenedor deb con un comentario
lxc-snapshot -n deb --comment comment-snap 

# listar snaps del contenedor
lxc-snapshot -n deb -L                
snap0 (/var/lib/lxc/deb/snaps) 2020:12:23 08:49:15

# listar snaps del contenedor y sus comentarios
lxc-snapshot -n deb -L --showcomments
snap0 (/var/lib/lxc/deb/snaps) 2020:12:23 08:49:15
Snap01 de container deb

# restaurar snapshot
lxc-snapshot -n deb --restore snap0
```



### Autoestart

Loos contenedores tienen la opción de arrancar con el sistema si se asigna la opción  `lxc.start.auto=1`

```bash
➜  ~ sudo cat /var/lib/lxc/p1/config
...
lxc.start.auto = 1
lxc.start.delay = 10
lxc.start.order = 100

lxc.group = debian
```

- `lxc.start.order` es la prioridad de arrancar entre contenedores, el numero mas alto tiene prioridad, es decir arranca primero
- `lxc.start.delay` es un timeout de espera para arrncar el siguiente contenedor.



### Limitar recursos

limita la ram y la cpu de un contenedor, en el siguiente ejemplo, 128MB ram 

```bash
➜  ~ sudo cat /var/lib/lxc/p1/config
...
lxc.cgroup.memory.limit_in_bytes = 134217728
lxc.cgroup.cpuset.cpus = 0,3
```



## LXD

En caso de debian  para las instalación de LXD hay que utilizar snap o descargar el [.deb](https://pkgs.org/download/lxd) , desde ubunto ya lo enemos en los repositorios oficiales.

[documentación LXD](https://linuxcontainers.org/lxd/docs/master/index)

```bash
snap install lxd 

# asigno el usuario al grupo lxd para no utilizar sudo
sudo usermod -aG lxd <usuario>
getent group lxd
```

### Configuración

iniciar configuración básica de LXD, como interfaz  de red, storage predeterminado, etc...

```bash
lxd init
```

### Listar imagenes base

```bash
# listar imagenes del repositorio
lxc image list images:

# listar imagenes locales
lxc list
```



### Comandos básicos

```bash
# crear un contnedor ubuntu llamado myvm
lxc lunch ubuntu/20.10 myvm

# arrancar, parar, eliminar
lxc start myvm
lxc stop myvm
lxc delete myvm

# ejcutar commando dentro del shell
lxc exec myvm bash

# copiar contenedor
lxc copy myvm newvm

# renombrar  contenedor
lxc move myvm groovy

# ver informacion del contenedor y su configuración
lxc info groovy
lxc config show groovy
```

### Config contenedores

Los contenedores e pueden nañadir configraciones extra o limitaciones como por ejemplo ram o cpu, existen muchas [opciones](https://linuxcontainers.org/lxd/docs/master/instances) a  configurar

```bash
# limitar memoria y cpu
lxc config set groovy limits.memory 512MB
lxc config set groovy limits.cpu 1
lxc config show groovy 

# dar permisos extra para poder crear contenedores recursivos
lxc config set groovy security.privileged true
lxc config set groovy security.nesting true
```



### Profile

por defecto existe la configuración default para contenedore que se asigna automaticamente, si creamos nuestra propia configuración la podemos asignar a nuevos contenedores.

```bash
# listar y ver profile
lxc profile list
lxc profile show default

# crear un profil nuevo y editarlo al gusto
lxc profile copy default custom
lxc profile edit custom

# asignar profile a un nuevo contenedor
lxc lunch ubuntu/20.10 groovy --profile custom
```



### File

file permite añadir o exttraer archivos a un contenedor

```bash
lxc file push myfile groovy/root
lxc file pull groovy/root/myfile .
```



### Snapshot

Se pueden hacer copias de seguridad rápidamente creando un snapshot del contenedor y en cualquier momento restaurarlo

```bash
# crear snashot snap1 de contenedor groovy
lxc snapshot groovy snap1

# ver snap creado
lxc info groovy

# restaurar snapshot
lxc restore groovy snap1
```

