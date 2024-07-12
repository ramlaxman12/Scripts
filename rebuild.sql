undef index_name
alter session set ddl_lock_timeout=100;
alter index booker.&&index_name rebuild online parallel 8;
alter index BOOKER.&index_name noparallel;
undef index_name
