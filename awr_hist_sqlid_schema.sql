set lines 155
col execs for 999,999,999
col avg_etime for 999,999.999
col avg_lio for 999,999,999.9
col avg_pio for 999,999,999.9
col begin_interval_time for a30
col node for 99999
break on plan_hash_value on startup_time skip 1
select ss.snap_id, ss.instance_number node, begin_interval_time, sql_id, plan_hash_value,
nvl(executions_delta,0) execs,
(elapsed_time_delta/decode(nvl(executions_delta,0),0,1,executions_delta))/1000000 avg_etime,
s.parsing_schema_name,
nvl(ROWS_PROCESSED_DELTA,0) ROWS_PROCS
from DBA_HIST_SQLSTAT S, DBA_HIST_SNAPSHOT SS
where sql_id ='&sql_id'
and ss.snap_id = S.snap_id
and ss.instance_number = S.instance_number
and s.instance_number like nvl('&instance_number',s.instance_number)
order by 1, 2, 3
/