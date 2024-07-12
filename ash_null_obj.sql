undef last_x_mins
set echo off feed off
@big_job
@plusenv
col owner for a10
col segment_name for a40
col segment_type for a15
col cnt for 9999
Select 
      count(*) cnt, 
      owner, 
      segment_name , 
      segment_type
from 
      v$active_session_history ash, 
      dba_extents ext
where
       ( event like 'db file s%' or event like 'direct%' )
    and (current_obj# in (0,-1) or current_obj# is Null)
    and sample_time > sysdate - &&last_x_mins/(60*24)
    and session_state='WAITING'
    and P1 = file_id
    and P2  between  block_id and block_id + blocks - 1
group by 
   owner, segment_name, segment_type
/
@big_job_off
