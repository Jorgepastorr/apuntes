# Vagrant

**Vagrant** es una herramienta que nos ayuda a desplegar máquinas virtualizadas rápidamente, ademas a estas máquinas se les puede añadir una configuración en el despliege via script, ansible y otros, donde podremos desplegar y configurar una o varias máquinas de manera rápida y eficaz.

Cabe decir que vagrant es solo la herramienta de despliegue, necesita de un proveedor de virtualización, como [VirtualBox](https://es.wikipedia.org/wiki/VirtualBox), [VMware](https://es.wikipedia.org/wiki/VMware), [Amazon EC2](https://es.wikipedia.org/wiki/Amazon_EC2), [LXC](https://es.wikipedia.org/wiki/LXC), [DigitalOcean](https://es.wikipedia.org/wiki/DigitalOcean), libvirt, etc.

- [Doc vagrant](https://www.vagrantup.com/docs)

- [Doc vagrant-libvirt](https://github.com/vagrant-libvirt/vagrant-libvirt)





## Instalación

Para que vagrant funcione hay que tener un proveedor de máquinas virtuales, tipo virtualbox, libvirt, etc.

El el siguiente recuadro se muestra como intalar Vagrant para el proveedor libvirt, par otros proveedores consultar el enlace de documentación.

- [Instalación vagrant debian wiki](https://wiki.debian.org/Vagrant)

- [Doc instalación vagrant](https://www.vagrantup.com/docs/installation)



```bash
# Instalar vagrant-libvirt
sudo apt install vagrant-libvirt libvirt-daemon-system

# añadir usuario al grupo libvirt para evitr utilizar sudo
sudo usermod --append --groups libvirt $USER

# reiniciada  la sesión comprovar el user añadido al grupo y la versión de vagrant
cat /etc/group | grep libvirt

vagrant --version
Vagrant 2.2.3
```



## Boxes

En vagrant Boxes juega un papel inportante, ya que es el repositorio de imagenes base. Estas imagenes ya son un sistema operativo intalado y listo para utilizar, aqui recae la gracia y rapidez de vagrant.

- [Boxes search](https://app.vagrantup.com/boxes/search)

Una vez vas desplegando máquinas se van guardando las imagenes localmente.

```bash
➜ vagrant box list     
debian/buster64 (libvirt, 10.4.0)
debian/buster64 (virtualbox, 10.4.0)
ubuntu/trusty64 (virtualbox, 20190514.0.0)
```



## Desplegar

Al desplegar máquinas con vagrant hay que tener en cuenta que crea archivos para guardar configuraciones, por lo tanto es buena práctica crear un directorio donde se va a crear cada entorno de máquinas.

En el siguiente ejemplo se muestra como desplegar una máquina debian buster con el proveedor libvirt

```bash
# iniciar directorio como entorno vagrant con base debian/buster
vagrant init debian/buster64

# levantar máquina con entorno libvirt
vagrant up --provider=libvirt

# ahora ya podemos acceder a la shell de la máquina
vagrant ssh
```

Los archivos que genera el entorno vagrant son `.vagrant` archivos relacionados con la máquina virtual y `Vagrantfile` configuración a asignar a la máquina.

```bash
➜ ls -al                               
total 16
drwxr-xr-x  3 debian debian 4096 ene 15 10:55 .
drwxr-xr-x 12 debian debian 4096 ene 15 10:47 ..
drwxr-xr-x  4 debian debian 4096 ene 15 10:55 .vagrant
-rw-r--r--  1 debian debian 3022 ene 15 10:52 Vagrantfile
```



## Comandos básicos

```bash
vagrant init debian/buster64
vagrant up 
vagrant up --provider=libvirt
vagrant ssh
vagrant halt
vagrant up
vagrant destroy
vagrant reload
vagrant box list
vagrant snapshot list
vagrant snapshot save [maquina] name-snap
vagrant snapshot restore [maquina] name-snap
vagrant snapshot delete [maquina] name-snap
```





## Configuraciones

Una vez iniciado un entorno vagrant con `init` se cre un archivo `VagrantFile` donde configuramos la/s máquina que queremos desplegar.

```bash
 config.vm.define "mv0" do |test|
    test.vm.box = "debian/buster64"
    test.vm.hostname = "mv0
    
    test.vm.provider :libvirt do |lb|
      lb.memory = "1024"
    end
  end
```





### Aprovisionamiento

El aprovisionamiento es una de las grandes utilidades de la configuración de vagrant, sirve para instalar o configurar todo lo que necesites en el primer arranque de la máquina.

Para hacer este despliege puedes utilizar, shell, script, ansible, chef, etc.

*VagrantFile*

```bash
# despliege con shell
config.vm.provision "shell", inline: <<-SHELL
  apt-get update
  apt-get install -y nginx
SHELL

# depliege con script
config.vm.provision "shell", path: 'script.sh'

# despliege con ansible
config.vm.provision "ansible" do |ansible|
  ansible.playbook = "instrucciones.yml"
end
```





### Rendimiento

La configuración del rendimiento que quieres dar a una máquina es importante, en la sección provider podemos configurar cuanta ram mo cpu tendrá nuestra máquina.

- [opciones rendimiento con libvirt](https://github.com/vagrant-libvirt/vagrant-libvirt#provider-options)

```bash
   config.vm.provider :libvirt do |lb|
     lb.memory = "1024"
     lb.cpus = 2
   end
```



### Network

[Doc](https://www.vagrantup.com/docs/networking)

Por defecto vagrant crea las máquinas con un interfaz NAT hacia nuestro host, donde se veran entre ellas pero desde el exterior no podras ver la máquina virtual.

- `Private_network` esta opción añade una red privada, que solo se veran entre las maquinas virtuales.

- `Public-network` esta opción cre un bridge a la interfaz del host y se vera como una máquina mas en la LAN

- `Forwarded_port` redireccionar un puerto de el host a la máquina virtual.



```bash
# redireccionmiento de vpuerto a la interfaz localhost
config.vm.network "forwarded_port", guest: 80, host: 8080
# redireccionmiento de vpuerto a la interfaz 192.168.88.2
config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "192.168.88.2"

# interfaz privada
config.vm.network "private_network", ip: "192.168.33.10"

# interfaz publica
config.vm.network "public_network"
```

En libvirt la interfaz publica da problemas y se tiene que crear un bridge anualmente para que fincuione correctamente.

```bash
# VagrantFile
config.vm.network "public_network", dev: "br0", mode: "bridge", type: "bridge"

# /etc/network/interfaces
...
auto br0
iface br0 inet dhcp
  bridge_ports enp3s0
  bridge_stp off
  bridge_fd 0
  bridge_maxwait 0
```





### Volumes

Los puntos de montaje siempre son utiles para transferir archivos entre nuestras máquinas.

[Doc volumes](https://www.vagrantup.com/docs/synced-folders/basic_usage)

```bash
config.vm.synced_folder "../data", "/vagrant_data"
```



### Discos

Añadir discos extra a la máquina virtual

[Doc discos](https://www.vagrantup.com/docs/disks/usage)

```bash
config.vm.provider :libvirt do |lb|
  lb.storage :file, size:'2G'
  lb.storage :file, size:'2G'
end
```



### Multi_maquina

Para según que proyectos es necesario levantar mas de una máquina virtual. Pues simplemente definiendo multiples máquinas en el archivo `VagrantFile`  se desplegaran a  la vez.

[Doc multi machine](https://www.vagrantup.com/docs/multi-machine)

```bash
Vagrant.configure("2") do |config|

  config.vm.define "web1" do |test|
    test.vm.box = "debian/buster64"
    test.vm.provider :libvirt
    test.vm.hostname = "ojoaldato.net" 
    test.vm.network "public_network", dev: "br0", mode: "bridge", type: "bridge"
    
    config.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get install -y nginx
    SHELL
  end
# ---------------------

 config.vm.define "web2" do |test|
    test.vm.box = "debian/buster64"
    test.vm.provider :libvirt
    test.vm.hostname = "vayviene.net" 
    test.vm.network "public_network", dev: "br0", mode: "bridge", type: "bridge"

    config.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get install -y nginx
    SHELL
  end

end
```



## Snapshot

sintaxis `vagrant snapshot save [maquina] name-snap`

```bash
# crear snapshot
➜  vagrant vagrant snapshot save web snap01
==> web: Snapshotting the machine as 'snap01'...
==> web: Snapshot saved! You can restore the snapshot at any time by
==> web: using `vagrant snapshot restore`. You can delete it using
==> web: `vagrant snapshot delete`.

# ver snapshot
➜  vagrant vagrant snapshot list
==> web: 
snap01

# restaurar snap
➜  vagrant vagrant snapshot restore web snap01

# eliminar snap
➜  vagrant vagrant snapshot delete web snap01
```



