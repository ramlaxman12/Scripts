set linesi 100
undef sql_handle
select * from table( dbms_xplan.display_sql_plan_baseline( sql_handle=>'&sql_handle', format=>'basic'));
undef sql_handle
