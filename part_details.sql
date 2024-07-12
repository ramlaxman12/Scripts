set lines 400 pages 200
col PARTITION_NAME for a27
col table_name for a27
col table_owner for a27
col PARTITION_NAME for a36
col HIGH_VALUE for a36
SELECT  *
FROM 
(
	SELECT  TABLE_OWNER
	       ,TABLE_NAME
	       ,PARTITION_NAME
	       ,HIGH_VALUE
	FROM dba_tab_partitions
	WHERE table_owner='&owner' 
	AND table_name='&table_name'
	ORDER BY PARTITION_NAME 
)
WHERE rownum <=90;
