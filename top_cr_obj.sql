--
-- show top objects with the most CR buffers in buffer cache
--
col objname	format a60		head 'Object Name : SubObject'
col obj_bf	format 9,999,999	head 'Total|Buffers'
col tcr_bf	format 999,999		head 'Cloned|Buffers'
col obj_pct	format 99.9		head 'Clone|Pct'

with	 tcr as
(select  objd
        ,count(*) 	cr_bf
from     v$bh           
where	 status 	= 'cr'
group by objd
)
	,tobj as
(
select   objd
        ,count(*)	obj_bf
from     v$bh           
group by objd
)
select	 *
from
(
select 	 owner||'.'||object_name||decode(subobject_name,null,' ',' : '||subobject_name)	objname
	,tobj.obj_bf									obj_bf
	,tcr.cr_bf									tcr_bf
	,100*(tcr.cr_bf/tobj.obj_bf) 							obj_pct
from 	 tcr
	,tobj
	,dba_objects 	o
where	 tcr.objd	= o.data_object_id
and	 tobj.objd	= o.data_object_id
and	 tcr.objd	= tobj.objd
order by tcr_bf desc
)
where	rownum <= 30
;
