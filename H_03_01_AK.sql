SELECT COUNT(J.JOB_ID)
FROM ANDREW.JOBS J
WHERE J.JOB_ID='AD_PRES';

----------------------------------------

create or replace PROCEDURE DEL_JOB(
        P_JOB_ID IN ANDREW.JOBS.JOB_ID%TYPE,
        PO_RESULT OUT VARCHAR2) IS
        
    V_IS_CREATED NUMBER;
    
BEGIN

    SELECT TO_NUMBER(COUNT(J.JOB_ID))
    INTO V_IS_CREATED
    FROM ANDREW.JOBS J
    WHERE J.JOB_ID=P_JOB_ID;
    
    IF V_IS_CREATED=0 THEN
        PO_RESULT:=P_JOB_ID||' DOESNT CREATED';
    ELSE
        DELETE FROM ANDREW.JOBS J
        WHERE J.JOB_ID=P_JOB_ID;
        --COMMIT;
        PO_RESULT:=P_JOB_ID||' DELETED SUCCESFULLY';
    END IF;
    
END DEL_JOB;
    /
    
---------------------------------------------------

DECLARE
    V_MESSAGE VARCHAR2(50);
    V_JOB_ID ANDREW.JOBS.JOB_ID%TYPE :='AD_PRES';
BEGIN
    DEL_JOB(P_JOB_ID=>V_JOB_ID,
            PO_RESULT=>V_MESSAGE);
    dbms_output.put_line(V_MESSAGE);
END;
/
    
--------------------------------------------------

SELECT *
FROM ANDREW.JOBS;
