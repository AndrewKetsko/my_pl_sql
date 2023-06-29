SET SERVEROUTPUT ON;

DECLARE
    V_YEAR NUMBER:=2021;
    V_CHECK_YEAR NUMBER;
BEGIN
    V_CHECK_YEAR:=MOD(V_YEAR,4);
    IF V_CHECK_YEAR=0 THEN
        dbms_output.put_line('LEAP YEAR');
    ELSE
        dbms_output.put_line('NON LEAP YEAR');
    END IF;
END;
/
