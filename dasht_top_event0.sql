@plusenv
col event       format a32 trunc
col sql_id      format a13
col cpu         format 999,999
col wait        format 999,999
col io          format 999,999
col tot         format 9,999,999        head '*TOT*'
col pctwait     format 999.9    head 'WAIT%'
col pctio       format 999.9    head 'IO%'
col pcttot      format 999.9    head 'TOT%'
select   event
        ,sql_id
        ,wait
        ,100*ratio_to_report (wait) over () pctwait
        ,io
        ,100*ratio_to_report (io) over () pctio
        ,tot
        ,100*ratio_to_report (tot) over () pcttot
from
(
select   dash.event      event
        ,dash.sql_id     sql_id
        ,sum(decode(dash.session_state,'WAITING',1,0)) - sum(decode(dash.session_state,'WAITING',decode(en.wait_class, 'User I/O',1,0),0))    wait
        ,sum(decode(dash.session_state,'WAITING', decode(en.wait_class, 'User I/O',1,0),0))    io
        ,sum(decode(dash.session_state,'ON CPU',1,1))     tot
from     dba_hist_active_sess_history       dash
        ,v$event_name                   en
where    event                  is not NULL
and      sql_id                 is not NULL
and      dash.is_sqlid_current   = 'Y'
and      dash.session_state      = 'WAITING'
and      dash.event_id             = en.event# (+)
and      sample_time between timestamp'&&t1' and timestamp'&&t2'
group by event, sql_id
order by sum(decode(dash.session_state,'WAITING',1,1)) desc
)
where rownum <=10
;
