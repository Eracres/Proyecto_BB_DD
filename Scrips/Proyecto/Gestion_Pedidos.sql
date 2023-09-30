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
			/*WHEN 2 THEN
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
                */
            ELSE DBMS_OUTPUT.PUT_LINE('No hay mas opciones disponibles');
        END CASE;
    END;
BEGIN
    my_procedure(opcion);
END;
/