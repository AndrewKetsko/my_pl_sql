select em.job_id
from hr.employees em
where em.employee_id=202
;

select j.job_title
FROM hr.jobs j
where J.JOB_id='MK_REP'
;

DECLARE
    V_EMPLOYEE_ID HR.EMPLOYEES.EMPLOYEE_ID%TYPE:=110;
    V_JOB_ID HR.EMPLOYEES.JOB_ID%TYPE;
    V_JOB_TITLE HR.JOBS.JOB_TITLE%TYPE;
BEGIN
    select em.job_id
    INTO V_JOB_ID
    from hr.employees em
    where em.employee_id=V_EMPLOYEE_ID;
    select j.job_title
    INTO V_JOB_TITLE
    FROM hr.jobs j
    where J.JOB_id=V_JOB_ID;
    dbms_output.put_line('EMPLOYEE WITH ID: '||V_EMPLOYEE_ID||' HOLDS POSITION '||V_JOB_TITLE);
END;
/

------------------------------------------------------

select em.employee_id, em.job_id, j.job_title
from hr.employees em
join hr.jobs j
on em.job_id = j.job_id
where em.employee_id=202
;

DECLARE
    V_EMPLOYEE_ID HR.EMPLOYEES.EMPLOYEE_ID%TYPE:=110;
    V_JOB_TITLE HR.JOBS.JOB_TITLE%TYPE;
BEGIN
    select j.job_title
    INTO V_JOB_TITLE
    from hr.employees em
    join hr.jobs j
    on em.job_id = j.job_id
    where em.employee_id=V_EMPLOYEE_ID;
    dbms_output.put_line('EMPLOYEE WITH ID: '||V_EMPLOYEE_ID||' HOLDS POSITION '||V_JOB_TITLE);
END;
/

