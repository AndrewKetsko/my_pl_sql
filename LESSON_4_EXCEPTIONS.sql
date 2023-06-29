BEGIN
DBMS_OUTPUT.PUT_LINE(10/2);
DBMS_OUTPUT.PUT_LINE(1/0);
DBMS_OUTPUT.PUT_LINE(10/2);
EXCEPTION 
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('SOME ERROR '||SQLERRM);
END;
/
-----------------------------------------------------------
BEGIN
    BEGIN
        DBMS_OUTPUT.PUT_LINE(1/0);
    EXCEPTION 
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('SOME ERROR '||SQLERRM);
    END;
    DBMS_OUTPUT.PUT_LINE(10/2);
END;
/
--------------------------------------------------------------

SELECT *
FROM ANDREW.JOBS J
WHERE J.MIN_SALARY=4500;

DECLARE
V_JOB_TITLE ANDREW.JOBS.JOB_TITLE%TYPE;
BEGIN
    BEGIN
        SELECT J.JOB_TITLE
        INTO V_JOB_TITLE
        FROM ANDREW.JOBS J
        WHERE J.MIN_SALARY=4501;
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND '||SQLERRM);
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('TOO_MANY_ROWS '||SQLERRM);
    END;
    DBMS_OUTPUT.PUT_LINE(V_JOB_TITLE);
END;
/
--------------------------------------------------------
DECLARE
    v_salary NUMBER := 4000;
    v_job_title VARCHAR2(500);
    --v_job_title VARCHAR2(500);
BEGIN
    IF v_salary < 2000 THEN
        raise_application_error(-20002, 'Передана зарплата менша за 2000');
    END IF;
    BEGIN
        SELECT LISTAGG(j.job_title, ', ') --WITHIN GROUP (ORDER BY j.job_title)
        --SELECT j.job_title
        INTO v_job_title
        FROM hr.jobs j
        WHERE j.min_salary <= v_salary;
    EXCEPTION
        WHEN too_many_rows THEN
        raise_application_error(-20001, 'Вибірка повернула більше одного рядка');
    END;
    dbms_output.put_line(a => v_job_title);
    dbms_output.put_line('Далі якийсь код...');
END;
/
----------------------------------------------------------------
DECLARE
v_salary NUMBER := 1400;
v_job_title VARCHAR2(500);
err_salary EXCEPTION;
BEGIN
BEGIN
IF v_salary < 2000 THEN
raise err_salary;
END IF;
SELECT LISTAGG(j.job_title, ', ') WITHIN GROUP (ORDER BY j.job_title)
INTO v_job_title
FROM hr.jobs j
WHERE j.min_salary <= v_salary;
EXCEPTION
WHEN err_salary THEN
raise_application_error(-20002, 'Передана зарплата менша за 2000');
WHEN too_many_rows THEN
raise_application_error(-20001, 'Вибірка повернула більше одного рядка');
END;
dbms_output.put_line(a => v_job_title);
dbms_output.put_line('Далі якийсь код...');
END;
------------------------------------------------------------
