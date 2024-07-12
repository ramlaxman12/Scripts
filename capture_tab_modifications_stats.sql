set echo on feed on
drop   table admin.db_tab_modifications;
create table admin.db_tab_modifications
tablespace administrator
as select * from sys.dba_tab_modifications
where 1=2
;
alter table admin.db_tab_modifications add capture_date date 
;
insert into admin.db_tab_modifications
(TABLE_OWNER,TABLE_NAME,PARTITION_NAME,SUBPARTITION_NAME,INSERTS,UPDATES,DELETES,TIMESTAMP,TRUNCATED,DROP_SEGMENTS,capture_date)
select 
 TABLE_OWNER,TABLE_NAME,PARTITION_NAME,SUBPARTITION_NAME,INSERTS,UPDATES,DELETES,TIMESTAMP,TRUNCATED,DROP_SEGMENTS,sysdate
from sys.dba_tab_modifications
;
commit
;
