
*********************
Relaciones espaciales
*********************

Introducción
============

Estos métodos lo que hacen es verificar el cumplimiento de determinados predicados geográficos entre dos geometrías distintas. Los predicados geográficos toman dos geometrías como argumento, y devuelven un valor booleano que indica si ambas geometrías cumplen o no una determinada relación espacial. Las principales relaciones espaciales contempladas son equals, disjoint, intersects, touches, crosses, within, contains, overlaps. 

Matriz DE-9IM
=============

Estas relaciones o predicados son descritas por la matriz DE-9IM (Dimensionally Extended 9 intersection Matrix), que es una construcción matemática de la rama de la topología.

	.. image:: _images/matriz.png
		:scale: 50 %

Figura: Mátriz DE-9IM de dos figuras geométricas dadas. Fuente: wikipedia en inglés [7] (http://en.wikipedia.org/wiki/DE-9IM)

Predicados espaciales
=====================

	.. image:: _images/mas_predicados_espaciales.png
		:scale: 50 %
		
Figura: Ejemplos de predicados espaciales. Fuente: wikipedia. http://en.wikipedia.org/wiki/File:TopologicSpatialRelarions2.png

	.. image:: _images/touches.png
		:scale: 50 %

Figura: Ejemplos de la relación “Touch” (toca). Fuente: “OpenGIS® Implementation Standard for Geographic information - Simple feature access - Part 1: Common architecture”

	.. image:: _images/crosses.png
		:scale: 50 %

Figura: Ejemplos de la relación “Crosses” (cruza). Fuente: “OpenGIS® Implementation Standard for Geographic information - Simple feature access - Part 1: Common architecture”

	.. image:: _images/within.png	
		:scale: 50 %
	
Figura: Ejemplos de la relación “Within” (contenido en). Fuente: “OpenGIS® Implementation Standard for Geographic information - Simple feature access - Part 1: Common architecture”

	.. image:: _images/overlaps.png
		:scale: 50 %

Figura: Ejemplos de la relación “Overlaps” (solapa). Fuente: “OpenGIS® Implementation Standard for Geographic information - Simple feature access - Part 1: Common architecture”

Los principales métodos de la clase Geometry para chequear predicados espaciales entra la geometría en cuestión y otra proporcionada como parámetro son:

	* **Equals (A, B)**: Las geometrías son iguales desde un punto de vista topológico
	* **Disjoint (A, B)**: No tienen ningún punto en común, las geometrías son disjuntas
	* **Intersects (A, B)**:Tienen por lo menos un punto en común. Es el inverso de Disjoint
	* **Touches (A, B)**: Las geometrías tendrán por lo menos un punto en común del contorno, pero no puntos interiores
	* **Crosses (A, B)**: Comparten parte, pero no todos los puntos interiores, y la dimensión de la intersección es menor que la dimensión de al menos una de las geometrías
	* **Contains (A, B)**: Ningún punto de B está en el exterior de A. Al menos un punto del interior de B está en el interior de A
	* **Within (A, B)**: Es el inverso de Contains. Within(B, A) = Contains (A, B)
	* **Overlaps (A, B)**: Las geometrías comparten parte pero no todos los puntos y la intersección tiene la misma dimensión que las geometrías.
	* **Covers (A, B)**: Ningún punto de B está en el exterior de A. B está contenido en A.
	* **CoveredBy (A, B)**: Es el inverso de Covers. CoveredBy(A, B) = Covers(B, A)

ST_Equals
---------
::

	ST_Equals(geometry A, geometry B), comprueba que dos geometrías sean espacialmente iguales.

ST_Equals devuelve TRUE si dos geometrías del mismo tipo tienen identicas coordenadas x,y. 

Ejemplo
^^^^^^^
::
	
	# SELECT name, geom, ST_AsText(geom)
	FROM points
	WHERE name = 'Casa de Piedra';

::

		name   	|                        geom                        |          st_astext 
	----------------+----------------------------------------------------+------------------------------
 	 Casa de Piedra | 0101000020E6100000A6CC727E2F8052C0F9AF62A70EA81240 | POINT(-74.0028988 4.6641184)

Si usamos el valor obtenido en ``geom`` y consultamos a la base de datos::

	# SELECT name
	FROM points
	WHERE ST_Equals(geom, '0101000020E6100000A6CC727E2F8052C0F9AF62A70EA81240');

::
     	name      
	---------------
	Casa de Piedra

ST_Intersects, ST_Disjoint, ST_Crosses y ST_Overlaps
----------------------------------------------------
Comprueban la relación entre los interiores de las geometrías.

ST_Intersects
^^^^^^^^^^^^^
::

	ST_Intersects(geometry A, geometry B) 
	
Devuelve TRUE si la intersección no es un resultado vacio. 

ST_Disjoint
^^^^^^^^^^^
::

	ST_Disjoint(geometry A , geometry B)
	
Es el inverso de ST_Intersects. indica que dos geometrías no tienen ningún punto en común. Es menos eficiente que ST_Intersects ya que esta no está indexada. Se recomienda comprobar ``NOT ST_Intersects``

ST_Crosses
^^^^^^^^^^
::

	ST_Crosses(geometry A, geometry B)
	
Se cumple esta relación si el resultado de la intesección de dos geometrías es de dimensión menor que la mayor de las dimensiones de las dos geometrías y además esta intersección está en el interior de ambas.

ST_Overlap
^^^^^^^^^^
::

	ST_Overlaps(geometry A, geometry B) 
	
compara dos geometrías de la misma dimensión y devuelve TRUE si su intersección resulta una geometría diferente de ambas pero de la misma dimensión

Ejemplo
"""""""
Dada la siguiente imagen

	.. image:: _images/intersection.png
		:scale: 50 %

Vemos que el poligono **16** intersecta a los poligonos **8** y **15**::

	# SELECT gid 
	FROM barrios_de_bogota 
	WHERE ST_Intersects(geom, (select geom from barrios_de_bogota where gid = 16))
	AND gid != 16
	
::

 	gid 
	-----
   	8
  	15


ST_Touches
^^^^^^^^^^
::

	ST_Touches(geometry A, geometry B)
	
Devuelte TRUE si cualquiera de los contornos de las geometrías se cruzan o si sólo uno de los interiores de la geometría se cruza el contorno del otro.
	
ST_Within y ST_Contains
^^^^^^^^^^^^^^^^^^^^^^^
::

	ST_Within(geometry A , geometry B)
	
es TRUE si la geometría A está completamente dentro de la geometría B. Es el inverso de ST_Contains

::

	ST_Contains(geometry A, geometry B)
	
Devuelve TRUE si la geometría B está contenida completamente en la geometría A

Ejemplo
"""""""

¿En que barrio se encuentra el Museo del 20 de Julio?

::

	#SELECT b.name from barrios_de_bogota b, points p 
	WHERE ST_Contains(b.geom, p.geom) and
	p.name = 'Museo del 20 de Julio'
	
::

	     name      
	---------------
 	San Cristóbal
	

ST_Distance and ST_DWithin
^^^^^^^^^^^^^^^^^^^^^^^^^^
::

	ST_Distance(geometry A, geometry B)
	
Calcula la menor distancia entre dos geometrías.

::

	ST_DWithin(geometry A, geometry B, distance)
	
Permite calcular si dos objetos se encuentran a una distancia dada uno del otro.

Ejemplo
"""""""
Encontrar los puntos de interes a como maximo 2km de la oficina de turismo de **Bogotanisimo.com**::
	
	# SELECT name
	FROM points
	WHERE 
		name is not null and
		name != 'Bogotanisimo.com' and
		ST_DWithin(
		     ST_Transform(geom, 21818),
		     (SELECT ST_Transform(geom, 21818)
			FROM points
			WHERE name='Bogotanisimo.com'),
		     2000
		   );
	
::

          name          
	------------------------
 	panaderia Los Hornitos


Hemos aplicado una transformación geométrica a otro sistema de referencia (EPSG:21818), para poder medir distancias en metros. Nuestros datos originales usan grados en lugar de metros para las coordenadas.

Otra manera de realizar la misma operación pero sin necesidad de transformar los datos a un sistema de referencia diferente para poder usar metros es usar el tipo de datos **geography** de PostGIS::

	#SELECT name
	FROM points
	WHERE 
		name is not null and
		name != 'Bogotanisimo.com' and
		ST_DWithin(
		     geography(geom),
		     (SELECT geography(geom)
			FROM points
			WHERE name='Bogotanisimo.com'),
		     2000
		   );


El resultado es el mismo que el de la consulta anterior. 

El uso del tipo **geography** para medir distancias, no obstante, es el recomendado cuando se trata de medir la distancia entre dos puntos de la Tierra muy distantes entre sí. 

En estos casos, un sistema de refencia plano no es una buena elección. Estos sistemas suelen dar buenos resultados a la hora de mostrar mapas en planos, porque conservan las direcciones, pero las distancias y áreas pueden estar bastante distorsionadas con respecto a la realidad. Es necesario utilizar un sistema de referencia espacial que conserve las distancias, teniendo en cuenta la curvatura terrestre. El tipo **geography** de PostGIS es un buen ejemplo, puesto que realiza los cálculos sobre una esfera, y no sobre un esferoide. 

JOINS espaciales
================
Permite combinar información de diferentes tablas usando relaciones espaciales como clave dentro del JOIN. Es una de las caracteristicas más potentes de las bases de datos espaciales. 

Veamos un ejemplo: Los nombres de los barrios por los que cruza el rio Bogotá

::

	# SELECT b.name 
	FROM barrios_de_bogota b JOIN waterways w 
	ON ST_Crosses(b.geom, w.geom)
	WHERE w.name = 'Rio Bogotá'

::

      	name      
	----------------
 	Bosa
 	Ciudad Kennedy
 	Fontibón
 	Engativá
 	Suba


Cualquier función que permita crear relaciones TRUE/FALSE entre dos tablas puede ser usada para manejar un JOIN espacial, pero comunmente las más usadas son:

	* ST_Intersects
	* ST_Contains
	* ST_DWithin
	
JOIN y GROUP BY
---------------

El uso de las relaciones espaciales junto con funciones de agregacion, como **group by**, permite operaciones muy poderosas con nuestros datos. Veamos un ejemplo sencillo: El numero de escuelas que hay en cada uno de los barrios de Bogota::

	#select b.name, count(p.type) as hospitals from barrios_de_bogota b join
	points p on st_contains(b.geom, p.geom) where p.type = 'hospital' 
	group by b.name order by hospitals desc

::

	name      | schools 
  ----------------+---------
   Suba           |       8
   Usaquén        |       5
   Los Mártires   |       3
   Teusaquillo    |       3
   Antonio Nariño |       3
   Tunjuelito     |       2
   Ciudad Kennedy |       2
   Engativá       |       1
   Fontibón       |       1
   Santa Fé       |       1
   Barrios Unidos |       1
   Ciudad Bolívar |       1
 


1. La clausula JOIN crea una tabla virtual que incluye los datos de los barrios y de los puntos de interés
2. WHERE filtra la tabla virtual solo para las columnas en las que el punto de interés es un hospital
3. Las filas resultantes son agrupadas por el nombre del barrio y rellenadas con la función de agregación count().

Prácticas
========


Comprueba si estas geometrías son iguales: LINESTRING(0 0, 10 0) Y MULTILINESTRING((10 0, 5 0),(0 0, 5 0)).

Represente como texto el valor de la geometría del barrio 'Ciudad Bolivar'.

¿En que barrio se encuentra la Plaza de Las Americas? (Pista: buscar en tabla de edificios)

¿Qué diferencias hay entre los predicados ST_Contains y ST_Covers? (Pista: http://lin-ear-th-inking.blogspot.com.es/2007/06/subtleties-of-ogc-covers-spatial.html)

