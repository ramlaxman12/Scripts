-- run on non-dropship SRW database
-- Count Active FDs in specified partition and print the drop partition command if active_rows=0
@/home/sreekanc/scripts/big_job.sql
set linesi 190
set pagesi 1000
SET SERVEROUTPUT ON SIZE 1000000
SET ECHO ON

DECLARE

rows_to_update  number  :=0;
v_sql_to_run    varchar(4000);

cursor fd_part_cursor IS
select    partition_name,table_owner,table_name
from      all_tab_partitions
where   table_owner in ('BOOKER') and
                table_name='FULFILLMENT_DEMANDS' and
                partition_name <= 'FULFILLMENT_DEMANDS_20130931' order by partition_name;


BEGIN
dbms_snapshot.set_i_am_a_refresh(value => true);

FOR i in fd_part_cursor LOOP
dbms_output.new_line;
dbms_output.put_line('--Checking partition : '||i.partition_name);
   v_sql_to_run := 'select    /*+ full(fd) parallel(fd,16) */ count(*)         '||
                     'from      fulfillment_demands partition ('||i.partition_name||') fd '||
                     'where     exists (    select ''x'' from       shipment_requests sr '||
                                                'where  fd.fulfillment_reference_id = sr.request_reference_id and sr.warehouse_id = fd.warehouse_id)';
   execute immediate v_sql_to_run into rows_to_update;
if (rows_to_update=0) then
dbms_output.put_line('--No active rows found.');
dbms_output.put_line('alter table '||i.table_owner||'.'||i.table_name||' drop partition '||i.partition_name||' parallel 12 update global indexes;');
dbms_output.new_line;
else
dbms_output.put_line('--Active rows '||rows_to_update||' found.Please check');
end if;
END LOOP; -- for loop

EXCEPTION
WHEN NO_DATA_FOUND THEN
   rows_to_update := 0;
END;    -- For Begin
/

