set linesize 160
set pagesize 60
set colsep '  '
column total                    head "Total Available|CPU Seconds"      format 990
column consumed                 head "Used|Oracle Seconds"              format 990.9
column consumer_group_name      head "Consumer|Group Name"              format a25      wrap off
column "throttled"              head "Oracle Throttled|Time (s)"        format 990.9
column cpu_utilization          head "% of Host CPU"                    format 990.9
break on time skip 2 page
 
select to_char(begin_time, 'YYYY-DD-MM HH24:MI:SS') time,
consumer_group_name,
60 * (select value from v$osstat where stat_name = 'NUM_CPUS') as total,
cpu_consumed_time / 1000 as consumed,
cpu_consumed_time / (select value from v$parameter where name = 'cpu_count') / 600 as cpu_utilization,
cpu_wait_time / 1000 as throttled
from v$rsrcmgrmetric_history
order by begin_time,consumer_group_name;
