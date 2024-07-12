@plusenv
col name format a60
col pct  format 999.9
select df.name name,fs.file#,fs.PHYRDS, 100*ratio_to_report(PHYRDS) over () pct
from v$filestat fs
	,v$datafile df
where df.file# = fs.file#
order by 3
/
