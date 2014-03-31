VMWare Instalación de la máquina virtual
========================================

.. note::

    +------------+-----------------------------------------+
    | Fecha      | Autor                                   |
    +------------+-----------------------------------------+
    | 2014-03-31 | * Pedro-Juan Ferrer (pferrer@osgeo.org) |
    +------------+-----------------------------------------+

    ©2014 Geoinquietos Valencia

    Excepto donde quede reflejado de otra manera, la presente documentación
    se halla bajo licencia : Creative Commons (Creative Commons -
    Attribution - Share Alike:
    http://creativecommons.org/licenses/by-sa/4.0/)
    
La formación se va a realizar en una máquina virtual. Para ello se utilizará
un software de virtualización, que se encargará de hospedar la máquina
virtual. 

Para el caso que nos ocupa emplearemos la máquina virtual |olver| de `OSGeo
Live`_ dentro del software de virtualización *VMWare*.

Los pasos necesarios para esto son:

* Descarga e instalación de VMWare.
* Descarga de OSGeo Live.
* Configuración de la máquina virutal

En la terminología de los software de virtualización, la máquina real es la
anfitriona, host en inglés; mientras que la máquina virtual es la huésped, o
guest en inglés.


Descarga e instalación de VMWare
--------------------------------

El primer paso es descargar el software de la `página de descargas de
VMWare`_ y proceder a su instalación.

.. image:: _static/download_vmware.png

El resultado de esta descarga debe ser un fichero con un nombre parecido a
:file:`VMware-Player-6.0.1-1379776.x86_64.bundle` o
:file:`VMware-player-6.0.1-1379776.exe` en función del sistema operativo
seleccionado.

Instalación en GNU/Linux (Debian)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Al tratarse de un archivo binario, deberán cambiarse los permisos para poder
ejecutar la instalación:

.. code-block:: bash

   $ chmod +x VMware-Player-6.0.1-1379776.x86_64.bundle

Y deberemos ejecutarlo con permisos de superusuario:

.. code-block:: bash

   $ sudo ./VMware-Player-6.0.1-1379776.x86_64.bundle

y usar las opciones por defecto para la instalación.

Instalación en Windows 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ejecutaremos el archivo :file:`.exe` y usaremos las opciones por defecto para la
instalación.

.. _página de descargas de VMWare: https://my.vmware.com/web/vmware/free#desktop_end_user_computing/vmware_player/6_0

Descarga de OSGeo Live
------------------------------

Para descargar la |olver| de la máquina virtual deberemos visitar la
`sección correspondiente de la web Sourceforge`_ y proceder a la descarga
del archivo :file:`.7z` [1]_.

.. image:: _static/download_live.png

Descompresión del archivo en GNU/Linux
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Para descomprimir el archivo emplearemos el comando:

.. code-block:: bash

   $ 7z e osgeo-live-vm-7.0.7z

Configuración de la máquina virtual
--------------------------------------

La máquina virtual se ejecuta dentro del programa *VMWare Player* que hemos
instalado con anterioridad, por lo que arrancaremos dicho programa

.. image:: _static/vmware_open_vm.png

Seleccionaremos la opción *Create a New Virtual Machine*.

.. image:: _static/vmware_proc_01.png

Seleccionamos *I will install the operating system later*

.. image:: _static/vmware_proc_02.png

Seleccionamos *Guest Operating System: Linux* y *Version: Ubuntu*

A continuación deberemos darle un nombre a la máquina virtual y seleccionar
una ubicación en disco en la que almacenarla. 
.. image:: _static/vmware_proc_03.png
   

Seleccionamos el nombre de la máquina y cuál será su localización en disco. 
El nombre de la máquina *osgeo_live* y el destino de la
máquina aparece difuminado.


.. image:: _static/vmware_proc_04.png
   
La aplicación nos solicitará que seleccionemos la capacidad del disco. En
realidad no usaremos el disco que configure la máquina virtual, por lo que
podemos dejar las opciones por defecto.

Seleccionamos la configuración del disco duro: *Split virtual disk into multiple files*

.. image:: _static/vmware_proc_05.png
   

Pulsaremos *Finish*


.. image:: _static/vmware_proc_06.png
   

Pulsaremos *Close*

Tenemos la máquina virtual creada pero hay que configurarla para que use el
disco que nos hemos descargado.

.. image:: _static/vmware_proc_07.png
   

Seleccionamos la máquina osgeo_live y a continuación pulsamos *Edit virtual
machine settings*

.. image:: _static/vmware_proc_08.png
   
Seleccionaremos el disco duro creado por defecto *Hard Disk (SCSI)* y lo
eliminaremos.

Seleccionar *Hard Disk (SCSI)* y después pulsar *Remove*

Ahora añadiremos el disco virtual que nos hemos descargado de *Sourceforge*
y hemos descomprimido.

.. image:: _static/vmware_proc_09.png
   

Pulsar *Add...*


.. image:: _static/vmware_proc_10.png
   

Seleccionar *Hard Disk* y pulsar *Next*


.. image:: _static/vmware_proc_11.png
   
Dejaremos la opción por defecto *SCSI*

Pulsar *Next*

El nuevo disco ya existe por lo que hay que seleccionar la opción *Use an
existing virtual disk*

.. image:: _static/vmware_proc_12.png
   

Seleccionar *Use an existing virtual disk* y pulsar *Next*


.. image:: _static/vmware_proc_13.png
   
A continuación pulsaremos *Browse* y buscaremos el lugar dónde
hemos descomprimido el archivo descargado de *Sourceforge*. En la imagen
podemos ver que la casilla ha sido difuminada.

Seleccionar el disco que hemos descomprimido y pulsar *Finish*


.. image:: _static/vmware_proc_14.png
   
Es posible que la aplicación nos solicite información sobre la ejecución de
una actualización de versión del disco virtual. Deberemos seleccionar la
opción *Convert*.


.. image:: _static/vmware_proc_15.png
   
Solo restará guardar la configuración de la máquina virtual pulsando *Save*

Pulsamos *Save*

Y ejecutar la máquina virtual con la opción *Play virtual machine*

.. image:: _static/vmware_proc_16.png

Seleccionamos *osgeo_live* y pulsamos *Play virtual machine*

.. [1] 7-Zip es un gestor de archivos comprimidos Open Source y
   multiplataforma que usa de manera nativa el formato de archivo :file:`7z`
   aunque puede trabajar con muchos otros. Puede instalarse por paquetes o
   descargarse de http://www.7-zip.org

.. |olver| replace:: versión 7.0

.. _OSGeo Live: http://live.osgeo.org
.. _sección correspondiente de la web Sourceforge: http://sourceforge.net/projects/osgeo-live/files/7.0/

