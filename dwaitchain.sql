col "%This" for a10
col SECONDS for 9999999999999
col WAIT_CHAIN for a99
set lines 400 pages 299

WITH
bclass AS (SELECT class, ROWNUM r from v$waitstat),
ash AS (SELECT /*+ QB_NAME(ash) LEADING(a) USE_HASH(u) SWAP_JOIN_INPUTS(u) */
            a.*
          , u.username
          , CASE WHEN a.session_type = 'BACKGROUND' OR REGEXP_LIKE(a.program, '.*\([PJ]\d+\)') THEN
              REGEXP_REPLACE(SUBSTR(a.program,INSTR(a.program,'(')), '\d', 'n')
            ELSE
                '('||REGEXP_REPLACE(REGEXP_REPLACE(a.program, '(.*)@(.*)(\(.*\))', '\1'), '\d', 'n')||')'
            END || ' ' program2
          , NVL(a.event||CASE WHEN a.event IN ('buffer busy waits', 'gc buffer busy', 'gc buffer busy acquire', 'gc buffer busy release')
                              THEN ' ['||(SELECT class FROM bclass WHERE r = a.p3)||']' ELSE null END,'ON CPU')
                       || ' ' event2
          , TO_CHAR(CASE WHEN session_state = 'WAITING' THEN p1 ELSE null END, '0XXXXXXXXXXXXXXX') p1hex
          , TO_CHAR(CASE WHEN session_state = 'WAITING' THEN p2 ELSE null END, '0XXXXXXXXXXXXXXX') p2hex
          , TO_CHAR(CASE WHEN session_state = 'WAITING' THEN p3 ELSE null END, '0XXXXXXXXXXXXXXX') p3hex
        FROM
            dba_hist_active_sess_history a
          , dba_users u
        WHERE
            a.user_id = u.user_id (+)
        AND sample_time BETWEEN timestamp'2022-04-27 01:38:00' AND timestamp'2022-04-27 01:50:00'
    ),
ash_samples AS (SELECT DISTINCT sample_id FROM ash),
ash_data AS (SELECT /*+ MATERIALIZE */ * FROM ash),
chains AS (
    SELECT
        sample_time ts
      , level lvl
      , session_id sid
      --, SYS_CONNECT_BY_PATH(username||':'||':'||program2||':'||sql_id||':'||event2, ' -> ')||CASE WHEN CONNECT_BY_ISLEAF = 1 THEN '('||d.session_id||')' ELSE NULL END path
      , REPLACE(SYS_CONNECT_BY_PATH(username||':'||program2||event2, '->'), '->', ' -> ') path -- there's a reason why I'm doing this (ORA-30004 :)
      , CASE WHEN CONNECT_BY_ISLEAF = 1 THEN d.session_id ELSE NULL END sids
      , CONNECT_BY_ISLEAF isleaf
      , CONNECT_BY_ISCYCLE iscycle
      , d.*
    FROM
        ash_samples s
      , ash_data d
    WHERE
        s.sample_id = d.sample_id
    AND d.sample_time BETWEEN timestamp'2022-04-27 01:38:00' AND timestamp'2022-04-27 01:50:00'
    CONNECT BY NOCYCLE
        (    PRIOR d.blocking_session = d.session_id
         AND PRIOR s.sample_id = d.sample_id
         AND PRIOR d.blocking_inst_id = d.instance_number)
    START WITH session_type='FOREGROUND'
)
SELECT
    LPAD(ROUND(RATIO_TO_REPORT(COUNT(*)) OVER () * 100)||'%',5,' ') "%This"
  , COUNT(*) * 10 seconds
  , path wait_chain
  -- , COUNT(DISTINCT sids)
  -- , MIN(sids)
  -- , MAX(sids)
FROM
    chains
WHERE
    isleaf = 1
GROUP BY
    username||':'||program2||event2
  , path
ORDER BY
    COUNT(*) DESC;

