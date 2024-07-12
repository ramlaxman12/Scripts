--
-- Show top objects in terms of User I/O (eg. event like db file%) in ash
--
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
	,u.name||'.'||o.name||decode(o.subname,null,' ',' : ')||o.subname 	obj
from 	 v$active_session_history 	ash
        ,v$event_name 			en
	,sys.obj$ 			o
	,sys.user$ 			u
where 	 ash.event#		= en.event# 
and 	 en.wait_class		= 'User I/O'
and 	 current_obj# 		= o.obj#
and	 o.owner#		= u.user#
group by current_obj#
	,u.name||'.'||o.name||decode(o.subname,null,' ',' : ')||o.subname
	,event
having count(*) 		> 100
order by event
	,cnt
;

