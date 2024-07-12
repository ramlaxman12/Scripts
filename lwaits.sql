set linesi 200
set pagesi 2000
col command	format a05		head 'Cmd'		trunc
col event  	format a16  		head 'Wait Event' 	trunc
col sql_id   	format a15	        head 'sql_id'
col child       format 99
col mach	format a10		head 'Machine'		trunc
col module 	format a24  		head 'Module' 		trunc
col orauser    	format a12		head 'Oracle|User'	trunc
col status    	format a1		head 'S'	trunc
col p1     	format 999999999999999	head 'P1'
col p2     	format 999999999999999	head 'P2'
col p3     	format 999999  		head 'P3'
col sid	   	format a05  		head 'SID'
col sqlid	format a15    	        head 'SQL Id'
col state  	format a07  		head 'Wait|State' 	trunc
col wtim   	format 99999999  		head 'Wait|Time'
col blocking_session   	format 9999  		head 'blck|sess'
col last_call_et   	format 9999999  		head 'last|callet'

SELECT 	 
	/*+ RULE */
	 rpad(sw.sid,5,' ')					sid,
	se.status 
	,se.username 						orauser
	,decode(se.module,null,'. '||substr(se.username,1,6),se.module)	module
       	,decode (se.command
	       , 0, '      '
	       , 1, 'CR TB'
               , 2, 'ISRT'
	       , 3, 'SEL'
	       , 4, 'CR CL'
	       , 5, 'AL CL'
	       , 6, 'UPDT'
	       , 7, 'DEL'
	       , 8, 'DR'
	       , 9, 'CR IX'
	       ,10, 'DR IX'
	       ,11, 'AL IX'
	       ,12, 'DR TB'
	       ,15, 'AL TB'
	       ,17, 'GRANT'
	       ,18, 'REVOK'
	       ,19, 'CRSYN'
	       ,20, 'DRSYN'
	       ,21, 'CR VW'
	       ,22, 'DR VW'
	       ,26, 'LK TB'
	       ,27, 'NO OP'
	       ,28, 'RENM'
	       ,29, 'CMNT'
	       ,30, 'AUDIT'
	       ,31, 'NOAUD'
	       ,32, 'CR DBL'
	       ,33, 'DR DBL'
	       ,34, 'CR DB'
	       ,35, 'AL DB'
	       ,36, 'CR RBS'
	       ,37, 'AL RBS'
	       ,38, 'DR RBS'
	       ,39, 'CR TS'
	       ,40, 'AL TS'
	       ,41, 'DR TS'
	       ,42, 'AL SES'
	       ,43, 'AL USR'
	       ,44, 'COMMIT'
	       ,45, 'ROLLBK'
	       ,46, 'SAVEPT'
	       ,47, 'PL/SQL'
	       ,62, 'AN TB'
	       ,63, 'AN IX'
	       ,64, 'AN CL'
	       ,85, 'TR TB'
	       ,    to_char(se.command)
	       )               	command
	,se.sql_id      sql_id
	,se.sql_child_number child
	,sw.event
       	,sw.state
       	,sw.seconds_in_wait 		wtim
	,lb.sid      blocking_session
	,last_call_et
FROM     v$session              se
        ,v$session_wait         sw
        ,v$process              p
        ,v$latchholder         lb
WHERE   
         sw.sid         = se.sid
AND      p.addr         = se.paddr
AND      hextoraw(lpad(ltrim(to_char(sw.p1,'XXXXXXXXXX')), 16 , '0'))        = lb.laddr
ORDER BY lb.name,se.module
;

ttitle off
set pause off
