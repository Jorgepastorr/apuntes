
sxid

sXid checks for changes in suid and sgid files and directories based on its last check. Logs are
     stored by default in /var/log/sxid.log. 

SYNOPSIS
     sxid [-c, --config file] [-n, --nomail] [-k, --spotcheck] [-l, --listall] [-h, --help]
          [-V, --version]

root@nodo01:~# sxid 
root@nodo01:~# ls /var/log/sxid.log 
/var/log/sxid.log

sxid # genera comprobacion con configuracion actual
sxid -k directory -l # genera resumen de directorio especifico
sxid -c config_file # usar config especifica

/etc/cron.daily/sxid
/etc/default/sxid # enable yes si quieres que se ejecute cada dias
/etc/sxid.conf

---

portsentry

portsentry is a program that tries to detect portscans on network interfaces with the  ability
       to  detect  stealth  scans.  On alarm portsentry can block the scanning machine via hosts.deny
       (see hosts_access(5), firewall rule (see ipfwadm(8), ipchains(8) and iptables(8))  or  dropped
       route (see route(8)).


/etc/portsentry/portsentry.conf
/etc/portsentry/portsentry.ignore.static

/var/lib/portsentry/portsentry.blocked.history

---

apache2 openssl

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/nodo01.key -out /etc/apache2/ssl/nodo01.crt

/etc/apache2/sites-available/default-ssl.conf

root@nodo01:~# a2enmod ssl
root@nodo01:~# a2ensite default-ssl.conf

---

snort

Snort is an open source network intrusion detection system, capable  of  performing  real-time
       traffic analysis and packet logging on IP networks.  It can perform protocol analysis, content
       searching/matching and can be used to detect a variety of attacks and probes, such  as  buffer
       overflows,  stealth  port scans, CGI attacks, SMB probes, OS fingerprinting attempts, and much
       more.

snort -v -i eth1
snort -v -i eth1 -l /var/log/snort/logs_snort/
snort -d -v -r /var/log/snort/logs_snort/snort.log.1669145794 

---

aide
       AIDE is an intrusion detection system for checking the integrity of files.


/etc/default/aide

/etc/aide/:
aide.conf  aide.conf.d  aide.settings.d

aide.conf

    # iognorar files
    !/var/lib/lxcfs

root@nodo01:~# aideinit # crear la bbdd inicial
cp -p /var/lib/aide/aide.db.new /var/lib/aide/aide.db

root@nodo01:~# aide.wrapper --check

---

rkhunter

rkhunter is a shell script which carries out various checks on the local system to try and de‐
       tect known rootkits and malware. It also performs checks to see if commands  have  been  modi‐
       fied, if the system startup files have been modified, and various checks on the network inter‐
       faces, including checks for listening applications.


rkhunter --propupd
root@nodo01:~# rkhunter --check -sk
/var/log/rkhunter.log
