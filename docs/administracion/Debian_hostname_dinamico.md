# Debian hostname dinamico

https://blog.schlomo.schapiro.org/2013/11/setting-hostname-from-dhcp-in-debian.html



Al parecer debian y ubuntu llevan un tiempo con un pequeño bug, que al hacer la resolución del hostname mediante dhcp, no la resuelve bien. Indagando por internet hay diferentes soluciones y e escogido la que menos agresiva/guarrada me a parecido, en dos sencillos pasos arreglas el problema.



#### 1. Añadir localhost por defecto  

```bash
 echo localhost | tee /etc/hostname
```

#### 2. Solución para el dhclient-script roto 

El dhclient-script tiene (IMHO) un error: si hay un antiguo arrendamiento DHCP con un nombre de host en la base de datos de arrendamiento (por ejemplo, en /var/lib/dhcp/dhclient.eth0.leases), entonces el script no establecerá el nombre de host desde DHCP incluso si el nombre del sistema sigue siendo localhost. 

Para evitar este error, simplemente cree un gancho de entrada dhclient para anular la variable de nombre de host anterior:

```bash
echo unset old_host_name | sudo tee /etc/dhcp/dhclient-enter-hooks.d/unset_old_hostname
```





