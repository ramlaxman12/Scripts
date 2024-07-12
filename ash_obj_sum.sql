@plusenv
col oname 	format a40
col subobject	format a30
col event 	format a30	trunc
col tsname	format a25	trunc
col otype	format a08	trunc
select 	 count(*)
	,h.event
	,o.owner||'.'||o.object_name oname
	,o.subobject_name	subobject
	,s.tablespace_name	tsname
	,decode(o.object_type,'INDEX','--')||o.object_type		otype
from 	 v$active_session_history h
	,dba_objects o
	,dba_segments s
where 	 h.sample_time between sysdate-60/1440 and sysdate
and   	 h.event not like 'log %'
and 	 h.current_obj# = o.object_id
and	 o.owner	= s.owner
and	 o.object_name 	= s.segment_name
group by h.event
	,o.owner||'.'||o.object_name
	,s.tablespace_name
	,o.object_type
	,o.subobject_name
having	count(*) >50
order by 1
/
