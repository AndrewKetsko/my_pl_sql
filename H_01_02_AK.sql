SET SERVEROUTPUT ON;

DECLARE
    V_DATE DATE:=TO_DATE('30.06.2023','DD.MM.YYYY');
    V_DAY NUMBER;
BEGIN
    V_DAY:=TO_NUMBER(TO_CHAR(V_DATE,'DD'));
    IF V_DAY=TO_NUMBER(TO_CHAR(LAST_DAY(TRUNC(SYSDATE)),'DD')) THEN
        dbms_output.put_line('SALARY DAY');
    ELSIF V_DAY=15 THEN
        dbms_output.put_line('ADVANCE DAY');
    ELSIF V_DAY<15 THEN
        dbms_output.put_line('WAITING ADVANCE DAY');
    ELSE
        dbms_output.put_line('WAITING SALARY DAY');
    END IF;
END;
/
