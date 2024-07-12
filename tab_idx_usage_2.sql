set pagesi 0
set lines 190
col in_use 	format a06	head 'In Use?'
col tab_name	format a40	head 'Table Name'
col iname	format a50	head 'Index Name'
col execs	format 999,999,999
col bgetspx	format 999999.9	head 'BfrGets|PerX'
col sql_id	format a13
set verify off

undef tab_owner;
undef tab_name;

break on in_use on tab_name
WITH 	 in_plan_objects AS
(
SELECT	 sql_id, object_name
FROM 	 v$sql_plan
WHERE 	 object_owner not in ('SYS','SYSTEM')
group by sql_id, object_name
)
	,all_sql AS
(
SELECT	 sql_id
	,sum(executions) execs
	,sum(buffer_gets)/sum(executions) bgetspx,
         max(last_active_time) lat
FROM 	 v$sql
WHERE	 executions	>0
group by sql_id
)
select	 decode(object_name,null,'NO','YES')	in_use
 	,i.table_owner||'.'||i.table_name 	tab_name
	,p.sql_id				sqlid
	,s.execs				execs
	,least(s.bgetspx,999999)		bgetspx
	,decode(substr(index_name,1,3),'PK_','  '||i.owner||'.'||i.index_name,owner||'.'||index_name) iname
        ,lat last_active_time
FROM 	 dba_indexes 		i
	,in_plan_objects	p
	,all_sql		s
WHERE 	 i.index_name 	= p.object_name (+)
and	 p.sql_id	= s.sql_id (+)
and 	 table_owner 	= upper('&&tab_owner')
and 	 table_name 	= upper('&&tab_name')
order by in_use
	,i.table_owner||'.'||i.table_name
	,i.index_name
	,s.execs
;
undef tab_owner;
undef tab_name;
