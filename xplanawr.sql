set linesize 999
set pagesize 999

select * from table( dbms_xplan.display_awr('&sql_id', plan_hash_value => '&plan_hash_value', format =>'ALL ALLSTATS LAST'))
/