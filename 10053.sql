oradebug setospid &SPID;
oradebug event 10053 trace name context forever, level 12;
oradebug tracefile_name


	
Here are instructions for trace

SQL> alter session set max_dump_file_size = UNLIMITED;
SQL> alter session set timed_statistics = true;
SQL> alter session set statistics_level=all;
SQL> alter session set tracefile_identifier = '10046_trace_file';
SQL> alter session set events '10046 trace name context forever, level 12';
SQL> alter session set events '10053 trace name context forever, level 1';

--------------- problme query to execute here


since the execution takes forever you can abort it using CTRL+C after aprox 10 mins, DO NOT KILL THE SESSION

SQL> select 'close cursor' from dual; <- it's very important to execute this step in order to dump the rowsource information

Please upload the resulting trace which will contain the string '10046'in the filename