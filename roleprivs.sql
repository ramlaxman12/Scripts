set linesi 190
set pagesi 0
accept username prompt "Enter Username : ";
select privilege,admin_option from role_sys_privs where role=upper('&username');
select owner,table_name,privilege from role_tab_privs where role=upper('&username') order by table_name;
select granted_role from role_role_privs where role=upper('&username');
