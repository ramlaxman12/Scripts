set linesi 190
col name format a35
col value format a30
col description format a60
select NAME,VALUE,ISDEFAULT,ISSES_MODIFIABLE,ISSYS_MODIFIABLE,DESCRIPTION from v$parameter where lower(name) like lower('%&1%');
