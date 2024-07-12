set line 200 pages 200
select * from table (Dbms_xplan.display_cursor(format=>'allstats last'));

