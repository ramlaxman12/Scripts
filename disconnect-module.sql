accept module_name prompt 'Enter the name of the module to disconnect: '

declare
  ddl varchar2(512);
begin
  for sess_rec in (
    select sid, serial# from v$session where module = '&module_name'
  )
  loop
    ddl := 'alter system disconnect session '''
           ||sess_rec.sid||','||sess_rec.serial#
           ||''' immediate';
    dbms_output.put_line(ddl);
    begin
      execute immediate ddl;
    exception
      when others then dbms_output.put_line('ERROR: '||SQLERRM);
    end;
  end loop;
end;
/
