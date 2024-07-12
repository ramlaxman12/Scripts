prompt "CDB STARTUP TIME"
prompt"==================="
set lines 400 pages 299
break on instance_number
col st head "Startup Time" for a27
SELECT con_id
	,INSTANCE_NUMBER
	,to_char(STARTUP_TIME, 'DD-MON-YYYY HH24:MI:SS') "st"
FROM CDB_HIST_DATABASE_INSTANCE
order by instance_number,STARTUP_TIME;

prompt "PDB STARTUP TIME"
prompt "====================="
set lines 400 pages 299
col st head "Startup Time" for a27
col ot head "Open Time" for a27
col pdb_name for a18
break on instance_number
SELECT con_id
	,INSTANCE_NUMBER
	,to_char(STARTUP_TIME, 'DD-MON-YYYY HH24:MI:SS')  st
	,to_char(OPEN_TIME, 'DD-MON-YYYY HH24:MI:SS') ot
	,OPEN_MODE
	,PDB_NAME
FROM CDB_HIST_PDB_INSTANCE
order by INSTANCE_NUMBER,STARTUP_TIME;
