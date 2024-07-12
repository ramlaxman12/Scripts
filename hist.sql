set heading on
set pagesi 10000
set linesi 190
select trunc(n.BEGIN_INTERVAL_TIME),sum(s.EXECUTIONS_TOTAL) executions,sum(s.DISK_READS_TOTAL) dreads,sum(s.DISK_READS_TOTAL)/sum(s.EXECUTIONS_TOTAL) dreads_perx,sum(s.BUFFER_GETS_TOTAL) bgets,sum(s.BUFFER_GETS_TOTAL)/sum(s.EXECUTIONS_TOTAL) bgets_perx,sum(s.CPU_TIME_TOTAL) cpu,sum(s.CPU_TIME_TOTAL)/sum(s.EXECUTIONS_TOTAL) cpu_perx,sum(s.ELAPSED_TIME_TOTAL) elap,sum(s.ELAPSED_TIME_TOTAL)/sum(s.EXECUTIONS_TOTAL) elap_perx,sum(s.IOWAIT_TOTAL) iowait,sum(s.IOWAIT_TOTAL)/sum(s.EXECUTIONS_TOTAL) iowait_perx  from dba_hist_snapshot n,dba_hist_sqlstat s where s.sql_id='&1' and s.snap_id=n.snap_id and n.begin_interval_time>=trunc(sysdate-3) group by trunc(n.BEGIN_INTERVAL_TIME);
