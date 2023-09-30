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

/* Triggers */

--Tabla de control--

CREATE TABLE auditar_proyecto(
	USUARIO VARCHAR2(30),
    FECHA DATE,
    ACCION VARCHAR2(30)
);

