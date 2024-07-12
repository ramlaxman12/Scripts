@/home/sreekanc/scripts/big_job.sql

set serveroutput on
alter table booker.fulfillment_demands modify partition FULFILLMENT_DEMANDS_20120818 LOB (fulfillment_doc) (allocate extent (size 5G));
exec dbms_lock.sleep(20);
alter table booker.fulfillment_demands modify partition FULFILLMENT_DEMANDS_20120818 LOB (fulfillment_doc) (allocate extent (size 5G));
exec dbms_lock.sleep(20);
alter table booker.fulfillment_demands modify partition FULFILLMENT_DEMANDS_20120818 LOB (fulfillment_doc) (allocate extent (size 5G));
exec dbms_lock.sleep(20);
alter table booker.fulfillment_demands modify partition FULFILLMENT_DEMANDS_20120818 LOB (fulfillment_doc) (allocate extent (size 5G));
exec dbms_lock.sleep(20);
alter table booker.fulfillment_demands modify partition FULFILLMENT_DEMANDS_20120818 LOB (fulfillment_doc) (allocate extent (size 5G));
