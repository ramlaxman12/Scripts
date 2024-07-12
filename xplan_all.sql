undef sql_id
set linesize 120
set pagesize 9000

@sqlid_info


prompt	========== from awr ==========
select 	 t.*
from
	(select distinct sql_id, plan_hash_value from v$sql_plan where sql_id = '&&sql_id') s
	,table(dbms_xplan.display_awr(s.sql_id,null,null,'basic')) t
;
prompt	========== from Cursor  ==========
select 	 t.*
from
	(select distinct sql_id,child_number, plan_hash_value from v$sql_plan where sql_id = '&&sql_id') s
	,table(dbms_xplan.display_cursor(s.sql_id,s.child_number,'basic')) t
;
