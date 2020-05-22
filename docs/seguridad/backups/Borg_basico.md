# Borg básico

borg es un gran programa para crear backups aqui muestro lo básico de lo básico, es mucho mas extenso y potente de gran utilidad.

#### instalar

```bash
sudo dnf install borgbackup
```



#### crear repo

Encriptar el repositorio ( donde se guardaran los backups )

```bash
borg init --encryption=repokey /home/users/inf/wism2/ism47787241/backup-borg
```

Sin encriptar y sin password

```bash
borg init -e none /home/debian/repoborg          
```



#### crear backups

Creando primer backup de carpeta 

```bash
borg create /home/users/inf/wism2/ism47787241/backup-borg::primer-backup ~/carpeta ~/carpeta2
```

Creando segundo backup de carpeta 



#### listar backups

```bash
borg list /home/users/inf/wism2/ism47787241/backup-borg
borg list /home/users/inf/wism2/ism47787241/backup-borg::primer-backup
borg list /home/users/inf/wism2/ism47787241/backup-borg::segundo-backup
```



#### Borrar backup específico

```bash
borg delete /home/users/inf/wism2/ism47787241/backup-borg::segundo-backup
borg delete /home/users/inf/wism2/ism47787241/backup-borg
```



#### restaurar backup

```bash
borg extract /home/users/inf/wism2/ism47787241/backup-borg::segundo-backup
```



#### Repositorio remoto

```bash
borg init user@hostname:/path/to/repo
```

Otra manera de hacerlo remoto, sincronizando carpetas del host remoto y añadiendo la repo

```bash
sshfs user@hostname:/path/to /path/tot
borg init /path/to/repo
fusermount -u /path/to
```



####  Backup compression

Por defecto compresión 4

rango de compresión de 1-22,  1 poco comprimido 22 máxima compresión.

```bash
borg create –compression zstd,N /path/to/repo::arch ~
```

