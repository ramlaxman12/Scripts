--
-- turn off PQO which was set with big_job.sql
--
set echo off feed off
alter session force parallel query parallel 1;
alter session disable parallel dml;
alter session force parallel dml parallel 1;
