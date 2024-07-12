REM ------------------------------------------------------------------------------------------------
REM $Id: redo.sql,v 1.1 2002/03/14 00:41:33 hien Exp $
REM Author     : hien
REM #DESC      : Show all online redo logs
REM Usage      : 
REM Description: 
REM ------------------------------------------------------------------------------------------------

@plusenv

col grp		format 99	heading 'GRP'
col members	format 9	head    'M'
col lsn		format 999999	heading 'LogSeq|Number'
col arch	format a03	heading 'Arch'
col sta		format a10	heading 'Status'
col fsta	format a10	heading 'File|Status'
col mb		format 9999	heading 'MB'
col ftime	format a14	heading 'First Time'
col fscn	format 99999999999999	heading 'First SCN'
col fname	format a50

break on grp on members on lsn on arch on sta on mb on ftime on fscn
SELECT 	 
	 l.group# 					grp
	,l.members					members
	,l.sequence# 					lsn
	,l.archived 					arch
	,l.status					sta 
	,l.bytes/(1024*1024) 				mb
	,to_char(l.first_time,'YY/MM/DD HH24:MI') 	ftime
	,l.first_change# 				fscn
	,f.status					fsta 
	,f.member					fname
FROM 	 v$log		l
	,v$logfile	f
WHERE	 l.group# = f.group#
ORDER BY sequence#, l.group#, f.member
;
