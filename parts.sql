set linesi 190
set verify off
set echo off
set pagesi 10000
col column_name format a40
col high_value format a85
col COLUMN_POSITION format a30
undef table_name
select COLUMN_NAME from dba_part_key_columns where OWNER='BOOKER' and  NAME=nvl(upper('&&table_name'),'FULFILLMENT_DEMANDS') and object_type='TABLE' order by COLUMN_POSITION;
select p.PARTITION_NAME,p.HIGH_VALUE,p.TABLESPACE_NAME,s.BYTES/(1024*1024) size_MB from dba_tab_partitions p,dba_segments s where s.SEGMENT_NAME(+)=p.TABLE_NAME and s.OWNER(+)=p.table_OWNER and s.PARTITION_NAME(+)=p.PARTITION_NAME and p.TABLE_OWNER='BOOKER' and p.TABLE_NAME=nvl(upper('&table_name'),'FULFILLMENT_DEMANDS') order by p.PARTITION_NAME;
undef table_owner
undef table_name
