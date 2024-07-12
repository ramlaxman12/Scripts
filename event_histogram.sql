set pagesi 40
set linesi 190
SELECT
   event,
   wait_time_milli,
   wait_count
FROM
   v$event_histogram
WHERE
   event  like '%&event%'
ORDER BY 1,2;
