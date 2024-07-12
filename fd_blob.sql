set linesi 190
set pagesi 1000
select l.PARTITION_NAME,s.TABLESPACE_NAME,l.SEGMENT_CREATED,s.bytes/(1024*1024) lob_size,s.next_extent/(1024*1024) next_extent,l.securefile  from dba_segments s, dba_lob_partitions l where l.TABLE_OWNER=s.owner and l.LOB_NAME=s.segment_name and l.LOB_PARTITION_NAME=s.partition_name and l.table_name='FULFILLMENT_DEMANDS' and l.table_owner='BOOKER' order by l.partition_name;
