set linesi 170
set pagesi 2000
select name,
           to_char(decode( unit,
                    'bytes', value/1024/1024,
                             value ),'999,999,999.9') value,
           decode( unit, 'bytes', 'mbytes', unit ) unit
    from v$pgastat;
