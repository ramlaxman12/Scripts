@plusenv
select 	 round(avg(max(cnt_tot)) over (order by sample_time RANGE BETWEEN INTERVAL '5' minute PRECEDING AND current row)) as avg
	,max(cnt_tot) as tot
	,SAMPLE_time,max(cnt) as cnt
	,event
	,substr(sq.sql_text,1)
	,ash.sql_id
	,ash.sql_child_number chd
	/* plsql_entry_object_id, plsql_entry_subprogram_id, plsql_object_id, plsql_subprogram_id, session_state, qc_session_id, qc_instance_id
	,blocking_session
	,blocking_session_status
	,blocking_session_serial#
	,event_id
	,event#
	,seq#
	,p1text
	,p1
	,p2text
	,p2
	,p3text
	,p3
	,wait_class
	,wait_class_id
	,wait_time
	,time_waited
	,xid
	,current_obj#
	,current_file#
	,current_block#
	,program
	,module
	,action
	,client_id*/
	,to_char(round(sum(elapsed_time) / nullif(sum(executions), 0) / 1000000, 6), '9,999,999,990.999999') as "sec p"
	,round(sum(disk_reads) / nullif(sum(executions), 0), 0) as "disk p"
	,round(sum(buffer_gets) / nullif(sum(executions), 0), 0) as "gets p"
	,round(sum(rows_processed) / nullif(sum(executions), 0), 0) as "rows p"
	,round(sum(cpu_time) / 1000000 / nullif(sum(executions), 0), 3) as "cpu p"
	,sum(executions) as exec
	,sum(users_opening) as open
	,sum(users_executing) as e
from 	( 
	 select   sum(count(*)) over (partition by sample_time) as cnt_tot
		 ,count(*) as cnt
		 ,SAMPLE_time
		 ,event
		 ,sql_id
		 ,sql_child_number 
	 from 	  v$active_session_history 
	 where 	  1=1
	 and 	  sample_time > sysdate - interval '2' minute
	 group by event, sql_id,sql_child_number, SAMPLE_time 
	 having   count(*) >= 2
	) ash
	, v$sql sq
where  	 ash.sql_id = sq.sql_id(+) 
and 	 ash.sql_child_number=sq.child_number (+)
group by event,sql_text,ash.sql_id,ash.sql_child_number,ash.SAMPLE_time order 
by 	 sample_time desc
;
