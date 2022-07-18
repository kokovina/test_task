DECLARE

/*Контрольное число*/
control_sum VARCHAR(20);
/*Страховой номер*/
control_number VARCHAR(20);
/*Переменная для исходного страхового номера*/
initial_control_number VARCHAR(20);
/*Переменная для сравнения с контрольным числом*/
validate_sum INTEGER;
/*ID снилса в таблице*/
my_id NUMBER;

BEGIN

/*Указываем ID снилса в таблице*/
my_id := 124;

/*Выбираем запись из таблицы*/
SELECT snils
INTO control_number
FROM SNILS
WHERE id = my_id;
DBMS_OUTPUT.put_line('СНИЛС: ' || control_number);
initial_control_number := SUBSTR(control_number, 1, 11);
/*Извлекаем из строки только цифры*/
control_number := regexp_replace(control_number,'[^[[:digit:]]]*');

/*Если СНИЛС больше 1001998*/
IF (SUBSTR(control_number, 1, 9)>1001998) THEN
/*Если без контрольного числа*/
IF LENGTH(control_number) = 9 THEN
   DBMS_OUTPUT.PUT_LINE('СНИЛС без контрольного числа');
   /*Расчет контрольного числа с помощью функции control_digit*/
   control_sum := control_digit(control_number);
   DBMS_OUTPUT.PUT_LINE('Страховой номер с контрольным числом: ' || initial_control_number || ' ' || control_sum);
   /*Записываем в конец записи контрольное число*/
   UPDATE SNILS 
     SET snils = TO_CHAR(initial_control_number || ' ' || control_sum)
   WHERE ID = my_id;

/*С контрольным числом*/
ELSE IF LENGTH(control_number) = 11 THEN
   DBMS_OUTPUT.PUT_LINE('СНИЛС c контрольным числом');
   /*Запоминаем в переменную исходное контрольное число*/
   validate_sum := TO_NUMBER(SUBSTR(control_number, 10, 2));
   /*Извлекаем страховой номер*/
   control_number := SUBSTR(control_number, 1, 9);
   /*Расчет контрольного числа с помощью функции control_digit*/
   control_sum := TO_CHAR(control_digit(control_number));
   /*Если исходное контрольное число равно рассчитаному*/
   IF control_sum = validate_sum THEN
     DBMS_OUTPUT.PUT_LINE('Контрольное число верно: ' || control_sum);
   ELSE
     DBMS_OUTPUT.PUT_LINE('Контрольное число ' || validate_sum || ' не верно. Верное контрольное число ' || control_sum);
     /*Если контрольное число в таблице было неправильное, то заменяем на верное*/
     UPDATE SNILS 
       SET snils = TO_CHAR(initial_control_number || ' ' || control_sum)
     WHERE ID = my_id;
   END IF;
  END IF;
END IF;
ELSE 
  DBMS_OUTPUT.PUT_LINE('Страховой номер меньше: 001-001-998');
END IF;
END;
