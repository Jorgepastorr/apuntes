# getenforce

getenforce es un sistema de seguridad extra  los permisos adicionales.

- permissive → Desactivada, útil para cuando juegas con las particiones o ficheros del sistema.

```bash
setenforce 0 # desactivar temporalmente
```

- enforce → activada, siempre ha de estar activada por posibles ataques.

```bash
setenforce 1 # activar temporalmente
```



<u>Activar o desactivar permanentemente.</u>

modificar el siguete archivo:

***/etc/selinux/config***

```bash
 ---
 SELINUX=enforcing
 ---
```

