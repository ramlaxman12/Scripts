SET LONG 10000
SELECT DBMS_SPM.evolve_sql_plan_baseline(sql_handle => '&sql_handle')
FROM   dual;
