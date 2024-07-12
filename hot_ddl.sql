set serveroutput on
exec ddl_util.hot_ddl('&1',5000);
