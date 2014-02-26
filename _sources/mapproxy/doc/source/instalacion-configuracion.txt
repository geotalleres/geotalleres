Instalación de MapProxy
=================================================

.. note:: El siguiente proceso de instalación está orientado a una máquina GNU/Linux de tipo Debian/Ubuntu o similar. En `esta entrada del geomaticblog <http://geomaticblog.net/2012/10/10/instalando-mapproxy-en-windows-paso-a-paso/>`_ puede encontrarse unas notas de instalación en *Windows*.

Descarga de dependencias del sistema
---------------------------------------------------

Instalar paquetes iniciales::

  $ sudo apt-get install tree python-virtualenv

.. note:: Las líneas de esta documentación que comiencen con el símbolo
          del dólar indican instrucciones a ejecutar en una consola
          del sistema. Si vas a copiar estas líneas en tu consola debes hacerlo
          **sin incluir el dólar**.

Instalar el resto de dependencias de MapProxy::

  $ sudo apt-get install python-imaging \
    python-yaml libproj0 libgeos-dev python-lxml libgdal-dev \
    python-shapely build-essential python-dev libjpeg-dev \
    zlib1g-dev libfreetype6-dev

Esto descargará unas 200MB en binarios en un sistema nuevo, tardará un buen
rato...  A partir de aquí todo se ejecuta como un usuario normal. En el caso
de OSGeo Live muchos de estos paquetes ya están instalados y por tanto solo
instalará los necesarios.

Cómo instalar MapProxy
---------------------------------------------------

Primero vamos a descargar los materiales del taller. En el home del usuario
ejecutar::

  $ mkdir mapproxy-workshop
  $ wget -O mapproxy-workshop/mapproxy-workshop.pdf "http://bit.ly/mapproxy-workshop"

..  $ git clone https://github.com/geoinquietosvlc/mapproxy-workshop.git


Con esto tendremos una nueva carpeta ``mapproxy-workshop`` con el documento pdf
del taller.

Moverse a la carpeta creada y crear el entorno virtual con::

  $ virtualenv venv

Activar el entorno virtual con::

  $ source venv/bin/activate

.. note:: Una vez activado el entorno virtual nos aparecerá entre paréntesis en
          el símbolo del sistema el nombre del mismo. Se indica igualmente
          en estas instrucciones para recordarlo.

Instalar la librería de tratamiento de imágenes PIL con::

  (venv)$ pip install https://bitbucket.org/olt/pil-2009-raclette/get/default.tar.gz

Y ya por fin podemos instalar MapProxy::

  (venv)$ pip install MapProxy

Al finalizar podremos comprobar que MapProxy está instalado usando la
instrucción ``mapproxy-util``::

  (venv)$ mapproxy-util --version
  MapProxy 1.5.0

Crear un proyecto de demostración
------------------------------------------

Para comprobar que MapProxy está funcionando correctamente vamos a crear un
proyecto de ejemplo y lo arrancaremos con el servidor de pruebas que MapProxy
incorpora. Para ello, nos colocaremos en la carpeta raíz del taller y crearemos
la carpeta ``confs``. Nos movemos a esa carpeta y ejecutamos la herramienta que
MapProxy incorpora para diferentes tareas ``mapproxy-util``.::

	(venv)$ mapproxy-util create -t base-config test

Y veremos aparecer en pantalla la confirmación de que ha escrito los archivos::

	writing test/mapproxy.yaml
	writing test/seed.yaml

Esta instrucción ha creado la carpeta ``test`` y dentro de ella dos ficheros de
configuración que veremos en la siguiente parte del taller. El fichero
``mapproxy.yaml`` configura el servidor de teselas y ``seed.yaml`` las tareas de
pregeneración y/o limpieza de teselas.

Para ejecutar el servidor de pruebas se utilizará de nuevo ``mapproxy-util``
esta vez con la tarea de arrancar el servidor de pruebas.::

  (venv)$ cd test
  (venv)$ mapproxy-util serve-develop mapproxy.yaml

Y veremos aparecer en pantalla líneas similares a las siguientes::

  [2012-12-06 17:20:09,814] mapproxy.config - INFO - reading: /home/user/mapproxy-workshop/confs/test/mapproxy.yaml
  [2012-12-06 17:20:09,907] mapproxy.service.wmts - WARNING - grid 'global_geodetic_sqrt2' is not compatible with WMTS, skipping for layer 'osm'
  [2012-12-06 17:20:09,909] mapproxy.service.wmts - WARNING - grid 'global_geodetic_sqrt2' is not compatible with WMTS, skipping for layer 'osm'
  [info]  * Running on http://127.0.0.1:8080/
  [info]  * Restarting with reloader: stat() polling
  [2012-12-06 17:20:10,234] mapproxy.config - INFO - reading: /home/user/mapproxy-workshop/confs/test/mapproxy.yaml
  [2012-12-06 17:20:10,321] mapproxy.service.wmts - WARNING - grid 'global_geodetic_sqrt2' is not compatible with WMTS, skipping for layer 'osm'
  [2012-12-06 17:20:10,324] mapproxy.service.wmts - WARNING - grid 'global_geodetic_sqrt2' is not compatible with WMTS, skipping for layer 'osm'

Si nos dirigimos con nuestro navegador a la dirección web http://localhost:8080
podremos ver un mensaje de bienvenida y si hacemos clic en el enlace *demo*
MapProxy nos mostrará su interfaz de demostración de servicios. En esta página
podemos ver diferentes enlaces a ficheros de capacidades y a visores. Podemos
probar con el servicio **TMS** y ver la capa ``osm`` en el sistema de
coordenadas ``EPSG:900913`` en formato ``png``.

.. figure:: _static/demo-test.png
	 :width: 50%
	 :alt: Interfaz de demostración de MapProxy
	 :align: center

	 Interfaz de demostración de MapProxy

Esta interfaz además de permitir navegar por la cartografía, ofrece información
adicional sobre la *cache* como las coordenadas de sus límites, los niveles de
resolución así como el código mínimo necesario para cargar dicha capa usando la
biblioteca de *webmapping* `OpenLayers <http://www.openlayers.org>`_.

.. note:: Para apagar el servidor de pruebas se debe pulsar la combinación de
					teclas ``Control+C``.

Si se observa cuidadosamente la salida de ``mapproxy-util``, se pueden tanto las peticiones que mapproxy hace al *source*::

   [2013-02-03 20:08:15,241] mapproxy.source.request - INFO - GET http://shagrat.icc.es/lizardtech/iserv/ows?layers=orto5m&width=541&version=1.1.1&bbox=482127.752371,4636453.33696,497518.196187,4655724.38706&service=WMS&format=image%2Fpng&styles=&srs=EPSG%3A25831&request=GetMap&height=678 200 759.8 366

Así como las peticiones que mapproxy *responde* al cliente::

   [info] 127.0.0.1 - - [03/Feb/2013 20:08:23] "GET /service?LAYERS=orto5m-icc&FORMAT=image%2Fpng&SRS=EPSG%3A3857&EXCEPTIONS=application%2Fvnd.ogc.se_inimage&TRANSPARENT=TRUE&SERVICE=WMS&VERSION=1.1.1&REQUEST=GetMap&STYLES=&BBOX=284862.66336419,5137678.0304892,342979.26470981,5176813.788971&WIDTH=891&HEIGHT=600 HTTP/1.1" 200 -



Finalmente, podemos comprobar cómo el servidor ha guardado algunas teselas al
visitar la demostración en la carpeta ``confs/test/cache_data`` que podemos ver
desde la consola si navegamos hasta esa carpeta y ejecutamos el comando
``tree``::

    $ tree -d -L 3
    .
    └── osm_cache_EPSG900913
        ├── 01
        │   └── 000
        ├── 03
        │   └── 000
        ├── 05
        │   └── 000
        ├── 07
        │   └── 000
        └── tile_locks

Como vemos ha creado una carpeta para la *cache* de la capa ``osm`` y una
estructura de carpetas donde se almacenan las imágenes.

.. attention:: ¿Qué tamaño tienen las imágenes? ¿En qué formato están?
   Si tenemos *imagemagick* instalado en nuestro ordenador, podemos ver
   información sobre las imágenes del caché rápidamente ejecutando::

    identify `find cache_data | grep png`

Despliegue
-----------------------

No es objetivo de este taller describir el proceso de despliegue de MapProxy en
un servidor de producción. MapProxy es una aplicación escrita en Python que
sigue el estándar WSGI_ de publicación de aplicaciones web. Este estándar
permite publicar aplicaciones de diferentes formas que dependerán en parte de
nuestro entorno. En la `documentación de despliegue`_ de MapProxy se detallan las
más importantes entre las que se podrían destacar:

- Mediante `Apache + mod_WSGI`_: en esta configuración se activa este módulo de
  Apache y se configura una sección en la configuración del mismo que apunte a
  la ubicación de nuestro *server script*. Esta variante funciona tanto en
  Windows como en servidores GNU/Linux.

- Mediante Gunicorn_: en esta configuración se configura un servicio que arranca
  un servidor gunicorn que se podrá a continuación exponer directamente u
  ofrecer a través de un proxy inverso con otro servidor web como Apache o
  Nginx. Esta variante solo se puede configurar en máquinas GNU/Linux.

En ambos casos se utiliza un script de arranque de la aplicación WSGI que se
puede generar con la herramienta ``mapproxy-util``.


Autores:
-------------------------

* Pedro-Juan Ferrer `@vehrka <http://twitter.com/vehrka>`_ · pferrer@osgeo.org
* Iván Sanchez `@realivansanchez <http://twitter.com/realivansanchez>`_ · ivan@sanchezortega.es
* Jorge Sanz `@xurxosanz <http://twitter.com/xurxosanz>`_ · jsanz@osgeo.org

.. _WSGI: http://www.python.org/dev/peps/pep-3333/
.. _documentación de despliegue: http://mapproxy.org/docs/1.5.0/deployment.html
.. _Apache + mod_WSGI: http://mapproxy.org/docs/1.5.0/deployment.html#apache-mod-wsgi
.. _Gunicorn: http://mapproxy.org/docs/1.5.0/deployment.html#gunicorn
