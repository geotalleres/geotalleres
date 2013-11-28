.. |PG| replace:: PostGIS

**********************************
Importación y exportación de datos
**********************************
En este tema nos introduciremos en el uso de herramientas de importación/exportación de datos hasta/desde |PG|. Se realizará la importación con archivos de tipo ESRI ShapeFile y con datos descargados de OpenStreetMap. Para realizar estos procesos, se dispondrá de herramientas como ``shp2pgsql`` que vienen incluidas en |PG| o se utilizarán otras como ``osmosis`` u ``osm2pgsql`` descargadas desde los repositorios.

Importación ESRI shapes mediante shp2pgsql
==========================================

El cargador ``shp2pgsql`` convierte archivos ESRI Shape en SQL preparado para la inserción en la base de datos. Se utiliza desde la linea de comandos, aunque existe una versión con interfaz gráfica para el sistema operativo Windows. Se puede acceder a la ayuda de la herramienta mediante::

	$ shp2pgsql -?
	
Para el uso de la herramienta::

	$ shp2pgsql [<opciones>] <ruta_shapefile> [<esquema>.]<tabla>
	
entre las opciones encontraremos:

	* **-s <srid>**  Asigna el sistema de coordenadas. Por defecto será -1
	* **(-d|a|c|p)**
		* *-d*  Elimina la tabla, la recrea y la llena con los datos del shape
		* *-a*  Llena la tabla con los datos del shape. Debe tener el mismo esquema exactamente
		* *-c*  Crea una nueva tabla y la llena con los datos. opción por defecto.
		* *-p*  Modo preparar, solo crea la tabla
	* **-g <geocolumn>** Especifica el nombre de la columna geometría (usada habitualmente en modo *-a*)
	* **-D** Usa el formato Dump de postgresql
	* **-G** Usa tipo geogrfía, requiere datos de longitud y latitud
	* **-k** Guarda los identificadores en postgresql
	* **-i** Usa int4 para todos los campos integer del dbf
	* **-I** Crea un índice spacial en la columna de la geometría
	* **-S** Genera geometrías simples en vez de geometrías MULTI
	* **-w** Salida en WKT
	* **-W <encoding>** Especifica la codificación de los caracteres. (por defecto : "WINDOWS-1252").
	* **-N <policy>** estrategia de manejo de geometrías NULL (insert*,skip,abort).
	* **-n**  Solo importa el archivo DBF
	* **-?**  Muestra la ayuda
	
Práctica
--------

Realice la importación de los datos proporcionados para el taller. Se le proporcionará asistencia con los parámetros a usar. 

Es conveniente definir el encoding de la base de datos como LATIN1. Se puede hacer con una sentencia update:

	.. note:: # update pg_database set encoding=8 where datname='base_de_datos'

	.. image:: _images/encoding.png
		:scale: 50%
	
Comprobar que se ha actualizado correctamente la tabla ``geometry_columns``.

Cargar alguno de los ficheros con la GUI de pgAdmin III.	

Vamos a hacer algunos cambios dentro de la tabla *barrios_de_bogota*. Tras cargar el SHP, ejecutemos estas sentencias desde psql o pgAdmin III::

	# update barrios_de_bogota set name='Usaquén' where gid = 1;
	update barrios_de_bogota set name='Chapinero' where gid = 2;
	update barrios_de_bogota set name='Santa Fé' where gid = 3;
	update barrios_de_bogota set name='San Cristóbal' where gid = 4;
	update barrios_de_bogota set name='Usme' where gid = 5;
	update barrios_de_bogota set name='Tunjuelito' where gid = 6;
	update barrios_de_bogota set name='Bosa' where gid = 7;
	update barrios_de_bogota set name='Ciudad Kennedy' where gid = 8;
	update barrios_de_bogota set name='Fontibón' where gid = 9;
	update barrios_de_bogota set name='Engativá' where gid = 10;
	update barrios_de_bogota set name='Suba' where gid = 11;
	update barrios_de_bogota set name='Barrios Unidos' where gid = 12;
	update barrios_de_bogota set name='Teusaquillo' where gid = 13;
	update barrios_de_bogota set name='Los Mártires' where gid = 14;
	update barrios_de_bogota set name='Antonio Nariño' where gid = 15;
	update barrios_de_bogota set name='Puente Aranda' where gid = 16;
	update barrios_de_bogota set name='Ciudad Bolívar' where gid = 17;
	update barrios_de_bogota set name='Rafael Uribe' where gid = 18;
	update barrios_de_bogota set name='Sumapáz' where gid = 19;

Y posteriormente éstas::

	# ALTER TABLE public.barrios_de_bogota ADD COLUMN population numeric DEFAULT 0;
	update barrios_de_bogota set population=544924 where gid = 1;
	update barrios_de_bogota set population=156274 where gid = 2;
	update barrios_de_bogota set population=107044 where gid = 3;
	update barrios_de_bogota set population=409653 where gid = 4;
	update barrios_de_bogota set population=301621 where gid = 5;
	update barrios_de_bogota set population=302342 where gid = 6;
	update barrios_de_bogota set population=795283 where gid = 7;
	update barrios_de_bogota set population=1344777 where gid = 8;
	update barrios_de_bogota set population=327933 where gid = 9;
	update barrios_de_bogota set population=893944 where gid = 10;
	update barrios_de_bogota set population=1118580 where gid = 11;
	update barrios_de_bogota set population=254162 where gid = 12;
	update barrios_de_bogota set population=138993  where gid = 13;
	update barrios_de_bogota set population=95866 where gid = 14;
	update barrios_de_bogota set population=116648 where gid = 15;
	update barrios_de_bogota set population=257090 where gid = 16;
	update barrios_de_bogota set population=567861 where gid = 17;
	update barrios_de_bogota set population=396711 where gid = 18;
	update barrios_de_bogota set population=20952 where gid = 19;

Por último, añadamos una nueva columna, que usaremos en un ejercicio posterior::

# ALTER TABLE public.barrios_de_bogota ADD COLUMN city text DEFAULT '';

	
Exportación desde |PG| a archivos de tipo ESRI Shapefile
========================================================

Para este proceso utilizaremos la herramienta ``pgsql2shp``. Con ella podremos convertir los datos de nuestra base de datos en archivos ESRI Shape. Igual que para el caso anterior, la herramienta se utilizará desde la linea de comandos::

	$ pgsql2shp [<opciones>] <basedatos> [<esquema>.]<tabla>
   $ pgsql2shp [<opciones>] <basedatos> <consulta>
   
las opciones serán::

	* **-f <nombrearchivo>**  Especifica el nombre del archivo a crear
	* **-h <host>**  Indica el servidor donde realizará la conexión
	* **-p <puerto>**  Permite indicar el puerto de la base de datos
	* **-P <password>**  Contraseña
	* **-u <user>** Usuario
	* **-g <geometry_column>** Columna de geometría que será exportada

Práctica
--------

	Exportar algún fichero de la base de datos a Shapefile otra vez.	

GDAL/OGR
========
GDAL/OGR es una librería de lectura y escritura de formatos geoespaciales, tanto *Raster* con GDAL como *Vectorial* con OGR. Se trata de una librería de software libre ampliamente utilizada.

ogrinfo
-------
``ogrinfo`` obtiene información de los datos vectoriales. Podremos utilizar esta herramienta para la obtención de esta información de las tablas que tenemos almacenadas en la base de datos. El uso se realiza a través de la consola::

	$ ogrinfo [<opciones>] <ruta fuente datos>
	
Entre las opciones destacaremos::

	* **-where** muestra los datos de las filas que cumplan la clausula
	* **-sql** filtra la información mediante consultas SQL
	* **-geom={YES/NO/SUMMARY}** modifica la visualización de la información de la columna geométrica 

Para utilizar ``ogrinfo`` contra nuestra base de datos, debemos utilizar la opción ``PG:`` indicandole la cadena de conexión::

	$ ogrinfo PG:"host=localhost user=usuario dbname=basedatos password=contraseña"

seguidamente incluiremos cualquiera de las opciones anteriores. De esta manera por ejemplo podremos indicar::

	$ ogrinfo PG:"host=localhost user=usuario dbname=basedatos password=contraseña" -sql "<una consulta>" <fuente de datos> 
	
ogr2ogr
-------

OGR es capaz de convertir a |PG| todos los formatos que maneja, y será capaz de exportar desde |PG| todos aquellos en los que tiene permitida la escritura. Ejecutando::

	$ ogr2ogr --formats
	
podremos comprobar los formatos que maneja la herramienta. La étiqueta ``write`` nos indica si podemos crear este tipo de formatos. Hemos de tener en cuenta el formato de salida para poder manejar los parametros especiales de cada formato.

En la página principal de GDAL podremos encontrar un listado de todas las opciones que nos permite manejar el comando. Detallamos a continuación algunas de las principales:

	* **-select <lista de campos>** lista separada por comas que indica la lista de campos de la capa de origen que se quiere exportar
	* **-where <condición>** consulta a los datos de origen
	* **-sql** posibilidad de insertar una consulta más compleja
	
Otras opciones en referencia al formato de destino (las anteriores hacían referencia al de origen):

	* **-f <driver ogr>** formato del fichero de salida
	* **-lco VARIABLE=VALOR** Variables propias del driver de salida
	* **-a_srs <srid>** asigna el SRID especificado a la capa de salida
	* **-t_srs <srid>** Reproyecta la capa de salida según el SRID especificado 

Práctica
--------

Vamos a cargar en PostGIS directamente un fichero KML y un fichero CSV.

Cargar fichero KML
^^^^^^^^^^^^^^^^^^

Descargar de http://forest.jrc.ec.europa.eu/effis/applications/firenews/kml/?&from_date=08/09/2013&to_date=15/09/2013 el fichero firenews.kml

A continuación, cargarlo en PostGIS con esta instrucción::

	# ogr2ogr -a_srs epsg:4326 -f "PostgreSQL" PG:"dbname=taller_semana_geomatica host=localhost user=postgres password=postgres port=5432" firenews.kml 

Ya tendríamos el fichero cargado.


Cargar fichero CSV
^^^^^^^^^^^^^^^^^^

Vamos a usar el fichero con los incendios detectados en las últimas 24 horas por Modis. Está en http://firms.modaps.eosdis.nasa.gov/active_fire/text/Global_24h.csv

Ahora, podemos elegir una de dos opciones:

	* Crear a mano una tabla con los campos necesarios y usar el comando COPY de PostgreSQL para copiar directamente el CSV.
	* Crear un fichero VRT a partir del CSV y cargar con ogr2ogr dicho fichero VRT

Para el primer caso, la tabla a crear es como sigue::

	# CREATE TABLE incendios_modis_24h (
	ogc_fid integer NOT NULL,
	the_geom public.geometry(Point,3857),
	latitude character varying,
	longitude character varying,
	brightness character varying,
	scan character varying,
	track character varying,
	acq_date character varying,
	acq_time character varying,
	satellite character varying,
	confidence character varying,
	version character varying,
	bright_t31 character varying,
	frp character varying
	);
	 
Y la línea a ejecutar desde psql o pgAdmin III::

	# COPY incendios_modis24h FROM '/path/to/csv/file/incendios_modis.csv' WITH DELIMITER ';' CSV HEADER;

Para el caso de usar ogr2ogr, primero creamos el VRT::

	<OGRVRTDataSource>
		<OGRVRTLayer name="Global_24h">
			<SrcDataSource>Global_24h.csv</SrcDataSource>
			<GeometryType>wkbPoint</GeometryType>
			<LayerSRS>EPSG:4326</LayerSRS>
			<GeometryField encoding="PointFromColumns" x="longitude" y="latitude"/>
		</OGRVRTLayer>
	</OGRVRTDataSource>

Y luego ejecutamos ogr2ogr::

	# ogr2ogr -a_srs epsg:4326 -f "PostgreSQL" PG:"dbname=taller_semana_geomatica host=localhost user=postgres password=postgres port=5432" incendios_modis.vrt


Importación datos OSM a PostGIS
===============================
OpenStreetMap (también conocido como OSM) es un proyecto colaborativo para crear mapas libres y editables.

Los mapas se crean utilizando información geográfica capturada con dispositivos GPS móviles, ortofotografías y otras fuentes libres. Esta cartografía, tanto las imágenes creadas como los datos vectoriales almacenados en su base de datos, se distribuye bajo licencia abierta Open Database Licence (ODbL).

OSM dispone de un modelo de datos particular que no responde al modelo característico de los SIG. Este está compuesto de:

	* Node
	* Way
	* Relation

a diferencia de las geometrías características como:

	* Punto
	* Linea
	* Poligono
	
una característica particular es la ausencia de polígonos dentro del modelo, estos se realizan mediante la asignación de una relación a una linea cerrada. Esta particularidad no impide que los datos de OSM puedan ser adaptados al modelo de geometrías normal mediante cargadores de datos OSM. A continuación se presentan dos de los más utilizados

osm2pgsql
---------
Mediante el uso de este programa podremos incorporar en nuestra base de datos los datos obtenidos desde OSM. Una vez que hemos realizado la importación, aparecerán en nuestra base de datos las tablas que serán el resultado de esta importación:

	* *planet_osm_point*
	* *planet_osm_line*
	* *planet_osm_polygon*
	* *planet_osm_roads*
	
Al disponer el modelo de OSM de cientos de etiquetas, la importación crea en las tablas un gran número de campos de los que la mayoría tendrán valor NULL.

La ejecución se realiza desde la consola::

	$ osm2pgsql [opciones] ruta_fichero.osm otro_fichero.osm
	$ osm2pgsql [opciones] ruta_planet.[gz, bz2]
	
algunas de las opciones se detallan a continuación:

	* *-H* Servidor |PG|
	* *-P <puerto>* Puerto
	* *-U <usuario>* Usuario
	* *-W* pregunta la password del usuario
	* *-d <base_de_datos>* base de datos de destino
	* *-a* añade datos a las tablas importadas anteriormente
	* *-l* almacena las coordenadas en latitud/longitug en lugar de Spherical Mercator
	* *-s* utiliza tablas secundarias para la importación en lugar de hacerlo en memoria
	* *-S <fichero_de_estilos>* ruta al fichero que indica las etiquetas de OSM que se quiere importar
	* *-v* modo verborrea, muestra la salida de las operaciones por consola

En caso de no disponer del SRID 900913 en nuestro |PG| podremos utilizar la definición que hay de él en ``osm2pgsql``. Simplemente ejecutaremos el script 900913.sql

Práctica
--------

Vamos a exportar datos de OpenStreetMap y cargarlos en PostGIS con osm2pgsql. Para ello, vamos primero a http://www.openstreetmap.org/export#

Veremos que, si el área a exportar es muy grande, la página nos redireccionará a servicios de descarga masiva, como http://download.geofabrik.de/south-america/colombia.html. De hecho, el enlace para descargar los datos de Colombia es http://download.geofabrik.de/south-america/colombia-latest.osm.bz2. Pero, **ojo**: si hay muchos datos y la máquina no es muy potente, puede tardar mucho en cargarlos.

Una vez hemos descargado lo que queremos, vamos a proceder a activar en PostGIS la extensión hstore. Esto permite la creación de una nueva estructura de almacenamiento en PostGIS llamada hstore. No es más que una estructura de datos pensada para almacenar en una columna un dato de tipo *clave => valor*. Gracias a ello, podremos usar etiquetas en las consultas que lancemos::

	# SELECT way, tags FROM planet_osm_polygon WHERE (tags -> 'landcover') = 'trees'; 

Para tener más información, ir a http://wiki.openstreetmap.org/wiki/Osm2pgsql#hstore

Para cargar en PostGIS el fichero exportado, ejecutaríamos esta orden (**no ejecutarla**)::

	# osm2pgsql -d taller_semana_geomatica -U postgres --hstore colombia-latest.osm

El problema es que eso cargaría nuestros datos en una proyección 900913 (WebMercator). Si lo queremos en 4326 (WGS84), la instrucción es::

	# osm2pgsql -d taller_semana_geomatica -U postgres --latlong --hstore colombia-latest.osm

Si tras ejecutar la instrucción obtenemos este error::

	# Projection code failed to initialise

El problema es que osm2pgsql no sabe dónde buscar las definiciones de los sistemas de coordenadas. Debemos definir la variable de entorno *PROJ_LIB* para que apunte donde es debido. En Linux sería::

	# export PROJ_LIB=/usr/local/share/proj

Esto cargaría los datos de OSM en nuestra base de datos. Si nos fijamos en la tabla de polígonos, vemos que tienen definido un campo *population*. Desde QGIS podemos configurar para que solo nos muestre los polígonos con los datos de población, y compararlos con los que hemos metido a mano en la tabla *barrios_de_bogota*, actualizados en 1998.
	
osmosis
-------

Esta herramienta también realiza la importación de datos desde OSM a |PG|, pero a diferencia de la anterior, esta mantiene las relaciones entre los objetos de OSM importados. Se recomienda acudir a la documentación de la herramienta para comprender mejor su uso.

Consulta mediante visores web y SIG escritorio
==============================================

Mediante el uso de diferentes Software tanto de escritorio como de entorno web, accederemos a los datos que hemos importado y podremos tanto visualizarlos como crear servicios web adaptados de estos datos.

Prácticas
---------

Operaciones con QGIS: mostrar tablas de PostGIS, etiquetar, colorear, etc.
	
	
	
