SELECT  COUNT(*), ship_request_status_type_id , warehouse_id
FROM    shipment_requests
WHERE   ship_request_status_type_id IN (1, 3, 5)
AND     next_examination_time_utc < CAST( sys_extract_utc( systimestamp )
        AS DATE ) - 2/24 GROUP BY ship_request_status_type_id , warehouse_id;
