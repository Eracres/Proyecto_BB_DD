    CREATE OR REPLACE PROCEDURE modificar_precio( 
    p_articulo IN VARCHAR2, 
    p_precio IN NUMBER, 
    p_categoria IN VARCHAR2
    ) IS 
    v_precio_anterior NUMBER; 
    BEGIN 

    SELECT precio_costo INTO v_precio_anterior FROM articulos WHERE articulo = p_articulo AND categoria = p_categoria; 

    IF p_precio < v_precio_anterior * 0.98 THEN 

    UPDATE articulos 
    SET precio_costo = p_precio 
    WHERE articulo = p_articulo 
    AND categoria = p_categoria; 

    ELSE DBMS_OUTPUT.PUT_LINE('No se puede modificar el precio ya que es mayor al 2%');
    END IF; 
    
    EXCEPTION 

    WHEN no_data_found 
    THEN DBMS_OUTPUT.PUT_LINE('No se encontró el artículo'); 
    END; 
    /