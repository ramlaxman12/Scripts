undef object_pattern
set long 20000

select 	 to_char(DDL_DATE,'YYYY/MM/DD HH24:MI:SS')
	,to_char(new_time(DDL_DATE,'GMT','PDT'),'YYYY/MM/DD HH24:MI:SS') PDT
	,ORACLE_USERNAME
	,OBJECT_OWNER||'.'||OBJECT_NAME
	,TRUNCATED_DDL
from ADMIN.DB_AUDITED_DDL_OPERATIONS
where ddl_date between sysdate-30 and sysdate
and lower(OBJECT_NAME) like lower('%&&object_pattern%')
order by DDL_DATE
/
