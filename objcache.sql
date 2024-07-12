set lines 150 pages 299
col object_name for a18
col partition_name for a27
col cachedblocks for 99999999
col cachepct for 99999999
select co.object_name object_name,
       nvl(co.subobject_name,'N/A') partition_name,
       co.cachedblocks, 100*(co.cachedblocks/seg.blocks) cachepct
from (
select owner, object_name ,
    subobject_name, object_type , sum(num_buf) cachedblocks
from
    dba_objects , x$kcboqh
where obj# = data_object_id
and   upper(object_name) =upper('&&table_name')
and   upper(owner)=upper('&&owner')
group by owner , object_name , subobject_name , object_type) co,
(select owner,segment_name,partition_name,blocks
  from dba_segments
  where upper(owner)=upper('&&owner') and upper(segment_name)=upper('&&table_name')) seg
where co.owner=seg.owner and co.object_name=seg.segment_name
and nvl(co.subobject_name,'ZZZ')=nvl(seg.partition_name,'ZZZ');
