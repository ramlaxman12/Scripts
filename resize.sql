set linesi 190
set pagesi 0
SELECT /*+rule*/ 'ALTER DATABASE DATAFILE '''||FILE_NAME||''' RESIZE '||CEIL( (NVL(HWM,1)*par.VALUE)/1024/1024 )||'M;' FROM DBA_DATA_FILES A , V$PARAMETER par , ( SELECT FILE_ID, MAX(BLOCK_ID+BLOCKS-1) HWM FROM DBA_EXTENTS GROUP BY FILE_ID ) B WHERE A.FILE_ID = B.FILE_ID(+) AND par.name = 'db_block_size' and tablespace_name='&1';
