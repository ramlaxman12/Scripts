col db_name for a10
col action_time for a30 trunc
col action for a10 trunc
col NAMESPACE for a10
col version for a12
col ID for 9999
col comments for a40 trunc
col BUNDLE_SERIES for a15
set pages 1000 lin 200 trimspool on head on feed on
break on db_name on version skip 1
select  d.name db_name,
VERSION,
ACTION_TIME,
ACTION,
NAMESPACE,
NAMESPACE,
ID,
BUNDLE_SERIES,
COMMENTS
from    dba_registry_history, v$database d
where   upper(BUNDLE_SERIES) like '%PSU%'
order by version, ACTION_TIME;
