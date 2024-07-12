--
-- Show top objects in terms of I/Os (event like db file%) in awr
--
@big_job
@plusenv
col objid	format 99999999 head 'Object Id'
col obj		format a70	head 'Owner.Object : SubObject'
col objid	format 9999999
col cnt		format 9,999,999
col event	format a32

break on event skip 1
select 	 event				event
	,count(*) 			cnt
	,current_obj# 			objid
	,o.owner||'.'||object_name||decode(subobject_name,null,' ',' : ')||subobject_name 	obj
from 	 dba_hist_active_sess_history h
	,dba_objects o
where 	 event like 'db file %'
and 	 current_obj# = o.object_id
group by current_obj#
	,o.owner||'.'||object_name||decode(subobject_name,null,' ',' : ')||subobject_name 	
	,event
having count(*) >1000
order by event
	,cnt
;
@big_job_off
