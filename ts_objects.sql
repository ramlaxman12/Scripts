set pagesi 190
column COLUMN_NAME format a25
set heading on
set feedback off
set linesi 190
undef tablespace_name
accept tablespace_name prompt "Enter tablespacename : "
prompt ============== Tables ==========================
select owner,table_name from dba_tables where tablespace_name='&tablespace_name';

prompt
prompt ============== Table partitions ==========================
prompt

select table_owner,table_name,partition_name from dba_tab_partitions where tablespace_name='&tablespace_name';

prompt
prompt ============== Table subpartitions ====================
prompt

select table_owner,TABLE_NAME,PARTITION_NAME,SUBPARTITION_NAME from DBA_TAB_SUBPARTITIONS where TABLESPACE_NAME='&tablespace_name';

prompt
prompt ============== Indexes ==========================
prompt

select owner,index_name from dba_indexes where tablespace_name='&tablespace_name';

prompt
prompt ============== Index partitions ==========================
prompt

select index_owner,index_name,partition_name from dba_ind_partitions where tablespace_name='&tablespace_name';

prompt
prompt ============== Index subpartitions  ==========================
prompt

select INDEX_OWNER,INDEX_NAME,PARTITION_NAME,SUBPARTITION_NAME from dba_ind_subpartitions where TABLESPACE_NAME='&tablespace_name';

prompt
prompt ============== LOBs  ==========================
prompt

select owner,table_name,column_name,SEGMENT_NAME from dba_lobs where TABLESPACE_NAME='&tablespace_name';

prompt
prompt ============== LOB partitions ==========================
prompt

select table_owner,table_name,column_name,partition_name from dba_lob_partitions where TABLESPACE_NAME='&tablespace_name';

prompt
prompt ============== Lob subpartitions  ==========================
prompt

select TABLE_OWNER,TABLE_NAME,COLUMN_NAME,LOB_NAME,SUBPARTITION_NAME from dba_lob_subpartitions where TABLESPACE_NAME='&tablespace_name';

prompt
prompt ============== All segemnts  ==========================
prompt

select segment_name,segment_type,bytes/(1024*1024) from dba_segments where tablespace_name='&tablespace_name';

prompt
prompt ============== Partition table default  ==========================
prompt

select owner,table_name,partitioning_type from dba_part_tables where DEF_TABLESPACE_NAME='&tablespace_name';

prompt
prompt ============== Partition Index default  ==========================
prompt

select owner,index_name,table_name,PARTITIONING_TYPE from dba_part_indexes where def_TABLESPACE_NAME='&tablespace_name';

prompt
prompt ============== Partition LOBs default =================
prompt

select TABLE_OWNER,TABLE_NAME,COLUMN_NAME,LOB_NAME from dba_part_lobs where def_TABLESPACE_NAME='&tablespace_name';

prompt
prompt ============== SubPartition template =================
prompt

select USER_NAME,TABLE_NAME,SUBPARTITION_NAME,TABLESPACE_NAME from DBA_SUBPARTITION_TEMPLATES where tablespace_name='&tablespace_name';
undef tablespace_name
