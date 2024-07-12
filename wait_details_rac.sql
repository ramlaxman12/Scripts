column event format A40
column PID format A10
column P1_P2_P3_TEXT format A50
column username format A10
column osuser format A10
column event format A30
column sid format 99999
column wait_time format 999
column wait_time format 99
column wis format 9999
column inst_id format 99
set lines 170
set pages 100
select w.inst_id, w.sid, to_char(p.spid,'99999') PID,
substr(w.event, 1, 28) event,
substr(s.username,1,20) username,
substr(s.osuser, 1,10) osuser,
w.state,
w.wait_time, w.seconds_in_wait wis,
substr(w.p1text||' '||to_char(w.P1)||'-'||
w.p2text||' '||to_char(w.P2)||'-'||
w.p3text||' '||to_char(w.P3), 1, 45)
P1_P2_P3_TEXT, module
from gv$session_wait w, gv$session s, gv$process p
where s.sid=w.sid
and p.addr = s.paddr
and s.username is not null
and w.event not like 'SQL*%'
and w.event not like '%pipe%'
and w.inst_id = s.inst_id
and s.inst_id =p.inst_id
order by w.inst_id
/