set lines 400 pages 299
col begin_time for a18
select
       to_char(begin_time,'yyyy-mm-dd hh24:mi') begin_time,
       file_id fid,  
       average_read_time *10  avgrd_ms,
       average_write_time *10 avgwr_ms,
       physical_reads pr,
       physical_writes pw
from
      GV$FILEMETRIC_HISTORY f
	where inst_id = &inst_id
order by begin_time;