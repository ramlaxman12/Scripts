set linesi 190
col event format a40
col username format a15
select se.username,s.sid,s.qcsid,p.spid,p.server_name,p.status,s.DEGREE,s.REQ_DEGREE,se.sql_id,se.event  
from v$px_process p ,v$px_session s,v$session se  where s.sid=p.sid and s.serial#=p.serial# and s.sid=se.sid and s.serial#=se.serial# order by s.qcsid,s.sid;
