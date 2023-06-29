  -- function in package util
  FUNCTION get_region_cnt_emp (p_department_id IN NUMBER DEFAULT NULL) RETURN tab_dep_list
    PIPELINED IS
    out_rec tab_dep_list := tab_dep_list();
    l_cur   SYS_REFCURSOR;
  BEGIN
    OPEN l_cur FOR
      SELECT r.region_name
            ,COUNT(em.employee_id)
        FROM hr.employees em
        JOIN hr.departments dp ON em.department_id = dp.department_id
        JOIN hr.locations lc ON dp.location_id = lc.location_id
        JOIN hr.countries c ON lc.country_id = c.country_id
        FULL OUTER JOIN hr.regions r ON c.region_id = r.region_id
       WHERE (em.department_id = p_department_id OR p_department_id IS NULL)
       GROUP BY r.region_name;
    BEGIN
      LOOP
        EXIT WHEN l_cur%NOTFOUND;
        FETCH l_cur BULK COLLECT
          INTO out_rec;
        FOR i IN 1 .. out_rec.count LOOP
          PIPE ROW(out_rec(i));
        END LOOP;
      END LOOP;
      CLOSE l_cur;
    EXCEPTION
      WHEN OTHERS THEN
        IF (l_cur%ISOPEN) THEN
          CLOSE l_cur;
          RAISE;
        ELSE
          RAISE;
        END IF;
    END;
  END get_region_cnt_emp;
  /

--types for this function
  type rec_dep_list is record(region_name varchar2(50), empl_count number);
  type tab_dep_list is table of rec_dep_list;

--result
select *
from table(andrew.util.get_region_cnt_emp(p_department_id=>80));



