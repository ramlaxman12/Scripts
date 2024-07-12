set linesi 190
set feedback off
set verify off
set pagesi 0
accept username prompt "Enter Username : ";
prompt ;
prompt Sys privileges:;
select privilege,admin_option from dba_sys_privs where grantee=upper('&username');
prompt ;
prompt Object privileges:;
select owner,table_name,privilege from dba_tab_privs where grantee=upper('&username') order by table_name;
prompt ;
prompt Roles granted:;
select granted_role from dba_role_privs where grantee=upper('&username');
