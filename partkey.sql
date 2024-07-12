set pagesi 1500
col column_name format a40
set linesi 190
select OBJECT_TYPE,COLUMN_NAME,COLUMN_POSITION from DBA_PART_KEY_COLUMNS where owner=upper('&owner') and NAME=upper('&table_name') order by 3;
