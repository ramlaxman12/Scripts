col AVERAGE_WRITE_TIME for 9999.999
col FS for a27
col host_name for a36
select HOST_NAME,substr(file_name,1,(instrb(file_name,'/',2,1) - 1)) FS,avg(AVERAGE_WRITE_TIME * 10) AVERAGE_WRITE_TIME,
sum(PHYSICAL_WRITES + PHYSICAL_BLOCK_WRITES) Writes
from gv$filemetric_history fh,dba_data_files df, gv$instance i
where df.file_id = fh.file_id and AVERAGE_WRITE_TIME > 0 and i.INST_ID = fh.INST_ID
group by HOST_NAME,substr(file_name,1,(instrb(file_name,'/',2,1) - 1));