undef stat_string
@plusenv
col statno	format 999	head 'Stat#'
col statname	format a40	head 'Stat Name'
col class	format 9999	head 'Class'
select 	 statistic#		statno
	,name			statname
	,class
from 	 v$statname
where 	 lower(name) 		like lower('%&stat_string%')
order by name
;
