prompt enter start and end times in format DD-MM-YYYY 
 
column sample_end format a21
select trunc(s.begin_interval_time) sample_date
, sum(q.EXECUTIONS_TOTAL) executions
, round(sum(DISK_READS_TOTAL)/greatest(sum(executions_total),1),1) pio_per_exec
, round(sum(BUFFER_GETS_TOTAL)/greatest(sum(executions_total),1),1) lio_per_exec
, round(sum(CPU_TIME_TOTAL)/greatest(sum(executions_total),1),1) cpu_per_exec
, round((sum(ELAPSED_TIME_TOTAL)/greatest(sum(executions_total),1)/1000),1) elap_per_exec
from dba_hist_sqlstat q, dba_hist_snapshot s
where q.SQL_ID=trim('&sqlid.')
and s.snap_id = q.snap_id
and s.dbid = q.dbid
and s.instance_number = q.instance_number
and s.end_interval_time >= to_date(trim('&start_time.'),'dd-mm-yyyy')
and s.begin_interval_time <= to_date(trim('&end_time.'),'dd-mm-yyyy')
group by 
trunc(s.begin_interval_time)
order by 1
/
