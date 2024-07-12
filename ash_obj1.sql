@plusenv
col oname 	format a40
col event 	format a30	trunc
col tsname	format a25	trunc
col otype	format a08	trunc
select 	 count(*)
	,h.event
	,h.sql_id
	,o.owner||'.'||o.object_name oname
	,s.tablespace_name	tsname
	,decode(o.object_type,'INDEX','--')||o.object_type		otype
from 	 v$active_session_history h
	,dba_objects o
	,dba_segments s
where 	 h.sample_time between sysdate-300/1440 and sysdate
and   	 h.event not like 'log %'
and 	 h.current_obj# = o.object_id
and	 o.owner	= s.owner
and	 o.object_name 	= s.segment_name
group by h.event
	,h.sql_id
	,o.owner||'.'||o.object_name
	,s.tablespace_name
	,o.object_type
having	count(*) >100
order by h.event, count(*)
/
