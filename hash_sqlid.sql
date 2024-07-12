undef sql_hash
col sqlid_c	format a16
col cputime	format 9999999999999
col llt		format a12 	head 'Last|Load Time'
col lat		format a12	head 'Last|Active Time'
col sql_text	format a140
select * from
(
select 	 sql_id||':'||child_number sqlid_c
	,cpu_time	cputime
	,to_char(to_date(last_load_time,'YYYY-MM-DD/HH24:MI:SS'),'YYMMDD HH24:MI') llt
	-- following column in 10gR2 --
	--,to_char(last_active_time,'YYMMDD HH24:MI') lat
	,hash_value
	,plan_hash_value
	,sql_text
from 	 v$sql
where 	 hash_value = &&sql_hash
order by last_load_time desc
)
where rownum <=20
;
