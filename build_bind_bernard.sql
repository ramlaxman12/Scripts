set lines 32000 head off trimspool off pages 0
    break on fdate on report
   set trimspool on
select line from (
     select  decode(position, 1,
                                  '-------------------------------------' ||chr(10) ||
                                  '-- Date :'||to_char(LAST_CAPTURED,'YYYY-MM-DD HH24:MI:SS')||chr(10)  ||
                                  '-------------------------------------' ||chr(10)|| chr(10)
                                  || 'alter session set NLS_DATE_FORMAT=''YYYY-MM-DD HH24:MI:SS'' ;' || chr(10)
                               --   || 'alter session set NLS_TIMESTAMP_FORMAT=''YYYY-MM-DD HH24:MI:SS.FFFFFF'' ;' || chr(10)
                              , chr(10)
             )||
            'variable ' ||
             regexp_replace( name,':D*[[:digit:]]*','a')
             ||to_char(position) || ' '
            || case DATATYPE
                       -- varchar2
                 when  1   then 'varchar2(4000)' || chr(10) || 'Exec '||regexp_replace( name,':D*[[:digit:]]*',':a') ||
                                 to_char(position) || ':='''||  value_string || ''';'
                          -- number
                 when  2   then 'number'         || chr(10) || 'exec '||regexp_replace( name,':D*[[:digit:]]*',':a') ||
                                 to_char(position) || ':='  ||  value_string || ';'
                          -- date
                 when  12  then 'varchar2(30)'   || chr(10) || 'exec '|| regexp_replace( name,':D*[[:digit:]]*',':a') ||
                                to_char(position) || ':='''||
                                        decode( value_string, null,
                                                            to_char(anydata.accessdate(value_anydata),'YYYY-MM-DD HH24:MI:SS') )  || ''';'
                           -- char
                 when  96  then 'char(3072)'     || chr(10) || 'exec '||regexp_replace( name,':D*[[:digit:]]*',':a') ||
                                 to_char(position) || ':='''||  value_string || ''';'
                           -- timestamp
                 when  180 then 'varchar2(26)'   || chr(10) || 'exec '||regexp_replace( name,':D*[[:digit:]]*',':a') ||
                                 to_char(position) || ':='''||
                                         decode( value_string, null,
                                                            to_char(anydata.accessTimestamp(value_anydata),'YYYY-MM-DD HH24:MI:SS') ) || ''';'
                                                            --to_char(anydata.accessTimestamp(value_anydata),'YYYY-MM-DD HH24:MI:SS.FFFFFF') ) || ''';'
                           -- timestampTZ
                 when  181 then 'varchar2(26)'   || chr(10) || 'exec '||regexp_replace( name,':D*[[:digit:]]*',':a') ||
                                 to_char(position) || ':='''||
                                         decode( value_string, null,
                                                            to_char(anydata.accessTimestampTZ(value_anydata),'YYYY-MM-DD HH24:MI:SS') ) || ''';'
                                                            --to_char(anydata.accessTimestampTZ(value_anydata),'YYYY-MM-DD HH24:MI:SS.FFFFFF') ) || ''';'
                 when  112 then 'CLOB'           || chr(10) || 'exec '||regexp_replace( name,':D*[[:digit:]]*',':a') ||
                                  to_char(position) || ':='''||  value_string || ''';'
               else
                               'Varchar2(4000)'  || chr(10) || 'exec '|| regexp_replace( name,':D*[[:digit:]]*',':a') ||
                                  to_char(position) || ':='''||  value_string || ''';'
               end line
     from v$sql_bind_capture where sql_id = 'ffzq8p6rswt3y'  and child_number = '0'
order by last_captured,position, child_number, position )
union all
select  regexp_replace(line,'(:)D*([[:digit:]]*)','1a2')||chr(10)  ||'/' line from (
select  regexp_replace(
          max(sys_connect_by_path (sql_text,'{') ),
          '{','') line
from (
select
        piece,   sql_text
  from v$sqltext_with_newlines where  sql_id='ffzq8p6rswt3y'
order by 1
)
start with piece=0
connect by  piece  = prior piece + 1
)
/