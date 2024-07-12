set pages 0 lines 170 echo off feed off
select '-- oldest sample: '||to_char(min(sample_time),'YYYY-MM-DD HH24:MI') from v$active_session_history;
select '-- current time : '||to_char(sysdate,'YYYY-MM-DD HH24:MI') from dual;
undef	last_n_min
col dbid noprint new_value xdbid
select dbid  from v$database;
--
-- specify time below in PST --
--
spool ash_gpi1.txt
SELECT * from 
TABLE(dbms_workload_repository.ash_report_text(&&xdbid,1,to_date('2011/11/10 14:55','YYYY/MM/DD HH24:MI')
                                                        ,to_date('2011/11/10 15:05','YYYY/MM/DD HH24:MI')));
spool off
