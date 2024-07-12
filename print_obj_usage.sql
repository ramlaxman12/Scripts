undef tab_name
exec print_table('select * from v$object_usage where table_name =  upper(''&&tab_name'')');
