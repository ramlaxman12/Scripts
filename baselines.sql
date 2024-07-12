undef sql_id
col sql_handle format a20
col module format a15 trunc
set pagesi 0
col opt_cost format 99999999
col sql_handle format a30
col plan format 99999999999
set linesi 190
break on sql_id on SQL_HANDLE
select distinct nvl(s.sql_id,'-') sql_id,b.SQL_HANDLE,b.PLAN_NAME,decode(b.ACCEPTED,'YES','Y','N')||decode(b.ENABLED,'YES','Y','N')||decode(b.FIXED,'YES','Y','N') AEF,b.OPTIMIZER_COST opt_cost,s.MODULE,to_number(decode(b.ACCEPTED,'NO',null,s.plan_hash_value)) plan,round(b.ELAPSED_TIME/decode(b.executions,0,1,b.executions)) elapX,round(b.CPU_TIME/decode(b.executions,0,1,b.executions)) cpuX,round(b.BUFFER_GETS/decode(b.executions,0,1,b.executions)) bgetsX,round(b.DISK_READS/decode(b.executions,0,1,b.executions)) DreadsX from dba_sql_plan_baselines b ,v$sql s where b.signature=s.EXACT_MATCHING_SIGNATURE(+) and s.SQL_PLAN_BASELINE(+)=b.plan_name and s.sql_id=nvl('&sql_id',s.sql_id) order by 1 desc,4 desc;
