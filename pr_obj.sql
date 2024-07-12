undef object_name
exec print_table('select * from dba_objects where object_name=''&&object_name'' ');
undef object_name
