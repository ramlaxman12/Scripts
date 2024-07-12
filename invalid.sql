set linesi 190
col object_name format a40
select owner,object_name,object_type from dba_objects where status='INVALID' order by owner,object_type;
