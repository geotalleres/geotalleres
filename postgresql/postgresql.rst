.. |PG|  replace:: *PostgreSQL*

PostgreSQL
============

.. note::

	=================  ====================================================
	Fecha              Autores
	=================  ====================================================           
	1 Septiembre 2012   * Fernando González (fernando.gonzalez@geomati.co)
	                    * Micho García (micho.garcia@geomati.co)
	24 Junio 2013       * Fernando González (fernando.gonzalez@fao.org)
	                    * Ramiro Mata (rmata@zonageo.com.ar)
	                    * Leandro Roncoroni (lronco@zonageo.com.ar)
	=================  ====================================================

	©2012 Fernando González Cortés y Miguel García Coya
	
	Excepto donde quede reflejado de otra manera, la presente documentación se halla bajo licencia : Creative Commons (Creative Commons - Attribution - Share Alike: http://creativecommons.org/licenses/by-sa/3.0/deed.es)

	Los contenidos de este punto son inicialmente traducciones de la documentación oficial de PostgreSQL que han sido extendidos posteriormente.

.. note::
	
	PostgreSQL is Copyright © 1996-2006 by the PostgreSQL Global Development Group and is distributed under the terms of the license of the University of California below.
	
	Postgres95 is Copyright © 1994-5 by the Regents of the University of California.
	
	Permission to use, copy, modify, and distribute this software and its documentation for any purpose, without fee, and without a written agreement
	is hereby granted, provided that the above copyright notice and this paragraph and the following two paragraphs appear in all copies.
	
	IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCI-
	DENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS
	DOCUMENTATION, EVEN IF THE UNIVERSITY OF CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
	
	THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IM-
	PLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE SOFTWARE PROVIDED HERE-
	UNDER IS ON AN “AS-IS” BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATIONS TO PROVIDE MAINTENANCE,
	SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

Introducción
-------------

El objetivo de este tutorial sobre |PG| es que el usuario sea capaz
de crear y eliminar bases de datos y acceder a ellas para la manipulación de los
datos.

Por esto, los puntos siguientes están pensados para dar una introducción
simple a |PG|, a los conceptos básicos sobre bases de datos relacionales
y al lenguaje SQL. No se requiere experiencia en
sistemas UNIX ni en programación. 

Tras el tutorial, es posible continuar el aprendizaje leyendo la
documentación oficial del proyecto, en inglés, en la que se puede encontrar
abundante información sobre el lenguaje SQL, el desarrollo de
aplicaciones para PostgreSQL y la configuración y administración de servidores.

Arquitectura cliente/servidor
-------------------------------

Al igual que el resto de componentes instalados, |PG| utiliza un modelo
cliente/servidor, ya explicado en la introducción.

Las aplicaciones cliente pueden ser de naturaleza muy diversa: una herramienta 
orientada a texto (psql), una aplicación gráfica (pgAdmin3), un servidor web que
accede a la base de datos para mostrar las páginas web, o una herramienta de
mantenimiento de bases de datos especializadas. Algunas aplicaciones de cliente
se suministran con la distribución |PG| mientras que otras son desarrolladas por los usuarios. 

Creación de una base de datos
--------------------------------

El primer paso para trabajar con |PG| es crear una base de datos. Para ello es necesario ejecutar 
como usuario *postgres* el comando *createdb*::

	$ sudo su postgres
	$ createdb mibd

Si no se tiene acceso físico al servidor o se prefiere acceder de forma remota
es necesario utilizar un cliente SSH. La siguiente instrución::

	$ ssh geo@190.109.197.226

conecta al servidor 190.109.197.226 con el usuario *geo*.

Ejercicio: Conectar al sistema desde Windows y crear una base de datos.

Generalmente el mejor modo de mantener la información en la base de datos es utilizando
un usuario distinto a *postgres*, que sólo debería usarse para tareas administrativas. Es
posible incluso crear más de un usuario con diferentes derechos (SELECT, INSERT, UPDATE,
DELETE) para tener un entorno más seguro. Sin embargo, esto queda fuera del ámbito
de este tutorial y se conectará siempre con el usuario *postgres*.

Acceso a una base de datos
-----------------------------

Una vez la base de datos ha sido creada es posible utilizar un cliente para conectar a ella. Existen varias maneras:

- psql: el programa de terminal interactivo de PostgreSQL que permite introducir de forma interactiva, editar y ejecutar comandos SQL. Veremos más adelante qué es SQL. Es el que utilizaremos.

- una herramienta existente con interfaz gráfica, como pgAdmin, que veremos brevemente. 

- una aplicación personalizada desarrollada con algún lenguaje para el que haya un driver de acceso. Esta posibilidad no se trata en esta formación. 

Para conectar con pgAdmin se deberá seleccionar el menu File > Add Server y registrar el nuevo servidor con su dirección IP y el puerto en el que está escuchando (5432 por defecto). También habrá que indicar el nombre de usuario con el que se desea hacer la conexión. 

Una vez se tiene configurada una entrada para la base de datos en pgAdmin, es posible 
conectar a dicho servidor haciendo doble click en dicha entrada. 

.. image :: _static/training_postgresql_connect_pgadmin.png

Una vez creada, es posible selecionar la nueva base de datos y mostrar el árbol de
objetos que contiene. Se puede ver el esquema "public" que no contiene ningún elemento.

Para seguir interactuando con la base de datos abriremos una ventana SQL clicando sobre
el siguiente icono:

.. image :: _static/training_postgresql_open_sql.png

Que abrirá una ventana que permite enviar comandos SQL al servidor de base de datos. Probemos
con los siguientes comandos::

	SELECT version ();
	SELECT current_date;
	SELECT 2 + 2;

psql
-----

También podemos conectar a la base de datos con psql. Podemos conectar con psql desde cualquier máquina que tenga una versión de psql compatible con el servidor. El propio servidor tiene dicho programa instalado y es obviamente compatible por lo que la mejor opción es acceder al servidor::
	
	$ ssh geo@190.109.197.226

Es posible especificar al comando ``psql`` la base de datos a la que se quiere acceder, el usuario con el que se quiere realizar el acceso y la instrucción que se quiere ejecutar en el sistema. Los valores concretos utilizados dependerán de la configuración concreta del servidor. En adelante usaremos el usuario de base de datos ``postgres`` y la base de datos ``geoserverdata``.

.. note: El usuario con más permisos es ``postgres`` pero su uso representa un riesgo ya que tiene permisos para leer y escribir en todas las bases de datos. En su lugar es preferible hacer uso de una cuenta creada específicamente para la base de datos que se quiere acceder y que no tenga acceso a otras bases de datos. Sin embargo, en este caso se usa ``postgres`` por simplicidad.  

La siguiente instrucción invoca la función ``version``::

	$ psql -U postgres -d test_database -c "SELECT version ()"
	                                                  version                                                   
	------------------------------------------------------------------------------------------------------------
	 PostgreSQL 9.1.5 on x86_64-unknown-linux-gnu, compiled by gcc (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3, 64-bit
	(1 row)
		
Otros ejemplos::

	$ psql -U postgres -d test_database -c "SELECT current_date"
	    date    
	------------
	 2012-09-11
	(1 row)
	
	$ psql -U postgres -d test_database -c "SELECT 2 + 2"
	 ?column? 
	----------
	        4
	(1 row)

Todos estos comandos SQL pueden ser ejecutados usando otro parámetro del programa ``psql``. La opción -f permite especificar un fichero que contiene instrucciones SQL. Así, por ejemplo sería posible crear un fichero en ``/tmp/mi_script.sql`` con el siguiente contenido::

	SELECT version ();
	SELECT current_date;
	SELECT 2 + 2;

Y ejecutarlo con la instrucción::

	$ psql -U geoserver -d geoserverdata -f /tmp/mi_script.sql
	
	                                               version                                                
	------------------------------------------------------------------------------------------------------
	 PostgreSQL 9.1.11 on i686-pc-linux-gnu, compiled by gcc (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3, 32-bit
	(1 row)
	
	    date    
	------------
	 2014-02-11
	(1 row)
	
	 ?column? 
	----------
	        4
	(1 row)
	
Como se puede observar, se ejecutan todos los comandos del script sql uno detrás de otro.

Consola psql interactiva
-------------------------

También es posible, y conveniente para tareas de mayor complejidad, entrar al modo interactivo de ``psql``. Para ello podemos omitir el parámetro -c::

	$ psql -U postgres -d test_database
	
o conectar sin especificar la base de datos y usar el comando \\c dentro de *psql*::

	$ psql -U postgres 
	=# \c test_database
	You are now connected to database "mibd" as user "postgres".

.. note :: Dado que psql es un programa en línea de comandos tenemos que diferenciar en la documentación las instrucciones que se deben de ejecutar en la línea de comandos del sistema operativo y la línea de comandos de psql. Las primeras, como se comentó en la introducción a Linux, vienen precedidas del símbolo del dólar ($) mientras que para las últimas utilizaremos un par de símbolos: =#. Es necesario prestar atención a este detalle durante el resto de la documentación.

En el resto de la documentación se seguirán enviando comandos SQL desde la línea de comandos del sistema operativo ($) usando el parámetro -c o el parámetro -f, como especificado anteriormente. Sin embargo, se especifica a continuación una mínima referencia sobre los comandos que se pueden ejecutar en la línea de comandos de postgresql (=#)

Para obtener el listado de las bases de datos existentes en el sistema, usar el comando
\\l::

	=# \l
	
Y para listar tablas del esquema por defecto de la base de datos actual (*public*)::

	=# \dt

Si queremos listar las tablas que hay en otro esquema es posible utilizar la siguiente sintaxis::
  
	=# \dt gis.*  

Por último, para obtener información sobre cualquier objeto de la base de datos es posible
utilizar el comando \\d::

	=# \d gis.categorias
	
Se puede añadir un + para obtener información más detallada::

	=# \d+ gis.categorias
	 
Ayuda de psql
..............
	
Para una completa referencia de los comandos disponibles es posible usar el comando \\?::

	=# \?

que nos abrirá la ayuda. El formato de la ayuda es el mismo que el del comando *less*.

Cargando información desde shapefile: shp2pgsql
------------------------------------------------

El parámetro -f es extremadamente útil cuando queremos usar PostgreSQL junto con su extensión espacial PostGIS para la carga de datos desde shapefile. Para ello contamos con ``shp2pgsql``, que es capaz de generar un script SQL a partir de un shapefile que al ejecutar en PostgreSQL generará una tabla espacial con los mismos datos del shapefile.

La sintaxis básica es sencilla::

	shp2pgsql <shapefile> <nombre_de_tabla_a_crear>
	
Por ejemplo::

	$ shp2pgsql provincias.shp provincia

El comando anterior realmente muestra por pantalla el script, lo cual no es muy útil y además tarda mucho tiempo (con Ctrl+C es posible cancelar la ejecución en la mayoría de los casos). Para que realmente sea útil tenemos que almacenar los datos en un fichero que luego podamos pasar a psql con el parámetro -f. Esto lo podemos hacer mediante redireccionando la salida estándar a un fichero temporal::

	$ shp2pgsql provincias.shp provincias > /tmp/provincias.sql

Es posible que durante este proceso obtengamos un error similar a éste::

	Unable to convert data value to UTF-8 (iconv reports "Invalid or incomplete multibyte or wide character"). Current encoding is "UTF-8". Try "LATIN1" (Western European), or one of the values described at http://www.postgresql.org/docs/current/static/multibyte.html.
	
lo cual quiere decir que la codificación utilizada para almacenar los textos en el fichero .dbf no es UTF-8, que es la que espera el programa ``shp2pgsql`` por defecto. También nos sugiere que intentemos LATIN1. Para decirle al programa qué codificacion utilizamos, podemos especificar el parámetro -W::

	$ shp2pgsql -W LATIN1 provincias.shp provincias > /tmp/provincias.sql

Y si nuestros datos están en LATIN1 se generará el script sin ningún problema.

A continuación no tenemos más que cargar el fichero recién generado con psql::

	$ psql -U postgres -d geoserverdata -f /tmp/provincias.sql
	
Tras la ejecución podemos ver con cualquier sistema GIS que soporte conexiones PostGIS 2.0 (como QGis) que se ha creado una tabla en PostreSQL/PostGIS con los mismos datos que contenía el shapefile.

El siguiente aspecto que tenemos que tener en cuenta, es que el sistema de referencia de coordenadas (CRS) no está especificado. Por ejemplo, ejecutando esta instrucción::

	$ psql -U postgres -d geoserverdata -c "select * from geometry_columns"
	
	 f_table_catalog | f_table_schema |      f_table_name       | f_geometry_column | coord_dimension | srid |      type       
	-----------------+----------------+-------------------------+-------------------+-----------------+------+-----------------
	 geoserverdata   | public         | provincias              | geom              |               2 |    0 | MULTIPOLYGON

podemos observar que la tabla recién creada tiene un campo srid, que indica el código EPSG del sistema de coordenadas utilizado, con valor igual a 0. Para evitar esto es posible utilizar el parámetro -s de ``shp2pgsql``::

	$ shp2pgsql -s 4326 provincias.shp provincias > /tmp/provincias.sql

que establecerá que nuestros datos están en EPSG:4326 (o el CRS que se especifique).

Por último, es recomendable crear nuestros datos en un esquema distinto de ``public`` para facilitar las copias de seguridad y las actualizaciones de PostGIS, por motivos que no se tratan en esta documentación::

	$ psql -U postgres -d geoserverdata -c "create schema gis"
	CREATE SCHEMA
	$ shp2pgsql -s 4326 provincias.shp gis.provincias > /tmp/provincias.sql
	
Incluso es posible cargar en PostgreSQL el fichero resultante con una única línea, sólo enlazando la salida de ``shp2pgsql`` con la entrada de ``psql`` mediante una tubería de linux "|"::

	$ shp2pgsql -s 4326 provincias.shp gis.provincias | psql -U postgres -d geoserverdata

Por ejemplo los siguientes comandos cargan una serie de datos en PostGIS, en la base de datos ``geoserver``::

	$ psql -U postgres -d geoserver -c "create schema gis"
	$ shp2pgsql -s 4326 -W LATIN1 /tmp/datos/ARG_adm0.shp gis.admin0 | psql -U postgres -d geoserverdata
	$ shp2pgsql -s 4326 -W LATIN1 /tmp/datos/ARG_adm1.shp gis.admin1 | psql -U postgres -d geoserverdata
	$ shp2pgsql -s 4326 -W LATIN1 /tmp/datos/ARG_adm2.shp gis.admin2 | psql -U postgres -d geoserverdata
	$ shp2pgsql -s 4326 -W LATIN1 /tmp/datos/ARG_rails.shp gis.ferrovia | psql -U postgres -d geoserverdata
	$ shp2pgsql -s 4326 -W LATIN1 /tmp/datos/ARG_roads.shp gis.vias | psql -U postgres -d geoserverdata
	$ shp2pgsql -s 4326 -W LATIN1 /tmp/datos/ARG_water_areas_dcw.shp gis.zonas_agua | psql -U postgres -d geoserverdata
	$ shp2pgsql -s 4326 -W LATIN1 /tmp/datos/ARG_water_lines_dcw.shp gis.lineas_agua | psql -U postgres -d geoserverdata
	
Nótese que todos estos pasos se pueden simplificar en sólo dos, que cargarían todos los shapefiles de un directorio::

	$ psql -U postgres -d geoserver -c "create schema gis"
	$ for i in `ls /tmp/datos/*.shp`; do shp2pgsql -s 4326 $i gis.${i%.shp} | psql -U postgres -d geoserverdata; done

El siguiente ejemplo crea una base de datos llamada ``analisis`` y dentro de ella un esquema llamado ``gis``. Luego se instala la extensión PostGIS y por último se cargan en la base de datos todos los shapefiles existentes en el directorio ``Escritorio/datos/analisis``::

	$ psql -U postgres -c "create database analisis"
	$ psql -U postgres -d analisis -c "create schema gis"
	$ psql -U postgres -d analisis -c "create extension postgis"
	$ for i in `ls /tmp/datos/analisis/*.shp`; do shp2pgsql -s 25830 $i gis.${i%.shp} | psql -U postgres -d analisis; done

.. _postgresql-backup:

Creación de copias de seguridad
----------------------------------

Un aspecto importante a la hora de administrar un servidor de base de datos es la creación de copias de seguridad.

Para hacer y restaurar la copia de seguridad se utilizan los comandos ``pg_dump`` y ``pg_restore`` en la línea de comandos del sistema operativo. El comando ``pg_dump`` tiene la siguiente sintaxis::

	 pg_dump <options> <database>

Entre las opciones más interesantes están:

* username: nombre del usuario con el que conectar a la base de datos para realizar la copia: --username=geo
* password: clave para conectar a la base de datos
* host: dirección del servidor de base de datos. Se puede omitir si es la máquina desde la cual se lanza el comando: --host=192.168.2.107
* schema: esquema que se quiere copiar. Si no se especifica se copiarán todos los esquemas.
* format: formato de la copia. Para obtener un formato compatible con ``pg_restore`` es necesario especificar "c": --format=c
* file: fichero donde queremos guardar la copia de seguridad: --file=/tmp/db.backup

Así, si accedemos a la base de datos "geoserverdata" con el usuario "geoserver" y quisiéramos hacer una copia del esquema "gis" podríamos ejecutar la siguiente instrucción desde la línea de comandos del servidor de base de datos::

	$ pg_dump --username=geoserver --format=c --schema=gis --file=/tmp/gis.backup geoserverdata

Dicho comando creará un fichero en ``/tmp/gis.backup`` con la copia de todos los datos que hay en el esquema "gis".

Para recuperar la copia se puede utilizar el comando ``pg_restore``::

	$ pg_restore --username=geoserver --dbname=geoserverdata /tmp/gis.backup 

Si el esquema existe, el comando ``pg_restore`` dará un error por lo que si queremos reemplazar los contenidos del esquema deberemos renombrar el esquema primero con la siguiente instrucción:: 

	$ psql --username=geoserver --dbname=geoserverdata --command="alter schema gis rename to gis2"

Una vez la copia de seguridad ha sido recuperada de forma satisfactoria es posible eliminar el esquema renombrado::

	$ psql --username=geoserver --dbname=geoserverdata --command="drop schema gis2 cascade"

.. warning :: Para que todo este proceso se de sin problemas, es importante que los datos estén en un esquema distinto de "public", ya que algunas extensiones, como PostGIS, instalan tablas y funciones en dicho esquema y al hacer el backup estaremos incluyendo también estos objetos que luego no dejarán recuperar la copia.

.. warning :: También es muy importante guardar los ficheros con la copia de seguridad en una máquina distinta al servidor de bases de datos, ya que en caso de que haya algún problema con dicha máquina se pueden perder también las copias. 


Más información
----------------

La página web de |PG| se puede consultar aquí [1]_. En ella hay abundante información en inglés [2]_,
así como listas de correo en español [3]_.

También se puede descargar un curso de PostGIS de bastante difusión [4]_.

Referencias
------------

.. [1] http://www.postgresql.org
.. [2] http://www.postgresql.org/docs/9.2/static/index.html
.. [3] http://archives.postgresql.org/pgsql-es-ayuda/
.. [4] http://blog.lookingformaps.com/2012/11/publicada-documentacion-del-curso-bases.html