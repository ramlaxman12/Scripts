undef obj_name
prompt => v$db_object_cache
set echo on verify on
exec print_table('select * from v$db_object_cache where namespace=''MULTI-VERSION OBJECT FOR TABLE'' and type=''MULTI-VERSIONED OBJECT'' and name = upper(''&&obj_name'') ');
undef obj_name
