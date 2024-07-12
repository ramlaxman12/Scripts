--PROCEDURE OBJECT_SPACE_USAGE
-- Argument Name                  Type                    In/Out Default?
-- ------------------------------ ----------------------- ------ --------
-- OBJECT_OWNER                   VARCHAR2                IN
-- OBJECT_NAME                    VARCHAR2                IN
-- OBJECT_TYPE                    VARCHAR2                IN
-- SAMPLE_CONTROL                 NUMBER                  IN
-- SPACE_USED                     NUMBER                  OUT
-- SPACE_ALLOCATED                NUMBER                  OUT
-- CHAIN_PCENT                    NUMBER                  OUT
-- PARTITION_NAME                 VARCHAR2                IN     DEFAULT
-- PRESERVE_RESULT                BOOLEAN                 IN     DEFAULT
-- TIMEOUT_SECONDS                NUMBER                  IN     DEFAULT

undef oowner
undef oname
undef otype
set serveroutput on

DECLARE
 spc_used NUMBER;
 spc_alloc NUMBER;
 chain_pct NUMBER;
BEGIN
  dbms_space.object_space_usage(upper('&&oowner'),upper('&&oname'), upper('&&otype'), 20, spc_used, spc_alloc, chain_pct);

  dbms_output.put_line('Space   Used: ' || TO_CHAR(spc_used));
  dbms_output.put_line('Space  Alloc: ' || TO_CHAR(spc_alloc));
  dbms_output.put_line('Chain    Pct: ' || TO_CHAR(chain_pct));
END;
/
