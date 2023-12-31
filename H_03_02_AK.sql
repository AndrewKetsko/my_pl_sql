CREATE TABLE ANDREW.DEPARTMENTS AS
SELECT *
FROM HR.DEPARTMENTS;

SELECT *
FROM ANDREW.EMPLOYEES;

SELECT EM.EMPLOYEE_ID, DEP.DEPARTMENT_NAME
FROM ANDREW.EMPLOYEES EM
JOIN ANDREW.DEPARTMENTS DEP
ON EM.DEPARTMENT_ID=DEP.DEPARTMENT_ID
WHERE EMPLOYEE_ID=105
;

CREATE FUNCTION GET_DEP_NAME(
    P_EMPLOYEE_ID IN NUMBER) 
RETURN VARCHAR2 IS 
    V_DEPARTMENT_NAME ANDREW.DEPARTMENTS.DEPARTMENT_NAME%TYPE;
BEGIN
    SELECT DEP.DEPARTMENT_NAME
    INTO V_DEPARTMENT_NAME
    FROM ANDREW.EMPLOYEES EM
    JOIN ANDREW.DEPARTMENTS DEP
    ON EM.DEPARTMENT_ID=DEP.DEPARTMENT_ID
    WHERE EMPLOYEE_ID=P_EMPLOYEE_ID;
    
    RETURN V_DEPARTMENT_NAME;
END GET_DEP_NAME;
/

SELECT EM.EMPLOYEE_ID, 
        EM.FIRST_NAME, 
        EM.LAST_NAME, 
        EM.EMAIL, 
        EM.PHONE_NUMBER, 
        EM.HIRE_DATE, 
        GET_JOB_TITLE (P_EMPLOYEE_ID=>EM.EMPLOYEE_ID) AS JOB_TITLE,
        EM.SALARY, 
        EM.COMMISSION_PCT, 
        EM.MANAGER_ID, 
        GET_DEP_NAME(P_EMPLOYEE_ID=>EM.EMPLOYEE_ID) AS DEPARTMENT_NAME
FROM ANDREW.EMPLOYEES EM;