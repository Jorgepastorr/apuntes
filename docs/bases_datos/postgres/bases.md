
# Postgres

## Comandos para moverse

```bash
psql 'nombre del gestor' # Conectar al gestor de tablas (base de datos)
\l listado     # ls
\d 'tabla'     # visualiza tabla =dir
\c 'base de datos'   # cd entrar
\i  'url'      # importar
\q             # salir
\df            # ver funciones de usuario
\df+           # ver funciones de usuario mas codigo
\help          # ayuda
\h comando     # ayuda de 1 comando en concreto.
\! clear       #limpia pantalla
\copy 'tabla' to 'nombre archivo(/ruta)' csv header # exportar tabla
```

## Querys  

### Select Ej

Tiene varias opciones, from, where, and, or y muchas más.

`select * from tabla;`  nos muestra toda la tabla (muy importante `;` final).

Muéstrame la columna de la tabla donde columna sea >= 50000

```sql 
select columna/s from tabla where(dónde) columna >= 50000;
```

Mostrar filas de una tabla

```sql 
select count( * ) from tabla ;
```

Ejemplo and  y or:

```sql 
select columna/s
from tabla
where ( columna condición
and columna condición )
or ( columna condición) ;
```

### like, not like

Lo utilizamos para buscar en una columna partiendo de un carácter o varios.  
`Ilike` es lo mismo que `like` pero busca el carácter tanto en mayus como minúscula 

```sql
%     -- comodín vale por todos o 0 caracteres.
_     -- comodín vale por 1 carácter
'm%'  -- primera letra es m
'%m'  -- última letra es m
'%m%' -- contiene m
'_m%' -- segunda letra contiene m y la primera cualquier carácter.
```

[ejemplos like /not like](https://drive.google.com/open?id=1957qJTIgwKnuV2nERf-p_EphSpulWhEnqxoP7Ylcj-k)

#### like any, all

like any o like all sirve para comparar múltiples likes en uno solo, utilizando una array.

* LIKE ALL : compara como and
* LIKE ANY : compara como or

Sintaxis:

```sql  
select * from tabla
where columna like any ( array['% % %' , '%.%'] ) ;
   
select * from tabla
   where columna like '% % %' or
            columna like '%.%' ;

select * from tabla where columna like all ( array['% % %' , '%.%'] ) ;

select * from tabla 
   where columna like '% % %' and
            columna like '%.%' ;
```

### Similar to

Similar to permite comparar texto similar a like pero nos deja insertar la opción or `|` dentro de sus opciones 

```sql 
'abc' SIMILAR TO 'abc'      true
'abc' SIMILAR TO 'a'        false
'abc' SIMILAR TO '%(b|d)%'  true
'abc' SIMILAR TO '(b|c)%'   false
```

### Expresiones regulares

Poder utilizar expresiones regulares

Operador | Descripcion | Ejemplo  
:-- | :--- | :---  
~ | Matches regular expression, case sensitive | 'thomas' ~ '.*thomas.*' 
~* | Matches regular expression, case insensitive | 'thomas' ~ '.*Thomas.*'  
!~ | Does not match regular expression, case sensitive | 'thomas' !~ '.*Thomas.*' 
!~* | Does not match regular expression, case insensitive | 'thomas' !~ '.*vadim.*'  


```sql 
 select * from tabla where  columna ~ '.$';
```

### AS

As se utiliza para cambiar el nombre a una columna o tabla temporalmente (sobre un select).
Si deseas que el nombre tenga espacios en blanco colocarlo entre comillas dobles "uno dos"

```sql 
select oficina as ofi, 
dir as director,
( ventas *100/objetivo) as porcentaje_cumplido 
from oficinas ;
```

### Limit, Offset

Limit limita el string final a el número que le indiques.

```sql 
SELECT columnas FROM tabla LIMIT 5;
```

Offset especifica desde que fila empezara a mostrar el string.  
Si hay en una tabla 20 filas y añades un offset 5 mostrara 15 filas empezando por la fila 6.

```sql 
SELECT columnas FROM tabla OFFSET 5;
```

### Concatenar || substring

Concatenar nos permite juntar 2 columnas o caracteres al resultado.

columna1 || columna2  
columna1 || ' carácter o nada' || columna2

```sql 
select columna1 ||  '-' || columna2 as alias from tabla;
```

Substring permite extraer caracteres de un resultado de fila.  
substring ( columna from 1(comienzo) for 2(largo) )

```sql 
select nombre as "Nombre",
substring (titulo from 4 for 7)||'  '||
substring (titulo from 1 for 3) as "Titulo",
contrato as "Contrato"
from repventas;
```

### Extract

Permite extraer una sección de la casilla para mostrarla, compararla etc..  
Algunos de sus campos: year, month, day, hour, minute, second …

```sql 
select extract( campo from columna) from tabla;

select  nombre, contrato from repventas where extract( year from contrato) < 1988;
```

### Distinct

Te permite reagrupar los caracteres repetidos en una columna y muestra los iguales

```sql 
select distinct id_fab from productos;
```


### Is null, Is not null

Para ver los datos nulos o no nulos de una columna.

```sql 
Select columna from tabla 
   where columna is null;
```

### Round 

Redondea y elimina los números decimales.

```sql 
select round( columna ) from tabla;
select round( columna, 2 ) from tabla; -- dos decimales 125.00
```

### Order by

Ordena columnas según orden ascendente (asc) o descendente (desc) 

```sql 
select *
from tabla 
order by columna1 asc, columna2 asc;
```

### Condición por fecha

```sql 
select * from tabla
where columna1 >= '2011-1-1' and columna1 <='2011-12-31' ;
```

#### Current_date

Muestra los días transcurridos de una fecha.

```sql 
select current_date - columnafecha from tabla;
```

Mostrar en años.

```sql 
select ((current_date - columnafecha) /365) from tabla;
```

#### Age 

Muestra el tiempo transcurrido en años meses y días desde una fecha.

```sql 
select age(columnafecha) from tabla;
```

### Coalesce, cast 

Coalesce convierte un null en un número.
Cast cambia el formato del caracter.

poner null un 0

```sql 
select coalesce( columna, 0 ) as columna from tabla;
```

poner null un texto
```sql 
select coalesce(cast( columna as text), 'texto-a-poner' ) as columna from tabla;
```

### To_char 

Extrae el trozo de fecha deseado 'YYYY' años, 'mm' meses, 'dd' días.

```sql 
 select to_char(columna, 'YYYY') = 1990 from tabla;
```

( util despues de un where como condición )

## Joins  

### Left outer join

Left outer join junta tablas de izquierda a  derecha por un campo, en los campos que no coinciden se quedan en blanco.
Podemos ir de izquierda a derecha con LEFT o de derecha a izquierda con RIGHT

```sql
SELECT *
FROM tabla1 LEFT OUTER JOIN tabla2 ON ( tabla1.columna = tabla2.columna)
-- A la tabla le puedes poner alias para facilitar escritura 
SELECT *
FROM pedidos ped LEFT OUTER JOIN productos prod ON (ped.fab  = prod.id_fab )
-- Ver los clientes que han hecho pedidos y los que no saldrán espacios en null.
select * 
from clientes cli LEFT OUTER JOIN pedidos ped ON (cli.num_clie = ped.clie)
order by cli.num_clie;
```

### Inner join

Inner join nos junta las tablas y nos muestra las filas que coinciden en la columna escogida.

```sql
select *
From tabla1 INNER JOIN tabla2 ON (tabla1.columna = tabla2.columna);
--- 
SELECT *
FROM   oficinas o, repventas r
WHERE  o.dir = r.num_empl;
---
SELECT *
FROM   oficinas o INNER JOIN repventas r ON (o.dir = r.num_empl);
```

### Auto join

Auto join es básicamente un join a una misma tabla lo único diferente a de ser que 2 de las columnas coincidan en los datos.

Se puede hacer tanto en INNER, LEFT o RIGHT

```sql 
Select *
From tabla t1 LEFT OUTER JOIN tabla t2 on ( t1.columna = t2.columna )
```

### Group by

Group by nos permite agrupar varias filas en un grupo.

Sus atributos son:

* `sum ()`
* `count (*)`
* `min ()`
* `max()`
* `avg()` → recomendable round ( avg ( columna ) ,2 )

Sintaxis
```sql
Select
From
where
Group by
Order by
```

```sql
SELECT clie, COUNT(*),
       SUM(importe),
       ROUND(AVG(importe),2),
       MIN(importe),
       MAX(importe),
       MIN(fecha_pedido),
       MAX(fecha_pedido)
FROM      pedidos
GROUP BY  clie
ORDER BY SUM(importe) DESC;
```

#### Having

Having es el filtrado que utiliza `group by`, se rige a sus normas de estructura, filtra por los atributos de group by.

```sql 
SELECT   columna, COUNT(*)
FROM        tabla
GROUP BY columna
HAVING   COUNT(*)>4;
( Las columnas han de coincidir, si no dará error.)
```

### Subselects

Subselects permite agregar partes de otra tabla en un mismo select, la respuesta del subselect siempre a deser 1 opción que se comparara con cada opción de la tabla inicial.

```sql 
select num_empl, nombre,
(select empresa from clientes where clientes.rep_clie=repventas.num_empl order by limite_credito desc limit 1),
(select max(limite_credito) from clientes where clientes.rep_clie=repventas.num_empl) from repventas;

num_empl |    nombre     |      empresa      |   max   
----------+---------------+-------------------+----------
     105 | Bill Adams    | Acme Mfg.         | 50000.00
     109 | Mary Jones    | Holm & Landis     | 55000.00
     102 | Sue Smith     | Fred Lewis Corp.  | 65000.00
     106 | Sam Clark     | Jones Mfg.        | 65000.00
     104 | Bob Smith     | Ian & Schmidt     | 20000.00
     101 | Dan Roberts   | First Corp.       | 65000.00
     110 | Tom Snyder    | Ace International | 35000.00
     108 | Larry Fitch   | Midwest Systems   | 60000.00
     103 | Paul Cruz     | JCP Inc.          | 50000.00
     107 | Nancy Angelli | Peter Brothers    | 40000.00
(10 rows)
```

#### All

all es equivalente a un and, tienen que darse todos los casos ciertos de los elementos  del subquery.

En el ejemplo muestro las oficinas que todos sus vendedores tienen una superior al 55% del objetivo de la oficina.

```sql 
select * from oficinas
where ( objetivo * 0.55 ) < all( select cuota from repventas
                                  where oficina_rep = oficina );

oficina | ciudad  | region | dir | objetivo  |  ventas  
---------+---------+--------+-----+-----------+-----------
     22 | Denver  | Oeste  | 108 | 300000.00 | 186042.00
     13 | Atlanta | Este   | 105 | 350000.00 | 367911.00
(2 filas)
```

#### Any

Any es equivalente a un or, tiene que ser cierto algún elemento de la subquery.

ejemplo: mostrar oficinas que tienen algún representante con la cuota de mas del 50% que el objetivo de su oficina.

```sql 
select * from oficinas
where ( objetivo * 0.5 ) < any( select cuota from repventas where oficina_rep = oficina );

oficina |  ciudad  | region | dir | objetivo  |  ventas  
---------+----------+--------+-----+-----------+-----------
     22 | Denver   | Oeste  | 108 | 300000.00 | 186042.00
     11 | New York | Este   | 106 | 575000.00 | 692637.00
     13 | Atlanta  | Este   | 105 | 350000.00 | 367911.00
(3 filas)
```

otro ejemplo muy útil del any con un array

```sql 
select num_empl from repventas
       where nombre = any(array['Sue Smith','Mary Jones','Bill Adams']);

 num_empl
----------
      105
      109
      102
(3 filas)
```

#### Exists

Exists es muy similar a IN, retorna true o false, si es true muestra la fila si no, no la muestra.

Se tiene que relacionar dentro de la subquery la query original con la subquery, como se ve en el ejemplo.

Ejemplo: todos los clientes que no han hecho ningún pedido.

```sql 
select num_clie, empresa from clientes
where not exists(select distinct clie from pedidos where num_clie=clie);

num_clie |     empresa    
----------+-----------------
    2123 | Carter & Sons
    2115 | Smithson Corp.
    2121 | QMA Assoc.
    2122 | Three-Way Lines
    2119 | Solomon Inc.
    2105 | AAA Investments
(6 filas)
```

#### IN

In nos permite comparar valores de diferentes filas o tablas.

```sql 
select producto, importe
from pedidos
where clie 
in (select num_clie from clientes where num_clie =2111);
```

### Union

Union como su mismo nombre, une querys en una. Lo único que hay que tener en cuenta es que las 2 querys han de tener el mismo número y tipo de campos, es decir numérica con numérica, texto con texto etc..

En el caso de que un query tenga mas campos que otro, se puede poner uno adicional con NULL.

Ejemplo: en el ejemplo se ve, una query que retorna el director con el número de trabajadores que tiene, y en la otra los trabajadores por director.

```sql  
select  dir.nombre as director, rep.nombre as esbirro, null as num_mascotas
from repventas rep
   join repventas dir on( rep.director=dir.num_empl)
UNION
select  dir.nombre as director, '-------', count(*) as num_mascotas
from repventas rep
   join repventas dir on( rep.director=dir.num_empl)
group by dir.num_empl
order by 1,3 desc;
 director   |    esbirro    | num_mascotas
-------------+---------------+--------------
Bob Smith   | Dan Roberts   |            
Bob Smith   | Bill Adams    |            
Bob Smith   | Paul Cruz     |            
Bob Smith   | -------       |            3
Dan Roberts | Tom Snyder    |            
Dan Roberts | -------       |            1
Larry Fitch | Nancy Angelli |            
Larry Fitch | Sue Smith     |            
Larry Fitch | -------       |            2
Sam Clark   | Mary Jones    |            
Sam Clark   | Larry Fitch   |            
Sam Clark   | Bob Smith     |            
Sam Clark   | -------       |            3
```

### Case when else end   

Case es la manera de añadir condiciones en una query, similar a un if, se pueden añadir tantas condiciones como se quieran, añadiendo when's.

```sql 
SELECT nombre,
 CASE
  WHEN edad>40 THEN 'Adulto'
  ELSE 'Joven'
END
FROM repventas;

    nombre     |  case  
---------------+--------
 Bill Adams    | Joven
 Mary Jones    | Joven
 Sue Smith     | Adulto
 Sam Clark     | Adulto
```

```sql  
 SELECT nombre, edad, ventas
FROM repventas
WHERE
CASE
    WHEN edad < 40 THEN ventas > 200000
    ELSE ventas > 300000
END;
   nombre    | edad |  ventas   
-------------+------+-----------
 Bill Adams  |   37 | 367911.00
 Mary Jones  |   31 | 392725.00
 Sue Smith   |   48 | 474050.00
 Dan Roberts |   45 | 305673.00
 Larry Fitch |   62 | 361865.00
 Paul Cruz   |   29 | 286775.00
(6 filas)
```



### Forzar valor

`valor::typo` fuerzas a un valor a tener un determinado tipo .

```sql
SELECT insertar_usuarios('1'::text);
```



