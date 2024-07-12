COL "DAY" FOR A10
COL "00" FOR A4
COL "01" FOR A4
COL "02" FOR A4
COL "03" FOR A4
COL "04" FOR A4
COL "05" FOR A4
COL "06" FOR A4
COL "07" FOR A4
COL "08" FOR A4
COL "09" FOR A4
COL "10" FOR A4
COL "11" FOR A4
COL "12" FOR A4
COL "13" FOR A4
COL "14" FOR A4
COL "15" FOR A4
COL "16" FOR A4
COL "17" FOR A4
COL "18" FOR A4
COL "19" FOR A4
COL "20" FOR A4
COL "21" FOR A4
COL "22" FOR A4
COL "23" FOR A4
COL TOT_GB for 9999.99
set lines 180
set pages 10000
SELECT  to_char(completion_time,'YYYY-MM-DD')  DAY,
to_char(sum(decode(to_char(completion_time,'HH24'),'00',(blocks*block_size)/1024/1024/1024,0)),'999') "00",
to_char(sum(decode(to_char(completion_time,'HH24'),'01',(blocks*block_size)/1024/1024/1024,0)),'999') "01",
to_char(sum(decode(to_char(completion_time,'HH24'),'02',(blocks*block_size)/1024/1024/1024,0)),'999') "02",
to_char(sum(decode(to_char(completion_time,'HH24'),'03',(blocks*block_size)/1024/1024/1024,0)),'999') "03",
to_char(sum(decode(to_char(completion_time,'HH24'),'04',(blocks*block_size)/1024/1024/1024,0)),'999') "04",
to_char(sum(decode(to_char(completion_time,'HH24'),'05',(blocks*block_size)/1024/1024/1024,0)),'999') "05",
to_char(sum(decode(to_char(completion_time,'HH24'),'06',(blocks*block_size)/1024/1024/1024,0)),'999') "06",
to_char(sum(decode(to_char(completion_time,'HH24'),'07',(blocks*block_size)/1024/1024/1024,0)),'999') "07",
to_char(sum(decode(to_char(completion_time,'HH24'),'08',(blocks*block_size)/1024/1024/1024,0)),'999') "08",
to_char(sum(decode(to_char(completion_time,'HH24'),'09',(blocks*block_size)/1024/1024/1024,0)),'999') "09",
to_char(sum(decode(to_char(completion_time,'HH24'),'10',(blocks*block_size)/1024/1024/1024,0)),'999') "10",
to_char(sum(decode(to_char(completion_time,'HH24'),'11',(blocks*block_size)/1024/1024/1024,0)),'999') "11",
to_char(sum(decode(to_char(completion_time,'HH24'),'12',(blocks*block_size)/1024/1024/1024,0)),'999') "12",
to_char(sum(decode(to_char(completion_time,'HH24'),'13',(blocks*block_size)/1024/1024/1024,0)),'999') "13",
to_char(sum(decode(to_char(completion_time,'HH24'),'14',(blocks*block_size)/1024/1024/1024,0)),'999') "14",
to_char(sum(decode(to_char(completion_time,'HH24'),'15',(blocks*block_size)/1024/1024/1024,0)),'999') "15",
to_char(sum(decode(to_char(completion_time,'HH24'),'16',(blocks*block_size)/1024/1024/1024,0)),'999') "16",
to_char(sum(decode(to_char(completion_time,'HH24'),'17',(blocks*block_size)/1024/1024/1024,0)),'999') "17",
to_char(sum(decode(to_char(completion_time,'HH24'),'18',(blocks*block_size)/1024/1024/1024,0)),'999') "18",
to_char(sum(decode(to_char(completion_time,'HH24'),'19',(blocks*block_size)/1024/1024/1024,0)),'999') "19",
to_char(sum(decode(to_char(completion_time,'HH24'),'20',(blocks*block_size)/1024/1024/1024,0)),'999') "20",
to_char(sum(decode(to_char(completion_time,'HH24'),'21',(blocks*block_size)/1024/1024/1024,0)),'999') "21",
to_char(sum(decode(to_char(completion_time,'HH24'),'22',(blocks*block_size)/1024/1024/1024,0)),'999') "22",
to_char(sum(decode(to_char(completion_time,'HH24'),'23',(blocks*block_size)/1024/1024/1024,0)),'999') "23",
sum(blocks*block_size)/1024/1024/1024 Tot_GB
from v$ARCHIVED_LOG
where to_date(completion_time) > sysdate -30
and dest_id=1
GROUP by to_char(completion_time,'YYYY-MM-DD') order by 1
/