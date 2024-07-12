set linesi 200
column owner format a30
column segment_name format a40
column segment_type format a40
select owner, segment_name, segment_type from dba_extents where file_id = &P1 and &P2 between block_id and block_id + blocks -1;
