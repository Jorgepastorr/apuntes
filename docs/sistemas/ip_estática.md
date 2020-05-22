#  ip estática raspberry

### Wlan

***/etc/network/interfaces***

```bash
auto wlan0

  iface lo inet loopback
  allow-hotplug wlan0
  iface wlan0 inet static
  address <ip desitjada>
  netmask <màscara>
  gateway <gateway>
  wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
  iface default inet dhcp
```



**/etc/wpa_supplicant/wpa_supplicant.conf**

```bash
network={
  ssid="<ssid xarxa>"
  psk="<contrasenya>"
}
```



## eth0

**/etc/network/interfaces**

```bash
auto eth0

  iface lo inet loopback
  iface eth0 inet static  
  address 192.168.1.75  
  netmask 255.255.255.0   
  gateway 192.168.1.1
```



  

  

# IP estática fedora.

buscar el archivo:

/etc/sysconfig/network-scripts/ <fichero con nombre de la tarjeta de red>

modificar.

```bash
DEVICE=eth0                                <nombre tarjeta de red>
BOOTPROTO=static
DNS1=8.8.8.8                               <tu dns/gateway>
DNS2=4.4.4.4
GATEWAY=192.168.0.1                <gateway>
HOSTNAME=node01.tecmint.com <Nombre que te ven en línea>
IPADDR=192.68.0.100                <IP-deseada>
NETMASK=255.255.255.0          <Mascara>
TYPE=Ethernet
NETWORKING_IPV6=no              <opcional>
IPV6INIT=no                                    <opcional>
```

actualizar lo cambios.

```bash
sudo systemctl restart network
```



