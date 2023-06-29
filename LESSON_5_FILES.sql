SELECT *
FROM ALL_DIRECTORIES;

CREATE VIEW IBAN_ACCOUNTS_V AS
SELECT ext_fl.employee_id, ext_fl.iban, ext_fl.type
FROM EXTERNAL ( (   employee_id NUMBER,
                    iban VARCHAR2(100),
                    type VARCHAR2(3) )
TYPE oracle_loader DEFAULT DIRECTORY FILES_FROM_SERVER -- вказуємо назву директорії в БД
ACCESS PARAMETERS ( records delimited BY newline
                    nologfile
                    nobadfile
                    fields terminated BY ','
                    missing field VALUES are NULL )
LOCATION('IBAN_ACCOUNTS.csv') -- вказуємо назву файлу
REJECT LIMIT UNLIMITED /*немає обмежень для відкидання рядків*/ ) ext_fl;

SELECT *
FROM IBAN_ACCOUNTS_V;

CREATE OR REPLACE PROCEDURE WRITE_FILE_TO_DISK IS
                file_handle UTL_FILE.FILE_TYPE;
                file_location VARCHAR2(200) := 'FILES_FROM_SERVER'; -- Назва створеної директорії
                file_name VARCHAR2(200) := 'FILE_AK.csv'; -- Ім'я файлу, який буде записаний
                file_content VARCHAR2(4000); -- Вміст файлу
BEGIN
        FOR I IN (
            SELECT JOB_ID||','||JOB_TITLE||','||MIN_SALARY||','||MAX_SALARY AS FILE_CONTENT
            FROM ANDREW.JOBS)
        LOOP
            FILE_CONTENT:=FILE_CONTENT||I.FILE_CONTENT||CHR(10);
        END LOOP;
    FILE_HANDLE:=UTL_FILE.FOPEN(FILE_LOCATION,FILE_NAME,'W');
    UTL_FILE.PUT_RAW(FILE_HANDLE,UTL_RAW.CAST_TO_RAW(FILE_CONTENT));
    UTL_FILE.FCLOSE(FILE_HANDLE);
EXCEPTION
    WHEN OTHERS THEN 
    RAISE;
END WRITE_FILE_TO_DISK;
/

SELECT JOB_ID||','||JOB_TITLE||','||MIN_SALARY||','||MAX_SALARY AS FILE_CONTENT
FROM ANDREW.JOBS;


BEGIN
WRITE_FILE_TO_DISK;
END;
/

DECLARE
    v1 VARCHAR2(2000);
    f1 utl_file.file_type;
    file_location VARCHAR2(200) := 'FILES_FROM_SERVER';
    file_name VARCHAR2(200) := 'PROJECTS.csv';
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

DECLARE
l_directory VARCHAR2(100) :='FILES_FROM_SERVER';
l_file_name VARCHAR2(100) :='file.csv';
BEGIN
UTL_FILE.FREMOVE(l_directory, l_file_name);
DBMS_OUTPUT.PUT_LINE('Файл '||l_file_name||' успішно видалено.');
END;
/





