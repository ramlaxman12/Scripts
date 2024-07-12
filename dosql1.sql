set pages 10000
set lines 200
col osuser format a10
col module format a20 trunc
col machine format a50 trunc
select osuser,max(LOGON_TIME),PROGRAM, machine,module from db_logons where username like 'DBTOOLS_SPDA_001' and LOGON_TIME>sysdate-30 group by USERNAME,machine, program,osuser,module order by program,max(LOGON_TIME);
