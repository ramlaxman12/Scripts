-- for last 15 minutes

col sid		format 99999
col bgetspx	format 999999.9
col cnt		format 99
col module	format a50

break on stime on pst skip 1

with	 sqlidstat 	as
(
select   sql_id, sum(executions) execs, sum(buffer_gets) bgets, sum(buffer_gets)/sum(executions) bgetspx
from     v$sqlstats
where    executions     >0
group by sql_id
)
	,ash		as
(
select 	 to_char(sample_time,'MM/DD HH24:MI')	stime
	,to_char(new_time(sample_time,'GMT','PST'),'MM/DD HH24:MI') pst
	,count(*)				cnt
	,SESSION_ID				sid
	,SQL_ID					
	,MODULE					module
from 	 v$active_session_history
where 	 sample_time	> sysdate-45/1440
and 	 SESSION_STATE = 'ON CPU'
and	 SQL_ID is not null
group by to_char(sample_time,'MM/DD HH24:MI')
	,to_char(new_time(sample_time,'GMT','PST'),'MM/DD HH24:MI')
	,SESSION_ID
	,SQL_ID
	,MODULE
having	 count(*)>1
)
select 	 ash.stime
	,ash.pst
	,ash.sid
	,ash.cnt
	,ash.sql_id
	,nvl(sqlidstat.bgetspx,0) bgetspx
	,ash.module
	,sqlidstat.execs
	,sqlidstat.bgets
from 	 ash
	,sqlidstat
where 	 ash.sql_id	= sqlidstat.sql_id 
order by ash.stime
	,sqlidstat.bgetspx desc
/
