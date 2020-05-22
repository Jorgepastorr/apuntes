## Permisos avanzados


| nombre | valor | valor octal |
| :----: | :----: | :----: |
| setuid | s | 4 |
| setgid | s | 2 |
| sticky | t | 1 |

<br>  

En ficheros podemos jugar con setuid y setgid, sticky es solo para directorios.
El concepto es simple, cuando están aplicados setuid o setgid ese fichero se ejecutara en nombre del usuario del fichero o del grupo del fichero.

<br> 
**Setuid**   

Con setuid aplicado en un fichero, dicho fichero se ejecutara en nombre del usuario del fichero.

Podemos ver que el bit está asignado (s) haciendo un ls:
```bash
$ ls -l /bin/su
-rwsr-xr-x 1 root root 31012 2015-04-04 10:49 /bin/su

# Para asignar este bit a un fichero:
chmod u+s /bin/su
# en octal
chmod 4755 /bin/su

# Y para quitarlo:
chmod u-s /bin/su
# en octal
chmod 0788 /bin/su
```
> Si no tuviera  el setuid asignado no podrías ejecutar su, ya que se te negaría el permiso.

<br>
**Setgid**       

Setgid se puede aplicar tanto a ficheros como a directorios. En ficheros se comporta igual que setuid pero asignado al grupo.
Lo interesante es la aplicación en directorios. Si queremos tener un directorio compartido, se aplica setgid y todos los archivos que se creen dentro pertenecerán al grupo del directorio.

Podemos ver que el bit está asignado (s) haciendo un ls:
```bash
$ ls -l compartida
-rwxrwsr-x 1 jorge jorge  31012 2018-08-10 12:25 compartida/

# Para asignar este bit a un fichero:
chmod g+s  compartida/
# en octal
chmod 2755 compartida/

# Y para quitarlo:
chmod g-s  compartida/
# en octal
chmod 0788  compartida/
```

Creo un archivo con otro usuario dentro del directorio y ago la prueba.
```bash
$ su
# touch test
root@sistemas:/home/jorge/compartido
# ls -l
total 0
-rw-r--r-- 1 root jorge 0 2018-08-10 12:30 test
# whoami
root
```
<br>  

**Sticky**  
Se suele asignar a directorios al que todo el mundo tiene acceso, permite evitar que un usuario borre los archivos de otro ya que tiene permisos de escritura dentro del directorio. Cabe decir que aun que se asigna en la sección de others también afecta al grupo.

Podemos ver que el bit está asignado (t) haciendo un ls:
```bash
$ ls -l compartida
-rwxrwxr-t 1 jorge jorge  31012 2018-08-10 12:25 compartida/

# Para asignar este bit a un fichero:
chmod o+t compartida/
# en octal
chmod 1755 compartida/

# Y para quitarlo:
chmod o-t  compartida/
# en octal
chmod 0788  compartida/
```

<br>  

## ACL Acces Control List

**Opciones básicas**  

| Opción | Acción |
| :---: | :-------------------- |
| b | borrar todas acl's |
| k | borrar todas las default |
| R | recursivo |
| x | borrar acl especifica |
| d | default añadir por defecto |
| m | añadir o modificar acl |

<br>  

**Sintaxis** 
```bash
# Agregar permisos para un usuario
setfacl -m "u:user:permissions" <file/dir>
# Agregar permisos para un grupo (group es el nombre del grupo o el ID del grupo):
setfacl -m "g:group:permissions" <file/dir>
```
<br>  

**Ejemplos** 

Mostrar acl\'s
```bash
getfacl <nombre archivo>
```

Borrar todas las acl del directorio compartida
```bash
setfacl -bkR compartida
```
Borrar acl de grupo para el usuario user3
```bash
setfacl -x g:user3 <file/dir>
```

Establecer todos lo permisos para el usuario Jhonny en el archivo con nombre “abc”:
```bash
setfacl -m "u:johny:rwx" abc
```

Dar permisos de  g=rw- a archivos dentro del directorio compartida y permisos g=rwx a los directorios por defecto y de forma recursiva
```bash
setfacl -dRm g::rwx compartida
```
<br>  

#### Ejemplo practico

**Queremos que 3 usuarios que pertenecen al departamento de secretaria, trabajen compartiendo archivos de un directorio. Los otros no podran ver el contenido del directorio.
Los tres podran leer y editar pero no borrar el de su compañero.**

- Umask por defecto 0022


Creo carpeta y añado permisos de setgid y sticky para compartir libremente.

**Con user1** 
```bash 
mkdir -m 3770 compartida
chgrp secre compartida
```

Con acl añado permisos para que el grupo puedan editar archivos entre ellos

```bash
setfacl -dRm g:secre:rwx compartida
```
> Esto hace que al crear archivos se creen por defecto con permisos de grupo rw-

Creo nuevos archivos y verifico que funciona
```bash
# user1
ls > compartida/info.txt

# user2
ls > compartida/data.pdf

# user3
ls > compartida/carta.odt
```
```bash
# user3
ls -l compartida/
-rw-rw----+ 1 user3 secre 642 nov 10 19:58 carta.odt
-rw-rw----+ 1 user2 secre  30 nov 10 19:58 data.pdf
-rw-rw----+ 1 user1 secre  11 nov 10 19:57 info.txt
```

Verifico que puedo editar en otros pero no borrar el trabajo de otros.
```bash
# user3
$ echo "modificando ultima linea" >> compartida/info.txt 
$ rm compartida/info.txt 
rm: no se puede borrar 'compartida/info.txt': Operación no permitida
```

Ahora dentro de compartida creo un directorio excluyendo a user3
```bash
# user1
mkdir compartida/top-secret
ls > compartida/top-secret/info2.txt
setfacl -m u:user3:--- compartida/top-secret
```

```bash
# user3
$ ls compartida/top-secret/
ls: no se puede abrir el directorio 'compartida/top-secret/': Permiso denegado
```
