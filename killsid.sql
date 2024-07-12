undef sid
select 'alter system kill session ''' || sid || ',' || serial# || ''' immediate;' from v$session where
sid = &sid
/
