# Logs

Son los registros de errores y procesos el sistema



## journalctl

Es un comando para ver los registros del sistema 

<u>**Extensiones**</u>

-f → muestra los registros a tiempo real

-r → ( reverse ) los últimos procesos los muestra primero

-b → ( boot ) registro de arranque

-b -1→ penultimo arranque, si vamos aumentando el número mostrara arranques anteriores.

--list-boots → todos los arranques.

-u servicio → arranques de servicios tipo sshd, postgresql, etc…

-p → prioridades

​	0 - emergencia

​	1 - alerta

​	2 - críticos

​	3 - error

​	4 - warning

​	5 - notice

​	6 - info

​	7 - debug  



--disk-usage →  Cantidad de MB que guarda el sistema en registros

- Para cambiar la cantidad de estos MB 
- /etc/systemd/journald.conf
- editar→ SystemMakUsage=200M ( pones la cantidad deseada )
- cambiar a systema LIFO
- systemctl kill --kill-who=main --signal=SIGUR2 systemd-journald.service



**<u>Filtrar</u>**

--since → filtrar

Podemos filtrar con --since “1 hour ago” tanto por dias, horas, fechas en general.

--since “YYYY-MM-DD”

--until → hasta → si lo combinas con --since tienes un desde, hasta tal fecha.

--since  “YYYY-MM-DD” --until  “YYYY-MM-DD”