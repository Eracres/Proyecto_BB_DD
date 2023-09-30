1.	Una librería almacena la información de sus libros en una tabla llamada "libros".
	Eliminamos la tabla:
	 drop table libros;
	Creamos la tabla "libros" con la siguiente estructura:
	 create table libros(
	  codigo number(3),
	  titulo varchar2(40),
	  autor varchar2(30),
	  precio number(5,2)
	);
	Damos de alta los siguientes registros:

	insert into libros values(100,'Uno','Richard Bach',15);
	insert into libros values(300,'Aprenda PHP','Mario Molina',55);
	insert into libros values(102,'Matematica estas ahi','Paenza',18);
	insert into libros values(105,'El aleph','Borges',25);
	insert into libros values(109,'El experto en laberintos','Gaskin',20);
	insert into libros values(204,'Alicia en el pais de las maravillas','Carroll',31);


	Creamos una función que reciba 1 parámetro (un valor numérico a incrementar) y retorne el valor ingresado como argumento con el incremento del 10%.


	CREATE OR REPLACE FUNCTION incremento(valor NUMBER) RETURN NUMBER 
	IS
	BEGIN
		RETURN valor * 1.1;
	END;
	/
	
	SELECT incremento(100) FROM DUAL;
	
2.	Realizamos un "select" sobre "libros" que muestre el título, precio y llamamos a la función creada
	anteriormente para que nos devuelva el precio incrementado en un 10%.
	
	CREATE OR REPLACE FUNCTION incremento(valor NUMBER) RETURN NUMBER 
	IS
	BEGIN
		RETURN valor * 1.1;
	END;
	/
	
	SELECT TITULO, incremento(PRECIO) FROM LIBROS;
	
3.	Creamos otra función que reciba 2 parámetros, un valor a incrementar y el incremento, y que nos 
	retorne el valor ingresado como primer argumento con el incremento especificado por el segundo argumento.
	
	CREATE OR REPLACE FUNCTION incremento2(valor NUMBER, increm NUMBER) RETURN NUMBER 
	IS
	BEGIN
		RETURN valor * (1+ increm/100);
	END;
	/
	
	SELECT incremento2(100, 200) FROM DUAL;
	
4.	Creamos o reemplazamos una función que recibe un parámetro de tipo numérico y retorna una cadena de caracteres. 
	Se define una variable en la zona de definición de variables denominada "valorretornado" de tipo varchar. 
	En el cuerpo de la función empleamos una estructura condicional (if) para averiguar si el valor enviado como 
	argumento es menor o igual a 20, si lo es, almacenamos en la variable "valorretornado" la cadena "economico", 
	en caso contrario guardamos en tal variable la cadena "costoso"; al finalizar la estructura condicional retornamos la variable "valorretornado":
	
	CREATE OR REPLACE FUNCTION opinion_precio(valor NUMBER) RETURN VARCHAR2 IS
		valorretornado VARCHAR(50);
	BEGIN
		IF valor > 20 THEN
			valorretornado := 'costoso';
		ELSE
			valorretornado := 'economico';
		END IF;
		
		RETURN valorretornado;
	
	END;
	/
	
5.	Realizamos un "select" para mostrar el título, precio y una cadena que indique si el libro es económico o costoso (llamando a la función creada anteriormente.

	SELECT TITULO, PRECIO, opinion_precio(PRECIO) AS CALIFICACION FROM LIBROS;
	
6- Crear una función que sume dos números.

	CREATE OR REPLACE FUNCTION sumar_nums (num1 NUMBER, num2 NUMBER) RETURN NUMBER IS
		resultado NUMBER;
	BEGIN
		resultado := num1 + num2;
		RETURN resultado;
	END;
	/
	
	DECLARE
		resultado NUMBER;
	BEGIN
		resultado := sumar_nums(5, 10);
		DBMS_OUTPUT.PUT_LINE('El resultado es: ' || resultado);
	END;
	/
	
7- Crear una función que visualice una cadena al revés.

	CREATE OR REPLACE FUNCTION rev_char(cadena VARCHAR) RETURN VARCHAR IS
		rev_cadena VARCHAR;
	BEGIN
		
	END;
	/