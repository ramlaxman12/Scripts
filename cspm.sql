set serveroutput on
undef sql_id
undef plan_hash
set lines 170 pages 50000 long 20000 longc 20000  termout on

accept sql_id prompt 'Enter the sql_id: '
accept plan_hash prompt 'Enter the desired plan hash: '
--------------------------------------------------------------------------------
-- Use input to capture required data for execution
--------------------------------------------------------------------------------
variable v_outline_xml clob;
variable v_sql_text clob;
variable v_exists number;

set feedback off
begin
  select   sql_text into :v_sql_text from (
    select s.sql_fulltext sql_text from v$sql s
    where s.sql_id = '&&sql_id'
    and s.child_number = ( select min(child_number) from v$sql where sql_id = '&&sql_id')
  ) where rownum<=1;
  --
  select other_xml into :v_outline_xml from (
    select other_xml from v$sql_plan where plan_hash_value = '&&plan_hash' and other_xml is not null) where  rownum<=1 ;
  --
  -- Check to see if this plan has ever been used for this sql.  If not, notify the user.
  select sign(sum(plan_count)) into :v_exists from (
    select count(*) as plan_count from v$sql_plan
    where sql_id = '&&sql_id' and plan_hash_value = '&&plan_hash'
  );
  --
exception
when others then
null;
end;
/
set feedback on

--------------------------------------------------------------------------------
-- Make sure the user wants to continue and do the import
--------------------------------------------------------------------------------


declare
my_plans pls_integer;
  v_profile sys.sqlprof_attr;
begin
  if (
    (:v_sql_text is null)
    or
    (:v_outline_xml is null)
  )
  then
    dbms_output.put_line(chr(10)||'FATAL: Missing required data.  Unable to prcceed for sql: &&sql_id, plan: &&plan_hash'||chr(10));
    --
 elsif (:v_exists < 1)
  then
    dbms_output.put_line(chr(10)||
      'WARNING: The plan &&plan_hash has never been applied to this sql and hence we cant assign baseline.Exiting...'
    );
  else 
    --
    -- Extract hint data from xml
    select substr(extractvalue(value(d), '/hint'),1,4000)
      bulk collect into v_profile from table( xmlsequence(extract(xmltype(:v_outline_xml), '/*/outline_data/hint'))) d;
    --
    -- Add the header and footer records
    v_profile.extend;
    for i in reverse 2..v_profile.count
    loop
      v_profile(i) := v_profile(i-1);
    end loop;
    v_profile(1)                := 'BEGIN_OUTLINE_DATA';
    v_profile.extend;
    v_profile(v_profile.count)  := 'END_OUTLINE_DATA';
    --
    -- Import the profile
    dbms_output.put_line(chr(10)||'Creating SQL Profile for sql: &&sql_id, plan: &&plan_hash'||chr(10));
    DBMS_SQLTUNE.IMPORT_SQL_PROFILE(
      sql_text => :v_sql_text,
      profile => v_profile,
      name => 'PROFILE_&&sql_id'
    );
    --
  my_plans := DBMS_SPM.LOAD_PLANS_FROM_CURSOR_CACHE( sql_id => '&sql_id',plan_hash_value  => nvl('&plan_hash',null),fixed=>'YES');
  dbms_output.put_line(my_plans||' sql plan loaded');
  end if;
end;
/
undef sql_id
undef plan_hash_value
