set pages 10000
set lines 200
col osuser format a10
col module format a20 trunc
select osuser,max(LOGON_TIME),PROGRAM, machine,module from db_logons where username like 'OLTP_USER' and LOGON_TIME>sysdate-30 group by USERNAME,machine, program,osuser,module order by max(LOGON_TIME);
