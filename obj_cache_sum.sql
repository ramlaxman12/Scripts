--desc v$db_object_cache
-- Name                                                                                                                          Null?    Type
-- ----------------------------------------------------------------------------------------------------------------------------- -------- ------------------------------------------------------------------------------------
-- OWNER                                                                                                                                  VARCHAR2(64)
-- NAME                                                                                                                                   VARCHAR2(1000)
-- DB_LINK                                                                                                                                VARCHAR2(64)
-- NAMESPACE                                                                                                                              VARCHAR2(64)
-- TYPE                                                                                                                                   VARCHAR2(64)
-- SHARABLE_MEM                                                                                                                           NUMBER
-- LOADS                                                                                                                                  NUMBER
-- EXECUTIONS                                                                                                                             NUMBER
-- LOCKS                                                                                                                                  NUMBER
-- PINS                                                                                                                                   NUMBER
-- KEPT                                                                                                                                   VARCHAR2(3)
-- CHILD_LATCH                                                                                                                            NUMBER
-- INVALIDATIONS                                                                                                                          NUMBER
-- HASH_VALUE                                                                                                                             NUMBER
-- LOCK_MODE                                                                                                                              VARCHAR2(9)
-- PIN_MODE                                                                                                                               VARCHAR2(9)
-- STATUS                                                                                                                                 VARCHAR2(19)
-- TIMESTAMP                                                                                                                              VARCHAR2(57)
-- PREVIOUS_TIMESTAMP                                                                                                                     VARCHAR2(57)
-- LOCKED_TOTAL                                                                                                                           NUMBER
-- PINNED_TOTAL                                                                                                                           NUMBER
col shmem	format 999,999.99	head 'Share|Mem MB'
select	 namespace
	,sum(SHARABLE_MEM)/(1024*1024)	shmem
from 	 v$db_object_cache
group by namespace
having	 sum(sharable_mem)	>0
order by shmem
;
