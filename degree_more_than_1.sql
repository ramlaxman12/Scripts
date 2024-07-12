set pagesi 0
set linesi 190
col index_name format a35
select owner,index_name,degree from dba_indexes where degree not in ('0','1','DEFAULT')  order by degree,owner;
