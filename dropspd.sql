EXEC DBMS_SPD.flush_sql_plan_directive;

 

 

BEGIN 
  FOR rec in (SELECT directive_id did FROM DBA_SQL_PLAN_DIRECTIVES)
  LOOP
    DBMS_SPD.DROP_SQL_PLAN_DIRECTIVE (  directive_id        => rec.did);
  END LOOP;
END;
/


