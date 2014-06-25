fiona y shapely
====================

.. note::

    ================  ================================================
    Fecha              Autores
    ================  ================================================             
    25 Junio 2014       * Fernando González Cortés(fergonco@gmail.com) 
    ================  ================================================  

    ©2014 Fernando González Cortés

    Excepto donde quede reflejado de otra manera, la presente documentación se halla bajo licencia : Creative Commons (Creative Commons - Attribution - Share Alike: http://creativecommons.org/licenses/by-sa/3.0/deed.es)

Ahora que sabemos hacer cosas interesantes con Shapely, vamos a ver cómo podemos utilizar ésta librería con datos leídos por Fiona.

shape y mapping
----------------

Las funciones ``shape`` y ``mapping`` nos permiten convertir desde objetos geométricos de fiona a objetos geométricos de shapely y viceversa.

Ejercicio. Qué hace el siguiente código (shape_mean_area.py)::

	#! /usr/bin/env python
	
	import sys
	import fiona
	
	file = sys.argv[1]
	
	d = fiona.open(file)
	
	total = 0
	for feature in d:
		total = total + shape(feature["geometry"]).area
	
	print total / len(d)
	
	d.close()

Ejemplo de utilización::

	./shape_mean_area.py /home/user/data/north_carolina/shape/urbanarea.shp
	13941122.63


Ejercicio. Crear un shapefile con un buffer alrededor de cada hospital. Podemos usar la siguiente plantilla::

	#! /usr/bin/env python
	
	import sys
	import fiona
	from shapely.geometry import shape, mapping
		
	d = fiona.open("/home/user/data/north_carolina/shape/hospitals.shp")
	
	outputSchema = {
		"geometry": "Polygon",
		"properties": {
			("NAME", d.schema["properties"]["NAME"])
		}
	}
	output = fiona.open("/tmp/hospitals_buffer.shp", "w", driver="ESRI Shapefile", crs=d.crs, schema=outputSchema) 
	
	for feature in d:
		newFeature = {}
		newFeature["geometry"] = ...
		newFeature["properties"] = ...
		output.write(newFeature)
	
	output.close()
	
	d.close()


Solución (shape_write_buffer.py)::

	#! /usr/bin/env python
	
	import sys
	import fiona
	from shapely.geometry import shape, mapping
		
	d = fiona.open("/home/user/data/north_carolina/shape/hospitals.shp")
	
	outputSchema = {
		"geometry": "Polygon",
		"properties": {
			("NAME", d.schema["properties"]["NAME"])
		}
	}
	output = fiona.open("/tmp/hospitals_buffer.shp", "w", driver="ESRI Shapefile", crs=d.crs, schema=outputSchema) 
	
	for feature in d:
		newFeature = {}
		newFeature["geometry"] = mapping(shape(feature["geometry"]).buffer(10000))
		newFeature["properties"] = {
			"NAME" : feature["properties"]["NAME"]
		}
		output.write(newFeature)
	
	output.close()
	
	d.close()

Filtrado espacial
-------------------

Ejercicio: Escribir un fichero que contenga sólo las areas urbanas cuya area es mayor que 13941122.63 (la media)::

	#! /usr/bin/env python
	
	import sys
	import fiona
	from shapely.geometry import shape, mapping
		
	d = fiona.open("/home/user/data/north_carolina/shape/urbanarea.shp")
	
	output = fiona.open("/tmp/big_urban_areas.shp", "w", driver="ESRI Shapefile", crs=d.crs, schema=d.schema) 
	
	for feature in d:
		if shape(feature["geometry"]).area > 13941122.63:
			newFeature = {}
			newFeature["geometry"] = feature["geometry"]
			newFeature["properties"] = feature["properties"]
			output.write(newFeature)
	
	output.close()
	
	d.close()

Ejercicio: Obtener el nombre de los hospitales que están a menos de veinte kilómetros del punto (446845,161978). ¿Es posible utilizar el programa "fiona_projection_selection_write.py"? ¿Qué cambios hay que hacerle?

Solución: Basta con importar las funciones de Shapely que vamos a usar en nuestra expressión::

	from shapely.geometry import shape, mapping
	from shapely.wkt import dumps, loads

y ejecutar la siguiente instrucción::

	./shape_projection_selection_write.py ~/data/north_carolina/shape/hospitals.shp /tmp/nearby_hospitals.shp 'shape(feature["geometry"]).distance(loads("POINT(446845 161978)")) < 20000' 'name as NAME'

Proyecciones espaciales
------------------------------

Modificar fiona_goldsboro_hospitals_write.py para que escriba un buffer de 4km alrededor de cada hospital.

Solución (fiona_goldsboro_hospitals_buffer_write.py)::

	#! /usr/bin/env python
	
	import sys
	import fiona
	from shapely.geometry import shape, mapping
	
	d = fiona.open("/home/user/data/north_carolina/shape/hospitals.shp")
	
	outputSchema = {
	        "geometry": 'Polygon',
	        "properties": {
	                ("NAME", d.schema["properties"]["NAME"])
	        }
	}
	output = fiona.open("/tmp/hospitals_in_goldsboro_buffer.shp", "w", driver="ESRI Shapefile", crs=d.crs, schema=outputSchema)
	
	for feature in d:
	        if feature["properties"]["CITY"]=="Goldsboro":
	                newFeature = {
	                        "geometry" : mapping(shape(feature["geometry"]).buffer(4000)),
	                        "properties" : {
	                                "NAME" : feature["properties"]["NAME"]
	                        }
	                }
	
	                output.write(newFeature)
	
	output.close()
	
	d.close()

Ejercicio:: ¿Es posible utilizar el script "fiona_projection_selection_write.py" para calcular el buffer de los hospitales? ¿Qué cambios hay que hacerle?

Solución: Como se pretende cambiar la geometría y esta no es una propiedad, hay que comprobar el caso específico al analizar los campos::
	
	if field["name"] == "geometry":
		geomField = field
	else:
		fields.append(field)

Luego, si efectivamente hubo una expresión con "geometry" tenemos que poner el tipo específico en el esquema::

	if geomField is not None:
		outputSchema["geometry"] = geomField["type"]

y el valor en la feature::

	if geomField is not None:
		newFeature["geometry"] = eval(field["expression"])

quedando al final el script así (shape_projection_selection_write.py)::

	#! /usr/bin/env python
	
	import sys
	import fiona
	from shapely.geometry import shape, mapping
	from shapely.wkt import dumps, loads
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
	geomField = None
	
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
		
		if field["name"] == "geometry":
			geomField = field
		else:
			fields.append(field)
			# create field in new feature
			outputSchema["properties"][field["name"]] = field["type"]
	
	if geomField is not None:
		outputSchema["geometry"] = geomField["type"]
	
	if len(fields) == 0:
		outputSchema["properties"] = d.schema["properties"]
	
	output = fiona.open(target, "w", driver="ESRI Shapefile", crs=d.crs, schema=outputSchema) 
	
	for feature in d:
		if eval(expression):
			newFeature = {
				"geometry" : feature["geometry"],
				"properties" : {}
			}
	
			if geomField is not None:
				newFeature["geometry"] = eval(geomField["expression"])
	
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

Ejemplo de uso::

	./shape_projection_selection_write.py ~/data/north_carolina/shape/hospitals.shp /tmp/oout.shp 'shape(feature["geometry"]).distance(loads("POINT(446845 161978)")) < 20000' 'geometry:Polygon as mapping(shape(feature["geometry"]).buffer(20000))' 'name as NAME'

¿Qué más?: agrupados
---------------------

Podemos agrupar con este script (shape_group.py)::

	#! /usr/bin/env python
	
	import sys
	import collections
	import fiona
	from shapely.geometry import shape, mapping, MultiPoint, MultiLineString, MultiPolygon
	from shapely.ops import cascaded_union
	
	file = sys.argv[1]
	target = sys.argv[2]
	geometryType = sys.argv[3]
	
	d = fiona.open(file)
	
	outputSchema = {
		"geometry": geometryType,
		"properties": {}
	}
	
	groupField = None
	groupFieldUsed = None
	if len(sys.argv) > 4:
		groupField = sys.argv[4]
		groupFieldUsed = True
		outputSchema["properties"][groupField] = d.schema["properties"][groupField]
	else:
		groupField = "id"
		groupFieldUsed = False
		outputSchema["properties"]["id"] = "int"
		
	output = fiona.open(target, "w", driver="ESRI Shapefile", crs=d.crs, schema=outputSchema) 
	
	classes = {}
	counter = 0
	total = len(d)
	for feature in d:
		print "\rgroup:\t", 50 * counter / total,
		counter = counter + 1
	
		if groupFieldUsed:
			value = feature["properties"][groupField]
		else:
			value = 0
	
		if value in classes:
			class_ = classes[value]
		else:
			class_ = []
			classes[value] = class_
		class_.append(feature)
	
	counter = 0
	total = len(classes)
	for value in classes:
		print "\rgroup:\t", 50 + 50 * counter / total,
		counter = counter + 1
	
		class_ = classes[value]
		classGeometries = [shape(feature["geometry"]) for feature in class_]
		unionResult = cascaded_union(classGeometries)
	
		# hack because cascaded_union may not give a collection
		if not isinstance(unionResult, collections.Iterable):
			if geometryType == "MultiPoint":
				unionResult = MultiPoint([unionResult])
			elif geometryType == "MultiLineString":
				unionResult = MultiLineString([unionResult])
			elif geometryType == "MultiPolygon":
				unionResult = MultiPolygon([unionResult])
		feature = {
			"geometry" : mapping(unionResult),
			"properties" : {
				groupField : value
			}
		}
		output.write(feature)
	
	d.close()
	output.close()


y usando estas instrucciones::

	./shape_group.py /home/user/data/north_carolina/shape/boundary_county.shp /tmp/groupedByName.shp MultiPolygon NAME
	./shape_group.py /home/user/data/north_carolina/shape/boundary_county.shp /tmp/bounds.shp MultiPolygon

¿Y?: Joins
------------

También podemos hacer Joins. Para ello extraemos el código que parsea los parámetros a un módulo "schema_parser"::

	def getField(fieldExpression, schema):
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
			fieldType = schema["properties"][fieldEvalExpression]
			computed = False
		return {
			"name" : fieldName,
			"type" : fieldType,
			"expression" : fieldEvalExpression,
			"computed" : computed
		}
		
	def getFields(args, schema):
		fields = []
		for fieldExpression in args:
			fields.append(getField(fieldExpression, schema))
	
		return fields		
	
	def getGeometryField(fields):
		return next((field for field in fields if field["name"] == "geometry"), None)
	
	def getAlphanumericFields(fields):
		return [field for field in fields if field["name"] != "geometry"]

Y con el siguiente script (shape_join.py)::

	#! /usr/bin/env python
	
	import schema_parser
	import sys
	import time
	import fiona
	from shapely.geometry import shape, mapping
	from shapely.ops import cascaded_union
	from rtree import index
	
	class SequentialScan:
	
		def preLoop(self):
			pass
	
		def featuresFor(self, outerFeature, inner):
			return inner
	
	class SpatialIndexScan:
	
		innerMemory = []
		idx = index.Index()
	
		def preLoop(self, inner):
			# Load inner in memory for random access
			for innerFeature in inner:
				self.innerMemory.append(innerFeature)
				bounds = shape(innerFeature["geometry"]).bounds
				self.idx.insert(len(self.innerMemory) - 1, bounds)
	
		def featuresFor(self, outerFeature, inner):
			ret = []
			# Query the index
			queryResult = self.idx.intersection(shape(outerFeature["geometry"]).bounds)
			for innerFeatureIndex in queryResult:
				ret.append(self.innerMemory[innerFeatureIndex])
	
			return ret
	
	outerPath = sys.argv[1]
	innerPath = sys.argv[2]
	target = sys.argv[3]
	scanType = sys.argv[4]
	joinCondition = sys.argv[5]
	
	start = time.time()
	
	outer = fiona.open(outerPath)
	inner = fiona.open(innerPath)
	
	if scanType == "sequential":
		innerScan = SequentialScan()
	elif scanType == "spatial-index":
		innerScan = SpatialIndexScan()
	
	innerScan.preLoop(inner)
	
	combinedSchema = dict(outer.schema.items() + inner.schema.items())
	fields = schema_parser.getFields(sys.argv[6:], combinedSchema)
	if len(fields) == 0:
		print "field expressions missing"
		sys.exit(-1)
	else:
		outputSchema = {
			"properties" : {}
		}
		geomField = schema_parser.getGeometryField(fields)
		
		if geomField is None:
			print "geometry field expression missing"
			sys.exit(-1)
		else:
			outputSchema["geometry"] = geomField["type"]
		
		alphanumericFields = schema_parser.getAlphanumericFields(fields)
		for field in alphanumericFields:
			outputSchema["properties"][field["name"]] = field["type"]
	
	output = fiona.open(target, "w", driver="ESRI Shapefile", crs=outer.crs, schema=outputSchema)
	counter = 0
	total = len(outer)
	for outerFeature in outer:
		print "\rjoin:\t\t", 100 * counter / total,
		counter = counter + 1
	
		scannedFeatures = innerScan.featuresFor(outerFeature, inner)
		for innerFeature in scannedFeatures:
			if eval(joinCondition):
				newFeature = {
					"geometry" : eval(geomField["expression"]),
					"properties" : {}
				}
				for field in alphanumericFields:
					# field evaluation
					value = eval(field["expression"])
	
					# create field in new feature
					newFeature["properties"][field["name"]] = value
	
				output.write(newFeature)
	output.close()
	inner.close()
	outer.close()
	
	end = time.time()
	print end - start, "seconds"
	
Podemos hacer joins. Por ejemplo podemos cortar la malla que creamos con el contorno de north_carolina, calculado con un agrupado::

	./shape_join.py /tmp/bounds.shp /tmp/grid.shp /tmp/cutted_grid.shp spatial-index 'shape(outerFeature["geometry"]).intersects(shape(innerFeature["geometry"]))' 'geometry:Polygon as mapping(shape(outerFeature["geometry"]).intersection(shape(innerFeature["geometry"])))' 'gid:int as innerFeature["properties"]["gid"]'

Ahora podemos asignar a cada hospital el código de la celda de la malla recién calculada::

	./shape_join.py /tmp/cutted_grid.shp ~/data/north_carolina/shape/hospitals.shp /tmp/hospital_gridcode.shp spatial-index 'shape(outerFeature["geometry"]).contains(shape(innerFeature["geometry"]))' 'geometry:Point as innerFeature["geometry"]' 'gid:int as outerFeature["properties"]["gid"]'

Usando el script de agrupado, podemos agrupar por celda::

	./shape_group.py /tmp/hospital_gridcode.shp /tmp/hospital_group_by_cell.shp MultiPoint gid

para obtener el número de hospitales por celda::

	./shape_process.py /tmp/hospital_group_by_cell.shp /tmp/num_hospitals_cell.shp True 'gid as gid' 'count:int as len(list(shape(feature["geometry"])))'

Por último podemos hacer un join con la malla inicial, por el código de malla y obtener el número de hospitales por superficie::

	./shape_join.py /tmp/num_hospitals_cell.shp /tmp/cutted_grid.shp /tmp/density.shp sequential 'outerFeature["properties"]["gid"] == innerFeature["properties"]["gid"]' 'geometry:Polygon as innerFeature["geometry"]' 'gid:int as outerFeature["properties"]["gid"]' 'density:float as outerFeature["properties"]["count"] / shape(innerFeature["geometry"]).area'

Resumiendo, aquí tenemos el proceso para el cálculo::

	./fiona_grid.py ~/data/north_carolina/shape/hospitals.shp 50000 /tmp/grid.shp
	./shape_group.py /home/user/data/north_carolina/shape/boundary_county.shp /tmp/bounds.shp MultiPolygon
	./shape_join.py /tmp/bounds.shp /tmp/grid.shp /tmp/cutted_grid.shp spatial-index 'shape(outerFeature["geometry"]).intersects(shape(innerFeature["geometry"]))' 'geometry:Polygon as mapping(shape(outerFeature["geometry"]).intersection(shape(innerFeature["geometry"])))' 'gid:int as innerFeature["properties"]["gid"]'
	./shape_join.py /tmp/cutted_grid.shp ~/data/north_carolina/shape/hospitals.shp /tmp/hospital_gridcode.shp spatial-index 'shape(outerFeature["geometry"]).contains(shape(innerFeature["geometry"]))' 'geometry:Point as innerFeature["geometry"]' 'gid:int as outerFeature["properties"]["gid"]'
	./shape_group.py /tmp/hospital_gridcode.shp /tmp/hospital_group_by_cell.shp MultiPoint gid
	./shape_process.py /tmp/hospital_group_by_cell.shp /tmp/num_hospitals_cell.shp True 'gid as gid' 'count:int as len(list(shape(feature["geometry"])))'
	./shape_join.py /tmp/num_hospitals_cell.shp /tmp/cutted_grid.shp /tmp/density.shp sequential 'outerFeature["properties"]["gid"] == innerFeature["properties"]["gid"]' 'geometry:Polygon as innerFeature["geometry"]' 'gid:int as outerFeature["properties"]["gid"]' 'density:float as outerFeature["properties"]["count"] / shape(innerFeature["geometry"]).area'
