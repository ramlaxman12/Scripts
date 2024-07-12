set linesi 190
set verify off
column child_number heading 'CHILD' format 99999
column sql_profile format a21
column first_load_time format a20
column sql_text format a50 wrap on
column parsing_schema_name format a10
select parsing_schema_name,sql_id,plan_hash_value,sql_profile from DBA_HIST_SQLSTAT where lower(module) like 'SmartAlarms3' and parsing_schema_name like 'OLTP_USER';
