select 'alter system kill session '||''''||sid||','||serial#||''''||' immediate ;' from v$session where sql_id = '&sql_id' ;

