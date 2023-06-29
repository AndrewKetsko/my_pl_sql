SET DEFINE OFF;

----------------------------------

SELECT SYS.GET_NBU(p_url => 'https://bank.gov.ua/NBU_uonia?id_api=UONIA_UnsecLoansDepo&json') AS res
FROM dual;

--------------------------------

CREATE TABLE interbank_index_ua_history ( 
    dt DATE,
    id_api VARCHAR2(100),
    value NUMBER,
    special VARCHAR2(10));
    
----------------------------------------

SELECT *
FROM interbank_index_ua_v;

------------------------------------

CREATE OR REPLACE VIEW interbank_index_ua_v (DT, ID_API, VALUE, SPECIAL) AS
    SELECT TO_DATE(TT.DT,'DD.MM.YYYY') AS DT, TT.ID_API, TT.VALUE, TT.SPECIAL
    FROM(
        SELECT SYS.GET_NBU(p_url => 'https://bank.gov.ua/NBU_uonia?id_api=UONIA_UnsecLoansDepo&json') AS RESULT
        FROM dual)
    CROSS JOIN JSON_TABLE(
        RESULT,'$[*]'
        COLUMNS(
            DT VARCHAR2(50) PATH'$.dt',
            ID_API VARCHAR2(50) PATH'$.id_api',
            VALUE NUMBER PATH'$.value',
            SPECIAL VARCHAR2(10) PATH'$.special'))TT;

---------------------------------------

SELECT *
FROM interbank_index_ua_v;

---------------------------------------------

CREATE OR REPLACE PROCEDURE download_ibank_index_ua IS
BEGIN
    INSERT INTO interbank_index_ua_history (DT, ID_API, VALUE, SPECIAL)
    SELECT DT, ID_API, VALUE, SPECIAL
    FROM  interbank_index_ua_v;
    COMMIT;
END download_ibank_index_ua;
/

-------------------------------------------

BEGIN
download_ibank_index_ua;
END;
/

------------------------------------------

BEGIN
    sys.dbms_scheduler.create_job(
        job_name => 'ADD_INTERBANK_INDEX_DAILY',
        job_type => 'PLSQL_BLOCK',
        job_action => 'begin download_ibank_index_ua(); end;',
        start_date => SYSDATE,
        repeat_interval => 'FREQ=DAILY;BYHOUR=9;BYMINUTE=00',
        end_date => TO_DATE(NULL),
        job_class => 'DEFAULT_JOB_CLASS',
        enabled => TRUE,
        auto_drop => FALSE,
        comments => 'ADD_INTERBANK_INDEX_DAILY');
END;
/

-------------------------------

SELECT *
FROM all_scheduler_jobs;

------------------------------------------

BEGIN
dbms_scheduler.disable(name=>'ADD_INTERBANK_INDEX_DAILY', force => TRUE);
END;
/

