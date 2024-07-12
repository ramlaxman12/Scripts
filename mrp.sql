set lines 400 pages 299
col pid for 99999
col CLIENT_PID for a9
col CLIENT_PROCESS for a9
col status for a18
col pid for a9
SELECT INST_ID,THREAD#, PROCESS, SEQUENCE#, BLOCK#, BLOCKS, PID, CLIENT_PID, CLIENT_PROCESS, STATUS  FROM GV$MANAGED_STANDBY order by status, thread#;

set lines 400 pages 299
SELECT INST_ID,PROCESS, STATUS, THREAD#, SEQUENCE#, BLOCK#, BLOCKS FROM GV$MANAGED_STANDBY where process='MRP0'
order by status, thread#;