select KGLNAOBJ, KGLNAOWN, KGLHDNSP,  KGLOBTYP, KGLOBT23, KGLOBT24
    from x$kglob where KGLOBT23 > 1000000 or KGLOBT24 > 1000000
   order by  KGLOBT24;
