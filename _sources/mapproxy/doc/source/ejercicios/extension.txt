Extensión: propuesta de ejercicios
-------------------------------------

#. Ofrecer WMTS/TMS de servicios propios

   Esto es, a partir de un servicio WMS de nuestra organización, ofrecer un servicio TMS y WMTS cacheado
   de ciertas capas para permitir un acceso más eficiente a las mismas.

#. Restructurar árboles de capas como un nuevo servicio

   Como continuación del anterior ejercicio, a partir de nuevo de un conjunto de servicios WMS de nuestra
   organización, reordenarlos y presentarlos a nuestros usuarios de una forma diferente, integrando
   varios orígenes de datos en un único servicio.

#. Redirigir el getLegendgraphic y el getFeatureInfo

   El protocolo WMS dispone de dos peticiones adicionales a la petición de mapa (``getMap``). MapProxy permite
   dar acceso a estas dos peticiones e incluso transformarlos usando hojas de estilo XSL.

#. Publicar servicios diseñados con TileMill (XML de Mapnik)

   Además de publicar un MBTiles, podemos publicar en MapProxy directamente un archivo de configuración de Mapnik,
   que puede haber sido generado con TileMill por ejemplo. Esto convierte a MapProxy efectivamente en un
   servidor de mapas.

#. Modo multimapa

   Hasta ahora solo hemos visto la generación de un servicio de MapProxy a partir de un archivo de configuración.
   MapProxy admite también un modo *multimapa* en el que es posible publicar un número indeterminado de archivos de
   configuración.

Autores:
-------------------------

* Pedro-Juan Ferrer `@vehrka <http://twitter.com/vehrka>`_ · pferrer@osgeo.org
* Iván Sanchez `@realivansanchez <http://twitter.com/realivansanchez>`_ · ivan@sanchezortega.es
* Jorge Sanz `@xurxosanz <http://twitter.com/xurxosanz>`_ · jsanz@osgeo.org