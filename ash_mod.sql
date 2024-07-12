break on dtime
select 	 to_char(CAST(sample_time as date),'YYYY/MM/DD HH24:MI') dtime
	,count(*) 
	,nvl(module,'<'||substr(program,1,instr(program,'.')-1)||'>')	module
from v$active_session_history
where CAST(sample_time as date) > sysdate -1/24
group by to_char(CAST(sample_time as date),'YYYY/MM/DD HH24:MI')
	,nvl(module,'<'||substr(program,1,instr(program,'.')-1)||'>')
order by dtime, count(*)
/
