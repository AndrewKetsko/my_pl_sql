CREATE TRIGGER delete_as_logs BEFORE
    INSERT ON andrew.logs
    FOR EACH ROW
DECLARE
    --PRAGMA AUTONOMOUS_TRANSACTION;
 BEGIN
    DELETE FROM andrew.logs l
    WHERE
        l.log_date < trunc(
            sysdate, 'DD'
        );

    COMMIT;
END delete_as_logs;
/

BEGIN
    to_log(
          'PROCESS TEST',
          'TEST TEXT2'
    );
END;
/

ALTER TRIGGER delete_as_logs DISABLE;

ALTER TRIGGER delete_as_logs ENABLE;
----------------------------------------------------

CREATE TABLE job_history (
    employee_id NUMBER,
    start_date  DATE,
    end_date    DATE,
    job_id      VARCHAR2(10)
);

SELECT
    *
FROM
    employees e
WHERE
    e.employee_id = 150;

CREATE TRIGGER JOB_HISTORY_LOG AFTER
    UPDATE ON andrew.EMPLOYEES
    FOR EACH ROW
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
 BEGIN
IF :OLD.JOB_ID!=: new.job_id THEN

UPDATE job_history jb
SET jb.end_date = TRUNC(SYSDATE, 'DD')
WHERE jb.employee_id = :OLD.employee_id
AND jb.job_id = :OLD.job_id;

IF SQL%ROWCOUNT = 0 THEN
INSERT INTO job_history(employee_id, start_date, end_date, job_id)
VALUES (:OLD.employee_id, :OLD.hire_date, TRUNC(SYSDATE, 'DD'), :OLD.job_id);
END IF;
INSERT INTO job_history(employee_id, start_date, end_date, job_id)
VALUES (:NEW.employee_id, TRUNC(SYSDATE, 'DD'), to_date('31.12.2999', 'DD.MM.YYYY'), :NEW.job_id);

END IF;
COMMIT;
END job_history_log;
/

UPDATE EMPLOYEES EM
SET EM.JOB_ID = 'ST_MAN'
WHERE EM.EMPLOYEE_ID=150;

