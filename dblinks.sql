set linesi 190
set heading on
set pagesi 0
col owner format a30
col db_link format a30
col host format a30
col username format a30
select owner,db_link,username,host,created from dba_db_links order by owner;
