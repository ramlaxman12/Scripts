col bind_name format a30
col bind_string format a30
select
  b.sql_id,
b.CHILD_NUMBER,
  b.name BIND_NAME,
  b.value_string BIND_STRING,
 LAST_CAPTURED
from
  v$sql t,
   v$sql_bind_capture b
where
  b.value_string is not null
  and b.sql_id='&sql_id'
and t.sql_id=b.sql_id
and t.child_number=b.child_number
order by LAST_CAPTURED
/
