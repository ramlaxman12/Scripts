undef table_name
undef table_owner
set linesi 190
col grantee format a30
col privilege format a30
select grantee,privilege,grantor,grantable from dba_tab_privs where table_name=upper('&table_name') and owner=nvl(upper('&table_owner'),'BOOKER') order by grantee,privilege;
undef table_name
undef table_owner
