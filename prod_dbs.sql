set pagesi 1000
select lower(database) from m2_databases where system_group in (select system_group from m2_system_groups start with PARENT_SYSTEM_GROUP = 'SCOS-CS' 
connect by prior SYSTEM_GROUP = PARENT_SYSTEM_GROUP) and system_group not in ('SSOF','SSOF-TEST','CBADB','CBADB-TEST')  and system_group not  like '%TEST' order by 1;
