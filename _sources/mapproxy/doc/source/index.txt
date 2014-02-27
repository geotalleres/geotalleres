Taller de MapProxy
=============================================

.. note::

    Autores:

    * |pferrer|
    * |jsanz|
    * |isanchez|

    Licencia:

    Excepto donde quede reflejado de otra manera, la presente documentación
    se halla bajo licencia `Creative Commons Reconocimiento Compartir Igual
    <https://creativecommons.org/licenses/by-sa/4.0/deed.es_ES>`_

Nivel: Básico
---------------------------

Los asistentes deberán conocer conceptos básicos del `protocolo WMS <https://en.wikipedia.org/wiki/Web_Map_Service>`_ y manejo básico de consola
GNU/Linux (cambiar de carpeta, listar contenidos).

Descripción
---------------------------

`MapProxy <http://mapproxy.org/>`_ es un servidor de teselas y proxy WMS Open
Source, acelera las aplicaciones de mapas a través de la pregeneración de
tiles integrando múltiples fuentes de datos y almacenándolos en una caché

El objetivo del taller es dar a conocer la aplicación MapProxy;
explicando cuáles son sus funcionalidades básicas, cuáles son sus
potencialidades, repasar algunos casos de éxito y finalmente escribir
y desplegar una configuración básica con las opciones más comunes.

La primera parte del taller consistirá en realizar una introducción,
instalación del software, creación de un proyecto de ejemplo y
comprobar su funcionamiento.

En la segunda parte del taller se revisarán algunos casos de uso de la
aplicación y se realizarán ejercicios que resuelvan algunas de las
dudas más frecuentes a la hora de empezar a usar este software.

Aplicaciones necesarias
------------------------------------------

Se recomienda emplear un sistema Operativo GNU/Linux basado en Debian/Ubuntu
con los siguientes paquetes instalados:

- Navegador web
- Consola
- Editor de ficheros (gedit sirve pero **vim its a win!!!**)
- Algunas librerías de desarrollo y componentes Python

Tabla de contenidos
-------------------

.. toctree::
   :maxdepth: 1

   presentacion.rst
   instalacion-configuracion.rst
   elarchivodeconfiguracion.rst
   elarchivodeseeding.rst
   ejercicios/index.rst
   referencias.rst


