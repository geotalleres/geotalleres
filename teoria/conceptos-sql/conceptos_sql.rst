
************************
Conceptos básicos de SQL
************************

Introducción
============
El lenguaje de consulta estructurado o SQL (por sus siglas en inglés **Structured Query Language**) es un lenguaje declarativo de acceso a bases de datos relacionales que permite especificar diversos tipos de operaciones en ellas. Una de sus características es el manejo del álgebra y el cálculo relacional que permiten efectuar consultas con el fin de recuperar de forma sencilla información de interés de bases de datos, así como hacer cambios en ella.

El SQL es un lenguaje de acceso a bases de datos que explota la flexibilidad y potencia de los sistemas relacionales y permite así gran variedad de operaciones.

Componentes del SQL
===================
El lenguaje SQL está compuesto por comandos, cláusulas, operadores y funciones de agregado. Estos elementos se combinan en las instrucciones para crear, actualizar y manipular las bases de datos.

Comandos
--------
Existen tres tipos de comandos SQL:

Los **DLL(Data Definition Language)** que permiten crear y definir nuevas bases de datos, campos e índices.
Los **DML(Data Manipulation Language)** que permiten generar consultas para ordenar, filtrar y extraer datos de la base de datos.
Los **DCL(Data Control Language)** que se encargan de definir las permisos sobre los datos

Lenguaje de definición de datos (DDL)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

	+-----------------------+--------------------------------------------------------+
	| **Comando**           | **Descripción**                                        +
	+-----------------------+--------------------------------------------------------+
	| CREATE                | Utilizado para crear nuevas tablas, campos e índices   |
	+-----------------------+--------------------------------------------------------+
	| DROP                  | Empleado para eliminar tablas e índices                |
	+-----------------------+--------------------------------------------------------+
	| ALTER                 | Utilizado para modificar las tablas agregando          |
	|                       | campos o cambiando la definición de los campos.        |
	+-----------------------+--------------------------------------------------------+


El lenguaje de definición de datos (en inglés Data Definition Language, o DDL), es el que se encarga de la modificación de la estructura de los objetos de la base de datos. Incluye órdenes para modificar, borrar o definir las tablas en las que se almacenan los datos de la base de datos. Existen cuatro operaciones básicas: CREATE, ALTER, DROP y TRUNCATE.

CREATE
""""""
Este comando crea un objeto dentro del gestor de base de datos. Puede ser una base de datos, tabla, índice, procedimiento almacenado o vista.

Ejemplo (crear una tabla)::
	
	# CREATE TABLE Empleado
	(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	Nombre VARCHAR(50),
	Apellido VARCHAR(50),
	Direccion VARCHAR(255),
	Ciudad VARCHAR(60),
	Telefono VARCHAR(15),
	Peso VARCHAR (5),
	Edad (2),
	Actividad Específica (100),
	idCargo INT
	)

ALTER
"""""
Este comando permite modificar la estructura de un objeto. Se pueden agregar/quitar campos a una tabla, modificar el tipo de un campo, agregar/quitar índices a una tabla, modificar un trigger, etc.

Ejemplo (agregar columna a una tabla)::
	
	# ALTER TABLE 'NOMBRE_TABLA' ADD NUEVO_CAMPO INT;
	# ALTER TABLE 'NOMBRE_TABLA' DROP COLUMN NOMBRE_COLUMNA;

DROP
""""
Este comando elimina un objeto de la base de datos. Puede ser una tabla, vista, índice, trigger, función, procedimiento o cualquier otro objeto que el motor de la base de datos soporte. Se puede combinar con la sentencia ALTER.

Ejemplo::
	
	# DROP TABLE 'NOMBRE_TABLA';
	# DROP SCHEMA 'ESQUEMA;'
	# DROP DATABASE 'BASEDATOS';

TRUNCATE
""""""""
Este comando trunca todo el contenido de una tabla. La ventaja sobre el comando DROP, es que si se quiere borrar todo el contenido de la tabla, es mucho más rápido, especialmente si la tabla es muy grande. La desventaja es que TRUNCATE sólo sirve cuando se quiere eliminar absolutamente todos los registros, ya que no se permite la cláusula WHERE. Si bien, en un principio, esta sentencia parecería ser DML (Lenguaje de Manipulación de Datos), es en realidad una DDL, ya que internamente, el comando TRUNCATE borra la tabla y la vuelve a crear y no ejecuta ninguna transacción.

Ejemplo::
	
	# TRUNCATE TABLE 'NOMBRE_TABLA';

Prácticas
---------

Práctica 1
^^^^^^^^^^

Definir mediante comandos SQL el modelo de datos creado para los Parques Naturales de Costa Rica

Lenguaje de manipulación de datos DML(Data Manipulation Language)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

	+-----------------------+--------------------------------------------------------+
	| **Comando**           | **Descripción**                                        +
	+-----------------------+--------------------------------------------------------+
	| SELECT                | Utilizado para consultar registros de la base de datos |
	|                       | que satisfagan un criterio determinado                 |
	+-----------------------+--------------------------------------------------------+
	| INSERT                |Utilizado para cargar lotes de datos en la base de datos|
	|                       |en una única operación.                                 |
	+-----------------------+--------------------------------------------------------+
	| UPDATE                | Utilizado para modificar los valores de los campos y   |
	|                       | registros especificados Utilizado para modificar las   |
	|                       | tablas agregando campos o cambiando la definición de   |
	|                       | los campos.                                            |
	+-----------------------+--------------------------------------------------------+
	| DELETE                | Utilizado para eliminar registros de una tabla         |
	+-----------------------+--------------------------------------------------------+



Definición
""""""""""
Un lenguaje de manipulación de datos (Data Manipulation Language, o DML en inglés) es un lenguaje proporcionado por el sistema de gestión de base de datos que permite a los usuarios llevar a cabo las tareas de consulta o manipulación de los datos, organizados por el modelo de datos adecuado.
El lenguaje de manipulación de datos más popular hoy día es SQL, usado para recuperar y manipular datos en una base de datos relacional.

INSERT
""""""
Una sentencia INSERT de SQL agrega uno o más registros a una (y sólo una) tabla en una base de datos relacional.

Forma básica::

	# INSERT INTO ''tabla'' (''columna1'', [''columna2,... '']) VALUES (''valor1'', [''valor2,...''])
	
Las cantidades de columnas y valores deben ser iguales. Si una columna no se especifica, le será asignado el valor por omisión. Los valores especificados (o implícitos) por la sentencia INSERT deberán satisfacer todas las restricciones aplicables. Si ocurre un error de sintaxis o si alguna de las restricciones es violada, no se agrega la fila y se devuelve un error.

Ejemplo::

	# INSERT INTO agenda_telefonica (nombre, numero) VALUES ('Roberto Jeldrez', 4886850);

Cuando se especifican todos los valores de una tabla, se puede utilizar la sentencia acortada::

	# INSERT INTO ''VALUES (''valor1'', [''valor2,...''])

Ejemplo (asumiendo que 'nombre' y 'número' son las únicas columnas de la tabla 'agenda_telefonica')::

	# INSERT INTO agenda_telefonica VALUES ('Jhonny Aguiar', 080473968);

UPDATE
""""""
Una sentencia UPDATE de SQL es utilizada para modificar los valores de un conjunto de registros existentes en una tabla.

Ejemplo::
	
	# UPDATE mi_tabla SET campo1 = 'nuevo valor campo1' WHERE campo2 = 'N';

DELETE
""""""
Una sentencia DELETE de SQL borra uno o más registros existentes en una tabla.

Forma básica::
	
	# DELETE FROM 'tabla' WHERE 'columna1' = 'valor1'

Ejemplo::

	# DELETE FROM My_table WHERE field2 = 'N';
	
Prácticas
---------

Práctica 1
----------

Extraer de Wikipedia la información necesaria para insertar en el modelo de datos creado para Parques Nacionales y desarrollar en un script mediante sentencias SQL.
	
Clausulas
^^^^^^^^^
Las cláusulas son condiciones de modificación utilizadas para definir los datos que desea seleccionar o manipular.

+-----------------------+--------------------------------------------------------+
| **Comando**           | **Descripción**                                        +
+-----------------------+--------------------------------------------------------+
| FROM                  | Utilizada para especificar la tabla de la cual se van a|
|                       | seleccionar los registros                              |
+-----------------------+--------------------------------------------------------+
| GROUP BY              | Utilizada para separar los registros seleccionados en  |
|                       | grupos específicos                                     |
+-----------------------+--------------------------------------------------------+
| HAVING                | Utilizada para expresar condición que debe satisfacer  |
|                       | cada grupo                                             |
+-----------------------+--------------------------------------------------------+
| ORDER BY              | Utilizada para ordenar los registros seleccionados de  |
|                       | acuerdo con un orden específico                        |
+-----------------------+--------------------------------------------------------+
| WHERE                 | Utilizada para determinar los registros seleccionados  |
|                       | en la clausula FROM                                    |
+-----------------------+--------------------------------------------------------+

Operadores
^^^^^^^^^^
Operadores Lógicos
""""""""""""""""""

+---------------------------+--------------------------------------------------------+
| **Operador**              | **Uso**                                                +
+---------------------------+--------------------------------------------------------+
| AND                       | Es el “y” lógico. Evalúa dos condiciones y devuelve un |
|                           | valor de verdad sólo si ambas son ciertas.             |
+---------------------------+--------------------------------------------------------+
| OR                        | Es el “o” lógico. Evalúa dos condiciones y devuelve un |
|                           | valor de verdad si alguna de las dos es cierta.        |
+---------------------------+--------------------------------------------------------+
| NOT                       | Negación lógica. Devuelve el valor contrario de la     |
|                           | expresión.                                             |
+---------------------------+--------------------------------------------------------+	
	
Operadores de comparación
"""""""""""""""""""""""""

+--------------------------------------------------+------------------+
| **Operador**                                     | **Uso**          +
+--------------------------------------------------+------------------+
| <                                                | Menor que        +
+--------------------------------------------------+------------------+
| >                                                | Mayor que        +
+--------------------------------------------------+------------------+
| <>                                               | Distinto de      +
+--------------------------------------------------+------------------+
| <=                                               | Menor o igual que+
+--------------------------------------------------+------------------+
| >=                                               | Mayor o igual que+
+--------------------------------------------------+------------------+
| BETWEEN                                          | Intervalo        +
+--------------------------------------------------+------------------+
| LIKE                                             | Comparación      +
+--------------------------------------------------+------------------+	
| In                                               | Especificar      +
+--------------------------------------------------+------------------+	

Funciones de agregado
^^^^^^^^^^^^^^^^^^^^^
Las funciones de agregado se usan dentro de una cláusula SELECT en grupos de registros para devolver un único valor que se aplica a un grupo de registros.

+--------------------------------------------------+--------------------------------------------------------+
| **Comando**                                      | **Descripción**                                        +
+--------------------------------------------------+--------------------------------------------------------+
| AVG                                              | Utilizada para calcular el promedio de los valores de  |
|                                                  | un campo determinado                                   |
+--------------------------------------------------+--------------------------------------------------------+
| COUNT                                            | Utilizada para devolver el número de registros de la   |
|                                                  | selección                                              |
+--------------------------------------------------+--------------------------------------------------------+
| SUM                                              | Utilizada para devolver la suma de todos los valores de|
|                                                  | un campo determinado                                   |
+--------------------------------------------------+--------------------------------------------------------+
| MAX                                              | Utilizada para devolver el valor más alto de un campo  |
|                                                  | especificado                                           |
+--------------------------------------------------+--------------------------------------------------------+ 
| MIN                                              | Utilizada para devolver el valor más bajo de un campo  |
|                                                  | especificado                                           |
+--------------------------------------------------+--------------------------------------------------------+

Consultas
=========
Consultas de selección
----------------------
Las consultas de selección se utilizan para indicar al motor de datos que devuelva información de las bases de datos, esta información es devuelta en forma de conjunto de registros. Este conjunto de registros es modificable.

Básicas
^^^^^^^
La sintaxis básica de una consulta de selección es::

	# SELECT Campos FROM Tabla;
	# SELECT Nombre, Telefono FROM Clientes;
	
Ordenar los registros
^^^^^^^^^^^^^^^^^^^^^
Se puede especificar el orden en que se desean recuperar los registros de las tablas mediante la clausula **ORDER BY**::

	# SELECT CodigoPostal, Nombre, Telefono FROM Clientes ORDER BY Nombre;

Se pueden ordenar los registros por mas de un campo::

	# SELECT CodigoPostal, Nombre, Telefono FROM Clientes ORDER BY CodigoPostal, Nombre;
	
Y se puede especificar el orden de los registros: ascendente mediante la claúsula (**ASC** -se toma este valor por defecto) ó descendente (**DESC**)::

	# SELECT CodigoPostal, Nombre, Telefono FROM Clientes ORDER BY CodigoPostal DESC , Nombre ASC;
	
Consultas con predicado
^^^^^^^^^^^^^^^^^^^^^^^

1. ALL Si no se incluye ninguno de los predicados se asume ALL. El Motor de base de datos selecciona todos los registros que cumplen las condiciones de la instrucción SQL::

		# SELECT ALL FROM Empleados;
		# SELECT * FROM Empleados;
	
2. TOP Devuelve un cierto número de registros que entran entre al principio o al final de un rango especificado por una cláusula ORDER BY. Supongamos que queremos recuperar los nombres de los 25 primeros estudiantes del curso 1994::

		# SELECT TOP 25 Nombre, Apellido 
		FROM Estudiantes 
		ORDER BY Nota DESC;

	Si no se incluye la cláusula ORDER BY, la consulta devolverá un conjunto arbitrario de 25 registros de la tabla Estudiantes .El predicado TOP no elige entre valores iguales. En el ejemplo anterior, si la nota media número 25 y la 26 son iguales, la consulta devolverá 26 registros. Se puede utilizar la palabra reservada PERCENT para devolver un cierto porcentaje de registros que caen al principio o al final de un rango especificado por la cláusula ORDER BY. Supongamos que en lugar de los 25 primeros estudiantes deseamos el 10 por ciento del curso::

		# SELECT TOP 10 PERCENT Nombre, Apellido
		FROM Estudiantes
		ORDER BY Nota DESC; 

3. DISTINCT Omite los registros que contienen datos duplicados en los campos seleccionados. Para que los valores de cada campo listado en la instrucción SELECT se incluyan en la consulta deben ser únicos::

		# SELECT DISTINCT Apellido FROM Empleados;

4. DISTINCTROW Devuelve los registros diferentes de una tabla; a diferencia del predicado anterior que sólo se fijaba en el contenido de los campos seleccionados, éste lo hace en el contenido del registro completo independientemente de los campo indicados en la cláusula SELECT::

		# SELECT DISTINCTROW Apellido FROM Empleados;

Criterios de selección
----------------------
Operadores Lógicos
^^^^^^^^^^^^^^^^^^
Los operadores lógicos soportados por SQL son:
	
	**AND, OR, XOR, Eqv, Imp, Is** y **Not.**
	
A excepción de los dos últimos todos poseen la siguiente sintaxis::

	<expresión1> operador <expresión2>

En donde expresión1 y expresión2 son las condiciones a evaluar, el resultado de la operación varía en función del operador lógico::

	# SELECT * FROM Empleados WHERE Edad > 25 AND Edad < 50; 
	# SELECT * FROM Empleados WHERE (Edad > 25 AND Edad < 50) OR Sueldo = 100; 
	# SELECT * FROM Empleados WHERE NOT Estado = 'Soltero'; 
	# SELECT * FROM Empleados WHERE (Sueldo > 100 AND Sueldo < 500) OR (Provincia = 'Madrid' AND Estado = 'Casado');
	
Operador **BETWEEN**
^^^^^^^^^^^^^^^^^^^^
Para indicar que deseamos recuperar los registros según el intervalo de valores de un campo emplearemos el operador **Between**::

	# SELECT * FROM Pedidos WHERE CodPostal Between 28000 And 28999; 
	(Devuelve los pedidos realizados en la provincia de Madrid) 

	# SELECT IIf(CodPostal Between 28000 And 28999, 'Provincial', 'Nacional') FROM Editores;
	(Devuelve el valor 'Provincial' si el código postal se encuentra en el intervalo,'Nacional' en caso contrario)
	
Operador **LIKE**
^^^^^^^^^^^^^^^^^
Se utiliza para comparar una expresión de cadena con un modelo en una expresión SQL. Su sintaxis es::

	expresión LIKE modelo

Operador **IN**
^^^^^^^^^^^^^^^
Este operador devuelve aquellos registros cuyo campo indicado coincide con alguno de los indicados en una lista. Su sintaxis es::

	expresión [Not] In(valor1, valor2, . . .)
	
	# SELECT * FROM Pedidos WHERE Provincia In ('Madrid', 'Barcelona', 'Sevilla');
	
Clausula **WHERE**
^^^^^^^^^^^^^^^^^^
La cláusula WHERE puede usarse para determinar qué registros de las tablas enumeradas en la cláusula FROM aparecerán en los resultados de la instrucción SELECT.  WHERE es opcional, pero cuando aparece debe ir a continuación de FROM::

	# SELECT Apellidos, Salario FROM Empleados 
	WHERE Salario > 21000;
	# SELECT Id_Producto, Existencias FROM Productos 
	WHERE Existencias <= Nuevo_Pedido;

Agrupamiento de registros (Agregación)
--------------------------------------
**AVG**
^^^^^^^
Calcula la media aritmética de un conjunto de valores contenidos en un campo especificado de una consulta::

	Avg(expr)
	
La función Avg no incluye ningún campo Null en el cálculo. Un ejemplo del funcionamiento de **AVG**::
	
	# SELECT Avg(Gastos) AS Promedio FROM 
	Pedidos WHERE Gastos > 100;
	
**MAX, MIN**
^^^^^^^^^^^^
Devuelven el mínimo o el máximo de un conjunto de valores contenidos en un campo especifico de una consulta. Su sintaxis es::

	Min(expr)
	Max(expr)
	
Un ejemplo de su uso::

	# SELECT Min(Gastos) AS ElMin FROM Pedidos 
	WHERE Pais = 'Costa Rica'; 
	# SELECT Max(Gastos) AS ElMax FROM Pedidos 
	WHERE Pais = 'Costa Rica';
	
**SUM**
^^^^^^^
Devuelve la suma del conjunto de valores contenido en un campo especifico de una consulta. Su sintaxis es::

	Sum(expr)
	
Por ejemplo::

	# SELECT Sum(PrecioUnidad * Cantidad) 
	AS Total FROM DetallePedido;

**GROUP BY**
^^^^^^^^^^^^
Combina los registros con valores idénticos, en la lista de campos especificados, en un único registro::

	# SELECT campos FROM tabla WHERE criterio 
 	GROUP BY campos del grupo
 	
Todos los campos de la lista de campos de SELECT deben o bien incluirse en la cláusula GROUP BY o como argumentos de una función SQL agregada::

	# SELECT Id_Familia, Sum(Stock) 
	FROM Productos GROUP BY Id_Familia;

HAVING es similar a WHERE, determina qué registros se seleccionan. Una vez que los registros se han agrupado utilizando GROUP BY, HAVING determina cuales de ellos se van a mostrar.

	# SELECT Id_Familia Sum(Stock) FROM Productos 
	GROUP BY Id_Familia 
	HAVING Sum(Stock) > 100 AND NombreProducto Like BOS*;

Manejo de varias tablas
=======================
Partiendo de la definición de las siguientes tablas:

1. **Tabla clientes** ::


	+------+--------+----------+
	| cid  | nombre | telefono |
	+------+--------+----------+
	|    1 | jose   | 111      | 
	|    2 | maria  | 222      |
	|    3 | manuel | 333      |
	|    4 | jesus  | 4444     | 
	+------+--------+----------+


2. **Tabla Acciones** ::


	+-----+-----+--------+----------+
	| aid | cid | accion | cantidad |
	+-----+-----+--------+----------+
	|   1 |   2 | REDHAT |      10  |
	|   2 |   4 | NOVELL |      20  |
	|   3 |   4 | SUN    |      30  |
	|   4 |   5 | FORD   |     100  |
	+-----+-----+--------+----------+
	
	
Cosultas mediante JOIN
----------------------
JOIN
^^^^
La sentencia SQL JOIN se utiliza para relacionar varias tablas. Nos permitirá obtener un listado de los campos que tienen coincidencias en ambas tablas::

	# select nombre, telefono, accion, cantidad from clientes join acciones on clientes.cid=acciones.cid;

resultando::
	
	+--------+----------+--------+----------+
	| nombre | telefono | accion | cantidad |
	+--------+----------+--------+----------+
	| maria  | 222      | REDHAT |       10 |
	| jesus  | 4444     | NOVELL |       20 |
	| jesus  | 4444     | SUN    |       30 | 
	+--------+----------+--------+----------+

LEFT JOIN
^^^^^^^^^
La sentencia LEFT JOIN nos dará el resultado anterior mas los campos de la tabla de la izquierda del **JOIN** que no tienen coincidencias en la tabla de la derecha::

	# select nombre, telefono, accion, cantidad from clientes left join acciones on clientes.cid=acciones.cid;

con resultado::
	
	+--------+----------+--------+----------+
	| nombre | telefono | accion | cantidad |
	+--------+----------+--------+----------+
	| jose   | 111      | NULL   |     NULL | 
	| maria  | 222      | REDHAT |       10 | 
	| manuel | 333      | NULL   |     NULL | 
	| jesus  | 4444     | NOVELL |       20 | 
	| jesus  | 4444     | SUN    |       30 | 
	+--------+----------+--------+----------+

RIGHT JOIN
^^^^^^^^^^
Identico funcionamiento que en el caso anterior pero con la tabla que se incluye en la consulta a la derecha del **JOIN**::

	# select nombre, telefono, accion, cantidad from clientes right join acciones on clientes.cid=acciones.cid;
	
cuyo resultado será::
	
	+--------+----------+--------+----------+
	| nombre | telefono | accion | cantidad |
	+--------+----------+--------+----------+
	| maria  | 222      | REDHAT |       10 | 
	| jesus  | 4444     | NOVELL |       20 | 
	| jesus  | 4444     | SUN    |       30 | 
	| NULL   | NULL     | FORD   |      100 | 
	+--------+----------+--------+----------+

UNION y UNION ALL
^^^^^^^^^^^^^^^^^
Podemos combinar el resultado de varias sentencias con UNION o UNION ALL. UNION no nos muestra los resultados duplicados, pero UNION ALL si los muestra::

	# select nombre, telefono, accion, cantidad from clientes left join acciones on clientes.cid=acciones.cid where accion is null union select nombre, telefono, accion, cantidad from clientes right join acciones on clientes.cid=acciones.cid where nombre is null;
	
que mostrará::

	+--------+----------+--------+----------+
	| nombre | telefono | accion | cantidad |
	+--------+----------+--------+----------+
	| jose   | 111      | NULL   |     NULL | 
	| manuel | 333      | NULL   |     NULL | 
	| NULL   | NULL     | FORD   |      100 | 
	+--------+----------+--------+----------+

Vistas
======

Las vistas (“views”) en SQL son un mecanismo que permite generar un resultado a partir de una consulta (query) almacenado, y ejecutar nuevas consultas sobre este resultado como si fuera una tabla normal. Las vistas tienen la misma estructura que una tabla: filas y columnas. La única diferencia es que sólo se almacena de ellas la definición, no los datos.

La cláusula CREATE VIEW permite la creación de vistas. La cláusula asigna un nombre a la vista y permite especificar la consulta que la define. Su sintaxis es::

	# CREATE VIEW id_vista [(columna,…)]AS especificación_consulta;
	
Opcionalmente se puede asignar un nombre a cada columna de la vista. Si se especifica, la lista de nombres de las columnas debe de tener el mismo número de elementos que elnúmero de columnas producidas por la consulta. Si se omiten, cada columna de la vista1 adopta el nombre de la columna correspondiente en la consulta. 
