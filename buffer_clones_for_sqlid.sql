break on stime
select 	 to_char(sample_time,'YY/MM/DD HH24:MI') stime
	,CURRENT_OBJ# 
	,count(*)
from 	 dba_hist_active_sess_history 
where 	 sample_time between to_date('14/04/28 22:52','YY/MM/DD HH24:MI') and  to_date('14/04/28 23:10','YY/MM/DD HH24:MI')
and	 sql_id	= '43pzx1u23np54'
group by to_char(sample_time,'YY/MM/DD HH24:MI')
	,CURRENT_OBJ#
order by 1
/
