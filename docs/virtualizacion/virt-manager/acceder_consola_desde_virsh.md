# acceder consola desde virsh

<https://www.certdepot.net/rhel7-access-virtual-machines-console/>

Entrar en la máquina virtual y ejecutar el siguiente comando.

```bash
sudo grubby --update-kernel=ALL --args="console=ttyS0"
```



**Alternativa si no funciona.**

Note: Alternatively, you can edit the ***/etc/default/grub*** file, add ***‘console=ttyS0‘*** to the GRUB_CMDLINE_LINUX variable and execute:

```bash
 sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

Now, reboot the virtual machine:

```bash
sudo reboot
```

```bash
sudo virsh console f24

Connected to domain f24
Escape character is ^]

Fedora 24 (Workstation Edition)
Kernel 4.5.5-300.fc24.x86_64 on an x86_64 (ttyS0)
```

