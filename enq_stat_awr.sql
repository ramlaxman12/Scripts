col waitcnt	format 999,999,999,999	head 'Wait Cnt'
col waitsec	format 9,999,999.9	head 'Wait Secs'
select	 sum(total_wait#) 		waitcnt
	,sum(cum_wait_time)/1000000	waitsec
	,eq_type
	,req_reason
from	 dba_hist_enqueue_stat
group by eq_type
	,req_reason
having	 sum(cum_wait_time)/1000000	>300
order by sum(cum_wait_time)
;
