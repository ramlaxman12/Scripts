set lines 250 pages 500
 col KEEP_PART_VALIDATION_CLAUSE for a15
 col ROW_MOVEMENT_NEW_KEY_VALUE for a15
select TABLE_NAME,ROLLING_PARTITION_TYPE,RETAIN_NUM_PARTITIONS,PRE_CREATE_NUM_PARTITIONS,KEEP_PART_VALIDATION_CLAUSE,ROW_MOVEMENT_NEW_KEY_VALUE from  db_rolling_partitions order by 1 ;