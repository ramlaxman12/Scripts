select owner||'.'||view_name from dba_views where view_name like 'DBA_HIST%' order by 1;
