@big_job
@plusenv
col cnt		format 999,999
col event	format a32

break on stime on pdt skip 1

select 	 to_char(sample_time,'YYYY/MM/DD HH24')	stime
	,to_char(new_time(sample_time,'GMT','PDT'),'YYYY/MM/DD HH24') PDT
	,count(*)				cnt
	,event					event
from 	 DBA_HIST_ACTIVE_SESS_HISTORY
where 	 sample_time	> sysdate - 12/24
and	(
	 event		= 'enq: TX - index contention'
      or event		= 'buffer busy waits'
	)
group by to_char(sample_time,'YYYY/MM/DD HH24')
	,to_char(new_time(sample_time,'GMT','PDT'),'YYYY/MM/DD HH24')
	,event
order by to_char(sample_time,'YYYY/MM/DD HH24')
	,event
;
