set pagesize 40
set linesize 190
column osuser format a10 trunc
column client_info format a20
column size_mb format 999999 heading "TmpUsgMB"
column ospid format a6
column username format a6
column machine format a25 trunc
col module      format a20              head 'Module'           trunc
col opname      format a20              head 'Opname'           trunc
column sid format 999999
column command format a7
col event       format a15              head 'Wait Event'       trunc
select 
 a.sid, a.username,a.module, c.spid ospid,client_info
, a.event,l.opname opname,l.sofar sofar,l.totalwork totalwork,l.sofar/l.totalwork*100 finish,round(l.time_remaining/60,0) remaining_mins
from v$session a,  v$process c ,v$session_longops l
where   
 a.paddr=c.addr(+)  and a.sid=l.sid(+) and a.program like 'rman@%' and l.time_remaining(+)> 0
order by a.username,opname;
set pause off;
