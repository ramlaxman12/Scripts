col pct format 99.9
with 	event_total as
(select count(*) evt from v$active_session_history
where sample_time > sysdate-15/1440
and event is not null
)
	,event_grp as
(
select count(*) cnt, event 
from 	 v$active_session_history
where sample_time > sysdate-15/1440
and event is not null
group by event
having count(*)>10
)
select 	 cnt
	,(cnt/evt)*100	pct
	,event
from 	 event_total
	,event_grp
order by pct
/
