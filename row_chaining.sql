select a.username,a.sql_id,a.prev_sql_id,b.value from v$sesstat b, v$session a where a.sid=b.sid and b.statistic#=1017 and a.username='VISHNU' order by 3;

