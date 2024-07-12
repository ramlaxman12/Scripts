set linesi 190
col mowner format a20
col master format a40
select mowner,master,youngest,last_purge_date from sys.mlog$;
