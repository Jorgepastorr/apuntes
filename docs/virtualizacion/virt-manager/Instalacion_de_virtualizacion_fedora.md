# Instalación de virtualización fedora

**Comprobar si nuestra cpu es intel VT-x o amd AMD-V y tiene el paquete de virtualización.**

```bash
egrep '(vmx|svm)' --color=always /proc/cpuinfo
lscpu
```

- Sino habilitar desde la bios.



**Comprobar si esta el modulo de kvm cargado.**

```bash
lsmod | grep kvm
```



**Mirar los bits de nuestra máquina mejor si son 64**

```bash
uname -m
```



**Comprobar sistema operativo y versión ( extra no es necesario )**

- Versió:    cat /etc/redhat-release                Fedora release 24 (Twenty Four)
- Versió:    uname -r                                       4.6.7-300.fc24.x86_64



**Instalar paquete de virtualización**

```bash
sudo dnf group install --with-optional virtualization
```



**ver paquetes binarios instalados**

```bash
rpm -qa | grep -E "kvm|virt"
```



**Iniciar el servicio de virtualización libvirt**

```bash
sudo systemctl start libvirtd.service
sudo systemctl enable libvirtd.service
```





**Iniciar virt-manager com usuario no root**

- Con la configuración inicial sólo puede usar los servicios root,  la cambiamos para dar permisos a cualquiera.

```bash
vim /etc/libvirt/libvirtd.conf —> auth_unix_rw = "none"
```

- Reiniciar el dominio de máquinas virtuales para guardar configuración.

```bash
 sudo systemctl restart libvirtd.service
```



 **Ya podemos usar los paquetes, por ejemplo abrir particiones reales virtualizadas.** 

```bash
sudo qemu-kvm /dev/sda
```

