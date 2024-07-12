set lines 160
undef top_n

col operation		format a33
col options		format a22
col oname		format a30	head 'Object Name'
col erows		format 9999999	head 'Est|Rows'
col lrows		format 999999	head 'Last|Rows'
col ecost		format 99999	head 'Est|Cost'
col exec		format 99999999	head 'Execs'
col lbgets		format 999999	head 'Last|Bfr|Gets'
col bgets		format 9999999	head 'Bfr|Gets'
col lmsecs		format 999999999 head 'Last|msecs'
col sqlid		format a16

select * from
(
SELECT   sql_id||'_'||child_number	sqlid
	,lpad(' ',depth)||id||' '||operation 	operation
	,options			options
        ,object_name			oname
	,executions			exec
        ,last_output_rows 		lrows
	,last_cr_buffer_gets		lbgets
        ,cr_buffer_gets			bgets
FROM     v$sql_plan_statistics_all
WHERE	 options is not null
AND	 object_name is not null
ORDER BY cr_buffer_gets desc
)
where 	 rownum <= &&top_n
;
