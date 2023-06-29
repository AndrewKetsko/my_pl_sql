CREATE TABLE products (
productid NUMBER,
productname VARCHAR2(255),
price NUMBER,
quantity NUMBER,
CONSTRAINT productid_pk PRIMARY KEY (productid) );

------------------------------------------------------

CREATE OR REPLACE PROCEDURE add_product (
        p_productname IN VARCHAR2,
        p_price IN NUMBER,
        p_quantity IN NUMBER,
        p_commit IN BOOLEAN DEFAULT FALSE) IS
    V_PRODUCTID NUMBER;
    
    FUNCTION get_max_productid RETURN NUMBER IS
        v_productid NUMBER;
    BEGIN
        SELECT NVL(MAX(productid),0)+1
        INTO v_productid
        FROM products;
        RETURN v_productid;
    END get_max_productid;
    
BEGIN
    V_PRODUCTID:=GET_MAX_PRODUCTID;
    INSERT INTO products (productid,productname,price,quantity)
    VALUES (v_productid,p_productname,p_price,p_quantity);
    
    IF p_commit = TRUE THEN
        COMMIT;
    END IF;
    
    dbms_output.put_line('Продукт '||p_productname||' успішно доданий до таблиці Products.');
EXCEPTION
    WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20001, 'Виникла помилка: '||sqlerrm

END add_product;
/

----------------------------------------------------------

BEGIN
    ANDREW.add_product(
            p_productname => 'test1',
            p_price => 15,
            p_quantity => 25);
END;
/
--------------------------------------------------

CREATE UNIQUE INDEX PROD_NAME_IND ON PRODUCTS(PRODUCTNAME);






