set pages 500 lines 200
col module for a50
col username for a32
col machine for a60

select username, module, count(*) from v$session where osuser is not null and username is not null group by username, module order by 3 ;
