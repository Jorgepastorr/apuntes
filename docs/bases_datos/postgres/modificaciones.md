# Modificación tablas

- [Añadir filas](#Añadir-filas)  
- [Copiar tabla](#Copiar-tabla)  
- [Update](#Update)  
  - [Actualizar filas](#Actualizar-filas)  
  - [Actualizar nombre de columna](#Actualizar-nombre-de-columna)  
  - [Cambiar codificación de caracteres](#Cambiar-codificación-de-caracteres)  
  - [Delete](#Delete)  
- [Crear tablas](#Crear-tablas)  
  - [CONSTRAINTS](#CONSTRAINTS)   
  - [Primary Key](#Primary-Key)  
  - [Default](#Default)  
  - [Unique](#Unique)  
  - [Check ](#Check)  
  - [Serial](#Serial)  
  - [Foreign key](#Foreign-key)  
  - [On Delete, On Update](#On-Delete,-On-Update)  
    - [Restrict](#Restrict)  
    - [Cascade](#Cascade)  
    - [Set Default, null](#Set-Default,-null)  
- [Inherits](#Inherits)  
- [Alter Table](#Alter-Table)  

## Añadir filas

```sql
copy oficinas (oficina, ciudad, region, dir, objetivo, ventas) FROM stdin;
--  cal entrar les dades separades per TAB.
-- Cada ENTER és un nou registre;
-- Per acabar posar \.
```

```sql
COPY oficinas (oficina, ciudad, region, dir, objetivo, ventas) FROM stdin;
22    Denver    Oeste    108    300000.00    186042.00
11    New York    Este    106    575000.00    692637.00
12    Chicago    Este    104    800000.00    735042.00
13    Atlanta    Este    105    350000.00    367911.00
21    Los Angeles    Oeste    108    725000.00    835915.00
\.
```

```sql
INSERT INTO "TABLA" VALUES
    ('999999','2017-01-01','9999','106','rei','2a44l','7','31500.00');
```

```sql
INSERT INTO peliculas (code, title, did, date_prod, kind) VALUES
    ('B6717', 'Tampopo', 110, '1985-02-10', 'Comedy'),
    ('HG120', 'The Dinner Game', 140, DEFAULT, 'Comedy');   
```

## Copiar tabla

Copiar tabla identica.

```sql
create table copia_rep as select * from repventas;
```

Copiar los datos de una tabla en otra ( han de coincidir los tipos ).  

```sql
insert into tabla_existente  ( select * from repventas );
```

## Update

### Actualizar filas

Al actualizar una fila tenemos que ir con cuidado ya que tenemos que hacer un select que solo salgan las filasque quieres modificar, si no se renombrara toda la columna que se muestre.

**Set →** se refiere a lo que quieres modificar

**where →** Depende de este where para modificar 1 o más filas ya que el número de filas que se muestran se modifica en el campo set indicado

sintaxis

```sql
update tabla 
set columna-a-modificar = resultado_nuevo
where columna-que-filtro = fila_que_quieres_modificar ;

update pedidos set clie = 9999  
where num_pedido = 999999;
```

```sql
update clientes 
set rep_clie = (select num_empl from repventas where nombre = 'Mary Jones'),
        limite_credito =  60000 
where empresa = 'Acme Mfg.';
```

Actualizar filtrando con join simple. 

```sql
update repventas dir
set cuota = (select min(cuota) from repventas where oficina_rep=dir.oficina_rep)
from oficinas of 
where dir.num_empl=of.dir and cuota > any(select cuota from repventas rep 
                                                where of.oficina=rep.oficina_rep);
```

Cuando tienes que fltrar con una join complicada es mejor aislarla en una tabla temporal.

```sql
with t as (
        select dir.num_empl as empl
        from repventas dir
        join oficinas of on(dir.num_empl = of.dir )
        where cuota > any(select cuota from repventas rep 
                        where of.oficina=rep.oficina_rep)
) 
update repventas 
set titulo =  (select min(cuota) from repventas where oficina_rep=dir.oficina_rep)
where num_empl in(select empl from t);
```

### Actualizar nombre de columna

```sql
alter table mi-tabla rename column nombre-antiguo to nombre-nuevo;
```

### Cambiar codificación de caracteres

```sql
update pg_database set encoding=6 where datname='TABLA';   -- (utf-8)
update pg_database set datcollate='es_ES.UTF-8' where datname='TABLA';
update pg_database set datctype='es_ES.UTF-8' where datname='TABLA';
```

### Delete

```sql
-- borrar tabla
drop table copia_clie;
-- borrar base de datos
drop database training;
```

Al usar delete hay que acordarse siempre de poner el `where`, en caso contrario borraremos todos los datos de la tabla.

```sql
-- borrar fila
delete from copia_rep 
where num_empl = 104;
```

## Crear tablas

### CONSTRAINTS

Es poden posar a cada columna o al final de la creació de la taula, mirar documentació Postgresql.

- `NOT NULL`: En la columno no puede haber un valor null.
- `PRIMARY KEY`: clave primaria nopuede ser repetida en la misma columna ni haber null.
- `DEFAULT`: poner u valor por defecto.
- `UNIQUE`: cada valor a de ser unico en la columna, puede ser null también.
- `CHECK`: comprueba que los valores cumplan una condición.
- `SERIAL`: cada vez que se añade un registro se incrementa en 1.
- `FOREIGN KEY/REFERENCES`: clave forania para asegurar integidad refencial.
  - `ON DELETE/ON UPDATE`: que hacer si rompemos la integridad al borrar/modificar una fila de la tabla referenciada.  
    - `RESTRICT`: retorna un error i no deja hacer la operación
    - `CASCADE`: borra o modifica filas afectadas
    - `SET DEFAULT`: pone el valor per defecto
    - `SET NULL`: pone el valor NULL
- `INHERITS`: hereda toda la estructura de una tabla y añade campos nuevos.

### Primary Key

Primary key es el campo irrepetible y obligatorio de la tabla.

```sql
CREATE TABLE clientes (
    num_clie smallint PRIMARY KEY,
    empresa character varying(20) NOT NULL,
    rep_clie smallint NOT NULL 
                        DEFAULT 108,
    limite_credito numeric(8,2)
);

-- en el caso de una prymary key doble
CREATE TABLE productos (
    id_fab character(3),
    id_producto character(5),
    descripcion character varying(20) NOT NULL,
    precio numeric(7,2) NOT NULL,
    existencias integer NOT NULL,
    PRIMARY KEY(id_fab, id_producto)
);
```

### Default

Valor por defecto que se añadira al campo si no se le asigna ninguno al añadir una fila a la tabla.  

```sql
CREATE TABLE clientes (
    num_clie smallint PRIMARY KEY,
    empresa character varying(20) NOT NULL,
    rep_clie smallint NOT NULL 
                        DEFAULT 108,
    limite_credito numeric(8,2)
);
```

### Unique

Por añadir ejemplo.

### Check

Condición que deve cumplir ese campo de la tabla, si la condicion no retorna true, no se podra modificar o crear esa fila.

```sql
CREATE TABLE clientes (
    num_clie smallint PRIMARY KEY,
    empresa character varying(20) NOT NULL,
    rep_clie smallint NOT NULL,
    limite_credito numeric(8,2),
    CHECK (num_clie < 1000)
);
```

### Serial

Cada vez que añadimos una fila en la tabla autors serial sumara en 1 el campo autor.  

```sql
create table autors (
    autor serial PRIMARY KEY,
    nom varchar(30) not null,
    nacionalitat varchar(30)
);
```

### Foreign key

Clave foranea hace referencia a otra columna de una tabla, si el valor a introducir/modificar coincide con uno que exista en la columna indicada se podra crear/modificar ese campo.

```sql
CREATE TABLE clientes (
    num_clie smallint PRIMARY KEY,
    empresa character varying(20) NOT NULL,
    rep_clie smallint NOT NULL 
                        REFERENCES repventas(num_empl),
    limite_credito numeric(8,2)
);

CREATE TABLE clientes (
        num_clie smallint,
        empresa character varying(20) NOT NULL,
        rep_clie smallint NOT NULL,
        limite_credito numeric(8,2),
        PRIMARY KEY(num_clie),
    FOREIGN KEY (rep_clie) REFERENCES repventas(num_empl)
    );
```

### On Delete, On Update

Condiciones al modificar o eliminar ese valor.

#### Restrict

Evita el borrado al detectar una inconsistencia. 
En el siguiente ejemplo, si intetas borrar un repventas que tiene un cliente asignado te denegará la acción.

```sql
CREATE TABLE clientes (
    num_clie smallint,
    empresa character varying(20) NOT NULL,
    rep_clie smallint NOT NULL 
                        REFERENCES repventas(num_empl)
                        ON DELETE RESTRICT,
    limite_credito numeric(8,2),
    PRIMARY KEY(num_clie)
);
```

#### Cascade

En este caso la accion de borrado/actualizado se generara en cascada.
Imagina que cambio el num_empleado de un repventas, con cascade a cada cliente que tenga asignado ese repventas se le actualizara automaticamente el campo rep_clie.  

```sql
CREATE TABLE clientes (
    num_clie smallint,
    empresa character varying(20) NOT NULL,
    rep_clie smallint NOT NULL 
                        REFERENCES repventas(num_empl)
                        ON DELETE CASCADE,
    limite_credito numeric(8,2),
    PRIMARY KEY(num_clie)
);
```

#### Set Default, null

Si al actualizar/eliminar se rompe la integridad entre tablas se asigna el valor por defecto.
En el siguiente ejemplo, si intento actualizar el rep_clie de un cliente y no existe en repventas(num_empl) se asignara el valor por defecto 105.  

```sql
CREATE TABLE clientes (
    num_clie smallint,
    empresa character varying(20) NOT NULL,
    rep_clie smallint NOT NULL
                        DEFAULT 105 
                        REFERENCES repventas(num_empl)
                        ON UPDATE SET DEFAULT,
    limite_credito numeric(8,2),
    PRIMARY KEY(num_clie)
);

-- en este caso se asignaria el valor null
CREATE TABLE clientes (
    num_clie smallint,
    empresa character varying(20) NOT NULL,
    rep_clie smallint NOT NULL
                        REFERENCES repventas(num_empl)
                        ON UPDATE SET NULL,
    limite_credito numeric(8,2),
    PRIMARY KEY(num_clie)
);
```

### Inherits

Creacion de una tabla partiendo de otra añadiendo campos.  
Creo la tabla clientes_vip partiendo de clientes y añado el campo puntos.  

```sql
CREATE TABLE clientes_vip (puntos integer) INHERITS (clientes);
```

## Alter Table

ALTER TABLE: modificar estructura de la base de dades

Afegir camp:

```sql
ALTER TABLE oficinas 
ADD direccion varchar(100);
```

Modificar camp:

```sql
ALTER TABLE oficinas 
ALTER direccion varchar(200);
```

Esborrar camp:

```sql
ALTER TABLE oficinas 
DROP direccion;
```

Afegir constraint:

```sql
ALTER TABLE oficinas
ADD CHECK(ciudad <> 'Barcelona')

alter table repventas
add nombre set not null;

-- o amb nom

ALTER TABLE oficinas
ADD CONSTRAINT no_badalona CHECK(ciudad <> 'Badalona')
```

## Backup

```bash
 pg_dump -h 192.168.88.4 -U jorge training > training_bk.sql
```

## Exportar

```sql
 \copy (select * from pacients) to 'pacients.csv' with csv header
```

## Inportar

```sql
\copy pacients_nous from 'nousclients.csv' delimiter ',' csv
```



## Permisos de usuario

```sql
\du+     -- ver roles
\dp      -- ver permisos
```

Crear usuario y dar permisos de acceso

```sql
CREATE USER jorge WITH PASSWORD 'jorge';
GRANT CONNECT ON DATABASE lab_clinic TO jorge;
GRANT USAGE ON SCHEMA public TO jorge;
```

Definir grupos de acceso

```sql
CREATE ROLE viewer;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO viewer;

CREATE ROLE editor;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO editor;

CREATE ROLE admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin;
```

Añadir usuario a grupo

```sql
GRANT viewer TO jorge;
```

Quitar grupo de usuario

```sql
REVOKE viewer FROM jorge;
GRANT editor TO jorge;
```

Elejir privilegio por defecto

```sql
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO viewer;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT,INSERT,UPDATE ON TABLES TO editor;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO admin;
```


