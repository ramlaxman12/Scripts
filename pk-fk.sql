accept tab_owner prompt 'tab_owner :' 
accept tab_name  prompt 'tab_name  :' 

prompt -- PK TO FK COLUMN MAPPING --;
col fktab       format a30      head 'FK|Table Name'
col fkcons      format a30      head 'FK|Const Name'
col fkcol       format a29      head 'FK|Column Name'
col pktab       format a18      head 'PK|Table Name' trunc
col pkcons      format a29      head 'PK|Const Name'
col pkpos       noprint
col pkcol       format a30      head 'PK|Col Name'

break on pktab on pkcons on fktab on fkcons

SELECT
         a.table_name           pktab
        ,a.constraint_name      pkcons
        ,b.table_name           fktab
        ,b.constraint_name      fkcons
        --,d.position           fkpos
        ,d.column_name          fkcol
FROM     dba_constraints        a
        ,dba_constraints        b
        ,dba_cons_columns       d
WHERE    b.constraint_type      = 'R'
  AND    a.constraint_type      = 'P'
  AND    b.r_owner (+)          = a.owner
  AND    b.r_constraint_name (+)        = a.constraint_name
  AND    b.constraint_name      = d.constraint_name
  AND    b.owner                = d.owner
  AND    b.table_name           = d.table_name
  AND    a.owner                = upper(nvl('&&tab_owner',user))
  AND    a.table_name           = upper('&&tab_name')
ORDER BY a.table_name
        ,a.constraint_name
        ,b.table_name
        ,b.constraint_name
        ,d.position
;

prompt ;
prompt ;
prompt -- FK TO PK COLUMN MAPPING --;
col fktab       format a18      head 'FK|Table Name' trunc
col fkcons      format a30      head 'FK|Cons Name'
col pktab       format a30      head 'PK|Table Name'
col pkcons      format a29      head 'PK|Cons Name'
col pkcol       format a29      head 'PK|Col Name'

break on fktab on fkcons on pktab on pkcons

SELECT
         fk.table_name          fktab
        ,fk.constraint_name     fkcons
        ,pk.table_name          pktab
        ,pk.constraint_name     pkcons
        ,pkc.column_name        pkcol
FROM     dba_constraints pk
        ,dba_constraints fk
        ,dba_cons_columns pkc
WHERE    fk.r_constraint_name   = pk.constraint_name
  AND    fk.r_owner             = pk.owner
  AND    pk.constraint_type     = 'P'
  AND    fk.constraint_type     = 'R'
  AND    pk.constraint_name     = pkc.constraint_name
  AND    pk.owner               = pkc.owner
  AND    fk.owner               = upper(nvl('&&tab_owner',user))
  AND    fk.table_name          = upper('&tab_name')
ORDER BY fk.constraint_name
        ,pk.table_name
        ,pk.constraint_name
        ,pkc.position
;

undef tab_owner
undef tab_name
