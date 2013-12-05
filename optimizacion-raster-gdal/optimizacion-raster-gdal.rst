Optimización de GeoTIFF para su publicación
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

Los datos raster generalmente contienen una gran cantidad de información, mucha más de la que se puede mostrar en una pantalla de una sola vez.
Para que GeoServer pueda gestionar esta gran cantidad de datos de forma eficiente en diferentes situaciones, es necesario prestar atención a su optimización.

Imaginemos que queremos mostrar por pantalla una imagen raster de 10.000 x 10.000 píxeles.
Puesto que la resolución de la pantalla es limitada, sólamente será capaz de mostrar,
como máximo, un 1% de los píxeles totales del raster.

En lugar de leer todo el ráster, debemos incorporar mecanismos en que no sea necesario leer completamente todos los datos cada vez que visualizamos el ráster, sino sólamente a la porción de información que podemos visualizar. Esto se hace de dos modos:

* En situación de "zoom in", es conveniente poder acceder sólo a la porción de imagen que se va a mostrar, descartando el resto.
* En situación de "zoom out", es conveniente disponer de una o varias copias del ráster a resoluciones menores.

El formato interno de los ficheros GeoTIFF se puede procesar y prepararlo para estas dos situaciones.

Para ello utilizaremos las librerías GDAL desde la línea de comandos.
En concreto, veremos las utilidades ``gdalinfo``, ``gdal_translate`` y  ``gdaladdo``.

gdalinfo
........

Proporciona información sobre ficheros ráster.

* Abrir una consola (terminal).
* Acceder al directorio que contiene las imágenes landsat::

    cd pry_workshop_data/raster/landsat/

* Ejecutar ``gdalinfo`` sobre la imagen de 1990::

    gdalinfo landsat_1990.tif

Obtendremos información sobre el tamaño del fichero, el sistema de coordenadas, y la manera en que están codificadas las diferentes bandas internamente.

En concreto, observamos::

  Band 1 Block=3069x1 Type=Byte, ColorInterp=Red
  Band 2 Block=3069x1 Type=Byte, ColorInterp=Green
  Band 3 Block=3069x1 Type=Byte, ColorInterp=Blue

Esto significa que la imagen está guardada en "tiras" de 1px de alto.


gdal_translate
..............

Para optimizar el acceso en situaciones de "zoom in", podemos cambiar esta codificación interna
para que almacene la información en bloques cuadrados de 512x512 píxeles. Ejecutar::

  gdal_translate -co "TILED=YES" -co "BLOCKXSIZE=512" -co "BLOCKYSIZE=512" landsat_1990.tif landsat_1990_tiled.tif

Veamos la información en la nueva imagen::

  gdalinfo landsat_1990_tiled.tif

Ahora obtenemos::

  Band 1 Block=512x512 Type=Byte, ColorInterp=Red
  Band 2 Block=512x512 Type=Byte, ColorInterp=Green
  Band 3 Block=512x512 Type=Byte, ColorInterp=Blue


gdaladdo
........

Para optimizar el acceso en situaciones de "zoom out", podemos añadir, internamente, una serie de imágenes a menor resolución::

  gdaaddo landsat_1990_tiled.tif 2 4 8

Ejecutando de nuevo gdalinfo, observamos que para cada banda aparece esta nueva información::

  Overviews of mask band: 1535x1535, 768x768, 384x384


La ventaja de utilizar la línea de comandos es que se puede crear un *script*  para automatizar
este procesado y aplicarlo masivamente a un gran conjunto de ficheros siempre que sea necesario.


.. note:: Para saber más...

   * `GDAL Utilities <http://www.gdal.org/gdal_utilities.html>`_.

