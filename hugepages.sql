select message_text from X$DBGALERTEXT where lower(message_text) like '%large pages%' and ORIGINATING_TIMESTAMP>=(select STARTUP_TIME from v$instance);
