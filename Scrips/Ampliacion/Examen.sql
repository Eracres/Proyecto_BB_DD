SET SERVEROUTPUT ON
SET VERIFY OFF

/*1-(0,5 PUNTOS) Crear un bloque PL/SQL que muestre el total de empleados y la media de los 
   sueldos (un decimal) de la tabla EMPLE.*/
   
   DECLARE
	emple_total NUMBER;
	med_salarios NUMBER(10,2);
   BEGIN
	SELECT COUNT(*), AVG(SALARIO) INTO emple_total, med_salarios FROM EMPLE;
	DBMS_OUTPUT.PUT_LINE('El numero de empleados es ' || emple_total || ' con un salario medio de ' || med_salarios);
   END;
   /
   
/*
2-(0,75 PUNTOS) Crear un bloque PL/SQL que muestre los 10 primeros múltiplos de un numero 
  dado e indique si es par o impar, el resultado sería
  
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
*/
	DECLARE
	valor NUMBER := &valor;
	counter NUMBER := 1;
	resultado NUMBER;
	par_o_impar VARCHAR(50);
   BEGIN
	LOOP
	resultado := valor * counter; 
		IF resultado MOD 2 = 0 THEN
			par_o_impar := 'PAR';
		ELSE
			par_o_impar := 'IMPAR';		
		END IF;		
	DBMS_OUTPUT.PUT_LINE('EL MULTIPLO NUMERO ' || counter || ' DE ' || valor || ' ES ' || resultado || ' Y ES ' || par_o_impar);
	counter := counter + 1;
	EXIT WHEN counter = 10;
	END LOOP;
   END;
   /

/*
3-(0.75 PUNTOS) Escribir un procedimiento para subir el sueldo de los empleados pasando como 
   parámetro el nº del empleado. Se subirá en un 10% si su fecha de alta en la empresa es anterior a 1992, 
   en caso contrario se le bajará un 5%. Se mostrará por pantalla el nombre del empleado, el salario anterior y el salario nuevo. 
   Controlar la excepción si no existe el nº del empleado.
*/  
   CREATE OR REPLACE PROCEDURE subir_salario(v_emple NUMBER) IS
		nombre VARCHAR(50);
		new_salario NUMBER;
		fecha DATE := '01/01/1992';
		salario EMPLE.SALARIO%TYPE;
		fecha_alta EMPLE.FECHA_ALT%TYPE;
   BEGIN
		SELECT SALARIO, FECHA_ALT INTO salario, fecha_alta FROM EMPLE WHERE EMP_NO = v_emple;
		IF fecha_alta < fecha THEN
			new_salario := 1.10;
		ELSE
			new_salario := 0.95;
		END IF;
			DBMS_OUTPUT.PUT_LINE('EL SALARIO ANTIGUO ERA: '||salario||' Y EL NUEVO ES: '||salario * new_salario);
			UPDATE EMPLE SET SALARIO =  salario * new_salario WHERE EMP_NO = v_emple;
   EXCEPTION
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('USUARIO NO ENCONTRADO');
   END;
   /
/*  
4-(0.75 PUNTOS) Escribir un procedimiento que reciba como parámetro un nº de empleado y deberá generar:
	Una excepción soy jefe, si su oficio es presidente, que mostrará el mensaje de error “Soy jefe y por eso no quiero continuar” y terminará la ejecución del procedimiento.
	Una excepción soy gil, si se llama Gil, que simplemente mostrará un mensaje “Te aviso de que soy Gil, ten cuidadito conmigo”, informando de la excepción.
	Escribir el nombre, oficio y salario del empleado si no cumple ninguna de las condiciones anteriores
*/
   CREATE OR REPLACE PROCEDURE excepcion(v_emple NUMBER) IS
		err_jefe EXCEPTION;
		err_gil EXCEPTION;
		nombre EMPLE.APELLIDO%TYPE;
		ofic EMPLE.OFICIO%TYPE;
		salario EMPLE.SALARIO%TYPE;
   BEGIN
		SELECT APELLIDO, OFICIO, SALARIO INTO nombre, ofic, salario FROM EMPLE WHERE EMP_NO = v_emple; 
		IF ofic = 'PRESIDENTE' THEN
			RAISE err_jefe;
		ELSIF nombre = 'GIL' THEN
			RAISE err_gil;
		ELSE
			DBMS_OUTPUT.PUT_LINE(nombre || ' ' || ofic || ' ' || salario);
		END IF;
   EXCEPTION
		WHEN err_jefe THEN
			DBMS_OUTPUT.PUT_LINE('Soy jefe y por eso no quiero continuar');
		WHEN err_gil THEN
			DBMS_OUTPUT.PUT_LINE('Te aviso de que soy Gil, ten cuidadito conmigo');
   END;
   /
   
   execute excepcion(7839);
   execute excepcion(7788);
   execute excepcion(7782);
/* 
5-(0.5 PUNTOS) Mediante una función usa la estructura condicional adecuada para mostrar el día de la semana según un 
   valor de entrada numérico, 1 para domingo, 2 lunes, etc.
*/	
	CREATE OR REPLACE FUNCTION semana(num NUMBER) RETURN VARCHAR IS
		dia VARCHAR(50);
	BEGIN
		CASE num
		WHEN 1 THEN dia := 'LUNES';
		WHEN 2 THEN dia := 'MARTES';
		WHEN 3 THEN dia := 'MIERCOLES';
		WHEN 4 THEN dia := 'JUEVES';
		WHEN 5 THEN dia := 'VIERNES';
		WHEN 6 THEN dia := 'SABADO';
		WHEN 7 THEN dia := 'DOMINGO';
		ELSE dia := 'DIA DESCONOCIDO';
		
		END CASE;
		
		RETURN dia;
	END;
	/
	
	SELECT semana() FROM DUAL;
/*		
6-(0.75 PUNTOS) Mostrar nombre, oficio, y nombre de departamento de todos los empleados. También se quiere saber cuántos empleados hay en la empresa.
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
	DECLARE 
		CURSOR C6 IS 
			SELECT e.APELLIDO, e.OFICIO, d.DNOMBRE 
			FROM EMPLE e, DEPART d 
			WHERE d.DEPT_NO = e.DEPT_NO;
		contador NUMBER;
		rey VARCHAR(50);
		presi VARCHAR(50);
	BEGIN
		FOR i IN C6 LOOP
			IF i.OFICIO = 'PRESIDENTE' THEN
				rey := i.APELLIDO;
				presi := i.OFICIO;
			END IF;
			DBMS_OUTPUT.PUT_LINE(C6%ROWCOUNT || '.- ' || i.APELLIDO || ' ' || i.OFICIO || ' ' || i.DNOMBRE);
		END LOOP;
		
		SELECT COUNT(*) INTO contador FROM EMPLE;
		
		DBMS_OUTPUT.PUT_LINE('HAY ' || contador || ' EMPLEADOS EN LA EMPRESA DEBERIAN SER 13 PUES, ' || rey || ' ES EL ' || presi);
	END;
	/
	   
	   
	DECLARE 
		CURSOR C6 IS
			SELECT E.APELLIDO, E.OFICIO, D.DNOMBRE
			FROM EMPLE E, DEPART D 
			WHERE E.DEPT_NO=D.DEPT_NO ORDER BY E.EMP_NO;
		CONT NUMBER;
		CONT2 NUMBER := 0;
		P_APELLIDO VARCHAR(40);
		P_OFICIO VARCHAR(40);
	BEGIN
		FOR EMPLEADO IN C6 LOOP
			IF EMPLEADO.OFICIO= 'PRESIDENTE' THEN 
				P_APELLIDO := EMPLEADO.APELLIDO;
				P_OFICIO := EMPLEADO.OFICIO;
			ELSE 
				CONT2 := CONT2+1;
			END IF;

				DBMS_OUTPUT.PUT_LINE(C6%ROWCOUNT  '-'  EMPLEADO.OFICIO ' ' 
				 EMPLEADO.APELLIDO  EMPLEADO.DNOMBRE);
				CONT := C6%ROWCOUNT;
		END LOOP;
		DBMS_OUTPUT.PUT_LINE('EL NUMERO DE EMPLEADOS ES: '  CONT  
		', DEBERIAN SER 'CONT2  ' PERO '  P_APELLIDO ' ES '  P_OFICIO);
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
	  
	  
	SET SERVEROUTPUT ON
	SET VERIFY OFF
	CREATE OR REPLACE TRIGGER CONTROL_LIBROS
		BEFORE INSERT OR UPDATE OR DELETE ON LIBROS
	BEGIN
		IF INSERTING THEN
			INSERT INTO CONTROL(USUARIO, FECHA, OPERACION) VALUES(USER, SYSDATE, 'INSERCION');
		ELSIF UPDATING THEN
			INSERT INTO CONTROL(USUARIO, FECHA, OPERACION) VALUES(USER, SYSDATE, 'MODIFICADO');
		ELSIF DELETING THEN
			INSERT INTO CONTROL(USUARIO, FECHA, OPERACION) VALUES(USER, SYSDATE, 'BORRADO');
		END IF;
	END;
	/
	
	SET SERVEROUTPUT ON
	SET VERIFY OFF
	CREATE OR REPLACE TRIGGER INSERT_LIBROS
		BEFORE INSERT ON LIBROS
	BEGIN
		IF INSERTING THEN
			INSERT INTO CONTROL(USUARIO, FECHA, OPERACION) VALUES(USER, SYSDATE, 'INSERCION');
		END IF;
	END;
	/
	  
/*
7.3 – Insertar los siguiente registros en “libros” y comprobar en la tabla control:
*/
		INSERT INTO LIBROS VALUES(100, 'UNO', 'RICHARD BACH', 'PLANETA', 25);
		INSERT INTO LIBROS VALUES(103, 'EL ALEPH', 'BORGES', 'EMECE', 28);		
		INSERT INTO LIBROS VALUES(105, 'MATEMATICA ESTAS AHÍ', 'PAENZA', 'NUEVO SIGLO', 12);
		INSERT INTO LIBROS VALUES(120, 'APRENDA PHP', 'MOLINA MARIO', 'NUEVO SIGLO', 55);
		INSERT INTO LIBROS VALUES(145, 'ALICIA EN EL PAIS DE LAS MARAVILLAS', 'CARROLL', 'PLANETA', 35);
/*
7.4 – Crear otro trigger sobre “libros” que se active cuando eliminamos un registro de “libros”, 
      debe almacenar en “control” el nombre del usuario que realiza la eliminación, 
	  la fecha y “borrado” en “operación”(0.25PUNTOS JUNTO CON EL 7.5)
*/
	SET SERVEROUTPUT ON
	SET VERIFY OFF
	CREATE OR REPLACE TRIGGER UPDATE_LIBROS
		BEFORE UPDATE ON LIBROS
	BEGIN
		IF UPDATING THEN
			INSERT INTO CONTROL(USUARIO, FECHA, OPERACION) VALUES(USER, SYSDATE, 'MODIFICADO');
		END IF;
	END;
	/
/*	  
7.5 – Borrar un libro de “libros” y comprobar que el trigger de borrado se dispara mirando los registros de “control”
*/
	DELETE FROM libros WHERE codigo = 103;
/*
7.6 – Crear un tercer trigger sobre “libros” que se active cuando modificamos un registro de “libros”, 
	  debe almacenar en “control” el nombre del usuario que realiza la modificación, la fecha y “modificado” en “operación”(0.25PUNTOS JUNTO CON EL 7.7)
*/ 
	SET SERVEROUTPUT ON
	SET VERIFY OFF
	CREATE OR REPLACE TRIGGER DELETE_LIBROS
		BEFORE DELETE ON LIBROS
	BEGIN
		IF DELETING THEN
			INSERT INTO CONTROL(USUARIO, FECHA, OPERACION) VALUES(USER, SYSDATE, 'BORRADO');
		END IF;
	END;
	/
/*	  
7.7 – Actualizar la editorial de varios libros y comprobar que el trigger de actualización se dispara mirando los registros de “control”
*/	
	UPDATE libros SET editorial = 'Nueva Editorial' WHERE codigo IN (100, 105);
	
/*
8- (1 PUNTO) Crear una tabla llamada NUMEROS y tiene una columna que se llama colum1.
*/	
	CONNECT SYSTEM/SYSTEM
	SET LINESIZE 100
	SET SERVEROUTPUT ON;
	SET VERIFY OFF;
	
	DROP TABLE numeros CASCADE CONSTRAINT;
	
	CREATE TABLE numeros(
		colum1 NUMBER
	);
/*	
8.1- Hacer un bloque PL/SQL para introducir en la columna los números del 1 al 10 excepto 3 y 8 (0.25PUNTOS)
*/	
	DECLARE
	BEGIN
		FOR i IN 1..10 LOOP
			IF i = 3 THEN
				CONTINUE;
			ELSIF i = 8 THEN
				CONTINUE;
			ELSE
				INSERT INTO numeros VALUES (i);
			END IF;
		END LOOP;
	END;
	/
/*
8.2 – Añadir la colmn2 en la tabla NUMEROS en la cual los valores de la columna1 se eleven al cuadrado(0.25PUNTOS)
*/
	ALTER TABLE numeros ADD col2 NUMBER;
	
	DECLARE
		CURSOR C8 IS
			SELECT colum1 FROM numeros;
		cuadrado NUMBER;
		num NUMBER := 0;
	BEGIN
		FOR num IN C8 LOOP
			cuadrado := POWER(num.colum1,2);
			UPDATE numeros SET col2=cuadrado WHERE colum1 = num.colum1;
		END LOOP;
	END;
	/
/*	
8.3- Añadir en la tabla NUMEROS la colum3 y escribir la palabra par o impar dependiendo del valor que contenga la columna2 (0.5PUNTOS)
*/	
	ALTER TABLE numeros ADD col3 VARCHAR(10);
	
	DECLARE
		CURSOR C9 IS
			SELECT col2 FROM numeros;
		par_impar VARCHAR(10);
	BEGIN
		FOR num IN C9 LOOP
			IF num.col2 MOD 2 = 0 THEN
				par_impar := 'par';
			ELSE
				par_impar := 'impar';
			END IF;
			UPDATE numeros SET col3=par_impar WHERE col2 = num.col2;
		END LOOP;
	END;
	/

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
/*		 
9- (1 PUNTO) Hacer una función que calcule el factorial de un número y que se utilice dicha función. 
	Ejemplo de factorial y salida por pantalla: 4! = 4*3*2*1 resultado 24
*/	
	CREATE OR REPLACE FUNCTION factorial(num NUMBER) RETURN NUMBER IS
		resultado NUMBER := 1;
		cadena VARCHAR(100) := '';
	BEGIN
		IF num < 0 THEN
			RETURN NULL;
		ELSIF num = 0 THEN
			cadena := '0! = 1';
		ELSE
			FOR i IN 1..num LOOP
				resultado := resultado * i;
				IF i = 1 THEN
					cadena := cadena || i;
				ELSE
					cadena := cadena || '*' || i;
				END IF;
			END LOOP;
			
			cadena := num || '! = ' || cadena;
		END IF;
		
		DBMS_OUTPUT.PUT_LINE(cadena);
		RETURN resultado;
	END;
	/
	
	DECLARE
		NUMERO NUMBER := &INTRODUCE_NUMERO;
		fact NUMBER;
	BEGIN
		fact := factorial(NUMERO);
		IF fact IS NULL THEN
			DBMS_OUTPUT.PUT_LINE('EL NUMERO ES MENOR QUE CERO');
		ELSE
			DBMS_OUTPUT.PUT_LINE('RESULTADO: ' || fact);
		END IF;
	END;
	/
/*	
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
*/	
	CREATE OR REPLACE PROCEDURE MOSTRAR_DATOS IS
	CURSOR EMPLEADOS IS 
		SELECT DEPART.DEPT_NO, EMP_NO, APELLIDO, DNOMBRE FROM EMPLE, DEPART 
		WHERE DEPART.DEPT_NO = EMPLE.DEPT_NO(+) ORDER BY EMPLE.DEPT_NO;
	V_DEPT_NO NUMBER DEFAULT 0;
	BEGIN
		FOR i IN EMPLEADOS LOOP
			IF i.DEPT_NO != V_DEPT_NO THEN
			V_DEPT_NO := i.DEPT_NO;
			DBMS_OUTPUT.PUT_LINE(V_DEPT_NO||' '||i.DNOMBRE);
			END IF;
			DBMS_OUTPUT.PUT_LINE('---- '||i.APELLIDO||' '||i.EMP_NO);
		END LOOP;
	END;
	/
	
	EXECUTE MOSTRAR_DATOS;
/*	
11- (2 PUNTOS) Se trata de controlar los presupuestos de los distintos departamentos, 
	manteniendo en una tabla los valores actualizados de la suma total de dinero que cada departamento gasta en salarios de los empleados.
	
11.1- (0.5 PUNTOS) Crear la tabla DEPT_BUDGET con las siguientes columnas:
		dept_no 	NUMBER(2)
		total_sal	NUMBER(10)

	Crear un procedimiento PL/SQL para llenarla con la suma de los salarios de cada departamento de la table EMPLE.
		
		DROP TABLE DEPT_BUDGET CASCADE CONSTRAINT;
		
		CREATE TABLE DEPT_BUDGET(
			DEPT_NO NUMBER(2);
			TOTAL_SAL NUMBER(10);
		);
		
		CREATE OR REPLACE PROCEDURE SALARIO_TOTAL IS
			CURSOR C11 IS
				SELECT D.DEPT_NO, SUM(E.SALARIO) FROM EMPLE E, DEPART D WHERE E.DEPT_NO = D.DEPT_NO(+) ORDER BY E.DEPT_NO;
		BEGIN
			
		END;
		/
		
11.2. (1.5 PUNTOS) Crear un trigger que actualice la tabla DEPT_BUDGET cuando se producen los siguientes eventos en EMPLE:
	- Si se borra un empleado, se resta su salario del total del departamento en la tabla dept_budget.
	-Si se añade un empleado, su salario se suma al total del departamento en la tabla dept_budget.
	-Si un empleado cambia de departamento, su antiguo salario se resta del total de su antiguo departamento, y su nuevo salario se suma al total del nuevo departamento.
*/