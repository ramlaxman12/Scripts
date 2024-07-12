col cdate	format a20
col mindate	format a20
col maxdate	format a20
col duration	format a25
select 	 to_char(sysdate,'MM/DD/YY HH24:MI:SS') cdate
	,to_char(min(SAMPLE_TIME),'MM/DD/YY HH24:MI:SS') mindate
	,to_char(max(SAMPLE_TIME),'MM/DD/YY HH24:MI:SS') maxdate
	,max(SAMPLE_TIME) - min(SAMPLE_TIME)		duration
from v$active_session_history
union all
select 	 to_char(new_time(sysdate,'GMT','PST'),'MM/DD/YY HH24:MI:SS') cdate
	,to_char(min(new_time(SAMPLE_TIME,'GMT','PST')),'MM/DD/YY HH24:MI:SS') mindate
	,to_char(max(new_time(SAMPLE_TIME,'GMT','PST')),'MM/DD/YY HH24:MI:SS') maxdate
	,max(SAMPLE_TIME) - min(SAMPLE_TIME)		duration
from v$active_session_history
;

col kb		format 99,999,999.99

break on pool skip 1
compute sum of kb on pool

select pool, name, bytes/1024 kb
from v$sgastat
where name = 'ASH buffers'
order by pool, bytes;
