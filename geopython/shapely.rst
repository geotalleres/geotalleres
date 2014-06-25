shapely
=========

.. note::

    ================  ================================================
    Fecha              Autores
    ================  ================================================             
    25 Junio 2014       * Fernando González Cortés(fergonco@gmail.com) 
    ================  ================================================  

    ©2014 Fernando González Cortés

    Excepto donde quede reflejado de otra manera, la presente documentación se halla bajo licencia : Creative Commons (Creative Commons - Attribution - Share Alike: http://creativecommons.org/licenses/by-sa/3.0/deed.es)

Sesión interactiva::

	# Dibujamos dos puntos en el JTSTestBuilder para obtener su WKT
	
	import shapely
	from shapely.wkt import dumps, loads
	
	a = loads("POINT (150 250)")
	b = loads("POINT (200 250)")
	a.distance(b)
	a.intersects(b)
	
	a.intersects(b.buffer(40))
	a.intersects(b.buffer(60))
	
	a = a.buffer(20)
	b = b.buffer(40)
	
	# Reemplazamos en el JTSTestBuilder
	dumps(a)
	dumps(b)
	
	# Intersectamos?
	a.intersects(b)
	c = a.intersection(b)
	
	# Le quitamos un trozo a b?
	d = b.difference(c)
	
	
	
