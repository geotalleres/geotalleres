fiona
=========

.. note::

    ================  ================================================
    Fecha              Autores
    ================  ================================================             
    25 Junio 2014       * Fernando González Cortés(fergonco@gmail.com) 
    ================  ================================================  

    ©2014 Fernando González Cortés

    Excepto donde quede reflejado de otra manera, la presente documentación se halla bajo licencia : Creative Commons (Creative Commons - Attribution - Share Alike: http://creativecommons.org/licenses/by-sa/3.0/deed.es)

Lectura de una juego de datos
-------------------------------

Ejercicio: Hacer script que muestra información de un fichero que se le pasa como parámetro::

	#! /usr/bin/env python
	
	import sys
	import fiona
	
	file = sys.argv[1]
	
	d = fiona.open(file)
	
	print "crs:", d.crs
	print "bounds:", d.bounds
	print "driver:", d.driver
	print "encoding:", d.encoding
	print "schema", d.schema
	
	d.close()

Lectura de objetos
---------------------

Es posible iterar secuencialmente por la fuente de datos con un bucle::

	for i in d:
		print i

Fiona ofrece los contenidos del shapefile como objetos python. Invocando el método ``next`` podemos obtener el primer registro de una fuente de datos::

	{
	    'geometry': {
	        'type': 'Point',
	        'coordinates': (914347.8748615, 249079.07840056275, 0.0)
	    },
	    'type': 'Feature',
	    'id': '159',
	    'properties': OrderedDict([
	        (u'cat', 160.0),
	        (u'OBJECTID', 160.0),
	        (u'AREA', 0.0),
	        (u'PERIMETER', 0.0),
	        (u'HLS_', 160.0),
	        (u'HLS_ID', 160.0),
	        (u'NAME', u'TheOuterBanksHospital(licensepending)'),
	        (u'ADDRESS', u'4800SCroatanHwy'),
	        (u'CITY', u'NagsHead'),
	        (u'ZIP', u'27959'),
	        (u'COUNTY', u'Dare'),
	        (u'PHONE', None),
	        (u'CANCER', u'?'),
	        (u'POLYGONID', 0.0),
	        (u'SCALE', 1.0),
	        (u'ANGLE', 0.0)
	    ])
	}

Ejercicio: hacer script que muestre todos los valores de un campo que se pasa como parámetro (fiona_show_field.py)::

	#! /usr/bin/env python
	
	import sys
	import fiona
	
	file = sys.argv[1]
	fieldName = sys.argv[2]
	
	d = fiona.open(file)
	
	for feature in d:
		print feature["properties"][fieldName]
	
	
	d.close()

Ejemplo::

	./fiona_show_field.py ~/data/north_carolina/shape/hospitals.shp NAME

Operaciones con campos
------------------------

Llevando el ejemplo anterior un paso más allá, podemos hacer un programita que en lugar de mostrar los campos por la consola lo que haga sea modificar las features eliminando todos los campos menos el seleccionado (fiona_projection.py)::

	#! /usr/bin/env python
	
	import sys
	import fiona
	
	file = sys.argv[1]
	fieldName = sys.argv[2]
	
	d = fiona.open(file)
	
	for feature in d:
		for property in feature["properties"]:
			if property != fieldName:
				del feature["properties"][property]
	
		print feature
	
	d.close()

Ejemplo::

	./fiona_projection.py ~/data/north_carolina/shape/hospitals.shp NAME

Y generalizando todavía más, podemos obtener una serie de expresiones como parámetros que serán los nuevos campos (fiona_projection_ops.py)::

	#! /usr/bin/env python
	
	import sys
	import fiona
	import re
	
	file = sys.argv[1]
	
	d = fiona.open(file)
	
	for feature in d:
		newFeature = {
			"geometry" : feature["geometry"],
			"properties" : {}
		}
		for i in range(2, len(sys.argv)):
			fieldExpression = sys.argv[i]
	
			# field parsing
			asIndex = fieldExpression.find(" as ")
			fieldName = fieldExpression[:asIndex].strip()
			evalExpression = fieldExpression[asIndex+4:]

			# field evaluation
			value = None
			if re.match("^[A-Za-z0-9_-]*$", evalExpression):
				# Just field reference
				value = feature["properties"][evalExpression]
			else:
				# Expression
				value = eval(evalExpression)

			# create field in new feature
			newFeature["properties"][fieldName] = value
	
		print newFeature
	
	d.close()

Ejemplo::

	./fiona_projection_ops.py ~/data/north_carolina/shape/hospitals.shp 'ingol as feature["properties"]["CITY"]=="Goldsboro"' 'city as CITY' 'name as NAME'

Filtrado
---------

Ejercicio: Hacer un script que muestre sólo los objetos hospital que están en la ciudad de "Goldsboro" (fiona_goldsboro_hospitals.py)::

	#! /usr/bin/env python
	
	import sys
	import fiona
		
	d = fiona.open("/home/user/data/north_carolina/shape/hospitals.shp")
	
	for feature in d:
		if feature["properties"]["CITY"]=="Goldsboro":
			print feature["properties"]["NAME"]
	
	d.close()


Incluso se podría extender el último ejemplo del punto anterior y pasar la expresión como parámetro también (fiona_projection_selection.py)::

	#! /usr/bin/env python
	
	import sys
	import fiona
	import re
	
	file = sys.argv[1]
	expression = sys.argv[2]
	
	d = fiona.open(file)
	
	for feature in d:
		if eval(expression):
			newFeature = {
				"geometry" : feature["geometry"],
				"properties" : {}
			}
			
			# If there are no field ops include all
			if len(sys.argv) == 3:
				newFeature["properties"] = feature["properties"]
			else:
				for i in range(3, len(sys.argv)):
					fieldExpression = sys.argv[i]
			
					# field parsing
					asIndex = fieldExpression.find(" as ")
					fieldName = fieldExpression[:asIndex].strip()
					evalExpression = fieldExpression[asIndex+4:]
			
					# field evaluation
					value = None
					if re.match("^[A-Za-z0-9_-]*$", evalExpression):
						# Just field reference
						value = feature["properties"][evalExpression]
					else:
						# Expression
						value = eval(evalExpression)
			
					# create field in new feature
					newFeature["properties"][fieldName] = value
		
			print newFeature
	
	d.close()



Ejemplo::

	./fiona_projection_selection.py ~/data/north_carolina/shape/hospitals.shp 'feature["properties"]["CITY"]=="Goldsboro"'

	./fiona_projection_selection.py ~/data/north_carolina/shape/hospitals.shp 'feature["properties"]["CITY"]=="Goldsboro"' 'name as NAME' 'city as CITY'

Es obvio que sería interesante escribir el resultado como otro shapefile, ¿no? Vemos primero cómo crear un shapefile desde cero.

Creación de un shapefile desde cero
------------------------------------

El siguiente código crea un fichero con objetos de tipo punto cuyas coordenadas se leen como parámetro (fiona_create_points.py)::

	#! /usr/bin/env python
	
	import sys
	import fiona
	from fiona.crs import from_epsg
	
	target = sys.argv[1]
	epsg = sys.argv[2]
	
	outputSchema = {
		"geometry": "Point",
		"properties": {
			("gid", "str")
		}
	}
	
	output = fiona.open(target, "w", driver="ESRI Shapefile", crs=from_epsg(epsg), schema=outputSchema) 
	
	id = 0
	for i in range(3, len(sys.argv), 2):
		x = float(sys.argv[i])
		y = float(sys.argv[i+1])
		feature = {
			"geometry" : {
				"coordinates" : (x, y),
				"type" : "Point"
			},
			"properties" : {
				"gid" : id
			}
		}
		id = id + 1
		output.write(feature)
	
	output.close()

Ejercicio: Crear un programa que tome un shapefile de entrada y un tamaño y cree una malla que cubra el shapefile original y cuya celda tiene el tamaño especificado. Se puede usar la plantilla siguiente::

	#! /usr/bin/env python
	
	import sys
	import fiona
	
	file = sys.argv[1]
	size = int(sys.argv[2])
	target = sys.argv[3]
	
	d = fiona.open(file)
	bounds = d.bounds
	crs = d.crs
	d.close();
	
	outputSchema = {...}
	
	output = fiona.open(target, "w", driver="ESRI Shapefile", crs=crs, schema=outputSchema) 
	
	id = 0
	x = bounds[0]
	while x < bounds[2]:
		y = bounds[1]
		while y < bounds[3]:
			feature = {...}
			id = id + 1
			output.write(feature)
	
			y = y + size
	
		x = x + size
	
	output.close()

Solución (fiona_grid.py)::

	#! /usr/bin/env python
	
	import sys
	import fiona
	
	file = sys.argv[1]
	size = int(sys.argv[2])
	target = sys.argv[3]
	
	d = fiona.open(file)
	bounds = d.bounds
	crs = d.crs
	d.close();
	
	outputSchema = {
		"geometry": "Polygon",
		"properties": {
			("gid", "str")
		}
	}
	
	output = fiona.open(target, "w", driver="ESRI Shapefile", crs=crs, schema=outputSchema) 
	
	id = 0
	x = bounds[0]
	while x < bounds[2]:
		y = bounds[1]
		while y < bounds[3]:
			feature = {
				"geometry" : {
					"coordinates" : [[
						(x, y),
						(x + size, y),
						(x + size, y + size),
						(x, y + size),
						(x, y)
					]],
					"type" : "Polygon"
				},
				"properties" : {
					"gid" : id
				}
			}
			id = id + 1
			output.write(feature)
	
			y = y + size
	
		x = x + size
	
	output.close()


Ejemplo::

	./fiona_grid.py ~/data/north_carolina/shape/hospitals.shp 50000 /tmp/grid.shp

Modificación y escritura de un shapefile
------------------------------------------

Ejercicio: tomar el ejemplo "fiona_goldsboro_hospitals" y escribir el resultado en otro fichero (fiona_goldsboro_hospitals_write.py)::

	#! /usr/bin/env python
	
	import sys
	import fiona
		
	d = fiona.open("/home/user/data/north_carolina/shape/hospitals.shp")
	
	outputSchema = {
		"geometry": d.schema["geometry"],
		"properties": {
			("NAME", d.schema["properties"]["NAME"])
		}
	}
	output = fiona.open("/tmp/hospitals_in_goldsboro.shp", "w", driver="ESRI Shapefile", crs=d.crs, schema=outputSchema) 
	
	for feature in d:
		if feature["properties"]["CITY"]=="Goldsboro":
	                newFeature = {
	                        "geometry" : feature["geometry"],
	                        "properties" : {
	                                "NAME" : feature["properties"]["NAME"]
	                        }
	                }

			output.write(feature)
	
	output.close()
	
	d.close()

Por último, vamos a generalizar el último ejemplo del punto de filtrado para pasarle como segundo parámetro el fichero de salida donde se quiere escribir (fiona_projection_selection_write.py)::

	#! /usr/bin/env python
	
	import sys
	import fiona
	
	file = sys.argv[1]
	target = sys.argv[2]
	expression = sys.argv[3]
	
	d = fiona.open(file)
	
	outputSchema = {
		"geometry": d.schema["geometry"],
		"properties": {
		}
	}
	
	fields = []
	
	for i in range(4, len(sys.argv)):
		fieldExpression = sys.argv[i]
	
		# field parsing
		asIndex = fieldExpression.find(" as ")
		fieldNameAndType = fieldExpression[:asIndex].strip()
		fieldEvalExpression = fieldExpression[asIndex+4:]
		colonIndex = fieldNameAndType.find(":")
		if colonIndex != -1:
			fieldName = fieldNameAndType[:colonIndex]
			fieldType = fieldNameAndType[colonIndex+1:]
			computed = True
		else:
			fieldName = fieldNameAndType
			fieldType = d.schema["properties"][fieldEvalExpression]
			computed = False
		field = {
			"name" : fieldName,
			"type" : fieldType,
			"expression" : fieldEvalExpression,
			"computed" : computed
		}
		fields.append(field)
	
		# create field in new feature
		outputSchema["properties"][field["name"]] = field["type"]
	
	output = fiona.open(target, "w", driver="ESRI Shapefile", crs=d.crs, schema=outputSchema) 
	
	for feature in d:
		if eval(expression):
			newFeature = {
				"geometry" : feature["geometry"],
				"properties" : {}
			}
			
			# If there are no field ops include all
			if len(fields) == 0:
				newFeature["properties"] = feature["properties"]
			else:
				for field in fields:
					# field evaluation
					value = None
					if field["computed"]:
						# Expression
						value = eval(field["expression"])
					else:
						# Just field reference
						value = feature["properties"][field["expression"]]
			
					# create field in new feature
					newFeature["properties"][field["name"]] = value
	
			output.write(newFeature)
	
	d.close()
	output.close()

Ejemplo::

	./fiona_projection_selection_write.py ~/data/north_carolina/shape/hospitals.shp /tmp/hospital_projection_and_filter.shp 'feature["properties"]["CITY"]=="Goldsboro"' 'name as NAME' 'city as CITY' 'shorname:str as feature["properties"]["NAME"][:3]'



