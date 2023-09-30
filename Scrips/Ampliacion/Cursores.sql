EJERCICIOS CURSORES:
1-	Escribir un bloque PL que utilice un cursor explicito para visualizar 
	el nombre y la localidad de todos los departamentos. Utilizar LOOP Y WHILE.
	
	DECLARE 
		CURSOR C1 IS
			SELECT DNOMBRE, LOC FROM DEPART;
		nombre DEPART.DNOMBRE%TYPE;
		local DEPART.LOC%TYPE;
	BEGIN
		OPEN C1;
			LOOP
				FETCH C1 INTO nombre, local;
				DBMS_OUTPUT.PUT_LINE(nombre || ' --- ' || local);
				EXIT WHEN C1%NOTFOUND;
			END LOOP;
		CLOSE C1;
	END;
	/
	
	DECLARE 
		CURSOR C1 IS
			SELECT DNOMBRE, LOC FROM DEPART;
		nombre DEPART.DNOMBRE%TYPE;
		local DEPART.LOC%TYPE;
	BEGIN
		OPEN C1;
			FETCH C1 INTO nombre, local;
			WHILE C1%FOUND LOOP
				FETCH C1 INTO nombre, local;
				DBMS_OUTPUT.PUT_LINE(nombre || ' --- ' || local);
			END LOOP;
		CLOSE C1;
	END;
	/
	
2-	Visualizar los apellidos de los empleados pertenecientes al departamento 20 
	numerándolos secuencialmente. Utilizar   %ROWCOUNT los números secuenciales.
	
	1.SANCHEZ
	2.JIMENEZ
	3.GIL
	4.ALONSO
	5.FERNANDEZ

	DECLARE
		CURSOR C2 IS
			SELECT APELLIDO FROM EMPLE WHERE DEPT_NO=20;
		apellido VARCHAR(15);
	BEGIN
		OPEN C2;
			LOOP
			FETCH C2 INTO apellido;
			DBMS_OUTPUT.PUT_LINE(C2%ROWCOUNT || ' -*- ' || apellido);
			EXIT WHEN C2%NOTFOUND;
			END LOOP;
		CLOSE C2;
	END;
	/

3-	Visualizar los empleados de un departamento mediante un procedimiento y 
	utilizando variables de acoplamiento.
	
	CREATE OR REPLACE PROCEDURE departa(num_dept EMPLE.DEPT_NO%TYPE) IS
		CURSOR C3 IS
			SELECT EMP_NO, APELLIDO, OFICIO, SALARIO FROM EMPLE WHERE DEPT_NO=num_dept;
		num_emple EMPLE.EMP_NO%TYPE;
		apellido EMPLE.APELLIDO%TYPE;
		ofic EMPLE.OFICIO%TYPE;
		salar EMPLE.SALARIO%TYPE;
	BEGIN
		OPEN C3;
			LOOP
				FETCH C3 INTO num_emple, apellido, ofic, salar;
				DBMS_OUTPUT.PUT_LINE(num_emple || ' -/- ' || apellido || ' -/- ' || ofic || ' -/- ' || salar || ' -/- ' || num_dept);
				EXIT WHEN C3%NOTFOUND;
			END LOOP;
		CLOSE C3;
	END;
	/

4-	Escribir un bloque PL que visualice el apellido, el oficio y la comisión 
	de los empleados que supere los 500€. Utilizando CURSOR FOR........LOOP.
	
	DECLARE
		CURSOR C4 IS	
			SELECT APELLIDO, OFICIO, COMISION FROM EMPLE WHERE COMISION > 500;
	BEGIN 
		FOR i IN C4 LOOP
			DBMS_OUTPUT.PUT_LINE(i.APELLIDO || ' -/- ' || i.OFICIO || ' -/- ' || i.COMISION);				
		END LOOP;
	END;
	/

5-	Escribir un bloque PL que visualice el apellido y la fecha de alta de 
	todos los empleados ordenados por fecha de alta. Utilizando CURSOR FOR........LOOP.	
	
	DECLARE
		CURSOR C5 IS	
			SELECT APELLIDO, FECHA_ALT FROM EMPLE ORDER BY FECHA_ALT;
	BEGIN 
		FOR i IN C5 LOOP
			DBMS_OUTPUT.PUT_LINE(i.APELLIDO || ' -/- ' || i.FECHA_ALT);				
		END LOOP;
	END;
	/
	
6-	Escribir un procedimiento que subirá el sueldo de todos los empleados del 
	departamento indicado en la llamada. La subida será el porcentaje indicado 
	en la llamada.
	
	Utilizaremos el cursor FOR UPDATE.
	
	FORMATO:
	CURSOR <nbcursor> IS <sentencia SELECT del cursor> FOR UPDATE;

	El formato para actualizar la fila seleccionada por un cursor FOR UPDATE:
	{UPDATE | DELETE} ...... WHERE CURRENT OF <nbcursor>
	
	CREATE OR REPLACE PROCEDURE subir_sueldo(num_dept EMPLE.DEPT_NO%TYPE, porc NUMBER) IS
		CURSOR C6 IS
			SELECT SALARIO FROM EMPLE WHERE DEPT_NO=num_dept 
		FOR UPDATE;
	BEGIN
		FOR I IN C6 LOOP
			UPDATE EMPLE SET SALARIO = SALARIO * (1+(porc/100)) WHERE CURRENT OF C6;
		END LOOP;
	END;
	/
	
7-	Desarrollar un procedimiento que visualice el apellido y la fecha de alta de todos 
	los empleados ordenados por apellido.
	
	CREATE OR REPLACE PROCEDURE ver_emple IS
		CURSOR C7 IS	
			SELECT APELLIDO, FECHA_ALT FROM EMPLE ORDER BY APELLIDO;
	BEGIN 
		FOR i IN C7 LOOP
			DBMS_OUTPUT.PUT_LINE(i.APELLIDO || ' -/- ' || i.FECHA_ALT);				
		END LOOP;
	END;
	/
		
8-	Codificar un procedimiento que muestre el nombre de cada departamento y el número
	de empleados que tiene.	
	
	CREATE OR REPLACE PROCEDURE cont_emple (num_dept EMPLE.DEPT_NO%TYPE) IS
		CURSOR C7 IS	
			SELECT D.DNOMBRE, COUNT(*) AS total_emple 
			FROM EMPLE E, DEPART D 
			WHERE E.DEPT_NO = D.DEPT_NO(+) AND E.DEPT_NO=num_dept;
	BEGIN 
		FOR i IN C7 LOOP
			DBMS_OUTPUT.PUT_LINE(i.DNOMBRE || ' -/- ' || i.total_emple);				
		END LOOP;
	END;
	/
	
	CREATE OR REPLACE PROCEDURE cont_emple (num_dept EMPLE.DEPT_NO%TYPE) IS
    CURSOR C7 IS
        SELECT D.DNOMBRE, COUNT(*) AS total_emple
        FROM EMPLE E
        JOIN DEPART D
        ON E.DEPT_NO = D.DEPT_NO
        WHERE E.DEPT_NO = num_dept
        GROUP BY D.DNOMBRE;
	BEGIN
		FOR i IN C7 LOOP
			DBMS_OUTPUT.PUT_LINE(i.DNOMBRE || ' -/- ' || i.total_emple);
		END LOOP;
	END;
	/
	
9-	Escribir un procedimiento que visualice el apellido y el salario de los cinco 
	empleados que tienen el salario más alto.
	
	REY	4100
	NEGRO	3005
	FERNANDEZ3000
	GIL	3000
	JIMENEZ	2900
	CEREZO	2885
	MUÑOZ	1690
	SALA	1625
	MARTIN	1600
	ARROYO	1500
	ALONSO	1430
	TOVAR	1350
	JIMENO	1335
	SANCHEZ 1040
	La salida seria:
	REY*4100
	NEGRO*3005
	FERNANDEZ*3000
	GIL*3000
	JIMENEZ*2900

	CREATE OR REPLACE PROCEDURE salario IS
	CURSOR C9 IS
		SELECT APELLIDO, SALARIO
		FROM (SELECT APELLIDO, SALARIO FROM EMPLE ORDER BY SALARIO DESC)
		WHERE ROWNUM <= 5;*
	BEGIN
		FOR i IN C9 LOOP
			DBMS_OUTPUT.PUT_LINE(i.APELLIDO || ' -/- ' || i.SALARIO);
		END LOOP;
	END;
	/

10-	Codificar un procedimiento que visualice los dos empleados que ganan menos 
	de cada oficio.
	
	FERNANDEZANALISTA	3000
	GIL	ANALISTA	3000
	CEREZO	DIRECTOR	2885
	JIMENEZ	DIRECTOR	2900
	NEGRO	DIRECTOR	3005
	SANCHEZ EMPLEADO	1040
	JIMENO	EMPLEADO	1335
	ALONSO	EMPLEADO	1430
	MUÑOZ	EMPLEADO	1690
	REY	PRESIDENTE	4100
	TOVAR	VENDEDOR	1350
	ARROYO	VENDEDOR	1500
	MARTIN	VENDEDOR	1600
	SALA	VENDEDOR	1625

	CREATE OR REPLACE PROCEDURE salario2 IS
	CURSOR C10 IS
		SELECT APELLIDO, OFICIO, SALARIO 
		FROM (SELECT OFICIO FROM EMPLE ORDER BY OFICIO)
		ORDER BY SALARIO DESC;		
	BEGIN
		FOR i IN C10 LOOP
			DBMS_OUTPUT.PUT_LINE(i.APELLIDO || ' -/- ' || i.OFICIO || ' -/- ' || i.SALARIO);
		END LOOP;
	END;
	/