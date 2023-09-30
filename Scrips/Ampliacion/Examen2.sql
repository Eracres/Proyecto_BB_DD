
/* EXAMEN SERGIO */

/*1-(0,5 PUNTOS) Crear un bloque PL/SQL que muestre el total de empleados y la media 
   de los sueldos (un decimal) de la tabla EMPLE.*/

	DECLARE 
		total NUMBER;
		media NUMBER(10,1);
	BEGIN
		SELECT COUNT(*), AVG(SALARIO) INTO total, media FROM EMPLE;
		DBMS_OUTPUT.PUT_LINE('HAY ' || total || ' EMPLEADOS CON UNA MEDIA DE SALARIO DE ' || media);
	END;
	/

/*2-(0,75 PUNTOS) Crear un bloque PL/SQL que muestre los 10 primeros múltiplos de un 
   numero dado e indique si es par o impar, el resultado sería*/
   
	Enter value for num: 75
	EL MULTIPLO NUMERO 1 DE 75 ES 75 Y ES IMPAR
	EL MULTIPLO NUMERO 2 DE 75 ES 150 Y ES PAR
	EL MULTIPLO NUMERO 3 DE 75 ES 225 Y ES IMPAR
	EL MULTIPLO NUMERO 4 DE 75 ES 300 Y ES PAR
	EL MULTIPLO NUMERO 5 DE 75 ES 375 Y ES IMPAR
	EL MULTIPLO NUMERO 6 DE 75 ES 450 Y ES PAR
	EL MULTIPLO NUMERO 7 DE 75 ES 525 Y ES IMPAR
	EL MULTIPLO NUMERO 8 DE 75 ES 600 Y ES PAR
	EL MULTIPLO NUMERO 9 DE 75 ES 675 Y ES IMPAR
	EL MULTIPLO NUMERO 10 DE 75 ES 750 Y ES PAR

	DECLARE 
		num NUMBER := &num;
		resultado NUMBER;
		par_impar VARCHAR(8);
	BEGIN
		FOR i IN 1..10 LOOP
			resultado := num * i;
			IF resultado MOD 2 = 0 THEN
				par_impar := 'PAR';
			ELSE
				par_impar := 'IMPAR';
			END IF;
			DBMS_OUTPUT.PUT_LINE('EL MULTIPLO NUMERO ' || i || ' DE ' || num ||' ES ' || resultado ||' Y ES ' || par_impar);
		END LOOP;
	END;
	/

/*3-(0.75 PUNTOS) Escribir un procedimiento para subir el sueldo de los empleados pasando 
  como parámetro el nº del empleado. Se subirá en un 10% si su fecha de alta en la 
  empresa es anterior a 1992, en caso contrario se le bajará un 5%. 
  Se mostrará por pantalla el nombre del empleado, el salario anterior y el salario 
  nuevo. Controlar la excepción si no existe el nº del empleado.*/
  
  CREATE OR REPLACE PROCEDURE subir_sueldo (num_emple EMPLE.EMP_NO%TYPE) IS
	fecha DATE;
	nombre VARCHAR(20);
	sal_emple NUMBER;
	sal_incre NUMBER;
	incre NUMBER := 1.10;
	decre NUMBER := 0.95;
  BEGIN
	
	SELECT APELLIDO, SALARIO, FECHA_ALT 
	INTO nombre, sal_emple, fecha 
	FROM EMPLE 
	WHERE EMP_NO = num_emple;
	
	IF TO_CHAR(fecha, 'YEAR') < '1992' THEN
		sal_incre := sal_emple * incre;
	ELSE
		sal_incre := sal_emple * decre;
	END IF;
	DBMS_OUTPUT.PUT_LINE(nombre || ' tenia un salariod de ' || sal_emple || ' ahora es de ' || sal_incre);
  EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('NO EXISTE EL EMPLEADO');
  END;
  /
	  
/*4-(0.75 PUNTOS) Escribir un procedimiento que reciba como parámetro un nº de 
   empleado y deberá generar:
   
	 Una excepción soy jefe, si su oficio es presidente, que mostrará el mensaje 
		de error “Soy jefe y por eso no quiero continuar” y terminará la ejecución 
		del procedimiento.
	 Una excepción soy gil, si se llama Gil, que simplemente mostrará un mensaje 
		“Te aviso de que soy Gil, ten cuidadito conmigo”, informando de la excepción.
	 Escribir el nombre, oficio y salario del empleado si no cumple ninguna de las 
	  condiciones anteriores
*/
	CREATE OR REPLACE PROCEDURE errores (num_emple EMPLE.EMP_NO%TYPE) IS
		err_presi EXCEPTION;
		err_gil EXCEPTION;
		nombre VARCHAR(20);
		ofic VARCHAR(20);
		sala NUMBER;
	BEGIN
		
		SELECT APELLIDO, OFICIO, SALARIO INTO nombre, ofic, sala FROM EMPLE WHERE EMP_NO = num_emple;
		
		IF nombre = 'GIL' THEN
			RAISE err_gil;
		ELSIF ofic = 'PRESIDENTE' THEN
			RAISE err_presi;
		ELSE
			DBMS_OUTPUT.PUT_LINE(nombre || '--*--' || ofic || '--*--' || sala);
		END IF;
	EXCEPTION
		WHEN err_gil THEN
			DBMS_OUTPUT.PUT_LINE('Te aviso de que soy Gil, ten cuidadito conmigo');
		WHEN err_presi THEN 
			DBMS_OUTPUT.PUT_LINE('Soy jefe y por eso no quiero continuar');
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('El empleado no existe');
	END;
	/
/*	
5-(0.5 PUNTOS) Mediante una función usa la estructura condicional adecuada para mostrar el día de la 
	semana según un valor de entrada numérico, 1 para domingo, 2 lunes, etc.
*/
	CREATE OR REPLACE FUNCTION dias (num NUMBER) RETURN VARCHAR IS
		dia_sem VARCHAR(15);
	BEGIN
		CASE num
			WHEN 1 THEN dia_sem := 'LUNES';
			WHEN 2 THEN dia_sem := 'MARTES';
			WHEN 3 THEN dia_sem := 'MIERCOLES';			
			WHEN 4 THEN dia_sem := 'JUEVES';			
			WHEN 5 THEN dia_sem := 'VIERNES';			
			WHEN 6 THEN dia_sem := 'SABADO';			
			WHEN 7 THEN dia_sem := 'DOMINGO';
			ELSE dia_sem := 'NO EXISTE';
		END CASE;
		RETURN dia_sem;
	END;
	/
	
	DECLARE
		num NUMBER := &num;
	BEGIN
		dias(num);
	END;
	/
/*
6-(0.75 PUNTOS) Mostrar nombre, oficio, y nombre de departamento de todos los empleados. 
   También se quiere saber cuántos empleados hay en la empresa.

	1-SALA VENDEDOR VENTAS
	2-NEGRO DIRECTOR VENTAS
	3-GIL ANALISTA INVESTIGACION
	4-JIMENEZ DIRECTOR INVESTIGACION
	5-FERNANDEZ ANALISTA INVESTIGACION
	6-TOVAR VENDEDOR VENTAS
	7-MARTIN VENDEDOR VENTAS
	8-ALONSO EMPLEADO INVESTIGACION
	9-JIMENO EMPLEADO VENTAS
	10-SANCHEZ EMPLEADO INVESTIGACION
	11-CEREZO DIRECTOR CONTABILIDAD
	12-REY PRESIDENTE CONTABILIDAD
	13-ARROYO VENDEDOR VENTAS
	14-MUÑOZ EMPLEADO CONTABILIDAD
	HAY 14 EMPLEADOS EN LA EMPRESA DEBERIAN SER 13 PUES, REY ES EL PRESIDENTE
*/
	CREATE OR REPLACE PROCEDURE lista IS
		CURSOR C6 IS
			SELECT E.APELLIDO, E.OFICIO, D.DNOMBRE FROM EMPLE E, DEPART D WHERE E.DEPT_NO = D.DEPT_NO; 
		total NUMBER;
	BEGIN
		FOR i IN C6 LOOP
			DBMS_OUTPUT.PUT_LINE(C6%ROWCOUNT || '-' || i.APELLIDO || ' ' || i.OFICIO || ' ' || i.DNOMBRE);
		END LOOP;
		DBMS_OUTPUT.PUT_LINE('HAY ' || i || ' EMPLEADOS EN LA EMPRESA DEBERIAN SER 13 PUES, ' || REY ES EL PRESIDENTE);
	END;
	/
/*
7- (0.75 PUNTOS) Una librería almacena los datos de sus libros en una tabla denominada “libros” y controla las acciones que los empleados realizan sobre dicha tabla almacenando en la tabla “control” el nombre del usuario, la fecha, y el tipo de modificación que se realizó sobre la tabla “libros”.

7.1 – Crear las tablas con las siguientes estructuras:
	Crea la table libros:		crea la tabla control:
	codigo number(6) 		 usuario varchar2(30)
	titulo varchar2(40)		 fecha date
	autor varchar2(30)		 operación varchar2(20)
	editorial varchar2(20		
	precio number(6,2)
*/	
	DROP TABLE LIBROS;
	
	CREATE TABLE LIBROS(
	CODIGO NUMBER(6),
	TITULO VARCHAR(40),
	AUTOR VARCHAR(30),
	EDITORIAL VARCHAR2 (20),
	PRECIO NUMBER(6,2) 
	);

	DROP TABLE CONTROL;
	
	CREATE TABLE CONTROL (
	USUARIO VARCHAR2(30),
	FECHA DATE,
	OPERACION VARCHAR2(20)
	);
/*	
7.2 – Crear un disparador que se active cuando insertamos un nuevo registro en “libros”, 
	debe almacenar en “control” el nombre del usuario que realiza la inserción, 
	la fecha e “inserción” en “operación” (0.25PUNTOS JUNTO CON EL 7.1 y 7.3)
*/	
	CREATE OR REPLACE TRIGGER control_insert
	AFTER INSERT ON LIBROS
	BEGIN
		INSERT INTO CONTROL (USUARIO, FECHA, OPERACION) VALUES (USER, SYSDATE, 'INSERCION');
	END;
	/
/*	
7.3 – Insertar los siguiente registros en “libros” y comprobar en la tabla control:
	Insert into libros values(100, ‘Uno’, ‘Richard Bach’, ‘Planeta’, 25);
	Insert into libros values(103, ‘El aleph’, ‘Borges’, ‘Emece’, 28);		
	Insert into libros values(105, ‘Matematica estas ahí’, ‘Paenza’, ‘Nuevo siglo’, 12);
	Insert into libros values(120, ‘Aprenda PHP’, 'Molina Mario’, ‘Nuevo siglo’, 55);
	Insert into libros values(145, ‘Alicia en el pais de las maravillas’, ‘Carroll’, ‘Planeta’, 35);
*/
/*	
7.4 – Crear otro trigger sobre “libros” que se active cuando eliminamos un registro de “libros”,
	debe almacenar en “control” el nombre del usuario que realiza la eliminación, la fecha y 
	“borrado” en “operación”(0.25PUNTOS JUNTO CON EL 7.5)
*/	
	CREATE OR REPLACE TRIGGER control_d
	BEFORE DELETE ON LIBROS
	BEGIN
		INSERT INTO CONTROL (USUARIO, FECHA, OPERACION) VALUES (USER, SYSDATE, 'BORRADO');
	END;
	/
/*	
7.5 – Borrar un libro de “libros” y comprobar que el trigger de borrado se dispara mirando los registros de “control”
*/
	DELETE FROM LIBROS WHERE CODIGO = 103;
/*
7.6 – Crear un tercer trigger sobre “libros” que se active cuando modificamos un registro de “libros”, 
	debe almacenar en “control” el nombre del usuario que realiza la modificación, la fecha 
	y “modificado” en “operación”(0.25PUNTOS JUNTO CON EL 7.7)
*/	
	CREATE OR REPLACE TRIGGER control_insert
	BEFORE UPDATE ON LIBROS
	BEGIN
		INSERT INTO CONTROL (USUARIO, FECHA, OPERACION) VALUES (USER, SYSDATE, 'MODIFICADO');
	END;
	/
/*	
7.7 – Actualizar la editorial de varios libros y comprobar que el trigger de actualización se dispara mirando los registros de “control”
*/
	UPDATE LIBROS SET EDITORIAL = 'Canaya' WHERE CODIGO = 145;
/*
8- (1 PUNTO) Crear una tabla llamada NUMEROS y tiene una columna que se llama colum1. 
*/	
	DROP TABLE NUMEROS CASCADE CONSTRAINT;
	
	CREATE TABLE NUMEROS(
		COLUMN1 NUMBER
	);
/*	
8.1-Hacer un bloque PL/SQL para introducir en la columna los números del 1 al 10 
	excepto 3 y 8 (0.25PUNTOS)
*/	
	DECLARE
	BEGIN
		FOR i IN 1..10 LOOP
			IF i = 3 THEN
				CONTINUE;
			ELSIF i = 8 THEN
				CONTINUE;
			ELSE
				INSERT INTO NUMEROS VALUES (i);
			END IF;
		END LOOP;
	END;
	/
/*	
8.2 – Añadir la colmn2 en la tabla NUMEROS en la cual los valores de la columna1 se eleven al cuadrado(0.25PUNTOS)
	
	

8.3- Añadir en la tabla NUMEROS la colum3 y escribir la palabra par o impar dependiendo del valor que contenga la columna2 (0.5PUNTOS)
	COL1  COL2  COL3
	------------------------
	     1          1  impar
	     2          4  par
	     4        16  par
	     5        25  impar
	     6        36  par
	     7        49  impar
	     9        81  impar
	     10    100  par




9- (1 PUNTO) Hacer una función que calcule el factorial de un número y que se utilice dicha función. Ejemplo de factorial y salida por pantalla: 4! = 4*3*2*1 resultado 24


10- (1 PUNTO) Obtener el siguiente listado de los datos del departamento y sus empleados.
10 CONTABILIDAD
---- CEREZO  7782 
---- REY 7839 
---- MU?OZ  7934 
20 INVESTIGACION
---- SANCHEZ 7369 
---- JIMENEZ 7566 
---- GIL 7788 
---- ALONSO 7876
---- FERNANDEZ 7902 
30 VENTAS
---- ARROYO 7499
---- SALA 7521 
---- MARTIN 7654
---- NEGRO 7698
---- TOVAR 7844
---- JIMENO 7900
40 PRODUCCION

11- (2 PUNTOS) Se trata de controlar los presupuestos de los distintos departamentos, manteniendo en una tabla los valores actualizados de la suma total de dinero que cada departamento gasta en salarios de los empleados.
	
10.1- (0.5 PUNTOS) Crear la tabla DEPT_BUDGET con las siguientes columnas:
		dept_no 	NUMBER(2)
		total_sal	NUMBER(10)

Crear un procedimiento PL/SQL para llenarla con la suma de los salarios de cada departamento de la table EMPLE.
		
10.2. (1.5 PUNTOS) Crear un trigger que actualice la tabla DEPT_BUDGET cuando se producen los siguientes eventos en EMPLE:
- Si se borra un empleado, se resta su salario del total del departamento en la tabla dept_budget.
-Si se añade un empleado, su salario se suma al total del departamento en la tabla dept_budget.
-Si un empleado cambia de departamento, su antiguo salario se resta del total de su antiguo departamento, y su nuevo salario se suma al total del nuevo departamento.
*/