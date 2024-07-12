set line 200 pages 2000
select * from table(dbms_xplan.display_cursor(format=>'ALLSTATS LAST, ADVANCED, +METRICS'));
