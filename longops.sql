col opname for a30
select sid,opname,sofar,totalwork,round((sofar/totalwork)*100) "PCT_DONE", time_remaining from v$session_longops where sofar<>totalwork;
