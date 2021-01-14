# Ansible

https://docs.ansible.com/ansible/latest/modules/modules_by_category.html

## Intalación

```bash
sudo apt install ansible
ansible --version
```

## Configuración

configurar ssh hacia todos los nodos

```bash
ssh-copy-id -i user@host
```



Por defecto ansible utiliza python2, si en los host no esta instalado se reproducira un fallo que no encuentra `/usr/lib/python` se resuelve crando un link en todos los hosts remotos.

```bashç
ln -s /usr/lib/python3 /usr/lib/python
```



### windows

https://docs.ansible.com/ansible/latest/user_guide/windows_setup.html

Para poder controlar remotamente nodos windows con ansible es necesario tener los siguientes modulos de python en el servidor `python3-winrm o pywinrm` y en el nodo remoto tener powershell 3.0 o superior y habilitiar control remoto con puerto 5986.

Una vez habilitada la conexión se tendra que crear un certificado para la conexión o ignorar mediante la siguiente valiable, pasada desde ad-hoc o desde variable de configuración `ansible_winrm_server_cert_validation=ignore`



## Inventory

https://docs.ansible.com/ansible/2.3/intro_inventory.html

El inventorio es donde se definen los servidores a controlar, estos servidores se pueden agrupar por grupos y especificar  argumentos a cada uno de ellos.

Inventori `/etc/ansible/hosts`

```bash
#green.example.com
#blue.example.com
#192.168.100.1
#192.168.100.10

# GRUPO de servers --------------------------------
#[dbservers]
#
#db01.intranet.mydomain.net
#db02.intranet.mydomain.net
#10.25.1.56
#10.25.1.57

# Here's another example of host ranges, this time there are no
# leading 0s:

#db-[99:101]-node.example.com

localhost ansible_connection=local

[vhosts]
192.168.122.200 ansible_user=root

# ALIAS -----------------------------------
# Alias a un server
# vhost1 ansible_host=192.168.122.200 ansible_user=root

# VARIABLES --------------------------------
# Variables a un grupo de servidores
[vhosts:vars]
ansible_python_interpreter=/usr/bin/python3

# SUBGRUPOS -----------------------------------
[debian]
192.168.122.20

[ubuntu]
192.168.122.21

[apt:children]
ubuntu
debian
```

Se pueden separar  las variables en ficheros externos al inventario, estos ficheros se escribe en formato `yaml`.

- `/etc/ansible/group_vars/grupo`
- `/etc/ansible/host_vars/servidor`

```bash
/etc/ansible/group_vars/apt
ansible_become: True

/etc/ansible/host_vars/pc10
ansible_python_interpreter: /usr/bin/python3
```

## Modulos

Ansible trabaja con modulos y realizan las tareas que requrimos, tiene una lista muy extensa de módulos donde podemos encrnttrarlos organizados por: cloud, command,clustering, crypto, database, files, monitoring, ... Lista completa [aquí](https://docs.ansible.com/ansible/2.8/modules/list_of_all_modules.html)



## ad-hoc

sintaxis. `ansible [opciones] servidores,grupos,all [-m modulo] [-a argumentos]`

si no se especifica ningún módulo por defecto utiliza el módulo `command` 

Argumentos pas utilizados en ansible:

```bash
-C 				# comprobar si puede ser realizada una tarea
-u, --user 		# especificar usuario
-i --inventory 	# especificar inventario
-b --become 	# utilizar sudo
-f --fork 		# numero de nodos controlados simultaniamente (default 5)
-k 				# introducir password
--list-hosts 	# listar gosts, grupos del inventario
-m 				# modulo
-a 				# argumentos
```

Ejemplos:

```bash
# listartodos los hosts del inventario
➜  ansible ansible -i hosts all  --list-hosts
  hosts (2):
    localhost
    node

# ejecutar un comando directo
➜  ~ ansible localhost -a "hostname"
localhost | CHANGED | rc=0 >>
pc02

# utilizar modulo ping
➜  ~ ansible 192.168.122.200  -m ping     
192.168.122.200 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}

# usuario especifico
➜  ~ ansible vhosts -u root -m ping
192.168.122.200 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
# filtrar un nodo y comprobar conexión con usario root
➜  ansible ansible --limit node -i hosts all -m ping -u root 
node | SUCCESS => {
    "changed": false,
    "ping": "pong"
}

# instalaciones
# modulo dnf, argumentos intalar vim 
➜  ~ ansible 192.168.122.200 -u root -m dnf -a 'name=vim state=present'
192.168.122.200 | SUCCESS => {
    "changed": false,
    "msg": "Nothing to do",
    "rc": 0,
    "results": [
        "Installed: vim"
    ]
}

# -K preguntar por contraseña
# --become utilizar sudo
➜  ~ ansible 192.168.122.200  -m dnf -a 'name=vim state=present' -b -K
SUDO password: 
192.168.122.200 | SUCCESS => {
    "changed": false,
    "msg": "Nothing to do",
    "rc": 0,
    "results": [
        "Installed: vim"
    ]
}

# inventorio especifico -i --inventory
➜  ~ ansible 192.168.122.200 --inventory my-inventory -m ping     
192.168.122.200 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```



## Playbook

Playbook es una lista de tareas a realizar en  uno o mas nodos remotos, a continuación se muestra dos ejemplos simples.

```yaml
➜  ansible cat playbooks/copiarHost.yml 
---
- name: copiar archivo /etc/hosts
  hosts: all
  remote_user: jorge
  tasks:
  - name: Copiar /etc/hosts
    become: true
    copy: src=/etc/hosts dest=/etc/hosts    

➜  ansible cat playbook.yml
---
- name: instalar vim
  hosts: vhosts
  tasks:
  - name: instalando vim
    dnf:
      name: vim
      state: present
    become: true
  - name: saludar
    shell: echo "Hola Mundo"
```



Para ejecutar un playbook se utiliza la sintaxis ` ansible-playbook [opciones] playbook.yml`

```bash
➜ ansible-playbook playbook.yml -K
SUDO password: 

PLAY [vhosts] *******************************************************************************************

TASK [Gathering Facts] **********************************************************************************
ok: [192.168.122.200]

TASK [instalar vim] *************************************************************************************
ok: [192.168.122.200]

TASK [saludar] ******************************************************************************************
changed: [192.168.122.200]

PLAY RECAP **********************************************************************************************
192.168.122.200            : ok=3    changed=1    unreachable=0    failed=0   
```



Opciones útiles para playbooks, también se pueden utilizar las opciones de ad-hoc:

```bash
-i					# inventario
--syntax-check		# verificar sintaxis de playbook
--list-task			# listar tareas del playbook
--step				# preguntar en cada tarea si ejecutarla
--start-at-task=nombre de la tarea	# empezar desde una tarea especifica
--forks= / -f		# numero de conexiones simultaneas, por defecto 5
```

 

### Parametros básicos

Con `hosts`  especificamos que grupos o servidores ejecutaran la siguientes tareas, el separador es `:` y es posible utilizar los simbolos `& y !` para ambos o negación.

```yml
hosts: serverweb 			# grupo serverweb
hosts: serverweb:dbweb		# grupo serverweb y dbweb
hosts: serverweb:&madrid	# nodos que pertenezcan a serverweb y madrid
hosts: serverweb:!madrid	# nodos del serverweb que no pertenezcan a madrid

remote_user: jorge
become: true/false ( 1/0 )	# utilizar sudo o no
become_user: (usuario) postgres # cambiar de usuario
become_method: sudo/su		# metodo de cambio
check_mode: true/false		# mode de prueba
```

### Variables

```bash
# plantilla donde se mostraran variables
➜  ansible cat plantillas/host.j2 
{{ miip }} {{ ansible_hostname }} {{ ansible_fqdn }}


# playbook donde se especifica una variable y se asigna a una plantilla
➜  ansible cat playbooks/variables.yml                    
---
- name: crear fichero usando variables
  hosts: localhost
  connection: local
  vars:
    - miip: "1.2.3.4"
  tasks:
    - name: crear fichero hosts
      template: src=host.j2 dest=/tmp/hosts      
      
# ejeución 
➜ ansible-playbook -i hosts  playbooks/variables.yml
...

# de la plantilla se a generado este archivo
➜  ansible cat /tmp/hosts                             
1.2.3.4 pc02 pc02

# las variables predefinidas de ansible se pueden ver con el modulo setup
➜ ansible localhost -m setup
```



**Prioridades** de variables definidas de menor prioridad a mayor prioridad.

- defaults definidas en un rol
- variables de grupo ( `inventario, group_vars/all, group_vars/grupo` )
- variables de servidor ( `inventario, host_vars/servidor` )
- "Facts" del servidor
- variabes de playbook ( `vars_prompt, vars_files` )
- variable de rol definidas en `/roles/rol/vars/main.yml`
- variables de bloque, definidas en tareas
- parametros de rol, `include_params, include_vars`
- `set_facts/ registered_vars`
- extra vars, definidas al lanzar la orden de ansible ( siempre gana )



### Handlers

handlers son tareas que se ejecutan  si un trabajo a ido bien y solicita dicha tarea, es decir si se instala nginx reinicia el servicio, si ya esta intalado no se ejecutara el handler.

```yaml
➜  ansible cat handlers.yml
---
- hosts: vhosts
  become: true
  tasks:
  - name: instalar nginx
    dnf:
      name: nginx
      state: present
      update_cache: true
    notify:
      - "Reiniciar nginx"

  handlers: 
    - name: Reiniciar nginx
      service:
        name: nginx
        state: restarted  
```



```bash
➜  ansible ansible-playbook handlers.yml -K 
SUDO password: 

PLAY [vhosts] *******************************************************************************************

TASK [Gathering Facts] **********************************************************************************
ok: [192.168.122.200]

TASK [instalar nginx] ***********************************************************************************
changed: [192.168.122.200]

RUNNING HANDLER [Reiniciar nginx] ***********************************************************************
changed: [192.168.122.200]

PLAY RECAP **********************************************************************************************
192.168.122.200            : ok=3    changed=2    unreachable=0    failed=0   
```



### Include y Role

Estos son metodos para desglosar un playbook que es demasiado grande para ser leeible y facilitar la tarea de modificaciones etc..

**Include** es simplemente el incluir un playbook dentro de otro.

**Role** es una estructura de directorios donde se ordenaran adecuadamente los diferentes archivos yaml para las tareas.

```bash
site.yml
webservers.yml
fooservers.yml
roles/
    common/
        tasks/
        handlers/
        files/
        templates/
        vars/
        defaults/
        meta/
    webservers/
        tasks/
        defaults/
        meta/
```

- `tasks` - contiene la lista principal de tareas que debe ejecutar el rol.
- `handlers` - contiene handlers, que pueden ser utilizados por este rol o incluso en cualquier lugar fuera de este rol.
- `defaults` - variables predeterminadas para el rol (consulta [Using Variables](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#playbooks-variables) para mas información).
- `vars` - otras variables para el rol (see [Using Variables](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#playbooks-variables) for more information).
- `files` -  contiene archivos que se pueden implementar a través de este rol.
- `templates` - contiene plantillas que se pueden implementar a través de este rol.
- `meta` - define algunos metadatos para este rol.



#### Include

En el siguiente ejemplo es una instalación simple de el editor vim y un servicio nginx, con el metodo include separando los pasos de nginx en un archivo yaml diferente.

```yml
---
- name: primer Play
  hosts: vhosts
  remote_user: jorge
  become: true
  tasks:
  - name: instalar nginx
    dnf:
      name: vim
      state: present
  - include: instalar_nginx.yml
```



*instalar_nginx.yml* 

```yml
---
- name: instalar nginx
  dnf: name=nginx state=latest
- name: instalar servicio
  service: name=nginx state=started
- name: habilitar servicio
  service: name=nginx enabled=true
```



#### Role

En este ejemplo se muestra una instalación simple con la estructura de un role

```bash
➜  web tree
├── instalar_con_rol.yml
└── roles
    └── apache2
        ├── files
        │   └── apache2.conf
        ├── handlers
        │   └── main.yml
        ├── tasks
        │   └── main.yml
        └── templates
            └── index.html.j2
```

*instalar_con_rol.yml* 

```yml
- name: instalar y configurar apache2
  hosts: vhosts
  remote_user: jorge
  become: true
  roles:
    - apache2
```

*roles/apache2/tasks/main.yml* 

```yml
- name: instalar apache2
  apt: name=apache2 state=latest
- name: Iniciar y habilitar servicio
  service: name=apache2 state=started enabled=true
- name: Copiar fichero de configuracion
  copy: src=apache2.conf dest=/etc/apache2/apache2.conf
  notify: restart_httpd
  
- name: Copiar fichero index.html
  template: src=index.html.j2 dest=/var/www/html/index.html
```



*roles/apache2/handlers/main.yml*

```yml
- name: restart_httpd
  service: name=apache2 state=restarted  
```



*roles/apache2/templates/index.html.j2*  

```
Hola al servidor {{ ansible_fqdn }}
```



### Templates

dentro de una plantilla se pueden especificar las siguientes instrucciones:

Expresiones: una `{{ variable }}` propia o del sistema como `{{ ansible_fqdn }}`

Control: código con `{% ... %}`

comentarios: `{# ... #}`

```
{% if ansible_distribution == "Debian" %}
Muestra sólo en sistemas Debian
{% endif %}

{% for usuario in lista_usuarios %}
{{ usuario }}
{% endfor %}
```



### Condiciones

Las condiciones son para ejecutar tareas si dicha condición es cierta, en los siguientes ejemplos se ejecutaran las tareas si las distribuciones remotas son Debian o Ubuntu, esta información de las variables de ansible que podemos consultar en `ansible hostname -m setup`. 

```yml
# condicion para tarea
- name: instalar apache2
  include: instalar_apache2.yml
  when: ansible_distribution == "Debian" or ansible_distribution == "Ubuntu"
  
# condicion para rol
- name: instalar y configurar apache2
  hosts: vhosts
  remote_user: jorge
  become: true
  roles:
    - { role: apache2, when: ansible_distribution == "Debian" or ansible_distribution == "Ubuntu" }
```



### bucles

los bucles evitan repetir código y asi reducir el tamaño del playbook por ejemplo en la instalación de diversos paquetes.

```yml
# bucle de tres paquetes a instalar
- name: Instalar paquetes
  apt: name={{ item }} state=latest
  with_items:
    - mysql-server
    - phpmyadmin
    - php5

# bucle de diccionario creando usuarios
- name: Crear usuarios necesarios
  user: name={{ item.nombre }} groups={{ item.grupo }}
  with_items:
    - { nombre: usuario1, grupo: www-data }
    - { nombre: usuario2, grupo: www-data }
    
# bucle utilizando una variable que es una lista externa
- name: Instalar paquetes
  apt: name={{ item }} state=latest
  with_items: "{{ lista_paquetes }}"
  
  defaults/main.yml
  lista_paquetes: ["php5", "phpmyadmin", "mysql-server"]
```



### Register

El register permite guardar en una variable el resultado de una acción generada por un modulo de una tarea.

```yml
- name: playbook para la clase register
  hosts: localhost
  tasks:
    - name: Ejecutar comando uptime
      command: uptime
      register: salida_uptime

    - name: Visualizar variable
      debug: var=salida_uptime
```

Los valores de retorno son: `changed, failed, skipped, rc` rc (retorn command) efecto de salida `stdout, stderr, stdout_lines, stderr_lines` ejemplo: `register: salida_uptime.stdout`

```bash
...
TASK [Visualizar variable] ******************************************************************************
ok: [localhost] => {
    "salida_uptime": {
        "changed": true,
        "cmd": [
            "uptime"
        ],
        "delta": "0:00:00.003743",
        "end": "2020-11-24 18:50:34.459941",
        "failed": false,
        "rc": 0,
        "start": "2020-11-24 18:50:34.456198",
        "stderr": "",
        "stderr_lines": [],
        "stdout": " 18:50:34 up 15 days, 10:36,  1 user,  load average: 0,17, 0,46, 0,53",
        "stdout_lines": [
            " 18:50:34 up 15 days, 10:36,  1 user,  load average: 0,17, 0,46, 0,53"
        ]
    }
}
```



En este ejemplo al modificar el `index.html` se registra la acción en copiado y si esta es `changed`  se registra la salida del comando cat para mostrarla por stdout


```yml
- name: instalar apache
  include: instalar-apache2.yml

- name: Copiar fichero index.html
  template: src=index.html.j2 dest=/var/www/html/index.html
  register: copiado

- name: Mostrar contenido
  command: cat /var/www/html/index.html
  register: salida
  when: copiado|changed

- debug: var=salida.stdout
  when: salida|changed
```



### Ignore errors

Esta opción sirve para que en el caso de que una tarea de error, este se ignore y siga el playbook ejecutandose con la siguiente tarea.

```yml
- name: playbook para la clase register
  hosts: localhost
  tasks:
    - name: Visualizar hosts
      command: cat /etc/hosts2
      ignore_errors: True
```

Es una buena practica relacionar esta opció con tareas siguientes, es decir si da error haz una tarea o otra.

Por ejemplo, en el siguiente playbook si no existe el fichero `hosts2`  se ignora el error, ademas lo registramos en una variable que con una condición `when` hace una tarea u otra.

```yml
- name: playbook para la clase register
  hosts: localhost
  tasks:
    - name: Visualizar hosts
      command: cat /etc/hosts2
      register: salida
      ignore_errors: True

    - name: Visualizar variable
      debug: var=salida.stdout_lines
      when: not salida is failed   # salida!=failed

    - name: Visualizar variable
      debug: var=salida.stderr_lines
      when: salida is failed
```



### Failed when

`failed_when` nos sirve para probocar un fallo en el caso de no cumplir la condición que indicamos. 

Por ejempo en el siguiente caso si no tenemos en localhost la interfaz `eth0` el playbook registrara un fallo.

```yml
- name: playbook ejemplo failed_when
  hosts: localhost
  tasks:
    - name: Optener interfaces de red
      command: ip a
      register: salida
      failed_when: "'eth0' not in salida.stdout"
```

**También** esta su versión inversa con `changed_when`, que en este caso daria por buena una tarea según la condición indicada.

```yml
- name: playbook ejemplo failed_when
  hosts: localhost
  tasks:
    - name: Optener interfaces de red
      command: ip a
      register: salida
      failed_when: "'inet6' not in salida.stdout"
      changed_when: True
```



### Tags

Los tags sirven para especificar selectivamente que tareas ejecutar o omitir.

```yml
- name: Ejemplo etiqueas
  hosts: localhost
  tasks:
    - debug: msg="Tarea con tag PROD"
      tags: prod
    - debug: msg="Tarea con tag DEV"
      tags: dev
    - debug: msg="Tarea con varios tags"
      tags: [qa, prod]
    - debug: msg="Esta tare se ejecuta siempre"
      tags: always
```

Si  lanzamos el playbook sin el argumento tags se ejecutaran todas las tareas del playbook, en cambio si añadimos el argumento tag seleccionamos cuales vejecutar.

```bash
# ejecutar todas las tareas
ansible-playbook etiquetas.yml

# realizar tares con tag prod
ansible-playbook --tags prod etiquetas.yml

# omitir tareas con tag prod
ansible-playbook --skip-tags prod etiquetas.yml
```



### 

## Galaxy

Ansible galaxy es un repositorio de ansible donde puedes descargar roles de otros usuarios o alojar los tuyos propios a traves de github.

sintaxis: `ansible-galaxy [accion] [opciones] argumentos`

Acciones:

- `delete`  Eliminar rol dentro de la web de galaxy  
- `import ` Importar un rol desde github a galaxy

- `info` muestra información detallaa del rol
- `init` iniciar estructura de diretorio
- `install` Descargar rol
- `list` Listar rolers instalados
- `login` Auntentifica en la web de galaxy
- `remove` Elimina un rol del servidor local
- `search` Busqueda dentro del repositorio
- `setup` Crea una integracion con `Travis CI`

Opciones:

- `-f/--force` sobreescribir rol
- `-i/--ignore-errors`
- `-n/--no-deps` no instalar dependencias
- `-p/--roles-path` directorio de roles
- `-r/--roles-file` ficherpo con lista de roles a instalar

### Busqueda

Los roles de  galaxy se pueden buscar desde linea de comandos o desde la web de galaxy, es recomendable la web por ser una vista mas agradable.

Una vez escojido el rol deseado lo podemos instalar en nuestro servidor y lo tendremos disponible para las modificaciones necesarias.

```bash
# buscar rol
➜  ansible-galaxy search "Nginx"          

# inspeccionar e instalar
➜  ansible-galaxy info nginxinc.nginx        
➜  ansible-galaxy install nginxinc.nginx
- downloading role 'nginx', owned by nginxinc
- downloading role from https://github.com/nginxinc/ansible-role-nginx/archive/0.18.1.tar.gz
- extracting nginxinc.nginx to /home/debian/.ansible/roles/nginxinc.nginx
- nginxinc.nginx (0.18.1) was installed successfully

# los roles instalados se alojan en:
➜  ls ~/.ansible/roles 
nginxinc.nginx
➜  ls ~/.ansible/roles/nginxinc.nginx 
CHANGELOG.md  CODE_OF_CONDUCT.md  CONTRIBUTING.md  defaults  files  handlers  LICENSE  meta  molecule  README.md  tasks  templates  vars
```

### Nuevo rol

Galaxy permite crear una estructura de rol automaticamente para crear nuestros roles.

Recordar añadir en meta: autor, descripcion y modificar el readme

```bash
➜  playbooks ansible-galaxy init pruebarol
- pruebarol was created successfully

➜  playbooks tree pruebarol 
pruebarol
├── defaults
│   └── main.yml
├── files
├── handlers
│   └── main.yml
├── meta
│   └── main.yml
├── README.md
├── tasks
│   └── main.yml
├── templates
├── tests
│   ├── inventory
│   └── test.yml
└── vars
    └── main.yml
```



### Subir rol a galaxy

Una vez el rol listo podemos subirlo a galaxy para añadirlo al repositorio galaxy, para hacer esto primero tendremos que  subirlo a github.

primero subimos nuestro rol a Github

```bash
# crear uevpo repo en github y subir rol
git init
Inicializado repositorio Git vacío en /home/debian/Documentos/ansible/playbooks/pruebarol/.git/

git add .
git commit -m "first commit"
[master (commit-raíz) a8bf75f] first commit
 9 files changed, 142 insertions(+)
 ...
 
git remote add origin git@github.com:Jorgepastorr/pruebarol.git
git push -u origin master
```

Sincronizar repo de github con galaxy, este paso se puede hacer también desde la web de galaxy.

```bash
# logueamos en galaxy y subimos nuestro rol
ansible-galaxy  login    
ansible-galaxy import jorgepastorr pruebarol
```

Ya podemos encontrar nuestro rol en el repositorio de galaxy  e instalarlo donde queramos

```bash
ansible-galaxy search pruebarol

ansible-galaxy install jorgepastorr.pruebarol
- downloading role 'pruebarol', owned by jorgepastorr
- downloading role from https://github.com/Jorgepastorr/pruebarol/archive/master.tar.gz
- extracting jorgepastorr.pruebarol to /home/debian/.ansible/roles/jorgepastorr.pruebarol
- jorgepastorr.pruebarol (master) was installed successfully

ansible-galaxy list 
- jorgepastorr.pruebarol, master
- nginxinc.nginx, 0.18.1

ansible-galaxy delete jorgepastorr pruebarol
```







## Vault

El comando `ansible-vault` permite cifrar ficheros con una contraseña para proteger datos sensibles.

```bash
ansible-vault create fichero.yml	# crear fichero encriptado
ansible-vault edit fichero.yml		# editar fichero encriptado
ansible-vault encrypt fichero.yml	# encriptar un fichero
ansible-vault decrypt fichero.yml	# desencriptar fichero
ansible-vault view fichero.yml		# ver fichero encriptado

# preguntar contraseña de fichero
ansible-playbook --ask-vault-pass	playbook.yml
# coge contraseña de fichero
ansible-playbook --vault-password-file=file  playbook.yml
```



```bash
# crear archivo encryptado
➜ ansible-vault create secreto.yml
New Vault password: 
Confirm New Vault password: 

➜ cat secreto.yml 
$ANSIBLE_VAULT;1.1;AES256
65613139323466646538383064626463393435656134353662613730333764313339633237313935
3363653534306566373430386631333432633566393963650a333839633137396632383865373962
37653161366234386463313362623939313062643432626530616438343664303631343861333063
3838356238306265360a323631613637313762663732636339323961366639333633393565373062
30383061643634336266376633383334666363383739363562653133386663656131

# crear archivo normal y luego encryptarlo
➜ vim secreto2.yml
➜ cat secreto2.yml 
clave: miSecreto

➜ ansible-vault encrypt secreto2.yml
New Vault password: 
Confirm New Vault password: 
Encryption successful

➜ cat secreto2.yml 
$ANSIBLE_VAULT;1.1;AES256
30306137646336316235336264396364346666343364613363353961653632343536646561663332
3935396661623165663764663738386338353263393137310a643330326331333533323961326231
64333938313130613335633064346639313465666136356132313132353663313136643730306562
6238663564646264350a336566373939316231646333386661626531373962373234363361643637
37633861376132393265363566663236656337623864656666373133393562613631

# desencriptar archivo
➜ ansible-vault decrypt secreto2.yml
Vault password: 
Decryption successful

➜ cat secreto2.yml                  
clave: miSecreto
```



bien, ahora creo un playbpook muy simple donde la variable clave es data sensible.

 ```yml
- name: Prueba Vault
  hosts: localhost
  tasks:
    - debug: var=clave
 ```



```bash
# esta es una simple prueba del playbook
ansible-playbook -e "clave=prueba" vault.yml
...
TASK [debug] *************
ok: [localhost] => {
    "clave": "prueba"
}
...

# añado la variable en el archivo encriptado y me pregunta clave para desencriptar
ansible-playbook -e "@secreto.yml" --ask-vault-pass vault.yml
Vault password:
...
TASK [debug] *************
ok: [localhost] => {
    "clave": "superSecreto"
}
...

# añado la variable en el archivo encriptado y coje la clave para desencriptar del archivo .pass
➜  ansible vim .pass 
➜  ansible ansible-playbook -e "@secreto.yml" --vault-password-file=.pass playbooks/vault.yml
...
TASK [debug] *************
ok: [localhost] => {
    "clave": "superSecreto"
}
...
```

