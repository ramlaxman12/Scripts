--
-- Show top_x_rows [sql_ids & file#_block#] in the specified AWR timeframe (dba_hist_active_sess_history)  in terms of hot blocks - breakdown by 10 min interval
--

accept start_time_PST	prompt 'Start Time in PST (MM/DD HH24:MI) : ' 
accept   end_time_PST	prompt 'End   Time in PST (MM/DD HH24:MI) : ' 
accept    top_x_rows 	prompt 'Top x rows (between 3 and 10)     : '

@plusenv
@big_job
col sql_id	format a13
col fb 		format a18 	head 'File # : Block #'
col cpu		format 99,999	head '*CPU*'
col wait	format 99,999	head 'Wait'
col io		format 99,999	head 'I/O'
col tot		format 999,999	head 'TOT'
col pctcpu	format 999.9	head 'Cpu%'
col pctio	format 999.9	head 'IO%'
col pctwait	format 999.9	head 'Wait%'
col rowrank   	noprint
col stime	format a11	head 'Time'
col stime_PST 	format a11	head 'Time PST'

break on stime on stime_PST skip 1

select 	 substr(to_char(sample_time, 'MM/DD HH24:MI'),1,10)||'0'				stime
	,substr(to_char(new_time(sample_time,'GMT','PST'),'MM/DD HH24:MI'),1,10)||'0'		stime_PST
	,ash.sql_id										sql_id
	,lpad(ash.current_file#,' ',8)||':'||lpad(ash.current_block#,' ',8)			fb
     	,sum(decode(ash.session_state,'WAITING',1,0)) - sum(decode(ash.session_state,'WAITING',decode(en.wait_class, 'User I/O',1,0),0))    	wait
	,100*ratio_to_report(sum(decode(ash.session_state,'WAITING',1,0))-sum(decode(ash.session_state,'WAITING',decode(en.wait_class,'User I/O',1,0),0))) over (partition by substr(to_char(sample_time, 'MM/DD HH24:MI'),1,10)||'0') pctwait
     	,sum(decode(ash.session_state,'WAITING', decode(en.wait_class, 'User I/O',1,0),0))    	io
	,row_number() over (partition by substr(to_char(sample_time, 'MM/DD HH24:MI'),1,10)||'0' order by sum(decode(ash.session_state,'WAITING',1,0)) desc) 	rowrank
	,100*ratio_to_report (sum(decode(ash.session_state,'WAITING', decode(en.wait_class, 'User I/O',1,0),0))) over (partition by substr(to_char(sample_time, 'MM/DD HH24:MI'),1,10)||'0') pctio
     	,sum(decode(ash.session_state,'ON CPU',0,1))     					tot
from 	 dba_hist_active_sess_history 	ash
	,dba_hist_snapshot		sn
        ,v$event_name 			en
where 	 ash.sql_id 		is not NULL  
and	 ash.session_state	= 'WAITING'
and 	 ash.event		= en.name (+)
and	 ash.snap_id		= sn.snap_id
and	 ash.dbid		= sn.dbid
and	 ash.instance_number	= sn.instance_number
and	 ash.current_obj#	>= 0
and	 ash.current_file#	> 0
and	 ash.current_block#	> 0
and 	 to_char(new_time(sample_time,'GMT','PST'),'MM/DD HH24:MI') between '&&start_time_PST'
									and '&&end_time_PST'
group by substr(to_char(sample_time, 'MM/DD HH24:MI'),1,10)||'0'
	,substr(to_char(new_time(sample_time,'GMT','PST'),'MM/DD HH24:MI'),1,10)||'0'
	,sql_id
	,lpad(ash.current_file#,' ',8)||':'||lpad(ash.current_block#,' ',8)			
;
@big_job_off
