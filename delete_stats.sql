set serveroutput on
exec DBMS_STATS.DELETE_TABLE_STATS('&Owner','&Table_Name');

