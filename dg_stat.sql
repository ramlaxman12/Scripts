@plusenv
col facility		format a25
col message_num		format 9999999	head 'Msg Num'
col error_code		format 99999	head 'Err'
col callout		format a03
col message		format a110
select * from
(
select timestamp, facility, message_num, error_code, callout, message
from v$dataguard_status
order by timestamp desc
)
where rownum < 11
order by timestamp
;
