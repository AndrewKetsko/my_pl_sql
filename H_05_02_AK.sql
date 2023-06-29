CREATE OR REPLACE VIEW REP_PROJECT_DEP_V AS
    SELECT 
        V.PROJECT_NAME,
        EM.DEPARTMENT_ID, 
        COUNT(EM.EMPLOYEE_ID) AS EMPLOYEES_COUNT, 
        COUNT(DISTINCT EM.MANAGER_ID) AS UNIQUE_MANAGERS, 
        SUM(EM.SALARY) AS SUM_SALARY
    FROM EMPLOYEES EM
    JOIN(
        SELECT ext_fl.PROJECT_ID, ext_fl.PROJECT_NAME, ext_fl.DEPARTMENT_ID
        FROM EXTERNAL ( (   PROJECT_ID NUMBER,
                            PROJECT_NAME VARCHAR2(100),
                            DEPARTMENT_ID NUMBER )
        TYPE oracle_loader DEFAULT DIRECTORY FILES_FROM_SERVER
        ACCESS PARAMETERS ( records delimited BY newline
                            nologfile
                            nobadfile
                            fields terminated BY ','
                            missing field VALUES are NULL )
        LOCATION('PROJECTS.csv')
        REJECT LIMIT UNLIMITED) ext_fl) V
    ON EM.DEPARTMENT_ID = V.DEPARTMENT_ID
    GROUP BY V.PROJECT_NAME, EM.DEPARTMENT_ID
    ORDER BY 2;

-------------------------------------------------------

SELECT *
FROM ANDREW.REP_PROJECT_DEP_V;

------------------------------------------------------

CREATE OR REPLACE PROCEDURE WRITE_TOTAL_PROJ_INDEX_TO_DISK IS
                file_handle UTL_FILE.FILE_TYPE;
                file_location VARCHAR2(200) := 'FILES_FROM_SERVER';
                file_name VARCHAR2(200) := 'TOTAL_PROJ_INDEX_AK.csv';
                file_content VARCHAR2(4000):='PROJECT_NAME,DEPARTMENT_ID,EMPLOYEES_COUNT,UNIQUE_MANAGERS,SUM_SALARY'||CHR(10);
BEGIN
        FOR I IN (
            SELECT PROJECT_NAME||','||DEPARTMENT_ID||','||EMPLOYEES_COUNT||','||UNIQUE_MANAGERS||','||SUM_SALARY AS FILE_CONTENT
            FROM ANDREW.REP_PROJECT_DEP_V)
        LOOP
            FILE_CONTENT:=FILE_CONTENT||I.FILE_CONTENT||CHR(10);
        END LOOP;
    FILE_HANDLE:=UTL_FILE.FOPEN(FILE_LOCATION,FILE_NAME,'W');
    UTL_FILE.PUT_RAW(FILE_HANDLE,UTL_RAW.CAST_TO_RAW(FILE_CONTENT));
    UTL_FILE.FCLOSE(FILE_HANDLE);
EXCEPTION
    WHEN OTHERS THEN 
    RAISE;
END WRITE_TOTAL_PROJ_INDEX_TO_DISK;
/

-------------------------------------------------------

BEGIN
WRITE_TOTAL_PROJ_INDEX_TO_DISK;
END;
/

----------------------------------------------------------

DECLARE
    v1 VARCHAR2(2000);
    f1 utl_file.file_type;
    file_location VARCHAR2(200) := 'FILES_FROM_SERVER';
    file_name VARCHAR2(200) := 'TOTAL_PROJ_INDEX_AK.csv';
BEGIN
    f1 := utl_file.fopen(file_location, file_name, 'R');
        LOOP
            BEGIN
                utl_file.get_line(f1, v1);
                dbms_output.put_line(v1);
            EXCEPTION
                WHEN no_data_found THEN
                EXIT;
            END;
        END LOOP;
    IF utl_file.is_open(f1) THEN
        dbms_output.put_line('File '|| file_name || ' is exist');
    END IF;
    utl_file.fclose(f1);
    EXCEPTION
        WHEN OTHERS THEN
        dbms_output.put_line('File '|| file_name || ' is NOT exist');
END;
/
