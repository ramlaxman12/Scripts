@plusenv
col event	format a20		head 'Wait Event'	trunc
col lmode	format 9		head 'M'
col logio   	format 99999		head 'LogIOs'
col mach	format a16 		head 'Machine'		trunc
col module	format a20 		head 'Module'		trunc
col object	format a44		head 'Locked Object'	
col orauser    	format a07		head 'Oracle|User'	trunc
col osuser	format a07		head 'OS User'		trunc
col sidser	format a15  		head 'Sid,Serial<Blk'
col sp		format a10 		head 'Svr-Pgm'
col sqlid	format a13		head 'SqlId'
col sta   	format a1		head 'S'		trunc
col starttm	format a05		head 'Start|Time'
col tmin	format 999		head 'Tx|Min'
col typ    	format a2		head 'Lk|Tp'

break on starttm on tmin on sidser on logio on sta on event on orauser on osuser on mach on sp on sqlid on module
with	 lobj as
(
select	 /*+ ordered */
	 l.session_id sid, u.name||'.'||o.name||decode(o.subname,null,' ','-')||o.subname object, l.locked_mode lmode
from	 v$locked_object l
	,sys.obj$ 	o
	,sys.user$ 	u
where	 l.object_id 	= o.obj#
and	 o.owner#	= u.user#
)
SELECT 	 /*+ ordered */
	--to_char(to_date(t.start_time,'MM/DD/YY HH24:MI:SS'),'HH24MI') 	starttm
	(sysdate-t.start_date)*(24*60) tmin
        ,rpad(se.sid,4,' ')||','||lpad(se.serial#,5,' ')||decode(substr(se.blocking_session_status,1,1),'V','<',' ')||lpad(se.blocking_session,4,' ')	sidser
	--,least(t.log_io,99999)			logio
	,se.status				sta
	,se.event				event
	,se.username 				orauser
	,se.osuser					osuser
	,substr(se.machine,1,instr(se.machine,'.')-1)	mach
	,lpad(pr.spid,5)||'-'||lpad(substr(nvl(pr.program,'null'),instr(pr.program,'(')+1,4),4)	sp
	,nvl(se.sql_id,se.prev_sql_id)		sqlid
	,se.module				module
	,lobj.lmode				lmode
	,lobj.object				object
FROM	 lobj
	,v$session	se
	,v$transaction 	t
	,v$process	pr
WHERE 	 lobj.sid	= se.sid 
AND   	 se.taddr 	= t.addr 
AND 	 se.paddr	= pr.addr
ORDER BY 
	 t.start_time desc
	,se.sid
	,lobj.lmode desc
	,lobj.object
;
