/*Функция формирования контрольного числа*/
CREATE OR REPLACE FUNCTION control_digit (control_number VARCHAR)
RETURN VARCHAR IS
   /*Контрольное число */
   control_sum INTEGER :=0;
   /*Переменная для итераций*/
   j INTEGER :=0;
BEGIN 
   /*Рассчет котрольного числа*/
   FOR i IN REVERSE 1..LENGTH(control_number) LOOP
    control_sum := control_sum + SUBSTR(control_number, i, 1)*(j+1);
    j := j+1;
   END LOOP;
   IF control_sum < 100 THEN
     control_sum := control_sum;
   END IF;
   /*Частные случаи*/
    IF control_sum = 100 OR control_sum = 101 THEN
     control_sum :=0;
   END IF;
   IF control_sum > 100 THEN
     control_sum := MOD(control_sum, 101);
      IF control_sum = 100 OR control_sum = 101 THEN
       control_sum :=0;
     END IF;
   END IF;
   
   RETURN TO_CHAR(control_sum, 'FM00'); 
   
END control_digit; 
