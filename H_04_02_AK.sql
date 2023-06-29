    PROCEDURE DEL_JOB(
        P_JOB_ID IN ANDREW.JOBS.JOB_ID%TYPE,
        PO_RESULT OUT VARCHAR2) IS
    BEGIN
        CHECK_WORK_TIME;
        BEGIN
            DELETE FROM ANDREW.JOBS J
            WHERE J.JOB_ID=P_JOB_ID;
            --COMMIT;
        EXCEPTION
            WHEN no_data_found THEN
            raise_application_error (-20004, 'Посада '||p_job_id||' не існує');
        END;
            PO_RESULT:=P_JOB_ID||' DELETED SUCCESFULLY';
    END DEL_JOB;