.. |CDB| replace:: CartoDB
.. |OG| replace:: OpenGeo

*******************************************
Productos basados en PostGIS: CartoDB, OpenGeo
*******************************************

CartoDB
=======


CartoDB es un *SaaS*: http://en.wikipedia.org/wiki/Software_as_a_service. Básicamente, es un PostGIS que sirve datos desde una plataforma cloud: http://cartodb.com/

Se pueden cargar los datos en tablas a través de una interfaz web. También se pueden realizar consultas y visualizar los datos utilizando un mapa base. Todo esto sin necesidad de programar una sola línea de código.

Cuenta con un servicio básico gratuito para almacenar hasta 5 MB en 5 tablas. Si se quiere más espacio, hay varios planes de pago: http://cartodb.com/pricing/

Vamos a ver los usos básicos de CartoDB, y un uso avanzado


CartoDB básico
--------------

Una vez registrados y autenticados en la página, vemos la opción de crear una nueva tabla, a la derecha:


	.. image:: _images/cartodb_new_table.png
		:scale: 50 %


Para crear una nueva tabla, se nos pide que elijamos un fichero de nuestro disco duro, de una URL o directamente conectemos con nuestro Dropbox. Las extensiones de archivo permitidas son: csv, xls, xlsx, zip, kml, geojson, json, ods, kmz, gpx, tar, gz, tgz, osm, bz2, tif, tiff, txt, sql (sí, también permite ráster)

	.. image:: _images/cartodb_import_table.png
		:scale: 50 %

Asimismo, vemos que se nos da la opción de importar datasets ya predefinidos, con lo cuál tendremos una tabla creada con dos clics de ratón. 

	.. image:: _images/cartodb_table_created.png
		:scale: 50 %

Y lo más importante... ¡un visualizador ya listo, sin hacer nada más! Incluso podemos cambiar nuestro mapa base.

	.. image:: _images/cartodb_map_view.png
		:scale: 50 %


Pulsando la opción *Visualize* (arriba a la derecha) podemos darle nombre a nuestro mapa y compartirlo con quien queramos.

Por supuesto, podemos ejecutar consultas sobre nuestros datos, y quedarnos solo con los registros que queramos

	.. image:: _images/cartodb_query.png
		:scale: 50 %

En resumen: podemos manipular nuestros datos y visualizarlos al momento, ¡sin necesidad de montar una infraestructura WMS!


CartoDB avanzado: Torque
----------------------------

Torque es una librería construída sobre CartoDB que permite la visualización de datos temporales como si se tratara de una animación. Para elllo, utiliza *HTML5* para la renderización y el concepto de *datacube* para modelar los datos.

Un *datacube*, de manera resumida y visual, es esto:

	.. image:: _images/cartodb_data_cubes.png
		:scale: 50 %

Es decir: un conjunto de datos espaciales (geometrías) ubicados en una determinada posición en un momento temporal. 

El *datacube* en si, se crea con SQL:
	
	.. image:: _images/cartodb_data_cubes_sql.png
		:scale: 50 %

Cualquier usuario de CartoDB puede probar esta funcionalidad, si tiene datos espaciados temporalmente. Algunos ejemplos:

	* Seguimiento del movimiento de un coche en tiempo real: http://cartodb.github.io/torque/examples/car.html
	* Un velero de la Royal Navy durante la WWI. Los datos geográficos fueron tomados del libro de registro del capitán: http://www.theguardian.com/news/datablog/interactive/2012/oct/01/first-world-war-royal-navy-ships-mapped (o si se prefiere jugar con los parámetros: http://cartodb.github.io/torque/)


OpenGEO
=======

Es un stack completo de software libre. Desde el almacenamiento en base de datos hasta su visualización. Consta de::

	* PostGIS: para almacenar los datos
	* GeoServer: para servirlos a través de Internet
	* GeoWebCache: caché de teselas para acelerar el servicio
	* GeoExplorer: aplicación web para editar y publicar mapas.

Se puede descargar o ejecutar desde la nube.
