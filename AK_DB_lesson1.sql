set SERVEROUTPUT ON;


BEGIN
    DBMS_OUTPUT.PUT_LINE('hello');
    DBMS_OUTPUT.PUT_LINE('sysdate: '|| sysdate);
END;
/

DECLARE
v_num number:=10;
v_name varchar(20):='AK';
begin
DBMS_OUTPUT.PUT_LINE(v_num);
DBMS_OUTPUT.PUT_LINE(v_name);
end;
/

declare
v_name varchar(20);
begin
DBMS_OUTPUT.PUT_LINE(v_name);
v_name:='AK';
DBMS_OUTPUT.PUT_LINE(v_name);
end;
/

declare
v_num number:=5;
begin
DBMS_OUTPUT.PUT_LINE(v_num);
v_num:=10;
DBMS_OUTPUT.PUT_LINE(v_num);
v_num:=v_num+10;
DBMS_OUTPUT.PUT_LINE(v_num);
end;
/

DECLARE
v_sysdate date := SYSDATE;
BEGIN
--v_sysdate := TO_DATE('05.04.2023','DD.MM.YYYY');
IF to_char(v_sysdate,'d') IN ('6','7') THEN
dbms_output.put_line('Вихідні');
ElSIF to_char(v_sysdate,'d') = '3' THEN
dbms_output.put_line('Середа - маленька п''ятниця'); -- зверніть увагу на екранування
ELSE
dbms_output.put_line('Будні');
END IF;
END;
/

DECLARE
v_num1 NUMBER := 10;
v_num2 NUMBER := 2;
v_action VARCHAR2(1) :='+';
BEGIN
--dbms_output.put_line('Action is "' || v_action || '", result:');
IF v_action ='+' THEN
dbms_output.put_line(v_num1 + v_num2);
ELSIF v_action ='-' THEN
dbms_output.put_line(v_num1 - v_num2);
ELSIF v_action ='*' THEN
dbms_output.put_line(v_num1 * v_num2);
ELSIF v_action ='/' THEN
dbms_output.put_line(v_num1 / v_num2);
ELSE
dbms_output.put_line('Невідома дія');
END IF;
END;
/
