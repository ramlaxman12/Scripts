set pause "[Enter]..."
set pause on
set pagesize 40
set linesize 190
column osuser format a10 trunc
column size_mb format 999999 heading "TmpUsgMB"
column username format a12
col module      format a15              head 'Module'           trunc
column sid format 999999
column command format a7
column rm_group format a20
col event       format a15              head 'Wait Event'       trunc
column sql_id format a13
column ospid format a7
column blocking_session format a7 heading 'BLOCKER'
column sql_child_number format 999 heading 'CNO'
select 
 a.sid, a.username,a.module, rpad(to_char(c.spid,'9999999'),7,' ') ospid ,decode (a.command
               , 0, '-    '
               , 1, 'CR TB'
               , 2, 'ISRT'
               , 3, 'SEL'
               , 4, 'CR CL'
               , 5, 'AL CL'
               , 6, 'UPDT'
               , 7, 'DEL'
               , 8, 'DR'
               , 9, 'CR IX'
               ,10, 'DR IX'
               ,11, 'AL IX'
               ,12, 'DR TB'
               ,15, 'AL TB'
               ,17, 'GRANT'
               ,18, 'REVOK'
               ,19, 'CRSYN'
               ,20, 'DRSYN'
               ,21, 'CR VW'
               ,22, 'DR VW'
               ,26, 'LK TB'
               ,27, 'NO OP'
               ,28, 'RENM'
               ,29, 'CMNT'
               ,30, 'AUDIT'
               ,31, 'NOAUD'
               ,32, 'CR DBL'
               ,33, 'DR DBL'
               ,34, 'CR DB'
               ,35, 'AL DB'
               ,36, 'CR RBS'
               ,37, 'AL RBS'
               ,38, 'DR RBS'
               ,39, 'CR TS'
               ,40, 'AL TS'
               ,41, 'DR TS'
               ,42, 'AL SES'
               ,43, 'AL USR'
               ,44, 'COMMIT'
               ,45, 'ROLLBK'
               ,46, 'SAVEPT'
               ,47, 'PL/SQL'
               ,62, 'AN TB'
               ,63, 'AN IX'
               ,64, 'AN CL'
               ,85, 'TR TB'
   ,    to_char(a.command)
               )                command
,nvl(a.sql_id,'-') sql_id,a.sql_child_number, a.event,nvl(to_char(a.blocking_session,999999),'     -') blocking_session,round(a.last_call_et/60,0) "last_etM",a.RESOURCE_CONSUMER_GROUP rm_group,se.consumed_cpu_time cpu_time, se.cpu_wait_time, se.queued_time
from v$session a, v$process c, v$rsrc_session_info se, v$rsrc_consumer_group co
where se.current_consumer_group_id = co.id and se.sid=a.sid and
 a.paddr=c.addr  and a.status='ACTIVE' and a.username is not null
order by a.sql_id,a.username,a.sql_id,a.sql_child_number;
set pause off;
