set linesi 190
set pagesi 0
set verify off
 SELECT s.child_number, m.position, m.max_length,
  decode(m.datatype,1,'VARCHAR2',2,'NUMBER',m.datatype) AS datatype
  FROM v$sql s, v$sql_bind_metadata m
  WHERE s.sql_id = '&sql_id'
 and s.child_number=nvl('&child_number',s.child_number)
 AND s.child_address = m.address
  ORDER BY 1, 2;

