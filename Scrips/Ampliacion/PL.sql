/*
OPCION A
-	Funciones.
-	Procedimientos aquí iría casi todo el proyecto también hay que incluir las estructuras de control while o loop vais tenerlas que utilizar obligatoriamente y también if_then para que controle alguna variable, no contaría el if de las excepciones. 
-	Excepciones estas pueden ir con cada uno de los procedimientos que hagáis.
-	Cursores estos pueden ir en los procedimientos.
-	Triggers. 
Se valorara la complejidad del código utilizado en cada una de ellas.
Todos los códigos o programas pl´s deben tener las comprobaciones oportunas con el sqlplus. Como siempre tiene que haber captura y todo ello explicado en la presentación.

*/

--//***Procedimiento***//--

--Control de clientes--

CREATE OR REPLACE PROCEDURE gestion_clientes (opcion NUMBER, opcion2 NUMBER, dni_emple CLIENTE.DNI%TYPE) IS

    FUNCTION ins_emple (dni_emple CLIENTE.DNI%TYPE, nombre CLIENTE.NOMBRE%TYPE, apellido CLIENTE.APELLIDO%TYPE, dir CLIENTE.DIRECCION%TYPE, tel CLIENTE.TEL%TYPE) RETURN NUMBER IS
    BEGIN
        INSERT INTO CLIENTE VALUES (dni_emple , nombre , apellido , dir , tel);
        RETURN 1;
    END;

    FUNCTION del_emple (dni_emple CLIENTE.DNI%TYPE) RETURN NUMBER IS
    BEGIN
        DELETE  CLIENTE WHERE DNI = dni_emple;
        RETURN 1;
    END;

    PROCEDURE my_procedure (opcion NUMBER) IS
        resultado NUMBER;
    BEGIN
        CASE opcion
            WHEN 1 THEN
                DECLARE
                    nombre CLIENTE.NOMBRE%TYPE;
                    apellido CLIENTE.APELLIDO%TYPE;
                    dir CLIENTE.DIRECCION%TYPE;
                    tel CLIENTE.TEL%TYPE;
                BEGIN
                    resultado := ins_emple(dni_emple , 'SERGIO' , 'CACERES' , 'C/ MARIA USERA, 18 3-B' , '663432320');

                    DBMS_OUTPUT.PUT_LINE('Cliente creado con DNI --> ' || dni_emple );
                END;

            WHEN 2 THEN
                DECLARE
                    nombre CLIENTE.NOMBRE%TYPE;
                    apellido CLIENTE.APELLIDO%TYPE;
                    dir CLIENTE.DIRECCION%TYPE;
                    tel CLIENTE.TEL%TYPE;
                BEGIN
                    CASE opcion2
                        WHEN 1 THEN
                            UPDATE CLIENTE SET NOMBRE = 'DANIEL' WHERE DNI = dni_emple;
                        WHEN 2 THEN
                            UPDATE CLIENTE SET APELLIDO = 'MONTESINOS' WHERE DNI = dni_emple;
                        WHEN 3 THEN
                            UPDATE CLIENTE SET DIRECCION = 'C/ Jovellanos, 123' WHERE DNI = dni_emple;
                        WHEN 4 THEN
                            UPDATE CLIENTE SET TEL = '925270510' WHERE DNI = dni_emple;
                        ELSE 
                            DBMS_OUTPUT.PUT_LINE('No hay mas campos que modificar');
                    END CASE;
                END;
            WHEN 3 THEN
                resultado := del_emple(dni_emple);
        END CASE;

    END;
BEGIN
    my_procedure(opcion);
END;
/

execute gestion_clientes(1,1,'03923X');
execute gestion_clientes(2,1,'03923X');
execute gestion_clientes(2,2,'03923X');
execute gestion_clientes(2,3,'03923X');
execute gestion_clientes(2,4,'03923X');
execute gestion_clientes(2,5,'03923X');
execute gestion_clientes(3,1,'03923X');

--Control de pedidos--

CREATE OR REPLACE PROCEDURE gestion_pedidos (opcion NUMBER, dni_emple CLIENTE.DNI%TYPE, cant_pedidos NUMBER) IS

    FUNCTION ins_pedido (num_pedido REGISTRO_PEDIDO.N_PEDIDO%TYPE, dni_emple REGISTRO_PEDIDO.DNI%TYPE, fecha_ped REGISTRO_PEDIDO.FECHA%TYPE) RETURN NUMBER IS
        BEGIN
            INSERT INTO REGISTRO_PEDIDO VALUES (num_pedido , dni_emple , fecha_ped);
            RETURN 1;
        END;

    FUNCTION ins_factura (num_factura REGISTRO_FACTURA.N_FACTURA%TYPE, fecha_fac REGISTRO_FACTURA.FECHA%TYPE) RETURN NUMBER IS
        BEGIN
            INSERT INTO REGISTRO_FACTURA VALUES (num_factura, fecha_fac);
            RETURN 1;
        END;

		FUNCTION ins_albaran (num_albaran REGISTRO_ALBARAN.N_ALBARAN%TYPE, fecha_alb REGISTRO_ALBARAN.FECHA%TYPE, num_factura REGISTRO_FACTURA.N_FACTURA%TYPE, num_pedido REGISTRO_PEDIDO.N_PEDIDO%TYPE) RETURN NUMBER IS
        BEGIN
            INSERT INTO REGISTRO_ALBARAN VALUES (num_albaran,fecha_alb,num_factura,num_pedido);
            RETURN 1;
        END;

    PROCEDURE my_procedure (opcion NUMBER) IS
        resultado NUMBER;
    BEGIN
        CASE opcion
            WHEN 1 THEN
                DECLARE
                    num_pedido VARCHAR(10);
                    num_factura VARCHAR(20);
                    num_albaran VARCHAR(20);
                    max_num_pedido NUMBER;
                    max_num_factura NUMBER;
					max_num_albaran NUMBER;
                    fecha_ped REGISTRO_PEDIDO.FECHA%TYPE;
					fecha_fac REGISTRO_PEDIDO.FECHA%TYPE;
                    v_cant_pedidos NUMBER := cant_pedidos;
                BEGIN

					SELECT TO_NUMBER(SUBSTR(MAX(N_FACTURA), 5)) INTO max_num_factura FROM REGISTRO_FACTURA;
                    max_num_factura := max_num_factura + 1;
                    num_factura := 'FAC-' || LPAD(max_num_factura, 3, '0');
                    resultado := ins_factura( num_factura, '15/05/2023');
					DBMS_OUTPUT.PUT_LINE('Factura creada con nº --> ' || num_factura);

                    LOOP
                        SELECT TO_NUMBER(SUBSTR(MAX(N_PEDIDO), 5)) INTO max_num_pedido FROM REGISTRO_PEDIDO;
                        max_num_pedido := max_num_pedido + 1;
                        num_pedido := 'PED-' || LPAD(max_num_pedido, 3, '0');
                        resultado := ins_pedido( num_pedido , dni_emple , '12/02/2024');
                        DBMS_OUTPUT.PUT_LINE('Pedido creado con nº --> ' || num_pedido || ' para el DNI: ' || dni_emple );

						SELECT TO_NUMBER(SUBSTR(MAX(N_ALBARAN), 5)) INTO max_num_albaran FROM REGISTRO_ALBARAN;
                        max_num_albaran := max_num_albaran + 1;
                        num_albaran := 'ALB-' || LPAD(max_num_albaran, 3, '0');
                        resultado := ins_albaran(num_albaran,'14/07/2023',num_factura,num_pedido);
                        DBMS_OUTPUT.PUT_LINE('Albaran creado con nº --> ' || num_albaran || ' para el DNI: ' || dni_emple );
                        v_cant_pedidos := v_cant_pedidos - 1;
                        EXIT WHEN (v_cant_pedidos = 0);
                    END LOOP;

                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN
                        DBMS_OUTPUT.PUT_LINE('Pedido duplicado');
                END;
			WHEN 2 THEN
				DECLARE
					num_pedido VARCHAR(10);
                    num_factura VARCHAR(20);
                    num_albaran VARCHAR(20);
				BEGIN
					DELETE REGISTRO_ALBARAN WHERE N_FACTURA = 'FAC-006';
					DELETE REGISTRO_ALBARAN WHERE N_FACTURA = 'FAC-006';
					DELETE REGISTRO_FACTURA WHERE N_FACTURA = 'FAC-006';
					DELETE REGISTRO_PEDIDO WHERE DNI = '03923X';
					DELETE REGISTRO_PEDIDO WHERE N_PEDIDO = 'PED-016';
					DELETE CLIENTE WHERE DNI = '03923X';
				EXCEPTION
					WHEN NO_DATA_FOUND THEN
						DBMS_OUTPUT.PUT_LINE('EL cliente no existe');
				END;
            ELSE DBMS_OUTPUT.PUT_LINE('No hay mas opciones disponibles');
        END CASE;
    END;
BEGIN
    my_procedure(opcion);
END;
/

execute gestion_pedidos(1,'03923X',4);

--Insercion de lineas en Pedidos y Albaran--

CREATE OR REPLACE PROCEDURE inser_lineas (num_lineas NUMBER, 
                                          num_pedido VARCHAR, 
                                          num_albaran VARCHAR 
                                          ) IS
    v_num_lineas NUMBER := num_lineas;
    v_num_pedido NUMBER := 1;
    producto VARCHAR(15);
    cantidad NUMBER;
BEGIN
    LOOP
        producto := 'AN-' || LPAD(TO_CHAR(ROUND(DBMS_RANDOM.VALUE(1, 41))), 3, '0');
        cantidad := ROUND(DBMS_RANDOM.VALUE(1, 100));
        INSERT INTO LINEA_PEDIDO VALUES (
            'LP-' || LPAD(v_num_pedido, 3, '0'),
            num_pedido,
            cantidad,
            producto);
        INSERT INTO LINEA_ALBARAN VALUES (
            'LA-' || LPAD(v_num_pedido, 3, '0'),
            num_albaran,
            cantidad,
            producto);
        v_num_pedido := v_num_pedido + 1;
        v_num_lineas := v_num_lineas - 1;
        EXIT WHEN v_num_lineas = 0;
    END LOOP;
END;
/

execute inser_lineas (10, 'PED-011', 'ALB-011');

delete LINEA_ALBARAN WHERE N_ALBARAN = 'ALB-011';
delete LINEA_PEDIDO WHERE N_PEDIDO = 'PED-011';


--//***Triggers***//--

--Crear tabla de control de cada uno de los eventos que realizaremos--

DROP TABLE auditar_empresa CASCADE CONSTRAINT;

CREATE TABLE auditar_empresa(
		USUARIO VARCHAR2(10),
        FECHA DATE,
        NOMBRE_TABLA VARCHAR2(20),
        ACCION VARCHAR2(65)
	);


--Trigger de control de la tabla PRODUCTO--

CREATE OR REPLACE TRIGGER control_producto
	BEFORE INSERT OR UPDATE OR DELETE ON PRODUCTO
    FOR EACH ROW
	BEGIN
		IF INSERTING THEN
			INSERT INTO auditar_empresa(USUARIO, FECHA, NOMBRE_TABLA, ACCION) VALUES(USER, SYSDATE, 'TABLA PRODUCTO','Producto nuevo registrado con nº ' || :new.C_PRODUCTO);
		ELSIF UPDATING THEN
			INSERT INTO auditar_empresa(USUARIO, FECHA, NOMBRE_TABLA, ACCION) VALUES(USER, SYSDATE, 'TABLA PRODUCTO','Producto nº ' || :old.C_PRODUCTO || ' modificado');
		ELSIF DELETING THEN
			INSERT INTO auditar_empresa(USUARIO, FECHA, NOMBRE_TABLA, ACCION) VALUES(USER, SYSDATE, 'TABLA PRODUCTO','Producto nº ' || :old.C_PRODUCTO || ' borrado');
		END IF;
	END;
/

INSERT INTO PRODUCTO VALUES ('AN-042','DIABLO IV (PS5)',79.99,'G-32147857',1.21);
UPDATE PRODUCTO SET PRECIO = 109.99 WHERE C_PRODUCTO = 'AN-042';
DELETE PRODUCTO WHERE C_PRODUCTO = 'AN-042';

--Trigger de control de la tabla CLIENTE--

CREATE OR REPLACE TRIGGER control_cliente
	BEFORE INSERT OR UPDATE OR DELETE ON CLIENTE
    FOR EACH ROW
	BEGIN
		IF INSERTING THEN
			INSERT INTO auditar_empresa(USUARIO, FECHA, NOMBRE_TABLA, ACCION) VALUES(USER, SYSDATE, 'CLIENTE', 'Nuevo cliente registrado: ' || :new.NOMBRE || ' con DNI ' || :new.DNI);
		ELSIF UPDATING THEN
			INSERT INTO auditar_empresa(USUARIO, FECHA, NOMBRE_TABLA, ACCION) VALUES(USER, SYSDATE, 'CLIENTE', ' Datos cliente modificados');
		ELSIF DELETING THEN
			INSERT INTO auditar_empresa(USUARIO, FECHA, NOMBRE_TABLA, ACCION) VALUES(USER, SYSDATE, 'CLIENTE', 'El cliente ' || :old.NOMBRE || ' con DNI ' || :old.DNI || ' ha sido borrado' );
		END IF;
	END;
/

INSERT INTO CLIENTE VALUES ('039237X','SERGIO','CACERES','C/ MARINA USERA, 18','6687899874');
UPDATE CLIENTE SET DIRECCION = 'C/ BATALLA DE LEPANDO Nº18' WHERE DNI = '039237X';
DELETE CLIENTE WHERE DNI = '039237X';


--Trigger de control de la tabla PEDIDO--

CREATE OR REPLACE TRIGGER control_pedido
	BEFORE INSERT OR UPDATE OR DELETE ON REGISTRO_PEDIDO
    FOR EACH ROW
	BEGIN
		IF INSERTING THEN
			INSERT INTO auditar_empresa(USUARIO, FECHA, NOMBRE_TABLA, ACCION) VALUES(USER, SYSDATE, 'REGISTRO_PEDIDO', 'Pedido registrado con nº: ' || :new.N_PEDIDO || ' para el DNI ' || :new.DNI);
		ELSIF UPDATING THEN
			INSERT INTO auditar_empresa(USUARIO, FECHA, NOMBRE_TABLA, ACCION) VALUES(USER, SYSDATE, 'REGISTRO_PEDIDO', 'Modificado pedido nº: ' || :new.N_PEDIDO) ;
		ELSIF DELETING THEN
			INSERT INTO auditar_empresa(USUARIO, FECHA, NOMBRE_TABLA, ACCION) VALUES(USER, SYSDATE, 'REGISTRO_PEDIDO', 'Pedido nº ' || :old.N_PEDIDO || ' con DNI ' || :old.DNI || ' ha sido borrado' );
		END IF;
	END;
/

INSERT INTO REGISTRO_PEDIDO VALUES ('PED-011','039237X','19/01/2024');
UPDATE REGISTRO_PEDIDO SET FECHA = '25/03/2023' WHERE DNI = '039237X';
DELETE REGISTRO_PEDIDO WHERE DNI = '039237X';


--Trigger de control de la tabla ALBARAN--

CREATE OR REPLACE TRIGGER control_albaran
	BEFORE INSERT OR UPDATE OR DELETE ON REGISTRO_ALBARAN
    FOR EACH ROW
	BEGIN
		IF INSERTING THEN
			INSERT INTO auditar_empresa(USUARIO, FECHA, NOMBRE_TABLA, ACCION) VALUES(USER, SYSDATE, 'REGISTRO_ALBARAN', 'Albaran registrado con nº: ' || :new.N_ALBARAN || ' para el PEDIDO ' || :new.N_PEDIDO);
		ELSIF UPDATING THEN
			INSERT INTO auditar_empresa(USUARIO, FECHA, NOMBRE_TABLA, ACCION) VALUES(USER, SYSDATE, 'REGISTRO_ALBARAN', 'Modificado pedido nº: ' || :new.N_ALBARAN) ;
		ELSIF DELETING THEN
			INSERT INTO auditar_empresa(USUARIO, FECHA, NOMBRE_TABLA, ACCION) VALUES(USER, SYSDATE, 'REGISTRO_ALBARAN', 'Albaran nº ' || :old.N_ALBARAN || ' asociado al pedido ' || :old.N_PEDIDO || ' ha sido borrado');
		END IF;
	END;
/

INSERT INTO CLIENTE VALUES ('039237X','SERGIO','CACERES','C/ MARINA USERA, 18','6687899874');
INSERT INTO REGISTRO_FACTURA VALUES ('FAC-005','16/05/2023');
INSERT INTO REGISTRO_PEDIDO VALUES ('PED-011','039237X','19/01/2024');
INSERT INTO REGISTRO_ALBARAN VALUES ('ALB-011','21/01/2023','FAC-005','PED-011');
UPDATE REGISTRO_ALBARAN SET FECHA = '25/03/2023' WHERE N_ALBARAN = 'ALB-011';
DELETE REGISTRO_ALBARAN WHERE N_ALBARAN = 'ALB-011';

--Trigger de control de la tabla FACTURA--

CREATE OR REPLACE TRIGGER control_factura
	BEFORE INSERT OR UPDATE OR DELETE ON REGISTRO_FACTURA
    FOR EACH ROW
	BEGIN
		IF INSERTING THEN
			INSERT INTO auditar_empresa(USUARIO, FECHA, NOMBRE_TABLA, ACCION) VALUES(USER, SYSDATE, 'REGISTRO_FACTURA', 'Factura generada con nº: ' || :new.N_FACTURA);
		ELSIF UPDATING THEN
			INSERT INTO auditar_empresa(USUARIO, FECHA, NOMBRE_TABLA, ACCION) VALUES(USER, SYSDATE, 'REGISTRO_FACTURA', 'Modificada factura nº: ' || :new.N_FACTURA) ;
		ELSIF DELETING THEN
			INSERT INTO auditar_empresa(USUARIO, FECHA, NOMBRE_TABLA, ACCION) VALUES(USER, SYSDATE, 'REGISTRO_FACTURA', 'Pedido nº ' || :old.N_FACTURA);
		END IF;
	END;
/

INSERT INTO REGISTRO_FACTURA VALUES ('FAC-005','16/05/2023');
UPDATE REGISTRO_FACTURA SET FECHA = '25/03/2023' WHERE N_FACTURA = 'FAC-005';
DELETE REGISTRO_FACTURA WHERE N_FACTURA = 'FAC-005';