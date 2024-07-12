set linesi 190
col log_owner format a15
col master format a32
col log_table format a32
select l.log_owner,l.master,l.log_table,s.bytes/(1024*1024) mlog_size,min(sl.snaptime) oldest_refresh_time,count(sl.master) total_snapsites from dba_mview_logs l,dba_segments s, sys.slog$ sl where l.master=sl.master(+) and s.segment_name(+)=l.LOG_TABLE and s.owner(+)=l.log_owner group by l.log_owner,l.master,l.log_table,s.bytes/(1024*1024) ;
