undef objname
col mb		format 99,999,999.9
col segname	format a40
select 	 sum(BYTES)/(1024*1024) 	mb
	,owner||'.'||segment_name	segname
	,segment_type
	,tablespace_name
from 	 dba_segments 
where 	 segment_name	= upper('&&objname')
group by owner||'.'||segment_name 
	,segment_type
	,tablespace_name
;
