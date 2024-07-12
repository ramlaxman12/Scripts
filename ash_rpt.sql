set pages 0 lines 170 echo off feed off
select '-- oldest sample: '||to_char(min(sample_time),'MM/DD HH24:MI')
from v$active_session_history;
select '-- current time : '||to_char(sysdate,'MM/DD HH24:MI') from dual;
undef	last_n_min
col dbid noprint new_value xdbid
select dbid  from v$database;
SELECT 	 * from TABLE(dbms_workload_repository.ash_report_text(&&xdbid,1, SYSDATE-&&last_n_min/1440, SYSDATE));
