@plusenv
col oname		format a40	head 'Object Name'
undef data_OBJ_id
undef relative_fno
undef BLOCK_id
undef ROW
select 	 
	dbms_rowid.rowid_create ( 1, &&data_OBJ_id, &&relative_fno, &&BLOCK_id, &&ROW )
from 	 dual
;
o

--select DBMS_ROWID.ROWID_BLOCK_NUMBER(rowid),count(*),min(DBMS_ROWID.rowid_create(1,30896,13,DBMS_ROWID.ROWID_BLOCK_NUMBER(rowid),1)),max(DBMS_ROWID.rowid_create(1,30896,13,DBMS_ROWID.ROWID_BLOCK_NUMBER(rowid),1000)) from BOOKER.COMPETITOR_CATEGORIES group by DBMS_ROWID.ROWID_BLOCK_NUMBER(rowid) order by 2;

