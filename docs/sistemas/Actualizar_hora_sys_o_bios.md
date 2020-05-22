# Gestionar Hora

Antiguamente se gestionaba la hora en GMT *Greenwich Mean Time*  basándose en las lineas imaginarias de la tierra, pero ahora esto se a actualizado a UTC *Coordinated Universal Time*  basándose en relojes atómicos mas precisos, la cuestión es que según el sistema operativo utilizado utiliza una u otra linux, mac: UTC, windows: GMT.

Esto puede dar problemas al tener un dual boot, ya que al apagar el pc se guarda la hora en RTC *Real Time Clock* es decir la bios, y al arrancar se recoge y añade en el sistema, por eso al encender un ordenador sin red tiene la hora correctamente.

Mostrar hora del sistema

```bash
# general
debian  ➜  ~ timedatectl 
               Local time: mié 2019-06-05 12:48:31 CEST
           Universal time: mié 2019-06-05 10:48:31 UTC
                 RTC time: mié 2019-06-05 10:46:09
                Time zone: Europe/Madrid (CEST, +0200)
System clock synchronized: no
              NTP service: active
          RTC in local TZ: yes

# sistema
debian  ➜  ~ date
mié jun  5 12:49:48 CEST 2019

```

- local Time. hora local 
- Universal time: hora UTC
- RTC : Hora del hardware
- Time zone: Zona horaria geograficament
- network time: agafar o no hora d'internet
- NTP: agafar o no hora del servidor ntp
- RTC  in local TZ: utilizar localtime o no



 Cambiar hora del sistema.

```bash
sudo date --set “año-mes-dia hora”
timedatectl set-time 15:15
```

Zonas horarias

```bash
timedatectl list-timezones | grep Europe
timedatectl set-timezone Europe/Madrid
```



Establecer hora del sistema automaticamente

```bash
systemctl start chronyd
```

>  Recoge la hora de la red y la establece en el sistema.  



Incorpora hora del sistema en la bios.

```bash
sudo hwclock systohc
```



Extraer hora de la bios.

```bash
sudo  hwclock hctosys
```

