set lines 170
col name	format a25
col value	format a20
col time_computed format a20
col unit	format a30

prompt ** Run on standby **
/
select name, value, time_computed, unit
from v$dataguard_stats
order by name
;
