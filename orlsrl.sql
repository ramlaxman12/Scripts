set lines 400 pages 299
col REDO_FILE_NAME for a63
col type for a9
break on thread#
SELECT 'ORL' AS TYPE
	,a.thread#
	,a.group#
	,a.archived
	,a.status
	,b.MEMBER AS REDO_FILE_NAME
	,(a.BYTES / 1024 / 1024 / 1024) AS SIZE_GB
FROM v$log a
JOIN v$logfile b ON a.Group# = b.Group# 
UNION
SELECT 'SRL' AS TYPE
	,a.thread#
	,a.group#
	,a.archived
	,a.status
	,b.MEMBER AS REDO_FILE_NAME
	,(a.BYTES / 1024 / 1024 / 1024) AS SIZE_GB
FROM v$standby_log a
JOIN v$logfile b ON a.Group# = b.Group# order by thread#;