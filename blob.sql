set verify off
col column_name format a40
set linesi 190
col owner format a30
col segment_name format a30
select l.column_name,l.segment_name,s.PARTITION_NAME,s.tablespace_name,s.bytes/(1024*1024) from dba_lobs l ,dba_segments s where s.segment_name=l.segment_name and s.owner=l.owner and l.table_name=nvl(upper('&table_name'),'FULFILLMENT_DEMANDS')  and l.owner=nvl(upper('&owner'),'BOOKER') order by 1,2,3;
