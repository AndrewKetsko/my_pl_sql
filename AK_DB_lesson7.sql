SELECT TRIM(REGEXP_SUBSTR(p_list_val, '[^'||p_separator||']+', 1, LEVEL)) AS cur_value
FROM dual
CONNECT BY LEVEL <= REGEXP_COUNT(p_list_val, p_separator) + 1;

SELECT TRIM(REGEXP_SUBSTR('USD, EUR', '[^'||','||']+', 1, LEVEL)) AS cur_value
FROM dual
CONNECT BY LEVEL <= REGEXP_COUNT('USD, EUR', ',') + 1;

SELECT *
FROM TABLE(util.table_from_list(p_list_val => 'USD,EUR,KZT,AMD,GBP,ILS'));

--------------------------------------------------

SELECT *
FROM TABLE(util.get_currency(p_currency => 'USD', p_date => SYSDATE-5));