undef sql_id
exec print_table('select * from v$sqlstats_plan_hash where sql_id=''&sql_id'' ');
