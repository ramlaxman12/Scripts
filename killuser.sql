set line 200 pages 2000
select 'alter system kill session '''||sid||','||serial#||''' immediate;' from v$session where username='&USER';

