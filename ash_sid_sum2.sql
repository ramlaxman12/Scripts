undef sid
undef last_x_mins
@plusenv
col ash_time 	format a11
col event	format a32	trunc
col sid		format 99999
col obj_name 	format a60 trunc
col cnt		format 99
break on sid on ash_time

select 	 ash.session_id sid
	,to_char(sample_time,'MM/DD HH24:MI') ash_time
     	,count(*) cnt
     	,ash.session_state
     	,ash.event
	,o.owner||'.'||object_name||decode(subobject_name,null,' ',' - '||subobject_name) obj_name
from 	 v$active_session_history ash
	,dba_objects o
where 	 ash.session_id = &&sid 
and 	 sample_time >= sysdate - &&last_x_mins/1440
and	 ash.current_obj# = o.object_id
group by ash.session_id
	,to_char(sample_time,'MM/DD HH24:MI') 
	,ash.session_state
	,ash.event
	,o.owner||'.'||object_name||decode(subobject_name,null,' ',' - '||subobject_name)
order by to_char(sample_time,'MM/DD HH24:MI')
	,count(*)
;
