
col free_space for 99999999999
col TABLESPACE_SIZE for 99999999999
select TABLESPACE_NAME,TABLESPACE_SIZE/1024/1024 "TS_SIZE(M)",ALLOCATED_SPACE/1024/1024 "ALLOCATED(M)",FREE_SPACE/1024/1024 "FREE(M)" from dba_temp_free_space ;
