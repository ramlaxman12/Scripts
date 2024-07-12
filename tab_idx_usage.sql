--
-- This script is used primarily to help determine if unused indexes can be dropped
-- Given a table, list all indexes: whether and when they have been used in the last 31 days
--

undef tab_owner
undef tab_name

@plusenv
--@big_job

col bgpx        format 999,999,999      head 'BGets|PerX'
col cf		format a06		head 'Cache ?'
col days_ago	format 999		head 'Days|Ago'
col execs	format 9,999,999,999 	head 'Execs'
col iname       format a50      	head 'Index Name'
col last_ref	format a14		head 'Last Used'	trunc
col part	format a03		head 'Part'		trunc
col phash	format a11		head 'Plan Hash'
col tab_name    format a40      	head 'Table Name'
col unf		format a09		head 'Unused ?'
col uniq	format a01		head 'U'		trunc
col vis         format a01      	head 'V'		trunc

break on tab_name on uniq on vis on part on iname on phash skip 1 

WITH 	 in_plan as
(
SELECT   object_owner, object_name, sql_id, plan_hash_value, max(timestamp) last_ref
FROM     dba_hist_sql_plan	
GROUP BY object_owner, object_name, sql_id, plan_hash_value
having 	 max(timestamp) > sysdate-31
union
SELECT   object_owner, object_name, sql_id, plan_hash_value, max(timestamp) last_ref
FROM     v$sql_plan		
GROUP BY object_owner, object_name, sql_id, plan_hash_value
having 	 max(timestamp) > sysdate-31
)
	,vsql as
(
SELECT   sql_id
	,plan_hash_value
	,sum(executions) execs
	,max(last_active_time) last_ref
	,sum(buffer_gets)/decode(sum(executions),0,1,sum(executions))                  bgpx
FROM     v$sql
where 	 lower(sql_fulltext) 	not like '% dbms_stats %'
and 	 lower(sql_fulltext) 	not like '% SQL Analyze%'
GROUP BY sql_id
	,plan_hash_value
having	 max(last_active_time) > sysdate-31
)
	,hsql as
(
SELECT   s.sql_id
	,s.plan_hash_value 
	,sum(s.executions_delta) execs
	,sum(s.buffer_gets_delta)/sum(decode(s.executions_delta,0,1,s.executions_delta)) bgpx
FROM     dba_hist_sqlstat	s
	,dba_hist_sqltext	t
where	 s.sql_id	= t.sql_id
and	 lower(t.sql_text)	not like '%dbms_stats%'
and 	 lower(t.sql_text) 	not like '%SQL Analyze%'
and 	 lower(t.sql_text) 	not like '%DS_SVC%'
and	 s.parsing_schema_name	<> 'SYS'
GROUP BY s.sql_id
	,s.plan_hash_value
)
	,tab_idx as
(
select	 table_owner
	,table_name
	,owner		idx_owner
	,index_name
	,uniqueness
	,visibility
	,partitioned
from	 dba_indexes
where	 table_owner	= upper('&&tab_owner')
and	 table_name	= upper('&&tab_name')
and	 index_type	<> 'LOB'
)
select	 /*+ ordered */
	 distinct
	 i.table_owner||'.'||i.table_name			tab_name
	,i.uniqueness						uniq
	,i.visibility						vis
	,i.partitioned						part
	,i.idx_owner||'.'||index_name				iname
	,decode(p.sql_id,null,'<unused>','')  			unf
	,decode(p.sql_id,null,'',p.plan_hash_value)		phash
	,decode(s.sql_id,null,p.sql_id,s.sql_id) 		sql_id
	,decode(s.sql_id,null,'   No','Yes') 			cf
	,decode(s.execs,null,hs.execs,s.execs)			execs
	,decode(s.bgpx,null,hs.bgpx,s.bgpx)			bgpx
	,round(sysdate - decode(s.last_ref,null,p.last_ref,s.last_ref)) days_ago
	,decode(s.last_ref,null,p.last_ref,s.last_ref) 		last_ref
from	 tab_idx	i
	,in_plan	p
	,vsql		s
	,hsql		hs
where	 i.index_name		= p.object_name (+)
and	 i.idx_owner		= p.object_owner (+)
and	 p.sql_id		= s.sql_id (+)
and	 p.plan_hash_value 	= s.plan_hash_value (+)
and	 p.sql_id		= hs.sql_id (+)
and	 p.plan_hash_value 	= hs.plan_hash_value (+)
order by iname
	,unf
	,cf desc
	,days_ago desc
	,execs desc
;

