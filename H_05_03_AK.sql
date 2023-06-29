INSERT INTO ANDREW.EMPLOYEES
SELECT 207,'Andrew','Ketsko','MONICM82','111.566.6666', trunc(sysdate,'dd'),'IT_DB', 10000, 0.2, 100, 100
FROM DUAL;
COMMIT;
--------------------------------------

SELECT EM.DEPARTMENT_ID, COUNT(EM.EMPLOYEE_ID) AS EMPLOYEES_COUNT
FROM ANDREW.EMPLOYEES EM
GROUP BY EM.DEPARTMENT_ID
ORDER BY 1;

------------------------------------------

SELECT EM.EMAIL||'@I.UA'
FROM ANDREW.EMPLOYEES EM
WHERE EM.EMPLOYEE_ID = 207;

---------------------------------------------

DECLARE
    V_EMP_ID NUMBER :=207;
    v_recipient VARCHAR2(50);
    v_subject VARCHAR2(50) := 'test_subject';
    v_mes VARCHAR2(5000) := 'Вітаю шановний! </br> Ось звіт з нашоЇ компанії: </br></br>';
BEGIN
    SELECT EM.EMAIL||'@I.UA'
    INTO v_recipient
    FROM ANDREW.EMPLOYEES EM
    WHERE EM.EMPLOYEE_ID = V_EMP_ID;
    
    SELECT
        v_mes||'<!DOCTYPE html>
        <html>
        <head>
        <title></title>
        <style>
        table, th, td {border: 1px solid;}
        .center{text-align: center;}
        </style>
        </head>
        <body>
        <table border=1 cellspacing=0 cellpadding=2 rules=GROUPS frame=HSIDES>
        <thead>
        <tr align=left>
        <th>DEPARTMENT ID</th>
        <th>EMPLOYEES COUNT</th>
        </tr>
        </thead>
        <tbody>
        '|| list_html || '
        </tbody>
        </table>
        </body>
        </html>' AS html_table
    INTO v_mes
    FROM (
        SELECT LISTAGG('<tr align=left>
        <td>' || DEPARTMENT_ID || '</td>' || '
        <td class=''center''> ' || EMPLOYEES_COUNT||'</td>
        </tr>', '<tr>')
    WITHIN GROUP(ORDER BY EMPLOYEES_COUNT) AS list_html
    FROM ( 
        SELECT EM.DEPARTMENT_ID, COUNT(EM.EMPLOYEE_ID) AS EMPLOYEES_COUNT
        FROM ANDREW.EMPLOYEES EM
        GROUP BY EM.DEPARTMENT_ID));

    sys.sendmail(p_recipient => v_recipient,
    p_subject => v_subject,
    p_message => v_mes || ' ');
END;
/
