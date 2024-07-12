undef sid
exec print_table('select * from v$sql_workarea_active where sid=''&&sid'' ');
undef sid
