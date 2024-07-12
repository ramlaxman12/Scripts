
select 	EXTRACT(HOUR FROM (MAX(sample_time) - MIN(sample_time)))||' hours '|| 
	EXTRACT(MINUTE FROM (MAX(sample_time) - MIN(sample_time)))||' mins'    ASH_window 
from  v$active_session_history;

