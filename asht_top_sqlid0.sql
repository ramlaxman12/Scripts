@plusenv
col sql_id      format a13
col module      format a40 trunc
col cpu         format 999,999  head '*CPU*'
col wait        format 999,999
col io          format 999,999
col tot         format 9,999,999        head 'TOT'
col pctcpu      format 999.9    head 'CPU%'
col pctio       format 999.9    head 'IO%'
select   sql_id
        ,module
        ,cpu
        ,100*ratio_to_report (cpu) over () pctcpu
        ,wait
        ,io
        ,100*ratio_to_report (io) over () pctio
        ,tot
from
(
select   ash.sql_id                                                                             sql_id
        ,nvl(ash.module,'['||substr(ash.machine,1,instr(ash.machine,'amazon')-2)||']')          module
        ,sum(decode(ash.session_state,'ON CPU',1,0))                                            cpu
        ,sum(decode(ash.session_state,'WAITING',1,0)) - sum(decode(ash.session_state,'WAITING',decode(en.wait_class, 'User I/O',1,0),0))    wait
        ,sum(decode(ash.session_state,'WAITING', decode(en.wait_class, 'User I/O',1,0),0))      io
        ,sum(decode(ash.session_state,'ON CPU',1,1))                                            tot
from     v$active_session_history       ash
        ,v$event_name                   en
where    ash.sql_id             is not NULL
and      ash.is_sqlid_current   = 'Y'
and      ash.event#             = en.event# (+)
and      sample_time between timestamp'&&t1' and timestamp'&&t2'
group by sql_id
        ,nvl(ash.module,'['||substr(ash.machine,1,instr(ash.machine,'amazon')-2)||']')
order by sum(decode(session_state,'ON CPU',1,0))   desc
)
where rownum <=10
;
