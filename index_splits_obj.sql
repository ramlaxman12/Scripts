--
-- showing index contention due to splits for last 3 days for a single index
--
undef index_name
@plusenv
@sort_job

col cnt		format 999999
col objid	format 99999999
col event	format a32	trunc
col oname	format a64	trunc
col stime	format a11

break on event on objid on oname on sqlid skip 1
select	 event					event
        ,CURRENT_OBJ#				objid
        ,owner||'.'||object_name||decode(subobject_name,null,' ',' : ')||subobject_name	oname
	,SQL_ID					sqlid
       	,to_char(sample_time,'YY/MM/DD HH24') stime
	,count(*)				cnt
from 	 DBA_HIST_ACTIVE_SESS_HISTORY
	,dba_objects o
where	 event		= 'enq: TX - index contention'
and	 sample_time 	> sysdate-3
and	 CURRENT_OBJ# 	= o.OBJECT_ID
and	 o.object_name	= upper('&&index_name')
group by to_char(sample_time,'YY/MM/DD HH24')
	,CURRENT_OBJ#
        ,owner||'.'||object_name||decode(subobject_name,null,' ',' : ')||subobject_name
	,SQL_ID
	,event
order by CURRENT_OBJ#
	,SQL_ID
	,to_char(sample_time,'YY/MM/DD HH24')
;
