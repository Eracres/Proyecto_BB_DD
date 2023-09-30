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