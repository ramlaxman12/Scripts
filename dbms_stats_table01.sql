exec dbms_stats.gather_table_stats('&towner','&tname',method_opt =>'FOR ALL INDEXED COLUMNS');
