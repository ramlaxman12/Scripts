--
-- Show current sessions that trigger index splits
--
@plusenv
col module	format a30 	trunc
col sid		format 99999
col objid	format 999999999
col event	format a30	trunc

select * from
(
select 	 /*+ ordered */
	 ses.sid		sid
	,decode(ses.event,null,'<'||ses.status||'>',ses.event)	event
	,ses.sql_id
	,ses.prev_sql_id
	,decode(ses.module,null,'<'||ses.machine||'>',ses.module)	module
	,decode(sn.name,'leaf node splits',		'LeafSplit'
	               ,'branch node splits',		'BranchSplit'
		       ,'leaf node 90-10 splits',	'Leaf90Split' 
		       ,'root node splits',		'RootSplit'
		       ,sn.name)	split_type
	,ss.value 			svalue
from 	 v$session	ses
	,v$sesstat 	ss
	,v$statname 	sn 
where	 ses.sid	= ss.sid
and	 ses.status	= 'ACTIVE'
and 	 ss.statistic#	= sn.statistic# 
and 	 sn.name 	like '%node%splits%' 
and 	 ss.value 	> 0
)
pivot
(
	max(svalue) for split_type in ('LeafSplit','Leaf90Split','BranchSplit','RootSplit')
)
order by sql_id
;
