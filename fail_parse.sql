set linesi 190
select s.sid,p.spid, t.stat_name, t.value
from v$sess_time_model t,v$session s,v$process p
where t.stat_name = 'failed parse elapsed time'
and t.value != 0 and t.sid=s.sid and s.paddr=p.addr
order by value;

