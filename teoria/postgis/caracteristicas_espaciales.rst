.. |PG|  replace:: *PostGIS*
.. |PSQL| replace:: *PostgreSQL*
.. |PG_VERSION| replace:: *2.0*

********************************
|PG|, características espaciales
********************************
Introducción
============
Para el curso que nos compete realizaremos las prácticas con la versión 2.0 de |PG| por ser la que dispone del módulo de Raster y de Topología. |PG| es una extensión espacial para |PSQL| que permite gestionar objetos geográficos, de tal manera que añade esta capacidad al SGBD |PSQL|. 
 
Instalación y configuración de |PG|
===================================

En función del sistema operativo que estemos usando, la instalación será de una forma u otra. Como ya hemos mencionado, vamos a contemplar tres sistemas operativos:

	* Sistemas Windows XP/7
	* Sistemas Mac OS X
	* Sistemas basados en Debian

Windows
-------


Mac OS X
--------


Debian/Ubuntu/Derivados
-----------------------



Espacialización de una base de datos
------------------------------------


La integración de |PG| con |PSQL| está hecha en el lenguaje PL/PGSQL, por
lo que para dotar de capacidades espaciales una base de datos existente es necesario
primero añadir soporte para este lenguaje. Esto es necesario para versiones de |PSQL| anteriores a la 8.4::

	$ createlang plpgsql curso

.. image:: _images/postgis-images/pre-postgis.png
	   :scale: 50 %

.. image:: _images/postgis-images/pre-postgis-2.png
	   :scale: 50 %
	   
Hecho esto, la instalación de |PG| se hará de una forma u otra, en función de si estamos usando una versión de |PSQL| anterior a la 9.1 o no.

Instalación de |PG| en versión de |PSQL| inferior a 9.1
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A continuación hay que localizar dos ficheros SQL de PostGIS que al ejecutarse
añadiran las estructuras necesarias a nuestra base de datos. Estos ficheros
se llaman *lwpostgis.sql* (o símplemente *postgis.sql*) y *spatial_ref_sys.sql*.

Para localizarlos podemos utilizar el comando *locate*::

	$ locate postgis.sql
	/usr/share/postgresql/8.4/contrib/postgis-|PG_VERSION|/postgis.sql
	/usr/share/postgresql/8.4/contrib/postgis-|PG_VERSION|/uninstall_postgis.sql
	/usr/share/postgresql/9.1/contrib/postgis-|PG_VERSION|/postgis.sql
	/usr/share/postgresql/9.1/contrib/postgis-|PG_VERSION|/uninstall_postgis.sql
	
	$ locate spatial_ref_sys.sql
	/usr/share/postgresql/8.4/contrib/postgis-|PG_VERSION|/spatial_ref_sys.sql
	/usr/share/postgresql/9.1/contrib/postgis-|PG_VERSION|/spatial_ref_sys.sql

Una vez localizados dos ficheros de la misma versión, es necesario ejecutarlos
en el servidor. Existen dos formas de hacerlo con *psql*: el parámetro -f y
el comando \\i. Con el parámetro -f llamaríamos a *psql* desde la línea de
comandos del sistema y especificaríamos el fichero .sql que queremos ejecutar
con dicho parámetro. Para que el fichero se ejecute en la base de datos que
nos interesa hay que especificar también el parámetro -d visto anteriormente::

	$ psql -U postgres -d template_postgis -f /usr/share/postgresql/9.1/contrib/postgis-|PG_VERSION|/postgis.sql
	$ psql -U postgres -d template_postgis -f /usr/share/postgresql/9.1/contrib/postgis-|PG_VERSION|/spatial_ref_sys.sql

La opción de usar el comando \\i consiste en entrar al modo interactivo de *psql*
conectando a la base de datos de interés y ejecutando el fichero con \\i::

	$ psql -U postgres -d template_postgis
	=# \i /usr/share/postgresql/9.1/contrib/postgis-|PG_VERSION|/postgis.sql
	=# \i /usr/share/postgresql/9.1/contrib/postgis-|PG_VERSION|/spatial_ref_sys.sql
	
o también se puede entrar a la base de datos por defecto (*postgres*) y
conectar interactivamente a nuestra base de datos luego con \\c::

	$ psql -U postgres
	=# \c template_postgis
	=# \i /usr/share/postgresql/9.1/contrib/postgis-|PG_VERSION|/postgis.sql
	=# \i /usr/share/postgresql/9.1/contrib/postgis-|PG_VERSION|/spatial_ref_sys.sql
	
Tras esta operación se puede observar que han aparecido dos 
nuevas tablas: *geometry_columns* y *spatial_ref_sys*, además de
numerosas funciones en el esquema *public*.

.. image:: _images/postgis-images/postgis-1.png
	   :scale: 50 %
	   
.. image:: _images/postgis-images/postgis-2.png
	   :scale: 50 %
	   
.. image:: _images/postgis-images/postgis-3.png
	   :scale: 50 %

.. image:: _images/postgis-images/postgis-4.png
	   :scale: 50 %
	   	   
La tabla *geometry_columns* es un catálogo de las columnas espaciales existentes en la base de datos. Como PostGIS no utiliza los tipos de datos espaciales de PostgreSQL, debe buscarse una manera de identificar qué campo contiene geometrías. Esto se hace de manera estándar (OGC) manteniendo un catálogo con la lista de columnas espaciales que existen. Cuando un cliente, como gvSIG por ejemplo, intente identificar las tablas espaciales que hay en la base de datos irá a la tabla *geometry_columns* y verá referencias a las tablas que contienen los datos espaciales. Por esto hay que tenerla siempre actualizada. Por su parte, la tabla *spatial_ref_sys* contiene una lista con los sistemas de referencia disponibles.

.. image :: _images/training_postgis_spacialized.png

Podremos comprobar la versión que tenemos instalada de |PG| mediante::

	# SELECT postgis_full_version();



Instalación de |PG| en versión de |PSQL| 9.1 o superior
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Si se cuenta con |PSQL| 9.1 o superior, podremos utilizar la expresión **CREATE EXTENSION**. 

De manera que instalar |PG| será tan sencillo como::

	# CREATE EXTENSION postgis;

	
Creación de una plantilla template_postgis
------------------------------------------

Podremos utilizar la base de datos creada inicialmente como plantilla para la posterior creación de bases de datos espaciales evitando tener que repetir el proceso. Para ello simplemente::

	$ createdb -U postgres -T template_postgis [nueva_base_datos]
	
En caso de querer crear la base de datos con un usuario diferente al utilizado para la creación de la plantilla debemos indicarselo al sistema::

	# UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template_postgis';
	
Y seguidamente debemos asignarle permisos al esquema PUBLIC en las tablas de metadatos::

	# GRANT ALL ON geometry_columns TO PUBLIC;
	# GRANT ALL ON geography_columns TO PUBLIC;
	# GRANT ALL ON spatial_ref_sys TO PUBLIC;
	
Indices espaciales
==================
Una base de datos ordinaria pone a disposición del usuario una estructura de datos que sirve para agilizar el acceso a determinados registros en función del valor que tienen en un campo. La indexación para tipos de datos estándar que pueden ser ordenados (alfabéticamente o numéricamente) consiste en esencia en ordenar estos registros de manera que sea fácil localizarlos.

Pero en el caso de la información espacial no existe un orden total ya que un polígono puede contener a un punto, cruzarse con una línea, etc. En cambio, se ponen en marcha ciertas estrategias para asociar los registros con determinadas partes del territorio que cubren y así poder obtener los registros que se encuentran cerca de una posición dada.

|PSQL| implementa un algoritmo de indexación espacial denomimado ``GiST`` (Generalized Search Tree). |PG| extiende los índices ``GiST`` para que funcionen adecuadamente con los tipos ``geometry```.

Se recomienda el uso de estos índices cuando el número de registros excede de algunos miles. De esta manera se incrementará la velocidad de la búsqueda espacial y su visualización en SIG de escritorio. 


Funciones espaciales
====================
Una base de datos ordinaria proporciona funciones para manipular los datos en una consulta. Estas funciones incluyen la concatenación de cadenas, operaciones matemáticas o la extración de información de las fechas. Una base de datos espacial debe proporcionar un completo juego de funciones para poder realizar análisis con los objetos espaciales: analizar la composición del objeto, determinar su relación espacial con otros objetos, transformarlo, etc. 

La mayor parte de las funciones espaciales pueden ser agrupadas en una de las siguientes cinco categorías:

- Conversión: Funciones que convierten las geometrías a otros formatos externos

- Gestión: Tareas administrativas de PostGIS

- Recuperación: Obtienen propiedades y medidas de las geometrías.

- Comparación: Comparan dos geometrías y obtienen información sobre su relación
  espacial.

- Generación: Generan geometrías a partir de otros tipos de datos.

La lista de funciones es muy larga. Para obtener una lista comúnmente presente
en las bases de datos espaciales se puede consultar el estándar 
`OGC SFSQL <http://www.opengeospatial.org/standards/sfs>`_, que es
implementado por PostGIS.

Otros módulos
=============
En la versión 2.0 de |PG| se incorporan dos módulos nuevos dentro del núcleo del producto, el módulo *Raster* y el módulo de *Topología persistente*. En función de si estamos usando una versión de PostgreSQL inferior a la 9.1 o no, instalaremos ambos módulos de una forma u otra.


Instalación de módulos en PostgreSQL inferior a versión 9.1
----------------------------------------------------------- 

Deberemos instalar cada módulo cargando ficheros PL/pgSQL. Lo haremos mediante la herramienta de línea de comandos *psql*

Raster
^^^^^

Este módulo se encarga de gestionar la información raster siguiendo la misma filosofía que el tipo geometry y permitiendo análisis raster y mezclar información raster y vectorial en el análisis.

La instalación de este módulo es similar a la instalación de |PG| realizandose mediante la ejecución de scripts que crean la funcionalidad necesaria para el manejo raster en la base de datos.::

	$ psql -U postgres -f path_rtpostgis.sql -d [nombre_base_datos]
	$ psql -U postgres -f path_raster_comments.sql -d [nombre_base_datos]
	
Topologia persistente
^^^^^^^^^^^^^^^^^^^^

Este es una forma de estructurar la información geográfica de manera diferente al modelo *simple features*. Se instala de manera opcional y no se tratará en este curso por exceder los objetivos del mismo.


Instalación de módulos en PostgreSQL inferior a versión 9.1
----------------------------------------------------------- 

Como sucede al instalar la extensión |PG|, si contamos con |PSQL| 9.1 o superior, basta con que instalemos los siguientes comandos::

	# CREATE EXTENSION postgis_raster;
	# CREATE EXTENSION postgis_topology;


Prácticas
=========
	
	Creé una base de datos espacial que se llame ``curso`` a partir de la plantilla ``template_postgis``. 
	
	Cree un esquema ``gis`` en la base de datos ``curso``.
