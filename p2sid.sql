REM -----------------------------------------------------
REM $Id: sid-2-spid.sql,v 1.1 2002/03/14 00:27:53 hien Exp $
REM Author      : Murray, Ed
REM #DESC       : Get the SPID given a SID
REM Usage       : SID - SID
REM Description : Get the SPID given a SID
REM -----------------------------------------------------

undefine PID
column sid format 99999999
select sid,serial#,status from v$session where paddr = (select addr from v$process where spid = &PID)
/

undefine PID
