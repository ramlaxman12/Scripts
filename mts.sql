-- ----------------------------------------------------------
-- Program Name		dba_mts.sql
-- Purpose		list stats for multi-threaded server
-- Author		unknown
-- Date			march 2009 
-- Comments		this report is designed to be viewed
--			from the sql prompt and is not
-- 			spooled to a file - you may have to
--			hit enter often for longer reports
-- Parameters
-- Audit Trail
-- ---------------------------------------------------------
/* BEGIN BEGIN BEGIN BEGIN BEGIN BEGIN BEGIN BEGIN */
set verify off
set pagesize 999
set linesize 80
set pause on
set feedback off
set showmode off
set echo off

prompt Hit enter for first report
prompt
 
col num              format 999      heading "Nbr"
col name             format a25      heading "Name"
col type             format 999      heading "Type"
col value            format a32      heading "Value"
col meg              format 99.99    heading "Size|Meg"
col isdefault        format a9       heading "IsDefault"
ttitle "Current Parameter Report For Oracle MTS (shared shadows)"
select num, name, type, value, isdefault
from v$parameter
where name in ('dispatchers','shared_servers','max_shared_servers',
'max_dispatchers')order by num;
 
prompt
prompt Hit Enter For Next Report.....
 
col name             format a5         heading "Name"
col status           format a10        heading "Status"
col accept           format a3         heading "Acpt|Cont"
col messages         format 9999999999 heading "Messages"
col idle             format 99999      heading "Idle|Minuts"
col busy             format 99999      heading "Busy|Minuts"
col ib_pct           format 99.99      heading "Busy|Pct"
col owned            format 999        heading "Circuits|Owned"
col created          format 999999     heading "Circuits|Created"
break on report
rem compute sum of ib_pct on report
ttitle "DISPATCHER STATUS Report For Oracle MTS (shared shadows)"
select name,
       status,
       accept,
       messages,
       (idle / 100) / 60 idle,
       (busy / 100) / 60 busy,
       (busy / (busy + idle)) * 100 ib_pct,
       owned,
       created
from v$dispatcher
order by name;

prompt
prompt Status
prompt        WAIT       - Idle
prompt        SEND       - Sending a message
prompt        RECEIVE    - Receiving a message
prompt        CONNECT    - Establishing a connection
prompt        DISCONNECT - Handling a disconnect request
prompt        BREAK      - Handling a break
prompt        TERMINATE  - In the process of terminating
prompt        ACCEPT     - Accepting connections (no further information available)
prompt        REFUSE     - Rejecting connections (no further information available)
prompt
prompt NOTE:  If the sum of "Busy Pct" is > 50% increase the init.ora
prompt        parameters "dispatchers" and "max_dispatchers" as
prompt        needed.
prompt
prompt Hit Enter For Next Report.....
 
col name    format a5     heading "Disp|Name"
col status1 format a10    heading "Disp|Status"
col spid    format a6     heading "Disp|O/S|PID"
col status2 format a8     heading "Circuit|Status"
col osuser  format a10    heading "O/S|User|Name"
col process format a6     heading "O/S|User|PID"
col program format a16    heading "O/S|User|Program"
col status3 format a8     heading "O/S|User|Status"
break on name skip 1 on report
ttitle "DISPATCHER/CIRCUIT STATUS Report For Oracle MTS (shared shadows)"
select vd.name name,
       vd.status status1,
       vp.spid spid,
       vc.status status2,
       vs.osuser osuser,
       vs.process process,
       substr(vs.program,1,16) program,
       vs.status status3
from v$session vs, v$circuit vc, v$process vp, v$dispatcher vd
where vd.paddr = vp.addr
  and vd.paddr = vc.dispatcher
  and vc.saddr = vs.saddr
order by vd.name;
prompt
prompt Hit Enter For Next Report.....
prompt

col queued           format 9999       heading "Messages|Currently|Queued"
col totalq           format 99999999999 heading "Total|Messages|Processed"
col wait             format 99999999.99 heading "Total|Wait|Time|(seconds)"
col tw_time          format 99.9999    heading "Average|Wait|Time|(seconds)"
break on report
compute sum of totalq wait on report
ttitle "DISPATCHER RESPONSE QUEUE STATUS Report For Oracle MTS (shared shadows)"
select vd.name,
       vq.queued,
       vq.totalq,
       vq.wait / 100 wait,
       (vq.wait / (vq.totalq + 1)) / 100 tw_time
from v$queue vq, v$dispatcher vd
where vq.type = 'DISPATCHER'
  and vq.paddr = vd.paddr
order by vd.name;
prompt
prompt NOTE:If the "Average Wait Time (seconds)" is unreasonable then
prompt      increase the init.ora parameters "dispatchers" and
prompt      and "max_dispatchers" as needed.
prompt
prompt Hit Enter For Next Report.....
 
col aaa format 999.9999 heading "Avg Wait Per|Request|(seconds)"
ttitle "COMMON RESPONSE QUEUE STATUS Report For Oracle MTS (shared shadows)"
select decode( totalq, 0, 0,
               (wait / totalq) / 100 ) aaa
from v$queue
where type = 'COMMON';
prompt
prompt NOTE:If the "Average Wait Time (seconds)" is unreasonable then
prompt      increase the init.ora parameters "servers" and
prompt      "max_servers".
prompt
prompt Hit Enter For Next Report..... 


col maximum_connections format 99999 heading "Maximum|Connections"
col servers_started     format 99999 heading "Servers|Started"
col servers_terminated  format 99999 heading "Servers|Terminated"
col servers_highwater   format 99999 heading "Servers|Highwater"
ttitle "SHARED SHADOW STATS Report For Oracle MTS (shared shadows)"
select * from v$shared_server_monitor;
 
prompt
prompt Hit Enter For Next Report.....
prompt
 
col name1      format a5   heading "Shrd|Sver|Name"
col status     format a13  heading "Status"
col messages   format 9999999999 heading "Total|Messages|Processed"
col breaks     format 99999      heading "Total|Breaks"
col requests   format 999999999  heading "Total|Requests|(common)"
col idle       format 99999      heading "Idle|Time|(minutes)"
col busy       format 99999      heading "Busy|Time|(minutes)"
ttitle "SHARED SHADOW STATUS Report and Summary For Oracle MTS (shared shadows)"
select vs.name name1,
       vs.status,
       vs.messages,
       vs.breaks,
       vs.requests,
       (vs.idle / 100) / 60 idle,
       (vs.busy / 100) / 60 busy
from  v$shared_server vs
order by vs.name;

prompt   Hit Enter For Next Report.....
prompt 

select status, count(*) 
from   v$shared_server
group by status;
prompt
prompt   Status
prompt   EXEC          - Executing SQL
prompt   WAIT (ENQ)    - Waiting for a lock
prompt   WAIT (SEND)   - Waiting to send data to user
prompt   WAIT (COMMON) - Idle; waiting for a user request
prompt   WAIT (RESET)  - Waiting for a circuit to reset after a break
prompt   QUIT          - Terminating
prompt
  
prompt
prompt Hit Enter For Next Report.....
prompt
 
col sid     format 99999 heading "SID"
ttitle "SHARED SHADOW ACTIVE Report For Oracle MTS (shared shadows)"
select vss.name, vss.status, vc.status, vc.queue, vs.osuser, vs.process, vs.sid
from v$session vs, v$circuit vc, v$shared_server vss
where vss.circuit = vc.circuit
and   vc.saddr    = vs.saddr;

prompt
prompt Type EXIT to Exit SQL*Plus ....
prompt
