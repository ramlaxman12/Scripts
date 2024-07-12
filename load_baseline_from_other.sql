declare
  gg binary_integer;
begin
  gg:=dbms_spm.load_plans_from_cursor_cache(
      sql_id          => '&new_sql_id', 
      plan_hash_value => '&new_plan_hash_value',
      sql_handle      => '&original_sql_handle');
end;
/
