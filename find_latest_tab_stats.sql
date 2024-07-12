undef tname
set lines 170
col statsti 		format a16
col tabname 		format a40	head 'Table Name'
col partition_name 	format a30
col subpart		format a30
select to_char(STATS_UPDATE_TIME,'YYYY/MM/DD HH24:MI') statstime, owner||'.'||table_name tabname, partition_name,subpartition_name subpart
  from dba_tab_stats_history 
  where 	stats_update_time	> sysdate - 14
and		table_name		like upper('%&tname%')
  order by STATS_UPDATE_TIME; 
