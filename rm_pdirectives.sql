set linesi 190
col cpu_p1 format 9999
col cpu_p2 format 9999
col cpu_p3 format 9999
col cpu_p4 format 9999
col cpu_p5 format 9999
col cpu_p6 format 9999
col cpu_p7 format 9999
col cpu_p8 format 9999
col ACTIVE_SESS_POOL_P1 format a10
col status format a5
select PLAN,GROUP_OR_SUBPLAN,TYPE,CPU_P1,CPU_P2,CPU_P3,CPU_P4,CPU_P5,CPU_P6,CPU_P7,CPU_P8,STATUS,MANDATORY from DBA_RSRC_PLAN_DIRECTIVES;
