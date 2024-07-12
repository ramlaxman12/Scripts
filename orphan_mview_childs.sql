set linesi 200
col snapname format a40
col snapsite format a50
SELECT
   r.NAME snapname,
   snapid,
   NVL(r.snapshot_site, 'not registered') snapsite,
   snaptime
FROM  
   sys.slog$ s,
   dba_registered_snapshots r
WHERE 
   s.snapid=r.snapshot_id(+);
