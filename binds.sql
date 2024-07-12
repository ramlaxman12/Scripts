set heading on 
undef sql_id
col bind_name format a15
col bind_string format a30
col data_type for a15
col Time for a32
col CHILD for 999
select
--  b.sql_id,
b.CHILD_NUMBER CHILD,
  b.name BIND_NAME,
  b.value_string BIND_STRING,
b.datatype_string DATA_TYPE,
anydata.accesstimestamp(b.value_anydata) "Time",
 LAST_CAPTURED
from
  v$sql t,
   v$sql_bind_capture b
where
--  b.value_string is not null
   b.sql_id='&sql_id'
and t.sql_id=b.sql_id
and t.child_number=b.child_number
-- order by LAST_CAPTURED, name
/
