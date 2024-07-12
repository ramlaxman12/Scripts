set pages 1000
set lines 132
col name format a15 wrap
col username format a10
col module format a12
col space_used format 9,999,999,999,999
select a.username,a.sid,r.name,b.start_time,a.module,a.action, (b.used_ublk * 8192) space_used
from v$session a, v$transaction b,v$rollname r
where a.saddr=b.ses_addr
and b.xidusn = r.usn
order by 7
/

