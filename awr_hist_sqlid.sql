set lines 400 pages 299
col avg_rows noprint
col avg_buffer_Gets for 9999999.99
col avg_disk_Reads for 9999999.99
col avg_ela for 99999999.99
col avg_cL_WAIT for 99999999999.99
col END_INTERVAL_TIME for a25
col instance_number for 99 heading "INST"
col ROWS_PROCS for 999999999
select END_INTERVAL_TIME, a.INSTANCE_NUMBER, PLAN_HASH_VALUE, OPTIMIZER_COST
,decode(BUFFER_GETS_DELTA,0,1,BUFFER_GETS_DELTA)/decode(EXECUTIONS_DELTA,0,1,EXECUTIONS_DELTA) avg_buffer_Gets
,decode(DISK_READS_DELTA,0,1,DISK_READS_DELTA)/decode(EXECUTIONS_DELTA,0,1,EXECUTIONS_DELTA) avg_disk_Reads 
,(decode(ELAPSED_TIME_DELTA,0,1,ELAPSED_TIME_DELTA)/decode(EXECUTIONS_DELTA,0,1,EXECUTIONS_DELTA))/1000000 avg_ela 
,nvl(ROWS_PROCESSED_DELTA,0) ROWS_PROCS
, EXECUTIONS_DELTA
, INVALIDATIONS_DELTA
from DBA_HIST_SQLSTAT a, DBA_HIST_SNAPSHOT b
where sql_id='&sql_id'
and a.executions_delta > 0
and a.snap_id=b.snap_id
and a.instance_number=b.instance_number
order by END_INTERVAL_TIME;