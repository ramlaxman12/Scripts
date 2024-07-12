SELECT   DECODE (session_state, 'WAITING', event, NULL) event,
             session_state, COUNT(*), SUM (time_waited) time_waited
FROM     v$active_session_history
WHERE    sql_id = '9ap4pmzyb1y3g'
and      sample_time > SYSDATE - 1
GROUP BY DECODE (session_state, 'WAITING', event, NULL),
         session_state
order by time_waited
;

