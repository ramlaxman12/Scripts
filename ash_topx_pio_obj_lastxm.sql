--
-- Show top_x_rows [object] in the last_x_mins in terms of physical I/Os - minute by minute
--

undef last_x_mins
undef top_x_rows
@plusenv
col sql_id	format a13
col modprog 	format a40 		head 'Module/Program'	trunc
col wait	format 999,999
col io		format 999,999		head '*I/O*'
col tot		format 9,999,999	head 'TOT'
col pctio	format 999.9		head 'IO%'
col pctwait	format 999.9		head 'Wait%'
col stime	format a11		head 'Time'
col stime_PST	format a11		head 'Time PST'
col rowrank   	noprint
col obj_name	format a60		head 'Object Name'

break on stime on stime_PST skip 1
select   * 
from
(
select 	 to_char(sample_time, 'MM/DD HH24:MI')							stime
	,to_char(new_time(sample_time,'GMT','PST'),'MM/DD HH24:MI')				stime_PST
	,ash.sql_id										sql_id
	,u.name||'.'||o.name||decode(o.subname,null,' ',' - '||o.subname) 			obj_name
     	,sum(decode(ash.session_state,'WAITING',1,0)) - sum(decode(ash.session_state,'WAITING',decode(en.wait_class, 'User I/O',1,0),0))    wait
	,100*ratio_to_report (sum(decode(ash.session_state,'WAITING',1,0)) - sum(decode(ash.session_state,'WAITING',decode(en.wait_class, 'User I/O',1,0),0))) over (partition by to_char(sample_time, 'MM/DD HH24:MI')) pctwait
     	,sum(decode(ash.session_state,'WAITING', decode(en.wait_class, 'User I/O',1,0),0))    	io
	,100*ratio_to_report (sum(decode(ash.session_state,'WAITING', decode(en.wait_class, 'User I/O',1,0),0))) over (partition by to_char(sample_time, 'MM/DD HH24:MI')) pctio
	,row_number() over (partition by to_char(sample_time, 'MM/DD HH24:MI') order by sum(decode(ash.session_state,'WAITING', decode(en.wait_class, 'User I/O',1,0),0)) desc) rowrank
from 	 v$active_session_history 	ash
        ,v$event_name 			en
	,sys.obj$ 			o
	,sys.user$ 			u
where 	 ash.sql_id 		is not NULL  
and 	 ash.event#		= en.event# (+)
and	 ash.current_obj# 	= o.obj#
and	 o.owner# 		= u.user#
and 	 sample_time 		>= sysdate - &&last_x_mins/1440
group by to_char(sample_time, 'MM/DD HH24:MI')
	,to_char(new_time(sample_time,'GMT','PST'),'MM/DD HH24:MI')
	,ash.sql_id
	,u.name||'.'||o.name||decode(o.subname,null,' ',' - '||o.subname)
)
where	 rowrank <= &&top_x_rows
order by stime
	,rowrank
;
