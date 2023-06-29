SET SERVEROUTPUT ON;

SELECT EM.SALARY
FROM HR.EMPLOYEES EM
WHERE EM.employee_id = 101;

DECLARE
    V_SALARY NUMBER;
    V_EMPLOYEE_ID NUMBER:=150;
    V_FIRST_NAME VARCHAR(30);
BEGIN
    SELECT EM.SALARY, EM.FIRST_NAME
    INTO V_SALARY, V_FIRST_NAME
    FROM HR.EMPLOYEES EM
    WHERE EM.employee_id = V_EMPLOYEE_ID;
    DBMS_OUTPUT.PUT_LINE(V_FIRST_NAME ||' ' || V_SALARY);
END;
/

--------------------------------------------------------------

SELECT EM.FIRST_NAME ||' '|| EM.LAST_NAME AS NAME, D.DEPARTMENT_NAME
FROM HR.EMPLOYEES EM
JOIN HR.DEPARTMENTS D
ON EM.DEPARTMENT_ID=D.DEPARTMENT_ID
WHERE EM.employee_id = 107
;

DECLARE
    V_EMPLOYEE_ID HR.EMPLOYEES.EMPLOYEE_ID%TYPE:=107;
    V_DEPARTMENT_NAME HR.DEPARTMENTS.DEPARTMENT_NAME%TYPE;
    V_NAME VARCHAR(20);
BEGIN
    SELECT EM.FIRST_NAME ||' '|| EM.LAST_NAME AS NAME, D.DEPARTMENT_NAME
    INTO V_NAME, V_DEPARTMENT_NAME
    FROM HR.EMPLOYEES EM
    JOIN HR.DEPARTMENTS D
    ON EM.DEPARTMENT_ID=D.DEPARTMENT_ID
    WHERE EM.employee_id = V_EMPLOYEE_ID;
    IF V_DEPARTMENT_NAME='IT' THEN
        DBMS_OUTPUT.PUT_LINE('EMPLOYEE '|| V_NAME ||' FROM IT DEPARTMENT');
    ELSE
        DBMS_OUTPUT.PUT_LINE('EMPLOYEE '|| V_NAME ||' FROM SOME DEPARTMENT');
    END IF;
END;
/

--------------------------------------------------------

BEGIN
    FOR I IN REVERSE 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
END;
/

------------------------------------------------------

DECLARE
    V_SALARY HR.JOBS.MIN_SALARY%TYPE:=9000;
BEGIN
    FOR I IN (
        SELECT J.JOB_TITLE AS TITLE
        FROM HR.JOBS J
        WHERE V_SALARY BETWEEN J.MIN_SALARY AND J.MAX_SALARY) 
    LOOP
        DBMS_OUTPUT.PUT_LINE(I.TITLE);
    END LOOP;
END;
/

SELECT J.JOB_TITLE
FROM HR.JOBS J
WHERE 10000 BETWEEN J.MIN_SALARY AND J.MAX_SALARY
;

-----------------------------------------------------------

DECLARE
    V_LOCATION_ID HR.DEPARTMENTS.LOCATION_ID%TYPE:=1700;
BEGIN
    FOR I IN (
        SELECT 1
        FROM HR.DEPARTMENTS D
        WHERE D.LOCATION_ID = V_LOCATION_ID)
    LOOP
        DBMS_OUTPUT.PUT_LINE(V_LOCATION_ID || ' HAVE SOME');
        RETURN;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(V_LOCATION_ID || ' HAVE NONE');

END;
/

SELECT *
FROM HR.DEPARTMENTS D
WHERE D.LOCATION_ID = 1700;

----------------------------------------------------------

BEGIN
    FOR cc IN 1..10 LOOP
        IF cc = 5 THEN
            EXIT;
        END IF;
        dbms_output.put_line(cc);
    END LOOP;
    dbms_output.put_line('Наступний код після циклу');
END;
/

---------------------------------------------------------------

BEGIN
    FOR cc IN 1..10 LOOP
        IF MOD(cc, 2) = 0 THEN
            CONTINUE;
        END IF;
        dbms_output.put_line(cc);
    END LOOP;
    dbms_output.put_line('Наступний код після циклу');
END;
/

---------------------------------------------------------------

BEGIN
    FOR I IN (
        SELECT EM.FIRST_NAME, EM.SALARY
        FROM HR.EMPLOYEES EM
        ORDER BY EM.FIRST_NAME) 
    LOOP
        IF I.SALARY>=15000 THEN
            dbms_output.put_line(I.FIRST_NAME ||' HAVE SALARY: '||I.SALARY);
            EXIT;
        ELSE
            CONTINUE;
        END IF;
    END LOOP;
END;
/

SELECT EM.FIRST_NAME, EM.SALARY
FROM HR.EMPLOYEES EM
ORDER BY EM.FIRST_NAME;

---------------------------------------------------------------

DECLARE
    V_I NUMBER:=1;
BEGIN
    WHILE V_I <= 5 LOOP
        dbms_output.put_line('HELLO');
        V_I:=V_I+1;
    END LOOP;
END;
/

-----------------------------------------------------------------

DECLARE
v_salary NUMBER := 5000;
v_step_up NUMBER := 500;
BEGIN
WHILE v_salary <= 9500 LOOP
dbms_output.put_line('Підвищення зарплати на '||v_step_up||', і зараз зарплата ='||v_salary);
v_salary := v_salary + v_step_up;
END LOOP;
dbms_output.put_line('Поки що підвищення зарплати не передбачається');
END;
/

-------------------------------------------------------------------

DECLARE
    v_salary NUMBER := 5000;
    v_step_up NUMBER := 500;
BEGIN
    WHILE v_salary <= 9500 LOOP
        IF TRIM(TO_CHAR(SYSDATE,'day')) IN ('неділя','субота') THEN
            EXIT;
        END IF;
        IF v_salary IN (6500,7500) THEN
            v_salary := v_salary + v_step_up; -- якщо не прописати цю умову, підемо в так званий "безкінечний цикл"
            CONTINUE;
        END IF;
        dbms_output.put_line('Підвищення зарплати на '||v_step_up||', і зараз зарплата ='||v_salary);
        v_salary := v_salary + v_step_up;
    END LOOP;
    dbms_output.put_line('Поки що підвищення зарплати не передбачається');
END;
/

---------------------------------------------------------
SELECT *
FROM
(SELECT TT.*, ROWNUM AS ROW_NUM
FROM
(SELECT *
FROM andrew.EMPLOYEES EM
WHERE EM.DEPARTMENT_ID = 80
ORDER BY EM.HIRE_DATE) TT) TT2
WHERE TT2.ROW_NUM = 10
;

DECLARE
    V_ROW_EMP NUMBER:=1;
    V_COUNT_EMP NUMBER:=10;
    V_COEFICIENT NUMBER(2,1):=1.2;
    V_DEP_ID NUMBER:=80;
    V_EMP_ID NUMBER;
BEGIN
    WHILE V_ROW_EMP <= V_COUNT_EMP LOOP
        SELECT TT2.EMPLOYEE_ID
        INTO V_EMP_ID
        FROM
            (SELECT TT.*, ROWNUM AS ROW_NUM
            FROM
                (SELECT *
                FROM andrew.EMPLOYEES EM
                WHERE EM.DEPARTMENT_ID = V_DEP_ID
                ORDER BY EM.HIRE_DATE) TT) TT2
            WHERE TT2.ROW_NUM = V_ROW_EMP;
            
            UPDATE AMDREW.employees em
            SET em.salary = em.salary*v_COEFICIENT
            WHERE em.employee_id = v_emp_id;
    v_row_emp := v_row_emp + 1
    END LOOP;
END;
/