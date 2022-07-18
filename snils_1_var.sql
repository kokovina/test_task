DECLARE

/*����������� �����*/
control_sum VARCHAR(20);
/*��������� �����*/
control_number VARCHAR(20);
/*���������� ��� ��������� ���������� ������*/
initial_control_number VARCHAR(20);
/*���������� ��� ��������� � ����������� ������*/
validate_sum INTEGER;
/*ID ������ � �������*/
my_id NUMBER;

BEGIN

/*��������� ID ������ � �������*/
my_id := 124;

/*�������� ������ �� �������*/
SELECT snils
INTO control_number
FROM SNILS
WHERE id = my_id;
DBMS_OUTPUT.put_line('�����: ' || control_number);
initial_control_number := SUBSTR(control_number, 1, 11);
/*��������� �� ������ ������ �����*/
control_number := regexp_replace(control_number,'[^[[:digit:]]]*');

/*���� ����� ������ 1001998*/
IF (SUBSTR(control_number, 1, 9)>1001998) THEN
/*���� ��� ������������ �����*/
IF LENGTH(control_number) = 9 THEN
   DBMS_OUTPUT.PUT_LINE('����� ��� ������������ �����');
   /*������ ������������ ����� � ������� ������� control_digit*/
   control_sum := control_digit(control_number);
   DBMS_OUTPUT.PUT_LINE('��������� ����� � ����������� ������: ' || initial_control_number || ' ' || control_sum);
   /*���������� � ����� ������ ����������� �����*/
   UPDATE SNILS 
     SET snils = TO_CHAR(initial_control_number || ' ' || control_sum)
   WHERE ID = my_id;

/*� ����������� ������*/
ELSE IF LENGTH(control_number) = 11 THEN
   DBMS_OUTPUT.PUT_LINE('����� c ����������� ������');
   /*���������� � ���������� �������� ����������� �����*/
   validate_sum := TO_NUMBER(SUBSTR(control_number, 10, 2));
   /*��������� ��������� �����*/
   control_number := SUBSTR(control_number, 1, 9);
   /*������ ������������ ����� � ������� ������� control_digit*/
   control_sum := TO_CHAR(control_digit(control_number));
   /*���� �������� ����������� ����� ����� ������������*/
   IF control_sum = validate_sum THEN
     DBMS_OUTPUT.PUT_LINE('����������� ����� �����: ' || control_sum);
   ELSE
     DBMS_OUTPUT.PUT_LINE('����������� ����� ' || validate_sum || ' �� �����. ������ ����������� ����� ' || control_sum);
     /*���� ����������� ����� � ������� ���� ������������, �� �������� �� ������*/
     UPDATE SNILS 
       SET snils = TO_CHAR(initial_control_number || ' ' || control_sum)
     WHERE ID = my_id;
   END IF;
  END IF;
END IF;
ELSE 
  DBMS_OUTPUT.PUT_LINE('��������� ����� ������: 001-001-998');
END IF;
END;
