set linesi 180
set pagesi 2000
column dest_name format a20
column error format a70
select DEST_NAME,STATUS,ARCHIVER,LOG_SEQUENCE,NET_TIMEOUT,FAILURE_COUNT,MAX_FAILURE,ERROR from v$archive_dest;
