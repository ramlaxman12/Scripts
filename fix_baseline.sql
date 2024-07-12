set serveroutput on
set feed on
undef sql_handle
undef plan_name
declare
  v_out binary_integer;
begin
   v_out := dbms_spm.ALTER_SQL_PLAN_BASELINE(
           sql_handle =>'&sql_handle',
           plan_name=>'&plan_name',
           attribute_name=>'fixed',
           attribute_value=>'YES');
end;
/
undef sql_handle
undef plan_name
