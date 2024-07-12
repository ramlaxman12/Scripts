col OTYPE for a27
col sql_id for a18
col CLASS for a18
col PCT for a10
col OBJ for a27
set lines 400 pages 299
select
       o.object_name obj,
       o.object_type otype,
       ash.SQL_ID,
       w.class,
       TRIM(ROUND(RATIO_TO_REPORT(COUNT(*)) OVER () * 100, 1)) || '%' PCT
from gv$active_session_history ash,
     ( select rownum class#, class from gv$waitstat ) w,
      all_objects o
where event='&event_name'
   and w.class#(+)=ash.p3
   and o.object_id (+)= ash.CURRENT_OBJ#
   group by o.object_name,o.object_type,ash.SQL_ID,w.class order by 5 desc;