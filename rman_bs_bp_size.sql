set lines 400 pages 299
col completion_time for a36
SELECT TO_CHAR(completion_time, 'DD-MON-YYYY') completion_time, type, round(sum(bytes)/1024/1024/1024/1024) TB, round(sum(elapsed_seconds)/60) min
FROM
(
SELECT
CASE
  WHEN s.backup_type='L' THEN 'ARCHIVELOG'
  WHEN s.controlfile_included='YES' THEN 'CONTROLFILE'
  WHEN s.backup_type='D' AND s.incremental_level=0 THEN 'LEVEL0'
  WHEN s.backup_type='I' AND s.incremental_level=1 THEN 'LEVEL1'
END type,
TRUNC(s.completion_time) completion_time, p.bytes, s.elapsed_seconds
FROM v$backup_piece p, v$backup_set s
WHERE p.status='A' and p.SET_STAMP=s.SET_STAMP and p.set_count = s.set_count
UNION ALL
SELECT 'DATAFILECOPY' type, TRUNC(completion_time), output_bytes, 0 elapsed_seconds FROM v$backup_copy_details
)
GROUP BY TO_CHAR(completion_time, 'DD-MON-YYYY'), type
ORDER BY 1 ASC,2,3;