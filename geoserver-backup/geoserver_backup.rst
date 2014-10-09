.. _geoserver-backup:

Copias de seguridad de GeoServer
==================================

.. note::

	================  ================================================
	Fecha              Autores
	================  ================================================             
	8 Octubre 2014     * Fernando González (fernando.gonzalez@fao.org) 
	================  ================================================	

	©2013 FAO Forestry 
	
	Excepto donde quede reflejado de otra manera, la presente documentación se halla bajo licencia : Creative Commons (Creative Commons - Attribution - Share Alike: http://creativecommons.org/licenses/by-sa/3.0/deed.es)

Un aspecto importante a la hora de administrar GeoServer es la creación de copias de seguridad. GeoServer almacena toda su configuración en el directorio de datos de GeoServer, referido a partir de ahora como $GEOSERVER_DATA.

Así, para realizar una copia de seguridad, es necesario copiar este directorio, comprimido por comodidad y optimización de espacio, a algún lugar fuera del servidor. Los siguientes comandos crearían una copia de la configuración de GeoServer en el fichero ``/tmp/geoserver-backup.tgz``::

	$ cd $GEOSERVER_DATA
	$ tar -czvf /tmp/geoserver-backup.tgz *

Nótese que el comando ``tar``, encargado de la compresión, se debe ejecutar en el directorio $GEOSERVER_DATA. Las opciones ``-czvf`` especificadas significan:

* c: crear
* z: comprimir en zip
* v: verbose, muestra por pantalla los ficheros que se incluyen en la copia de seguridad
* f: fichero resultante, especificado a continuación

.. warning :: Es muy importante guardar los ficheros con la copia de seguridad en una máquina distinta al servidor de GeoServer, ya que en caso de que haya algún problema con dicha máquina se pueden perder también las copias. 

Para recuperar la configuración sólo tenemos que reemplazar el directorio $GEOSERVER_DATA por los contenidos del fichero. Para ello se puede descomprimir la copia de seguridad en un directorio temporal::

	$ mkdir /tmp/copia
	$ tar -xzvf /tmp/geoserver-backup.tgz --directory=/tmp/copia

A diferencia del comando ``tar`` que utilizamos para crear la copia de seguridad, ahora estamos usando la opción ``x`` (extraer) en lugar de ``c`` (crear) y estamos especificando con la opción ``--directory`` que queremos extraer la copia en el directorio ``/tmp/copia``.

Una vez descomprimido sólo hay que reemplazar los contenidos del directorio $GEOSERVER_DATA por los del directorio ``/tmp/copia``. Por seguridad, moveremos los contenidos actuales del directorio $GEOSERVER_DATA a otro directorio temporal::

	$ mkdir /tmp/data
	$ sudo mv $GEOSERVER_DATA/* /tmp/data/
	
Nótese que para vaciar el directorio tenemos que utilizar permisos de superusuario, con ``sudo``, ya que generalmente el directorio $GEOSERVER_DATA pertenece al usuario que ejecuta GeoServer (tomcat7 en este ejemplo) y es distinto al usuario que administra el sistema.

Tras estas dos instrucciones el directorio $GEOSERVER_DATA estará vacío y tendremos los contenidos actuales en ``/tmp/data/`` y la copia en ``/tmp/copia``. Por tanto, sólo tenemos que copiar los contenidos de ``/tmp/copia`` a $GEOSERVER_DATA::

	$ sudo cp -R /tmp/copia/* $GEOSERVER_DATA

De nuevo, al modificar el directorio $GEOSERVER_DATA tenemos que utilizar ``sudo``.

Para que GeoServer pueda gestionar de nuevo esos ficheros, hay que cambiar el propietario de los ficheros recuperados para que tengan el mismo que el $GEOSERVER_DATA. Para ver qué usuario es este, podemos ejecutar el siguiente comando::

	$ ls -l $GEOSERVER_DATA/..
	total 4
	drwxr-xr-x 17 tomcat7 tomcat7 4096 Oct  9 09:25 data

y ver que el usuario y grupo es ``tomcat7`` y ``tomcat7``. Con esta información, podemos restablecer los permisos así:: 

	$ sudo chown -R tomcat7:tomcat7 $GEOSERVER_DATA/*

Por último, quedaría reiniciar GeoServer. En este ejemplo, se ejecuta dentro de un Tomcat7 por lo que basta con ejecutar::
	
	$ sudo service tomcat7 restart

Creación de copias parciales
-------------------------------

Algunos directorios dentro de $GEOSERVER_DATA pueden ocupar mucho espacio y no ser interesantes para las copias de seguridad frecuentes. Es el caso del directorio de GeoWebCache ``gwc``, que contiene el cacheado de las teselas dibujadas para cada capa y puede llegar a ocupar varios Gigabytes.

Para evitar esto, sólo es necesario utilizar el comando ``tar`` de una manera ligeramente distinta, pasándole como parámetro los directorios dentro de $GEOSERVER_DATA que queremos excluir::

	$ cd $GEOSERVER_DATA
	$ tar -czvf /tmp/geoserver-partial-backup.tgz --exclude=www --exclude=gwc *

Nótesen los parámetros ``--exclude`` indicando que no se deben incluir en la copia los directorios ``www`` y ``gwc``. 

.. warning :: Es importante saber que una copia parcial no puede recuperarse del mismo modo que una copia total, ya que si reemplazamos todo el directorio, perderíamos los subdirectorios que no han sido copiados.

Así, para recuperar una copia parcial procederíamos de la misma manera que en el caso general, pero vaciando sólo los contenidos de $GEOSERVER_DATA que están en la copia.  

Copia de un workspace
........................

En otros casos, la copia de seguridad es interesante sólo para aspectos concretos, como un workspace. 

Tómese por ejemplo la copia del workspace ``nfms``. En este caso es más fácil hacer la copia completa de ese directorio que hacerla en $GEOSERVER_DATA y excluir todo lo que no es el workspace::

	$ cd $GEOSERVER_DATA/workspaces/nfms
	$ tar -czvf /tmp/geoserver-nfms-backup.tgz *

Para recuperar la copia, realizaremos los pasos anteriores pero sólo en el directorio ``$GEOSERVER_DATA/workspaces/nfms``::

	$ mkdir /tmp/copia
	$ tar -xzvf /tmp/geoserver-nfms-backup.tgz --directory=/tmp/copia

La copia de los datos actuales la hacemos sólo para ``$GEOSERVER_DATA/workspaces/nfms``::

	$ mkdir /tmp/data
	$ sudo mv $GEOSERVER_DATA/workspaces/nfms/* /tmp/data/
	
Tras estas dos instrucciones el directorio $GEOSERVER_DATA/workspaces/nfms estará vacío y tendremos la configuración actual del workspace en ``/tmp/data/`` y la copia de seguridad del workspace en ``/tmp/copia``. Por tanto, sólo tenemos que copiar los contenidos de ``/tmp/copia`` a $GEOSERVER_DATA/workspaces/nfms::

	$ sudo cp -R /tmp/copia/* $GEOSERVER_DATA/workspaces/nfms

Por último, hay que cambiar el propietario de los ficheros recuperados:: 

	$ sudo chown -R tomcat7:tomcat7 $GEOSERVER_DATA/workspaces/nfms/*

y reiniciar GeoServer::
	
	$ sudo service tomcat7 restart
  

