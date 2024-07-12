select 'alter system kill session '||''''||sid||','||serial#||''''||' immediate ;' from v$session where module ='&module';
