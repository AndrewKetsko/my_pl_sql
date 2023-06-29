SET DEFINE OFF;

------------------------------------------

SELECT SYS.GET_NBU(p_url => 'https://bank.gov.ua/NBUStatService/v1/statdirectory/exchange?valcode=USD&date=20230513&json') AS res
FROM dual;

----------------------------------------------

CREATE OR REPLACE FUNCTION get_needed_curr(
            p_valcode IN VARCHAR2 DEFAULT 'USD',
            p_date IN DATE DEFAULT SYSDATE) 
        RETURN VARCHAR2 IS
    v_json VARCHAR2(1000);
    v_date VARCHAR2(15) := TO_CHAR(p_date,'YYYYMMDD');
BEGIN
    SELECT sys.get_nbu(p_url => 'https://bank.gov.ua/NBUStatService/v1/statdirectory/exchange?valcode='||p_valcode||'&date='||v_date||'&json') AS res
    INTO v_json
    FROM dual;
    RETURN v_json;
END get_needed_curr;
/

----------------------------------

select get_needed_curr(
        p_valcode => 'EUR', -- PLN, KZT, AMD
        p_date => SYSDATE-5)
from dual;

-------------------------------------------

SELECT * --tt.r030, tt.txt, tt.rate, tt.cur, TO_DATE(tt.exchangedate,'dd.mm.yyyy') AS exchangedate
FROM (
    SELECT get_needed_curr(
        p_valcode => 'EUR',
        p_date => SYSDATE-5) AS json_value FROM dual)
CROSS JOIN json_table(
    json_value,'$[*]'
    COLUMNS(
        r030 NUMBER PATH '$.r030',
        txt VARCHAR2(100) PATH '$.txt',
        rate NUMBER PATH '$.rate',
        cur VARCHAR2(100) PATH '$.cc',
        exchangedate VARCHAR2(100) PATH '$.exchangedate')) TT;
        
--------------------------------------------------
        
CREATE TABLE cur_exchange( 
    r030 NUMBER,
    txt VARCHAR2(100),
    rate NUMBER,
    cur VARCHAR2(100),
    exchangedate DATE);

--------------------------------------------------------

DECLARE
    v_list_curr VARCHAR2(200) := 'USD,EUR,KZT,AMD,GBP,ILS';
BEGIN
    FOR cc IN (
        SELECT REGEXP_SUBSTR(v_list_curr, '[^,]+', 1, LEVEL) AS cur_value
        FROM dual
        CONNECT BY LEVEL <= REGEXP_COUNT(v_list_curr, ',') + 1)
    LOOP
    
    INSERT INTO cur_exchange (r030, txt, rate, cur, exchangedate)
    SELECT tt.r030, tt.txt, tt.rate, tt.cur, TO_DATE(tt.exchangedate, 'dd.mm.yyyy') AS exchangedate
    FROM (
        SELECT get_needed_curr(p_valcode => cc.cur_value,p_date => SYSDATE) AS json_value FROM dual)
        CROSS JOIN json_table(
            json_value, '$[*]'
            COLUMNS(
                r030 NUMBER PATH '$.r030',
                txt VARCHAR2(100) PATH '$.txt',
                rate NUMBER PATH '$.rate',
                cur VARCHAR2(100) PATH '$.cc',
                exchangedate VARCHAR2(100) PATH '$.exchangedate')) TT;
    END LOOP;
END;
/

-------------------------------------------------------------

ALTER TABLE cur_exchange
ADD (change_date DATE DEFAULT SYSDATE);

---------------------------------------------------------------

CREATE OR REPLACE PROCEDURE add_test_curr IS
    BEGIN
        INSERT INTO cur_exchange (r030, txt, rate, cur, exchangedate)
        SELECT 
            ROUND(dbms_random.value(100, 1000)) AS r030,
            'Тестова валюта №'||ROUND(dbms_random.value(1, 100)) AS txt,
            ROUND(dbms_random.value(20, 50), 4) AS rate,
            dbms_random.string('X',3) AS cur,
            TRUNC(SYSDATE, 'DD') AS exchangedate
        FROM dual;
    COMMIT;
END add_test_curr;
/

----------------------------------------------------

BEGIN
    sys.dbms_scheduler.create_job(
        job_name => 'test_update_curr',
        job_type => 'PLSQL_BLOCK',
        job_action => 'begin add_test_curr(); end;',
        start_date => SYSDATE,
        repeat_interval => 'FREQ=SECONDLY; INTERVAL=30',
        end_date => TO_DATE(NULL),
        job_class => 'DEFAULT_JOB_CLASS',
        enabled => TRUE,
        auto_drop => FALSE,
        comments => 'Оновлення курс валют тестовими даними');
END;
/

---------------------------------------------------

SELECT *
FROM cur_exchange
ORDER BY change_date;

------------------------------------------------------

SELECT *
FROM all_scheduler_jobs sj;

--------------------------------------------------

SELECT *
FROM all_scheduler_job_run_details l;

--------------------------------------------------------

BEGIN
dbms_scheduler.disable(name=>'TEST_UPDATE_CURR', force => TRUE);
END;
/

------------------------------------------------------------

BEGIN
dbms_scheduler.enable(name=>'TEST_UPDATE_CURR');
END;
/

--------------------------------------------------------------

BEGIN
DBMS_SCHEDULER.RUN_JOB(job_name => 'TEST_UPDATE_CURR');
END;
/

-----------------------------------------------------------------

BEGIN
dbms_scheduler.drop_job(job_name => 'TEST_UPDATE_CURR');
END;
/
