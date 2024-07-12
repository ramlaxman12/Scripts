  CREATE OR REPLACE FORCE VIEW VAS.SRW_INVENTORY_LEVEL_BY_O_TEST (WAREHOUSE_ID, INVENTORY_OWNER_GROUP_ID, INVENTORY_CONDITION_CODE, ASIN, ON_HAND_QUANTITY, BOUND_QUANTITY, COMMITTED_QUANTITY, ALLOCATED_QUANTITY, UNALLOCATED_CUSTOMER_DEMAND) AS
  SELECT warehouse_id,
inventory_owner_group_id,
inventory_condition_code,
asin,
SUM(on_hand_quantity) on_hand_quantity,
SUM(bound_quantity) bound_quantity,
SUM(committed_quantity) committed_quantity,
SUM(allocated_quantity) allocated_quantity,
SUM(unallocated_customer_demand) unallocated_customer_demand
--SUM(ready_quantity) ready_quantity,
--SUM(active_quantity) active_quantity
FROM (
SELECT ilbop_fc.warehouse_id warehouse_id,
inventory_owner_group_id,
inventory_condition_code,
asin,
on_hand_quantity,
bound_quantity,
allocated_quantity AS committed_quantity,
0 AS allocated_quantity,
0 AS unallocated_customer_demand
--0 AS active_quantity,
--0 AS ready_quantity
FROM booker.INV_LEVEL_BY_OWNER_PHYSICAL ilbop_fc
where not exists ( select 1
from asin_summing_skus ass
where ass.fcsku = ilbop_fc.asin)
UNION ALL
SELECT ilbop_fc.warehouse_id warehouse_id,
inventory_owner_group_id,
inventory_condition_code,
ass.asin,
on_hand_quantity,
bound_quantity,
allocated_quantity AS committed_quantity,
0 AS allocated_quantity,
0 AS unallocated_customer_demand
--0 AS active_quantity,
--0 AS ready_quantity
FROM booker.INV_LEVEL_BY_OWNER_PHYSICAL ilbop_fc,
asin_summing_skus ass
where ass.fcsku = ilbop_fc.asin
UNION ALL
SELECT warehouse_id,
inventory_owner_group_id,
inventory_condition_code,
asin,
0 AS on_hand_quantity,
0 AS bound_quantity,
0 AS committed_quantity,
allocated_quantity,
unallocated_customer_demand
--active_quantity ,
--ready_quantity
FROM BOOKER.ILBO_SRW_DC3
)
GROUP BY warehouse_id,
inventory_owner_group_id,
inventory_condition_code,
asin;

