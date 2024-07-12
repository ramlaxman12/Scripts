set echo off feed off arraysize 500
--
-- to enable restartability after space failure (14400 secs = 4 hours)
--
alter session enable resumable timeout 14400;
--
-- to enhance chance of acquiring exclusive ddl lock
--
alter session set ddl_lock_timeout=100;
--
-- to speed up multiblock i/O (ie. scattered read, direct temp read/write)
--
alter session set db_file_multiblock_read_count=128;
alter session set "_smm_auto_max_io_size"=1024;
alter session set "_smm_auto_min_io_size"=512;
--
-- to speed up sort (workarea) - MANUAL is better for really big job (large SORT) along with parallelism
-- sort_area_size (in bytes)
--
alter session set workarea_size_policy = manual;
alter session set sort_area_size = 536870912;  
--
-- How to super-size the work area memory size that can be used by any session in the database? (453540.1)
-- _smm_max_size (in KB)
-- _smm_px_max_size (in KB)
--
--alter session set "_smm_max_size"=20480; 
--alter session set "_smm_px_max_size"=40960; 
--alter system  set "_pga_max_size"=2G;
--
-- to enable PQO
--
alter session force parallel query parallel 3;
alter session enable parallel dml;
alter session force parallel dml parallel 3;
--
-- terminate "online index create/rebuild" if lock is not acquired after 120 secs
--alter session set events = '10626 trace name context forever, level 120';
--
set time on
set timing on
