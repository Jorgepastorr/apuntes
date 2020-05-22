

# Pam

pam es un conjunto de librerías, que proporciona una api para autenticar aplicaciones (servicios), los clientes de pam, son las aplicaciones que tienen que autenticar.

PAM (plugable autenticable mode), la gracia es que es modular el programa(aplicación) utiliza pam y este ya utiliza la autentificación que se le haya asignado (contraseña, huella dactilar, etc..).

Una aplicación **pam aware**,  es una aplicación que sabe que hará autentificación  usando pam, en el archivo `/etc/pam.conf`

Como saber que una aplicación es *pam aware*, mirando si en sus requisitos existe algún modulo pam.

Cualquier programa que sea pam aware, y no tenga un fichero especifico en `/etc/pam.d`, se le aplica other, que deniega todo por defecto.

`ldd` list dinamic dependencies. listar dependencias.

```bash
➜  ldd /usr/bin/chfn     
    linux-vdso.so.1 (0x00007ffc98950000)
    libpam.so.0 => /lib/x86_64-linux-gnu/libpam.so.0 (0x00007fe8f2566000)
    libpam_misc.so.0 => /lib/x86_64-linux-gnu/libpam_misc.so.0 (0x00007fe8f2561000)
....
```

## *Directorios* de configuración

`/etc/pam.d/`
`/etc/pam.conf`

ruta modulos de pam instalados `/usr/lib64/security/`

Ejemplo archivo pam

```bash
#%PAM-1.0
#type       control     argument
auth       sufficient   pam_rootok.so
auth       include      system-auth
account    include      system-auth
password   include      system-auth
session    include      system-auth
```

file.so la extensión `.so` significa (shared object), objeto compartido, y este puede tener, o no argumentos.

```bash
[root@pam pam.d]# cat system-auth 
#%PAM-1.0
# This file is auto-generated.
# User changes will be destroyed the next time authconfig is run.
auth        required      pam_env.so
auth        sufficient    pam_unix.so try_first_pass nullok
auth        required      pam_deny.so

account     required      pam_unix.so

password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type=
password    sufficient    pam_unix.so try_first_pass use_authtok nullok sha512 shadow
password    required      pam_deny.so

session     optional      pam_keyinit.so revoke
session     required      pam_limits.so
-session     optional      pam_systemd.so
session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid
session     required      pam_unix.so
```

## Types

Pam tiene 4 types diferentes: ` auth, account, password, session`

Hay que saber diferenciar:

- `auth` autentificación, demostrar quien soy
- `autz` a que me da derecho mi autentificación

`auth`  autenticación de usuario, quien soy.

`account` tengo permiso para modificar

`password` reglas para cambiar pasword
`session` cosas a hacer al iniciar y cerrar sesión

**importante**:  pam no es un servicio, al hacer un cambio en los archivos es inmediato

```bash
#%PAM-1.0
auth       optional     pam_echo.so [auth: %h %s %t %u]
auth       required     pam_permit.so
auth       sufficient   pam_unix.so
account    optional     pam_echo.so [auth: %h %s %t %u]
account    sufficient   pam_permit.so
```

`suficient` si da cierto ya vale para la autentificación, en caso que de falso se ignora 

## Controls

La opción de controls, es compleja, tiene echo unos alias donde agrupan una serie de opciones predefinidas mas habituales.

ejemplo:

```bash
required
[success=ok new_authtok_reqd=ok ignore=ignore default=bad]
requisite
[success=ok new_authtok_reqd=ok ignore=ignore default=die]
sufficient
[success=done new_authtok_reqd=done default=ignore]
optional
[success=ok new_authtok_reqd=ok default=ignore]
```

- `ignore`: ignora esta opción

- `bad` :  marca como fallo y sigue evaluando

- `die`: marca como fallo y no evalúes más

- `ok`: marca como resultado positivo y sigue avaluando 

- `done`: resultado positivo y no evalúes más opciones

- `N` numero de casillas a saltar

- `reset` resetea valores anteriores



### Predefinidos

`required` Esta opción siempre tendrá que dar cierto, si da falso,  fallara pero sigue preguntando la siguiente opción.

`requisite`  esta opción tiene que dar cierto, si da falso, cierra, no pasa a la siguiente opcion.

`suficient` Si da cierto ya vale para la autentificación, en caso que de falso se ignora 

`optional` Opciones que intentara hacer, el resultado de los módulos en este control, no afectara a no ser que sea el único a evaluar

`include`  Incluir otros módulos de reglas existentes como si estuvieran en el mismo archivo

`substack` llama a otro archivo y devuelve true o false, según la tabla de reglas.



**Ejemplo include, subsrack**:

En el caso siguiente substack llama al archivo proves, devuelve true, pasa a la siguiente regla y pide contraseña pam_unix.so . Si   cambiamos substack por include, include le el archivo proves y como el sufficient da true, ya lo da por valido, no pasa a la siguiente regla y no pide contraseña.

En el caso de que substack devuelva false, seguirá preguntando reglas pero nunca dará positiva la acción.

*/etc/pam.d/chfn*

```bash
#%PAM-1.0
auth       optional     pam_echo.so
auth       substack     proves
auth       required     pam_unix.so

account    optional     pam_echo.so
account    sufficient   pam_permit.so
```

*/etc/pam.d/proves*

```bash
#%PAM-1.0
auth    sufficient pam_permit.so
```

## Argumentos

### Manejo de contraseñas

Los argumentos tipo `pam_unix.so, pam_ldap.so, pam_mount.so, etc...` que requiere insertar contraseña, tienen diferentes atributos para gestionarlas. 

- Si no tiene atributos se pedirá contraseña.

- `try_first_pass` si se a introducido una contraseña anteriormente la hace servir, en el caso contrario la pide.

- `use_first_pass`  usa la contraseña  introducida anteriormente, si no se ha  introducido ninguna antes, no usara ninguna.

- `nullok` permite acceso a usuarios sin contraseña.

`password requisite pam_pwquality.so` establece las reglas para definir condiciones contraseñas 

`/etc/securitt/pwquality.conf` archivo de condiciones.

### Restricciones

`pam_succeed_if.so`  aplica restricciones

```bash
auth required pam_succeed_if.so user = pere
auth required pam_succeed_if.so user != “pere”
auth required pam_succeed_if.so uid > 1000
```



Otra manera de restringir es crear un control propio. En el siguiente ejemplo, si el usuario es `uid=1001` saltara una linea y se le denegara el acceso, en caso contrario se ignorara `pam_succed_if` y se evaluara la siguiente linea. 

```bash
auth [success=1 default=ignore] pam_succeed_if.so debug uid = 1001
auth sufficient pam_permit.so
auth sufficient pam_deny.so
```







`pam_time.so`  aplica restricciones, en condiciones en torno al tiempo. Solo funciona en account y funciona junto al archivo `/etc/security/time.conf`

bloquear a local1 de 8h a 24h toda la semana

```
services;ttys;users;times
chfn;*;local1;Al0800-2400
```

```
todas las combinaciones aceptadas son: Mo Tu We Th Fr Sa Su Wk Wd Al, donde Al son todos, Wk de lunes a viernes, Wd fin de semana.
Dos dias repetidos se anulan MoMo = ninguno, y MoWk = dias laborables menos lunes, AlFr = todos los dias excepto viernes.
El formato de hora es un rango de HHMM-HHMM en modo 24h
```

### Homedir

`pam_mkhomedir.so`  indica que al iniciar sesión un usuario, a de crear, si no lo tiene, directamente el home de dicho usuario, por defecto lo creara con las directrices de skel, a no ser que se le indique lo contrario.

*system-auth*

```bash
session     required      pam_mkhomedir.so silent umask=0007
```

### Montajes

Pam_mount permite crear puntos de montaje, de diferentes servicios . `pam_mount.so` tiene que estar en auth y session con el control opcional, a de estar antes del sufficient o del included. Para definir los puntos de montaje utiliza el archivo `/etc/security/pam_mount.conf.xml`

```bash
auth    optional    pam_mount.so
auth    sufficient  pam_ldap.so use_first_pass
auth    required    pam_unix.so use_first_pass
account sufficient  pam_ldap.so
session optional    pam_mount.so
```

un container para poder hacer mounts tienes que poner la opción  `--privileged` en el run

diferentes tipos de montaje.

```bash
# tmpfs
<volume    user="*"     fstype="tmpfs"     mountpoint="~/tmp"
       options="size=100M,uid=%(USER),mode=0775" />
# nfs
<volume user="*" fstype="nfs" server="fileserver" path="/home/%(USER)" mountpoint="~" />

# sshfs
<volume user="*" fstype="fuse" path="sshfs#%(USER)@fileserver:" mountpoint="~" />

# smbfs
<volume user="user" fstype="smbfs" server="krueger" path="public"
mountpoint="/home/user/krueger" />
```



modulos pam

`/usr/lib64/security/`

/etc/exports

```bash
/usr/share/man *(ro,sync)
/usr/share/doc *(ro,sync)
```

`exportfs -s`

```bash
mount -t nfs 172.17.0.1:/usr/share/man /mnt
```



## Ejemplo *system-auth* para ldap

```bash
#%PAM-1.0
# This file is auto-generated.
# User changes will be destroyed the next time authconfig is run.
auth        required      pam_env.so
auth        optional      pam_mount.so
auth        sufficient    pam_unix.so try_first_pass nullok
auth        sufficient    pam_ldap.so try_first_pass
auth        required      pam_deny.so

account     sufficient      pam_unix.so
account     sufficient    pam_ldap.so
account     required      pam_deny.so

password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type=
password    sufficient    pam_unix.so try_first_pass use_authtok nullok sha512 shadow
password  sufficient      pam_ldap.so try_first_pass
password    required      pam_deny.so

session     optional      pam_keyinit.so revoke
session     required      pam_limits.so
-session     optional      pam_systemd.so
session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid
session     required      pam_mkhomedir.so
session     optional      pam_mount.so
session     sufficient      pam_unix.so
session     sufficient      pam_ldap.so
```





## Authconfig

Es una manera de modificar el archivo `system-auth`  automáticamente, pasando-le una serie de parámetros que los encontraremos en `authconfig --help` y `man authconfig` .

```bash
authconfig --enableshadow --enablelocauthorize \
   --enableldap \
   --enableldapauth \
   --ldapserver='ldapserver' \
   --ldapbase='dc=edt,dc=org' \
   --enablemkhomedir \
   --updateall
```

- `enableldap` : modifica los archivos `nsswitch.conf, nslcd.conf`  para tener acceso al servidor ldap.
- `enableldapauth`: añade las lineas `pam_ldap.so` en el archivo `system-auth`
- `enablemkhomedir`: añade `pam_mkhomedir.so` a `system-auth`





## Aplicación PamAware

 https://pypi.python.org/pypi/python-pam/ 

En ocasiones queremos que alguna aplicación  autentifique usuarios del sistema. Python tiene su modulo pam `python-pam, python3-pam`, que se puede instalar tanto con pip como con dnf.



Ejemplo autentificación con el sistema, si es correcta muestra un rango del 1 al 10.

*pamaware.py*

```python
#!/usr/bin/python
import pam

p=pam.pam()
userName=raw_input("Nom usuari: ")
userPasswd=raw_input("Passwd: ")

p.authenticate(userName, userPasswd)
print('{} {}'.format(p.code,p.reason))

if p.code == 0:
    for i in range(1,11):
        print i,
else:
    print "Error autenticacio"
```

```
# python pamaware.py
Nom usuari: marti
Passwd: marti
10 User not known to the underlying authentication module
Error autenticacio

# python pamaware.py
Nom usuari: pere
Passwd: kaka
7 Authentication failure
Error autenticacio

# python pamaware.py
Nom usuari: pere
Passwd: pere
0 Success
1 2 3 4 5 6 7 8 9 10
```





## Creación modulo pam

documentación

- https://pypi.python.org/pypi/python-pam/1.8.1
- http://stackoverflow.com/questions/5286321/pam-authentication-in-python-without-root-privileges

Pam python

- https://atlee.ca/software/pam/index.html

Python Pam

- http://pam-python.sourceforge.net/



Para la creación de un modulo python, se necesita descargar  y compilar el ejecutable `pam_python.so` .

Este paquete tiene sus dependencias que instalamos a continuación.

```bash
tar xvzf pam-python-1.0.6.tar.gz
dnf -y install sphinx python3-sphinx python2-sphinx gcc
dnf -y install pam-devel
dnf -y install redhat-rpm-config
dnf -y install python-devel
## editar línia 201 de: /usr/include/features.h:
# he canviat 700 per 600 en la línia # define _XOPEN_SOURCE 700
make
cp src/pam_python.so /usr/lib64/security/.
```



Una vez con el ejecutable del modulo en su sitio ya podemos crear nuestro archivo pam. para la prueba modifico el archivo `/etc/pam.d/chfn`

```bash
#%PAM-1.0
auth       optional     pam-echo.so [ auth ------- ]
auth       sufficient	pam_python.so /opt/docker/pam_mates.py

account     optional     pam-echo.so [ account ------- ]
account     sufficient	pam_python.so /opt/docker/pam_mates.py

password   include      pam_deny.so
session    include      pam_deny.so
```



y ubico en `/opt/docker` mi programa `pam_mates.py`

```python
# pam_mates.py
# Validar lusuari realitzant una pregunta de matemtiques

def pam_sm_authenticate ( pamh, flags, argv):
    print "Quant fan 3*2?"
    resposta=raw_input()
    if int(resposta) == 6:
        return pamh.PAM_SUCCESS
    else:
        return pamh.PAM_AUTHTOK_ERR
def pam_sm_setcred (pamh, flags, argv):
    return pamh.PAM_SUCCESS

def pam_sm_acct_mgmt ( pamh, flags, argv):
    return pamh.PAM_SUCCESS

def pam_sm_open_session ( pamh, flags, argv):
    return pamh.PAM_SUCCESS

def pam_sm_close_session (pamh, flags, argv):
    return pamh.PAM_SUCCESS

def pam_sm_chauthtok (pamh, flags, argv):
    return pamh.PAM_SUCCESS
```

> Este programa se a echo a partir de copiar el ejemplo `pam_permit.py` de la documentación de pam_python. http://pam-python.sourceforge.net/examples/



Este ejemplo muestra el resultado del programa, si el usuario acierta la respuesta matemática, se le dejara cambiar el chfn

```
$ chfn anna
Changing finger information for anna.
Name []: 2
Office []: 2
Office Phone []: 2
Home Phone []: 2
auth -----------------
Quant fan 3*2?
6
account --------------
Finger information  changed . 
```

