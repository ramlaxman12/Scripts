set lines 210 pages 1000
col name for a30
col ISDEFAULT for a10
col DISPLAY_VALUE for a90
break on inst_id skip 1
select inst_id,name,isdefault,display_value from gv$parameter
where translate(upper(name),'123456789101112','nnnnnnnnnnnnn') in
('ARCHIVE_LAG_TARGET','DB_FILE_NAME_CONVERT','LOG_ARCHIVE_FORMAT','LOG_ARCHIVE_MAX_PROCESSES','LOG_ARCHIVE_MIN_SUCCEED_DEST','LOG_ARCHIVE_CONFIG',
'LOG_ARCHIVE_TRACE','LOG_FILE_NAME_CONVERT','STANDBY_FILE_MANAGEMENT','INSTANCE_NAME','LOCAL_LISTENER','DB_UNIQUE_NAME','FAL_SERVER','FAL_CLIENT',
'LOG_ARCHIVE_DEST_n','LOG_ARCHIVE_DEST_STATE_n','DB_RECOVERY_FILE_DEST','DB_RECOVERY_FILE_DEST_SIZE','LOG_ARCHIVE_DEST_nn','LOG_ARCHIVE_DEST_STATE_nn') order by inst_id;