set linesi 190
set pagesi 100
col name format a35
col snapshot_site format a30
break on owner on name
select owner,name,SNAPSHOT_SITE,CAN_USE_LOG,REFRESH_METHOD from dba_registered_snapshots order by owner,name,snapshot_site;
