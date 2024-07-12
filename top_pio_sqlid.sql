@plusenv

col dreadspx	format 999,999,999.9
col bgetspx	format 999,999,999.9
col executions	format 9,999,999,999
col disk_reads	format 9,999,999,999
col buffer_gets	format 99,999,999,999
col sql_text	format a100		trunc
col lactv_pdt	format a14

select * from
(
select 	 sql_id
	,to_char(new_time(last_active_time,'GMT','PDT'),'YY/MM/DD HH24:MI')	lactv_pdt
	,executions
	,disk_reads 
	,disk_reads / executions	dreadspx
	,buffer_gets
	,buffer_gets /executions	bgetspx
	,sql_text
from 	 v$sqlarea 
where	 executions	>10
order by disk_reads desc
)
where	 rownum 	<= 30
;
