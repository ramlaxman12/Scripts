column "wait event" format a50 word_wrap
column "session" format a25
column "minutes" format 9999D9
column CHAIN_ID noprint
column N noprint
column l noprint
with w as (
select
 chain_id,rownum n,level l
 ,lpad(' ',level,' ')||(select instance_name from gv$instance where inst_id=w.instance)||' '''||w.sid||','||w.sess_serial#||'@'||w.instance||'''' "session"
 ,lpad(' ',level,' ')||w.wait_event_text ||
   case
   when w.wait_event_text like 'enq: TM%' then
    ' mode '||decode(w.p1 ,1414332418,'Row-S' ,1414332419,'Row-X' ,1414332420,'Share' ,1414332421,'Share RX' ,1414332422,'eXclusive')
     ||( select ' on '||object_type||' "'||owner||'"."'||object_name||'" ' from all_objects where object_id=w.p2 )
   when w.wait_event_text like 'enq: TX%' then
    (
     select ' on '||object_type||' "'||owner||'"."'||object_name||'" on rowid '
     ||dbms_rowid.rowid_create(1,data_object_id,relative_fno,w.row_wait_block#,w.row_wait_row#)
     from all_objects ,dba_data_files where object_id=w.row_wait_obj# and w.row_wait_file#=file_id
    )
   end "wait event"
 , w.in_wait_secs/60 "minutes"
 , s.username , s.program
 from v$wait_chains w join gv$session s on (s.sid=w.sid and s.serial#=w.sess_serial# and s.inst_id=w.instance)
 connect by prior w.sid=w.blocker_sid and prior w.sess_serial#=w.blocker_sess_serial# and prior w.instance = w.blocker_instance
 start with w.blocker_sid is null
)
select * from w where chain_id in (select chain_id from w group by chain_id having max("minutes") >= 1 and max(l)>1 )
order by n
/
