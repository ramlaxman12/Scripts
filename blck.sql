with lk as (select blocking_instance||'.'||blocking_session blocker, inst_id||'.'||sid waiter 
            from gv$session where blocking_instance is not null and blocking_session is not null)
select lpad('  ',2*(level-1))||waiter lock_tree from
 (select * from lk
  union all
  select distinct 'root', blocker from lk
  where blocker not in (select waiter from lk))
connect by prior waiter=blocker start with blocker='root';