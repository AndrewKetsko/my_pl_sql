DECLARE
    v_recipient VARCHAR2(50) :='kastanta91usb@gmail.com';
    v_subject VARCHAR2(50) :='test_subject';
    v_mes VARCHAR2(50) :='Hello World';
BEGIN
    sys.sendmail(p_recipient => v_recipient,
                p_subject => v_subject,
                p_message => v_mes || ' ');
END;
/
-------------------------------------------------------------------------
SELECT
'<!DOCTYPE html>
<html>
<head>
<title></title>
<style>
table, th, td {border: 1px solid;}
.center{text-align: center;}
</style>
</head>
<body>
<table border=1 cellspacing=0 cellpadding=2 rules=GROUPS frame=HSIDES>
<thead>
<tr align=left>
<th>Job_id</th>
<th>Count_emp</th>
</tr>
</thead>
<tbody>
'|| list_html || '
</tbody>
</table>
</body>
</html>' AS html_table
FROM (
SELECT LISTAGG('<tr align=left>
<td>' || job_id || '</td>' || '
<td class=''center''> ' || cnt_empl||'</td>
</tr>', '<tr>')
WITHIN GROUP(ORDER BY cnt_empl) AS list_html
FROM ( SELECT job_id, COUNT(1) AS cnt_empl
FROM hr.employees
GROUP BY job_id
HAVING COUNT(1) > 2 ));
---------------------------------------------------------------

