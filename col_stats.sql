set linesi 190
set verify off
col histogram format a15
col low_value format a20
col high_value format a20
col column_name format a30
set pagesi 0
set echo off
select COLUMN_NAME,NUM_DISTINCT,LOW_VALUE,HIGH_VALUE,DENSITY,NUM_NULLS,histogram from DBA_TAB_COL_STATISTICS where table_name=upper('&table_name') and owner=nvl(upper('&owner'),'BOOKER');
