set linesi 190
set pagesi 100
col log_owner format a15
col master format a32
col snapshot_site format a20
col log_table format a32
col Is_Stale? format a10
break on log_owner on master on log_table on mlog_size 
select l.log_owner,l.master,l.log_table,s.bytes/(1024*1024) mlog_size,sl.snaptime snaptime,r.SNAPSHOT_SITE,(case when sl.snaptime<sysdate-1 then 'Y' end) "Is_Stale?" from dba_registered_snapshots r,dba_mview_logs l,dba_segments s, sys.slog$ sl where l.master=sl.master(+) and s.segment_name(+)=l.LOG_TABLE and s.owner(+)=l.log_owner and sl.snapid=r.snapshot_id(+) order by l.log_owner,l.master,l.log_table,s.bytes/(1024*1024),sl.snaptime ;
