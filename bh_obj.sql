@plusenv
col pct 	format 99.9
col oname 	format a65
col cnt 	format 999,999,999

with bhc as
(
select 	 objd
	,count(*) cnt
from	 v$bh
group by objd
)
select 	 objd
	,o.owner||'.'||o.object_name||' - '||subobject_name	oname
	,cnt
	,100*ratio_to_report(cnt) over() pct
from 	 bhc
	,dba_objects o
where	 cnt >1000
and	 objd = o.object_id
order by cnt
;
