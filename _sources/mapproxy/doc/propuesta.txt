Propuesta TALLER: Introducción a MapProxy y configuración básica
====================================================

Facilitadores:
---------------------------

Ferrer Matoses, Pedro -Juan
Sanz Salinas, Jorge Gaspar

Nivel: Básico
---------------------------

Los asistentes deberán conocer conceptos básicos del servicio WMS, manejo básico
de consola linux (cambiar de carpeta, listar contenidos).

Descripción:
---------------------------

MapProxy es un servidor de teselas y proxy WMS Open Source, acelera las
aplicaciones de mapas a través de la pregeneración de tiles integrando múltiples
fuentes de datos y almacenándolos en una caché local.

El objetivo del taller es dar a conocer la aplicación MapProxy; explicando
cuales son sus funcionalidades básicas, cuales son sus potencialidades, repasar
algunos casos de éxito y finalmente escribir y desplegar una configuración
básica con las opciones más comunes.

La primera parte del taller consistirá en realizar una introducción, instalación
del software, creación de un proyecto de ejemplo y comprobar su funcionamiento.

En la segunda parte del taller se revisarán algunos casos de uso de la
aplicación y se realizarán ejercicios que resuelvan algunas de las dudas más
frecuentes a la hora de empezar a usar este software.

Aplicaciones necesarias:
------------------------------------------

SO Linux de Escritorio basado en Debian/Ubuntu con los siguientes paquetes
instalados:


- Navegador web
- Consola
- Editor de ficheros (gedit sirve pero vim its a win!!!)
- Algunas librerías de desarrollo y componentes Python

Materiales necesarios:
------------------------------------------


- Equipo con máquina virtual y conexión a internet
- Documentación del taller


Programa
---------------------------------

Bloque Presentación:
+++++++++++++++++++++++

#. Agenda
#. Mover a los no linuxeros
#. Introducción de Mapproxy
#. Origenes del proyecto
#. A donde va

(~30 min)

Bloque Instalación:
++++++++++++++++++++++++++

#. Entornos virtuales en Python
#. Crear el “venv”
#. Instalar componentes
#. Archivo de configuración
#. Ejecución del servidor de desarrollo
#. Ejercicio de instalación

(~45 min)

Bloque Configuración de MapProxy:
+++++++++++++++++++++++++++++++++++

#. Los archivos de configuración (servicio y seeding)
#. Archivos YAML
#. Organizado de mayor a menor/de fuera hacia dentro/de como se ofrece a como
         se guarda
#. Explicar el árbol Sevicio/Capa/Origen/Cache/Grid/Opciones globales y que
         las relaciones pueden ser uno a muchos

Viendo el archivo de configuración del ejercicio anterior, ir explicando (sin
entrar en detalle que eso se hace luego) los siguientes puntos

#. Servicios -> cómo se configuran (las más habituales)
#. Capas

   #. Origenes de datos
   #. Estructura en árbol

#. Caché -> Grid y Source
#. Source -> Origenes soportados por MP
#. Grids ->
#. Globals -> Importante dónde se guarda la caché

Archivo de Seeding

#. Seeding
#. Cleaning
#. Coberturas

(~45 min y descanso)

Bloque Práctico
+++++++++++++++++++++++++++++++++++++++

#. Explicar para qué sirve MapProxy

    #. Casos de uso {pequeña explicación del caso de uso con gráficos}

       #. Acelerar el acceso a un WMS habitual

       #. Generar WMS de OSM

       #. Meter "Coberturas" [son ROI de MapProxy]

       #. Seeding y cleaning

       #. Reproyectar y cachear un servicio de teselas externo

(~30 min)

#. Ejercicios

   #. Acelerar el acceso a un WMS habitual y convertir OSM (TMS) en un servicio
         WMS. (ejercicio guiado -> 20 min)

   #. Reproyectar y cachear un TMS externo.

   #. Seeding y cleaning y Coberturas.

(~30 min por ejercicio)

#. Opciones de despliegue y cierre

   #. Explicar como se despliega en producción

        #. como fastcgi

        #. como aplicacion wsgi

    #. Conclusiones (repaso de lo que hemos visto e invitación a temas
           avanzados)

(~20 min)

#. Avanzados

   #. Ofrecer WMTS/TMS de servicios propios

   #. Restructurar árboles de capas como un nuevo servicio

   #. Redirigir el getLegendgraphic y el getFeatureInfo

   #. Publicar servicios diseñados con TileMill (MBTiles o el XML de Mapnik)

   #. Modo multimapa
