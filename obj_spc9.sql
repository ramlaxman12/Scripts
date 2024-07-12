col mb		format 99,999,999.9
col segname	format a40
break on report
compute sum of mb on report
select 	 BYTES/(1024*1024) 	mb
	,owner||'.'||segment_name	segname
	,partition_name
	,segment_type
	,tablespace_name
from 	 dba_segments 
where 	 segment_name	in 
(
 'WORKFLOW_COLLECTIONS'
,'WORKFLOW_GENERATION_TIMES'
,'WORK_UNITS'
,'WORK_UNIT_ANCESTORS'
,'WORK_UNIT_ATTRIB_VALUES'
,'WORK_UNIT_DEADLINES'
,'WORK_UNIT_EVENTS'
,'WORK_UNIT_HISTORIES'
)
order by partition_name
;
