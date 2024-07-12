select session_id, session_type, session_state, sql_id, module from v$active_session_history 
where sample_time = (select max(sample_time) from v$active_session_history)
and session_type = 'FOREGROUND'
/
