set linesi 180
set pagesi 100
col snapid format 9999
col snapshot_site format a15
col master_table_name  format a38
col log_table  format a38
col snap_table_at_snapsite format a38
break on snapshot_site  
select nvl(r.SNAPSHOT_SITE,'ORPHAN') snapshot_site,r.owner||'.'||r.name snap_table_at_snapsite,s.mowner||'.'||s.master master_table_name,sl.log_owner||'.'||sl.log_table log_table,s.snaptime,sl.snapshot_id snapid from dba_registered_snapshots r,sys.slog$ s,dba_snapshot_logs sl where s.snapid=r.snapshot_id(+) and s.snapid=sl.snapshot_id  order by snapshot_site,owner,name;
