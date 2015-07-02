.. _geoserver-install:

Instalación de GeoServer (con PostGIS)
======================================

.. note::

	=================  ================================================
	Fecha              Autores
	=================  ================================================
	2 Julio 2015       * Oscar Fonts (oscar.fonts@geomati.co)
	=================  ================================================

	©2012-2015 Oscar Fonts

	Excepto donde quede reflejado de otra manera, la presente documentación se halla bajo licencia : Creative Commons (Creative Commons - Attribution - Share Alike: http://creativecommons.org/licenses/by-sa/3.0/deed.es)


Requisitos hardware
-------------------

* Sistema Operativo: Recomendado Ubuntu 14.04 Server 64 bits
* CPU con 4 núcleos
* RAM: 2 GB mínimo, 4 GB recomendado
* Disco: 8 GB para sistema y binarios. A partir de ahí, según cantidad de datos a publicar. Raster es especialmente crítico al publicarse como GeoTIFF sin compresión y con redundancia. Dejar también margen para GeoWebCache y para manipular GeoTIFFs con GDAL.


Aplicaciones de base
--------------------

Usar el gestor de paquetes, ayuda a mantener las cosas al día. Cualquier cosa que necesite intervención manual para actualizarse, quedará obsoleta: nadie va a estar mirándose el server cada semana.

Para actualizar paquetes::

	sudo apt-get update
	sudo apt-get upgrade

Para activar la instalación automática de parches de seguridad::

	sudo apt-get install unattended-upgrades
	sudo dpkg-reconfigure -plow unattended-upgrades

Java y tomcat::

	apt-get install openjdk-7-jdk
	apt-get install tomcat7

Añadir JAI y JAI-ImageIO nativos::

	cd /usr/lib/jvm/java-7-openjdk-amd64
	wget http://download.java.net/media/jai/builds/release/1_1_3/jai-1_1_3-lib-linux-amd64-jdk.bin
	sh jai-1_1_3-lib-linux-amd64-jdk.bin
	wget http://download.java.net/media/jai-imageio/builds/release/1.1/jai_imageio-1_1-lib-linux-amd64-jdk.bin
	export _POSIX2_VERSION=199209
	sh jai_imageio-1_1-lib-linux-amd64-jdk.bin

Instalar fuentes de Microsoft (Arial, Courier New, etc)::

	apt-get install ttf-mscorefonts-installer

Si publicamos muchos datos en GeoServer, podemos llegar al límite de ficheros que el SO puede tener abiertos simultáneamente. Para evitarlo, añadir estas líneas a '/etc/security/limits.conf`::

	*                hard    nofile          16384
	*                soft    nofile          16384
	root             hard    nofile          16384
	root             soft    nofile          16384


Instalar GDAL (1.10)::

	apt-get install gdal-bin


Instalar PostgreSQL (9.3) y PostGIS (2.1)::

	apt-get install postgresql postgis
	apt-get install postgresql-9.3-postgis-2.1


Instalación GeoServer
---------------------

Instalar la última estable descargable de geoserver.org (ejemplo comandos para 2.7.1.1)::

	cd /var/lib/tomcat7/webapps/
	wget http://sourceforge.net/projects/geoserver/files/GeoServer/2.7.1.1/geoserver-2.7.1.1-war.zip
	apt-get install unzip
	unzip geoserver-2.7.1.1-war.zip
	rm -rf target/ *.txt geoserver-2.7.1.1-war.zip

Mover el GEOSERVER_DATA_DIR fuera de los binarios::

	sudo mkdir /var/geoserver/
	sudo cp -r /var/lib/tomcat7/webapps/geoserver/data /var/geoserver
	sudo chown -R tomcat7:tomcat7 /var/geoserver

Editar el fichero /etc/default/tomcat7 y añadir al final las rutas a Java, los datos, la caché, y parámetros de optimización::

	JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
	GEOSERVER_DATA_DIR=/var/geoserver
	PORTAL_CONFIG_DIR=/var/portal

	JAVA_OPTS="-server -Xms1560m -Xmx2048m -XX:PermSize=256m -XX:MaxPermSize=512m -XX:+UseConcMarkSweepGC -XX:NewSize=48m -Dorg.geotools.shapefile.datetime=true -Duser.timezone=GMT -DGEOSERVER_DATA_DIR=$GEOSERVER_DATA_DIR -Dfile.encoding=UTF-8 -DMINIFIED_JS=true -DPORTAL_CONFIG_DIR=$PORTAL_CONFIG_DIR"

Reiniciar tomcat::

	service tomcat7 restart


Configuración GeoServer
-----------------------

Entrar a:

	http://localhost:8080/geoserver/web/

En "server status", combrobar que:

* El Data directory apunta a /var/lib/geoserver_data
* La JVM es la instalada (OpenJDK 1.7 64 bits)
* Native JAI y Native JAI ImageIO están a "true"

Seguridad
.........

Seguir las notificaciones de seguridad que aparecen en la página principal de GeoServer:

* Cambiar password de "admin".
* Cambiar el master password.

Configuración Web
.................

Bajo "About & Status":
^^^^^^^^^^^^^^^^^^^^^^

* Editar la información de contacto. Esto aparecerá en los servicios WMS públicos: dejar a "Claudius Ptolomaeus" es indecente.

Bajo "Data":
^^^^^^^^^^^^

* Borrar todos los espacios de trabajo (workspaces) existentes (y en consecuencia, sus almacenes de datos y capas asociadas).
* Borrar todos los estilos existentes (dirá que hay 4 que no los puede borrar, esto es correcto).

Bajo "Services":
^^^^^^^^^^^^^^^^

* WCS: Deshabilitar si no va a usarse.
* WFS: Cambiar el nivel de servicio a "Básico" (a menos que queramos permitir la edición remota de datos vectoriales).
* WMS: En "Limited SRS list", poner sólo las proyecciones que deseamos anunciar en nuestro servicio WMS. Esto reduce el tamaño del GetCapabilities. Por ejemplo: 4326, 3857, 900913.

Bajo "Settings":
^^^^^^^^^^^^^^^^

* Global: Cambiar el nivel de logging a PRODUCTION_LOGGING.

Bajo "Tile Caching":
^^^^^^^^^^^^^^^^^^^^

* Caching Defaults: Activar los formatos "image/png8" para capas vectoriales, "image/jpeg" para capas ráster, y ambas para los grupos de capas.
* Disk Quota: Habilitar la cuota de disco. Tamaño máximo algo por debajo de la capacidad que tengamos en la unidad de GEOSERVER_DATA_DIR.


.. note:: Para saber más...

   * `GeoServer on Steroids <http://es.slideshare.net/geosolutions/gs-steroids-foss4ge2014>`_.
