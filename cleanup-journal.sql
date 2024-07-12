DECLARE
   Isclean BOOLEAN;
 BEGIN
     Isclean := FALSE;
 
     WHILE isclean=FALSE
      LOOP
              Isclean := DBMS_REPAIR.ONLINE_INDEX_CLEAN(DBMS_REPAIR.ALL_INDEX_ID, DBMS_REPAIR.LOCK_WAIT);
              DBMS_LOCK.SLEEP(10);
       END LOOP;
    EXCEPTION
      WHEN OTHERS THEN
         RAISE;
      END;
/
 
