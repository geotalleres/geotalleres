.. |PG| replace:: *PostGIS*
.. |PR|	replace:: *PostGIS Raster*	

***********
|PR|
***********

Introducción
=========================

Desde la versión 2.0 de |PG|, es posible cargar y manipular datos de naturaleza ráster en una base de datos espacial, gracias a |PR|: un nuevo conjunto de tipos y funciones que dotan a PostGIS de la posibilidad de manipular datos ráster.

El objetivo de |PR| es **la implementación de un tipo de datos RASTER lo más parecido posible al tipo GEOMETRY de** |PG| **, y ofrecer un único conjunto de funciones SQL que operen de manera transparente tanto en coberturas vectoriales como en coberturas de tipo ráster.**

Como ya hemos mencionado, |PR| es parte oficial de |PG| 2.0, de manera que **no es necesario instalar ningún software adicional**. Cuando una base de datos PostgreSQL es activada con |PG|, ya es al mismo tiempo también activada con |PR|.


Tipo de datos Raster
==============================

El aspecto más importante a considerar sobre el nuevo tipo de datos RASTER definido por |PR| es **que tiene significado por si mismo**. O de otra forma: **una columna de tipo RASTER es una cobertura raster completa, con metadatos y posiblemente geolocalizada, pese a que pertenezca a una cobertura raster mayor**.

Tradicionalmente, las bases de datos espaciales con soporte para ráster, han permitido cargar y teselar coberturas ráster para operar con ellas. Normalmente, se almacenaban los metadatos de la cobertura completa por un lado (geolocalización, tamaño de píxel, srid, extensión, etc) y las teselas por otro, como simples *chunks* de datos binarios adyacentes. La filosofía tras |PR| es diferente. También permite la carga y teselado de coberturas completas, pero cada tesela por separado, **contiene sus propios metadatos y puede ser tratada como un objeto raster individual**. Además de eso, una tabla de |PR| cargada con datos pertenecientes a una misma cobertura:

	* Puede tener teselas de diferentes dimensiones (alto, ancho).
	* Puede tener teselas no alineadas con respecto a la misma rejilla.
	* Puede contener *huecos* o teselas que se solapan unas con otras.

Este enfoque hace a |PR| una herramienta muy poderosa, aunque también tiene algunos problemas inherentes (como el bajo rendimiento en aplicaciones de visualización de datos ráster en tiempo real). Para saber más sobre |PR| el mejor sitio donde acudir es http://trac.osgeo.org/postgis/wiki/WKTRaster

En los siguientes apartados, veremos algunas de las operaciones que se pueden realizar con |PR|


Procesando y cargando raster con GDAL VRT
=========================================

Como ya hemos visto en el capítulo de importación y exportación, la manera de cargar datos ráster en |PR| es a través de *raster2pgsql*. En este capítulo, trabajaremos con datos sobre las temperaturas en Colombia durante el mes de Septiembre del año 2010. 

Tenemos datos relativos a todas las zonas del planeta y varios meses disponibles en la url http://www.worldclim.org. Las zonas que nos interesan a nosotros son 2: zona 23 y zona 33. La zona 23 contiene los datos de la mayor parte de Colombia, y el resto está en la zona 33. Las url de descarga de datos de esas zonas son:

	* http://www.worldclim.org/tiles.php?Zone=23
	* http://www.worldclim.org/tiles.php?Zone=33

Los datos en si son ficheros GeoTIFF con una sola banda. Aquí vemos ambos fragmentos visualizados en QGIS:


	.. image:: _images/temperaturas_colombia.png
		:scale: 50 %

Podríamos cargar los ficheros GeoTIFF por separado en una misma tabla, mediante dos llamadas a *raster2pgsql*, pero lo que vamos a hacer es construir un raster virtual en formato VRT, y cargar ese ráster en |PR| con una única llamada a *raster2pgsql*. Lo haremos en 3 pasos:

	1. Construir fichero VRT a partir de los ficheros TIFF con *gdalbuildvrt*:: 

		# gdalbuildvrt tmean9.vrt tmean9_*.tif

	2. Crear el fichero SQL a partir del fichero VRT generado en el paso anterior::

		# raster2pgsql -I -C -F -t 36x36 -P -M -s 4326 tmean9.vrt > tmean9.sql

	3. Cargar el fichero SQL en |PR|::

		# psql -d taller_semana_geomatica -f tmean9.sql -U postgres

Con eso ya tendríamos ambos ficheros cargados en |PR|

Un problema que tenemos ahora es que los ficheros GeoTIFF tienen muchos más datos que simplemente los datos de Colombia. Es por eso que, para los siguientes apartados, vamos a *recortar* una parte del fichero GeoTIFF, que comprenda solo Colombia, y cargaremos esa parte en |PR|, con el nombre *tmean9_colombia*.

El recorte se hará usando la herramienta *clipper* de QGIS, que no es más que una interfaz gráfica de usuario para llamar a gdal_translate pasándole las coordenadas de inicio y fin y la altura y anchura del rectángulo a obtener. A pesar de que esta operación se realizará en clase, no se profundizará en ella, por exceder de los límites del curso. Se realiza únicamente para justificar la existencia de la tabla utilizada en los ejemplos posteriores.

La imagen recortada queda así (se ha aplicado un pseudo-color a la capa para apreciar el contorno de Colombia dentro del fichero GeoTiff):

 
	.. image:: _images/temperaturas_recorte_colombia.png
		:scale: 50 %

Bastante más pequeña y manejable. 

De todas formas, aun podemos afinar más esta operación de recorte. En un apartado posterior veremos como utilizar la geometría que define los límites de Colombia como *molde* para quedarnos únicamente con la porción del ráster contenida dentro de esos límites.


Obtención de metadatos y estadísticas de una capa |PR|
======================================================

Mediante consultas SQL, es posible obtener metadatos y estadísticas de las capas ráster almacenadas.

Obtención de metadatos
^^^^^^^^^^^^^^^^^^^^^^

Podemos obtener los metadatos de una tabla |PR| mediante una consulta al catálogo *raster_columns*

El catálogo *raster_columns* se mantiente actualizado automáticamente con los cambios de las tablas que contiene. Las entradas y salidas del catálogo se controlan mediantes las funciones **AddRasterConstraints** y **DropRasterConstraints**. Para más información, consultar http://postgis.net/docs/manual-2.0/using_raster.xml.html#RT_Raster_Columns

Para consultar los metadatos de una tabla mediante el catálogo *raster_columns* hacemos::


	#SELECT
		r_table_name,
		r_raster_column,
		srid,
		scale_x,
		scale_y,
		blocksize_x,
		blocksize_y,
		same_alignment,
		regular_blocking,
		num_bands,
		pixel_types,
		nodata_values,
		out_db,
		ST_AsText(extent) AS extent
	FROM raster_columns WHERE r_table_name = 'tmean9_colombia';


Y la salida es:


	.. image:: _images/raster_properties.png
		:scale: 30 %

También podemos obtener metadatos mediante las funciones *ST_MetaData* y *ST_BandMetaData*, pero hemos de tener en cuenta que estas funciones **operan sobre una sola columna** mientras que la consulta a *raster_columns* **obtiene los datos de la tabla completa**. En el caso de que el ráster cargado en |PR| sea teselado, lo más normal, posiblemente no nos interese obtener los metadatos de cada una de las teselas, sino de la cobertura completa.

Aquí tenemos un ejemplo de cómo obtener los metadatos de una banda de una de las teselas de nuestro ráster::

	# SELECT
		rid,
		(ST_BandMetadata(rast, 1)).*
	FROM tmean9_colombia
	WHERE rid = 1265; 

El resultado es como sigue::


 	#  rid | pixeltype | nodatavalue | isoutdb | path
	 ------+-----------+-------------+---------+------
 	  1266 | 32BF      |             | f       |

	
	

Obtención de estadísticas
^^^^^^^^^^^^^^^^^^^^^^^^^

Si lo que queremos es obtener estadísticas de nuestras capas ráster, podemos hacer una consulta SQL como la siguiente::

	# WITH stats AS (
		SELECT
			(ST_SummaryStats(rast, 1)).*
		FROM tmean9_colombia
		WHERE rid = 1266
	)
	SELECT
		count,
		sum,
		round(mean::numeric, 2) AS mean,
		round(stddev::numeric, 2) AS stddev,
		min,
		max
	FROM stats;

Y la salida es::

	# count |  sum   |  mean  |  stddev | min | max
	 -------+--------+--------+---------+-----+-----
  	   1296 | 326501 | 251.93 |    7.21 | 223 | 263


En la salida, podemos ver que los valores para las temperaturas mínima y máxima no parecen tener sentido. Lo que sucede es que son valores en grados centígrados que han sido escalados por 100. Más información en http://www.prism.oregonstate.edu/docs/meta/temp_realtime_monthly.htm

A continuación, veremos como modificar esos valores mediante el uso de operaciones de MapAlgebra.


MapAlgebra sobre capas |PR|
===========================

En el apartado anterior, vimos como los valores de temperaturas de la capa ráster estaban escalados por 100. Vamos a cambiar todos estos valores usando una expresión de MapAlgebra. Para ello, añadiremos una nueva banda con los valores cambiados::

	# UPDATE tmean9_colombia SET
		rast = ST_AddBand(
			rast,
			ST_MapAlgebraExpr(rast, 1, '32BF', '[rast] / 100.', -9999),
			1
		);

En la llamada a MapAlgebra, hemos especificado que la banda de salida tendrá un tamaño de píxel de 32BF y un valor NODATA de -9999. Con la expresión *[rast] / 100*, convertimos cada valor de píxel a su valor previo al escalado.

Tras ejecutar esa consulta, el resultado es éste::

	# ERROR:  new row for relation "tmean9_colombia" violates check constraint "enforce_out_db_rast"
	DETAIL:  Failing row contains (1, 0100000200563C2A37C011813F18FD8BFEC51081BF00000000426E54C0000000..., tmean9_colombia.tif)

Como vemos, la consulta no ha funcionado. El problema es que, cuando cargamos esta capa ráster usando raster2pgsql, especificamos el flag **-C**. Este flag activa una serie de restricciones en nuestra tabla, para garantizar que todas las columnas de tipo RASTER tienen los mismos atributos (más información en http://postgis.net/docs/manual-2.0/RT_AddRasterConstraints.html).

El mensaje de error nos dice que hemos violado una de esas restricciones. Concretamente la restricción de *out-db*. A primera vista, puede parecer extraño, porque nosotros no estamos especificando que la nueva banda sea de tipo *out-db*. El problema es que esta restricción solo funciona con una banda, y si se intenta añadir una segunda banda a un ráster que ya tiene una, la restricción lo hace fallar.

La solución a nuestro problema pasa por:

	1. Eliminar las restricciones de la tabla mediante *DropRasterConstraints*
	2. Volver a ejecutar la consulta
	3. Volver a activar las restricciones (**OJO: Es una operación costosa en datos raster muy grandes**)


Las consultas a ejecutar son las siguientes::

	# SELECT DropRasterConstraints('tmean9_colombia', 'rast'::name);
	# UPDATE tmean9_colombia SET rast = ST_AddBand(rast, ST_MapAlgebra(rast, 1, '32BF', '[rast] / 100.', -9999), 1);
	# SELECT AddRasterConstraints('tmean9_colombia', 'rast'::name);

Y el resultado es::

	# droprasterconstraints
	-----------------------
 	t

	# UPDATE 2950

	# addrasterconstraints
	----------------------
 	t


Ahora comprobaremos que una nueva banda ha sido añadida a nuestro ráster::

	# SELECT
		(ST_Metadata(rast)).numbands
	FROM tmean9_colombia
	WHERE rid = 1266;

Devuelve::

	# numbands
	----------
	2


¿Y cuáles son los detalles de esas dos bandas?::

	# WITH stats AS (
		SELECT
			1 AS bandnum,
			(ST_SummaryStats(rast, 1)).*
		FROM tmean9_colombia
		WHERE rid = 1266
		UNION ALL
		SELECT
			2 AS bandnum,
			(ST_SummaryStats(rast, 2)).*
		FROM tmean9_colombia
		WHERE rid = 1266
	)

	SELECT
		bandnum,
		count,
		round(sum::numeric, 2) AS sum,
		round(mean::numeric, 2) AS mean,
		round(stddev::numeric, 2) AS stddev,
		round(min::numeric, 2) AS min,
		round(max::numeric, 2) AS max
	FROM stats
	ORDER BY bandnum;

El resultado es::

	# bandnum | count |    sum    |  mean  | stddev |  min   |  max
	 ---------+-------+-----------+--------+--------+--------+--------
      		1 |  1296 | 326501.00 | 251.93 |   7.21 | 223.00 | 263.00
       		2 |  1296 |   3265.01 |   2.52 |   0.07 |   2.23 |   2.63

Vemos que el valor en la banda 2 ha sido corregido, dividiendo los valores de temperaturas entre 100. Ahora las temperaturas tienen sentido como grados centígrados


Clip de datos ráster usando geometrías
=========================================================

Una de las grandes ventajas de poder tener datos de naturaleza ráster y vectorial cargados en |PG| es que se puede operar con ellos mediante la utilización de la misma API SQL. En este ejemplo, veremos como *recortar* un raster usando una geometría como modelo.

Trabajaremos con los datos ráster de temperaturas, y con los datos vectoriales de Colombia. Como vemos en esta imagen (coloreada con pseudocolor en QGIS 2.0), el ráster ocupa bastante más extensión que Colombia:

	.. image:: _images/raster_with_vector.png
		:scale: 50 %

Lo que queremos es *recortar* la parte del ráster que queda dentro de los límites de Colombia. Y lo haremos únicamente con **consultas SQL**. Posteriormente, volcaremos ese ráster recortado a disco, en formato GeoTIFF.

La consulta que se queda solamente con la parte del ráster comprendida dentro de los límites de Colombia es::

	# CREATE TABLE tmean9_colombia_clip AS 
	SELECT t.rid, t.rast, c.admin_name 
	FROM tmean9_colombia t JOIN co c ON ST_Intersects(t.rast, c.geom)

Con esa consulta hemos logrado crear una tabla con datos ráster **únicamente** comprendidos dentro de los límites de Colombia. Para visualizar esa tabla, tenemos dos opciones. Ambas requieren de **GDAL 2.0**

	* Volcar el contenido de la tabla a disco, a formato GeoTIFF, mediante el uso de *gdal_translate* http://www.gdal.org/gdal_translate.html
	* Instalar en QGIS el plugin de visualización de PostGIS Raster. El problema es que **aun no se ha portado el plugin a la versión 2.0 de QGIS**

Elegimos la primera opción, por no requerir la instalación de ningún software adicional. La orden que debemos ejecutar es::

	# gdal_translate PG:"host=localhost port=5432 dbname=taller_semana_geomatica user=postgres password=postgres table=tmean9_colombia_clip mode=2" tmean9_colombia_clip.tif


Y el aspecto de este ráster recortado una vez colocado sobre el mapa y coloreado con pseudocolor en QGIS 2.0 es:

.. image:: _images/postgis_raster_clipped.png
	:scale: 30 %


Combinando raster y geometrías para análisis espacial
=====================================================

Vamos a ver ahora cuáles fueron las temperaturas máximas, mínimas y medias de todos los barrios de Bogotá durante el mes de Septiembre. Para ello, usaremos nuevamente la API SQL de |PG| y |PR| junto con las funciones de agregación de PostgreSQL.

La consulta a realizar es la siguiente::

	# WITH stats AS (
		SELECT rast, (ST_SummaryStats(rast, 2)).* 
		FROM tmean9_colombia_clip
	) 

	SELECT 
		b.name, 
		ROUND(AVG(s.mean::numeric), 2) AS tmean, 
		ROUND(AVG(s.min::numeric), 2) as tmin, 
		ROUND(AVG(s.max::numeric), 2) as tmax 
	FROM stats s JOIN barrios_de_bogota b ON ST_Intersects(s.rast, b.geom)
	GROUP BY b.name
	ORDER BY b.name

El resultado es el siguiente::

	# 	  name      | tmean | tmin | tmax
	----------------+-------+------+------
 	 Antonio Nariño |  1.19 | 0.63 | 2.04
 	 Barrios Unidos |  1.25 | 0.79 | 1.72
 	 Bosa           |  1.39 | 0.66 | 2.23
 	 Chapinero      |  1.25 | 0.79 | 1.72
 	 Ciudad Bolívar |  1.19 | 0.63 | 2.04
 	 Ciudad Kennedy |  1.19 | 0.63 | 2.04
 	 Engativá       |  1.25 | 0.79 | 1.72
 	 Fontibón       |  1.25 | 0.79 | 1.72
 	 Los Mártires   |  1.19 | 0.63 | 2.04
 	 Puente Aranda  |  1.19 | 0.63 | 2.04
 	 Rafael Uribe   |  1.19 | 0.63 | 2.04
 	 San Cristóbal  |  1.19 | 0.63 | 2.04
 	 Santa Fé       |  1.19 | 0.63 | 2.04
 	 Suba           |  1.30 | 0.96 | 1.41
	 Sumapáz        |  1.10 | 0.46 | 2.19
 	 Teusaquillo    |  1.19 | 0.63 | 2.04
 	 Tunjuelito     |  1.19 | 0.63 | 2.04
 	 Usaquén        |  1.25 | 0.79 | 1.72
 	 Usme           |  1.08 | 0.56 | 2.08



