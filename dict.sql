set pagesi 0
undef 1
select table_name from dict where table_name like upper('%'||'&1'||'%');
