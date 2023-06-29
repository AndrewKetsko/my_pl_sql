DECLARE
    v_table VARCHAR2(50) := 'products_old';
    v_dynamic_sql VARCHAR2(500);
    v_sum NUMBER;
BEGIN
    v_dynamic_sql := 'SELECT SUM(p.price_sales) FROM hr.'||v_table||' p';
    dbms_output.put_line(v_dynamic_sql);
    EXECUTE IMMEDIATE v_dynamic_sql INTO v_sum;
    dbms_output.put_line(v_sum);
END;
/
---------------------------------------

BEGIN
-- приклад коди ми хочемо, щоб наш DDL код був "читабельний"
EXECUTE IMMEDIATE
'
CREATE TABLE test1
(id NUMBER,
val VARCHAR2(50))
';
-- приклад коли, ми можемо наш DDL код, написати в один рядок
EXECUTE IMMEDIATE 'CREATE TABLE test2 (id NUMBER, val VARCHAR2(50))';
END;
/

-------------------------------------------------

BEGIN
    FOR del_tb IN ( SELECT table_name
                    FROM all_tables
                    WHERE owner = 'ANDREW'
                    AND table_name LIKE 'TEST%' ) LOOP
        dbms_output.put_line('DROP TABLE ' || del_tb.table_name || ';'); -- вивести на екран команду
        EXECUTE IMMEDIATE 'DROP TABLE '||del_tb.table_name; -- запустити команду
    END LOOP;
END;
/

-----------------------------------------

DECLARE
    v_sql_condition VARCHAR2(500) := 'job_id';
    v_sql_value VARCHAR2(50) := '''ST_CLERK''';
    v_dynamic_sql VARCHAR2(500);
    v_sum NUMBER;
BEGIN
    v_dynamic_sql :='
    SELECT SUM(e.salary)
    FROM hr.employees e
    WHERE e.'||v_sql_condition||' = '||v_sql_value||'
    ';
--dbms_output.put_line(v_dynamic_sql);
EXECUTE IMMEDIATE v_dynamic_sql INTO v_sum;
dbms_output.put_line(v_sum);
END;
/

-------------------------------------------------------

CREATE TABLE logs
( id NUMBER,
appl_proc VARCHAR2(50),
message VARCHAR2(2000),
log_date DATE DEFAULT SYSDATE,
CONSTRAINT id_pk PRIMARY KEY(id) );

-----------------------------------

CREATE SEQUENCE log_seq
MINVALUE 1 MAXVALUE 99999999999999999
START WITH 1 INCREMENT BY 1
CACHE 20;

-----------------------------------

CREATE PROCEDURE to_log(
    p_appl_proc IN VARCHAR2,
    p_message IN VARCHAR2) IS
PRAGMA autonomous_transaction;
BEGIN
    INSERT INTO logs(id, appl_proc, message)
    VALUES(log_seq.NEXTVAL, p_appl_proc, p_message);
    COMMIT;
END;
/

----------------------------------------

BEGIN
    EXECUTE IMMEDIATE 
        'CREATE TABLE balance
        ( employee_id NUMBER,
        iban VARCHAR2(50),
        balance NUMBER )';
END;
/

---------------------------------------

BEGIN
    INSERT INTO balance (employee_id, iban, balance)
    VALUES (100, 'UA000000000000000000000001', 35000);
    INSERT INTO balance (employee_id, iban, balance)
    VALUES (101, 'UA000000000000000000000002', 25000);
    INSERT INTO balance (employee_id, iban, balance)
    VALUES (102, 'UA000000000000000000000003', 32000);
    COMMIT;
END;
/

-----------------------------------------------------

CREATE PROCEDURE update_balance(
    p_employee_id IN NUMBER,
    p_balance IN NUMBER) IS
    
    v_balance_new balance.balance%TYPE;
    v_balance_old balance.balance%TYPE;
    v_message logs.message%TYPE;
    
BEGIN

    SELECT balance
    INTO v_balance_old
    FROM balance b
    WHERE b.employee_id = p_employee_id
    FOR UPDATE; -- Блокуємо рядок для оновлення
    
    IF v_balance_old >= p_balance THEN
        UPDATE balance b
        SET b.balance = v_balance_old - p_balance
        WHERE employee_id = p_employee_id
        RETURNING b.balance INTO v_balance_new; -- щоб не робити новий SELECT INTO
    ELSE
        v_message := 'Employee_id = '||p_employee_id||'. Недостатньо коштів на рахунку. Поточний баланс '||v_balance_old||', спроба зняття '||p_balance||'';
        raise_application_error(-20001, v_message);
    END IF;
    
    v_message := 'Employee_id = '||p_employee_id||'. Кошти успішно зняті з рахунку. Було '||v_balance_old||', стало '||v_balance_new||'';
    to_log(p_appl_proc => 'util.update_balance', p_message => v_message);

            IF 1=0 THEN -- зімітуємо непередбачену помилку
                v_message := 'Непередбачена помилка';
                raise_application_error(-20001, v_message);
            END IF;
    COMMIT; -- зберігаємо новий баланс та знімаємо блокування в поточній транзакції
    EXCEPTION
        WHEN OTHERS THEN
            to_log(p_appl_proc => 'util.update_balance', p_message => NVL(v_message, 'Employee_id = '||p_employee_id||'. ' ||SQLERRM));
            ROLLBACK; -- Відміняємо транзакцію у разі виникнення помилки
            raise_application_error(-20002, NVL(v_message, 'Не відома помилка'));
END update_balance;