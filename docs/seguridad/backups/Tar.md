# Tar

### Opciones básicas

```bash
-c # comprime
-x # descomprime
-z # gzip
-J # xz
-j # bzip2
-p # conserva permisos
-h # conservar softlinks
-v # muestra informacion vervose
-P # conserva ruta absoluta
-f # referencia a archivos       
-t # ver interior tar
-u # añadir archivo a tar
--exclude # Excluir directorio o fichero
--delete # borrar ruta del interior del tar
```

### Niveles de compresión

```bash
tar -cpf backup.tar /home/*
gzip -1 backup.tar
```

- Comprime de nivel 1 mínima a 9 máxima compresión

### Ruta absoluta

Al tener ruta absoluta se restaurara el archivo automáticamente en su destino

```bash
# Comprimir
sudo tar -czpvPf backup-sudoers-ruta-absoluta.tar.gz /etc/sudoers

#Visualizar para comprobar:
sudo tar -tzpvf backup-sudoers-ruta-absoluta.tar.gz
-r--r----- root/root      3337 2015-09-27 20:58 etc/sudoers

#Descomprimir tar.gz
sudo tar -xzpvPf backup-sudoers-ruta-absoluta.tar.gz
```

```bash
# ruta absoluta dentro del comprimido
tar --transform="s,ASIX1,/usr/share/ASIX," -czvf paquet-4.tar.gz ASIX1 --show-transformed-names
```

### Comprimir diversas rutas

Comprimir con ruta relativa es lo mismo que la absoluta sin opción P

Creas un archivo con diversas rutas.

***seleccio.txt***  

```bash
/etc/sudoers
/etc/httpd/conf/httpd.conf
```

```bash
# Comprimes
tar -czpvP --files-from=seleccio.txt -f conf-server.tar.gz

# ver comprimido
tar -tzf conf-server.tar.gz

# restaurar
tar -xzpvPf conf-server.tar.gz
```

### Excluir archivos

Se excluirán todos los archivos que contengan la palabra top

```bash
tar  -v --exclude='*Top*' -f SHIELD-ACL-excl-patro.tar.gz SHIELD/
```

Excluyendo con varios parámetros.

```bash
cat > exclusions.txt
Misiones
SHIELD/AGENTES/OFICINA/Jugar.txt
```

```bash
tar  -v --exclude-from=exclusions.txt -f SHIELD-ACL-excl-fitxer.tar.gz SHIELD/
```

### Extraer

Extraer normal

```bash
tar -xzpvf SHIELD-ACL.tar.gz
```

Extraer en ruta concreta

```bash
tar -xzpv -C /home/user/ACLs/ACLs.scripts/test/ -f SHIELD-ACL.tar.gz
```

Extraer solo archivos específicos

```bash
tar -xzpv -C /home/user/ACLs/ACLs.scripts/test/ -f SHIELD-ACL.tar.gz *OFICINA*
```

Extraer solo archivos que coincidan con el patrón

```bash
tar --acls -xzpvf SHIELD-ACL.tar.gz *{fe,et}*.txt
```

### Añadir archivos a un tar

Primero descomprimimos de tar.gz a tar

```bash
gzip -d SHIELD-ACL.tar.gz
```

añadimos

```bash
tar  -uvf SHIELD-ACL.tar Fitxer-a-afegir.txt Fitxer-a-afegir2.txt
```

volvemos a comprimir

```bash
gzip SHIELD-ACL.tar
```

### Eliminar archivos del tar

Primero descomprimimos de tar.gz a tar

```bash
gzip -d SHIELD-ACL.tar.gz
```

Eliminamos

```bash
tar --delete Fitxer-a-eliminar*.txt -f SHIELD-ACL.tar
```

volvemos a comprimir

```bash
gzip SHIELD-ACL.tar
```

### Mostrar progreso

Mostrar progreso desde consola:

```bash
tar -czf - ./Downloads/ | (pv -p --timer --rate --bytes > backup.tgz)
```

Mostrar progreso con  TUI(Text User Interface):

```bash
tar -czf - ./Documents/ | (pv -n > backup.tgz) 2>&1 | dialog --gauge "Progress" 10 70
```

## Backups Incrementares y Diferenciales

Los 2 parten de un backup completo, la diferencia es que:

- El Incremental solo guarda la información de los cambios desde el ultimo backup, y para restaurar tengo que utilizar todos los backups increméntales + el total.
- El diferencial guarda los cambios echos a partir del total, para restaurar solo necesito un total y el diferencial.

### Incremental

Suponemos que hago los backups diarios.

estructura:

```bash
.
├── backups
│   └── snars
└── docs
    ├── A
    ├── B
    ├── C
    └── D

3 directories, 4 files
```

Creo un primer backup total

```bash
debian  ➜ tar cvzf backups/total-domingo-03-2019.tgz -g backups/snars/total-domingo-03-2019.snar docs
cp backups/snars/total-domingo-03-2019.snar backups/snars/incremental-03-2019.snar
```

> La opción `-g` indica la ubicación del archivo  donde guarda el registro de backups.

Lunes al acabar el día creo primer incremental.

```bash
debian  ➜ tar cvzf backups/incremental-lunes-03-2019.tgz -g backups/snars/incremental-03-2019.snar docs

docs/
docs/E
docs/F
```

- Observo que han habido cambios y los guarda

Martes al fin de día lo mismo.

```bash
debian  ➜ tar cvzf backups/incremental-martes-03-2019.tgz -g backups/snars/incremental-03-2019.snar docs

docs/
docs/A
```

- Han editado A y guarda los cambios

#### Restaurar incremental

Para restaurar se tiene que restaurar el total más todos los incrementales hasta el día que quieres.

Por comodidad restaurare en tmp

```bash
debian  ➜ tree backups  
# obserbo que backups tengo
backups
├── incremental-lunes-03-2019.tgz
├── incremental-martes-03-2019.tgz
├── snars
│   ├── total-domingo-03-2019.snar
    └── incremental-03-2019.snar 
└── total-domingo-03-2019.tgz

# restauro el total
debian  ➜ tar xvzf backups/total-domingo-03-2019.tgz -C /tmp 
docs/
docs/A
docs/B
docs/C
docs/D
0 directories, 4 files

# lunes
debian  ➜ tar --incremental xvzf backups/incremental-lunes-03-2019.tgz -C /tmp 
docs/
docs/E
docs/F

# martes
debian  ➜ tar --incremental xvzf backups/incremental-martes-03-2019.tgz -C /tmp 
docs/
docs/A

# lo tengo todo
debian  ➜  pruevas tree /tmp/docs                                         
/tmp/docs
├── A
├── B
├── C
├── D
├── E
└── F
```

### Diferenciales

Diferenciales son más útiles para cada semana o cada mes.

Parto del total anterior.

Hago el primer backup de la semana y se guardan todos los cambios de la semana.

```bash
debian  ➜  cp backups/snars/total-domingo-03-2019.snar backups/snars/diferencial-S1.snar
debian  ➜  tar cvzf backups/dif-semana1-03-2019.tgz docs -g backups/snars/diferencial-S1.snar

docs/
docs/E
docs/A
docs/F
tar: docs/D: el fichero no ha cambiado; no se vuelca
tar: docs/C: el fichero no ha cambiado; no se vuelca
```

En la segunda semana al hacer un diferencial partiendo de principio de mes, se guardan cambios de las 2 semanas.

```bash
debian  ➜  cp backups/snars/total-domingo-03-2019.snar backups/snars/diferencial-S2.snar
debian  ➜  tar cvzf backups/dif-semana2-03-2019.tgz docs -g backups/snars/diferencial-S2.snarz

docs/
docs/E
docs/project/
docs/project/Z
docs/project/A
docs/A
docs/F
tar: docs/D: el fichero no ha cambiado; no se vuelca
tar: docs/C: el fichero no ha cambiado; no se vuelca
```

#### Restaurar diferencial

Al restaurar diferenciales solo necesitas un total  y el ultimo diferencial.

```bash
debian  ➜ tar --incremental xvvzf backups/total-domingo-03-2019.tgz -C /tmp
drwxr-xr-x debian/debian    13 2019-03-03 13:21 docs/
-rw-r--r-- debian/debian     0 2019-03-03 13:21 docs/A
-rw-r--r-- debian/debian     0 2019-03-03 13:21 docs/B
-rw-r--r-- debian/debian     0 2019-03-03 13:21 docs/C
-rw-r--r-- debian/debian     0 2019-03-03 13:21 docs/D

debian  ➜  tar --incremental xvvzf backups/dif-semana2-03-2019.tgz -C /tmp
drwxr-xr-x debian/debian     0 2019-03-03 14:31 docs/
-rw-r--r-- debian/debian     0 2019-03-03 13:43 docs/E
drwxr-xr-x debian/debian     0 2019-03-03 14:25 docs/project/
-rw-r--r-- debian/debian     0 2019-03-03 14:25 docs/project/Z
-rw-r--r-- debian/debian     0 2019-03-03 14:25 docs/project/A
-rw-r--r-- debian/debian     0 2019-03-03 13:43 docs/F
```





Un gráfico de como funcionaría las restauracioners y desde donde cogen referencia

```bash

                       semana1           semana2

            +             +                 +
            |             |                 |
            | <-----------------------------+
            |             |                 |
            |  +   +      |    +   +        |
            |  |   |      |    |   |        |
            +<------------+    |   |        |
            |  +<--+      |    | <-+        |
            +<-+   |      |    |   |        |
            |  |   |      | <--+   |        |
            +----------------------------------------------+
			  lu  ma          lu   ma
      total
```

