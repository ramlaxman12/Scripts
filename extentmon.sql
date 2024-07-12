SELECT m.tablespace_name,
              SUM(TRUNC(NVL(f.bytes, 0)/m.max_next_extent)) free_extents
       FROM dba_free_space f,
            (SELECT tablespace_name,
                    MAX(TRUNC(next_extent*(1+pct_increase/100.0))) max_next_extent
             FROM dba_segments
             WHERE segment_type IN ('TABLE','INDEX','CLUSTER','ROLLBACK',
                                'CACHE','INDEX PARTITION','INDEX SUBPARTITION','LOB PARTITION','LOBINDEX',
                                'LOBSEGMENT','NESTED TABLE','TABLE PARTITION','TABLE SUBPARTITION')
               AND next_extent != 0
             GROUP by tablespace_name
            ) m
       WHERE f.tablespace_name (+) = m.tablespace_name
       GROUP BY m.tablespace_name ;
