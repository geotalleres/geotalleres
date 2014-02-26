Presentación
============================

Autores:
-------------------------

* Pedro-Juan Ferrer `@vehrka`_ · pferrer@osgeo.org

  * Project Manager en Omnium SI
  * Geofriki

* Iván Sanchez `@realivansanchez`_ · ivan@sanchezortega.es

  * PHPDev en Omnium SI
  * Más geofriki aún si cabe

* Jorge Sanz `@xurxosanz`_ · jsanz@osgeo.org

  * GISguy en `Prodevelop <http://www.prodevelop.es>`_
  * Geofriki

Qué es MapProxy
---------------------------

MapProxy es un servidor de teselas que lee datos de WMS, TMS, configuraciones de
Mapserver o Mapnik de TileCache, Google Maps, Bing Maps, etc. Podría decirse que
MapProxy es un *acelerador* de mapas en Internet, aunque no solo ofrece
servicios de *proxy*, también es un Servidor WMS, permite realizar *Sembrado
(Seeding)* de capas, permite gestionar seguridad de acceso a capas, reproyectar
capas, etc.

.. figure:: img/mapproxy.png
   :align: center
   :alt: Esquema básico de red

   Esquema de una red con MapProxy configurado

Un poco más sobre MapProxy
---------------------------

- La web del proyecto es http://mapproxy.org
- Es un producto de `Omniscale`_ (`ImpOSM`_)
- `Oliver Tonnhofer`_ es su desarrollador principal
- Está escrito en Python
- Es FOSS desde 2010 (licencia Apache)
- Tiene una `lista de correo`_ para soporte y dudas (en inglés)

Pero ¿para qué sirve?
---------------------------

Algunos casos de uso:

* Ofrecer acceso a servicios de mapas en zonas con acceso restringido a Internet

* Ofrecer a Internet ciertos servicios internos de una organización sin abrir
  todo el servidor de mapas corporativo

* Generar servicios de teselas (TMS/WMTS) a partir de un servidor WMS

* Acelerar el acceso a servicios de mapas *cacheando* la información

* Mezclar cartografía de diferentes servicios de mapas

* Descargar cartografía a equipos que se van a desplazar a zonas sin acceso a
  Internet (caso del equipo HOT de OSM)

* Servir cartografía diseñada con TileMill

* Ofrecer servicios en diferentes sistemas de coordenadas a partir de un
  servicio TMS que solo nos llega en el Mercator.

¿Cómo funciona?
---------------------------

Se trata de un software de servidor que se configura a través de ficheros
escritos en `YAML`_ y *scripts* Python. Una vez correctamente configurado se
*despliega* el servicio mediante alguno de los procedimientos para aplicaciones
*Python* que siguen el estándar WSGI_.


.. code-block:: yaml

    services:
      demo:
      kml:
      tms:
      wmts:
      wms:
        srs: ['EPSG:3857', 'EPSG:900913', 'EPSG:4258', 'EPSG:4326', 'EPSG:25831']
        image_formats: ['image/jpeg', 'image/png']
        md:
          # metadata used in capabilities documents
          title: Taller MapProxy
          abstract: Ejercicio de aceleración de WMS y OSM con MapProxy
          online_resource: http://localhost:8080/service
          contact:
            person: Pedro-Juan Ferrer, Iván Sánchez y Jorge Sanz
            position: Facilitadores
            organization: Geoinquietos Valencia
            email: pferrer@osgeo.org , jsanz@osgeo.org y ivan@sanchezortega.es
          access_constraints:
            Este servicio tiene únicamente objetivos educativos.
          fees: 'None'


.. _@vehrka: http://twitter.com/vehrka
.. _@realivansanchez: http://twitter.com/realivansanchez
.. _@xurxosanz: http://twitter.com/xurxosanz
.. _lista de correo: http://lists.osgeo.org/mailman/listinfo/mapproxy
.. _Omniscale: http://omniscale.com
.. _ImpOSM: http://imposm.org
.. _Oliver Tonnhofer: http://twitter.com/oltonn
.. _YAML: http://http://www.yaml.org
.. _WSGI: http://www.python.org/dev/peps/pep-3333/
