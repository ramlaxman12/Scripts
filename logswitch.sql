set lines 400 pages 299
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
select
  to_char(first_time,'YY-MM-DD') day,
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'00',1,0)),'999') "00",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'01',1,0)),'999') "01",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'02',1,0)),'999') "02",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'03',1,0)),'999') "03",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'04',1,0)),'999') "04",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'05',1,0)),'999') "05",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'06',1,0)),'999') "06",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'07',1,0)),'999') "07",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'08',1,0)),'999') "08",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'09',1,0)),'999') "09",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'10',1,0)),'999') "10",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'11',1,0)),'999') "11",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'12',1,0)),'999') "12",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'13',1,0)),'999') "13",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'14',1,0)),'999') "14",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'15',1,0)),'999') "15",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'16',1,0)),'999') "16",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'17',1,0)),'999') "17",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'18',1,0)),'999') "18",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'19',1,0)),'999') "19",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'20',1,0)),'999') "20",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'21',1,0)),'999') "21",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'22',1,0)),'999') "22",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'23',1,0)),'999') "23",
  COUNT(*) TOT_SWITCHES_PER_DAY
from v$log_history
group by to_char(first_time,'YY-MM-DD')
order by day;