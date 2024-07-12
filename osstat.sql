@plusenv
col stat_name	format a30
col value 	format 999,999,999,999
select * from v$osstat 
where cumulative = 'NO' 
and stat_name not like 'TCP%' 
and stat_name not like 'GLOBAL%';
@sm
