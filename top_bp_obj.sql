@plusenv
col pct 	format 99.9
col oname 	format a65
col cnt 	format 999,999,999
col used_mb	format 99,999.9
col sum_tch	format 99,999,999
col avg_tch	format 999.9

with bhc as
(
select 	 obj
	,sum(tch) sum_tch
	,avg(tch) avg_tch
	,count(*) cnt
from	 x$bh
group by obj
)
select * from
(
select 	 obj
	,o.owner||'.'||o.object_name||decode(subobject_name,null,'',': ')||subobject_name	oname
	,sum_tch
	,avg_tch
	,cnt
	,cnt*bs.blksize/(1024*1024)				used_mb
	,100*ratio_to_report(cnt) over() 			pct
from 	 bhc
	,dba_objects o
	,(SELECT value blksize   from v$parameter where name='db_block_size') bs
where	 obj = o.object_id
order by cnt desc
)
where	 rownum <= 30
;
