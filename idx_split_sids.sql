col sid 	format 99999
col statname	format a22
col statval	format 9999999
select 	 s.sid, substr(n.name,1,20) statname, value statval
from 	 v$sesstat s, v$statname n
where 	 s.statistic# = n.statistic#
and 	 s.statistic# = 318
and 	 s.value >100
order by value
;
