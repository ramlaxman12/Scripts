set pagesi 1000
set linesi 190
col column_name format a30
select owner,table_name,column_name,segment_name,tablespace_name from dba_lobs where owner='BOOKER' order by table_name;
