    PROCEDURE CHECK_WORK_TIME IS
        BEGIN

        IF TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE = AMERICAN') IN ('SAT', 'SUN') THEN
            raise_application_error (-20205, 'Ви можете вносити зміни лише у робочі дні');
        END IF;
    
    END CHECK_WORK_TIME;