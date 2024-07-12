
undef sid

set lines 170 echo off
col sess	format a10
col stime	format a08
col sta  	format a04	head 'Sta'
col event	format a24 trunc
col seq#	format 99999
col wtime	format 9999999
col twaited	format 99999999
col p1p2p3	format a16	head 'P1:P2:P3'
col wclass	format a08 			trunc
col sqlid_cn	format a16	head 'SqlId:ChildNo'
col blk		format a01	head 'X'
col oc		format 999
col cn		format 99
col flags	format a12	head 'CPH S PRXJBZ'
col mod		format a24	head 'Module'	trunc

break on sess skip 1
select 	 session_id||','||session_serial#	sess
	,to_char(sample_time, 'HH24:MI:SS') 	stime
	,module					mod
	,sql_id||decode(sql_child_number,-1,'   ',':'||lpad(sql_child_number,2,' '))	sqlid_cn
--	,in_connection_mgmt||in_parse||in_hard_parse||' '||in_sql_execution||' '||in_plsql_execution||in_plsql_rpc||in_java_execution||in_bind 	flags
	,decode(session_state,'WAITING','Wait','ON CPU','cpu',' ? ')		sta
	,seq#					seq#
	,decode(blocking_session_status,'VALID','x',' ')			blk
	,event					event
	,lpad(least(p1,9999999),7,' ')||':'||lpad(least(p2,999999),6,' ')||':'||lpad(least(p3,9),1,' ') p1p2p3
	,wait_class				wclass
	,wait_time				wtime
	,time_waited				twaited
from	 v$active_session_history
where	 session_id = &&sid
and	 sample_time > sysdate - 15/1440
order by sample_time
;
