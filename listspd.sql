exec dbms_spd.flush_sql_plan_directive;
SET LINESIZE 200

COLUMN dir_id FORMAT A20
COLUMN owner FORMAT A10
COLUMN object_name FORMAT A10
COLUMN col_name FORMAT A10

SELECT TO_CHAR(d.directive_id) dir_id, o.owner, o.object_name, 
       o.subobject_name col_name, o.object_type, d.type, d.state, d.reason
FROM   dba_sql_plan_directives d, dba_sql_plan_dir_objects o
WHERE  d.directive_id=o.directive_id
and o.owner='VISHNU'
ORDER BY 1,2,3,4,5;
