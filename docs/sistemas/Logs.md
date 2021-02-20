# Logs del sistema

Tanto el sistema como las aplicaciones guardan los logs en el directorio `/var/logs/` ahí se encuentran los diferentes archivos de logs, como por ejemplo `messages` que hace referencia al sistema.

En ocasiones queremos ver logs en tiempo real y buscaremos el archivo log de la aplicación  o sistema y lo visualizaremos directamente.

```bash
sudo tail -f /var/log/messages
```

También existen diferentes comandos para filtrar y gestionar mejor los logs como `journalctl o dmesg`



## journalctl

Es la manera que tiene Systemctl de consultar los logs del sistema

- **-S -U**: permite especificar desde (since) y/o  hasta cuando (until)
  - YYYY-MM-DD [ HH:MM:SS], yesterday, today, tomorrow, N day ago, - / + NhMmin (-1h15min)
- **-u** unit: mensage de una unidad en concreto
- **-k** : mensajes del kernel
- **-p** por tipo ( emerg, alert, crit, err, warning, notice, info, debug )
- PARAM=VALUE : parametros como `_PID, _UID, _COMM`  ( man systemd.journal-fields )



```bash
sudo journalctl

# filtrar entre dias, o horas
sudo journalctl -S 2021-02-14 -U 2021-02-16
sudo journalctl -S today
sudo journalctl -S yesterday
sudo journalctl -S '2 day ago'
sudo journalctl -S -1h10min

# filtrar por servicio
sudo journalctl -u networking.service

# logs del kernel
sudo journalctl -k

# filtrar po tipo de alerta
sudo journalctl -p err
sudo journalctl -p warning
sudo journalctl -p emerg
sudo journalctl -p alert
sudo journalctl -p info

# filtrar por parametro
sudo journalctl _COMM=anacron
sudo journalctl _UID=1000

# filtrar los ultimos logs, con una corta esplicación
sudo journalctl -xe
```



## dmesg

Al arrancar el sistema se muestran mensajes según se van cargando controladores o funciones del sistema. para revisarlos se usa **dmesg**

- **-T** Muestra las marcas de tiempo mas claramente
- **-k** solo mensajes del kernel
- **-l** filtra por niveles  de aviso ( warn, err, etc...)
- **-H**  salida para lectura humana, es equivalnte a `dmesg | less`

Este comando es equivalente a `journalctl -b -k`

