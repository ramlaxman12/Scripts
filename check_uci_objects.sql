select distinct owner, table_name,column_name from dba_tab_columns where
( column_name like '%ADDRESS%' or
column_name like '%DRIVER_LICENSE%' or
column_name like '%FAMILY_NAME%' or
column_name like '%FIRST_NAME%' or
column_name like '%GIVEN_NAME%' or
column_name like '%LAST_NAME%' or
column_name like '%LATITUDE%' or
column_name like '%LINE%' or
column_name like '%LONGITUDE%' or
column_name like '%PHONE%' or
column_name like '%SSN_%'  or 
column_name like '%ZIP%'  ) and 
(owner not in ('SYS','SYSTEM','DBSNMP','ADMIN','PERFSTAT','PRECISE','SQLTXPLAIN','STDBYPERF') and 
owner not like '%DBA') 
and table_name not in ('WAREHOUSE_ADDRESSES','INVODS_USERS','WAREHOUSES','IP_CFG_GL_SETTINGS','PORTAL_USERS','WAREHOUSE_SHIP_METHOD_ZONES')
and table_name not like 'SQL_AREA%' and table_name not like 'SQL_PLAN%'
and 
(column_name not in (
'ADDRESS_AREA',
'ADDRESS_CODE',
'ADDRESS_DESCRIPTION',
'ADDRESS_KEY',
'ADDRESS_MATCH_FLAG', 
'ADDRESS_MONIKER',
'ADDRESS_NUM',
'ADDRESS_ROLE',
'ADDRESS_SOURCE',
'ADDRESS_SOURCE_TYPE_CODE' ,
'ADDRESS_STYLE',
'ADDRESS_TYPE', 
'ADDRESS_TYPE_CODE',
'ADDRESS_USAGE_TYPE_CODE',
'ADDRESS_VALIDATION_LEVEL_CODE',
'ADDRESS_VERIFICATION_CODE',
'ADDRESSING',
'MAC_ADDRESS',
'NAS_ADDRESS', 
'NET_ADDRESS', 
'OS_FAMILY_NAME' ,
'PHONETIC',
'REMOTE_ADDRESS' ,
'ROUTINGADDRESS', 
'SENDER_ADDRESS', 
'SERVER_ADDRESS', 
'SERVER_MAC_ADDRESS', 
'SERVERNETPHYSICALADDRESS',
'WORKER_ADDRESS',
'ZIP_FILE_NAME',
'PRODUCT_LINE_CODE',
'LINE_ITEM_ID',
'ACTION_CLASSNAME',
'MATCH_CLASSNAME',
'IP_ADDRESS_LIST_ID'
)
)
and column_name not like '%BASELINE%' and column_name not like '%OUTLINE%' and column_name not like '%DEADLINE%' and column_name not like '%ADDRESS_ID%' 
and column_name not like '%ADDRESS_TYPE%' and column_name not like '%PRODUCT_LINE%' and column_name not like '%SIDELINE%' and column_name not like '%PIPELINE%'
and column_name not like '%LINE_NUM%' and column_name not like '%LINE_TYPE%' and column_name not like '%LINE_COUNT%' and column_name not like '%ADDRESS_FLAG%'
and column_name not like '%IN_LINE%'
/
