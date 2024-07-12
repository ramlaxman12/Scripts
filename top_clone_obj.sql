--
-- show top objects with the most clones in buffer cache
--
col objname	format a60		head 'Object Name : SubObject'
col obj_bf	format 9,999,999	head 'Total|Buffers'
col tcl_bf	format 999,999		head 'Cloned|Buffers'
col obj_pct	format 99.9		head 'Clone|Pct'

with	 cl as
(select  objd
        ,file#
        ,block#
        ,count(*)-1 	cl_bf
from     v$bh           
group by objd
        ,file#
        ,block#
having 	 count(*) >1
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
	,tcl.tcl_bf									tcl_bf
	,100*(tcl.tcl_bf/tobj.obj_bf) 							obj_pct
from 	 (select objd, sum(cl_bf) tcl_bf from cl group by objd) tcl
	,tobj
	,dba_objects 	o
where	 tcl.objd	= o.data_object_id
and	 tobj.objd	= o.data_object_id
and	 tcl.objd	= tobj.objd
order by tcl_bf desc
)
where	rownum <= 30
;
