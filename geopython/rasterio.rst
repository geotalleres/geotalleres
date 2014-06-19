rasterio
=========

Lectura de raster y obtención de información
-----------------------------------------------

El siguiente programa python muestra la información de un raster que se pasa como parámetro::

	#! /usr/bin/env python
	
	import sys
	import rasterio
	
	file = sys.argv[1]
	
	d = rasterio.open(file)
	
	print "filas, columnas:", d.height, d.width
	print "bandas:", d.count
	print "crs:", d.crs
	print "crs_wkt:", d.crs_wkt
	print "bounds:", d.bounds
	print "driver:", d.driver
	print "nodatavalues:", d.nodatavals
	print "transform", d.get_transform()
	
	d.close()

Ejemplos::

	raster_info.py ~/data/north_carolina/rast_geotiff/elevation.tif
	raster_info.py /usr/share/osgearth/data/world.tif

Truco: En modo interactivo ejecutar ``dir(d)`` para ver las opciones

Lectura en una coordenada
----------------------------

Una propiedad ``affine`` en rasterio... que no he encontrado. Está en el master, pero no está todavía en la versión que hay instalada. Con lo cual esto no se puede hacer:

https://github.com/mapbox/rasterio/blob/master/docs/datasets.rst#attributes

Es un poquito más complicado:

Con ``t.get_transform`` podemos obtener una lista con los coeficientes de la matriz de transformacion. Pero para que sea una matriz de transformación correcta hay que añadirle una fila::

	t = d.get_transform() + [1, 0, 0]

También tenemos que mover la primera columna al final de la matriz, para lo cual utilizaremos numpy. Numpy lo utilizaremos también después para multiplicar la coordenada por la matriz de transformación::

	affine = numpy.mat([t[:3], t[3:6], t[6:]])

Cambiamos la primera columna al final::

	affine = affine[:,numpy.array([1, 2, 0])]

Y por último multipicamos un vector coordenada (con un 1 en la z) y obtenemos la coordenada de la esquina superior izquierda de nuestro raster::

	affine * numpy.mat("0;0;1")
	affine * numpy.mat("{0};{1};1".format(d.width, d.height))
	affine * numpy.mat("{0};{1};1".format(d.width/2, d.height/2))

Podemos también hacer la transformación al contrario, a partir de unas coordenadas (en el CRS de la imagen) podemos obtener el pixel del raster que contiene dicho punto. Para ello utilizaremos la inversa de la matriz para hacer la transformación (.I en numpy)::

	affine.I * numpy.mat("0;0;1")

Una vez resuelto el problema técnico podemos empaquetar lo anterior como funciones en un módulo util::

	#! /usr/bin/env python
	
	import numpy
	import rasterio
	
	def getAffine(raster):
		t = raster.get_transform() + [1, 0, 0]
		affine = numpy.mat([t[:3], t[3:6], t[6:]])
		affine = affine[:,numpy.array([1, 2, 0])]
		return affine
	
	def toPixel(x, y, raster):
		ret = getAffine(raster).I * numpy.mat("{0};{1};1".format(x, y))
		return (int(ret.item(0)), int(ret.item(1)))
	
	def toMap(col, row, raster):
		ret = getAffine(raster) * numpy.mat("{0};{1};1".format(col, row))
		return (ret.item(0), ret.item(1))
 

y hacer un programita que nos devuelva la posición::

	#! /usr/bin/env python
	
	import sys
	import utils
	import rasterio
	
	file = sys.argv[1]
	x = sys.argv[2]
	y = sys.argv[3]
	
	d = rasterio.open(file)
	
	pixel = utils.toPixel(x, y, d)
	print "Pixel: ", pixel
	
	for i in range(1,d.count+1):
		band = d.read_band(i)
		print band[pixel[1], pixel[0]]
	
	d.close()

Ejemplos::

	raster_coordinate.py ~/data/raster/bluemarble.tif -60 -50
	Pixel:  (1440, 1680)
	26
	69
	125

	raster_coordinate.py ~/data/north_carolina/rast_geotiff/elevation.tif 633519 223743
	Pixel:  (351, 475)
	129.621

Escribir un raster
--------------------

La escritura del raster sería similar a la lectura. Lo único que hay que tener en cuenta es que las lectura y escritura de bandas se hace a través de estructuras numpy::

	w = rasterio.open("/tmp/out.tif", "w", driver='GTiff',dtype=rasterio.uint8,count=1,width=2, height=2)
	w.write_band(1, numpy.mat([[128, 0], [0, 255]], numpy.uint8))
	w.close()

Operaciones con bandas
------------------------

Podemos aprovechar que las bandas son almacenadas en una estructura de numpy para realizar operaciones entre bandas fácilmente. En el siguiente ejemplo estaríamos creando una máscara sobre un modelo digital de terreno::

	d = rasterio.open("~/data/north_carolina/rast_geotiff/elevation.tif")
	band = d.read_band(1)
	mask = band < 100

que luego podríamos utilizar para multiplicar por la propia banda y así dejar a 0 los valores que no cumplen la condición::

	result = mask * band

Generalizando, podríamos hacer un programita que leyera un fichero de entrada y una expresión y creara un raster manteniendo los pixeles que cumplen dicha expresión y dejando los demás a cero::

	#! /usr/bin/env python
	
	import sys
	import rasterio
	from rasterio import features
	
	file = sys.argv[1]
	outputPath = sys.argv[2]
	expression = sys.argv[3]
	
	d = rasterio.open(file)
	
	band = d.read_band(1)
	mask = eval(expression)
	result = mask * band
	
	output = rasterio.open(
		outputPath, 'w',
		driver='GTiff',
		dtype=rasterio.float32,
		transform=d.transform,
		nodata=0,
		count=1,width=d.width,height=d.height)
	output.write_band(1, result)
	output.close();
	
	d.close()

Ejemplos::










