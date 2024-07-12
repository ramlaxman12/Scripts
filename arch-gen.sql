select trunc(FIRST_TIME,'HH24'),count(*) from v$archived_log where FIRST_TIME>sysdate-7 group by trunc(FIRST_TIME,'HH24') order by 1;
