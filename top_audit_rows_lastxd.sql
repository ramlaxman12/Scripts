--
-- This script shows the top_x_rows in the laxt x days for objects being audited - used maily to determine which object+action generates the most audit records
--
@set_sessiontimezone
@big_job
@plusenv
--SES_ACTIONS	Session summary (a string of 16 characters, one for each action type in the order 
--		ALTER, AUDIT, COMMENT, DELETE, GRANT, INDEX, INSERT, LOCK, RENAME, SELECT, UPDATE, REFERENCES, and EXECUTE. 
--		Positions 14, 15, and 16 are reserved for future use. 
--		The characters are: - for none, S for success, F for failure, and B for both).

undef last_x_days
undef top_x_rows
col objname	for a40
col priv#	for 999
col priv_used	for a30
col tmstmp	for a14 		head 'Latest Timestamp'
col pct		for 99.9
col days_ago	for 99.99		head 'Days|Ago'
col action_name	for a12		trunc
col ses_actions	for a16			head 'AACDGIILRSURX---'
col rowrank	noprint
col mmdd	for a5			head 'Date'

break on mmdd skip 1
select	 *
from
(
select 	 to_char(cast(ntimestamp# as date),'MM/DD')		mmdd
	,count(*)					count
	,100*ratio_to_report (count(*)) over (partition by to_char(cast(ntimestamp# as date), 'MM/DD')) 		pct
	,row_number() over (partition by to_char(cast(ntimestamp# as date), 'MM/DD') order by count(*) desc) 	rowrank
	,max(to_char(cast(NTIMESTAMP# as date),'MM/DD HH24:MI:SS'))	tmstmp
	,sysdate - max(cast(NTIMESTAMP# as date))			days_ago
	,userid
	,aa.name				action_name
	,obj$creator||decode(obj$name,null,'','.')||obj$name		objname
	,ses$actions				ses_actions
	,m.name					priv_used
from 	 sys.aud$				a
	,sys.system_privilege_map		m
	,sys.audit_actions			aa
where	 cast(ntimestamp# as date)	>= sysdate - &&last_x_days
and	 -a.priv$used			= m.privilege (+)
and	 a.action#			= aa.action (+)
group by to_char(cast(ntimestamp# as date),'MM/DD')
	,aa.name
	,userid
	,obj$creator||decode(obj$name,null,'','.')||obj$name		
	,ses$actions
	,m.name
)
where	 rowrank 		<= &&top_x_rows
order by mmdd
	,rowrank
/
