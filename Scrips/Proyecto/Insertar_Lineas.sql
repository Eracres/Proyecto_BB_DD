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