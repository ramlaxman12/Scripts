set lines 170
col statstime 		format a16
col pdt 		format a16
col tabname 		format a40	head 'Table Name'
col partition_name 	format a30
col subpart		format a30
select 	 to_char(STATS_UPDATE_TIME,'YYYY/MM/DD HH24:MI') statstime
	,to_char(new_time(STATS_UPDATE_TIME,'GMT','PDT'),'YYYY/MM/DD HH24:MI') pdt
	,owner||'.'||table_name tabname
	,partition_name
	,subpartition_name subpart
from dba_tab_stats_history 
where owner = 'BOOKER'
and 	stats_update_time	> sysdate - 1
order by STATS_UPDATE_TIME; 
