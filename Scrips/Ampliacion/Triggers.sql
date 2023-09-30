EJERCICIOS TRIGGERS:

1-	Crear el trigger auditar_subida_salario, 
	que se disparará después de cada modificación de la columna salario de la tabla EMPLE.
	Se creará primero la tabla auditar_emple con col1 varchar2(200). 
	Donde se insertará el literal “subida salario empleado” y el número del empleado.

	DROP TABLE auditar_emple CASCADE CONSTRAINT;
	
	CREATE TABLE auditar_emple(
		COL1 VARCHAR2(200)
	);

	CREATE OR REPLACE TRIGGER auditar_subida_salario
		BEFORE UPDATE OF SALARIO ON EMPLE
		FOR EACH ROW
	BEGIN
		INSERT INTO auditar_emple(col1)
		VALUES ('Subida salario' || ' ' ||:new.emp_no);
	END;
	/
	
	
	DECLARE
		num_emple NUMBER(4) := &num_emple;
	BEGIN
		UPDATE EMPLE SET SALARIO=SALARIO+100 WHERE EMP_NO=num_emple;
	END;
	/

2-	Crear un trigger que se disparará cada vez que se borre un empleado, 
	guardando el literal “borrado empleado”, su número de empleado, 
	apellido y el departamento en una fila de la tabla AUDITAR_EMPLE.
	
	CREATE OR REPLACE TRIGGER borrado_emple
		BEFORE DELETE ON EMPLE
		FOR EACH ROW
	BEGIN
		INSERT INTO auditar_emple(col1)
		VALUES ('Usuario borrado' || ' ' || :old.EMP_NO || ' ' || :old.APELLIDO || ' ' || :old.DEPT_NO);
	END;
	/
	
	
	DECLARE
		num_emple NUMBER(4) := &num_emple;
	BEGIN
		DELETE FROM EMPLE WHERE EMP_NO=num_emple;
	END;
	/
		
3-	Incluir una restricción en el ejercicio anterior para que se ejecute 
	el disparador cuando el empleado borrado sea PRESIDENTE.
	
	CREATE OR REPLACE TRIGGER borrado_emple
		BEFORE DELETE ON EMPLE
		FOR EACH ROW
	BEGIN
		IF :old.EMP_NO = 7839 THEN
			INSERT INTO auditar_emple(col1)
			VALUES ('Presidente borrado' || ' ' || :old.EMP_NO || ' ' || :old.APELLIDO || ' ' || :old.DEPT_NO);
		ELSE
			INSERT INTO auditar_emple(col1)
			VALUES ('Usuario borrado' || ' ' || :old.EMP_NO || ' ' || :old.APELLIDO || ' ' || :old.DEPT_NO);
		END IF;
	END;
	/
	
4-	Escribe un disparador que permite auditar las operaciones de inserción o 
	borrado de datos que se realicen en la tabla EMPLE según las siguientes especificaciones:
	-	Se creará la tabla auditar_emple con col1 varchar2(200).
	-	Cuando se produzca cualquier manipulación, se insertará una fila en la tabla creada que contendrá: 
		fecha y hora, nºempleado, apellido y la palabra INSERCIÓN O BORRADO según la actualización.
	
	Utilizar el formato múltiples eventos.
	
	CREATE OR REPLACE TRIGGER manipulacion 
		BEFORE INSERT OR DELETE ON EMPLE
		FOR EACH ROW
	BEGIN
		IF DELETING THEN
			INSERT INTO auditar_emple(col1)
			VALUES (TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS') || ' ' || :old.EMP_NO || ' ' || :old.APELLIDO || ' BORRADO');
		ELSIF INSERTING THEN
			INSERT INTO auditar_emple(col1)
			VALUES (TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS') || ' ' || :new.EMP_NO || ' ' || :new.APELLIDO || ' INSERCIÓN');
		END IF;
	END;
	/
		
	CREATE OR REPLACE PROCEDURE borrado(num_emple NUMBER) IS
	BEGIN
		DELETE FROM EMPLE WHERE EMP_NO=num_emple;
	END;
	/
	
	INSERT INTO EMPLE VALUES (7844,'TOVAR','VENDEDOR',7698,'08/09/1991',1350,0,30);
	
5-	Escribir un disparador que controle las conexiones de los usuarios en la base de datos. 
	Para ello crearemos la siguiente tabla: