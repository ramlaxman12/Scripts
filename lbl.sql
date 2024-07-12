set serveroutput on
undef sql_id
undef plan_hash_value
undef fixed
DECLARE
my_plans pls_integer;
BEGIN
  my_plans := DBMS_SPM.LOAD_PLANS_FROM_CURSOR_CACHE( sql_id => '&sql_id',plan_hash_value  => nvl('&plan_hash_value',null),fixed=>nvl('&fixed','YES'));
  dbms_output.put_line(my_plans||' sql plan loaded');
END;
/
undef sql_id
undef plan_hash_value
undef fixed
