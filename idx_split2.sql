select * from
(
select 	 ss.sid
	,decode(sn.name,'leaf node splits',		'lf_s'
	               ,'branch node splits',		'br_s'
		       ,'leaf node 90-10 splits',	'lf90_s' 
		       ,'root node splits',		'rt_s'
		       ,sn.name)	split_type
	,ss.value 			svalue
from v$sesstat ss, v$statname sn 
where sn.name like '%node%splits%' 
and ss.statistic#=sn.statistic# 
and ss.value >0
)
pivot
(
	max(svalue) for split_type in ('lf_s','br_s','lf90_s','rt_s')
)
;
