
instalar

```bash
sudo dnf install -y postgresql-server
```

Crear espacio de datos necesario del SGBDR

```bash
sudo postgresql-setup initdb
```

Modificar permiso de acceso remoto

*vim /var/lib/pgsql/data/pg_hba.conf*

```bash
# "local" is for Unix domain socket connections only
local   all             all                                     peer
# IPv4 local connections:
host    all             all             127.0.0.1/32            md5
# IPv6 local connections:
host    all             all             ::1/128                 md5
# Allow replication connections from localhost, by a user with the
# replication privilege.
local   replication     all                                     peer
host    replication     all             127.0.0.1/32            md5
host    replication     all             ::1/128                 md5
```

Iniciar servicio

```bash
sudo systemctl start postgresql
```

Añadir contraseña de acceso a postgres

```bash
sudo passwd postgres
su postgres
psql template1 -U postgres
alter user postgres with encrypted password 'postgres'
```

```bash
 psql -d template1 -U postgres -h localhost
```

