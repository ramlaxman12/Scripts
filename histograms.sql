set pagesi 0
set linesi 190
col column_name format a30
break on column_name
SELECT column_name,endpoint_number, endpoint_value FROM DBA_HISTOGRAMS  WHERE table_name = upper('&table_name') and owner=nvl('&owner','BOOKER') AND column_name=nvl('&column_name',column_name) order by column_name,endpoint_number;
