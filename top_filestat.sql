--
-- Show top datafiles in terms of disk I/Os
--
@plusenv

col file#	for 9999
col df_name	for a70
col ts_name	for a25
col pct_preads	for 99.9	head 'Pct'
col pct_pwrts	for 99.9	head 'Pct'
col pct_rdtim	for 99.9	head 'Pct'
col preads	for 9,999,999,999
col pwrts	for 9,999,999,999
col rdtim	for 99,999,999,999
col mb		for 99,999	head 'MB'

select * from
(
select	 fs.file#
	,fs.phyrds	preads
	,100*ratio_to_report (fs.phyrds) over () 	pct_preads
	,fs.phywrts	pwrts
	,100*ratio_to_report (fs.phywrts) over () 	pct_pwrts
	,fs.readtim	rdtim
	,100*ratio_to_report (fs.readtim) over () 	pct_rdtim
	,df.bytes/(1024*1024)				mb
	,df.name	df_name
	,ts.name	ts_name
from	 v$filestat	fs
	,v$datafile	df
	,v$tablespace	ts
where	 fs.file#	= df.file#
and	 df.ts#		= ts.ts#
order by fs.readtim	desc
)
where	 rownum 	<=50
;
