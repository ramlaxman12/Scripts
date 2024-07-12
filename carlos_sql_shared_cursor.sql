SET HEA OFF LIN 300 NEWP NONE PAGES 0 FEED OFF ECHO OFF VER OFF TRIMS ON TRIM ON TI OFF TIMI OFF SQLBL ON BLO . RECSEP OFF;
SPO union_all.sql
SELECT CASE WHEN ROWNUM &gt; 1 THEN 'UNION ALL ' ELSE '          ' END||
       'SELECT '''||column_name||
       ''' reason_not_shared, sql_id, child_number FROM mv WHERE '||
       LOWER(column_name)||' = ''Y''' big_union_all
  FROM dba_tab_columns
 WHERE table_name = 'V_$SQL_SHARED_CURSOR'
   AND owner = 'SYS'
   AND data_length = 1
/
SPO OFF;
GET union_all.sql
A ) -
SELECT COUNT(*) cursors, -
COUNT(DISTINCT sql_id) sql_ids, -
reason_not_shared -
FROM union_query -
GROUP BY reason_not_shared -
ORDER BY cursors DESC, sql_ids DESC;
0 union_query AS (
0 mv AS (SELECT /*+ MATERIALIZE NO_MERGE */ * FROM v$sql_shared_cursor),
0 WITH 
SET HEA ON NEWP 1 PAGES 30
/
!rm union_all.sql