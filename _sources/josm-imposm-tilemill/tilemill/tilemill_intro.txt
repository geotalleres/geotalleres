.. _TileMill:

Qué es TileMill
================

.. note::

    Autores:

    * |pferrer|
    * |isanchez|
    * |stramoyeres|

    Licencia:

    Excepto donde quede reflejado de otra manera, la presente documentación
    se halla bajo licencia `Creative Commons Reconocimiento Compartir Igual
    <https://creativecommons.org/licenses/by-sa/4.0/deed.es_ES>`_

TileMill es un herramienta que permite un acercamiento al diseño cartográfico a
través de un lenguaje que es familiar a los desarrolladores web.

Sirve para que **incluso** un diseñador web pueda hacer mapas bonitos.

¿Por qué mis mapas han de ser bonitos?
---------------------------------------

Vamos, no fastidies, estás hablando con un cartógrafo.

Bueno, no tienen porqué serlo ...

... pero venden más :)

Algunos ejemplos de mapas hechos con TileMill.

.. image:: ../img/ejemplosmapas.png
   :width: 600 px
   :alt: algunos mapas hechos con TileMill
   :align: center

Añadiendo datos
------------------

El primer paso siempre es añadir datos y el primer paso para añadirlos es tener
claros sus metadatos, en especial:

* Su Formato
* Su Tamaño
* y su Sistema de referencia

Vectores
```````````````````

* CSV
* Shapefile
* KML
* GeoJSON

Raster
```````````````````

* GeoTIFF

Bases de datos
```````````````````

* SQLite
* PostGIS

Introducción al lenguaje Carto
--------------------------------

Carto es el lenguaje que utiliza TileMill para aplicar estilos a las primitivas
cartográficas.

Está basado en *Cascadenik* que es un pre-procesador de estilos para Mapnik.

Mapnik solo entiende XML pero poca gente entiende XML así que aparecieron
pre-procesadores para hacer "la vida más fácil" a los usuarios de Mapnik.

TileMill usa Mapnik por debajo y Carto es el lenguaje con el que le comunica
como deben quedar las cosas.

Pintando puntos
```````````````````

.. code-block:: css

  #puntos{
    marker-width: 2;
    marker-fill: #EE0000;
    marker-line-color: #FFFABB;
  }

Existen dos tipos de *puntos* **Point** y **Marker** entre los dos suman 24
propiedades.

.. image:: ../img/ejemplopuntos.png
   :width: 600 px
   :alt: ejemplo con algunos puntos dibujados
   :align: center

Pintando lineas
```````````````````

.. code-block:: css

  #linea {
    line-color: #c0d8ff;
    line-cap: round;
    line-join: round;
  }

Existen 11 propiedades distintas para las ĺíneas.

.. image:: ../img/ejemplolineas.png
   :width: 600 px
   :alt: ejemplo con algunas líneas dibujadas
   :align: center

Pintando áreas
```````````````````

.. code-block:: css

  #areas {
    line-color: #FFFABB;
    line-width: 0.5;
    polygon-opacity: 1;
    polygon-fill: #6B9;
   }

Existen 5 propiedades distintas para las áreas.

.. image:: ../img/ejemploarea.png
   :width: 600 px
   :alt: ejemplo con áreas dibujadas
   :align: center

.. _pintandoconclase:

Pintando con clase
```````````````````````

Para el que se lo haya preguntado ... también se pueden usar clases (y
condiciones)

.. code-block:: css

  .natural[TYPE='water'],
  .water {
    polygon-fill:#c0d8ff;
  }

  .natural[TYPE='forest'] {
    polygon-fill:#cea;
  }

Y alguna cosilla más
```````````````````````

El uso de **@** te permite definir **variables**

.. code-block:: css

  @water:#c0d8ff;
  @forest:#cea;

Y los selectores se pueden anidar

.. code-block:: css

  .highway[TYPE='motorway'] {
    .line[zoom>=7]  {
      line-color:spin(darken(@motorway,36),-10);
      line-cap:round;
      line-join:round;
    }
    .fill[zoom>=10] {
      line-color:@motorway;
      line-cap:round;
      line-join:round;
    }
  }


Más sobre el lenguaje Carto
-------------------------------------

Usando iconos como marcadores
`````````````````````````````````

Por ejemplo para pintar puntos de interes

.. code-block:: css

  .amenity.place[zoom=15] {
    [type='police']{
      point-file: url(../res/comi-9px.png);
    }
    [type='fuel'] {
      point-file: url(../res/petrol-9px.png);
    }
    [type='townhall'],
    [type='university'] {
      point-file: url(../res/poi-9px.png);
    }
  }


.. image:: ../img/ejemploiconos.png
   :width: 600 px
   :alt: ejemplo con iconos
   :align: center

Pintando cajas de carretera
```````````````````````````````

.. code-block:: css

  .highway[TYPE='motorway'] {
    .line[zoom>=7]  {
      line-color:spin(darken(@motorway,36),-10);
      line-cap:round;
      line-join:round;
    }
    .fill[zoom>=10] {
      line-color:@motorway;
      line-cap:round;
      line-join:round;
    }
  }

  .highway[zoom=13] {
    .line[TYPE='motorway']      { line-width: 2.0 + 2; }
    .fill[TYPE='motorway']      { line-width: 2.0; }
  }

¿No sabes lo que es una caja de carretera?

.. image:: ../img/ejemplocaja.png
   :width: 350 px
   :alt: ejemplo con carreteras
   :align: center

Exportando los mapas
---------------------------

* PNG
* PDF
* MBTiles
* SVG

Montando un TMS
`````````````````````

Pasar de MBTiles a una estructura de directorios para TMS `usando mbutil
<https://github.com/mapbox/mbutil>`_

.. code-block:: bash

   $ mb-util exportado.mbtiles directorio/

Otras alimañas
---------------

Soporte para plugins
```````````````````````````

A partir de la versión 0.9 y aprovechando que node.js también lo permite.

Añaden funcionalidades como poder ver varios niveles de zoom a la vez.

A fecha de hoy hay 5 plugins *Core* y 2 plugins adicionales.

Mapas interactivos
```````````````````````````

TileMill admite cierta interactividad que se puede configurar para cada mapa.

.. image:: ../img/ejemplointeractivo.png
   :width: 600 px
   :alt: ejemplo de mapa interactivo
   :align: center

Referencias y enlaces
---------------------------
* `Página principal de TileMill <http://mapbox.com/TileMill/>`_
* `Referencia del lenguaje Carto <http://mapbox.com/carto/>`_
* `Estilo OSM Bright de Mapbox para cartografía de OpenStreetMap <https://github.com/mapbox/osm-bright>`_
