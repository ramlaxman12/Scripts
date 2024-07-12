col AVERAGE_READ_TIME for 9999.999
col FS for a27
col host_name for a36
set lines 400 pages 299
select HOST_NAME,substr(file_name,1,(instrb(file_name,'/',2,1) - 1)) FS,avg(AVERAGE_READ_TIME *10 ) AVERAGE_READ_TIME,
sum(PHYSICAL_READS + PHYSICAL_BLOCK_READS) Reads
from gv$filemetric_history fh,dba_data_files df, gv$instance i
where df.file_id = fh.file_id and AVERAGE_READ_TIME > 0 and i.INST_ID = fh.INST_ID
group by HOST_NAME,substr(file_name,1,(instrb(file_name,'/',2,1) - 1));