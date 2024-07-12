@plusenv

col sname		format a40	head 'Segment Name'	trunc
col lrd_val		format 999,999	head 'Logical|Reads M'
col lrd_pct		format 99.9	head '%'
col prd_val		format 999,999	head 'Physical|Reads M'
col prd_pct		format 99.9	head '%'
col bbw_val		format 999,999,999	head 'Buffer Busy|Waits'
col bbw_pct		format 99.9	head '%'
col itl_val		format 999,999	head 'ITL Waits'
col itl_pct		format 99.9	head '%'
col rlw_val		format 999,999,999	head 'Row Lock|Waits'
col rlw_pct		format 99.9	head '%'
col spc_val		format 999,999		head 'Space|Used MB'
col spc_pct		format 99.9	head '%'

with		 lrd
as
(
select * from
	(
   select 	 owner||'.'||object_name 			sname
		,round(sum(value)/1000000) 			lrd_val
		,100*ratio_to_report(sum(value)) over () 	lrd_pct
   from v$segment_statistics
   where statistic_name = 'logical reads'
   and owner not in ('SYS','SYSTEM')
   and owner not like ('%_DBA')
   group by owner||'.'||object_name, statistic_name
   order by lrd_pct desc
	)
where rownum <=20
)
		,prd
as
(
select * from
	(
   select 	 owner||'.'||object_name 			sname
		,round(sum(value)/1000000) 			prd_val
		,100*ratio_to_report(sum(value)) over () 	prd_pct
   from v$segment_statistics
   where statistic_name = 'physical reads direct'
   and owner not in ('SYS','SYSTEM')
   and owner not like ('%_DBA')
   group by owner||'.'||object_name, statistic_name
   order by prd_pct desc
	)
where rownum <=200
)
		,rlw
as
(
select * from
	(
   select owner||'.'||object_name sname,sum(value) rlw_val, 100*ratio_to_report(sum(value)) over () rlw_pct
   from v$segment_statistics
   where statistic_name = 'row lock waits'
   and owner not in ('SYS','SYSTEM')
   and owner not like ('%_DBA')
   group by owner||'.'||object_name, statistic_name
   order by rlw_pct desc
	)
where rownum <=200
)
		,bbw
as
(
select * from
	(
   select owner||'.'||object_name sname,sum(value) bbw_val, 100*ratio_to_report(sum(value)) over () bbw_pct
   from v$segment_statistics
   where statistic_name = 'buffer busy waits'
   and owner not in ('SYS','SYSTEM')
   and owner not like ('%_DBA')
   group by owner||'.'||object_name, statistic_name
   order by bbw_pct desc
	)
where rownum <=200
)
		,itl
as
(
select * from
	(
   select owner||'.'||object_name sname,sum(value) itl_val, 100*ratio_to_report(sum(value)) over () itl_pct
   from v$segment_statistics
   where statistic_name = 'ITL waits'
   and owner not in ('SYS','SYSTEM')
   and owner not like ('%_DBA')
   group by owner||'.'||object_name, statistic_name
   order by itl_pct desc
	)
where rownum <=200
)
		,spc
as
(
select * from
	(
   select 	 owner||'.'||object_name 			sname
		,round(sum(value)/1024/1024)			spc_val
		,100*ratio_to_report(sum(value)) over () 	spc_pct
   from v$segment_statistics
   where statistic_name = 'space used'
   and owner not in ('SYS','SYSTEM')
   and owner not like ('%_DBA')
   group by owner||'.'||object_name, statistic_name
   order by spc_pct desc
	)
where rownum <=200
)
select 	 lrd.sname
	,lrd.lrd_val
	,lrd.lrd_pct
	,prd.prd_val
	,prd.prd_pct
	,rlw.rlw_val
	,rlw.rlw_pct
	,bbw.bbw_val
	,bbw.bbw_pct
	,itl.itl_val
	,itl.itl_pct
	,spc.spc_val
	,spc.spc_pct
from	 lrd
	,prd
	,rlw
	,bbw
	,itl
	,spc
where	 lrd.sname	= prd.sname(+)
and	 lrd.sname	= rlw.sname(+)
and	 lrd.sname	= bbw.sname(+)
and	 lrd.sname	= itl.sname(+)
and	 lrd.sname	= spc.sname(+)
order by lrd.lrd_pct desc
;
