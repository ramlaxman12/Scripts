undef sql_id
exec print_table('select * from v$sqlstats where sql_id=''&sql_id'' ');
