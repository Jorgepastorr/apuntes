# Mongo

## básico

```javascript
Entrar en consola:
mongo
Comandes bàsiques de la consola:
db // mostra la BD en ús
show databases // mostra les BD del servidor
show collections // mostre les col·leccions de la BD en ús
use proves // fa que la BD en ús sigui proves; si no existeix, la crea
db.createCollection(“tweets”) // crear tabla
```

## insertar

`insertOne` se utiliza para insertar una fila y `insertMany` para insertar múltiples filas

```javascript
db.inventory.insertOne({ item: "canvas", qty: 100, tags: ["cotton"], size: { h: 28, w: 35.5, uom: "cm" } })

db.inventory.insertMany([
   { item: "journal", qty: 25, tags: ["blank", "red"], size: { h: 14, w: 21, uom: "cm" } },
   { item: "mat", qty: 85, tags: ["gray"], size: { h: 27.9, w: 35.5, uom: "cm" } },
   { item: "mousepad", qty: 25, tags: ["gel", "blue"], size: { h: 19, w: 22.85, uom: "cm" } }
])
```



### insert save

Exemple (utilitza el mètode *deprecat* `db.collection.save()` enlloc del `.insertOne()`) :

```javascript
db.test.save({})
db.test.save({name: []})
db.test.save({name: ['George']})
db.test.save({name: ['George', 'Raymond']})
db.test.save({name: ['George', 'Raymond', 'Richard']})
db.test.save({name: ['George', 'Raymond', 'Richard', 'Martin']})
```

## Update

tiene este formato

```java
db.collection.update(query, update, options)
```

[Operadors de valores](https://docs.mongodb.com/manual/reference/operator/update/#id1)

actualiza el primero que encuentra

```java
> db.inventory.updateOne( 
...    { item: "paper" }, 
...    { 
...      $set: { "size.uom": "cm", status: "P" }, 
...      $currentDate: { lastModified: true } 
...    } 
... )
```

actualizar todos los que coinciden

```java
db.inventory.updateMany( 
   { "qty": { $lt: 50 } }, 
   { 
     $set: { "size.uom": "in", status: "P" }, 
     $currentDate: { lastModified: true } 
   } 
) 
```

sustituir el primero que encuentra

```java
db.inventory.replaceOne( 
   { item: "paper" }, 
   { item: "paper", instock: [ { warehouse: "A", qty: 60 }, { warehouse: "B", qty: 40 } ] } 
)
```





## Delete

```java
db.inventory.deleteMany({ status : "A" })
db.inventory.deleteOne({ status : "A" })
```



## Remove

```java
db.restaurants.remove({}) // eliminar contenido de tabla
db.restaurants.drop() // eliminar tabla
```



## Operadores

```bash
# comparadores
$eq # igual que
$gt	# mayor que
$gte # mayor o igual que
$lt # menor que
$lte # menor o igual que
$ne  #  diferente 
$in # cualquier valor dentro de  una array
$nin # ningun  valor dentro de  una array

# logicos
$or # cualquier coincidente
$and # todos an de coincidir
$not # invierte el efecto de una consulta
$nor # debuelve los elementos que no comparten ninguna de las condiciones
$exists # retorna los documentos que contienen el campo espewcificado
```



## Importar

desde fuera de mongo

```bash
mongoimport --db users --collection contacts --file contacts.json
mongoimport --db users --collection contacts --type csv \
			--headerline --file /opt/backups/contacts.csv

mongoimport --host 127.0.0.1 --port 27017 --db geo --collection countries \ 
			--type json --file json_dades_exemple/geo/countries.json -\
			-drop --stopOnError --maintainInsertionOrder
```



## querys

Para hacer búsquedas se utiliza el método `find` o `findOne` si solo quieres un resultado.

```javascript
> db.inventory.find({"patron de busqueda"}, {"campos a mostrar, por defecto todos"})
> db.inventory.find().count()
4
> db.inventory.find().pretty()
{
    "_id" : ObjectId("5e661c4863e51a5f0a8f3c2a"),
    "item" : "mousepad",
    "qty" : 25,
    "tags" : [
        "gel",
        "blue"
    ],
    "size" : {
        "h" : 19,
        "w" : 22.85,
        "uom" : "cm"
    }
}
...
 db.inventory.findOne()
```



### where

```javascript
> db.inventory.find({item: "mousepad"})
```

**where**: és un intèrpret i va molt lent (avalua l’expressió JavaScript per a cada document de la col·lecció), però alhora és molt potent. Utilitza l’objecte this per referir-se al document. Per exemple aquí serveix per avaluar si l’array name té mida més gran que 1:

```javascript
db.test.find( { $where: "this.name.length > 1" } );
```



### in

```javascript
SELECT * FROM inventory WHERE status in ("A", "D")
// equivalente
db.inventory.find( { status: { $in: [ "A", "D" ] } } )
```

### and

```java
SELECT * FROM inventory WHERE status = "A" AND qty < 30
// equivalente
db.inventory.find( { status: "A", qty: { $lt: 30 } } )
```

### or

```java
SELECT * FROM inventory WHERE status = "A" OR qty < 30
// equivalente
db.inventory.find( { $or: [ { status: "A" }, { qty: { $lt: 30 } } ] } )
```

### and y or

```java
SELECT * FROM inventory WHERE status = "A" AND ( qty < 30 OR item LIKE "p%")
// equivalente
db.inventory.find( {
     status: "A",
     $or: [ { qty: { $lt: 30 } }, { item: /^p/ } ]
} )
```

### like/ilike

```java
db.users.find({"name": /.*m.*/}) // like '%m%'
db.users.find({"name": /m/}) // like '%m%'
db.users.find({ "name" : /m/i } ) // ilike '%m%'
db.users.find({name: /a/})
db.users.find({name: /^pa/}) // like 'pa%'
db.users.find({name: /ro$/}) // like '%ro'
db.users.find({ name: { $regex: /.*m.*/i} })
```

https://www.w3schools.com/jsref/jsref_obj_regexp.asp



### exists

```java
db.records.find( { a: { $exists: true } } )
db.records.find( { b: { $exists: false } } )
```



### proyecciones

Las proyecciones son los campos a mostrar

```java
db.collection.find(<query document>, <projection document>)
> db.inventory.findOne({},{_id:0})
> db.inventory.findOne({},{item:1})
> db.inventory.findOne({},{_id:0,item:1})
{ "item" : "canvas" }
```



### subcampos

En la búsqueda de subcampos ( objetos dentro de objetos ) en el primer ejemplo se muestra como hay que asignar el subcampo entero a buscar ( El orden importa ). En el segundo ejemplo buscas un item dentro del subcampo.

```java
// buscar el objeto {h:28, w:35.5, uom:"cm"}
> db.inventory.findOne({size: {h:28, w:35.5, uom:"cm"}})
{
    "_id" : ObjectId("5e661beb63e51a5f0a8f3c27"),
    "item" : "canvas",
    "qty" : 100,
    "tags" : [
        "cotton"
    ],
    "size" : {
        "h" : 28,
        "w" : 35.5,
        "uom" : "cm"
    }
}
// buscar el valor del item "uom" dentro del subcampo de "size"
> db.inventory.findOne({"size.uom": "cm"})
```



### campos array

En la búsqueda de arrays existen diferentes soluciones:

- buscar toda la array (el orden de los items importa ).
- metodo `$all` indica que contenga esos items.

```java
// busqueda por array
db.inventory.find( { tags: ["blank", "red"] } )
// que contenga red y blank
db.inventory.find( { tags: { $all: ["red", "blank"] } } )
// que contenga red
db.inventory.find( { tags: "red" } )
```



#### entre

Búsquedas entre con comparadores

```java
// > 22 and < 30
> db.inventory.find( { dim_cm: { $elemMatch: { $gt: 22, $lt: 30 } } })
{ "dim_cm" : [ 22.85, 30 ] }

// > 25
> db.inventory.find( { "dim_cm.1": { $gt: 25 } } )
{ "dim_cm" : [ 22.85, 30 ] }
```



#### buscar entre objetos

buscar un item que contiene objetos, hay que buscar por objeto, el orden importa

```java
> db.inventory.find( { "instock": { warehouse: "A", qty: 5 } } )

// buscar en el primer objeto de instock
> db.inventory.find( { 'instock.0.qty': { $lte: 14 } } )
```



### Nor

Devuelve los elementos que no comparten ninguna de las condiciones

En el siguiente ejemplo la sentencia dice, muéstrame: 

- los que no tengan el item name, o un tamaño de array de 0, o un tamaño de array de 1. Estos no me los muestres.

```java
// $size es el numero de valores que tiene la array name
> db.test.find({$nor: [{name: {$exists: false}}, {name: {$size: 0}}, {name: {$size: 1}}]})
{ "name" : [ "George", "Raymond" ] }
{ "name" : [ "George", "Raymond", "Richard" ] }
{ "name" : [ "George", "Raymond", "Richard", "Martin" ] }
```



### not

```java
db.test.count({ "name": { "$not": { "$size": 0 } } });
```



### Aggregate



#### group

group ace una agrupación de los campos que coinciden y sum los suma.

```java
> db.inventory.aggregate([
	{ $match :{"status" : 'A'}}, 
	{ $group: {_id :"$status", total : {$sum: "$qty"} } }
])
// resultado	
{ "_id" : "A", "total" : 120 }
```



#### project

```java
{ "_id" : ObjectId("5e6bc9655a4fa4a58d139cd9"), "item" : "notebook", "qty" : [25, 25]}
{ "_id" : ObjectId("5e6bc9655a4fa4a58d139cdc"), "item" : "jupiter", "qty" : [10, 5]}
```



```java
> db.inventory.aggregate([
    { $match :{"item" : 'notebook'}}, 
    { $project: { total : {$sum: "$qty"} } }
])
// resultado    
{ "_id" : ObjectId("5e6bc9655a4fa4a58d139cd9"), "total" : 50 }
```



## Indices

### Texto

ver indice

```java
> db.stores.getIndexes()
[{
		"v" : 2,
		"key" : {
			"_id" : 1
		},
		"name" : "_id_",
		"ns" : "text.stores"
	}]
```

expandir index de texto a campos name y description

```java
> db.stores.createIndex( { name: "text", description: "text" } )
{
	"createdCollectionAutomatically" : false,
	"numIndexesBefore" : 1,
	"numIndexesAfter" : 2,
	"ok" : 1
}
```



```java
> db.stores.find({ $text: { $search: "java coffe shop"} })
{ "_id" : 5, "name" : "Java Shopping", "description" : "Indonesian goods" }
{ "_id" : 1, "name" : "Java Hut", "description" : "Coffee and cakes" }
{ "_id" : 3, "name" : "Coffee Shop", "description" : "Just coffee" }

> db.stores.find({ $text: { $search: "java -coffee shop"} })
{ "_id" : 5, "name" : "Java Shopping", "description" : "Indonesian goods" }

> db.stores.find({ $text: { $search: "java \"coffee shop\""} })
{ "_id" : 3, "name" : "Coffee Shop", "description" : "Just coffee" }
```

ordenar por relevancia

```java
> db.stores.find({ $text: { $search: "java coffe shop"} }, { puntuacio: { $meta: "textScore" }} ).sort( { puntuacio: {$meta: "textScore"}})
{ "_id" : 5, "name" : "Java Shopping", "description" : "Indonesian goods", "puntuacio" : 1.5 }
{ "_id" : 1, "name" : "Java Hut", "description" : "Coffee and cakes", "puntuacio" : 0.75 }
{ "_id" : 3, "name" : "Coffee Shop", "description" : "Just coffee", "puntuacio" : 0.75 }

```



### geoespaciales

Mongo permet crear uns [índexs geoespacials](https://docs.mongodb.com/manual/geospatial-queries/) per a camps que continguin aquest tipus d’informació, i així poder fer consultes sobre documents propers a certes coordenades. Les coordenades poden ser esfèriques-2D (com les de latitud i longitud de la Terra), o planars-2D.

```java
> db.cities.createIndex({"loc": "2dsphere"} , {"name": "loc.geoidx"})
```

var las ciudades que están hasta 20km de las cordenadas indicadas.

```java
> db.cities.find({"loc": {
...                      "$near": {
...      "$geometry": {
...      type: "Point" ,
...      coordinates: [116.40752599999996000, 39.90403]
...      },
...      "$maxDistance": 20000,
...      "$minDistance": 0
...   }
...    }
...                 })
```



#### Buscar orden cercanía

Devuelve documentos en orden de proximidad a un punto específico, del más cercano al más lejano.
límite: opcional. El número máximo de documentos a devolver. El valor predeterminado es 100.

```java
db.cities.aggregate ([
		{"$geoNear": 
			{"near": [-5.53888900000004,  38.639167], 
             "distanceField": "dis", 
             "includeLocs": "loc", 
             "spherical": true, 
             "maxDistance":  40000/6371, 
             "minDistance": 0/6371, 
             "distanceMultiplier": 6371}
			},
    	{"$project": 
			{"_id": false, "name": true, "dis": true}
		}
	])
```



#### Orden cercanía con max distancia

en una distancia de max de 20km

```java
db.cities.aggregate ([
		{"$geoNear": 
			{"near": [-5.53888900000004,  38.639167], 
             "distanceField": "dis", 
             "includeLocs": "loc", 
             "spherical": true, 
             "distanceMultiplier": 6371}
			},
    	{"$match": { "dis": {$lt: 20}}},
    	{"$project": 
			{"_id": false, "name": true, "dis": true}
		}
	])
    
    
db.cities.aggregate ([
		{"$geoNear": 
			{"near": [-5.53888900000004,  38.639167], 
             "distanceField": "dis", 
             "includeLocs": "loc", 
             "spherical": true, 
             "maxDistance":  20/6371, 
             "distanceMultiplier": 6371}
			},
    	{"$project": 
			{"_id": false, "name": true, "dis": true}
		}
	])
```







## Funciones

```java
function findCities(long, lat, maxDist, minDist) {
	return db.cities.aggregate ([
		{"$geoNear": 
			{"near": [long, lat], "distanceField": "dis", "includeLocs": "loc", "spherical": true, "maxDistance": maxDist/6371, "minDistance": minDist/6371, "distanceMultiplier": 6371}
			}, 
		{"$project": 
			{"_id": false, "name": true, "dis": true}
		}
	])
}
Aquesta funció només funciona si estem utilitzant la BD geo, és clar.
findCities(-5.53888900000004, 38.639167, 40000, 0)
```

