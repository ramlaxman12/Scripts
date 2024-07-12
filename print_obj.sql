undef objname
exec print_table('select * from dba_objects where object_name=''&objname'' ');
