.. _elarchivodeseeding:

El archivo de configuración seed.yaml
=============================================

Introducción
---------------------------------

MapProxy genera teselas bajo demanda y las puede almacenar en una cache, pero para acelerar el proceso, sobretodo de capas que no se prevea que vayan a cambiar demasiado, se puede *sembrar* la caché para tener imágenes pregeneradas.

El proceso de sembrado o *seeding* se puede lanzar a través de una herramienta de consola llamada **mapproxy-seed** y configurarse fácilmente a través de un script en *YAML* llamado *seed.yaml*

seed.yaml
---------------------------------------------

El archivo consta de las siguientes secciones

**seeds**
  En esta sección se configuran las opciones de *sembrado* de las capas.

**cleanups**
  En esta sección se configuran las purgas del sembrado para liberar espacio en disco eliminando imágenes viejas.

**coverages**
  En esta sección se definen zonas que después se pueden emplear tanto en el sembrado como en las purgas.

seeds
^^^^^^^^^^^^^

En la sección se define **qué** debe ser sembrado haciendo referencia tanto a las caches (**caches**), como a las rejillas (**gids**) y por supuesto a los niveles de zoom (**levels**) pudiendo emplearse además claves de zonas (**coverages**).

.. code-block:: yaml

    seeds:
      girona_icc:
        caches: [icc_cache]
        grids: [utm_girona]
        levels:
          from: 1
          to: 7
        coverages: [girona]

Puede encontrarse más información sobre estas y otras claves de la sección en `la correspondiente sección sobre seeds de la página de seeding de la documentación de MapProxy`_

cleanups
^^^^^^^^^^^^^

La sección permite configurar las purgas de las cachés para evitar que se acumulen imágenes viejas en disco.

Se debe dar un nombre a cada configuración de purga y definir a que cachés van a atacar (**caches**), en qué rejillas (**grids**), a qué niveles (**levels**) o en que coberturas (**coverages**) y por supuesto la resolución temporal de la purgas (**remove_before**).

.. code-block:: yaml

    cleanups:
      girona:
        caches: [icc_cache]
        grids: [GLOBAL_MERCATOR, GLOBAL_GEODETIC, utm_girona]
        levels:
          from: 8
        coverages: [girona]
        remove_before:
          weeks: 1
          days: 2
          hours: 3
          minutes: 4


Puede encontrarse más información sobre estas y otras claves de la sección en `la correspondiente sección sobre cleanups de la página de seeding de la documentación de MapProxy`_

coverages
^^^^^^^^^^^^^

Por último, el archivo permite la definición de zonas en las que aplicar la tanto el sembrado como las purgas.

Estas zonas pueden definirse tanto como un *bounding box* o como una región definida con *WKT* en un archivo de texto o a través de un polígono que pueda leerse empleando OGR_.

.. code-block:: yaml

    coverages:
      girona:
        bbox: [2.67,41.88,2.97,42.07]
        bbox_srs: "EPSG:4326"


Se pueden encontrar algunos ejemplos de configuración en `la correspondiente sección sobre coverages de la página de seeding de la documentación de MapProxy`_


Autores:
-------------------------

* Pedro-Juan Ferrer `@vehrka <http://twitter.com/vehrka>`_ · pferrer@osgeo.org
* Iván Sanchez `@realivansanchez <http://twitter.com/realivansanchez>`_ · ivan@sanchezortega.es
* Jorge Sanz `@xurxosanz <http://twitter.com/xurxosanz>`_ · jsanz@osgeo.org

.. _la correspondiente sección sobre seeds de la página de seeding de la documentación de MapProxy: http://mapproxy.org/docs/1.5.0/seed.html#seeds
.. _la correspondiente sección sobre cleanups de la página de seeding de la documentación de MapProxy: http://mapproxy.org/docs/1.5.0/seed.html#cleanups
.. _OGR: http://www.gdal.org/ogr/
.. _la correspondiente sección sobre coverages de la página de seeding de la documentación de MapProxy: http://mapproxy.org/docs/1.5.0/seed.html#id7
