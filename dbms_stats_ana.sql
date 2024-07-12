set echo on feed on
@big-job
execute dbms_stats.gather_table_stats(- 
        tabname => 'ASSIGNMENTS', -
ownname 	=> 'BOOKER',- 
partname 	=> null,-				
estimate_percent => 80,-			
block_sample 	=> true,-				
method_opt 	=> 'FOR ALL INDEXED COLUMNS',-	
degree 		=> 5,-				
granularity 	=> 'default',-			
cascade 	=> false)
;

