DECLARE

/*����������� �����*/
control_sum VARCHAR(20);
/*��������� �����*/
control_number VARCHAR(20);
/*���������� ��� ��������� ���������� ������*/
initial_control_number VARCHAR(20);
/*���������� ��� ��������� � ����������� ������*/
validate_sum INTEGER;

BEGIN

FOR i IN ( 
  SELECT snils, id
  FROM SNILS 
  ) 
  LOOP 
    DBMS_OUTPUT.PUT_LINE( 
    '����� = ' || i.snils
    ); 
    initial_control_number := SUBSTR(i.snils, 1, 11);
    control_number := regexp_replace(i.snils,'[^[[:digit:]]]*');

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
   WHERE ID = i.id;

/*� ����������� ������*/
ELSE IF LENGTH(control_number) = 11 THEN
   DBMS_OUTPUT.PUT_LINE('����� c ����������� ������');
  /*���������� � ���������� �������� ����������� �����*/
   validate_sum := TO_NUMBER(SUBSTR(control_number, 10, 2));
   /*��������� ��������� �����*/
   control_number := SUBSTR(control_number, 1, 9);
  /*������ ������������ ����� � ������� ������� control_digit*/
   control_sum := control_digit(control_number);
   /*���� �������� ����������� ����� ����� ������������*/
   IF control_sum = validate_sum THEN
     DBMS_OUTPUT.PUT_LINE('����������� ����� �����: ' || control_sum);
   ELSE
     DBMS_OUTPUT.PUT_LINE('����������� ����� ' || validate_sum || ' �� �����. ������ ����������� ����� ' || control_sum);
     DBMS_OUTPUT.PUT_LINE('������ �������� �� ' || initial_control_number || ' ' || control_sum);
    /*���� ����������� ����� � ������� ���� ������������, �� �������� �� ������*/
     UPDATE SNILS 
       SET snils = TO_CHAR(initial_control_number || ' ' || control_sum)
     WHERE ID = i.id;
   END IF;
  END IF;
END IF;
ELSE 
  DBMS_OUTPUT.PUT_LINE('��������� ����� ������: 001-001-998');
END IF;
DBMS_OUTPUT.PUT_LINE(' ');
END LOOP;

END;
