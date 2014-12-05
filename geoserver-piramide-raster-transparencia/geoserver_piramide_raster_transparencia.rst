GeoServer: Creación de una pirámide raster con transparencia
============================================================

.. note::

	=================  ================================================
	Fecha              Autores
	=================  ================================================             
	3 Diciembre 2014   * Víctor González (victor.gonzalez@geomati.co)
	=================  ================================================	

	Excepto donde quede reflejado de otra manera, la presente documentación se halla bajo licencia : Creative Commons (Creative Commons - Attribution - Share Alike: http://creativecommons.org/licenses/by-sa/3.0/deed.es)

Contexto
--------

Para este taller partimos de un conjunto de GeoTIFFs de tres bandas (RGB) sin *overviews*, sin *tiles* y sin valores *no data*.

Estos GeoTIFFs cubren solo parte de la extensión total, por lo que la pirámide deberá contener imágenes
transparentes para aquellas zonas donde no haya imágenes raster.

Además, los propios GeoTIFFs utilizan el color blanco ((255,255,255) = #FFFFFF) para representar las zonas donde no hay cobertura.

Nuestro objetivo es publicar en GeoServer una pirámide que muestre nuestras imágenes raster acompañadas de transparencia
allí donde no haya cobertura o la imagen sea blanca.

Preparación de las imágenes
---------------------------

En primer lugar debemos saber que la pirámide generará imágenes negras para aquellas zonas donde no haya cobertura.
Por lo tanto, es necesario que en nuestras imágenes cambiemos el color que representa zonas sin cobertura de blanco a negro.

En caso de que dicho color sea uniforme, podemos utilizar GDAL (``gdalwarp``) para cambiarlo a negro::

    $ for i in $(ls imagenes_originales/*.tif); do gdalwarp -srcnodata 255 -dstnodata 0 $i imagenes_procesadas/$(basename $i); done

Si el color no es uniforme este proceso no nos servirá y no nos quedará otra opción que editar las imágenes a mano (Photoshop, GIMP, ...).


Construcción de la pirámide
---------------------------

Para construir la pirámide utilizaremos también GDAL (``gdal_retile``)::

    $ gdal_retile.py -v -r bilinear -levels 8 -ps 2048 2048 -s_srs "EPSG:23030" -of GTiff -co "TILED=YES" -co "COMPRESS=DEFLATE" -targetDir piramide imagenes_procesadas/*.tif

Los parámetros más importantes que hemos utilizado en este caso son:

* *-levels 8*: Número de niveles de la pirámide. Es importante crear un número suficiente de niveles de tal forma que al menos el nivel superior tenga una única imagen.
* *-co TILED=YES*: Creación de *tiles* internos en el GeoTIFF.
* *-co COMPRESS=DEFLATE*: Compresión de las imágenes. Es **muy importante** que la compresión no tenga pérdida, ya que de lo contrario los
  límites entre la ortofoto y el fondo negro (dentro de un mismo tile) quedarían difuminados, dando lugar a puntos de color negro cuando se
  aplique la transparencia con GeoServer. 


Publicación en GeoServer
------------------------

Una vez hemos creado nuestra pirámide, únicamente queda publicarla con GeoServer. 

Para ello necesitamos una extensión adicional que se llama *ImagePyramid* y que se puede descargar
de la `página de GeoServer <http://geoserver.org/release/stable/>`_.

* En la página "Almacenes de datos", hacer clic en "Agregar nuevo almacén".
* Escoger *ImagePyramid* bajo *Origenes de datos raster*.
* En el formulario, establecer el nombre y el espacio de trabajo y utilizar el directorio que contiene la pirámide (*piramide*, según los comandos mostrados más arriba) en *URL* (siempre con el prefijo *file:*).
* Clicar en "Guardar".

En función del tamaño de la pirámide, GeoServer puede tardar más o menos en añadir la pirámide, llegando a necesitar 
bastantes minutos para pirámides de varias decenas de GB.

Una vez se ha añadido el almacén de datos, clicar en *Publicación* para publicar.

Se presentará una página para rellenar los datos sobre la capa.

En este caso, únicamente deberemos establecer el valor para *InputTransparentColor* para decirle a GeoServer qué
color debe tomar como transparente. En nuestro caso, ese color es el negro, por lo que deberemos poner el valor *000000*.

* Clicar en "Guardar".

Es importante tener en cuenta que para que GeoServer nos devuelva las imágenes con transparencia, en la petición WMS debemos utilizar un formato de imagen que soporte la transparencia (``FORMAT=image/png``) y especificar de manera explícita que queremos la imagen con transparencia (``TRANSPARENT=true``)

