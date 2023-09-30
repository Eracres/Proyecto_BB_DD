DECLARE 
   num_emp NUMBER;
   nuevo_num NUMBER;
BEGIN
    SELECT MAX(EMP_NO) INTO num_emp FROM EMPLE;
    nuevo_num := num_emp + 1;
    INSERT INTO EMPLE VALUES (nuevo_num, 'MORENO', 'OFICIAL', 7554, '16/03/2019', 3500, 750, 10);
END;
/