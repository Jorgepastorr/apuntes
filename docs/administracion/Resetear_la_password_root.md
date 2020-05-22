# Resetear la password root.

Tenemos que iniciar el sistema en modo emergencia y permisos de escritura y lectura.

- al iniciar el ordenador en la pantalla de grub clicar “e” en la partición deseada.
- añadimos `rw init=/bin/bash` al final de la línea linux16 .

una vez dentro cambiar la pasword root con:

```bash
passwd
```



para evitar fallos con selinux crear archivo vacío.

Esto te permite reiniciar guardando los datos e ignorando el selinux ( barrera de seguridad )

```bash
touch /.autorelabel
/sbin/reboot -f
```



