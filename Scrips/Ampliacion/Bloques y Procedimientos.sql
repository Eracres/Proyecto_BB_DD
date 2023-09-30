1.	Obtener la longitud de la circunferencia introduciendo el radio 
	por teclado cuyo valor es en cm y el resultado lo queremos en metros.
	
	BLOQUE ANONIMO
	
	DECLARE
		radio NUMBER := &radio_cm;	
		longitud NUMBER; 
	BEGIN
		longitud := 2*3.1416*(radio/100);
		DBMS_OUTPUT.PUT_LINE('La longitud de la circunferencia de radio ' || radio ||
		' es igual a = ' || longitud);
	END;
	/
	
	PROCEDIMIENTO
	
	CREATE OR REPLACE PROCEDURE long_circ(radio NUMBER) IS 
		longitud NUMBER;
	BEGIN
		longitud := 2*3.1416*(radio/100);
		DBMS_OUTPUT.PUT_LINE('La longitud de la circunferencia de radio ' || radio ||
		' es igual a = ' || longitud);
	END;
	/
	
2.	Obtener el salario del empleado 7839 de la tabla EMPLE.
	
	BLOQUE ANONIMO
	
	DECLARE
		num_emple NUMBER := &num_emple;
		salario NUMBER;		
	BEGIN
		SELECT SALARIO INTO salario FROM EMPLE WHERE EMP_NO = num_emple;
		DBMS_OUTPUT.PUT_LINE('El salario del empleado ' || num_emple ||
		' es de = ' || salario);
	END;
	/
	
	PROCEDIMIENTO
	
	CREATE OR REPLACE PROCEDURE salario_emple(num_emple NUMBER) IS 
		salario NUMBER;	
	BEGIN
		SELECT SALARIO INTO salario FROM EMPLE WHERE EMP_NO = num_emple;
		DBMS_OUTPUT.PUT_LINE('El salario del empleado ' || num_emple ||
		' es de = ' || salario);
	END;
	/
	
3.	Mostrar el nombre de la asignatura con código 7 de la tabla ASIGNATURAS.

	BLOQUE ANONIMO
	
	DECLARE
		cod_asig NUMBER := &cod_asig;
		nom_asig VARCHAR(50);		
	BEGIN
		SELECT NOMBRE INTO nom_asig FROM ASIGNATURAS WHERE COD = cod_asig;
		DBMS_OUTPUT.PUT_LINE('Con el codigo ' || cod_asig ||
		' en nombre es = ' || nom_asig);
	END;
	/
	
	PROCEDIMIENTO
	
	CREATE OR REPLACE PROCEDURE nombre_asgn(cod_asig NUMBER) IS 
		nom_asig VARCHAR(50);	
	BEGIN
		SELECT NOMBRE INTO nom_asig FROM ASIGNATURAS WHERE COD = cod_asig;
		DBMS_OUTPUT.PUT_LINE('Con el codigo ' || cod_asig ||
		' en nombre es = ' || nom_asig);
	END;
	/
	
4.	Visualizar el nombre de la tabla PROFESORES, introduciendo el 
	DNI por teclado a través de una variable de sustitución.
	
	BLOQUE ANONIMO
	
	DECLARE
		nombre_prof VARCHAR(50);
		dni_prof VARCHAR(50):= &dni_prof;
	BEGIN
		SELECT APELLIDOS INTO nombre_prof FROM PROFESORES WHERE DNI = dni_prof;
		DBMS_OUTPUT.PUT_LINE('Con el DNI ' || dni_prof ||
		' el nombre del profesor es = ' || nombre_prof);
	END;
	/
	
	PROCEDIMIENTO
	
	CREATE OR REPLACE PROCEDURE nombr_profe(dni_prof VARCHAR) IS	
		nombre_prof VARCHAR(50);
	BEGIN 
		SELECT APELLIDOS INTO nombre_prof FROM PROFESORES WHERE DNI = dni_prof;
		DBMS_OUTPUT.PUT_LINE('Con el DNI ' || dni_prof ||
		' el nombre del profesor es = ' || nombre_prof);
	END;
	/
	
5.	A través de variables visualice el departamento VENTAS de la tabla 
	DEPART con el siguiente mensaje ‘El departamento nº X esta en XXX’.
	
	BLOQUE ANONIMO
	
	DECLARE
		nom_dept VARCHAR(50) := &nom_dept;
		dep_no NUMBER;
		local VARCHAR(50);
	BEGIN
		SELECT DEPT_NO, LOC INTO dep_no, local FROM DEPART WHERE DNOMBRE = nom_dept;
		DBMS_OUTPUT.PUT_LINE(‘El departamento nº ' || dep_no || ' esta en ’ || local);
	END;
	/
	
	PROCEDIMIENTO
	
	CREATE OR REPLACE PROCEDURE loc_num_dept(nom_dept VARCHAR) IS	
		dep_no NUMBER;
		local VARCHAR(50);
	BEGIN 
		SELECT DEPT_NO, LOC INTO dep_no, local FROM DEPART WHERE DNOMBRE = nom_dept;
		DBMS_OUTPUT.PUT_LINE(‘El departamento nº ' || dep_no || ' esta en ’ || local);
	END;
	/
	
6.	Insertar en la tabla EMPLE un empleado con código 9999 asignado directamente 
	en la variable, apellido ‘PEREZ’, oficio ‘ANALISTA’ y código del departamento 
	al que pertenece 10.
	
	BLOQUE ANONIMO
	
	DECLARE
		num_emple NUMBER := &num_emple;
		num_dept NUMBER := &num_dept;
		ofic VARCHAR(50) := &ofic;
		apellido VARCHAR(50) := &apellido;
	BEGIN
		INSERT INTO EMPLE (EMP_NO, APELLIDO, OFICIO, DEPT_NO) VALUES (num_emple, apellido, ofic, num_dept);
		DBMS_OUTPUT.PUT_LINE(‘Empleado insertado');
	END;
	/
	
	PROCEDIMIENTO
	
	CREATE OR REPLACE PROCEDURE insrt_emple (cod_emp NUMBER, cod_dep NUMBER, apell VARCHAR2, oficio VARCHAR2) IS
		
	BEGIN
		INSERT INTO EMPLE (EMP_NO, APELLIDO, OFICIO, DEPT_NO) VALUES (cod_emp, cod_dep, apell, oficio);
		DBMS_OUTPUT.PUT_LINE(‘Empleado insertado');
	END;
	/
	
7.	Incrementar el salario en la tabla EMPLE en 200€ a todos los trabajadores que sean ‘ANALISTAS’, mediante un bloque anónimo PL, 
	asignando dicho valor a una variable declarada%TYPE.
	
	DECLARE
		salario_emple EMPLE.SALARIO%TYPE := 200;
	BEGIN
		UPDATE EMPLE SET SALARIO = SALARIO+salario_emple WHERE OFICIO='ANALISTA’;
		DBMS_OUTPUT.PUT_LINE(‘Salario actualizado');
	END;
	/
	
	CREATE OR REPLACE PROCEDURE salar_emple (salario_emple EMPLE.SALARIO%TYPE) IS
	BEGIN
		UPDATE EMPLE SET SALARIO = SALARIO+salario_emple WHERE OFICIO='ANALISTA’;
		DBMS_OUTPUT.PUT_LINE(‘Salario actualizado');
	END;
	/
	
8.	Borrar un registro de la tabla EMPLE, existiendo en el bloque una variable PL y otra de sustitución.

	DECLARE
		cod_emple NUMBER:= &cod_emple;
	BEGIN
		DELETE FROM EMPLE WHERE EMP_NO = cod_emple;
		DBMS_OUTPUT.PUT_LINE('El empleado ' || cod_emple || ' ha sido eliminado de la tabla EMPLE');
	END;
	/
		
	CREATE OR REPLACE PROCEDURE del_emple (cod_emple EMPLE.EMP_NO%TYPE) IS
	BEGIN
		DELETE FROM EMPLE WHERE EMP_NO = cod_emple;
		DBMS_OUTPUT.PUT_LINE('El empleado ' || cod_emple || ' ha sido eliminado de la tabla EMPLE');
	END;
	/

9.	Suprimir de la tabla ASIGNATURAS aquellos que tengan un código mayor a cinco utilizando los atributos del cursor SQL%ROWCOUNT. 
	Que muestre cuantas filas ha borrado. 
	
	DECLARE
		cont_elim NUMBER;
	BEGIN
		DELETE FROM ASIGNATURAS WHERE COD > 5;
		cont_elim := SQL%ROWCOUNT;
		DBMS_OUTPUT.PUT_LINE('Se han eliminado ' || cont_elim || ' filas de la tabla ASIGNATURAS');
	END;
	/
	
	CREATE OR REPLACE PROCEDURE del_asig (cod_asig ASIGNATURAS.COD%TYPE) IS
		cont_elim NUMBER;
	BEGIN
		DELETE FROM ASIGNATURAS WHERE COD > cod_asig;
		cont_elim := SQL%ROWCOUNT;
		DBMS_OUTPUT.PUT_LINE('Se han eliminado ' || cont_elim || ' filas de la tabla ASIGNATURAS');
	END;
	/
	
10.	Obtener un bloque PL que introduciendo el código de un trabajador de la tabla EMPLE, 
	visualizar el código y su salario para posteriormente actualizarlo en función de su sueldo. 
	Si su sueldo es mayor de 1200 € su incremento será del 20% y su sueldo es menor del 25%. 
	Visualizar su sueldo actualizado.
	
	DECLARE
		cod_trab EMPLE.EMP_NO%TYPE := &cod_trab;
		salar_emple NUMBER;
		salar_emple_nuevo NUMBER;
	BEGIN
		SELECT SALARIO INTO salar_emple FROM EMPLE WHERE EMP_NO=cod_trab;
		
		DBMS_OUTPUT.PUT_LINE('El salario anterior del empleado ' || cod_trab || ' es de ' || salar_emple || 'Euros');
		
		IF salar_emple > 1200 THEN
			salar_emple_nuevo := salar_emple*1.2;
		ELSE
			salar_emple_nuevo := salar_emple*1.25;
		END IF;
		
		UPDATE EMPLE SET SALARIO = salar_emple_nuevo WHERE EMP_NO = cod_trab;
		
		DBMS_OUTPUT.PUT_LINE('El nuevo salario del empleado ' || cod_trab || ' es de ' || salar_emple || 'Euros');
		
	END;
	/
	
11.	Introduciendo un número por teclado, correspondiente al dorsal de un futbolista, 
	dar como salida el puesto en el que juega dicho jugador. 
	Utilizar la estructura de control más adecuada.
	
	DECLARE
		dorsal NUMBER := &dorsal;
		puesto VARCHAR(50);
	BEGIN
		CASE dorsal
			WHEN 1 THEN puesto := 'Portero';
			WHEN 2 THEN puesto := 'Defensa';
			WHEN 3 THEN puesto := 'Defensa';
			WHEN 4 THEN puesto := 'Defensa';
			WHEN 5 THEN puesto := 'Defensa';
			WHEN 6 THEN puesto := 'Centrocampista';
			WHEN 7 THEN puesto := 'Centrocampista';
			WHEN 8 THEN puesto := 'Centrocampista';
			WHEN 9 THEN puesto := 'Delantero';
			WHEN 10 THEN puesto:= 'Delantero';
			WHEN 11 THEN puesto := 'Delantero';
			ELSE puesto := 'La cagaste';
		END CASE;
		
		DBMS_OUTPUT.PUT_LINE('El jugador con dorsal ' || dorsal || ' es: ' || puesto);

	END;
	/
	
12.	Dados dos números introducidos por teclado, obtener cuál de los dos es mayor.

	DECLARE
		num1 NUMBER := &num1;
		num2 NUMBER := &num2;
	BEGIN
		IF num1 > num2 THEN
			DBMS_OUTPUT.PUT_LINE('num1 es mayor que num2');
		ELSIF num1 < num2 THEN
			DBMS_OUTPUT.PUT_LINE('num2 es mayor que num1');
		ELSIF num1 = num2 THEN
			DBMS_OUTPUT.PUT_LINE('num2 es igual a num1');
		END IF;
	END;
	/
	
13.	Realizar un programa que devuelva el número de cifras de un número entero, 
	introducido por teclado, mediante una variable de sustitución.
	
	DECLARE
		numero NUMBER := &number;
		cont NUMBER := 0;
	BEGIN
		WHILE numero > 0 LOOP
			cont := cont +1;
			numero := TRUNC(numero/10);
		END LOOP;
		DBMS_OUTPUT.PUT_LINE('El número de cifras es: ' || cont);
	END;
	/
	
14.	Dado un número introducido por teclado, visualizar por pantalla todos los 
	números iguales o inferiores a él. 
	Este programa se efectuará por todos los tipos de estructuras repetitivas.
	
	