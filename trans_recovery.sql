set linesize 190 
  alter session set NLS_DATE_FORMAT='DD-MON-YYYY HH24:MI:SS'; 
  select usn, state, undoblockstotal "Total", undoblocksdone "Done", undoblockstotal-undoblocksdone "ToDo", 
             decode(cputime,0,'unknown',sysdate+(((undoblockstotal-undoblocksdone) / (undoblocksdone / cputime)) / 86400)) 
              "Estimated time to complete" ,sysdate "Current Time"
   from v$fast_start_transactions; 
select ktuxeusn, to_char(sysdate,'DD-MON-YYYY HH24:MI:SS') "Time", ktuxesiz "Remaining undo blks to rolbak", ktuxesta 
   from x$ktuxe 
   where ktuxecfl = 'DEAD'; 
