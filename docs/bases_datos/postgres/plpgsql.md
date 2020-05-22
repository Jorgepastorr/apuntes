# Plpgsql

- [Funciones](#Funciones)  
  - [modificar valor](#modificar-valor)  
  - [Argumento default](#Argumento-default)  
  - [Condicionales](#Condicionales)  
  - [Loop](#Loop)  
    - [For](#For)  
    - [While](#While)  
  - [Retornar selects](#Retornar-selects)  
  - [Return una columna](#Return-una-columna)  
  - [Return varias columnas](#Return-varias-columnas)  
  - [Borrar todas funciones user](#Borrar-todas-funciones-user)  

## Funciones

Para ver las funciones de usuario \df

Hay diferentes formas de manejar las funciones, pero tienes que tener en cuenta siempre.

* **argumentos de entrada:** que tipo son, en el ejemplo var1 y var2, numeric.
* **valor de salida:** **_returns_** es el tipo de argumento que devolverá la función.
* **variable de función:** todas las variables de funciones que utilices se tienen que declarar.
* **devolver resultado: ** return sin la "s" devuelve el valor de salida ( es importante que sea del mismo tipo especificado en returns ) 

```sql
  create or replace FUNCTION
  restar(var1 numeric, var2 numeric)
  returns numeric
  as
  $$
  DECLARE
    resultado numeric;
  BEGIN
     resultado := var1 - var2;
     return resultado;
  END;
  $$
  LANGUAGE plpgsql;
```

según los valores de entrada o salida de la función se manejan los returns de forma diferente.

### modificar valor

recibe un argumento o varios y lo devuelve un valor modificado. 

```sql
create or replace FUNCTION
   restar(var1 numeric, var2 numeric)
returns numeric
as
   $$
   BEGIN
       return var1 - var2;
   END;
   $$
LANGUAGE plpgsql;

select restar(cuota, ventas) from repventas ;
  restar  
------------
 -17911.00
 -92725.00
-124050.00
 -24912.00
  57406.00
  -5673.00
...
```

### Argumento default

Cuando es opcional poner un argumento, tenemos que indicar un valor por defecto al argumento.

```sql
create or replace function
   mayoredad( var int default NULL)
   returns text
...
```

### Execute

Execute permite ejecutar alguna opción, un buen uso de el es tener el codigo más visual y facil de leer, como en el siguente ejemplo.

```sql
create or replace function
    consulta_clients_import()
    returns setof text
as 
    $$
    declare
        buscaquery text := 'select nombre from repventas';
    begin
        return query execute(buscaquery);
    end;
    $$
language plpgsql;
```

### Condicionales

En ocasiones queremos hacer  diferentes acciones según la variable introducida, para eso existe los condicionales if - elsif - else.

```sql
create or replace function
   mayoredad( var int default NULL)
   returns text
as
   $$
   DECLARE
       edad text;
   begin
       if var is null then
           edad := 'dame una edad';
           return edad;
       elsif  var < 18   then
           edad := 'menor';
           return edad;
       else
           edad := 'adulto';
           return edad;
       end if;
   end;
   $$
language plpgsql;
```

```SQL
CREATE OR REPLACE FUNCTION del_usuariobycod(INT) RETURNS BOOL AS
$$
DECLARE codigo ALIAS FOR $1;
BEGIN
    DELETE FROM usuarios WHERE codusuario = codigo;
    IF FOUND THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END; $$ LANGUAGE plpgsql;
```

### Loop

#### For

En los bucles for hay que tener en cuenta:

* Que quieres devolver? y quando?
* Si quieres devolver una variable al acabar un for, no hay problema se hace la funcion de siempre.
* Si quieres devolver la variable mientras está en proceso cambia la cosa:
  * **returns **tiene que ser** setof**
  * **return next** en la variable de salida.

```sql
    FOR target IN query LOOP
    statements
    END LOOP ;
```

```sql
 create or replace function 
       contador() 
returns setof int 
as $$
     declare counter int; 
     begin
           for counter in 1..5 loop
    return next counter;
           end loop;
end; $$
language plpgsql;

select contador();

contador
---

        1
        2
        3
        4
        5
```

En el uso de querys en el for no tiene mucho misterio, es igual. Con el cambio que al declarar una variable como record y esta será el argumento del bucle.

```sql
create or replace function
      contador() 
      returns setof int 
as $$
       declare counter record;  
       begin
              for counter in select oficina from oficinas loop
       return next counter.oficina;
              end loop;
end; $$
language plpgsql;
```

#### Foreach

 El bucle FOREACH es muy parecido a un bucle FOR, pero en lugar de  iterar a través de las filas devueltas por una consulta SQL, itera a  través de los elementos de un valor de matriz. (En general, FOREACH está diseñado para recorrer componentes de una expresión de valor compuesto; en el futuro se pueden agregar variantes para recorrer compuestos  además de matrices). La instrucción FOREACH para recorrer una matriz es:

```sql
create or replace function resto_letra(resto int)
    returns varchar
as 
    $$
    declare 
        res varchar := '';
        contador int := 0;
        letra varchar; 
        a varchar[] := array['T','R','W','A','G','M','Y','F','P','D','X','B','N','J',
                             'Z','S','Q','V','H','L','C','K','E'];
    begin
        foreach letra in array a loop
            if contador = resto then
                res := letra;
            end if;
            contador := contador + 1;
        end loop;
        return res;
    end;  
    $$
language plpgsql;
```

#### While

While es un bucle con condición de salida.

```sql

create or replace function 
      contador() 
      returns setof int 
as $$
     declare counter int := 0;  
     begin
            while counter <= 6 loop
    return next counter;  
            counter := counter + 1;  
     end loop;
end; $$
language plpgsql;
```

### Exceptions

[error codes]( https://www.postgresql.org/docs/current/static/errcodes-appendix.html)  

```sql
create or replace FUNCTION in_pacient(nom, cognom, dni)
    returns text
AS  
    $$
    BEGIN        
        INSERT INTO pacients VALUES ( default, nom, cognoms, dni);
        return 'datos introducidos correctamente';
        EXCEPTION 
            WHEN unique_violation THEN
                return 'Clau unica duplicada';
            WHEN foreign_key_violation THEN
                return 'Clau foranea inexistent';
    END;
    $$
LANGUAGE plpgsql;
```

### Perform

Una instrucción PERFORM establece FOUND verdadero si produce  una o más filas, falso si no se produce ninguna fila. Ademas descarta el resultado ( es decir no lo muestra por pantalla ).

```sql
...
perform dni from pacients where dni = fila.dni;
if found then
    ...
...    
```

## Retornar selects

Al tratar con selects en funciones hay que tener en cuenta, que tienes que especificar en return que devuelves una query, con: **return query**

### Return una columna

Cuando devolvemos una columna de una query, hay que tener en cuenta de añadir en returns el tipo **setof** que construye un conjunto con el resultado y lo muestra.

```sql
create or replace FUNCTION
   maxdos_promig_anual(anio int)
returns setof numeric
as
   $$
   begin
       return query select max(promig_anual(num_empl, anio)) from repventas;
   end;
   $$
language plpgsql;

select max_promig_anual(1990);

max_promig_anual
---

           11566

(1 fila)
```

### Return varias columnas

Si tenemos que devolver varias columnas de una tabla, primero tenemos que crear una tabla en returns.

Especificar el tipo de campo en cada columna y estos han de coincidir en la query.   

```sql

CREATE OR REPLACE FUNCTION clientes_rep(rep int)
RETURNS table (
   cliente smallint,
   credito numeric
)
as
   $$
   begin
       return query select num_clie, limite_credito from clientes
                       where rep_clie = rep;
   end;
   $$
LANGUAGE plpgsql;

select * from clientes_rep(103);
cliente | credito 
---------+----------
   2111 | 50000.00
   2121 | 45000.00
   2109 | 25000.00
(3 filas)
```

### Exportar typo columna

En ocasiones no sabemos que typo de columna tenemos que devolver, una forma fácil es señalar la tabla columna e indicarle que lo exporte directamente.

```sql
...
returns table (
    nom_empresa clientes.empresa%type,
    id_clie clientes.num_clie%type,
    nom_rep repventas.nombre%type
)
...
```

## Borrar todas funciones user

```sql
select 'DROP FUNCTION ' || ns.nspname || '.' || proname || '(' || oidvectortypes(proargtypes) || ');'
FROM pg_proc INNER JOIN pg_namespace ns ON (pg_proc.pronamespace = ns.oid)
where ns.nspname = 'public';
```

## Variables especiales en PL/pgSQL

Cuando una función escrita en PL/pgSQL es llamada por un disparador tenemos ciertas variableS especiales disponibles en dicha función. Estas variables son las siguientes:

**NEW**

Tipo de dato RECORD; Variable que contiene la nueva fila de la tabla para las operaciones INSERT/UPDATE en disparadores del tipo row-level. Esta variable es NULL en disparadores del tipo statement-level.

**OLD**

Tipo de dato RECORD; Variable que contiene la antigua fila de la tabla para las operaciones UPDATE/DELETE en disparadores del tipo row-level. Esta variable es NULL en disparadores del tipo statement-level.

**TG_NAME**
Tipo de dato name; variable que contiene el nombre del disparador que está usando la función actualmente.

**TG_WHEN**
Tipo de dato text; una cadena de texto con el valor BEFORE o AFTER dependiendo de como el disparador que está usando la función actualmente ha sido definido

**TG_LEVEL**
Tipo de dato text; una cadena de texto con el valor ROW o STATEMENT dependiendo de como el disparador que está usando la función actualmente ha sido definido

**TG_OP**
Tipo de dato text; una cadena de texto con el valor INSERT, UPDATE o DELETE dependiendo de la operación que ha activado el disparador que está usando la función actualmente.

**TG_RELID**
Tipo de dato oid; el identificador de objeto de la tabla que ha activado el disparador que está usando la función actualmente.

**TG_RELNAME**
Tipo de dato name; el nombre de la tabla que ha activado el disparador que está usando la función actualmente. Esta variable es obsoleta y puede desaparacer en el futuro. Usar TG_TABLE_NAME.

**TG_TABLE_NAME**
Tipo de dato name; el nombre de la tabla que ha activado el disparador que está usando la función actualmente.

**TG_TABLE_SCHEMA**
Tipo de dato name; el nombre de la schema de la tabla que ha activado el disparador que está usando la función actualmente.

**TG_NARGS**
Tipo de dato integer; el número de argumentos dados al procedimiento en la sentencia CREATE TRIGGER.

**TG_ARGV[]**
Tipo de dato text array; los argumentos de la sentencia CREATE TRIGGER. El índice empieza a contar desde 0. Indices inválidos (menores que 0 ó mayores/iguales que tg_nargs) resultan en valores nulos.

## Trigger

Triger es una acción automatizada que se ejecuta antes o despues de hacer un insert, update o delete. Consiste en una funcion que se encarga de hacer la acción, y un disparador que se encarga de determinar en que momento ejecutarse.

**Caracteristicas de la función:**

- Tiene que crearse la funcion antes que elm disparador

- No tiene que tener argumentos y deve devolver siempre trigger

- El procedimiento STASTEMENT siempre tiene que devolver NULL

- Si una tabla tiene mas de un disparador definido, estos se ejecutaran por orden alfabetico. La fila retornada por cada disparador , se convierte en la entrada del siguiente.

- Se tiene que tener cuidado con no hacer bucles infinitos llamando a un disparador recursivamente.



Una funcion de trigger

1. **FOR EACH ROW** : S'executa per cada registre afectat per la sentència SQL. Els     exemples anteriors són  row-level.

2. **FOR EACH STATEMENT** :
    S'executa només un cop, tant si la sentècia SQL afecta només a un
    registre com si n'afecta a més d'un. En els exemples anteriors el
    TRIGGER BEFORE DELETE afecta a varis registres, si hagués sigut
    statement-level només s'hagués executat un cop la
    funció.

```plsql
-- funcion
create or replace function anadir_log()
    returns TRIGGER
AS
    $$
    BEGIN
        insert into registro_log values
         (current_user, TG_TABLE_NAME, TG_OP, current_timestamp);
        RETURN NULL;
    END;
    $$
language plpgsql;

-- disparador
create trigger anadir_log after insert or update or delete on resultats 
for each statement execute procedure anadir_log();
```

 select array_position(array['p','o'],'p');  

array_position 

1
