@/home/sreekanc/scripts/big_job.sql
SET SERVEROUTPUT ON SIZE 1000000
SET ECHO ON
alter session set db_file_multiblock_read_count = 64;

DECLARE

upd_batch       number  :=20001;
rows_to_update  number  :=0;
commit_sleep    number  :=5; -- time in seconds
v_sql_to_run    varchar(4000);

cursor fd_part_cursor IS
select    partition_name
from      all_tab_partitions
where   table_owner in ('BOOKER') and
                table_name='FULFILLMENT_DEMANDS' and
                partition_name <= 'FULFILLMENT_DEMANDS_20130931'
order by partition_name;


BEGIN
dbms_snapshot.set_i_am_a_refresh(value => true);

FOR part_rec in fd_part_cursor LOOP
   v_sql_to_run := 'select    /*+ full(fd) parallel(fd,16) */ count(*)         '||
                     'from      fulfillment_demands partition ('||part_rec.partition_name||') fd '||
                     'where     exists (    select ''x'' from       shipment_requests sr '||
                                                'where  fd.fulfillment_reference_id = sr.request_reference_id and sr.warehouse_id = fd.warehouse_id)';
   execute immediate v_sql_to_run into rows_to_update;
   dbms_output.put_line('rows_to_update ='||rows_to_update);

   WHILE (rows_to_update > 0) LOOP

   v_sql_to_run := 'update    /*+ full(fd) parallel(fd,16) */  '||
                   'fulfillment_demands partition ('||part_rec.partition_name||') fd '||
                   'set partition_key=trunc(sysdate)+7 '||
                   'where exists (select ''x'' from shipment_requests sr '||
                                  'where fd.fulfillment_reference_id = sr.request_reference_id and sr.warehouse_id = fd.warehouse_id) '||
                                  'and rownum < '||upd_batch;
   execute immediate v_sql_to_run ;

        IF (SQL%ROWCOUNT = 0) THEN
            rows_to_update :=0;
        ELSE
            dbms_output.put_line('Updated ' || SQL%ROWCOUNT || ' rows from partition '||part_rec.partition_name);
            commit;
            dbms_output.put_line('Sleeping '||commit_sleep||' secs after commit ...');
            dbms_lock.sleep(commit_sleep);
        END IF;

  END LOOP; -- while loop

END LOOP; -- for loop

EXCEPTION
WHEN NO_DATA_FOUND THEN
   rows_to_update := 0;
END;    -- For Begin
/
