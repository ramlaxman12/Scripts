@par_job
exec dbms_stats.gather_table_stats('BOOKER','IP_VENDOR_SCHEDULES',method_opt =>'FOR ALL INDEXED COLUMNS');
