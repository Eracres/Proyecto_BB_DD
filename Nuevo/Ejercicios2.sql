CREATE OR REPLACE PROCEDURE modificar_precio (
nb_articulo IN VARCHAR2,
nuevo_precio IN NUMBER,
categoria IN VARCHAR2
) AS
precio_anterior NUMBER;
BEGIN

SELECT PRECIO_COSTO INTO precio_anterior FROM ARTICULOS WHERE ARTICULO = nb_articulo;

IF ((nuevo_precio - precio_anterior) / precio_anterior) > 0.02 THEN

DBMS_OUTPUT.PUT_LINE('No se puede modificar el precio ya que es mayor al 2%');

ELSE

UPDATE ARTICULOS 
SET PRECIO_COSTO = nuevo_precio 
WHERE ARTICULO = nb_articulo
AND CATEGORIA = categoria;


END IF;

EXCEPTION

WHEN NO_DATA_FOUND 
THEN DBMS_OUTPUT.PUT_LINE('No se encontró el artículo');
END;
/
