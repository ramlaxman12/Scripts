col window_name format a17
col start_date format a10
col end_date format a10
col repeat_interval format a70
col duration format a15
col enabled format a10
col active format a10
col resource_plan format a15
select WINDOW_NAME,START_DATE,END_DATE,REPEAT_INTERVAL,DURATION,ENABLED,ACTIVE,RESOURCE_PLAN from DBA_SCHEDULER_WINDOWS;
