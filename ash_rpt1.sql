set pages 0 lines 170 echo off feed off
select '-- oldest sample: '||to_char(min(sample_time),'YYYY-MM-DD HH24:MI') from v$active_session_history;
select '-- current time : '||to_char(sysdate,'YYYY-MM-DD HH24:MI') from dual;
undef	last_n_min
col dbid noprint new_value xdbid
select dbid  from v$database;
--
-- specify time below in PDT --
--
spool ash_rpt1.out
SELECT * from 
TABLE(dbms_workload_repository.ash_report_text(&&xdbid,1,new_time(to_date('2011/05/05 11:32','YYYY/MM/DD HH24:MI'),'PDT','GMT')
                                                        ,new_time(to_date('2011/05/05 11:33','YYYY/MM/DD HH24:MI'),'PDT','GMT') ));
spool off
