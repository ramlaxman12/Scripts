@plusenv
col operation 	format a30
col start_time	format a14
col start_pst	format a14
col end_pst	format a14
col duration 	format a14
select 	 operation
	,to_char(start_time,'YY/MM/DD HH24:MI')
	,'|'
	,to_char(new_time(start_time,'GMT','PST'),'YY/MM/DD HH24:MI')	start_pst
	,'->'
	,to_char(new_time(end_time,'GMT','PST'),'YY/MM/DD HH24:MI')	end_pst
	,(end_time-start_time) day(1) to second(0) as duration
from 	 dba_optstat_operations
where	 operation like 'gather_database_stats%'
order by start_time
;
