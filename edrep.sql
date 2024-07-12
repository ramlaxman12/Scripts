set linesi 200
set pagesi 0
col source_table_owner format a10
col source_table format a20
col source_table_location format a10
col target_table_owner format a10
col target_table format a20
col staging_table format a23
col deleted_table format a20
col data_pull_mode format a15
select SOURCE_TABLE_LOCATION,SOURCE_TABLE_OWNER,SOURCE_TABLE,TARGET_TABLE_OWNER,TARGET_TABLE,DELETED_ROW_TABLE,STAGING_TABLE,LAST_PULL_END_TIME,DATA_PULL_MODE from data_pull_schedules where target_table='INVENTORY_COSTS' order by 1;
