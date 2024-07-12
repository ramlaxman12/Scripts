set linesi 190
col priv_used format a80
select PRIV_USED,count(*) from DBA_AUDIT_TRAIL group by priv_used order by 2;
