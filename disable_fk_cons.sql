set pagesi 0
set linesi 190
select 'alter table '||owner||'.'||TABLE_NAME||' disable constraint '||CONSTRAINT_NAME||';' from dba_constraints where CONSTRAINT_TYPE='R' and owner='BOOKER';
