set linesize 999
set pagesize 999

select * from table( dbms_xplan.display_cursor('&sql_id', '&child_number', 'ALL ALLSTATS LAST'));
