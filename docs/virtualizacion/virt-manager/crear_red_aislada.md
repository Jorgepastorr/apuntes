# Crear red aislada

## creo isolated forma gráfica

**crear red aislada**

```bash
virt-manager → editar → detalles de conexión → redes virtuales → add:
```

- desmarcar todas las casillas y dejar solo marcada red virtual aislada, todo lo demás en blanco.



**asignar red aislada a una máquina**

```bash
seleccionar maquina → abrir → bombilla de configuración → NIC (red):
```

- *fuente de red*  :  elegir red virtual aislada isolated
- *modelo de dispositivo*:  a de ser virtio al ser una red virtual.



## creo isolated2 desde comando

###  **crear archivo isolated2.xml**

```bash
nano isolated2.xml
```

```bash
<network> <name>isolated2</name>
</network>
```



###  **definir la red**

```bash
sudo virsh net-define isolated2.xml
Network isolated2 defined from isolated2.xml
```

> net-create crea una red igual que net-define la diferencia es que create se elimina al dejar de usarla y define es persistente.



### **ver lista de redes desde virsh**

```bash
sudo virsh net-list --all

Name                 State      Autostart     Persistent
----------------------------------------------------------
 default              inactive   no            yes
 isolated             active     yes           yes
 isolated2            inactive   no            yes
```



### **ver archivo de configuración de la red**

```bash
sudo virsh net-dumpxml isolated2

<network>
  <name>isolated2</name>
  <uuid>012e5b7f-ad0e-4047-8503-565fa377cc77</uuid>
  <bridge name='virbr2' stp='on' delay='0'/>
  <mac address='52:54:00:ca:45:01'/>
</network>
```

- name: nombre
- uuid:identificador
- mac: mac
- bridge. parámetros del bridge


   

   

### los archivos .xml de red se guardan en:

```bash
sudo ls /etc/libvirt/qemu/networks/

autostart  default.xml    isolated2.xml  isolated.xml
```



### *Activamos* y comprobamos isolated2

```bash
sudo virsh net-start isolated2Network isolated2 started

Network isolated2 started
```



```bash
sudo virsh net-list --all

 Name                 State      Autostart     Persistent
----------------------------------------------------------
 default              inactive   no            yes
 isolated             active     yes           yes
 isolated2            active     no            yes
```



### ver tarjeta de red de una máquina en mi caso f24

```bash
sudo virsh domiflist f24

Interface  Type       Source     Model       MAC
-------------------------------------------------------
-          direct     enp3s0     virtio      52:54:00:a4:fd:86
```



### asignar tarjeta de red a una máquina.

```bash
sudo virsh start f24
Domain f24 started

sudo virsh attach-interface --domain f24 --source isolated2 --type network --model 

virtio --config --live
Interface attached successfully
--config es para que sea permanente
--live si la máquina está activa, en el caso que estuviera apagada ignorarlo

sudo virsh domiflist f24Interface  

Type       Source     Model       MAC
-------------------------------------------------------
macvtap0   direct     enp3s0     virtio      52:54:00:a4:fd:86
vnet0      network    isolated2  virtio      52:54:00:80:b9:b4
```



### ver puente entre redes.

deducimos el nombre del bridge en el net-dumpxml anterior.

 <bridge name='virbr2' stp='on' delay='0'/>

```bash
 sudo brctl show virbr2

bridge name    bridge id        STP enabled    interfaces
virbr2        8000.525400ca4501    yes        virbr2-nic
					                            vnet0
```



### quitar red virtual de la máquina.

```bash
sudo virsh detach-interface --domain f24  --type network  --config --live --mac 52:54:00:80:b9:b4
Interface detached successfully

sudo virsh domiflist f24
Interface  Type       Source     Model       MAC
-------------------------------------------------------
macvtap0   direct     enp3s0     virtio      52:54:00:a4:fd:86
```

