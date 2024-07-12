set echo on feed on
@big-job
execute dbms_stats.gather_table_stats(- 
        tabname => 'BUYING_SCHEDULES', -
ownname 	=> 'BOOKER',- 
partname 	=> null,-				
estimate_percent => 100,-			
block_sample 	=> true,-				
method_opt 	=> 'FOR ALL INDEXED COLUMNS',-	
degree 		=> 3,-				
granularity 	=> 'default',-			
cascade 	=> true ,-				
stattab 	=> null,-				
statid 		=> null,- 
statown 	=> null) ; 

