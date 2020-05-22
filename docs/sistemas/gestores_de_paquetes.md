Gestores de paquetes

## Paquetes rpm

Los paquetes rpm se encuentran en los repositorios que se guardan en `/etc/yum.repos.d`.

**Querys**

```bash
rpm -qa 			# paquetes instalados
rpm -ql paquete 	# ver contenido de paquete instalado
rpm -qlp paquete.rpm 	# ver contenido de paquete sin instalar
rpm -qd paquete 	# ver paquetes de documentación
rpm -qc paquete 	# ver paquetes de configuración
rpm -qi paquete 	# información del paquete
rpm -qp --requires paquete.rpm	# ver dependencias del paquete
rpm -qp --scripts paquete.rpm 	# ver scripts pre y post intalación
rpm -qf /usr/bin/useradd	# ver a que paquete pertenece un archivo
```

> La opción `-p` es para cuando el paquete esta en el directorio actual

```bash
rpm -q --whatrequires dhclient	# ver quepaquetes usan el indicado
NetworkManager-1.2.6-1.fc24.x86_64
dracut-network-044-21.fc24.x86_64
```



**Manejo de rpm**  

```bash
rpm -i paquete.rpm	# instala paquete
rpm -U paquete.rpm	# actualizar paquete
rpm -e paquete.rpm	# eliminar paquete
rpm --rebuilddb		# actualizar base de datos rpm

# -vh permiten visualizar vel progreso en las opciones anteriores.
rpm -ivh tftp-server-5.2-18.fc24.x86_64.rpm
Preparing...                                                           ################################# [100%]
Updating / installing...
   1:tftp-server-5.2-18.fc24                                           ################################# [100%]
```



### dnf

```bash
dnf list installed		# ver paquetes instalados
dnf provides orden		# ver a que paquete pertenece una orden
dnf download paquete	# descargar un paquete
dnf search paquete		# buscar paquete en repositorios

dnf update				# actualizar repositorios
dnf upgrade				# actualizar systema
dnf dist-upgrade		# actualizar distribucion

dnf install paquete		# instalar paquete
dnf reinstall paquete	# reinstalar paquete
dnf upgrade paquete		# actualizar paquete
dnf [remove|erase] paquete		# borrar paquete
dnf purge paquete		# borrar configuración paquete
dnf autoremove			# borrar paquetes inecesarios
dnf clean 				# borrar headers

dnf group list			# listar grupos de paquetes 
dnf group install "grupo"		# instalar grupo

dnf repolist			# listar repositorios instalados
dnf repolist [enabled|disabled|all]
dnf config-manager --set-disabled repo_id	# desabilitar repositorio
dnf config-manager --set-enabled repo_id	# habilitar reppositorio
```





## Paquetes deb

Los repositorios oficiales de debian  están en la ubicación `/etc/apt/sources.list`  y los que añades posteriormente en `/etc/apt/sources.list.d/` .

Su composición es la siguiente:

```bash
deb http://ftp.caliu.cat/pub/distribucions/debian/ testing main contrib non-free 
deb-src http://ftp.caliu.cat/pub/distribucions/debian/ testing main contrib non-free
```

- `deb`: indica donde  buscar los fitcheros binaris

- `deb-src`: indica donde buscar el codigo fuente

- `stable testing oldstable o nombre de distro` : que tipo de paquetes usar.

- `main` : paquetes oficiales de debian 100% codigo libre

- `contrib` : paquetes que pueden tener alguna libreria no libre

- `non-free` : paquetes que tienen veneno según el código libre

[wiki de debian](https://wiki.debian.org/SourcesList)

**Añadir repositorio y su firma**

```bash
echo "deb https://riot.im/packages/debian/ stretch main" > /etc/apt/sources.list.d/matrix-riot-im.list
curl -L https://riot.im/packages/debian/repo-key.asc | sudo apt-key add
```



**Información**  

```bash
dpkg -l paquete		# lista los paquetes que coinciden con el patron
dpkg -L paquete		# muestra la lista de ficheros instalador por el paquete
dpkg -S /bin/ping	# busca a que paquete pertenece ese fichero
dpkg -s paquete		# muestra el estado actual de un paquete
dpkg -p paquete		# muestra detalles sobre un paquete instalado
dpkg -I paquete 	# informacion del paquete
```



**Acciones** 

```bash
dpkg -i paquete.deb	# instala un paquete
dpkg -r paquete 	# borra un paquete
dpkg -P paquete		# borra paquete y los ficheros de configuración
dpkg -C paquete		# busa ficheros instalados parcialmente y pregunta que hacer
```

```bash
dpkg --configure [opciones] paquete	# reconfigura paquete instalado
```

- `-ftype, --frontend=type`: Seleccioneu el frontend a utilitzar 
- `-pvalue, --priority=value`: Especifica el llindar mínim de prioritat. Tots les opcions de configuració igual o per sobre d'aquest llindar, seran mostrades.
- `--default-priority`: Utilitzar la prioritat per defecte.
- `-a, --all`: Configurar tots els paquets del sistema que utilitzen debconf
- `-u, --unseen-only`: Només mostra les qüestions que no han esta contestades prèviament.
-  `--force`: Força un dpkg-reconfigure inclús si el paquet està en un estat inconsistent o trencat.
- `--no-reload`: No torna a carregar les plantilles.
- `-h, --help`: Mostra com funciona l'ordre.



### apt

**Actualización**  

```bash
apt update			# actuliza repositorios
apt upgrade			# actualiza sistema
apt full-upgrade	# actualizaca nueva distribución si la hay
apt dist-upgrade	# lo mismo
```



**Acciones**  

```bash
apt search paquete			# buscapor nombre o descripcion del paquete
apt show paquete			# muestra informacion 
apt download paquete		# descarga paquete

apt install	paquete			# intala paquete
apt install paquete=version	# instala con la version indicada
apt reinstall paquete		# reinstala
apr remove paquete			# borra paquete

apt source paquete			# descarga codigo fuente
apt build-dep paquete		# compilar dependencias codigo fuente
apt -b source paquete		# compilar paquete

apt --fix-broken install	# repara paquetes rotos
```



```bash
tasksel --list-task			# muestra grupos de paquetes
tasksel  install paquete	# instala grupo de paquetes
apt install paquete^		# lo mismo
```



**Limpieza**  

```bash
apt autoclean		# borra paquetes que no se necesitan
apt autoremove		# borra paquetes que eran dependencias de otros y ya no se usan
apt purge paquete	# borra cconfiguracion del paquete
apt list [--install|--upgradable|--all-versions]	# muesta informacion
```



**Reparación**   

En ocasiones se queda algún paquete mal instalado y obstaculiza la gestión de nuevos paquetes.

```bash
sudo fuser -vki  /var/lib/dpkg/lock
rm /var/lib/dpkg/lock
dpkg --configure -a
sudo apt-get autoremove
```

> Lo que estamos haciendo es: matar todos los procesos que están utilizando dicho archivo 
>
> borrar el archivo,  re-configurar todos los paquetes por si a quedado alguno en mal estado.
>
> Borrar los que no son necesarios.



## Paquetes pkt

Los repositorios pacman se encuentran en `/etc/pacman.conf`, cada `[opcion]` se refiere a un repositorio distinto. Es importante que los [oficiales](https://wiki.archlinux.org/index.php/official_repositories) estén por encima de los [no oficiales](https://wiki.archlinux.org/index.php/Unofficial_user_repositories), ya que buscara por orden de llegada.

```bash
...
[core]
SigLevel = PackageRequired
Include = /etc/pacman.d/mirrorlist

[extra]
SigLevel = PackageRequired
Include = /etc/pacman.d/mirrorlist
...
[archlinuxfr]
SigLevel=Never
Server=http://repo.archlinux.fr/$arch
```

- Para añadir un repositorio no oficial solo tenemos que editar el `pacman.conf` como esta de ejemplo en el cuadro de código anterior y actualizar la base de datos.

Para gestionar paquetes de AUR existen diferentes gestores, se recomienda yay, aurman, etc...

### Pacman

**Consultas** 

```bash
pacman -Q			# var paquetes instalados
pacman -Qc paquete	# mostrar cambios del paquete
pacman -Qi paquete	# informacion del paquete
pacman -Ql paquete	# listar archivos del paquete
pacman -Qm 	# ver paquetes instalados que no estan en repos 
pacman -Qo file		# ver a que paquete pertenece el archivo
pacman -Qp file		# consultar un archivo de paquete
pacman -Qs paquete	# buscar paquete instalado
pacman -P 			# ver todas las opciones disponibles
```



**Acciones**

```bash
pacman -Sw paquete	# descargar paquete sin instalar
pacman -S paquete	 # instalar paquete
pacman -Ss paquete	# buscar paquete ven los repositorios
pacman -Su 			# actualizar sistema
pacman -Sy			# actualizar base de datos
pacman -Syu			# actualizar base y sistema
pacman -R paquete	# borrar paquete
pacman -Rs paquete 	# borrar paquete y sus dependencias 
pacman -Sc 			# borrar paquetes cache no instalados
```





























