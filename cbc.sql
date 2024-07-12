col p1 format 99999999999999999999
select sql_id,p1,count(*)
from v$session
where event like 'latch: cache buffers chain%'
group by sql_id,p1;
-- Use bhla.sql and give p1 as input. It'll show the segment affected by cbc
