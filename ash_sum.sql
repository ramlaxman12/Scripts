@plusenv
col module format a50
col event format a40
col objname format a30
select count(*), sql_id, o.object_name objname, event, module
from 	 v$active_session_history
	,dba_objects o
where event not in 
(
 'SQL*Net message from client'
,'rdbms ipc message'
,'log file sync'
,'DIAG idle wait'
,'jobq slave wait'
)
and	CURRENT_OBJ# 	= o.object_id (+)
group by sql_id, o.object_name, event, module
having count(*)>1
order by count(*)
;
