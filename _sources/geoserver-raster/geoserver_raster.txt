GeoServer: Publicación de datos raster
===============================================

.. note::

	=================  ================================================
	Fecha              Autores
	=================  ================================================             
	1 Diciembre 2012    * Oscar Fonts (oscar.fonts@geomati.co)
	24 Junio 2013		* Fernando González (fernando.gonzalez@fao.org)
	=================  ================================================	

	©2013 FAO Forestry 
	
	Excepto donde quede reflejado de otra manera, la presente documentación se halla bajo licencia : Creative Commons (Creative Commons - Attribution - Share Alike: http://creativecommons.org/licenses/by-sa/3.0/deed.es)

Almacen de datos GeoTIFF
------------------------

* En la página "Almacenes de datos", hacer clic en "Agregar nuevo almacén".

Los datos raster para el taller se encuentran en formato GeoTIFF.
A diferencia de los datos vectoriales, no tenemos un almacén de tipo
"Directory of spatial files" para datos raster, así que deberemos crear
un almacén distinto para cada una de las capas.

Comencemos con el primer fichero: Una clasificación de coberturas forestales.

* Escoger "GeoTIFF" bajo "Origenes de datos raster".
* En el formulario, utilizar "unredd" como espacio de nombres, y "forest_cover" como nombre de la capa. Opcionalmente, agregar una descripción.
* Clicar en "Buscar..." en "Parámetros de conexión", y navegar hasta el fichero :file:`/home/unredd/Desktop/pry_workshop_data/raster/forest_cover_1990.tif`.
* Clicar en "Guardar".

Se presentará una nueva página con una *"lista"* de las capas a publicar: Sólo aparece un elemento, "forest_cover_1990", puesto que el almacén sólo contempla un fichero GeoTIFF.


Publicación de una capa GeoTIFF
-------------------------------

Desde esta página,

* Clicar en "Publicación" para publicar.

Se presentará una página para rellenar los datos sobre la capa, similar a la que ya vimos para la creación de capas vectoriales.

En esta ocasión, GeoServer ha detectado automáticamente el sistema de referencia de coordenadas de la capa GeoTIFF.
A diferencia de las capas vectoriales, no hará falta declarar manualmente el SRS y los encuadres, que ya tienen la información necesaria.

* Clicar en "Guardar".

* Previsualizar la nueva capa "forest_cover_1990" en OpenLayers.

En la misma página de previsualización, clicando sobre cada una de estas áreas, obtenemos una información numérica, ``PALETTE_INDEX``. Se
distinguen cinco valores distintos: Área sin datos (amarillo), Bosque Atlántico (verde), Bosque Chaqueño (azul), Superficie no 
forestal (magenta), y Masas de Agua (rojo). Esta combinación de colores de alto contraste permite distinguir claramente
cada clase, pero obviamente no es la que mejor se asocia visualmente con el significado de cada categoría.

Simbolización Raster
--------------------

Podemos asociar cada uno de los valores a un nuevo color que represente mejor cada clase:

=====  ======================  =========================
Valor  Clase                   Nuevo color deseado
=====  ======================  =========================
0      Área sin datos          Transparente
1      Bosque Atlántico        Verde oscuro (#005700)
2      Bosque Chaqueño         Verde claro (#01E038)
3      Superficie no forestal  Amarillo pálido (#FFFF9C)
4      Masa de Agua            Azul (#3938FE)
=====  ======================  =========================

A partir de esta tabla, crearemos un estilo SLD para la capa ráster.

* En la página "Estilos", "Agregar un nuevo estilo".
* Asignarle el nombre "forest_mask".
* Dejar el "Espacio de nombres" en blanco.

En lugar de escribir el SLD desde cero, podemos utilizar la opción "Copiar de un estilo existente".

* Utilizar "Copiar de un estilo existente" para cargar el estilo "raster".
* Sustituir el contenido de ``RasterSymbolizer`` por este otro:

.. code-block:: xml

    <ColorMap type="values">
        <ColorMapEntry quantity="1" label="Bosque Atlantico" color="#005700" opacity="1"/>
        <ColorMapEntry quantity="2" label="Bosque Chaco" color="#01E038" opacity="1"/>
        <ColorMapEntry quantity="3" label="Zona no boscosa" color="#FFFF9C" opacity="1"/>
        <ColorMapEntry quantity="4" label="Masa de agua" color="#3938FE" opacity="1"/>
    </ColorMap>

Este mapa de color asigna, a cada posible valor, un color y una etiqueta personalizada. El valor "0" (Área sin datos), al no aparecer en el mapa, se representará como transparente.

* "Validar" el nuevo SLD, "Enviar", y asignar como estilo por defecto a la capa "forest_cover_1990" (en la pestaña "Publicación").
* Previsualizar de nuevo la capa:


Publicación de un mosaico Raster temporal
-----------------------------------------

Vamos a publicar una capa ráster con una imagen satelital RGB que pueda usarse como capa base de referencia.

En lugar de un solo fichero GeoTIFF, en esta ocasión disponemos de cuatro imagenes correspondientes a cuatro años distintos: 1990, 2000, 2005 y 2010.

Vamos a publicar las cuatro imágenes en como una sola capa, componiendo un "mosaico temporal".

* En la página "Almacenes de datos", hacer clic en "Agregar nuevo almacén".
* Escoger "ImageMosaic" bajo "Origenes de datos raster".
* Utilizaremos "landsat" como nombre para el almacen de datos.
* Este tipo de almacen no dispone de la utilidad "Buscar..." para indicar la localización de los datos, así que tendremos que escribirla a mano::

    file:///home/unredd/Desktop/pry_workshop_data/raster/landsat/

* Clicar en "Guardar", y luego en "publicación" en la página siguiente.
* Ir a la pestaña "dimensions", para habilitar la dimensión "Time". Escoger "List" como opción de presentación.
* "Guardar" y previsualizar la capa.


Cómo se define la dimensión temporal
....................................

Si abrimos los contenidos de :file:`pry_workshop_data/raster/landsat`, observamos los siguientes ficheros GeoTIFF, que contienen las imágenes para cada instante:

:file:``landsat_1990.tif``
:file:``landsat_2000.tif``
:file:``landsat_2005.tif``
:file:``landsat_2010.tif``

Vemos que el nombre de todos los ficheros comienza por las mismas 8 letras ``landsat_``, y que terminan con cuatro cifras indicando el año. De algún modo debemos indicar a GeoServer cómo están formados estos nombres, para que pueda extraer la información temporal a partir de ellos.

Esto se realiza mediante una serie de ficheros de `properties`:

  :file:`timeregex.properties`, cuyo contenido es::

    regex=[0-9]{4}

  Indica que la dimensión temporal está formada por 4 cifras.

  :file:`indexer.properties`, cuyo contenido es::

    TimeAttribute=time
    Schema=the_geom:Polygon,location:String,time:java.util.Date
    PropertyCollectors=TimestampFileNameExtractorSPI[timeregex](time)

  Indica que la marca temporal será obtenida aplicando `timeregex`, y se almacenará en un índice como atributo `time`.

.. note:: Para saber más...

   * Documentación técnica NFMS: `GeoServer > Advanced Raster data preparation and configuration > Adding an Image Mosaic to GeoServer <http://nfms4redd.org/doc/html/geoserver/raster_data/mosaic.html>`_
   * `Página sobre expresiones regulares <http://www.regular-expressions.info/>`_.

Consumo del servicio temporal
------------------------------

Ahora que tenemos una capa temporal publicada podemos pasar a formar a consumirla con algún cliente estándar. Desafortunadamente gvSIG no es capaz de consumir la
capa y QGIS no tiene soporte para la dimensión temporal. Sin embargo, es posible obtener las imágenes en los distintos instantes símplemente
utilizando el navegador web. Para ello, las llamadas que se hacen deben incluir el parámetro *TIME*, como en los siguientes ejemplos::

	http://168.202.48.83/geoserver/ows?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetMap&BBOX=-13.910569,12.090411,5.395932,32.233551&
		TIME=2000&CRS=EPSG:4326&WIDTH=923&HEIGHT=885&LAYERS=capacitacion:test&STYLES=&FORMAT=image/png&DPI=96&TRANSPARENT=TRUE

	http://168.202.48.83/geoserver/ows?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetMap&BBOX=-13.910569,12.090411,5.395932,32.233551&
		TIME=2005&CRS=EPSG:4326&WIDTH=923&HEIGHT=885&LAYERS=capacitacion:test&STYLES=&FORMAT=image/png&DPI=96&TRANSPARENT=TRUE

	http://168.202.48.83/geoserver/ows?SERVICE=WMS&VERSION=1.3.0&REQUEST=GetMap&BBOX=-13.910569,12.090411,5.395932,32.233551&
		TIME=2010&CRS=EPSG:4326&WIDTH=923&HEIGHT=885&LAYERS=capacitacion:test&STYLES=&FORMAT=image/png&DPI=96&TRANSPARENT=TRUE

.. note:: Para saber más...

   * Documentación técnica NFMS: `GeoServer > Advanced Raster data preparation and configuration > Processing with GDAL <http://nfms4redd.org/doc/html/geoserver/raster_data/processing.html>`_

