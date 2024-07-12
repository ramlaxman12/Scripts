@plusenv
col event#	format 999999
col eq_name	format a32	trunc
col req_reason	format a30	trunc
col req_description	format a46	word_wrapped
col event#	format 999
select * from v$enqueue_statistics 
where 	CUM_WAIT_TIME >100
and	TOTAL_WAIT# > 100
order by CUM_WAIT_TIME
;
