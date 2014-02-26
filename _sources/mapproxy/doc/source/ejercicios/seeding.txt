Ejercicio: *seeding* y borrado de *caches*
--------------------------------------------


Sembrar una caché
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Sembrar una caché significa llenar toda la caché de antemano. Hay un par de
casos de uso típicos para los que es adecuado sembrar las cachés:

* Usar cartografía en portátiles sin una conexión fiable a Internet (en campo,
  en el extranjero, o en una demo)
* Acelerar el acceso a las capas cacheadas, descargando todo (por ejemplo) la
  noche anterior


En este ejercicio vamos a sembrar los datos de OSM en el área de Gerona, pero
sólo para unos cuantos niveles de zoom. Una vez hecho el sembrado, veremos cómo
MapProxy sirve las imágenes sin necesidad de pedirlas al origen.


Sembrado sencillo
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

La tarea más sencilla es lanzar *una* **tarea** de sembrado *un* **cache** en
*una* **cobertura** (área) para algunos **niveles de zoom**. La *cache* (con sus
correspondientes *capas* y *origenes*) deberían estar ya definidos en vuestros
*mapproxy.yaml*. Las tareas de sembrado y las coberturas se definen en un
fichero aparte, normalmente nombrado *seed.yaml*.

Hay que recordar que la caché es siempre una pirámide de imágenes, y que su
extensión y niveles de zoom vienen referidos por el *grid* del *mapproxy.yaml*.
Por eso, cuando se siembra una caché, se hace referencia a los niveles de zoom
de esta pirámide.


Primero queremos sembrar la caché de la capa de OpenStreetMap, en la zona de
Gerona. Para hacer esto, escribid un fichero *seed.yaml* que contenga una tarea
de sembrado que haga referencia a la *cache* apropiada y a una cobertura con el
bounding box de Gerona, para niveles de zoom del 1 al 10.

Una vez escrito el fichero *seed.yaml*, se puede hacer el sembrado ejecutando
``mapproxy-seed -f mapproxy.yaml -s seed.yaml -i``. Si estuviera en producción,
cambiaríamos ``-i`` por ``-seed=ALL`` para poder automatizarlo.

A continuación puedes crear una tarea de caché de la capa de la ortofoto para el
grid UTM, para niveles de zoom del 1 al 7 y el mismo *coverage*.


Limpiando cachés
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Para asegurar que solo tenemos la caché de los datos que se usan en la oficina,
vamos a crear una tarea de limpieza que borre los datos a partir del nivel 8 de
la cache de la ortofoto del ICC en coordenadas UTM, pero solo aquellas teselas
que tengan más de **1 semana**, **2 días**, **3 horas** y **4 minutos**.

De esta forma mantenemos los niveles superiores pero nos deshacemos de aquellas
teselas que no se visitan desde hace un tiempo.


Comprobación
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Si ejecutamos el comando ``mapproxy-seed`` pasando como parámetro la opción
``--summary`` obtendremos el siguiente resumen de las tareas de sembrado y
limpieza de teselas.

::

	========== Seeding tasks ==========
	  girona_osm:
	    Seeding cache 'osm_cache' with grid 'GLOBAL_MERCATOR' in EPSG:900913
	    Limited to: 2.67000, 41.88000, 2.97000, 42.07000 (EPSG:4326)
	    Levels: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
	    Overwriting: no tiles
	  girona_icc:
	    Seeding cache 'icc_cache' with grid 'utm_girona' in EPSG:25831
	    Limited to: 2.66902, 41.87953, 2.97009, 42.07047 (EPSG:4326)
	    Levels: [1, 2, 3, 4, 5, 6, 7]
	    Overwriting: no tiles
	========== Cleanup tasks ==========
	  girona:
	    Cleaning up cache 'icc_cache' with grid 'GLOBAL_MERCATOR' in EPSG:900913
	    Limited to: 2.67000, 41.88000, 2.97000, 42.07000 (EPSG:4326)
	    Levels: [8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19]
	    Remove: tiles older than 2013-01-25 15:20:58
	  girona:
	    Cleaning up cache 'icc_cache' with grid 'GLOBAL_GEODETIC' in EPSG:4326
	    Limited to: 2.67000, 41.88000, 2.97000, 42.07000 (EPSG:4326)
	    Levels: [8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19]
	    Remove: tiles older than 2013-01-25 15:20:58
	  girona:
	    Cleaning up cache 'icc_cache' with grid 'utm_girona' in EPSG:25831
	    Limited to: 2.66902, 41.87953, 2.97009, 42.07047 (EPSG:4326)
	    Levels: [8, 9, 10, 11]
	    Remove: tiles older than 2013-01-25 15:20:58


Por otra parte, si ejecutamos ``mapproxy`` después de haber sembrado la caché,
en su salida por consola se ven las peticiones WMS que está sirviendo, pero
**no** las peticiones al *source* que debería estar haciendo (porque todas esas
peticiones se han hecho durante el proceso de sembrado).


Autores:
-------------------------

* Pedro-Juan Ferrer `@vehrka <http://twitter.com/vehrka>`_ · pferrer@osgeo.org
* Iván Sanchez `@realivansanchez <http://twitter.com/realivansanchez>`_ · ivan@sanchezortega.es
* Jorge Sanz `@xurxosanz <http://twitter.com/xurxosanz>`_ · jsanz@osgeo.org
