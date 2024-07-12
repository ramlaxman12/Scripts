undef owner
undef idxname
--PROCEDURE GATHER_INDEX_STATS
-- Argument Name                  Type                    In/Out Default?
-- ------------------------------ ----------------------- ------ --------
-- OWNNAME                        VARCHAR2                IN
-- INDNAME                        VARCHAR2                IN
-- PARTNAME                       VARCHAR2                IN     DEFAULT
-- ESTIMATE_PERCENT               NUMBER                  IN     DEFAULT
-- STATTAB                        VARCHAR2                IN     DEFAULT
-- STATID                         VARCHAR2                IN     DEFAULT
-- STATOWN                        VARCHAR2                IN     DEFAULT
-- DEGREE                         NUMBER                  IN     DEFAULT
-- GRANULARITY                    VARCHAR2                IN     DEFAULT
-- NO_INVALIDATE                  BOOLEAN                 IN     DEFAULT
-- STATTYPE                       VARCHAR2                IN     DEFAULT
-- FORCE                          BOOLEAN                 IN     DEFAULT

exec dbms_stats.GATHER_INDEX_STATS(OWNNAME => '&&owner',INDNAME => '&&idxname',ESTIMATE_PERCENT => 25,DEGREE => 5);
