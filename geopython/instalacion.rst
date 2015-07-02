Instalación
===========

.. note::

    ================  ================================================
    Fecha              Autores
    ================  ================================================             
    25 Junio 2014       * Fernando González Cortés(fergonco@gmail.com) 
    ================  ================================================  

    ©2014 Fernando González Cortés

    Excepto donde quede reflejado de otra manera, la presente documentación se halla bajo licencia : Creative Commons (Creative Commons - Attribution - Share Alike: http://creativecommons.org/licenses/by-sa/3.0/deed.es)

El taller se realiza sobre una máquina virtual con la versión 7.9 del DVD de OSGEO, sobre el que tenemos que instalar las librerías Shapely, Fiona y Rasterio.

Detallamos a continuación el método de instalación de dos formas.

Versión rápida
---------------

Copiar la `versión 1.7.0 de los fuentes en tar.gz de libspatialindex <http://download.osgeo.org/libspatialindex/spatialindex-src-1.7.0.tar.gz>`_ al directorio ``/tmp/`` de la máquina virtual.

Crear en la máquina un fichero ``/tmp/install.sh`` con este contenido::

	set -e
	
	cd $HOME
	
	sudo apt-get install libgdal1-dev python-dev
	sudo apt-get install python-virtualenv
	
	mkdir tig_env
	virtualenv tig_env
	source tig_env/bin/activate
	
	pip install fiona
	pip install Shapely
	
	cd /tmp
	tar -xzvf /tmp/spatialindex-src-1.7.0.tar.gz
	cd spatialindex-src-1.7.0/
	sudo ./configure
	sudo make
	sudo make install
	sudo ldconfig
	pip install Rtree
	
	pip install affine>=1.0
	pip install Numpy
	pip install setuptools
	
	pip install rasterio

Dar permisos de ejecución::

	chmod u+x /tmp/install.sh

Ejecutar::

	/tmp/install.sh

Versión detallada
------------------

Shapely, Fiona y Rasterio funcionan sobre GDAL y su instalación requiere la compilación de código en C, por lo que antes de empezar a instalar las librerías hay que instalar los siguientes prerrequisitos::

	sudo apt-get install libgdal1-dev python-dev

Creación de un entorno virtual
--------------------------------

Para la instalación crearemos un entorno virtual::

	sudo apt-get install python-virtualenv
	mkdir tig_env
	virtualenv tig_env
	
Tras la creación, podemos ejecutar la siguiente instrucción para entrar en el entorno virtual::

	source tig_env/bin/activate
	
Para dejar el entorno virtual es suficiente con ejecutar la instrucción ``deactivate``

Fiona y Shapely
----------------

Una vez creado y activado el entorno virtual, hay que ejecutar los siguientes comandos para instalar Fiona y Shapely::

    pip install fiona
    pip install Shapely

Rtree
......

Durante las prácticas se hará uso de un índice espacial, por lo que hay que instalar la librería ``libspatialindex`` 1.7.0, que se puede descargar de aquí::

	http://download.osgeo.org/libspatialindex/
	
Descargamos ``spatialindex-src-1.7.0.tar.gz`` en el directorio ``/tmp`` y descomprimimos::

	cd /tmp/
	tar -xzvf /tmp/spatialindex-src-1.7.0.tar.gz

A continuación, dentro del directorio que ha aparecido::

	cd spatialindex-src-1.7.0/

Se ejecutan las siguientes instrucciones::

	sudo ./configure
	sudo make
	sudo make install
	sudo ldconfig
    
Y por último instalamos el índice espacial::    
        
	pip install Rtree

Rasterio
---------

Para la manipulación de datos raster utilizaremos rasterio. Instalamos primero los requisitos::

	pip install affine>=1.0
	pip install Numpy
	pip install setuptools
        
Y por último instalamos rasterio::

	pip install rasterio

Comprobación
------------

Por último comprobamos que todo está instalado correctamente y ejecutamos python::

	pip freeze
	python
