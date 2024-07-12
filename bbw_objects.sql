@plusenv
SELECT * FROM (
   SELECT owner, object_name, subobject_name, object_type, 
          tablespace_name, value
   FROM v$segment_statistics
   WHERE statistic_name='buffer busy waits'
   ORDER BY value DESC)
WHERE ROWNUM <=20
;
