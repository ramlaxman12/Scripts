select (sysdate-OLDEST_FLASHBACK_time)*24*60 flashback_in_minutes  from V$FLASHBACK_DATABASE_LOG;
