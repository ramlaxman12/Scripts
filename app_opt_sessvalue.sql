set lines 400 pages 299
col SQL_FEATURE for a27
select * from GV$SES_OPTIMIZER_ENV where sid=&sid and ISDEFAULT='NO' and INST_ID=&inst_id;
