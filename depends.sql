set linesi 190
set pagesi 0
select owner,name,type from 
 dba_dependencies 
where lower(referenced_name)=lower('&object_name') and lower(referenced_owner)=lower(nvl('&object_owner','booker')) order by type,owner;
