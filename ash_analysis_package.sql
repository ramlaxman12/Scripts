Rem
Rem $Header: emdb/source/oracle/sysman/emdrep/sql/db/latest/instance/omc_ashv_pkg.sql /main/4 2019/01/03 19:41:39 bram Exp $
Rem
Rem omc_ashv_pkg.sql
Rem
Rem Copyright (c) 2017, 2019, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      omc_ashv_pkg.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: emdb/source/oracle/sysman/emdrep/sql/db/latest/instance/omc_ashv_pkg.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    bram        09/21/17 - Created
Rem

/* -------------------------------------------------------------------
   OMC_ASH_VIEWER PACKAGE
 * ------------------------------------------------------------------- */
-- Copyright (c) 2018, 2019, Oracle and/or its affiliates. All rights reserved.
CREATE OR REPLACE PACKAGE omc_ash_viewer AUTHID CURRENT_USER IS
 
  TYPE FilterTableType IS TABLE OF varchar2(32767) INDEX BY varchar2(30);

  TYPE AddInfoType IS RECORD (
    idNameSQL          varchar2(32767)
    -- SQL to resolve the id - name mappings using dictionary tables like
    -- dba_users, dba_objects etc.
  , id2name_dynamic    varchar2(32767)

    -- SQL to resolve the id-name mappings using AWR tables DBA_HIST_*
  , id2name_awr        varchar2(32767)

    -- SQL to resolve the id-name mappings using v$views or other tables.
  , id2name_const      varchar2(32767)

    -- SQL to generate the XML from the id-name mappings.
  , idNameXML          varchar2(32767)
  );

  TYPE DimType IS RECORD (
    -- Dimension name
    name                varchar2(30)
  , enabled             boolean
    -- this defines how to construct the select clause for this dimension
    -- e.g., sql_id = sql_id
  , selectStr           varchar2(32767)
  , mapSQL              varchar2(32767)
  , selectStrMap        varchar2(32767)
  , isDimMasked         boolean
  , fromClause          varchar2(32767)
  , mapXML              varchar2(32767)
  , whereClause         varchar2(32767)
  , addInfo             AddInfoType
  , is_pdb_specific     boolean
  , category            varchar2(128)
  );

  TYPE DimTableType IS TABLE OF DimType INDEX BY varchar2(30);

  TYPE BindType IS RECORD (
    name VARCHAR2(100)
  , value VARCHAR2(4000)
  );

  TYPE BindArrayType IS VARRAY(100) OF BindType;
  
  TYPE QueryBlockArrayType IS VARRAY(200) OF VARCHAR2(4000);

  TYPE ContextType IS RECORD (
  -- base information about RDBMS
    is_local          BOOLEAN
  , is_cdb_root       BOOLEAN
  , local_is_pdb      BOOLEAN
  , local_dbid        NUMBER
  , local_version     VARCHAR(30)
  , local_comp_ver    VARCHAR(30)
  , local_conid       NUMBER
  , local_condbid     NUMBER
  , underscores       BOOLEAN
  -- time period and instances
  , beginTimeUTC      DATE
  , endTimeUTC        DATE
  , instance_number   NUMBER
  -- bucketing
  , bucketCount       NUMBER
  , bucketInterval    NUMBER
  , lastBucketSize    NUMBER
  -- Extra memory filters
  , memEnable         BOOLEAN
  , memTZ             NUMBER
  , memSizeDays       NUMBER
  -- Extra on disk filters
  , diskEnable        BOOLEAN
  , disk_comp_ver     VARCHAR(30)
  , dbid              NUMBER
  , beginSnapID       NUMBER
  , endSnapID         NUMBER
  , awrTablePrefix    VARCHAR(20)
  , diskEndTimeUTC    DATE
  , diskTZ            NUMBER
  -- Diagnosability
  , show_sql          BOOLEAN
  , verbose_xml       BOOLEAN
  , error_xml         XMLTYPE
  , diag_start_time   TIMESTAMP
  , diag_context_secs NUMBER
  , diag_picker_secs  NUMBER
  , diag_data_secs    NUMBER
  , diag_cpuinfo_secs NUMBER
  -- Data query only
  , include_bg        BOOLEAN
  , minimize_cost     BOOLEAN
  , dimTable          DimTableType
  , memFilterPredicate VARCHAR2(32767)
  , diskFilterPredicate VARCHAR2(32767)
  , gvFilterPredicate VARCHAR2(32767)
  , sample_ratio      number
  , est_row_count     number
  , exp_row_count     number
  , activityLineXML   XMLTYPE
  , cpuCount          number
  , cpuCoreCount      number
  -- Query and Binds
  , query             QueryBlockArrayType
  , use_utc_binds     BOOLEAN
  , binds             BindArrayType
  );

  REPORT_INTERNAL_VERSION CONSTANT VARCHAR2(64) := '37';

  -- date format to be used for communications with package.
  OMC_TIME_FORMAT CONSTANT VARCHAR2(30) := 'MM/DD/YYYY HH24:MI:SS';

  -- error ratio to be acceptable for not mixing in-memory with on disk.
  -- 0.9 means that if at least 0.9 of the requeted time period is covered by
  -- one data source, we are allowed to only use that data source.
  OMC_ALLOWED_ERR_RATIO CONSTANT NUMBER := 0.9;

  -- default number of buckets
  OMC_DEF_BUCKETS CONSTANT NUMBER := 120;

  -- default max number of rows
  OMC_DEF_ROWS_PER_BUCKET CONSTANT NUMBER := 20;

  -- default REAL TIME min bucket size in seconds
  OMC_DEF_RT_MIN_BUCKET_SIZE CONSTANT NUMBER := 10;

  -- default Historical min bucket size in seconds
  OMC_DEF_HIST_MIN_BUCKET_SIZE CONSTANT NUMBER := 10;

  -- length of SQL text to fetch
  OMC_DEF_SQLTEXT_LEN CONSTANT NUMBER := 200;

  -- database version constants
  VER_12_2 CONSTANT VARCHAR2(12) := '1202000000';
  VER_12_1_2 CONSTANT VARCHAR2(12) := '1201000200';
  VER_12_1 CONSTANT VARCHAR2(12) := '1201000000';
  VER_12   CONSTANT VARCHAR2(12) := '1200000000';
  VER_11_MIN CONSTANT VARCHAR2(12) := '1102000200';

  TOP_ADD_INFO_COUNT      CONSTANT BINARY_INTEGER := 20;
  MAX_INFO_TIME_LIMIT     CONSTANT BINARY_INTEGER := 2;

  -- menu categories --
  -- when you add a new category here, make sure to visit the function
  -- generate_menu_xml and add the category there.
  RSRC_CONS_CAT           CONSTANT VARCHAR2(128) := 'resource_consumption_cat';
  SESS_ID_CAT             CONSTANT VARCHAR2(128) := 'session_identifiers_cat';
  SESS_ATTR_CAT           CONSTANT VARCHAR2(128) := 'session_attributes_cat';
  SQL_CAT                 CONSTANT VARCHAR2(128) := 'sql_cat';
  PLSQL_CAT               CONSTANT VARCHAR2(128) := 'pl_sql_cat';
  TARGET_CAT              CONSTANT VARCHAR2(128) := 'target_category';


  -- -------------------------------------------------------------------------
  --                      error number constants
  -- -------------------------------------------------------------------------
  ERR_DIMNAME_TOO_LONG CONSTANT NUMBER := -13720;
  ERR_DIMNAME_INVALID  CONSTANT NUMBER := -13721;

  -- str_to_ascii converts a string in the DB language and character set to 
  -- ASCII8 that is safe to use in XML and XMLCDATA elements. Special 
  -- characters are masked based on UTF16 standard of \xxxx using asciistr 
  -- SQL function.
  FUNCTION str_to_ascii(s IN VARCHAR) RETURN VARCHAR;

  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  -- fetch_sqltext_local and fetch_sqltext_awr
  --   Returns the text of a SQL (if found) 
  -- local looks at v$sql (not gv$) and then AWR.
  -- awr looks at AWR data
  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  FUNCTION fetch_sqltext_local(p_sqlid IN VARCHAR, p_dbid IN NUMBER, 
                               p_time_limit IN VARCHAR)
  RETURN   VARCHAR;

  FUNCTION fetch_sqltext_awr(p_sqlid IN VARCHAR, p_dbid IN NUMBER, 
                             p_is_pdb IN VARCHAR, p_time_limit IN VARCHAR)
  RETURN   VARCHAR;

  FUNCTION fetch_obj_name_local(p_obj_id IN NUMBER, p_dbid IN NUMBER,
                                p_con_dbid IN NUMBER, p_time_limit IN VARCHAR)
  RETURN   VARCHAR;

  FUNCTION fetch_obj_name_awr(p_obj_id IN NUMBER, p_dbid IN NUMBER, 
                              p_con_dbid IN NUMBER, p_is_pdb IN VARCHAR,
                              p_time_limit IN VARCHAR)
  RETURN   VARCHAR;

  FUNCTION fetch_procedure_name(p_obj_id IN NUMBER, p_subobj_id IN NUMBER,
                                p_con_dbid IN NUMBER, p_time_limit IN VARCHAR)
  RETURN VARCHAR;

  FUNCTION fetch_user_name(p_user_id IN NUMBER, p_con_dbid IN NUMBER,
                           p_time_limit IN VARCHAR)
  RETURN VARCHAR;

  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  -- getVersion
  --   Returns the version of the package
  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  FUNCTION getVersion RETURN VARCHAR;

  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  -- getData
  --   Single API for all other public functions in this package.
  --  "data_type"
  --     specifies which type of API is to be used. accepted values are:
  --     "data" for ASH data
  --     "timepicker" for the Time Picker graph
  --     "histogram" for a filtered time picker.
  --     If an invalid value is given, ORA-20001 is raised as an error.
  --  "time_type"
  --     specifies how the time period is to be interpreted.
  --     "realtime" for all Real Time interfaces (from some time in the past to NOW)
  --     "incremental" for an increment over real time (bucket size must be defined)
  --     "historical" for a longer time period or a time period in the past (two time stamps)
  --     If an invalid value is given, ORA-20002 is raised as an error.
  --  "filter_list"
  --     is the filter used in the same way as the original package
  --  "args"
  --     contains the rest of the arguments in XML format.
  --     The xml format is as follows (example containing all valid arguments)
  --  
  --    <args>
  --       <dbid>87658765</dbid>
  --       <instance_number>1</instance_number>
  --       <time_since_sec>3600</time_since_sec>
  --       <begin_time_utc>07/23/2018 10:20:00</begin_time_utc>
  --       <end_time_utc>07/24/2018 08:30:00</end_time_utc>
  --       <bucket_size>30</bucket_size>
  --       <show_sql>n</show_sql>
  --       <verbose_xml>n</verbose_xml>
  --       <include_bg>n</include_bg>
  --       <minimize_cost>n</minimize_cost>
  --    </args>
  --  
  --     Arguments that are not needed or that you wish to use the default values for,
  --     do not need to be specified in the XML doc.
  --     
  --     CPU info is now included in all API calls.    
  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  FUNCTION getData(data_type   VARCHAR2,
                   time_type   VARCHAR2,
                   filter_list VARCHAR2,
                   args        VARCHAR2
  ) RETURN XMLTYPE;

  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  -- getCPUInfo
  --   Returns information about availbale CPUs in XML format at a single 
  --   point in time.
  --    - dbid : specifies which db to look for, default (NULL) is DB we are
  --             conncted to.
  --    - observationTime : approximate time in which to look for data.
  --             default (NULL) is the latest possible data available 
  --             (NOW if possible).
  -- If instance_number is NULL it means all instances. Otherwise, fetch 
  --  only data for the specified instance number.
  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  FUNCTION getCPUInfo(dbid IN NUMBER := NULL,
                      observationTime IN VARCHAR := NULL,
                      instance_number IN NUMBER := NULL)
  RETURN XMLTYPE;

  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  -- getTimePickerRealTime
  --   Returns the time picker data for Real Time usage in XML format
  --   Time period is from NOW-time_since_sec to NOW. 
  --   The default time period is the last hour. 
  -- data is for entire database (all instances) we ara currently connected to
  -- ,foreground only, and in case we connect to a PDB - limited to that PDB.
  -- If instance_number is NULL it means all instances. Otherwise, fetch 
  --  only data for the specified instance number.
  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  FUNCTION getTimePickerRealTime(
      time_since_sec IN NUMBER := 3600
    , show_sql       IN VARCHAR2 := 'n'
    , verbose_xml    IN VARCHAR2 := 'n'
    , instance_number IN NUMBER := NULL)
  RETURN XMLTYPE;

  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  -- incrementTimePicker
  --   Returns the time picker data for Real Time usage in XML format
  --   This function is used to get incremental data after the initial load.
  --   Incremental use case is only for Real Time.
  --   Time period is from begin_time_utc to NOW.
  --   There is no default time period. 
  --   The time is bucketized using bucket_size (in seconds). 
  --   The bucket boundaries are: 
  --     begin_time_utc, begin_time_utc+bucket_size, 
  --     begin_time_utc+2*bucket_size etc.
  -- If instance_number is NULL it means all instances. Otherwise, fetch 
  --  only data for the specified instance number.
  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  FUNCTION incrementTimePicker(
      begin_time_utc IN VARCHAR2 
    , bucket_size    IN NUMBER 
    , show_sql       IN VARCHAR2 := 'n'
    , verbose_xml    IN VARCHAR2 := 'n'
    , instance_number IN NUMBER := NULL)
  RETURN XMLTYPE;

  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  -- getTimePickerHistorical
  --   Returns the time picker data for historical in an XML format
  --   dbid determines which RDBMS to look for, default is the one we are
  --     connected to.
  --   Time period is one of the following
  --     a) From begin_time_utc to end_time_utc if both are specified.
  --     b) From NOW-time_since_sec to NOW (default is 24 hours)
  -- If instance_number is NULL it means all instances. Otherwise, fetch 
  --  only data for the specified instance number.
  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  FUNCTION getTimePickerHistorical(
      dbid           IN NUMBER := NULL
    , begin_time_utc IN VARCHAR2 := NULL
    , end_time_utc   IN VARCHAR2 := NULL
    , time_since_sec IN NUMBER := 86400
    , show_sql       IN VARCHAR2 := 'n'
    , verbose_xml    IN VARCHAR2 := 'n'
    , instance_number IN NUMBER := NULL)
  RETURN XMLTYPE;

  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  -- getHistogramRealTime
  --   Returns the ASH histogram for Real Time Usage in an XML format
  --   Time period is from NOW-time_since_sec to NOW (default is one hour)
  --   The data can be filtered using the filter list.
  -- data is for entire database (all instances) we ara currently connected to
  -- ,foreground only, and in case we connect to a PDB - limited to that PDB.
  -- If instance_number is NULL it means all instances. Otherwise, fetch 
  --  only data for the specified instance number.
  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  FUNCTION getHistogramRealTime(
      filter_list     IN VARCHAR2 := NULL
    , time_since_sec  IN NUMBER := 3600
    , show_sql        IN VARCHAR2 := 'n'
    , verbose_xml     IN VARCHAR2 := 'n'
    , include_bg      IN VARCHAR2 := 'n'
    , instance_number IN NUMBER := NULL)
  RETURN XMLTYPE;

  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  -- incrementHistogram
  --   Returns the ASH histogram for Real Time usage in XML format
  --   This function is used to get incremental data after the initial load.
  --   Incremental use case is only for Real Time.
  --   Time period is from begin_time_utc to NOW.
  --   There is no default time period. 
  --   The time is bucketized using bucket_size (in seconds). 
  --   The bucket boundaries are: 
  --     begin_time_utc, begin_time_utc+bucket_size, 
  --     begin_time_utc+2*bucket_size etc.
  --   The data can be filtered using the filter list.
  -- If instance_number is NULL it means all instances. Otherwise, fetch 
  --  only data for the specified instance number.
  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  FUNCTION incrementHistogram(
      filter_list    IN VARCHAR2 := NULL
    , begin_time_utc IN VARCHAR2
    , bucket_size    IN NUMBER
    , show_sql       IN VARCHAR2 := 'n'
    , verbose_xml    IN VARCHAR2 := 'n'
    , include_bg      IN VARCHAR2 := 'n'
    , instance_number IN NUMBER := NULL)
  RETURN XMLTYPE;

  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  -- getHistogramHistorical
  --   Returns the ASH histogram for historical usage in an XML format
  --   dbid determines which RDBMS to look for, default is the one we are
  --     connected to.
  --   Time period is one of the following
  --     a) From begin_time_utc to end_time_utc if both are specified.
  --     b) From NOW-time_since_sec to NOW (default is 24 hours)
  --   The data can be filtered using the filter list.
  -- If instance_number is NULL it means all instances. Otherwise, fetch 
  --  only data for the specified instance number.
  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  FUNCTION getHistogramHistorical(
      dbid            IN NUMBER := NULL
    , filter_list     IN VARCHAR2 := NULL
    , begin_time_utc  IN VARCHAR2 := NULL
    , end_time_utc    IN VARCHAR2 := NULL
    , time_since_sec  IN NUMBER := 86400
    , show_sql        IN VARCHAR2 := 'n'
    , verbose_xml     IN VARCHAR2 := 'n'
    , include_bg      IN VARCHAR2 := 'n'
    , instance_number IN NUMBER := NULL)
  RETURN XMLTYPE;

  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  -- getDataRealTime
  --   Returns the ASH data for Real Time Usage in an XML format
  --   Time period is from NOW-time_since_sec to NOW (default is one hour)
  --   The data can be filtered using the filter list.
  -- data is for entire database (all instances) we ara currently connected to
  -- ,foreground only, and in case we connect to a PDB - limited to that PDB.
  -- If instance_number is NULL it means all instances. Otherwise, fetch 
  --  only data for the specified instance number.
  -- Minimize_cost: If set to 'y', 
  --                a. the time budget for additional information is 0.
  --                b. on disk data is disabled
  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  FUNCTION getDataRealTime(
      filter_list     IN VARCHAR2 := NULL
    , time_since_sec  IN NUMBER := 3600
    , show_sql        IN VARCHAR2 := 'n'
    , verbose_xml     IN VARCHAR2 := 'n'
    , include_bg      IN VARCHAR2 := 'n'
    , instance_number IN NUMBER := NULL
    , minimize_cost   IN VARCHAR2 := 'n')
  RETURN XMLTYPE;

  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  -- incrementData
  --   Returns the ASH data for Real Time usage in XML format
  --   This function is used to get incremental data after the initial load.
  --   Incremental use case is only for Real Time.
  --   Time period is from begin_time_utc to NOW.
  --   There is no default time period. 
  --   The time is bucketized using bucket_size (in seconds). 
  --   The bucket boundaries are: 
  --     begin_time_utc, begin_time_utc+bucket_size, 
  --     begin_time_utc+2*bucket_size etc.
  --   The data can be filtered using the filter list.
  -- If instance_number is NULL it means all instances. Otherwise, fetch 
  --  only data for the specified instance number.
  -- Minimize_cost: If set to 'y', 
  --                the time budget for additional information is 0.
  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  FUNCTION incrementData(
      filter_list    IN VARCHAR2 := NULL
    , begin_time_utc IN VARCHAR2
    , bucket_size    IN NUMBER
    , show_sql       IN VARCHAR2 := 'n'
    , verbose_xml    IN VARCHAR2 := 'n'
    , include_bg      IN VARCHAR2 := 'n'
    , instance_number IN NUMBER := NULL
    , minimize_cost   IN VARCHAR2 := 'n')
  RETURN XMLTYPE;

  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  -- getashdata
  --   Returns the ASH data for historical usage in an XML format
  --   dbid determines which RDBMS to look for, default is the one we are
  --     connected to.
  --   Time period is one of the following
  --     a) From begin_time_utc to end_time_utc if both are specified.
  --     b) From NOW-time_since_sec to NOW (default is 24 hours)
  --   The data can be filtered using the filter list.
  -- If instance_number is NULL it means all instances. Otherwise, fetch 
  --  only data for the specified instance number.
  -- Minimize_cost: If set to 'y', 
  --                the time budget for additional information is 0.
  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  FUNCTION getDataHistorical(
      dbid            IN NUMBER := NULL
    , filter_list     IN VARCHAR2 := NULL
    , begin_time_utc  IN VARCHAR2 := NULL
    , end_time_utc    IN VARCHAR2 := NULL
    , time_since_sec  IN NUMBER := 86400
    , show_sql        IN VARCHAR2 := 'n'
    , verbose_xml     IN VARCHAR2 := 'n'
    , include_bg      IN VARCHAR2 := 'n'
    , instance_number IN NUMBER := NULL
    , minimize_cost   IN VARCHAR2 := 'n')
  RETURN XMLTYPE;

END omc_ash_viewer;
/
Rem
Rem $Header: emdb/source/oracle/sysman/emdrep/sql/db/latest/instance/omc_ashv_pkg_body.sql /main/3 2019/01/03 19:41:39 bram Exp $
Rem
Rem omc_ashv_pkg_body.sql
Rem
Rem Copyright (c) 2017, 2019, Oracle and/or its affiliates. 
Rem All rights reserved.
Rem
Rem    NAME
Rem      omc_ashv_pkg_body.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: emdb/source/oracle/sysman/emdrep/sql/db/latest/instance/omc_ashv_pkg_body.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    bram        09/21/17 - Created
Rem

/**********************************************************************
 * XML Definition
 **********************************************************************
 * <report>
 *   <report_parameters>
 *     <dbid>..</dbid>
 *     <begin_time>..</begin_time>
 *     <end_time>..</end_time>
 *   </report_parameters>
 *   <tp_mem_map>
 *     <tp_mem name=".." id=".."/>
 *     .
 *     .
 *   </tp_mem_map>
 *   <histogram bucket_count=".." bucket_interval=".." 
 *               last_bucket_interval="..">
 *     <bucket number=".." count="..">
 *       <mem id=".." count=".."/>
 *     </bucket>
 *     <bucket>
 *       .
 *       .
 *     </bucket>
 *     .
 *     .
 *   </histogram>
 *   <ash_data sampling_ratio="..">
 *     <data>
 *       <dimensions> sample_time, sample_count,
 *                    session_id, session_serial#,
 *                    instance_number, con_dbid,  
 *                    map_action_xml,map_blk_sess_xml,
 *                    map_captureid_xml,map_client_id_xml,
 *                    consumer_group_id,map_dbop_xml,
 *                    map_ecid_xml,map_event_xml,
 *                    is_captured,is_filtered_out,
 *                    is_nc_background,is_replayed,
 *                    map_machine_xml,map_port_xml,
 *                    map_module_xml,map_obj_xml,map_plsqlid_xml,
 *                    map_program_xml,map_px_proc_xml,map_service_xml,
 *                    session_type,map_sqlfms_xml,map_sqlidtop_xml,
 *                    sql_opcode,sql_opcode_top,map_sqlrws_xml,
 *                    map_sqlrwsline_xml,map_sqlid_xml,map_fullphv_xml,
 *                    map_phv_xml,user_id,map_waitclass_xml,map_xid_xml
 *       </dimensions>
 *       <a> .. </a>
 *       <a> .. </a>
 *       .
 *       .
 *     </data>
 *     <action>
 *       <m v="NULL" i="1"/>
 *       <m v="AQ LB Coordinator" i="2"/>
 *     </action>
 *     <blocking_session>
 *       <m v="NULL" i="1"/>
 *       <m v="1,108,10478" i="2"/>
 *       <m v="1,103,15183" i="3"/>
 *       <m v="1,108,34769" i="4"/>
 *     </blocking_session>
 *     <capture_id>
 *       <m v="0" i="1"/>
 *     </capture_id>
 *     <capture_id_name>
 *       <capture_id id="1" name="other activity"/>
 *     </capture_id_name>
 *     <client_id>
 *       <m v="NULL" i="1"/>
 *     </client_id>
 *     <consumer_id_name>
 *       <consumer_group id="*1"/>
 *       <consumer_group id="17323"/>
 *     </consumer_id_name>
 *     <dbop>
 *       <m v="NULL" i="1"/>
 *     </dbop>
 *     <ecid>
 *       <m v="NULL" i="1"/>
 *     </ecid>
 *     <evt>
 *       <m v="CPU + Wait for CPU" i="1"/>
 *       <m v="enq: TX * row lock contention" i="2"/>
 *     </evt>
 *     <machine>
 *       <m v="slc03pqj" i="1"/>
 *     </machine>
 *     <port>
 *       <m v="0" i="1"/>
 *     </port>
 *     <module>
 *       <m v="tmashfix_planhash" i="1"/>
 *       <m v="NULL" i="2"/>
 *       <m v="sqlplus@slc03pqj (TNS V1*V3)" i="3"/>
 *       <m v="Streams" i="4"/>
 *       <m v="tmashfix_timewaited" i="5"/>
 *     </module>
 *     <object>
 *       <m v="-1" i="1"/>
 *       <m v="91837" i="2"/>
 *       <m v="91836" i="3"/>
 *       <m v="92530" i="4"/>
 *     </object>
 *     <obj_name>
 *       <obj id="-1"/>
 *       <obj id="91837" name="DEPT"/>
 *       <obj id="91836" name="EMP"/>
 *       <obj id="92530" name="TEST_TABLE"/>
 *     </obj_name>
 *     <plsql>
 *       <m v="NULL" i="1"/>
 *     </plsql>
 *     <plsql_id_name>
 *       <plsql id="NULL"/>
 *     </plsql_id_name>
 *     <program>
 *       <m v="oracle@slc03pqj (QM03)" i="1"/>
 *       <m v="sqlplus@slc03pqj (TNS V1*V3)" i="2"/>
 *       <m v="oracle@slc03pqj (PSP0)" i="3"/>
 *     </program>
 *     <px_process>
 *       <m v="0" i="1"/>
 *     </px_process>
 *     <service_hash>
 *       <m v="3427055676" i="1"/>
 *       <m v="165959219" i="2"/>
 *     </service_hash>
 *     <service_name>
 *       <service id="1" name="SYS$USERS"/>
 *       <service id="2" name="SYS$BACKGROUND"/>
 *     </service_name>
 *     <sqlfms>
 *       <m v="7872268119344707597" i="1"/>
 *       <m v="16236550969875509390" i="2"/>
 *       <m v="0" i="3"/>
 *       <m v="13919063950093378021" i="4"/>
 *     </sqlfms>
 *     <sqlidtop>
 *       <m v="NULL" i="1"/>
 *       <m v="2qn5pysyf94xd" i="2"/>
 *       <m v="9n359uygxwc2c" i="3"/>
 *       <m v="02zsrqqrdphs8" i="4"/>
 *     </sqlidtop>
 *     <sql_opcode_name>
 *       <sql_opcode id="0"/>
 *       <sql_opcode id="3" name="SELECT"/>
 *       <sql_opcode id="6" name="UPDATE"/>
 *       <sql_opcode id="47" name="PL/SQL EXECUTE"/>
 *     </sql_opcode_name>
 *     <sqlrws>
 *       <m v="NULL" i="1"/>
 *       <m v="SELECT STATEMENT," i="2"/>
 *       <m v="UPDATE," i="3"/>
 *     </sqlrws>
 *     <sqlrwsline>
 *       <m v="bws0mts266ywz,3439400302,,SELECT STATEMENT," i="1"/>
 *       <m v="0zvq3mpr4rmzn,3439400302,,SELECT STATEMENT," i="2"/>
 *       <m v="dbu67tghgdqkc,3439400302,,SELECT STATEMENT," i="3"/>
 *       <m v="NULL" i="4"/>
 *       <m v="5ax5jdb2k0prk,1094798453,1,UPDATE," i="5"/>
 *       <m v="02zsrqqrdphs8,2652400688,1,UPDATE," i="6"/>
 *     </sqlrwsline>
 *     <sql>
 *       <m v="NULL" i="1"/>
 *       <m v="6pjk90r455g9n" i="2"/>
 *       <m v="dbu67tghgdqkc" i="3"/>
 *       <m v="bws0mts266ywz" i="4"/>
 *       <m v="5yphvhbzh74dd" i="5"/>
 *       <m v="bxgptaads4swj" i="6"/>
 *       <m v="0zvq3mpr4rmzn" i="7"/>
 *       <m v="5ax5jdb2k0prk" i="8"/>
 *       <m v="02zsrqqrdphs8" i="9"/>
 *     </sql>
 *     <sqlid_text>
 *       <sql id="1"/>
 *       <sql id="2"><![CDATA[select count( * )
 * from scott.emp e
 * , scott.emp, scott.emp, scott.emp,scott.emp,scott.emp
 * , scott.dep]]></sql>
 *       <sql id="3"><![CDATA[select count( * )
 * from scott.emp e
 * , scott.emp, scott.emp, scott.emp,scott.emp,scott.emp
 * , scott.dep]]></sql>
 *       <sql id="4"><![CDATA[select count( * )
 * from scott.emp e
 * , scott.emp, scott.emp, scott.emp,scott.emp,scott.emp
 * , scott.dep]]></sql>
 *       <sql id="5"><![CDATA[select count( * )
 * from scott.emp e
 * , scott.emp, scott.emp, scott.emp,scott.emp,scott.emp
 * , scott.dep]]></sql>
 *       <sql id="6"><![CDATA[select count( * )
 * from scott.emp e
 * , scott.emp, scott.emp, scott.emp,scott.emp,scott.emp
 * , scott.dep]]></sql>
 *       <sql id="7"><![CDATA[select count( * )
 * from scott.emp e
 * , scott.emp, scott.emp, scott.emp,scott.emp,scott.emp
 * , scott.dep]]></sql>
 *       <sql id="8"/>
 *       <sql id="9"/>
 *     </sqlid_text>
 *     <fullphv>
 *       <m v="0" i="1"/>
 *       <m v="3439400302" i="2"/>
 *       <m v="1094798453" i="3"/>
 *       <m v="2652400688" i="4"/>
 *     </fullphv>
 *     <phv>
 *       <m v="0" i="1"/>
 *       <m v="3439400302" i="2"/>
 *       <m v="1094798453" i="3"/>
 *       <m v="2652400688" i="4"/>
 *     </phv>
 *     <wait_class>
 *       <m v="CPU" i="1"/>
 *       <m v="Application" i="2"/>
 *     </wait_class>
 *     <xid>
 *       <m v="00" i="1"/>
 *     </xid>
 *   </ash_data>
 * </report>
 * DBA_HIST_ACTIVE_SESS_HISTORY  ASH
 * DBA_HIST_PARAMETER PARAM
 * **************************************
 * DIMENSION         XMLPATH                      TABLE_NAME       COLUMN_NAME
 * *************************************-
 * sample_time       //data/a                     ASH  sample_time
 * session_id        //data/a                     ASH  session_id
 * session_serial#   //data/a                     ASH  session_serial#
 * instance_number   //data/a                     ASH  instance_number
 * con_dbid          //data/a                     ASH  con_dbid
 * action            /data/action/m/@v            ASH  action
 * blocking_session  /data/blocking_session/m/@v  ASH  blocking_session,
 *                                                    blocking_session_serial#,
 *                                                    blocking_inst_id
 * captureid         /data/capture_id/m/@v        ASH  dbreplay_file_id
 * client id         /data/client_id/m/@v         ASH  client_id
 * consumer_group_id /data/a                      ASH  consumer_group_id
 * dbop name         /data/dbop/m/@v              ASH  dbop_name
 * ecid              /data/ecid/m/@v              ASH  ecid
 * event             /data/evt/m/@v               ASH  event
 * is_captured       /data/a                      ASH  is_captured
 * is_filtered_out   /data/a                      ASH  is_filtered_out
 * is_nc_background  /data/a                      ASH  is_nc_background
 * is_replayed       /data/a                      ASH  is_replayed
 * machine           /data/machine/m/@v           ASH  machine
 * port              /data/a                      ASH  port
 * module            /data/module/m/@v            ASH  module
 * object            /data/obj_name/m/@id         ASH  object
 *                   /data/obj_name/m/@v     CDB/DBA_OBJECT object_name     
 * plsql id          /data/plsql_id_name/m/@id    ASH plsql_object_id,
 *                                                    plsql_subprogram_id
 *                   /data/plsql_id_name/m/@v CDB/DBA_PROCEDURES
 *                                                    object_name, 
 *                                                    procedure_name
 * program           /data/program/m/@v           ASH program
 * px_proc           /data/a                      ASH qc_instance_id     
 * service           /data/service_hash/m/@v      ASH service_hash
 *                   /data/service_name/service/@name   service_name
 *                                       gv$active_services,
 *                                       dba_hist_service_name
 * session_type      /data/a                      ASH session_type
 * fms               /data/sqlfms/m/@v            ASH force_matching_signature
 * sqlidtop          /data/
 * sql_opcode        /data/                       ASH sql_opcode
 *                   /data/
 * sql_ocode_top
 * sqlrws 
 * sqlrwsline
 * sqlid
 * fullphv
 * phv
 * user_id
 * wait_class        /data/wait_class/m/@v        ASH  wait_class
 * xid
 * sample_count      <a>                         PARAM value parameter_name = 
 *                                                   'ash_disk_filter_ratio'
 * 
 *****************************************************************************/
-- Copyright (c) 2018, 2019, Oracle and/or its affiliates. All rights reserved.
create or replace PACKAGE BODY omc_ash_viewer IS
  -- ------------------------------------------------------------------------
  -- add_info_time: accumulated time during a query for additional information 
  -- add_info_budget: maximal allowed time based on query type and performance.
  -- ------------------------------------------------------------------------
  add_info_time NUMBER;
  add_info_budget NUMBER;
  
  FUNCTION timing_to_seconds(t1 IN TIMESTAMP, t2 IN TIMESTAMP)
  RETURN NUMBER
  IS 
  BEGIN
    RETURN ROUND(EXTRACT(SECOND FROM (t2-t1)) +
                 (60 * EXTRACT(MINUTE FROM (t2-t1))) +
                 (3600* EXTRACT(HOUR FROM (t2-t1))) +
                 (86400 * EXTRACT(DAY FROM (t2-t1)))
                 ,4);
  END timing_to_seconds;

  FUNCTION timing_to_xml(context IN OUT NOCOPY ContextType)
  RETURN XMLTYPE 
  IS
    l_xml XMLTYPE;
    l_secs NUMBER;
    l_end_time TIMESTAMP := SYSTIMESTAMP;
  BEGIN
    l_secs := timing_to_seconds(context.diag_start_time, l_end_time);
    SELECT xmlelement("timing",xmlattributes(
             to_char(context.diag_start_time, OMC_TIME_FORMAT) as "start_time",
             to_char(l_end_time, OMC_TIME_FORMAT) as "end_time",
             to_char(context.est_row_count) as "est_rows",
             to_char(context.exp_row_count) as "exp_rows",
             to_char(l_secs) as "total",
             to_char(add_info_time) as "add_info",
             to_char(add_info_budget) as "add_info_budget",
             to_char(context.diag_context_secs) as "context",
             to_char(context.diag_picker_secs) as "time_picker",
             to_char(context.diag_cpuinfo_secs) as "cpu_info",
             to_char(context.diag_data_secs) as "data"))
    INTO l_xml
    FROM SYS.DUAl;
    RETURN l_xml;
  END timing_to_xml;

  -- -------------------- COMP_DB_VERSION ---------------------------------
  -- NAME       : COMP_DB_VERSION
  -- DESCRIPTION: comparable db version - pads database version numbers to
  --              2 digits each and removes the dots.
  --              resulting string can be comparable to others
  --              (<, <=, >, >=, =)
  -- PARAMETERS : p_version
  -- RETURNS    : string with padded version representation (10 characters).
  -- -----------------------------------------------------------------------
  FUNCTION COMP_DB_VERSION(p_version IN VARCHAR2)
  RETURN VARCHAR2
  IS
    l_version varchar2(30) := p_version;
    l_digit     number;
    r_version varchar2(17);  -- string to return
  BEGIN
    LOOP
      -- find the digit
      l_digit := regexp_substr(l_version,'(\d)+');
      -- strip the digit and the . (if it exists)
      IF l_version is null THEN
        r_version := r_version || '00';
      ELSE
        l_version := regexp_replace(l_version,'(\d)+.|(\d)+','',1,1);
        r_version := r_version || lpad(to_char(l_digit,'TM9'),2,'0');
      END IF;
      exit when length(r_version) >= 10;
    END LOOP;
    RETURN r_version;
  END COMP_DB_VERSION;

  FUNCTION error_to_xml(english_msg IN VARCHAR, id IN VARCHAR, 
                        arg1 IN VARCHAR := NULL,
                        arg2 IN VARCHAR := NULL,
                        arg3 IN VARCHAR := NULL)
  RETURN XMLTYPE 
  IS
    result XMLTYPE;
  BEGIN
    SELECT xmlelement("error", xmlforest(
             english_msg as "english_msg",
             id as "id",
             arg1 as "arg1",
             arg2 as "arg2",
             arg3 as "arg3")) 
    INTO result FROM sys.dual;
    RETURN result;
  END error_to_xml;

  -----------------------------------------------------------------------
  -- NAME:
  --    print_context
  --
  -- DESCRIPTION:
  --    Print the analysis context for debugging purposes.
  --
  -----------------------------------------------------------------------
  PROCEDURE printBoolean(name IN VARCHAR, value IN BOOLEAN)
  IS
  BEGIN
    IF value IS NULL THEN
      dbms_output.put_line(name || ' = NULL');
    ELSIF value THEN
      dbms_output.put_line(name || ' = TRUE');
    ELSE
      dbms_output.put_line(name || ' = FALSE');
    END IF;
  END printBoolean;

  PROCEDURE print_context(context IN OUT NOCOPY ContextType)
  IS
    err_msg VARCHAR2(4000);
  BEGIN
    IF context.error_xml IS NOT NULL THEN
      SELECT xmlelement("a",context.error_xml).getclobval() 
      INTO err_msg FROM sys.dual;
    END IF;
    dbms_output.put_line('======================================');
    dbms_output.put_line('        ASH VIEWER CONTEXT            ');
    dbms_output.put_line('======================================');
    printBoolean('is_local', context.is_local);
    printBoolean('is_cdb_root', context.is_cdb_root);
    dbms_output.put_line('local_dbid = ' || context.local_dbid);
    dbms_output.put_line('local_version = ' || context.local_version);
    dbms_output.put_line('local_comp_ver = ' || context.local_comp_ver);
    dbms_output.put_line('local_conid = ' || context.local_conid);
    dbms_output.put_line('local_condbid = ' || context.local_condbid);
    printBoolean('underscores', context.underscores);
    dbms_output.put_line('beginTimeUTC = ' ||
         to_char(context.beginTimeUTC, OMC_TIME_FORMAT));
    dbms_output.put_line('endTimeUTC = ' ||
         to_char(context.endTimeUTC, OMC_TIME_FORMAT));
    dbms_output.put_line('instance_number = ' || context.instance_number);
    dbms_output.put_line('bucketCount = ' || context.bucketCount);
    dbms_output.put_line('bucketInterval = ' || context.bucketInterval);
    dbms_output.put_line('lastBucketSize = ' || context.lastBucketSize);
    printBoolean('memEnable', context.memEnable);
    dbms_output.put_line('memSizeDays = ' || context.memSizeDays);
    dbms_output.put_line('memTZ = ' || context.memTZ);
    printBoolean('diskEnable', context.diskEnable);
    dbms_output.put_line('dbid = ' || context.dbid);
    dbms_output.put_line('disk_comp_ver = ' || context.disk_comp_ver);
    dbms_output.put_line('beginSnapID = ' || context.beginSnapID);
    dbms_output.put_line('endSnapID = ' || context.endSnapID);
    dbms_output.put_line('awrTablePrefix = ' || context.awrTablePrefix);
    dbms_output.put_line('diskEndTimeUTC = ' ||
         to_char(context.diskEndTimeUTC, OMC_TIME_FORMAT));
    dbms_output.put_line('diskTZ = ' || context.diskTZ);
    printBoolean('show_sql', context.show_sql);
    printBoolean('verbose_xml', context.verbose_xml);
    printBoolean('use_utc_binds', context.use_utc_binds);
    dbms_output.put_line('error_xml = ' || err_msg);
    dbms_output.put_line('==== DATA SPECIFIC CONTEXT ===');
    printBoolean('include_bg', context.include_bg);
    printBoolean('minimize_cost', context.minimize_cost);
    dbms_output.put_line('Estimated Row Count = ' || context.est_row_count);
    dbms_output.put_line('Expected Row Count = ' || context.exp_row_count);
    dbms_output.put_line('Down sampling ratio = ' || context.sample_ratio);
    dbms_output.put_line('memFilterPredicate = ' || context.memFilterPredicate);
    dbms_output.put_line('diskFilterPredicate = ' || context.diskFilterPredicate);
    dbms_output.put_line('gvFilterPredicate = ' || context.gvFilterPredicate);
    dbms_output.put_line('number of dimensions = ' || context.dimTable.COUNT);
    dbms_output.put_line('==== BINDS AND TRANSFORMATIONS ===');
    FOR i IN 1..context.binds.COUNT LOOP
      dbms_output.put_line(context.binds(i).name || ' = ' || context.binds(i).value);
    END LOOP;
    dbms_output.put_line('======================================');
  END print_context;

  --------------------------------------------------------------------------
  -- NAME:
  --    print_sql
  --
  -- DESCRIPTION:
  --    Print the query for debugging purposes
  --
  -- PARAMETERS:
  --    queryLob        (IN)  - The query to be printed
  --    context         (IN)  - Analysis context
  --------------------------------------------------------------------------
  PROCEDURE print_sql(queryLob IN CLOB
                     ,bind1 IN VARCHAR := NULL
                     ,bind2 IN VARCHAR := NULL
                     ,bind3 IN VARCHAR := NULL
                     ,bind4 IN VARCHAR := NULL
                     ,bind5 IN VARCHAR := NULL
                     ,bind6 IN VARCHAR := NULL
                     ,bind7 IN VARCHAR := NULL
                     ,bind8 IN VARCHAR := NULL
                     ,bind9 IN VARCHAR := NULL)
  IS
    queryLen   NUMBER;
    i          NUMBER;
    line       VARCHAR2(30000);
    c          VARCHAR2(4);
    EOLN_CHAR  VARCHAR2(4) := '
';
  BEGIN
    queryLen := dbms_lob.getLength(queryLob);
    i := 1;
    line := NULL;
    WHILE i <= queryLen LOOP
      c := substr(queryLob, i, 1);
      i := i + 1;
      IF c = EOLN_CHAR THEN
        IF line IS NOT NULL THEN
          IF length(trim(line)) > 0 THEN
            line := replace(line, ':1 ', bind1||' ');
            line := replace(line, ':2 ', bind2||' ');
            line := replace(line, ':3 ', bind3||' ');
            line := replace(line, ':4 ', bind4||' ');
            line := replace(line, ':5 ', bind5||' ');
            line := replace(line, ':6 ', bind6||' ');
            line := replace(line, ':7 ', bind7||' ');
            line := replace(line, ':8 ', bind8||' ');
            line := replace(line, ':9 ', bind9||' ');
            dbms_output.put_line(line);
          END IF;
        END IF;
        line := NULL;
      ELSE
        line := line || c;
      END IF;
    END LOOP;
    dbms_output.put_line(line || ';');
  END print_sql;

  --------------------------------------------------------------------------
  -- NAME:
  --    print_query
  --
  -- DESCRIPTION:
  --    Print the query for debugging purposes
  --
  -- PARAMETERS:
  --    queryLob        (IN)  - The query to be printed
  --    context         (IN)  - Analysis context
  --------------------------------------------------------------------------
  PROCEDURE print_query(queryLob IN CLOB, context IN OUT NOCOPY ContextType)
  IS
    dim        VARCHAR2(30);
  BEGIN
    dbms_output.put_line('-- BEGIN sql script for query');
    dbms_output.new_line;

    print_sql(queryLob);
    dbms_output.put_line('-- END sql script for query');
  END print_query;

  --------------------------------------------------------------------------
  -- NAME:
  --    executeSQL
  --
  -- DESCRIPTION:
  --    Executes a SQL statement with no binds
  --
  -- PARAMETERS:
  --    context         (IN)  - Analysis context
  --    dynsql          (IN)  - The query to be executed
  --    estimateRowCount(IN)  - is there a numeric return value
  --
  -- RETURN
  --    xmltype containing the result of the SQL
  --    IF estimateRowCount THEN also put the numeric value in 
  --       context.est_row_count (used for activity line)
  --------------------------------------------------------------------------
  FUNCTION executeSQL(context          IN OUT NOCOPY ContextType,
                      dynsql           IN CLOB,
                      estimateRowCount IN BOOLEAN)
  RETURN XMLTYPE
  IS
    retXML        XMLTYPE;
    l_err_msg     VARCHAR2(4000);
  BEGIN
    IF context.show_sql THEN
      print_sql(dynsql);
    END IF;

    IF estimateRowCount THEN
      EXECUTE IMMEDIATE dynsql INTO context.est_row_count, retXML;
    ELSE
      EXECUTE IMMEDIATE dynsql INTO retXML;
    END IF;
    RETURN retXML;

    EXCEPTION WHEN OTHERS THEN
       l_err_msg := SQLERRM;
       SELECT xmlelement("error",l_err_msg,xmlelement("sqltext",dynsql)) 
       INTO retXML FROM SYS.DUAL;
       IF NOT context.show_sql THEN
         print_sql(dynsql);
       END IF;
       dbms_output.put_line(l_err_msg);
       RETURN retXML;
  END executeSQL;

  FUNCTION replace_binds(p_sql IN VARCHAR, context IN OUT NOCOPY ContextType)
  RETURN VARCHAR
  IS
    l_sql VARCHAR(30000);
  BEGIN
    l_sql := p_sql;
    FOR i IN 1..context.binds.COUNT LOOP
      IF context.binds(i).name IS NOT NULL THEN
        l_sql := REPLACE(l_sql, context.binds(i).name, context.binds(i).value);
      END IF;
    END LOOP;
    RETURN l_sql;
  END replace_binds;

  PROCEDURE addQueryBlock(context IN OUT NOCOPY ContextType,
                          p_sql IN VARCHAR,
                          p_replace_binds IN BOOLEAN := TRUE)
  IS
  BEGIN
    IF p_sql IS NOT NULL THEN
      context.query.EXTEND(1);
      IF p_replace_binds THEN
        context.query(context.query.COUNT) := replace_binds(p_sql, context);
      ELSE
        context.query(context.query.COUNT) := p_sql; 
      END IF;
    END IF; 
  END addQueryBlock;

  PROCEDURE resetQuery(context IN OUT NOCOPY ContextType)
  IS
  BEGIN
    context.query.delete;
  END resetQuery;

  FUNCTION executeQuery(context IN OUT NOCOPY ContextType,
                        estimateRowCount IN BOOLEAN)
  RETURN XMLTYPE
  IS
    l_sql CLOB := context.query(1);
  BEGIN
    FOR i IN 2..context.query.COUNT LOOP
      SYS.DBMS_LOB.WRITEAPPEND(l_sql, LENGTH(context.query(i)), context.query(i));
    END LOOP;
    RETURN executeSQL(context, l_sql, estimateRowCount);
  END executeQuery;  

  -- ***************************************************************** --
  --  Implementation of ContextType code. (just for time picker)
  --  ----------------------------------------------------------
  --  ContextType is used for identifying the data sources for 
  --  time picker (and ASH data) queries.
  -- ***************************************************************** --
  -----------------------------------------------------------------------

  FUNCTION contextToXml(context IN OUT NOCOPY ContextType) 
  RETURN XMLTYPE
  IS
    l_report XMLTYPE;
    is_local VARCHAR(10);
    is_cdb_root VARCHAR(10);
    memEnable VARCHAR(10);
    diskEnable VARCHAR(10);
    underscores VARCHAR(10);
    show_sql VARCHAR(10);
    verbose_xml VARCHAR(10);
    include_bg VARCHAR(10);
    minimize_cost VARCHAR(10);
    use_utc_binds VARCHAR(10);
  BEGIN
    is_local := (CASE WHEN context.is_local THEN 'TRUE' ELSE 'FALSE' END);
    is_cdb_root := (CASE WHEN context.is_cdb_root THEN 'TRUE' ELSE 'FALSE' END);
    memEnable := (CASE WHEN context.memEnable THEN 'TRUE' ELSE 'FALSE' END);
    diskEnable := (CASE WHEN context.diskEnable THEN 'TRUE' ELSE 'FALSE' END);
    underscores := (CASE WHEN context.underscores THEN 'TRUE' ELSE 'FALSE' END);
    show_sql := (CASE WHEN context.show_sql THEN 'TRUE' ELSE 'FALSE' END);
    verbose_xml := (CASE WHEN context.verbose_xml THEN 'TRUE' ELSE 'FALSE' END);
    minimize_cost := (CASE WHEN context.minimize_cost THEN 'TRUE' ELSE 'FALSE' END);
    use_utc_binds := (CASE WHEN context.use_utc_binds THEN 'TRUE' ELSE 'FALSE' END);
    SELECT xmlelement("context",
             context.error_xml,
             xmlforest(
               is_local as "is_local"
             , is_cdb_root as "is_cdb_root"
             , context.local_dbid as "local_dbid"
             , context.local_version as "local_version"
             , context.local_comp_ver as "local_comp_ver"
             , context.local_conid as "local_conid" 
             , context.local_condbid as "local_condbid"
             , underscores as "underscores"
             , to_char(context.beginTimeUTC,OMC_TIME_FORMAT) as "beginTimeUTC"
             , to_char(context.endTimeUTC,OMC_TIME_FORMAT) as "endTimeUTC"
             , context.instance_number as "instanceNumber"
             , context.bucketCount as "bucketCount"
             , context.bucketInterval as "bucketInterval"
             , context.lastBucketSize as "lastBucketSize"
             , memEnable as "memEnable"
             , context.memSizeDays as "memSizeDays"
             , context.memTZ as "memTZ"
             , diskEnable as "diskEnable"
             , context.disk_comp_ver as "disk_comp_ver"
             , context.dbid as "dbid"
             , context.beginSnapID as "beginSnapID"
             , context.endSnapID as "endSnapID"
             , context.awrTablePrefix as "awrTablePrefix"
             , to_char(context.diskEndTimeUTC,OMC_TIME_FORMAT) as "diskEndTimeUTC"
             , context.diskTZ as "diskTZ"
             , show_sql as "show_sql"
             , verbose_xml as "verbose_xml"
             , include_bg as "include_bg"
             , minimize_cost as "minimize_cost"
             , use_utc_binds as "use_utc_binds"
           ))
    INTO l_report FROM SYS.DUAL;
    RETURN l_report;
  END contextToXml;

  FUNCTION createErrorReport(context IN OUT NOCOPY ContextType,
                             p_input IN OUT NOCOPY XMLTYPE)
  RETURN XMLTYPE
  IS
    l_report XMLTYPE;
    l_context_xml XMLTYPE;
    l_timing XMLTYPE;
  BEGIN
    l_context_xml := contextToXml(context);
    l_timing := timing_to_xml(context);
    SELECT xmlelement("report", l_timing, p_input, l_context_xml) 
    INTO l_report FROM SYS.DUAL;
    RETURN l_report;
  END createErrorReport;

  FUNCTION initBaseContext(dbid IN NUMBER, show_sql IN VARCHAR, 
                           verbose_xml IN VARCHAR, include_bg IN VARCHAR,
                           instance_number IN NUMBER, minimize_cost IN VARCHAR)

  RETURN ContextType
  IS
    context ContextType;
  BEGIN
    -- initialize the time limit and start timing
    add_info_time := 0;
    context.diag_start_time := SYSTIMESTAMP;

    -- init the query
    context.query := QueryBlockArrayType();
    context.binds := BindArrayType();

    -- check the diagnostic flags
    IF upper(show_sql) = 'Y' THEN
      context.show_sql := TRUE;
    ELSE
      context.show_sql := FALSE;
    END IF;
    IF upper(verbose_xml) = 'Y' THEN
      context.verbose_xml := TRUE;
    ELSE
      context.verbose_xml := FALSE;
    END IF;
    IF upper(include_bg) = 'Y' THEN
      context.include_bg := TRUE;
    ELSE
      context.include_bg := FALSE;
    END IF;
    IF upper(minimize_cost) = 'Y' THEN
      context.minimize_cost := TRUE;
    ELSE
      context.minimize_cost := FALSE;
    END IF;
    IF instance_number IS NULL OR instance_number < 1 THEN
      context.instance_number := NULL;
    ELSE
      context.instance_number := TRUNC(instance_number);
    END IF;
    
    -- get local version and dbid
    EXECUTE IMMEDIATE 'SELECT v.version FROM V$INSTANCE v'
    INTO context.local_version;
    context.local_comp_ver := comp_db_version(context.local_version);
    IF context.local_comp_ver >= VER_12_2 THEN
      context.local_dbid := TO_NUMBER(SYS_CONTEXT('USERENV','DBID'));
    ELSE
      EXECUTE IMMEDIATE 'SELECT v.dbid FROM V$DATABASE v'
      INTO context.local_dbid;
    END IF;

    -- get the local PDB identifications
    context.local_condbid := NULL;
    context.local_conid := NULL;
    context.local_is_pdb := FALSE;
    IF context.local_comp_ver >= VER_12 THEN
      context.local_conid := TO_NUMBER(SYS_CONTEXT('USERENV','CON_ID'));
      IF (context.local_conid IS NOT NULL AND context.local_conid > 1) THEN
        context.local_condbid := TO_NUMBER(SYS_CONTEXT('USERENV','CON_DBID')); 
        context.local_is_pdb := TRUE;
      ELSE
        context.local_conid := NULL;
      END IF;
    END IF;

    -- determine if we have a local run
    IF (dbid IS NULL
        OR dbid = context.local_dbid
        OR (context.local_condbid IS NOT NULL AND dbid = context.local_dbid)) THEN
      -- local system
      context.is_local := TRUE;
      context.dbid := context.local_dbid;
      IF context.local_condbid IS NOT NULL THEN
        -- connected to a PDB
        IF context.local_comp_ver >= VER_12_2 THEN
          context.awrTablePrefix := 'AWR_ROOT_';
        ELSE
          context.awrTablePrefix := 'DBA_HIST_';
        END IF;
      ELSE
        -- connected to Root or regular DB
        context.awrTablePrefix := 'DBA_HIST_';
        context.local_conid := NULL;
      END IF;
    ELSE
      -- imported snapshots
      context.is_local := FALSE;
      context.dbid := dbid;
      IF context.local_condbid IS NOT NULL THEN
        IF context.local_comp_ver >= VER_12 THEN
          context.awrTablePrefix := 'AWR_PDB_';
        ELSE
          context.error_xml := error_to_xml(
            'Imported AWR snapshots not supported in a PDB in RDBMS version ' 
            || context.local_version,
            'err_imported_in_pdb', context.local_version);
        END IF; 
      ELSE 
        context.awrTablePrefix := 'DBA_HIST_';
      END IF;
    END IF;
 
    context.underscores := FALSE;

    RETURN context;
  END initBaseContext;

  PROCEDURE initBaseContextTime(context IN OUT NOCOPY ContextType,
                                bucket_size IN NUMBER := NULL)
  IS
    l_size NUMBER;
    l_diff_sec NUMBER;
    l_min_size NUMBER;
  BEGIN
    IF context.endTimeUTC IS NULL THEN
      context.endTimeUTC := CAST(sys_extract_utc(systimestamp) AS DATE);
      l_min_size := OMC_DEF_RT_MIN_BUCKET_SIZE;
    ELSE
      l_min_size := OMC_DEF_HIST_MIN_BUCKET_SIZE;
    END IF;
    l_diff_sec := ROUND((context.endTimeUTC-context.beginTimeUTC)*86400,0);
    IF bucket_size IS NOT NULL THEN
      l_size := bucket_size;
    ELSE
      l_size := ROUND(GREATEST(l_min_size, l_diff_sec / OMC_DEF_BUCKETS),0);
      l_size := TRUNC((l_size+9)/10)*10;
    END IF;
    context.bucketInterval := l_size;
    context.bucketCount := CEIL(l_diff_sec / l_size);
    context.lastBucketSize := 
        GREATEST(0, l_diff_sec - (l_size * context.bucketCount));
  END initBaseContextTime;

  PROCEDURE getMemorySizeInDays(context IN OUT NOCOPY ContextType)
  IS
    l_min_tz   NUMBER;
    l_max_tz   NUMBER;
    l_underscores NUMBER;
    l_sqltext VARCHAR2(4000);
  BEGIN
    l_sqltext :=
      'SELECT min(CAST(a.LATEST_SAMPLE_TIME as DATE) - CAST(
                       a.OLDEST_SAMPLE_TIME as DATE))
             ,min(CAST(a.LATEST_SAMPLE_TIME as DATE) - CAST(
                  SYS_EXTRACT_UTC(SYSTIMESTAMP) as DATE))
             ,max(CAST(a.LATEST_SAMPLE_TIME as DATE) - CAST(
                  SYS_EXTRACT_UTC(SYSTIMESTAMP) as DATE))
             ,max(CASE WHEN (a.disk_filter_ratio <> 10 OR 
                             a.sampling_interval <> 1000)
                       THEN 1 ELSE 0 END)
       FROM   GV$ASH_INFO a';
    IF context.local_conid IS NOT NULL THEN
      l_sqltext := l_sqltext || ' WHERE a.con_id = 0';
      IF context.instance_number IS NOT NULL THEN
        l_sqltext := l_sqltext || 
           ' AND a.inst_id = ' || context.instance_number;
      END IF;
    ELSIF context.instance_number IS NOT NULL THEN
      l_sqltext := l_sqltext || 
         ' WHERE a.inst_id = ' || context.instance_number;
    END IF;
    EXECUTE IMMEDIATE l_sqltext 
    INTO context.memSizeDays, l_min_tz, l_max_tz, l_underscores;

    -- in case we found nothing, possibly because an instance is down
    IF context.memSizeDays IS NULL THEN
      context.memSizeDays := 0;
      context.memTZ := NULL;
      context.underscores := FALSE;
      context.memEnable := FALSE;
      RETURN;
    END IF;

    l_min_tz := ROUND(l_min_tz*96,0)/96;
    l_max_tz := ROUND(l_max_tz*96,0)/96;
    IF (l_max_tz - l_min_tz) < (1/96) THEN
      context.memTZ := l_max_tz;
    ELSE
      context.memTZ := NULL;
    END IF;
    IF l_underscores > 0 THEN
      context.underscores := TRUE;
    END IF;
  END getMemorySizeInDays;

  PROCEDURE chooseAwrForPdb(context IN OUT NOCOPY ContextType)
  IS
    l_pdb_time  DATE;
    l_root_time DATE;
    l_sqltext   VARCHAR2(4000);
  BEGIN
    -- get the latest snapshot time from local AWR.
    l_sqltext := 
      'SELECT CAST(MAX(end_interval_time-snap_timezone) AS DATE)
       FROM   AWR_PDB_SNAPSHOT
       WHERE  dbid = :1';
    EXECUTE IMMEDIATE l_sqltext 
    INTO l_pdb_time
    USING context.local_condbid;

    IF l_pdb_time IS NULL THEN
      -- no local snapshots. point to root AWR.
      RETURN;
    END IF;

    IF l_pdb_time >= context.beginTimeUTC THEN
      -- local AWR has some of the time range. Use it.
      context.awrTablePrefix := 'AWR_PDB_';
      context.dbid := context.local_condbid;
      context.local_dbid := context.local_condbid;
      RETURN;
    END IF;

    -- get the latest from root.
    -- this is in case the local AWR stopped working at some point, 
    -- and the root has the data.
    l_sqltext := 
      'SELECT CAST(MAX(end_interval_time-snap_timezone) AS DATE)
       FROM   AWR_ROOT_SNAPSHOT
       WHERE  dbid = :1';
    EXECUTE IMMEDIATE l_sqltext
    INTO l_root_time
    USING context.local_dbid;
    
    IF l_root_time IS NULL 
       OR l_root_time <= l_pdb_time + (1/8) THEN
      -- Either no root snapshots, or root is no mode than 3 hours ahead.
      -- Use local snapshots
      context.awrTablePrefix := 'AWR_PDB_';
      context.dbid := context.local_condbid;
      context.local_dbid := context.local_condbid;
    END IF;
  END chooseAwrForPdb;

  PROCEDURE initBaseContextDisk(context IN OUT NOCOPY ContextType)
  IS
    l_sqltext VARCHAR2(4000);
    l_begin_snap_id NUMBER;
    l_end_snap_id NUMBER;
    l_max_snap_id NUMBER;
    l_underscores NUMBER;
    l_version VARCHAR2(30);
    l_min_tz NUMBER;
    l_max_tz NUMBER;
    l_and_inst VARCHAR2(1000) := ' ';
  BEGIN
    IF context.is_local AND context.local_is_pdb AND 
       context.awrTablePrefix = 'AWR_ROOT_' THEN
      chooseAwrForPdb(context);
    END IF;

    IF context.instance_number IS NOT NULL THEN
      l_and_inst := ' AND instance_number = ' || context.instance_number;
    END IF;
   
    -- find the latest snapshot, if there is any data in AWR.
    l_sqltext :=
       'SELECT max(SNAP_ID) FROM ' || context.awrTablePrefix
       || 'SNAPSHOT WHERE dbid = :1' || l_and_inst;
    EXECUTE IMMEDIATE l_sqltext
    INTO l_max_snap_id
    USING context.dbid;
    IF l_max_snap_id IS NULL THEN
      -- no AWR snapshots available.
      -- emergency data might be available in 12.2 and above 
      -- even without snapshots, if we query local database.
      IF (context.is_local
          AND context.local_comp_ver >= VER_12_2) THEN
        context.diskEnable := TRUE;
        context.disk_comp_ver := context.local_comp_ver;
      ELSE
        context.diskEnable := FALSE;
      END IF;
      RETURN;
    END IF;
    
    -- find the begin snapshot for the query. 
    l_sqltext :=
       'SELECT min(snap_id),
               min(case when end_interval_time-snap_timezone > 
                   CAST(:1 AS TIMESTAMP) THEN snap_id ELSE NULL END)
        FROM ' || context.awrTablePrefix || 'SNAPSHOT 
        WHERE dbid = :2  
          AND end_interval_time-snap_timezone > CAST(:3 AS TIMESTAMP)' 
        || l_and_inst;
    EXECUTE IMMEDIATE l_sqltext
    INTO l_begin_snap_id, l_end_snap_id
    USING context.endTimeUTC, context.dbid, context.beginTimeUTC;
    context.diskEnable := TRUE;
    context.endSnapID := NVL(l_end_snap_id, l_max_snap_id + 1);
    context.beginSnapID := NVL(l_begin_snap_id, context.endSnapID);
    IF l_end_snap_id IS NOT NULL THEN
      l_sqltext := 
        'SELECT CAST(max(end_interval_time-snap_timezone) AS DATE) FROM '
        || context.awrTablePrefix || 'SNAPSHOT WHERE dbid = :1 ' 
        || ' AND snap_id = :2' || l_and_inst;
      EXECUTE IMMEDIATE l_sqltext
      INTO context.diskEndTimeUTC
      USING context.dbid, l_end_snap_id;
      context.diskEndTimeUTC := 
         LEAST(context.diskEndTimeUTC, context.endTimeUTC);
    END IF;

    -- Find the version of data in AWR
    -- and also find timezone for disk data
    l_sqltext := 
      'SELECT min(di.version),
              min(ROUND(CAST(s.end_interval_time AS DATE) - CAST(
               s.end_interval_time-s.snap_timezone AS DATE), 9)), 
              max(ROUND(CAST(s.end_interval_time AS DATE) - CAST(
               s.end_interval_time-s.snap_timezone AS DATE), 9))
       FROM ' 
       ||  context.awrTablePrefix || 'DATABASE_INSTANCE di, '
       ||  context.awrTablePrefix || 'SNAPSHOT s
      WHERE di.dbid = :1
        AND s.dbid = :2
        AND s.snap_id >= :3
        AND s.snap_id <= :4
        AND s.instance_number = di.instance_number
        AND s.startup_time = di.startup_time'; 
    IF context.instance_number IS NOT NULL THEN
       l_sqltext := l_sqltext || ' AND s.instance_number = ' || 
          context.instance_number;
    END IF;
    EXECUTE IMMEDIATE l_sqltext
    INTO l_version, l_min_tz, l_max_tz
    USING context.dbid, context.dbid, context.beginSnapID, context.endSnapID; 
    context.disk_comp_ver := COMP_DB_VERSION(l_version);  
    IF l_version IS NOT NULL 
       AND l_min_tz IS NOT NULL 
       AND l_max_tz IS NOT NULL
    THEN
      context.diskEnable := TRUE;
    ELSE
      context.diskEnable := FALSE;
      RETURN;
    END IF;
    l_min_tz := ROUND(l_min_tz*96,0)/96;
    l_max_tz := ROUND(l_max_tz*96,0)/96;
    IF (l_max_tz - l_min_tz) < (1/96) THEN
      context.diskTZ := l_max_tz;
      IF context.memEnable THEN
        IF (context.memTZ IS NULL OR 
            ROUND(context.diskTZ*96,0) <> ROUND(context.memTZ*96,0)) THEN
          context.diskTZ := NULL;
          context.memTZ := NULL;
        ELSE
          context.diskTZ := context.memTZ;
        END IF;
      END IF;
    ELSE 
      context.diskTZ := NULL;
    END IF;

    -- find if underscore parameters area used
    -- this will complicate things later on.
    -- underscores can mess things up later on. 
    IF (context.disk_comp_ver < VER_12_2
        AND l_begin_snap_id IS NOT NULL
        AND NOT context.underscores) THEN
      l_sqltext :=
        'SELECT count(*) FROM ' || context.awrTablePrefix
        || 'PARAMETER WHERE dbid = :1 AND snap_id >= :2 AND snap_id <= :3'
        || ' AND parameter_name IN '
        || ' (''_ash_sampling_interval'',''_ash_disk_filter_ratio'')'
        || l_and_inst;
      EXECUTE IMMEDIATE l_sqltext
      INTO l_underscores
      USING context.dbid, context.beginSnapID, context.endSnapID;
      IF l_underscores > 0 THEN
        context.underscores := TRUE;
      END IF;
    END IF;
    EXCEPTION WHEN OTHERS THEN
    BEGIN
      IF context.show_sql THEN
        dbms_output.put_line(l_sqltext);
      END IF;
      RAISE;
    END;
  END initBaseContextDisk;
                                
  FUNCTION buildBaseContextIncremental(
         begin_time_utc IN DATE
       , bucket_size IN NUMBER
       , show_sql IN VARCHAR
       , verbose_xml IN VARCHAR
       , include_bg IN VARCHAR
       , instance_number IN NUMBER
       , minimize_cost IN VARCHAR)
  RETURN ContextType
  IS
    context ContextType := initBaseContext(
         NULL, show_sql, verbose_xml, include_bg, instance_number, 
         minimize_cost);
  BEGIN
    context.beginTimeUTC := begin_time_utc;
    initBaseContextTime(context, bucket_size);
    getMemorySizeInDays(context);
    context.memEnable := TRUE;
    context.diskEnable := FALSE;
    context.diag_context_secs := 
        timing_to_seconds(context.diag_start_time, SYSTIMESTAMP);
    RETURN context;
  END buildBaseContextIncremental; 

  FUNCTION buildBaseContextRealTime(
         time_since_sec IN NUMBER
       , show_sql IN VARCHAR
       , verbose_xml IN VARCHAR
       , include_bg IN VARCHAR
       , instance_number IN NUMBER
       , minimize_cost IN VARCHAR)
  RETURN ContextType
  IS
    context ContextType := initBaseContext(
              NULL, show_sql,verbose_xml, include_bg, instance_number, 
              minimize_cost);
    l_requested_days NUMBER;
  BEGIN
    context.beginTimeUTC := 
       CAST(SYS_EXTRACT_UTC(SYSTIMESTAMP) AS DATE) - (time_since_sec/86400);
    initBaseContextTime(context, NULL);
    context.memEnable := TRUE;
    context.dbid := context.local_dbid;
    -- check if memory is enough
    l_requested_days := context.endTimeUTC - context.beginTimeUTC;
    getMemorySizeInDays(context);
    IF context.minimize_cost OR
       OMC_ALLOWED_ERR_RATIO * context.memSizeDays >= l_requested_days THEN
      -- It is expected for most use cases that this is the common code path.
      -- in case an instance was recently started or memory pressure causes
      -- a short amount to be in memory, we might supplement with disk.
      context.diskEnable := FALSE;
    ELSE
      -- potentially add disk data
      initBaseContextDisk(context);
    END IF;
    context.diag_context_secs := 
        timing_to_seconds(context.diag_start_time, SYSTIMESTAMP);
    RETURN context;
  END buildBaseContextRealTime; 

  FUNCTION buildBaseContextHistorical(
         dbid IN NUMBER
       , begin_time_utc IN VARCHAR2
       , end_time_utc   IN VARCHAR2
       , time_since_sec IN NUMBER
       , show_sql IN VARCHAR
       , verbose_xml IN VARCHAR
       , include_bg IN VARCHAR
       , instance_number IN NUMBER
       , minimize_cost IN VARCHAR)
  RETURN ContextType
  IS
    context ContextType := initBaseContext(
         dbid, show_sql, verbose_xml, include_bg, instance_number, 
         minimize_cost);
    l_now DATE := CAST(SYS_EXTRACT_UTC(SYSTIMESTAMP) AS DATE);
    l_requested_days NUMBER;
    l_mem_gap NUMBER;
  BEGIN
    IF context.error_xml IS NOT NULL THEN
      RETURN context;
    END If;

    -- set the time period and initialize 
    IF begin_time_utc IS NOT NULL THEN
      context.beginTimeUTC := TO_DATE(begin_time_utc, OMC_TIME_FORMAT);
      IF end_time_utc IS NOT NULL THEN
        context.endTimeUTC := TO_DATE(end_time_utc, OMC_TIME_FORMAT);
      END IF;
      IF context.beginTimeUTC >= context.endTimeUTC THEN
        context.beginTimeUTC := NULL;
        context.endTimeUTC := NULL;
      END IF;
    END IF;
    IF context.beginTimeUTC IS NULL THEN 
      context.beginTimeUTC :=
         CAST(SYS_EXTRACT_UTC(SYSTIMESTAMP) AS DATE) - (time_since_sec/86400);
    END IF;
    initBaseContextTime(context, NULL);

    -- case we run on imported snapshots
    IF NOT context.is_local THEN 
      context.memEnable := FALSE;
      initBaseContextDisk(context);
      context.diag_context_secs := 
          timing_to_seconds(context.diag_start_time, SYSTIMESTAMP);
      RETURN context;
    END IF;
    
    -- check if memory is an option
    l_requested_days := context.endTimeUTC - context.beginTimeUTC;
    getMemorySizeInDays(context);
    l_mem_gap := GREATEST(0, l_now - context.endTimeUTC);
    IF (context.memSizeDays-l_mem_gap) >= OMC_ALLOWED_ERR_RATIO * l_requested_days THEN
      -- not the usuall case, but we serve from memory alone.
      context.diskEnable := FALSE;
      context.memEnable := TRUE;
      context.diag_context_secs := 
          timing_to_seconds(context.diag_start_time, SYSTIMESTAMP);
      RETURN CONTEXT;
    END IF;
    initBaseContextDisk(context);
    IF NOT context.diskEnable THEN
      -- most unusual case: no data on disk
      context.memEnable := TRUE;
      context.diag_context_secs := 
          timing_to_seconds(context.diag_start_time, SYSTIMESTAMP);
      RETURN context;
    END IF;
    IF context.diskEndTimeUTC IS NULL THEN 
      -- end point for disk data is NOW, no need for mmeory data
      context.memEnable := FALSE;
      context.diag_context_secs := 
          timing_to_seconds(context.diag_start_time, SYSTIMESTAMP);
      RETURN context;
    END IF;
    IF (context.diskEndTimeUTC - context.beginTimeUTC < 
         OMC_ALLOWED_ERR_RATIO * l_requested_days) AND
       (context.memSizeDays > l_mem_gap) THEN
      -- disk is not enough and there is something relevant in memory
      context.memEnable := TRUE;
    ELSE
      context.memEnable := FALSE;
    END IF;
    context.diag_context_secs := 
        timing_to_seconds(context.diag_start_time, SYSTIMESTAMP);
    RETURN context;
  END buildBaseContextHistorical;

  PROCEDURE validateBaseContextForData(context IN OUT NOCOPY ContextType)
  IS
  BEGIN
    IF context.error_xml IS NOT NULL THEN
      RETURN;
    END IF;
    IF context.diskEnable THEN
      IF context.disk_comp_ver < VER_12_2 AND 
         (context.diskTZ IS NULL OR context.underscores) THEN
        context.error_xml := error_to_xml(
          'Unsupported use case: DB instances in different time zone or underscore parameters in use',
          'err_underscores_or_tz');
      END IF;
      RETURN;
    END IF;
    IF context.local_comp_ver >= VER_12_2 
       OR context.memTZ IS NOT NULL THEN
      RETURN;
    END IF;
    context.error_xml := error_to_xml(
       'Unsupported use case: DB instances in different time zone',
       'err_multiple_tz');
  END validateBaseContextForData;

  PROCEDURE generate_binds(context IN OUT NOCOPY ContextType,
                           p_use_utc IN BOOLEAN)
  IS
    l_begin_time DATE;
    l_end_time DATE;
    l_mem_begin_time DATE;
  BEGIN
    context.use_utc_binds := p_use_utc;
    l_begin_time := context.beginTimeUTC;
    l_end_time := context.endTimeUTC;
    IF context.memEnable AND context.memSizeDays IS NOT NULL THEN
      l_mem_begin_time := 
         CAST(SYS_EXTRACT_UTC(SYSTIMESTAMP) AS DATE)-context.memSizeDays;
    ELSE
      l_mem_begin_time := l_end_time;
    END IF;
    IF NOT p_use_utc THEN
      l_begin_time := l_begin_time + NVL(context.diskTZ, context.memTZ);
      l_end_time := l_end_time + NVL(context.diskTZ, context.memTZ);
      l_mem_begin_time := l_mem_begin_time + NVL(context.diskTZ, context.memTZ);
    END IF;
    context.binds.EXTEND(21);
    context.binds(1).name := '@AWRTAB@';
    context.binds(1).value := context.awrTablePrefix;
    context.binds(2).name := '@DBID@';
    context.binds(2).value := to_char(context.dbid);
    context.binds(3).name := '@B_SNAP@';
    context.binds(3).value := to_char(NVL(context.beginSnapID,0));
    context.binds(4).name := '@E_SNAP@';
    context.binds(4).value := to_char(NVL(context.endSnapID,10000000000));
    context.binds(5).name := '@BUCK_CNT@';
    context.binds(5).value := to_char(context.bucketCount);
    context.binds(6).name := '@BUCK_SIZE@';
    context.binds(6).value := to_char(context.bucketInterval);
    context.binds(7).name := '@LAST_BUCK_SIZE@';
    context.binds(7).value := to_char(context.lastBucketSize);
    context.binds(8).name := '@MEM@';
    context.binds(8).value := CASE WHEN context.memEnable THEN '1' ELSE '0' END;
    context.binds(9).name := '@DISK@';
    context.binds(9).value := CASE WHEN context.diskEnable THEN '1' ELSE '0' END;
    context.binds(10).name := '@BEGIN_TIME_T@';
    context.binds(10).value :=
       'TO_TIMESTAMP(''' ||
       to_char(l_begin_time,'YYYYMMDDHH24MISS')
       || ''',''YYYYMMDDHH24MISS'')';
    context.binds(11).name := '@END_TIME_T@';
    context.binds(11).value :=
       'TO_TIMESTAMP(''' ||
       to_char(l_end_time,'YYYYMMDDHH24MISS')
       || ''',''YYYYMMDDHH24MISS'')';
    context.binds(12).name := '@BEGIN_TIME_D@';
    context.binds(12).value :=
       'TO_DATE(''' ||
       to_char(l_begin_time,'YYYYMMDDHH24MISS')
       || ''',''YYYYMMDDHH24MISS'')';
    context.binds(13).name := '@END_TIME_D@';
    context.binds(13).value :=
       'TO_DATE(''' ||
       to_char(l_end_time,'YYYYMMDDHH24MISS')
       || ''',''YYYYMMDDHH24MISS'')';
    context.binds(14).name := '@DISK_BEGIN_T@';
    context.binds(14).value := context.binds(10).value;
    context.binds(15).name := '@DISK_END_T@';
    context.binds(15).value :=
       'TO_TIMESTAMP(''' ||
       to_char(l_mem_begin_time,'YYYYMMDDHH24MISS')
       || ''',''YYYYMMDDHH24MISS'')';
    context.binds(16).name := '@ASH_T_COL@';
    context.binds(16).value :=
      CASE WHEN NVL(context.disk_comp_ver,context.local_comp_ver) >= VER_12_2
      THEN 'a.sample_time_utc' ELSE 'a.sample_time' END;
    context.binds(17).name := '@SNAP_ET_COL@';
    context.binds(17).value :=
      CASE WHEN NVL(context.disk_comp_ver,context.local_comp_ver) >= VER_12_2
      THEN 's.end_interval_time-s.snap_timezone' ELSE 's.end_interval_time' END;
    context.binds(18).name := '@SNAP_BT_COL@';
    context.binds(18).value :=
      CASE WHEN NVL(context.disk_comp_ver,context.local_comp_ver) >= VER_12_2
      THEN 's.begin_interval_time-s.snap_timezone' ELSE 's.begin_interval_time' END;
    context.binds(19).name := '@AND_FG_ONLY@';
    IF context.include_bg THEN
      context.binds(19).value := ' ';
    ELSE
      context.binds(19).value := ' AND a.session_type = ''FOREGROUND'' ';
    END IF;
    context.binds(20).name := '@AND_INST_V@';
    IF context.instance_number IS NULL THEN
      context.binds(20).value := ' ';
    ELSE
      context.binds(20).value := ' AND a.instance_number = ' 
          || to_char(context.instance_number);
    END IF;
    context.binds(21).name := '@AND_INST_GVD@';
    IF context.instance_number IS NULL THEN
      context.binds(21).value := ' ';
    ELSE
      context.binds(21).value := ' AND TO_NUMBER(USERENV(''INSTANCE'')) = ' 
          || to_char(context.instance_number);
    END IF;
  END generate_binds;

  -----------------------------------------------------------------------
  -- ***************************************************************** --
  --  Implementation of CPU Info code.
  --  ---------------------------------------
  --  CPU Info is used for displaying the 3 CPU lines
  --  (threads a.k.a. CPUs, Cores, and Limit a.k.a. instance caging).
  --  Public API is getCPUInfo, and before it there are helper functions.
  -- ***************************************************************** --
  -----------------------------------------------------------------------

  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  -- getCPUInfoFromMemory
  --   Returns information about availbale CPUs in XML format for
  --   local system as of NOW.
  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  FUNCTION getCPUInfoFromMemory(context IN OUT NOCOPY ContextType,
                                p_input IN XMLTYPE,
                                p_full_report IN BOOLEAN)
  RETURN   XMLTYPE
  IS
    l_sqltext VARCHAR2(4000);
    l_now     VARCHAR2(30);
    l_inst_pred VARCHAR2(1000);
    l_report  XMLTYPE;
    l_info  XMLTYPE;
  BEGIN
    l_now := TO_CHAR(SYS_EXTRACT_UTC(SYSTIMESTAMP), OMC_TIME_FORMAT);
    IF context.instance_number IS NULL THEN
      l_inst_pred := NULL;
    ELSE
      l_inst_pred := ' WHERE TO_NUMBER(USERENV(''INSTANCE'')) = ' 
          || context.instance_number || ' ';
    END IF;
    l_sqltext := 
      q'[
SELECT xmlelement("cpuinfo",
           xmlattributes(
            :1 as "time",
            num_cpus as "cpus",
            num_cpu_cores as "cores",
            cpu_limit as "limit"
      ))
FROM (
  SELECT SUM(num_cpus) as num_cpus,
         SUM(num_cpu_cores) as num_cpu_cores,
         SUM(LEAST(cpu_limit,num_cpus)) as cpu_limit
  FROM (
    SELECT host_name, AVG(num_cpus) as num_cpus, 
           AVG(num_cpu_cores) as num_cpu_cores, SUM(cpu_limit) as cpu_limit
    FROM   TABLE(GV$(CURSOR(
      SELECT i.instance_number as inst_id, i.host_name, 
             NVL(os.num_cpus, os.num_cpu_cores) as num_cpus,
             NVL(os.num_cpu_cores, os.num_cpus) as num_cpu_cores,
             CASE WHEN (par.res_plan IS NULL 
                        OR par.cpu_count IS NULL
                        OR par.cpu_count = 0) 
                  THEN NVL(os.num_cpus, os.num_cpu_cores)
                  ELSE LEAST(par.cpu_count, NVL(os.num_cpus, os.num_cpu_cores))
                  END as cpu_limit
      FROM   v$instance i, 
             (SELECT MAX(DECODE(stat_name, 'NUM_CPUS', value, NULL)) as num_cpus
                    ,MAX(DECODE(stat_name, 'NUM_CPUS', NULL, value)) as num_cpu_cores
              FROM   v$osstat
              WHERE stat_name IN ('NUM_CPUS', 'NUM_CPU_CORES')
             ) os,
             (SELECT TO_NUMBER(MAX(DECODE(name, 'cpu_count', value, NULL))) as cpu_count
                    ,MAX(DECODE(name, 'cpu_count', NULL, value)) as res_plan
              FROM   v$parameter
              WHERE name IN ('cpu_count', 'resource_manager_plan')
             ) par ]' || l_inst_pred || q'[
    )))
    GROUP BY host_name
  )
) ]';

    EXECUTE IMMEDIATE l_sqltext 
    INTO l_info
    USING l_now;

    IF p_full_report THEN
      SELECT xmlelement("report", p_input, l_info)
      INTO   l_report
      FROM   sys.dual;
      RETURN l_report;
    END IF;
    RETURN l_info;
  END getCPUInfoFromMemory;

  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  -- getCPUInfoFromAWR
  --   Returns information about availbale CPUs in XML format 
  --   from a specific AWR snapshot
  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  FUNCTION getCPUInfoFromAWR(context IN OUT NOCOPY ContextType,
                             p_snap_id IN NUMBER,
                             p_input IN XMLTYPE,
                             p_full_report IN BOOLEAN)
  RETURN   XMLTYPE
  IS
    l_sqltext VARCHAR2(4000);
    l_report  XMLTYPE;
    l_info    XMLTYPE;
    l_snap_id NUMBER := p_snap_id;
    l_inst_pred1 VARCHAR2(1000);
    l_inst_pred2 VARCHAR2(1000);
  BEGIN
    IF context.instance_number IS NULL THEN
      l_inst_pred1 := NULL;
      l_inst_pred2 := NULL;
    ELSE
      l_inst_pred1 := ' AND instance_number = ' || 
                      context.instance_number || ' ';
      l_inst_pred2 := ' AND i.inst_id = ' || context.instance_number || ' ';
    END IF;

    IF l_snap_id IS NULL THEN
      l_sqltext := 
'WITH snaps AS
  (SELECT snap_id, count(*) as cnt
   FROM   ' || context.awrTablePrefix || 'snapshot
   WHERE  dbid = ' || to_char(context.dbid) || l_inst_pred1 ||
   ' AND  snap_id >= ' || to_char(NVL(context.beginSnapID,0)) ||
   ' AND  snap_id <= ' || to_char(NVL(context.endSnapID,1000000000)) ||
'  GROUP BY snap_id)
  SELECT max(snap_id) FROM snaps
  WHERE  cnt = (SELECT max(cnt) FROM snaps) ';
      EXECUTE IMMEDIATE l_sqltext 
      INTO l_snap_id;
      IF l_snap_id IS NULL THEN
        RETURN NULL;
      END IF;
    END IF;
    
    l_sqltext := 
      q'[
SELECT xmlelement("cpuinfo",
           xmlattributes(
            to_char(s_time, ]' ||
      sys.dbms_assert.enquote_literal(OMC_TIME_FORMAT)
  || q'[ ) as "time",
            num_cpus as "cpus",
            num_cpu_cores as "cores",
            cpu_limit as "limit"
      ))
FROM (
  SELECT SUM(num_cpus) as num_cpus,
         SUM(num_cpu_cores) as num_cpu_cores,
         SUM(LEAST(cpu_limit,num_cpus)) as cpu_limit,
         MAX(s_time) as s_time
  FROM (
    SELECT host_name, max(s_time) as s_time, AVG(num_cpus) as num_cpus,
           AVG(num_cpu_cores) as num_cpu_cores, SUM(cpu_limit) as cpu_limit
    FROM (
      SELECT i.inst_id, i.host_name, i.s_time,
             NVL(os.num_cpus, os.num_cpu_cores) as num_cpus,
             NVL(os.num_cpu_cores, os.num_cpus) as num_cpu_cores,
             CASE WHEN (par.res_plan IS NULL
                        OR par.cpu_count IS NULL
                        OR par.cpu_count = 0)
                  THEN NVL(os.num_cpus, os.num_cpu_cores)
                  ELSE LEAST(par.cpu_count, NVL(os.num_cpus, os.num_cpu_cores))
                  END as cpu_limit
      FROM ( SELECT s.instance_number as inst_id,
                    di.host_name as host_name,
                    s.end_interval_time - s.snap_timezone as s_time
             FROM   AWRPREFIXsnapshot s, AWRPREFIXdatabase_instance di
             WHERE  s.dbid = :1 
               AND  s.snap_id = :2
               AND  di.dbid = :3
               AND  di.startup_time = s.startup_time
           ) i,
           ( SELECT instance_number as inst_id
                   ,MAX(DECODE(stat_name, 'NUM_CPUS', value, NULL)) as num_cpus
                   ,MAX(DECODE(stat_name, 'NUM_CPUS', NULL, value)) as num_cpu_cores
             FROM   AWRPREFIXosstat
             WHERE dbid = :4 
               AND snap_id = :5
               AND stat_name IN ('NUM_CPUS', 'NUM_CPU_CORES')
             GROUP BY instance_number
           ) os,
           ( SELECT instance_number as inst_id
                   ,TO_NUMBER(MAX(DECODE(parameter_name, 'cpu_count', value, NULL))) as cpu_count
                   ,MAX(DECODE(parameter_name, 'cpu_count', NULL, value)) as res_plan
             FROM   AWRPREFIXparameter
             WHERE dbid = :6 
               AND snap_id = :7
               AND parameter_name IN ('cpu_count', 'resource_manager_plan')
             GROUP BY instance_number
           ) par
      WHERE i.inst_id = os.inst_id 
        AND i.inst_id = par.inst_id ]' || l_inst_pred2 || q'[
    )
    GROUP BY host_name
  )
) ]';
    l_sqltext := REPLACE(l_sqltext, 'AWRPREFIX', context.awrTablePrefix);

    EXECUTE IMMEDIATE l_sqltext 
    INTO l_info
    USING context.dbid, l_snap_id, context.dbid, 
          context.dbid, l_snap_id, context.dbid, l_snap_id;

    IF p_full_report THEN
      SELECT xmlelement("report", p_input, l_info)
      INTO   l_report
      FROM   sys.dual;
      RETURN l_report;
    END IF;
    RETURN l_info;
  END getCPUInfoFromAWR;

  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  -- getCPUInfoReport
  --   Returns information about availbale CPUs in XML format at a single 
  --   point in time.
  --    - dbid : specifies which db to look for, default (NULL) is DB we are
  --             conncted to.
  --    - observationTime : approximate time in which to look for data.
  --             default (NULL) is the latest possible data available 
  --             (NOW if possible).
  --  
  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  FUNCTION getCPUInfoReport(dbid IN NUMBER := NULL,
                            observationTime IN VARCHAR := NULL,
                            instance_number IN NUMBER := NULL) 
  RETURN XMLTYPE
  IS
    context    ContextType := 
          initBaseContext(dbid,'n','n','n',instance_number,'n');
    l_input    XMLTYPE;
    l_sqltext  VARCHAR2(4000);
    l_end_time DATE;
    l_begin_time DATE;
    l_end_snap NUMBER;
    l_begin_snap NUMBER;
    l_req_time DATE;
    l_req_timestamp TIMESTAMP;
    l_now      DATE;
    l_empty    XMLTYPE;
    l_inst     NUMBER;
    l_inst_pred VARCHAR2(1000);
  BEGIN
    -- create the input header
    SELECT xmlelement("input",xmlattributes(
             dbid as "dbid", observationTime as "requested_time",
             instance_number as "instance_number"))
    INTO   l_input
    FROM   SYS.DUAL;

    -- check the instance number
    IF context.instance_number is NULL THEN
      l_inst := NULL;
      l_inst_pred := NULL;
    ELSE
      l_inst := context.instance_number;
      l_inst_pred := ' AND instance_number = ' || l_inst || ' ';
    END IF;

    -- first case: current system
    IF dbid IS NULL OR dbid = context.local_dbid THEN 
      IF observationTime IS NULL THEN
        RETURN getCPUInfoFromMemory(context,l_input,TRUE);
      ELSE 
        l_sqltext := 
          'SELECT MAX(snap_id), 
                  CAST(MAX(end_interval_time-snap_timezone) AS DATE)
           FROM ' || context.awrTablePrefix || 'SNAPSHOT WHERE dbid = :1'
           || l_inst_pred;
        EXECUTE IMMEDIATE l_sqltext
        INTO    l_end_snap, l_end_time
        USING   context.local_dbid;
        IF l_end_snap IS NULL THEN
          -- No AWR data available.
          RETURN getCPUInfoFromMemory(context,l_input,TRUE);
        END IF;
        -- AWR available
        l_req_time := TO_DATE(observationTime, OMC_TIME_FORMAT);
        l_now := CAST(SYS_EXTRACT_UTC(SYSTIMESTAMP) AS DATE);
        IF l_req_time >= l_end_time THEN
          IF l_now - l_req_time < l_req_time - l_end_time THEN
            -- Current memory data closer than AWR data in time
            RETURN getCPUInfoFromMemory(context, l_input,TRUE); 
          ELSE 
            context.dbid := context.local_dbid;
            RETURN getCPUInfoFromAWR(context, l_end_snap, l_input, TRUE);
          END IF;
        END IF;
      END IF;
      -- If we are here, we need to find the appropriate place in AWR.
      -- This is the same as imported snapshots.
    END IF;

    -- second case: imported snapshots (or current system from AWR)
    IF observationTime IS NULL THEN 
      -- case second(1): getting latest data
      l_sqltext := 
        'SELECT MAX(snap_id)
         FROM ' || context.awrTablePrefix || 'SNAPSHOT WHERE dbid = :1'
         || l_inst_pred;
      EXECUTE IMMEDIATE l_sqltext
      INTO    l_end_snap
      USING   context.dbid;
      IF l_end_snap IS NULL THEN
        -- No AWR data available.
        SELECT xmlelement("report", l_input, 
                 xmlelement("error",'No Data in AWR'))
        INTO   l_empty 
        FROM   SYS.dual;
        RETURN l_empty;
      END IF;
      RETURN getCPUInfoFromAWR(context, l_end_snap, l_input, TRUE);
    END IF;
    -- case second(2): get specific time
    l_req_timestamp := TO_TIMESTAMP(observationTime, OMC_TIME_FORMAT);
    l_sqltext := 
      'SELECT MAX(CASE WHEN end_interval_time-snap_timezone <= :1 
                  THEN snap_id ELSE NULL END),
              MIN(CASE WHEN end_interval_time-snap_timezone >= :2 
                  THEN snap_id ELSE NULL END)
       FROM ' || context.awrTablePrefix || 'SNAPSHOT
       WHERE dbid = :3' || l_inst_pred;
    EXECUTE IMMEDIATE l_sqltext
    INTO    l_begin_snap, l_end_snap
    USING   l_req_timestamp, l_req_timestamp, context.dbid;
    IF l_begin_snap IS NULL AND l_end_snap IS NULL THEN
      SELECT xmlelement("report", l_input,
                 xmlelement("error",'No Data in AWR'))
      INTO   l_empty
      FROM   SYS.dual;
      RETURN l_empty;
    END IF;
    RETURN getCPUInfoFromAWR(context, 
                             GREATEST(NVL(l_begin_snap, l_end_snap),
                                      NVL(l_end_snap, l_begin_snap)),
                             l_input, TRUE);
  END getCPUInfoReport;


  FUNCTION internalGetCPU(context IN OUT NOCOPY ContextType)
  RETURN XMLTYPE
  IS
    l_time TIMESTAMP := SYSTIMESTAMP;
    l_cpu  XMLTYPE := NULL;
  BEGIN
    IF context.is_local THEN
      IF context.memEnable THEN
         l_cpu := getCPUInfoFromMemory(context, NULL, FALSE);
      ELSE
         l_cpu := getCPUInfoFromAWR(context, NULL, NULL, FALSE);
         IF l_cpu IS NULL THEN
           l_cpu := getCPUInfoFromMemory(context, NULL, FALSE);
         END IF;
      END IF;
    ELSE
      l_cpu := getCPUInfoFromAWR(context, NULL, NULL, FALSE);
    END IF;
    context.diag_cpuinfo_secs := timing_to_seconds(l_time, SYSTIMESTAMP);
    RETURN l_cpu;
  END internalGetCPU;

  -----------------------------------------------------------------------
  -- ***************************************************************** --
  --  Implementation of Time Picker
  --  ---------------------------------------
  --  Time Picker is used for displaying a stacked graph of CPU
  --  I/O and Other waits over time.
  --  It is always for Foreground only and for the entire DB we are 
  --  connected to (or entire DB for AWR snapshots).
  --  Public APIs are:
  --    getTimePickerRealTime - For initializing Real Time Use case
  --    incrementTimePicker - For getting extra data to increment
  --                          the Real Time data after some time is passed
  --    getTimePickerHistorical - For historical use case.
  --
  --  Before the public APIs we have the actual implementation using
  --  Helper functions. 
  --  Each API constructs a ContextType element to identify time period
  --  and data sources, and then calls getTimePickerReport to construct 
  --  the report.
  -- ***************************************************************** --
  -----------------------------------------------------------------------

  PROCEDURE appendTimePickerSource(context IN OUT NOCOPY ContextType)
  IS
    l_sqltext VARCHAR2(4000);
    l_use_joins BOOLEAN;
    l_disk_source_name VARCHAR2(30);
  BEGIN
    ----------------
    -- MEMORY SOURCE
    ----------------
    IF context.memEnable THEN
      IF context.diskEnable THEN
        l_sqltext := ' mem_source';
      ELSE 
        l_sqltext := ' combined_source';
      END IF;
      l_sqltext := l_sqltext || 
q'[ AS (
    SELECT /*+ NO_MERGE */
          inst_id, bucket_id, 
          on_cpu, io_wait, other_wait, min_sample_id
    FROM TABLE(GV$(CURSOR( 
      SELECT TO_NUMBER(USERENV('INSTANCE')) as inst_id, bucket_id,
             SUM(on_cpu) as on_cpu,
             SUM(io_wait) as io_wait,
             SUM(other_wait) as other_wait,
             MIN(sample_id) as min_sample_id
      FROM ( 
        SELECT TRUNC(86400*((CAST(@ASH_T_COL@ AS DATE)@TZ_SHIFT@)-@BEGIN_TIME_D@ )
                    / @BUCK_SIZE@ ) as bucket_id,
                CASE WHEN a.session_state = 'ON CPU'
                     THEN @TPR@ ELSE 0 END as on_cpu,
                CASE WHEN (a.session_state = 'WAITING'
                           AND a.wait_class IN ('User I/O','System I/O'))
                     THEN @TPR@ ELSE 0 END as io_wait,
                CASE WHEN (a.session_state = 'WAITING'
                           AND NOT (a.wait_class IN ('User I/O','System I/O')))
                     THEN @TPR@ ELSE 0 END as other_wait,
                a.sample_id
         FROM   @INFO_TABLE@ V$ACTIVE_SESSION_HISTORY a
         WHERE  CAST(@ASH_T_COL@ AS DATE)@TZ_SHIFT@ >=  @BEGIN_TIME_D@
           AND  CAST(@ASH_T_COL@ AS DATE)@TZ_SHIFT@ < @END_TIME_D@
           AND  a.session_type = 'FOREGROUND'
           AND  (a.session_state = 'ON CPU' 
                OR a.wait_class <> 'Idle') @CON_ID_PRED@ @AND_INST_GVD@
     ) 
     GROUP BY bucket_id)))) ]';

      IF context.local_comp_ver < VER_12_2 AND context.use_utc_binds THEN
        l_sqltext := REPLACE(l_sqltext, '@TZ_SHIFT@', '-ai.tz');
      ELSE
        l_sqltext := REPLACE(l_sqltext, '@TZ_SHIFT@', NULL);
      END IF;

      IF context.local_comp_ver >= VER_12_2 THEN
        l_sqltext := REPLACE(l_sqltext, '@INFO_TABLE@', NULL);
        l_sqltext := REPLACE(l_sqltext, '@TPR@', 'a.usecs_per_row/1000000');
      ELSE
        l_sqltext := REPLACE(l_sqltext, '@INFO_TABLE@',
 '(SELECT 86400*(CAST(latest_sample_time AS DATE) - CAST(oldest_sample_time AS DATE))
                 / (latest_sample_id - oldest_sample_id) as tpr,
                 ROUND(96*(CAST(latest_sample_time AS DATE) - CAST(
                       SYS_EXTRACT_UTC(SYSTIMESTAMP) AS DATE)),0)/96 as tz
          FROM V$ASH_INFO
          WHERE ROWNUM <= 1 @CON_ID_0@
         ) ai, ');
        l_sqltext := REPLACE(l_sqltext, '@TPR@', 'ai.tpr');
      END IF;

      -- do this last because @INFO_TABLE@ contains more replacement strings.
      -- this is needed because in CDB the default con_id predicates do not work properly.
      IF context.local_is_pdb THEN
        l_sqltext := REPLACE(l_sqltext, '@CON_ID_PRED@', 
           ' AND a.con_id = ' || context.local_conid);
        l_sqltext := REPLACE(l_sqltext, '@CON_ID_0@', ' AND con_id = 0 ');
      ELSE
        l_sqltext := REPLACE(l_sqltext, '@CON_ID_PRED@', NULL);
        l_sqltext := REPLACE(l_sqltext, '@CON_ID_0@', NULL);
      END IF;

      addQueryBlock(context, l_sqltext, TRUE);
    END IF;

    ----------------
    -- DISK SOURCE
    ----------------
    IF context.diskEnable THEN
      -- If we also have memory, get the lower memory time in UTC
      -- for stitching disk and memory data.
      IF context.memEnable THEN
        l_disk_source_name := ' disk_source';
        l_sqltext := 
' ,mem_times AS (
  SELECT /*+ NO_MERGE */ inst_id, 
         MIN(min_sample_id) as min_sample_id
  FROM   mem_source
  GROUP BY inst_id
), ';
        addQueryBlock(context, l_sqltext, FALSE);
      ELSE
        l_disk_source_name := ' combined_source';
      END IF;

      -- determine if complicated joins are needed to take care of time zone 
      -- changes and usage of underscore parameters.
      IF context.disk_comp_ver >= VER_12_2 OR NOT context.use_utc_binds THEN
        l_use_joins := FALSE;
      ELSE
        l_use_joins := TRUE;
      END IF;

      -- add the time zone and parameter information in some query blocks.
      IF l_use_joins THEN
        -- step 1: use parameter table to get the time per row.
        l_sqltext :=
q'[ params AS
    (SELECT /*+ NO_MERGE */
            inst_id, snap_id, NVL(p1,1)*NVL(p2,10) as sec_per_row
     FROM (
       SELECT a.instance_number as inst_id,
              a.snap_id as snap_id,
              DECODE(a.parameter_name, '_ash_sampling_interval',
                   to_number(a.value)/1000,NULL) as p1,
              DECODE(a.parameter_name, '_ash_disk_filter_ratio',
                     to_number(a.value),NULL) as p2
       FROM @AWRTAB@parameter a
       WHERE  a.dbid = @DBID@ @AND_INST_V@
         AND  a.snap_id >= @B_SNAP@
         AND  a.snap_id <= @E_SNAP@
         AND  a.parameter_name IN
              ('_ash_sampling_interval','_ash_disk_filter_ratio')
       )) ]';
         addQueryBlock(context, l_sqltext, TRUE);
         -- step 2: find timezone information from snapshots
         --         use the latest snapshot from each instance as
         --         default timezone in case the snapshot information
         --         is not available.
         l_sqltext :=
q'[ ,max_snaps AS
    (SELECT /*+ NO_MERGE */
            ms.instance_number as inst_id,
            ms.snap_timezone as tz
     FROM @AWRTAB@SNAPSHOT ms
     WHERE  ms.dbid = @DBID@
       AND (ms.instance_number, ms.snap_id) IN
            (SELECT a.instance_number, max(a.snap_id) as snap_id
             FROM @AWRTAB@SNAPSHOT a
             WHERE  a.dbid = @DBID@ @AND_INST_V@
       AND  a.snap_id >= @B_SNAP@
       AND  a.snap_id <= @E_SNAP@
     GROUP BY a.instance_number)
    )
 ,snaps AS
    (SELECT /*+ NO_MERGE */
            a.instance_number as inst_id, a.snap_id, a.snap_timezone as tz
     FROM  @AWRTAB@SNAPSHOT a
     WHERE  a.dbid = @DBID@ @AND_INST_V@
       AND  a.snap_id >= @B_SNAP@
       AND  a.snap_id <= @E_SNAP@
  ) ]';
         addQueryBlock(context, l_sqltext, TRUE);
      END IF;

      -- Step 3: Main data block.
      -- several cases exist:
      -- 1. Use of complicated joins. We need to join to the snaps, and max_snaps
      --    query blocks. Also modify timezone
      -- 2. No complicated joins in 12.2: just need to handle time_per_row from ASH
      -- 3. No complicated joins in 12.1, 11g: binds are in local timezone so just
      --    handle TPR as 10 seconds. 
      IF l_use_joins THEN 
         l_sqltext := ', data';
      ELSE
         l_sqltext := l_disk_source_name;
      END IF;  
      l_sqltext := l_sqltext || 
q'[ AS
   (SELECT inst_id @TZ_GROUP@ , bucket_id,
           SUM(on_cpu) as on_cpu,
           SUM(io_wait) as io_wait,
           SUM(other_wait) as other_wait
    FROM ( @BEGIN_MEM_BOUNDARY@
     SELECT TRUNC(86400*(CAST((@ASH_T_COL@ @TZ_SHIFT@) 
       AS DATE)-@BEGIN_TIME_D@
       ) / @BUCK_SIZE@ ) as bucket_id,
               CASE WHEN a.session_state = 'ON CPU'
                    THEN @TPR@ ELSE 0 END as on_cpu,
               CASE WHEN (a.session_state = 'WAITING'
                          AND a.wait_class IN ('User I/O','System I/O'))
                    THEN @TPR@ ELSE 0 END as io_wait,
               CASE WHEN (a.session_state = 'WAITING'
                          AND NOT (a.wait_class IN ('User I/O','System I/O')))
                    THEN @TPR@ ELSE 0 END as other_wait,
               a.instance_number as inst_id,
               a.snap_id, a.sample_id
      FROM  @AWRTAB@ACTIVE_SESS_HISTORY a @TZ_TABLES@
    WHERE  a.dbid = @DBID@ @AND_INST_V@
      AND  a.snap_id >= @B_SNAP@
      AND  a.snap_id <= @E_SNAP@
      AND  @ASH_T_COL@ @TZ_SHIFT@ >= @BEGIN_TIME_T@
      AND  @ASH_T_COL@ @TZ_SHIFT@ < @END_TIME_T@
      AND  a.session_type = 'FOREGROUND'
      AND  (a.session_state = 'ON CPU' OR a.wait_class <> 'Idle'
           ) @TZ_PREDS@  @END_MEM_BOUNDARY@ ) 
    GROUP BY inst_id @TZ_GROUP@ , bucket_id)]';

      IF l_use_joins THEN
        l_sqltext := REPLACE(l_sqltext, '@TZ_SHIFT@', '-NVL(snaps.tz,max_snaps.tz)');
        l_sqltext := REPLACE(l_sqltext, '@TPR@', '1');
        l_sqltext := REPLACE(l_sqltext, '@TZ_TABLES@', ', max_snaps, snaps');
        l_sqltext := REPLACE(l_sqltext, '@TZ_PREDS@', 
' AND  a.instance_number = max_snaps.inst_id
      AND  a.instance_number = snaps.inst_id(+)
      AND  a.snap_id = snaps.snap_id(+) ');
        l_sqltext := REPLACE(l_sqltext, '@TZ_GROUP@', ', snap_id');
      ELSE
        l_sqltext := REPLACE(l_sqltext, '@TZ_SHIFT@', NULL);
        IF context.disk_comp_ver >= VER_12_2 THEN
          l_sqltext := REPLACE(l_sqltext, '@TPR@', 'a.usecs_per_row/1000000');
        ELSE
          l_sqltext := REPLACE(l_sqltext, '@TPR@', '10');
        END IF;
        l_sqltext := REPLACE(l_sqltext, '@TZ_TABLES@', NULL);
        l_sqltext := REPLACE(l_sqltext, '@TZ_PREDS@', NULL);
        l_sqltext := REPLACE(l_sqltext, '@TZ_GROUP@', NULL);
      END IF;

      -- memory boundary (outer join with mem and then a filter) is used in 
      -- case both memory and disk sources are in use. 
      IF context.memEnable THEN
         l_sqltext := REPLACE(l_sqltext, '@BEGIN_MEM_BOUNDARY@',
' SELECT * FROM (
  SELECT x.bucket_id, x.on_cpu, x.io_wait, x.other_wait,
         x.inst_id, x.snap_id, x.sample_id, m.min_sample_id FROM ( ');
         l_sqltext := REPLACE(l_sqltext, '@END_MEM_BOUNDARY@',
' ) x, mem_times m WHERE x.inst_id = m.inst_id(+)
  ) WHERE min_sample_id IS NULL OR sample_id < min_sample_id ');
      ELSE
        l_sqltext := REPLACE(l_sqltext, '@BEGIN_MEM_BOUNDARY@', NULL);
        l_sqltext := REPLACE(l_sqltext, '@END_MEM_BOUNDARY@', NULL);
      END IF;

      addQueryBlock(context, l_sqltext, TRUE);

      IF l_use_joins THEN 
         -- step 4: combine the bucket data with time per row data.
         l_sqltext := ' ,' || l_disk_source_name || 
q'[ AS
    (SELECT data.inst_id, data.bucket_id,
            SUM(data.on_cpu * NVL(params.sec_per_row,10)) as on_cpu,
            SUM(data.io_wait * NVL(params.sec_per_row,10)) as io_wait,
            SUM(data.other_wait * NVL(params.sec_per_row,10)) as other_wait
     FROM   data, params
     WHERE  data.inst_id = params.inst_id(+)
       AND  data.snap_id = params.snap_id(+)
     GROUP BY data.inst_id, data.bucket_id
    ) ]';
         addQueryBlock(context, l_sqltext, FALSE);
      END IF;
    END IF;

    --------------------------------------
    -- COMBINE THE DISK AND MEMORY SOURCES
    --------------------------------------
    IF context.diskEnable AND context.memEnable THEN
      l_sqltext := 
' ,combined_source AS (
  SELECT NVL(m.inst_id, d.inst_id) as inst_id,
         NVL(m.bucket_id, d.bucket_id) as bucket_id,
         NVL(m.on_cpu,0)+NVL(d.on_cpu,0) as on_cpu,
         NVL(m.io_wait,0)+NVL(d.io_wait,0) as io_wait,
         NVL(m.other_wait,0)+NVL(d.other_wait,0) as other_wait
  FROM   mem_source m FULL OUTER JOIN disk_source d
    ON   (m.inst_id = d.inst_id AND m.bucket_id = d.bucket_id)
) ';
      addQueryBlock(context, l_sqltext, FALSE);
    END IF;

    --------------------------------------
    -- COMBINE THE INSTANCES FOR DB LEVEL 
    --------------------------------------
    l_sqltext := 
' ,rac_data AS (
 SELECT bucket_id, sum(on_cpu) as on_cpu,
        sum(io_wait) as io_wait, sum(other_wait) as other_wait
 FROM combined_source GROUP BY bucket_id ORDER BY bucket_id ) ';
    addQueryBlock(context, l_sqltext, FALSE);
  END appendTimePickerSource;

  FUNCTION getTimePickerReport(context IN OUT NOCOPY ContextType,
                               p_input IN OUT NOCOPY XMLTYPE)
  RETURN XMLTYPE
  IS
    l_report XMLTYPE;
    l_base   XMLTYPE := NULL;
    l_cpu    XMLTYPE := NULL;
    l_timing XMLTYPE;
    l_text   VARCHAR2(4000);
  BEGIN
    -- IF no data sources are enabled: return error report.
    IF NOT context.memEnable AND NOT context.diskEnable THEN
      IF context.show_sql THEN
        print_context(context);
      END IF;
      context.error_xml := error_to_xml(
          'No data sources to query', 
          'err_no_data_source');
      RETURN createErrorReport(context, p_input);
    END IF;

--context.underscores := TRUE;
    IF NVL(context.disk_comp_ver,context.local_comp_ver) < VER_12_2 
       AND context.diskTZ IS NOT NULL 
       AND NOT context.underscores 
    THEN
      -- We genrate binds with a timezone shift so they are in the data's
      -- time zone. This is done because we do not have UTC timestamps 
      -- (version < 12.2) but we have a constant time zone so we can use
      -- the regular sample_time column as is.
      generate_binds(context, FALSE);
    ELSE
      -- Generate binds in UTC.
      -- Eitehr we are in 12.2 or above RDBMS so UTC timestamps 
      -- are available in ASH, or we have a complicated situation with 
      -- multiple time zones or usage of underscore parameters
      -- so we need multiple joins to get the UTC timestamp anyway.
      generate_binds(context, TRUE);
    END IF;
    
    IF context.show_sql THEN
      print_context(context);
    END IF;

    -- start the query
    resetQuery(context);
    addQueryBlock(context, 'WITH ', FALSE);
    appendTimePickerSource(context);

    -- Finish the base data using the data source SQL provided.
    IF context.verbose_xml THEN
      l_text :=
q'[ SELECT xmlelement("timepicker",
               xmlelement("mem_map",
                 xmlelement("mem",xmlattributes('CPU' as "name", '1' as "id")),
                 xmlelement("mem",xmlattributes('User I/O' as "name", '2' as "id")),
                 xmlelement("mem",xmlattributes('Other waits' as "name", '3' as "id"))
               ), hist_data )
  FROM (SELECT XMLELEMENT("histogram",
           xmlattributes(]' 
  || to_char(context.bucketCount) || ' as "bucket_count", '
  || to_char(context.bucketInterval) || ' as "bucket_interval", '
  || to_char(context.lastBucketSize) || ' as "last_bucket_interval"),
     XMLAGG(
       XMLELEMENT("bucket",
          XMLATTRIBUTES(
              bucket_id+1 as "number",
              round(on_cpu+io_wait+other_wait,2) as "count"),
  decode(on_cpu, 0, NULL, 
         xmlelement("mem",xmlattributes(''1'' as "id", round(on_cpu,2) as "count"))),
  decode(io_wait, 0, NULL, 
         xmlelement("mem",xmlattributes(''2'' as "id", round(io_wait,2) as "count"))),
  decode(other_wait, 0, NULL, 
         xmlelement("mem",xmlattributes(''3'' as "id", round(other_wait,2) as "count")))
                 ))) as hist_data FROM rac_data)';
    ELSE
      l_text := 
' SELECT xmlelement("timepicker", xmlattributes('
  || to_char(context.bucketCount) || ' as "bucket_count", '
  || to_char(context.bucketInterval) || ' as "bucket_interval", '
  || to_char(context.lastBucketSize) || ' as "last_bucket_interval"),
     XMLAGG(
       XMLELEMENT("b",
          XMLATTRIBUTES(
              bucket_id+1 as "n",
              round(on_cpu,2) as "c",
              round(io_wait,2) as "i",
              round(other_wait,2) as "o"
       )))) FROM rac_data';
    END IF;
    addQueryBlock(context, l_text, FALSE);
    l_base := executeQuery(context, FALSE);
    l_cpu := internalGetCPU(context);
    
    -- Construct the report.
    l_timing := timing_to_xml(context);
    SELECT xmlelement("report", 
             xmlattributes(
               to_char(context.beginTimeUTC,OMC_TIME_FORMAT) as "begin_time",
               to_char(context.endTimeUTC,OMC_TIME_FORMAT) as "end_time",
               to_char(ROUND(NVL(context.diskTZ,context.memTZ)*24,2)) as "time_zone",
               REPORT_INTERNAL_VERSION as "xml_version")
             ,l_timing ,p_input, l_cpu, l_base)
    INTO l_report FROM SYS.DUAL;
    RETURN l_report;
  END getTimePickerReport;

  -----------------------------------------------------------------------
  -- ***************************************************************** --
  --  Implementation of Getting ASH Data
  --  ---------------------------------------
  --  Public APIs are:
  --    getDataRealTime - For initializing Real Time Use case
  --    incrementData - For getting extra data to increment
  --                          the Real Time data after some time is passed
  --    getDataHistorical - For historical use case.
  --
  --  Before the public APIs we have the actual implementation using
  --  Helper functions. 
  --  Each API constructs a ContextType element to identify time period
  --  and data sources, and then calls getashdata to construct 
  --  the report.
  -- ***************************************************************** --
  -----------------------------------------------------------------------

  PROCEDURE appendTimePickerDataSource(context IN OUT NOCOPY ContextType)
  IS
    l_sqltext VARCHAR2(4000);
    l_use_joins BOOLEAN;
    l_disk_source_name VARCHAR2(30);
  BEGIN
    ----------------
    -- MEMORY SOURCE
    ----------------
    IF context.memEnable THEN
      IF context.diskEnable THEN
        l_sqltext := ' mem_source';
      ELSE 
        l_sqltext := ' combined_source';
      END IF;
      l_sqltext := l_sqltext || 
q'[ AS (
    SELECT /*+ NO_MERGE */
          inst_id, bucket_id, 
          filtered_cnt, total_sec, filtered_sec, min_sample_id
    FROM TABLE(GV$(CURSOR( 
      SELECT TO_NUMBER(USERENV('INSTANCE')) as inst_id, bucket_id,
             SUM(is_filtered) as filtered_cnt,
             SUM(tpr) as total_sec,
             SUM(is_filtered * tpr) as filtered_sec,
             MIN(sample_id) as min_sample_id
      FROM ( 
        SELECT CASE WHEN (]' || NVL(context.gvFilterPredicate,'1=1');
      addQueryBlock(context, l_sqltext, FALSE);
      l_sqltext := 
q'[         )  THEN 1 ELSE 0 END as is_filtered, @TPR@ as tpr,
               TRUNC(86400*((CAST(@ASH_T_COL@ AS DATE)@TZ_SHIFT@)-@BEGIN_TIME_D@ )
                   / @BUCK_SIZE@ ) as bucket_id,
               a.sample_id
         FROM   @INFO_TABLE@ V$ACTIVE_SESSION_HISTORY a
         WHERE  CAST(@ASH_T_COL@ AS DATE)@TZ_SHIFT@ >=  @BEGIN_TIME_D@
           AND  CAST(@ASH_T_COL@ AS DATE)@TZ_SHIFT@ < @END_TIME_D@
           AND  (a.session_state = 'ON CPU' 
            OR a.wait_class <> 'Idle') @DISK_PRED@ @AND_FG_ONLY@ @AND_INST_GVD@
     ) 
     GROUP BY bucket_id)))) ]';

      IF context.local_comp_ver < VER_12_2 AND context.use_utc_binds THEN
        l_sqltext := REPLACE(l_sqltext, '@TZ_SHIFT@', '-ai.tz');
      ELSE
        l_sqltext := REPLACE(l_sqltext, '@TZ_SHIFT@', NULL);
      END IF;

      IF context.local_comp_ver >= VER_12_2 THEN
        l_sqltext := REPLACE(l_sqltext, '@INFO_TABLE@', NULL);
        l_sqltext := REPLACE(l_sqltext, '@TPR@', 'a.usecs_per_row/1000000');
      ELSE
        l_sqltext := REPLACE(l_sqltext, '@INFO_TABLE@',
 '(SELECT 86400*(CAST(latest_sample_time AS DATE) - CAST(oldest_sample_time AS DATE))
                 / (latest_sample_id - oldest_sample_id) as tpr,
                 ROUND(96*(CAST(latest_sample_time AS DATE) - CAST(
                       SYS_EXTRACT_UTC(SYSTIMESTAMP) AS DATE)),0)/96 as tz
          FROM V$ASH_INFO
          WHERE ROWNUM <= 1
         ) ai, ');
        l_sqltext := REPLACE(l_sqltext, '@TPR@', 'ai.tpr');
      END IF;

      IF context.diskEnable THEN
        l_sqltext := REPLACE(l_sqltext, '@DISK_PRED@', 
' AND a.is_awr_sample = ''Y'' AND bitand(a.flags,128)=0 ');
      ELSE 
        l_sqltext := REPLACE(l_sqltext, '@DISK_PRED@', NULL); 
      END IF;

      addQueryBlock(context, l_sqltext, TRUE);
    END IF;

    ----------------
    -- DISK SOURCE
    ----------------
    IF context.diskEnable THEN
      -- If we also have memory, get the lower memory time in UTC
      -- for stitching disk and memory data.
      IF context.memEnable THEN
        l_disk_source_name := ' disk_source';
        l_sqltext := 
' ,mem_times AS (
  SELECT /*+ NO_MERGE */ inst_id, 
         MIN(min_sample_id) as min_sample_id
  FROM   mem_source
  GROUP BY inst_id
), ';
        addQueryBlock(context, l_sqltext, FALSE);
      ELSE
        l_disk_source_name := ' combined_source';
      END IF;

      -- determine if complicated joins are needed to take care of time zone 
      -- changes and usage of underscore parameters.
      IF context.disk_comp_ver >= VER_12_2 OR NOT context.use_utc_binds THEN
        l_use_joins := FALSE;
      ELSE
        l_use_joins := TRUE;
      END IF;

      -- add the time zone and parameter information in some query blocks.
      IF l_use_joins THEN
        -- step 1: use parameter table to get the time per row.
        l_sqltext :=
q'[ params AS
    (SELECT /*+ NO_MERGE */
            inst_id, snap_id, NVL(p1,1)*NVL(p2,10) as sec_per_row
     FROM (
       SELECT a.instance_number as inst_id,
              a.snap_id as snap_id,
              DECODE(a.parameter_name, '_ash_sampling_interval',
                   to_number(a.value)/1000,NULL) as p1,
              DECODE(a.parameter_name, '_ash_disk_filter_ratio',
                     to_number(a.value),NULL) as p2
       FROM @AWRTAB@parameter a
       WHERE  a.dbid = @DBID@ @AND_INST_V@
         AND  a.snap_id >= @B_SNAP@
         AND  a.snap_id <= @E_SNAP@
         AND  a.parameter_name IN
              ('_ash_sampling_interval','_ash_disk_filter_ratio')
       )) ]';
         addQueryBlock(context, l_sqltext, TRUE);
         -- step 2: find timezone information from snapshots
         --         use the latest snapshot from each instance as
         --         default timezone in case the snapshot information
         --         is not available.
         l_sqltext :=
q'[ ,max_snaps AS
    (SELECT /*+ NO_MERGE */
            ms.instance_number as inst_id,
            ms.snap_timezone as tz
     FROM @AWRTAB@SNAPSHOT ms
     WHERE  ms.dbid = @DBID@
       AND (ms.instance_number, ms.snap_id) IN
            (SELECT a.instance_number, max(a.snap_id) as snap_id
             FROM @AWRTAB@SNAPSHOT a
             WHERE  a.dbid = @DBID@ @AND_INST_V@
       AND  a.snap_id >= @B_SNAP@
       AND  a.snap_id <= @E_SNAP@
     GROUP BY a.instance_number)
    )
 ,snaps AS
    (SELECT /*+ NO_MERGE */
            a.instance_number as inst_id, a.snap_id, a.snap_timezone as tz
     FROM  @AWRTAB@SNAPSHOT a
     WHERE  a.dbid = @DBID@ @AND_INST_V@
       AND  a.snap_id >= @B_SNAP@
       AND  a.snap_id <= @E_SNAP@
  ) ]';
         addQueryBlock(context, l_sqltext, TRUE);
      END IF;

      -- Step 3: Main data block.
      -- several cases exist:
      -- 1. Use of complicated joins. We need to join to the snaps, and max_snaps
      --    query blocks. Also modify timezone
      -- 2. No complicated joins in 12.2: just need to handle time_per_row from ASH
      -- 3. No complicated joins in 12.1, 11g: binds are in local timezone so just
      --    handle TPR as 10 seconds. 
      IF l_use_joins THEN 
         l_sqltext := ', data';
      ELSE
         l_sqltext := l_disk_source_name;
      END IF;  
      l_sqltext := l_sqltext || 
q'[ AS
   (SELECT inst_id @TZ_GROUP@ , bucket_id,
             SUM(is_filtered) as filtered_cnt,
             SUM(tpr) as total_sec,
             SUM(is_filtered * tpr) as filtered_sec
    FROM ( @BEGIN_MEM_BOUNDARY@
     SELECT CASE WHEN (]';
      IF l_use_joins THEN
        l_sqltext := REPLACE(l_sqltext, '@TZ_GROUP@', ', snap_id');
      ELSE
        l_sqltext := REPLACE(l_sqltext, '@TZ_GROUP@', NULL);
      END IF;
      IF context.memEnable THEN
         l_sqltext := REPLACE(l_sqltext, '@BEGIN_MEM_BOUNDARY@',
' SELECT * FROM (
  SELECT x.bucket_id, x.is_filtered, x.tpr,
         x.inst_id, x.snap_id, x.sample_id, m.min_sample_id FROM ( ');
      ELSE
         l_sqltext := REPLACE(l_sqltext, '@BEGIN_MEM_BOUNDARY@', NULL);
      END IF;
      addQueryBlock(context, l_sqltext, FALSE);
      addQueryBlock(context, NVL(context.diskFilterPredicate,'1=1'), FALSE);
      l_sqltext := 
q'[          ) THEN 1 ELSE 0 END as is_filtered, @TPR@ as tpr,
            TRUNC(86400*(CAST((@ASH_T_COL@ @TZ_SHIFT@) 
       AS DATE)-@BEGIN_TIME_D@
       ) / @BUCK_SIZE@ ) as bucket_id,
               a.instance_number as inst_id,
               a.snap_id, a.sample_id
      FROM  @AWRTAB@ACTIVE_SESS_HISTORY a @TZ_TABLES@
    WHERE  a.dbid = @DBID@ @AND_INST_V@
      AND  a.snap_id >= @B_SNAP@
      AND  a.snap_id <= @E_SNAP@
      AND  @ASH_T_COL@ @TZ_SHIFT@ >= @BEGIN_TIME_T@
      AND  @ASH_T_COL@ @TZ_SHIFT@ < @END_TIME_T@
      AND  (a.session_state = 'ON CPU' OR a.wait_class <> 'Idle'
           ) @AND_FG_ONLY@ @TZ_PREDS@  @END_MEM_BOUNDARY@ ) 
    GROUP BY inst_id @TZ_GROUP@ , bucket_id)]';

      IF l_use_joins THEN
        l_sqltext := REPLACE(l_sqltext, '@TZ_SHIFT@', '-NVL(snaps.tz,max_snaps.tz)');
        l_sqltext := REPLACE(l_sqltext, '@TPR@', '1');
        l_sqltext := REPLACE(l_sqltext, '@TZ_TABLES@', ', max_snaps, snaps');
        l_sqltext := REPLACE(l_sqltext, '@TZ_PREDS@', 
' AND  a.instance_number = max_snaps.inst_id
      AND  a.instance_number = snaps.inst_id(+)
      AND  a.snap_id = snaps.snap_id(+) ');
        l_sqltext := REPLACE(l_sqltext, '@TZ_GROUP@', ', snap_id');
      ELSE
        l_sqltext := REPLACE(l_sqltext, '@TZ_SHIFT@', NULL);
        IF context.disk_comp_ver >= VER_12_2 THEN
          l_sqltext := REPLACE(l_sqltext, '@TPR@', 'a.usecs_per_row/1000000');
        ELSE
          l_sqltext := REPLACE(l_sqltext, '@TPR@', '10');
        END IF;
        l_sqltext := REPLACE(l_sqltext, '@TZ_TABLES@', NULL);
        l_sqltext := REPLACE(l_sqltext, '@TZ_PREDS@', NULL);
        l_sqltext := REPLACE(l_sqltext, '@TZ_GROUP@', NULL);
      END IF;

      -- memory boundary (outer join with mem and then a filter) is used in 
      -- case both memory and disk sources are in use. 
      IF context.memEnable THEN
         l_sqltext := REPLACE(l_sqltext, '@END_MEM_BOUNDARY@',
' ) x, mem_times m WHERE x.inst_id = m.inst_id(+)
  ) WHERE min_sample_id IS NULL OR sample_id < min_sample_id ');
      ELSE
        l_sqltext := REPLACE(l_sqltext, '@END_MEM_BOUNDARY@', NULL);
      END IF;

      addQueryBlock(context, l_sqltext, TRUE);

      IF l_use_joins THEN 
         -- step 4: combine the bucket data with time per row data.
         l_sqltext := ' ,' || l_disk_source_name || 
q'[ AS
    (SELECT data.inst_id, data.bucket_id,
            SUM(data.filtered_cnt) as filtered_cnt,
            SUM(data.total_sec * NVL(params.sec_per_row,10)) as total_sec,
            SUM(data.filtered_sec * NVL(params.sec_per_row,10)) as filtered_sec
     FROM   data, params
     WHERE  data.inst_id = params.inst_id(+)
       AND  data.snap_id = params.snap_id(+)
     GROUP BY data.inst_id, data.bucket_id
    ) ]';
         addQueryBlock(context, l_sqltext, FALSE);
      END IF;
    END IF;

    --------------------------------------
    -- COMBINE THE DISK AND MEMORY SOURCES
    --------------------------------------
    IF context.diskEnable AND context.memEnable THEN
      l_sqltext := 
' ,combined_source AS (
  SELECT NVL(m.inst_id, d.inst_id) as inst_id,
         NVL(m.bucket_id, d.bucket_id) as bucket_id,
         NVL(m.filtered_cnt,0)+NVL(d.filtered_cnt,0) as filtered_cnt,
         NVL(m.total_sec,0)+NVL(d.total_sec,0) as total_sec,
         NVL(m.filtered_sec,0)+NVL(d.filtered_sec,0) as filtered_sec
  FROM   mem_source m FULL OUTER JOIN disk_source d
    ON   (m.inst_id = d.inst_id AND m.bucket_id = d.bucket_id)
) ';
      addQueryBlock(context, l_sqltext, FALSE);
    END IF;

    --------------------------------------
    -- COMBINE THE INSTANCES FOR DB LEVEL 
    --------------------------------------
    l_sqltext := 
' ,rac_data AS (
 SELECT bucket_id, sum(filtered_cnt) as filtered_cnt,
        sum(total_sec) as total_sec, sum(filtered_sec) as filtered_sec
 FROM combined_source GROUP BY bucket_id ORDER BY bucket_id ) ';
    addQueryBlock(context, l_sqltext, FALSE);
  END appendTimePickerDataSource;

  FUNCTION getActivityLine(context IN OUT NOCOPY ContextType)
  RETURN XMLTYPE
  IS
    l_report XMLTYPE;
    l_text   VARCHAR2(4000);
  BEGIN
    -- IF no data sources are enabled: return error report.
    IF NOT context.memEnable AND NOT context.diskEnable THEN
      IF context.show_sql THEN
        print_context(context);
      END IF;
      context.error_xml := error_to_xml(
          'No data sources to query',
          'err_no_data_source');
      RETURN NULL;
    END IF;

    -- start the query
    resetQuery(context);
    addQueryBlock(context, 'WITH ', FALSE);
    appendTimePickerDataSource(context);

    -- Finish the report using the data source SQL provided.
    l_text :=
q'[ ,histogram_xml as
      (SELECT xmlelement("histogram",
                 xmlattributes(@BUCK_CNT@ as "bucket_count", @BUCK_SIZE@
                 as "bucket_interval", @LAST_BUCK_SIZE@ as "last_bucket_interval"),
              xmlagg(xmlelement("bucket",xmlattributes(
                      bucket_id+1 as "number",
                      (CASE WHEN (bucket_id=@BUCK_CNT@ and @LAST_BUCK_SIZE@ > 0)
                            THEN ROUND(total_sec / @LAST_BUCK_SIZE@,2)
                            ELSE ROUND(total_sec / @BUCK_SIZE@,2) END)
                         as "avg_active_sess",
                      (CASE WHEN (bucket_id=@BUCK_CNT@ and @LAST_BUCK_SIZE@ > 0)
                            THEN ROUND(filtered_sec / @LAST_BUCK_SIZE@,2)
                            ELSE ROUND(filtered_sec / @BUCK_SIZE@,2) END)
                         as "filtered_aas"))
                )) as x 
       FROM (SELECT * FROM rac_data ORDER BY bucket_id)
      )
   , est_count as
     (SELECT SUM(filtered_cnt) as cnt FROM rac_data)
   SELECT est_count.cnt, histogram_xml.x
   FROM est_count, histogram_xml ]';
    addQueryBlock(context, l_text, TRUE);
    l_report := executeQuery(context, TRUE);
    IF context.show_sql THEN
      dbms_output.put_line('Estimated Row count: ' || context.est_row_count);
      dbms_output.put_line('Expected Row count: ' || context.exp_row_count);
    END IF;
    RETURN l_report;
  END getActivityLine;

  ----------------------------------------------------------------------
  -- FIND_IS_CDB_ROOT
  -----------------------------------------------------------------------
  -- NAME:
  --   find_is_cdb_root
  --
  -- DESCRIPTION:
  --   Check whether the analysis is in the ROOT container of a CDB
  --
  -- RETURN:
  --   TRUE if connected to a cdb root containter, otherwise FALSE.
  -----------------------------------------------------------------------
  FUNCTION find_is_cdb_root(context IN OUT NOCOPY ContextType) 
  RETURN BOOLEAN
  IS
    l_sqltext VARCHAR2(4000);
    l_conid NUMBER;
    l_cnt NUMBER;
  BEGIN
    IF context.local_comp_ver < VER_12 THEN
      RETURN FALSE;
    END IF;
    IF context.is_local THEN
      l_conid := TO_NUMBER(SYS_CONTEXT('USERENV','CON_ID'));
      IF l_conid IS NOT NULL AND l_conid = 1 THEN
        RETURN TRUE;
      ELSE
        RETURN FALSE;
      END IF;
    END IF;
    -- inported snapshots: find from AWR
    l_sqltext := 
       'SELECT count(*) FROM ' || context.awrTablePrefix || 'parameter 
        WHERE  dbid = :1
          AND  snap_id >= :2
          AND  snap_id <= :3
          AND  parameter_name = ''enable_pluggable_database''
          AND  lower(value) = ''true''';
    EXECUTE IMMEDIATE l_sqltext 
    INTO l_cnt
    USING context.dbid, context.beginSnapID, context.endSnapID;
    IF l_cnt > 0 THEN 
      RETURN TRUE;
    END IF;
    RETURN FALSE;
  END find_is_cdb_root;

  -----------------------------------------------------------------------
  -- NAME:
  --   initialize_dimtable
  --
  -- DESCRIPTION:
  --   Initialize the dimension table. The dimensions declared here
  --   will determine the columns selected from ASH.
  --
  -----------------------------------------------------------------------
  PROCEDURE initialize_dimtable(context IN OUT NOCOPY ContextType,
                                dimTable IN OUT DimTableType)
  IS
    dim           varchar2(30);
    l_text        varchar2(4000);
    l_use_pdb_awr varchar2(10);
    l_time_limit  varchar2(10) := '''Y''';
    l_top_limit   varchar2(100) := TO_CHAR(TOP_ADD_INFO_COUNT);
  BEGIN
    IF NOT context.is_local AND context.local_is_pdb THEN
      l_use_pdb_awr := '''Y''';
    ELSE
      l_use_pdb_awr := '''N''';
    END IF;

    ----------------------------------------------------------------------
    -- INSTANCE_NUMBER
    -- The INSTANCE_NUMBER dimension does not have a definition for
    -- selectStr, mapSQL or SQL for mapping instance id to instance names.
    -- Because, the column is inst_id in the in-memory view and
    -- instance_number in the on-disk view.
    ----------------------------------------------------------------------
    dimTable('instance_number').name := 'instance_number';
    dimTable('instance_number').enabled := TRUE;
    dimTable('instance_number').is_pdb_specific := FALSE;

    ----------------------------------------
    -- CON_DBID
    ----------------------------------------
    dimTable('con_dbid').name := 'con_dbid';
    dimTable('con_dbid').is_pdb_specific := TRUE;
    dimTable('con_dbid').enabled := FALSE;
    IF context.is_cdb_root THEN
      dimTable('con_dbid').enabled := TRUE;
      dimTable('con_dbid').category := SESS_ID_CAT;
      dimTable('con_dbid').selectStr := ' a.con_dbid';
      dimTable('con_dbid').fromClause := 'map_condbid';
      dimTable('con_dbid').whereClause :=
         ' ash.con_dbid = map_condbid.con_dbid ';
      dimTable('con_dbid').addInfo.idNameXML := 'pdb_map_xml';
      IF context.is_local THEN
        dimTable('con_dbid').addInfo.idNameSQL :=
  q'[, map_condbid as
         (SELECT con_dbid, rownum as id
          FROM (SELECT DISTINCT con_dbid FROM unified_ash))
     , pdb_names_mem as 
         (SELECT dbid as con_dbid, name
          FROM   v$containers
          WHERE  dbid IN (SELECT con_dbid FROM map_condbid))
     , pdb_names_awr as 
         (SELECT 
                 con_dbid, substr(p, 15) as name
          FROM (
            SELECT con_dbid, 
                   max(to_char(startup_time,'YYYYMMDDHH24MISS')||pdb_name) as p
            FROM   dba_hist_pdb_instance
            WHERE  dbid = ]' || to_char(context.local_dbid) || q'[
              AND NOT con_dbid IN (SELECT con_dbid FROM pdb_names_mem)
              AND con_dbid IN (SELECT con_dbid FROM map_condbid)
            GROUP BY con_dbid)
          )
     , pdb_names as
          (SELECT con_dbid, name FROM pdb_names_mem
           UNION ALL 
           SELECT con_dbid, name FROM pdb_names_awr
          )
     , pdb_map_xml as
           (SELECT XMLELEMENT("con_dbid", XMLAGG( XMLELEMENT("m",
                     XMLATTRIBUTES(m.id as "i",
                                   m.con_dbid as "v",
                 omc_ash_viewer.str_to_ascii(n.name) as "name")))) as xml
            FROM map_condbid m, pdb_names n
            WHERE m.con_dbid = n.con_dbid(+)
           ) ]';
      ELSE
        dimTable('con_dbid').addInfo.idNameSQL :=
  q'[, map_condbid as
         (SELECT con_dbid, rownum as id
          FROM (SELECT DISTINCT con_dbid FROM unified_ash))
     , pdb_names as 
         (SELECT 
                 con_dbid, substr(p, 15) as name
          FROM (
            SELECT con_dbid, 
                   max(to_char(startup_time,'YYYYMMDDHH24MISS')||pdb_name) as p
            FROM   ]' || context.awrTablePrefix || 'pdb_instance
            WHERE dbid = ' || to_char(context.dbid) || q'[
              AND con_dbid IN (SELECT con_dbid FROM map_condbid)
            GROUP BY con_dbid)
          )
     , pdb_map_xml as
           (SELECT XMLELEMENT("con_dbid", XMLAGG( XMLELEMENT("m",
                     XMLATTRIBUTES(m.id as "i",
                                   m.con_dbid as "v",
                 omc_ash_viewer.str_to_ascii(n.name) as "name")))) as xml
            FROM map_condbid m, pdb_names n
            WHERE m.con_dbid = n.con_dbid(+)
           ) ]';
      END IF;
    END IF;

    ----------------------------------------
    -- WAIT_CLASS
    ----------------------------------------
    dimTable('wait_class').name := 'wait_class';
    dimTable('wait_class').is_pdb_specific := FALSE;
    dimTable('wait_class').category := RSRC_CONS_CAT;
    dimTable('wait_class').selectStr :=  
       q'#(CASE WHEN a.session_state = 'WAITING' THEN a.wait_class ELSE 'CPU' END)#';
    dimTable('wait_class').mapSQL :=
     q'#, map_waitclass as
         (SELECT wait_class, rownum as id
          FROM (select DISTINCT wait_class FROM unified_ash)
         )
        , map_waitclass_xml as
        (SELECT xmlelement("wait_class", xmlagg(xmlelement("m", xmlattributes(
                  wait_class as "v", id as "i")))) as x
         FROM map_waitclass) #';
    dimTable('wait_class').fromClause := 'map_waitclass';
    dimTable('wait_class').mapXML := 'map_waitclass_xml';
    dimTable('wait_class').whereClause :=
         ' ash.wait_class = map_waitclass.wait_class';

    ----------------------------------------
    -- EVENT
    ----------------------------------------
    /* select string for event should also include timemodel. We decode
     * timemodel bits for IMC events */
    dimTable('event').name := 'event';
    dimTable('event').is_pdb_specific := FALSE;
    dimTable('event').category := RSRC_CONS_CAT;
    IF context.disk_comp_ver >= VER_12_1_2 THEN
      dimTable('event').selectStr :=
       q'#(CASE WHEN a.session_state = 'WAITING' THEN a.event 
                WHEN bitand(a.time_model, power(2,18)) > 0 THEN 'CPU: IM Query'
                WHEN bitand(a.time_model, power(2,19)) > 0 THEN 'CPU: IM Populate'
                WHEN bitand(a.time_model, power(2,20)) > 0 THEN 'CPU: IM Prepopulate'
                WHEN bitand(a.time_model, power(2,21)) > 0 THEN 'CPU: IM Repopulate'
                WHEN bitand(a.time_model, power(2,22)) > 0 THEN 'CPU: IM Trickle Repop'
                ELSE 'CPU + Wait for CPU' END)#';
    ELSE
      dimTable('event').selectStr :=
       q'#(CASE WHEN a.session_state = 'WAITING' THEN a.event ELSE 'CPU + Wait for CPU' END)#';
    END IF;
    dimTable('event').mapSQL :=
     q'#, map_event as
        (SELECT event, rownum as id
         FROM (SELECT DISTINCT event FROM unified_ash)
        )
        , map_event_xml as
        (SELECT xmlelement("event",xmlagg(xmlelement("m", xmlattributes(
                   event as "v", id as "i")))) as x
         FROM map_event) #';
    dimTable('event').fromClause := 'map_event';
    dimTable('event').mapXML := 'map_event_xml';
    dimTable('event').whereClause := ' ash.event = map_event.event ' ;

    -------------------
    -- SQLID
    -------------------
    dimTable('sqlid').name := 'sqlid';
    dimTable('sqlid').selectStr := q'#nvl(sql_id, 'NULL') #';
    dimTable('sqlid').is_pdb_specific := FALSE;
    dimTable('sqlid').category := SQL_CAT;
    dimTable('sqlid').mapSQL :=
      q'# , map_sqlid as
           (SELECT sqlid, rownum as id
            FROM (SELECT sqlid, max(cnt) as cnt
                  FROM (SELECT sqlid, sum(sample_count) as cnt
                        FROM unified_ash
                        GROUP BY sqlid
                        UNION ALL
                        SELECT sql_id_top as sqlid,
                               sum(sample_count) as cnt
                        FROM unified_ash
                        GROUP BY sql_id_top)
                  GROUP BY sqlid
                  ORDER BY cnt DESC)) #';
    dimTable('sqlid').fromClause := 'map_sqlid';
    dimTable('sqlid').whereClause := ' ash.sqlid = map_sqlid.sqlid ';
    dimTable('sqlid').addInfo.idNameXML := 'sql_id_text_xml';
    dimTable('sqlid').addInfo.idNameSQL :=
      q'#, sql_id_text as
           (SELECT t.sqlid, t.id, %id_name_col% as sql_text
            FROM map_sqlid t
            WHERE t.id <= #' || l_top_limit || q'#)
          , sql_id_text_xml as
           (SELECT XMLELEMENT("sqlid",
                      XMLAGG(
                         XMLELEMENT("m",
                            XMLATTRIBUTES(id as "i",
                                          sqlid as "v"),
                               XMLCDATA(sql_text)))) as xml
            FROM (SELECT m.id, m.sqlid, t.sql_text
                  FROM sql_id_text t, map_sqlid m
                  WHERE m.sqlid = t.sqlid (+)))#';
    IF context.is_local THEN
      dimTable('sqlid').addInfo.idNameSQL := 
        REPLACE(dimTable('sqlid').addInfo.idNameSQL, '%id_name_col%',
    ' omc_ash_viewer.fetch_sqltext_local(t.sqlid, ' || 
            context.local_dbid || ',' || l_time_limit || ')');
    ELSE
      dimTable('sqlid').addInfo.idNameSQL := 
        REPLACE(dimTable('sqlid').addInfo.idNameSQL, '%id_name_col%',
    ' omc_ash_viewer.fetch_sqltext_awr(t.sqlid, ' || 
        context.local_dbid || ',' || l_use_pdb_awr || ',' || l_time_limit || ')');
    END IF;

    ---------------------
    -- SQL_ID_TOP
    ---------------------
    dimTable('sql_id_top').name := 'sql_id_top';
    dimTable('sql_id_top').selectStr := q'[nvl(top_level_sql_id,'NULL') ]';
    dimTable('sql_id_top').is_pdb_specific := FALSE;
    dimTable('sql_id_top').category := SQL_CAT;

    dimTable('sql_id_top').fromClause := 'map_sqlid map_top_sqlid';
    dimTable('sql_id_top').selectStrMap := 'map_top_sqlid';
    dimTable('sql_id_top').whereClause :=
             'ash.sql_id_top = map_top_sqlid.sqlid';

    ---------------------
    -- SQL_FMS
    ---------------------
    dimTable('sql_fms').name := 'sql_fms';
    dimTable('sql_fms').selectStr := 'nvl(force_matching_signature,0) ';
    dimTable('sql_fms').is_pdb_specific := FALSE;
    dimTable('sql_fms').category := SQL_CAT;

    dimTable('sql_fms').mapSQL :=
      q'[, map_sqlfms as
         (SELECT sql_fms, rownum as id
          FROM (SELECT DISTINCT sql_fms FROM unified_ash)
         )
         , map_sqlfms_xml as
         (SELECT xmlelement("sql_fms", xmlagg(xmlelement("m", xmlattributes(
                    sql_fms as "v", id as "i")))) as x
          FROM map_sqlfms) ]';
    dimTable('sql_fms').fromClause := 'map_sqlfms';
    dimTable('sql_fms').mapXML := 'map_sqlfms_xml';
    dimTable('sql_fms').whereClause :=
             'ash.sql_fms = map_sqlfms.sql_fms';

    -------------------
    -- SQL_RWS
    -------------------
    dimTable('sql_rws').name := 'sql_rws';
    dimTable('sql_rws').is_pdb_specific := FALSE;
    dimTable('sql_rws').category := SQL_CAT;


    dimTable('sql_rws').selectStr :=
      q'[decode(sql_plan_operation, null, 'NULL',
                sql_plan_operation || ',' || sql_plan_options)]';

    dimTable('sql_rws').mapSQL :=
      q'[, map_sql_rws as
         (SELECT sql_rws, rownum as id
          FROM (SELECT DISTINCT sql_rws FROM unified_ash)
         )
         , map_sqlrws_xml as
         (SELECT xmlelement("sql_rws", xmlagg(xmlelement("m", xmlattributes(
                    sql_rws as "v", id as "i")))) as x
          FROM map_sql_rws) ]';
    dimTable('sql_rws').fromClause := 'map_sql_rws';
    dimTable('sql_rws').mapXML := 'map_sqlrws_xml';
    dimTable('sql_rws').whereClause :=
             'ash.sql_rws = map_sql_rws.sql_rws';

    -------------------
    -- SQL_RWS_LINE
    -------------------
    dimTable('sql_rws_line').name := 'sql_rws_line';
    dimTable('sql_rws_line').is_pdb_specific := FALSE;
    dimTable('sql_rws_line').category := SQL_CAT;

    dimTable('sql_rws_line').selectStr :=
      q'[decode(sql_plan_operation, null, 'NULL',
                sql_id || ',' || sql_plan_hash_value || ',' ||
                sql_plan_line_id || ',' || sql_plan_operation || ','
                || sql_plan_options)]';

    dimTable('sql_rws_line').mapSQL :=
      q'[, map_sql_rws_line as
         (SELECT sql_rws_line, rownum as id
          FROM (SELECT DISTINCT sql_rws_line FROM unified_ash)
         )
         , map_sqlrwsline_xml as
         (SELECT xmlelement("sql_rws_line",
                    xmlagg(xmlelement("m", xmlattributes(
                    sql_rws_line as "v", id as "i")))) as x
          FROM map_sql_rws_line) ]';
    dimTable('sql_rws_line').fromClause := 'map_sql_rws_line';
    dimTable('sql_rws_line').mapXML := 'map_sqlrwsline_xml';
    dimTable('sql_rws_line').whereClause :=
             'ash.sql_rws_line = map_sql_rws_line.sql_rws_line';


    ------------------
    --  PX_PROCESS
    ------------------
    dimTable('px_process').name := 'px_process';
    dimTable('px_process').selectStr := 'decode(qc_instance_id, null, 0, 0, 0, 1)';
    dimTable('px_process').is_pdb_specific := FALSE;
    dimTable('px_process').category := SESS_ID_CAT;

    -------------------
    -- PHYSICAL_SESSION
    -------------------
    dimTable('physical_session').name := 'physical_session';
    dimTable('physical_session').category := SESS_ID_CAT;
    dimTable('physical_session').is_pdb_specific := FALSE;

    -----------------------
    -- BLOCKING_SESSION
    -----------------------
    dimTable('blocking_session').name := 'blocking_session';
    dimTable('blocking_session').is_pdb_specific := FALSE;
    dimTable('blocking_session').category := RSRC_CONS_CAT;

    dimTable('blocking_session').selectStr :=
      q'[decode(blocking_session, null, 'NULL', blocking_inst_id || ',' ||
                blocking_session || ',' || blocking_session_serial#)]';

    dimTable('blocking_session').mapSQL :=
      q'[, map_blk_sess as
         (SELECT blocking_session, rownum as id
          FROM (SELECT DISTINCT blocking_session FROM unified_ash)
         )
        , map_blk_sess_xml as
        ( SELECT xmlelement("blocking_session", xmlagg(xmlelement("m",
                    xmlattributes(blocking_session as "v", id as "i")))) as x
          FROM map_blk_sess) ]';
    dimTable('blocking_session').fromClause := 'map_blk_sess';
    dimTable('blocking_session').mapXML := 'map_blk_sess_xml';
    dimTable('blocking_session').whereClause :=
             'ash.blocking_session = map_blk_sess.blocking_session';

    -------------------
    -- SESSION_TYPE
    -------------------
    dimTable('session_type').name := 'session_type';
    dimTable('session_type').is_pdb_specific := FALSE;
    dimTable('session_type').category := SESS_ID_CAT;

    dimTable('session_type').selectStr :=
      q'[ decode(session_type, 'FOREGROUND', '1', '0')]';

    -------------------
    -- XID
    -------------------
    dimTable('xid').name := 'xid';
    dimTable('xid').selectStr := 'nvl(xid,''0'')';
    dimTable('xid').is_pdb_specific := FALSE;
    dimTable('xid').category := SESS_ATTR_CAT;

    dimTable('xid').mapSQL :=
      q'[, map_xid as
         (SELECT xid, rownum as id
          FROM (SELECT DISTINCT xid FROM unified_ash)
         )
         , map_xid_xml as
         (SELECT xmlelement("xid", xmlagg(xmlelement("m",xmlattributes(
                    xid as "v", id as "i")))) as x
          FROM map_xid) ]';
    dimTable('xid').fromClause := 'map_xid';
    dimTable('xid').mapXML  := 'map_xid_xml';
    dimTable('xid').whereClause :=
             'ash.xid = map_xid.xid';

    -------------------
    -- ECID
    -------------------
    dimTable('ecid').name := 'ecid';
    dimTable('ecid').selectStr := 'nvl(ecid,''NULL'')';
    dimTable('ecid').isDimMasked := TRUE;
    dimTable('ecid').is_pdb_specific := FALSE;
    dimTable('ecid').category := SESS_ATTR_CAT;

    dimTable('ecid').mapSQL :=
      q'[, map_ecid as
         (SELECT ecid, rownum as id
          FROM (SELECT DISTINCT ecid FROM unified_ash)
         )
         , map_ecid_xml as
         (SELECT xmlelement("ecid", xmlagg(
                    xmlelement("m", xmlattributes(
         omc_ash_viewer.str_to_ascii(ecid) as "v", id as "i"))))
                 as x
          FROM map_ecid) ]';
    dimTable('ecid').fromClause := 'map_ecid';
    dimTable('ecid').mapXML := 'map_ecid_xml';
    dimTable('ecid').whereClause :=
             'ash.ecid = map_ecid.ecid';

    -------------------
    -- MACHINE
    -------------------
    dimTable('machine').name := 'machine';
    dimTable('machine').is_pdb_specific := FALSE;
    dimTable('machine').isDimMasked := TRUE;
    dimTable('machine').category := SESS_ATTR_CAT;

    dimTable('machine').selectStr := 'nvl(machine, ''NULL'')';

    dimTable('machine').mapSQL :=
      q'[, map_machine as
         (SELECT machine, rownum as id
          FROM (SELECT DISTINCT machine FROM unified_ash)
         )
         , map_machine_xml as
         (SELECT xmlelement("machine", xmlagg(
                    xmlelement("m",
                       xmlattributes(omc_ash_viewer.str_to_ascii(machine) as "v",
                                     id as "i"))))
                 as x
          FROM map_machine) ]';
    dimTable('machine').fromClause := 'map_machine';
    dimTable('machine').mapXML := 'map_machine_xml';
    dimTable('machine').whereClause :=
             'ash.machine = map_machine.machine';

    -------------------
    -- MACHINE_PORT
    -------------------
    dimTable('machine_port').name := 'machine_port';
    dimTable('machine_port').is_pdb_specific := FALSE;
    dimTable('machine_port').category := SESS_ATTR_CAT;

    dimTable('machine_port').selectStr :=
         q'[machine || ',' || port]';

    dimTable('machine_port').mapSQL :=
      q'[, map_machine_port as
         (SELECT machine_port, rownum as id
          FROM (SELECT DISTINCT machine_port FROM unified_ash))
         , map_machine_port_xml as
         (SELECT XMLELEMENT("machine_port",
                    XMLAGG(XMLELEMENT("m",
                       XMLATTRIBUTES(machine_port as "v", id as "i")))) as x
          FROM map_machine_port) ]';
    dimTable('machine_port').fromClause := 'map_machine_port';
    dimTable('machine_port').mapXML := 'map_machine_port_xml';
    dimTable('machine_port').whereClause :=
             'ash.machine_port = map_machine_port.machine_port';

    -------------------
    -- PROGRAM
    -------------------
    dimTable('program').name := 'program';
    dimTable('program').selectStr := 'nvl(program,''NULL'')';
    dimTable('program').is_pdb_specific := FALSE;
    dimTable('program').category := SESS_ID_CAT;

    dimTable('program').mapSQL :=
      q'[, map_program as
         (SELECT program, rownum as id
          FROM (SELECT DISTINCT program FROM unified_ash)
         )
         , map_program_xml as
         (SELECT xmlelement("program", xmlagg(
                    xmlelement("m",
                       xmlattributes(program as "v",
                                     id as "i")))) as x
          FROM map_program) ]';

    dimTable('program').fromClause := 'map_program';
    dimTable('program').mapXML := 'map_program_xml';
    dimTable('program').whereClause := ' ash.program = map_program.program';

    -------------------
    -- MODULE
    -------------------
    dimTable('module').name := 'module';
    dimTable('module').selectStr := 'nvl(module,''NULL'')';
    dimTable('module').isDimMasked := TRUE;
    dimTable('module').is_pdb_specific := FALSE;
    dimTable('module').category := SESS_ATTR_CAT;

    dimTable('module').mapSQL :=
      q'[, map_module as
         (SELECT module, rownum as id
          FROM (SELECT DISTINCT module FROM unified_ash)
         )
         , map_module_xml as
         (SELECT xmlelement("module", xmlagg(
                    xmlelement("m",
                       xmlattributes(omc_ash_viewer.str_to_ascii(module) as "v",
                                     id as "i")))) as x
          FROM map_module) ]';

    dimTable('module').fromClause := 'map_module';
    dimTable('module').mapXML := 'map_module_xml';
    dimTable('module').whereClause := ' ash.module = map_module.module';


    -------------------
    -- ACTION
    -------------------
    dimTable('action').name := 'action';
    dimTable('action').selectStr := 'nvl(action,''NULL'') ';
    dimTable('action').isDimMasked := TRUE;
    dimTable('action').is_pdb_specific := FALSE;
    dimTable('action').category := SESS_ATTR_CAT;

    dimTable('action').mapSQL :=
      q'[, map_action as
         (SELECT action, rownum as id
          FROM (SELECT DISTINCT action FROM unified_ash)
         )
         , map_action_xml as
         (SELECT xmlelement("action", xmlagg(
                    xmlelement("m",
                       xmlattributes(omc_ash_viewer.str_to_ascii(action) as "v",
                                     id as "i")))) as x
          FROM map_action) ]';

    dimTable('action').fromClause := 'map_action';
    dimTable('action').mapXML := 'map_action_xml';
    dimTable('action').whereClause := ' ash.action = map_action.action';

    -------------------
    -- CLIENT_ID
    -------------------
    dimTable('client_id').name := 'client_id';
    dimTable('client_id').selectStr := 'nvl(client_id,''NULL'')';
    dimTable('client_id').isDimMasked := TRUE;
    dimTable('client_id').is_pdb_specific := FALSE;
    dimTable('client_id').category := SESS_ATTR_CAT;

    dimTable('client_id').mapSQL :=
      q'[, map_client_id as
         (SELECT client_id, rownum as id
          FROM (SELECT DISTINCT client_id FROM unified_ash)
         )
         , map_client_id_xml as
         (SELECT xmlelement("client_id", xmlagg(
                    xmlelement("m",
                       xmlattributes(omc_ash_viewer.str_to_ascii(client_id) as "v",
                                     id as "i")))) as x
          FROM map_client_id) ]';
    dimTable('client_id').fromClause := 'map_client_id';
    dimTable('client_id').mapXML := 'map_client_id_xml';
    dimTable('client_id').whereClause :=
             'ash.client_id = map_client_id.client_id';

    -------------------
    -- SQLID_FULLPHV
    -------------------
    IF context.disk_comp_ver >= VER_12_1_2 THEN
      dimTable('sqlid_fullphv').name := 'sqlid_fullphv';
      dimTable('sqlid_fullphv').is_pdb_specific := FALSE;
      dimTable('sqlid_fullphv').category := SQL_CAT;

      dimTable('sqlid_fullphv').selectStr :=
        q'[decode(sql_id, null, 'NULL', sql_id || ',' ||
              decode(sql_full_plan_hash_value,0,to_char(null),
                     sql_full_plan_hash_value))]';
      dimTable('sqlid_fullphv').mapSQL :=
        q'[, map_fullphv as
           (SELECT sqlid_fullphv, rownum as id
            FROM (SELECT DISTINCT sqlid_fullphv FROM unified_ash)
           )
           , map_fullphv_xml as
           (SELECT xmlelement("sqlid_fullphv",
                      xmlagg(xmlelement("m", xmlattributes(
                      sqlid_fullphv as "v", id as "i")))) as x
            FROM map_fullphv) ]';
      dimTable('sqlid_fullphv').fromClause := 'map_fullphv';
      dimTable('sqlid_fullphv').mapXML := 'map_fullphv_xml';
      dimTable('sqlid_fullphv').whereClause :=
               'ash.sqlid_fullphv = map_fullphv.sqlid_fullphv';
    END IF;

    -------------------
    -- SQLID_PHV
    -------------------
    dimTable('sqlid_phv').name := 'sqlid_phv';
    dimTable('sqlid_phv').is_pdb_specific := FALSE;
    dimTable('sqlid_phv').category := SQL_CAT;

    dimTable('sqlid_phv').selectStr :=
      q'[decode(sql_id, null, 'null', sql_id || ',' ||
            decode(sql_plan_hash_value,0,to_char(null),sql_plan_hash_value))]';

    dimTable('sqlid_phv').mapSQL :=
      q'[, map_phv as
         (SELECT sqlid_phv, rownum as id
          FROM (SELECT DISTINCT sqlid_phv FROM unified_ash)
         )
         , map_phv_xml as
         (SELECT xmlelement("sqlid_phv", xmlagg(xmlelement("m", xmlattributes(
                    sqlid_phv as "v", id as "i")))) as x
          FROM map_phv) ]';
    dimTable('sqlid_phv').fromClause := 'map_phv';
    dimTable('sqlid_phv').mapXML := 'map_phv_xml';
    dimTable('sqlid_phv').whereClause :=
             'ash.sqlid_phv = map_phv.sqlid_phv';

    --------------------
    -- SQL_OPCODE
    -------------------
    dimTable('sql_opcode').name := 'sql_opcode';
    dimTable('sql_opcode').selectStr := 'sql_opcode';
    dimTable('sql_opcode').is_pdb_specific := FALSE;
    dimTable('sql_opcode').category := SQL_CAT;
    dimTable('sql_opcode').addInfo.idNameSQL :=
      q'[, sql_opcode_map as
          (SELECT sql_opcode, rownum as id
           FROM (SELECT distinct sql_opcode FROM unified_ash
                 UNION
                 select distinct sql_opcode_top as sql_opcode FROM unified_ash))
         , sql_opcode_xml as
          (SELECT XMLELEMENT("sql_opcode",
                     XMLAGG(
                        XMLELEMENT("m",
                           XMLATTRIBUTES(t.id as "i",
                                         t.sql_opcode as "v",
                                         v.command_name as "name")))) as xml
           FROM sql_opcode_map t, v$sqlcommand v
           WHERE t.sql_opcode = v.command_type(+)
          )]';
    dimTable('sql_opcode').fromClause := 'sql_opcode_map';
    dimTable('sql_opcode').whereClause :=
             'ash.sql_opcode = sql_opcode_map.sql_opcode';
    dimTable('sql_opcode').addInfo.idNameXML := 'sql_opcode_xml';

    -------------------
    -- SQL_OPCODE_TOP
    -------------------
    dimTable('sql_opcode_top').name := 'sql_opcode_top';
    dimTable('sql_opcode_top').is_pdb_specific := FALSE;
    dimTable('sql_opcode_top').category := SQL_CAT;

    dimTable('sql_opcode_top').selectStr := 'top_level_sql_opcode';
    dimTable('sql_opcode_top').fromClause := 'sql_opcode_map map_top_sqlopcode';
    dimTable('sql_opcode_top').selectStrMap := 'map_top_sqlopcode';
    dimTable('sql_opcode_top').whereClause :=
             'ash.sql_opcode_top = map_top_sqlopcode.sql_opcode';

    -------------------------
    -- PL-SQL and PL_SQL_TOP
    -------------------------
    dimTable('pl_sql_top').name := 'pl_sql_top';
    dimTable('pl_sql_top').is_pdb_specific := TRUE;
    dimTable('pl_sql_top').category := PLSQL_CAT;
    dimTable('pl_sql_top').selectStr :=
      q'[decode(plsql_object_id, null,'NULL',
                plsql_entry_object_id || ',' || plsql_entry_subprogram_id)]';
    dimTable('pl_sql_top').fromClause := 'map_plsqlid map_top_plsqlid';
    dimTable('pl_sql_top').selectStrMap := 'map_top_plsqlid';

    dimTable('pl_sql').name := 'pl_sql';
    dimTable('pl_sql').is_pdb_specific := TRUE;
    dimTable('pl_sql').category := PLSQL_CAT;
    dimTable('pl_sql').selectStr :=
     q'#decode(plsql_object_id, null, 'NULL',
               plsql_object_id || ',' || plsql_subprogram_id) #';
    dimTable('pl_sql').fromClause := 'map_plsqlid';
    dimTable('pl_sql').addInfo.idNameXML := 'plsql_id_name_xml';
    l_text := 
     q'[, map_plsqlid as
        (SELECT pl_sql %con_dbid_col%, rownum as id
         FROM (SELECT max(cnt), pl_sql %con_dbid_col%
               FROM (SELECT pl_sql %con_dbid_col%, sum(sample_count) as cnt
                     FROM unified_ash GROUP BY pl_sql %con_dbid_col%
                     UNION ALL
                     SELECT pl_sql_top as pl_sql %con_dbid_col%, sum(sample_count) as cnt
                     FROM unified_ash GROUP BY pl_sql_top %con_dbid_col% )
               GROUP BY pl_sql %con_dbid_col% ORDER BY 1 DESC)
        )]';
    IF context.is_cdb_root THEN
      l_text := REPLACE(l_text, '%con_dbid_col%', ', con_dbid');
      dimTable('pl_sql').whereClause :=
      ' ash.pl_sql = map_plsqlid.pl_sql and
        ash.con_dbid = map_plsqlid.con_dbid ';
      dimTable('pl_sql_top').whereClause :=
             'ash.pl_sql_top= map_top_plsqlid.pl_sql AND
              ash.con_dbid = map_top_plsqlid.con_dbid';
    ELSE
      l_text := REPLACE(l_text, '%con_dbid_col%', NULL);
      dimTable('pl_sql').whereClause :=
           ' ash.pl_sql = map_plsqlid.pl_sql';
      dimTable('pl_sql_top').whereClause :=
             'ash.pl_sql_top = map_top_plsqlid.pl_sql';
    END IF;
    dimTable('pl_sql').mapSQL := l_text;

    IF context.is_local THEN
      l_text := 
 q'[, plsql_names as
     (SELECT 
             id, omc_ash_viewer.fetch_procedure_name(
                to_number(NVL(substr(pl_sql,1, instr(pl_sql, ',')-1), '0'))
               ,to_number(NVL(substr(pl_sql, instr(pl_sql, ',')+1), '0'))
               ,%con_dbid%,]' || l_time_limit || q'[) as name
      FROM   map_plsqlid
      WHERE  id < ]' || l_top_limit || q'[
        AND  pl_sql LIKE '%,%'
     ) 
    , plsql_id_name_xml as
     (SELECT XMLELEMENT("pl_sql",
                XMLAGG( XMLELEMENT("m",
                      XMLATTRIBUTES(m.id as "i",
                                    m.pl_sql as "v" %con_dbid_attr% ,
                                    n.name as "name")))) as xml
      FROM   map_plsqlid m, plsql_names n
      WHERE  m.id = n.id(+)) ]';
    ELSE
      l_text := 
 q'[ , plsql_id_name_xml as
     (SELECT XMLELEMENT("pl_sql",
                XMLAGG( XMLELEMENT("m",
                      XMLATTRIBUTES(m.id as "i",
                                    m.pl_sql as "v" %con_dbid_attr%
                                    )))) as xml
      FROM map_plsqlid m) ]';
    END IF;
    IF context.is_cdb_root THEN
      l_text := REPLACE(l_text, '%con_dbid_attr%', ' , m.con_dbid as "c" ');
      l_text := REPLACE(l_text, '%con_dbid%', ' con_dbid ');
    ELSE
      l_text := REPLACE(l_text, '%con_dbid_attr%', NULL);
      l_text := REPLACE(l_text, '%con_dbid%', ' NULL ');
    END IF;
    dimTable('pl_sql').addInfo.idNameSQL := l_text;

    --------------------------------
    -- CONSUMER_GROUP_ID
    --------------------------------
    dimTable('consumer_group_id').name := 'consumer_group_id';
    dimTable('consumer_group_id').selectStr :=
       'nvl(consumer_group_id, -1)';
    dimTable('consumer_group_id').is_pdb_specific := TRUE;
    dimTable('consumer_group_id').category := SESS_ATTR_CAT;
    dimTable('consumer_group_id').addInfo.idNameXML := 'consumer_id_name_xml';
    dimTable('consumer_group_id').fromClause := 'map_consumer_id';

    l_text := 
      q'[, map_consumer_id as
          (select consumer_group_id %con_dbid_col% %con_dbid_to_id%, rownum as id
           from (select distinct consumer_group_id %con_dbid_col%
                 from unified_ash)) ]';
    IF (context.diskEnable 
       AND (context.beginSnapID IS NOT NULL) AND (context.endSnapID IS NOT NULL)) THEN 
      l_text := l_text ||
     ', map_cg_names as
          (SELECT 
              consumer_group_id  %con_dbid_col% , max(CONSUMER_GROUP_NAME) as name
           FROM ' || context.awrTablePrefix || 'RSRC_CONSUMER_GROUP 
           WHERE dbid = ' || context.dbid || '
             AND (consumer_group_id  %con_dbid_col%) IN 
                 (SELECT consumer_group_id %con_dbid_col% FROM map_consumer_id)
             AND snap_id >= ' || context.beginSnapID || '
             AND snap_id <= ' || context.endSnapID || '
           GROUP BY consumer_group_id  %con_dbid_col%
          )'; 
    ELSE 
      l_text := l_text ||
     ', map_cg_names as
          (SELECT 
              id as consumer_group_id  %con_id_col% , 
              substr(max(lpad(to_char(sequence#),32,''0'') || name),33) as name
           FROM v$rsrc_cons_group_history
           WHERE (id %con_id_col%) IN 
                 (SELECT consumer_group_id %con_id_col% FROM map_consumer_id)
           GROUP BY id  %con_id_col%
          )'; 
    END IF;
    l_text := l_text ||
     q'[, consumer_id_name_xml as
        (SELECT XMLELEMENT("consumer_group_id",
                    XMLAGG( XMLELEMENT("m", XMLATTRIBUTES( 
                    m.id as "i"
                  , m.consumer_group_id as "v" %con_dbid_attr%
                  , omc_ash_viewer.str_to_ascii(n.name) as "name")))) as xml
         FROM map_consumer_id m, map_cg_names n
         WHERE m.consumer_group_id = n.consumer_group_id(+) %con_id_pred%
      )]';
    IF context.is_cdb_root THEN
      l_text := REPLACE(l_text, '%con_dbid_col%', ',con_dbid');
      l_text := REPLACE(l_text, '%con_id_col%', ',con_id');
      l_text := REPLACE(l_text, '%con_dbid_to_id%', ',con_dbid_to_id(con_dbid) as con_id');
      l_text := REPLACE(l_text, '%con_dbid_attr%', ' , m.con_dbid as "c" ');
      IF context.diskEnable THEN
        l_text := REPLACE(l_text, '%con_id_pred%', ' AND m.con_dbid = n.con_dbid(+) ');
      ELSE 
        l_text := REPLACE(l_text, '%con_id_pred%', ' AND m.con_id = n.con_id(+) ');
      END IF;
    ELSE
      l_text := REPLACE(l_text, '%con_dbid_col%', NULL);
      l_text := REPLACE(l_text, '%con_id_col%', NULL);
      l_text := REPLACE(l_text, '%con_dbid_to_id%', NULL);
      l_text := REPLACE(l_text, '%con_dbid_attr%', NULL);
      l_text := REPLACE(l_text, '%con_id_pred%', NULL);
    END IF;
    dimTable('consumer_group_id').addInfo.idNameSQL := l_text;
    IF context.is_cdb_root THEN
      dimTable('consumer_group_id').whereClause :=
              'ash.consumer_group_id = map_consumer_id.consumer_group_id and
               ash.con_dbid = map_consumer_id.con_dbid ';
    ELSE 
      dimTable('consumer_group_id').whereClause :=
              'ash.consumer_group_id = map_consumer_id.consumer_group_id ';
    END IF;

    ----------------------------
    -- DBOP
    ----------------------------
    IF (context.disk_comp_ver >= VER_12) THEN

      dimTable('dbop').name := 'dbop';
      dimTable('dbop').is_pdb_specific := FALSE;
      dimTable('dbop').category := SESS_ATTR_CAT;

      dimTable('dbop').selectStr := q'[nvl(dbop_name, 'NULL')]';
      dimTable('dbop').isDimMasked := TRUE;
      dimTable('dbop').mapSQL :=
        q'[, map_dbop as
           (SELECT dbop, rownum as id
            FROM (SELECT DISTINCT dbop FROM unified_ash)
           )
           , map_dbop_xml as
           (SELECT xmlelement("dbop",xmlagg(xmlelement("m",
                      xmlattributes(omc_ash_viewer.str_to_ascii(dbop) as "v", 
                                    id as "i")))) as x
            FROM map_dbop) ]';
      dimTable('dbop').mapXML := 'map_dbop_xml';
      dimTable('dbop').fromClause := 'map_dbop';
      dimTable('dbop').whereClause :=
               'ash.dbop = map_dbop.dbop';
    END IF;

    ------------------------------
    -- OBJECT
    ------------------------------
    dimTable('object').name := 'object';
    dimTable('object').selectStr :=
      q'[(CASE WHEN a.session_state = 'WAITING' AND a.event = 'enq: TM - contention' 
              THEN GREATEST(NVL(a.p2,0),0)
              WHEN a.session_state = 'WAITING' AND 
                   (a.wait_class IN ('User I/O', 'System I/O', 'Cluster', 'Application')
                    OR a.event like '%buffer busy%')
              THEN GREATEST(NVL(a.current_obj#,0),0)
              WHEN a.session_state = 'WAITING' THEN 0
              WHEN bitand(a.time_model,8126464) > 0 
              THEN GREATEST(NVL(a.current_obj#,0),0)
              ELSE 0 END)]';
    dimTable('object').is_pdb_specific := TRUE;
    dimTable('object').category := RSRC_CONS_CAT;
    dimTable('object').addInfo.idNameXML := 'obj_name_xml';
    dimTable('object').fromClause := 'map_object';
    l_text := 
      q'[, map_object as
         (SELECT object %con_dbid_col%, rownum as id
          FROM (SELECT sum(sample_count), object %con_dbid_col%
                FROM unified_ash GROUP BY object %con_dbid_col%
                ORDER BY 1 DESC))
         , obj_names as
          (SELECT object %con_dbid_col%, %fetch% as name
           FROM   map_object WHERE id <= ]' || l_top_limit || q'[
            AND   object > 0)
         ,obj_name_xml as
            (SELECT XMLELEMENT("object",
                      XMLAGG( XMLELEMENT("m", XMLATTRIBUTES(m.id as "i",
                                          m.object as "v" %con_dbid_attr%,
                                          n.name as "name")))) as xml
            FROM map_object m, obj_names n
            WHERE m.object = n.object(+) %con_id_pred% )]';
    IF context.is_cdb_root THEN
      l_text := REPLACE(l_text, '%con_dbid_col%', ',con_dbid');
      l_text := REPLACE(l_text, '%con_dbid_attr%', ' , m.con_dbid as "c" ');
      l_text := REPLACE(l_text, '%con_id_pred%', 
        ' AND m.con_dbid = n.con_dbid(+) ');
      IF context.is_local THEN
        l_text := REPLACE(l_text, '%fetch%',
          ' omc_ash_viewer.fetch_obj_name_local(object, '
          || context.dbid || ', con_dbid,' || l_time_limit || ')'); 
      ELSE
        l_text := REPLACE(l_text, '%fetch%',
          ' omc_ash_viewer.fetch_obj_name_awr(object, '
          || context.dbid || ', con_dbid' || 
             l_use_pdb_awr || ',' || l_time_limit || ')'); 
      END IF;
    ELSE
      l_text := REPLACE(l_text, '%con_dbid_col%', NULL);
      l_text := REPLACE(l_text, '%con_dbid_attr%', NULL);
      l_text := REPLACE(l_text, '%con_id_pred%', NULL);
      IF context.is_local THEN
        l_text := REPLACE(l_text, '%fetch%',
          ' omc_ash_viewer.fetch_obj_name_local(object, '
          || context.dbid || ', NULL,' || l_time_limit || ')');
      ELSE
        l_text := REPLACE(l_text, '%fetch%',
          ' omc_ash_viewer.fetch_obj_name_awr(object, '
          || context.dbid || ', NULL,' || l_use_pdb_awr || ',' || 
             l_time_limit || ')');
      END IF;
    END IF;
    dimTable('object').addInfo.idNameSQL := l_text;
    IF context.is_cdb_root THEN
      dimTable('object').whereClause :=
         ' ash.object = map_object.object AND ash.con_dbid = map_object.con_dbid ';
    ELSE
      dimTable('object').whereClause :=
         ' ash.object = map_object.object ';
    END IF;

    ---------------------------
    -- SERVICE_HASH
    ---------------------------
    dimTable('service_hash').name := 'service_hash';
    dimTable('service_hash').selectStr := 'a.service_hash';
    dimTable('service_hash').is_pdb_specific := FALSE;
    dimTable('service_hash').category := SESS_ID_CAT;
    dimTable('service_hash').fromClause := 'map_service';
    dimTable('service_hash').whereClause :=
             'ash.service_hash = map_service.service_hash ';
    dimTable('service_hash').addInfo.idNameXML := 'serv_hash_name_xml';
    dimTable('service_hash').addInfo.idNameSQL :=
      q'[, map_service as
         (SELECT service_hash, rownum as id
          FROM (SELECT DISTINCT service_hash FROM unified_ash)
         )
         , map_service_names as
         (SELECT 
                 service_name_hash as service_hash, max(service_name) as name
          FROM ]' || context.awrTablePrefix || q'[service_name 
          WHERE dbid = ]' || context.dbid || q'[ 
          GROUP BY service_name_hash
         )
         , serv_hash_name_xml as
         (SELECT XMLELEMENT("service_hash",
                    XMLAGG(
                       XMLELEMENT("m",
                          XMLATTRIBUTES( m.id as "i"
                                       , m.service_hash as "v"
                , omc_ash_viewer.str_to_ascii(n.name) as "name")))) as xml
          FROM map_service m, map_service_names n
          WHERE n.service_hash(+) = m.service_hash)]';


    ----------------------------------------
    -- USER_ID
    ----------------------------------------
    dimTable('user_id').name := 'user_id';
    dimTable('user_id').selectStr := ' NVL(a.user_id,-1) ';
    dimTable('user_id').is_pdb_specific := TRUE;
    dimTable('user_id').category := SESS_ID_CAT;
    dimTable('user_id').fromClause := 'map_user_id';
    dimTable('user_id').addInfo.idNameXML := 'user_name_xml';
    l_text := 
      q'[, map_user_id as
         (SELECT 
                 user_id %con_dbid_col%, rownum as id
          FROM (SELECT sum(sample_count), user_id %con_dbid_col%
                FROM unified_ash
                GROUP BY user_id %con_dbid_col%
                ORDER BY 1 DESC)) ]';
    IF context.is_local THEN
      l_text := l_text || 
        q'[, user_names as
          (SELECT id, omc_ash_viewer.fetch_user_name(user_id, %con_dbid%,]'
                 || l_time_limit || q'[) as name
           FROM   map_user_id 
           WHERE  id <= ]' || l_top_limit || q'[
             AND  user_id >= 0)
          , user_name_xml as
          (SELECT 
                 XMLELEMENT("user_id", XMLAGG( XMLELEMENT("m",
                              XMLATTRIBUTES( m.id as "i"
                                           , m.user_id as "v" %con_dbid_attr%
                                           , n.name as "name" )))) as xml
              FROM  map_user_id m, user_names n
              WHERE m.id = n.id(+)) ]';
    ELSE
      l_text := l_text ||
        q'[, user_name_xml as
          (SELECT 
                 XMLELEMENT("user_id", XMLAGG( XMLELEMENT("m",
                              XMLATTRIBUTES( m.id as "i"
                                           , m.user_id as "v" %con_dbid_attr%
                                           )))) as xml
              FROM  map_user_id m) ]';
    END IF;
    IF context.is_cdb_root THEN
      l_text := REPLACE(l_text, '%con_dbid_col%', ', con_dbid');
      l_text := REPLACE(l_text, '%con_dbid%', 'con_dbid');
      l_text := REPLACE(l_text, '%con_dbid_attr%', ' , m.con_dbid as "c" ');
      dimTable('user_id').whereClause :=
             'ash.user_id = map_user_id.user_id and
              ash.con_dbid = map_user_id.con_dbid';
    ELSE
      l_text := REPLACE(l_text, '%con_dbid_col%', NULL);
      l_text := REPLACE(l_text, '%con_dbid%', 'NULL');
      l_text := REPLACE(l_text, '%con_dbid_attr%', NULL);
      dimTable('user_id').whereClause :=
             'ash.user_id = map_user_id.user_id';
    END IF;
    dimTable('user_id').addInfo.idNameSQL := l_text;

    ----------------------------------------------------------------
    -- Capture and Replay specific dimensions ----------------------
    ----------------------------------------------------------------
    -------------------
    -- IS_CAPTURED ----
    -------------------
    dimTable('is_captured').name := 'is_captured';
    dimTable('is_captured').selectStr := 'a.is_captured';
    dimTable('is_captured').is_pdb_specific := FALSE;


    -------------------
    -- IS_REPLAYED ----
    -------------------
    dimTable('is_replayed').name := 'is_replayed';
    dimTable('is_replayed').selectStr := 'a.is_replayed';
    dimTable('is_replayed').is_pdb_specific := FALSE;

    ---------------------------
    -- FILTERED OUT WORKLOAD --
    ---------------------------
    dimTable('is_filtered_out').name := 'is_filtered_out';
    dimTable('is_filtered_out').is_pdb_specific := FALSE;
    dimTable('is_filtered_out').selectStr :=
      q'[(case when (a.is_captured = 'N' and not (a.session_type = 'BACKGROUND' or a.program like '% (J___)%')) then 'Y' else 'N' end)]';

    -----------------------------------------------
    -- JOBS AND BACKGROUND ACTIVITY NOT CAPTURED --
    -----------------------------------------------
    dimTable('is_nc_background').name := 'is_nc_background';
    dimTable('is_nc_background').is_pdb_specific := FALSE;
    dimTable('is_nc_background').selectStr :=
      q'[(case when (a.is_captured = 'N' and (a.session_type = 'BACKGROUND' or a.program like '% (J___)%')) then 'Y' else 'N' end)]';

    -----------------------------------------------
    -- CAPTURE_ID portion of the file id
    -- This should be looked at only for a consolidated replay
    -- This dimension is not extracted from the client DB.
    -------------------------------------------------------------
    dimTable('capture_id').name := 'capture_id';
    dimTable('capture_id').is_pdb_specific := FALSE;
    dimTable('capture_id').selectStr :=
      q'[floor(nvl(a.dbreplay_file_id,0)/4294967296)]';

    dimTable('capture_id').mapSQL :=
      q'[, map_captureid as
       (SELECT capture_id, rownum as id
          FROM (SELECT DISTINCT capture_id FROM unified_ash)
         ) ]';
    dimTable('capture_id').fromClause := 'map_captureid';
    dimTable('capture_id').whereClause :=
             'ash.capture_id = map_captureid.capture_id';

    IF context.is_local AND context.local_comp_ver >= VER_12 THEN
      dimTable('capture_id').addInfo.idNameSQL :=
        q'[, capture_id_name_xml as
            (SELECT XMLELEMENT("capture_id",
                       XMLAGG(
                          XMLELEMENT("m",
                             XMLATTRIBUTES(id as "i",
                                           capture_id as "v",
                        omc_ash_viewer.str_to_ascii(name) as "name")))) as xml
             FROM (SELECT m.id,m.capture_id, %id_name_col% as name
                   FROM map_captureid m)) ]';
      dimTable('capture_id').addInfo.id2name_awr :=
        q'[NVL((select c.name
              from dba_workload_schedule_captures sc,
                   dba_workload_captures c,
                   dba_workload_replay_schedules sch
            where sc.capture_id=c.id
              and sch.schedule_name=sc.schedule_name
              and sch.status='CURRENT'
              and sc.schedule_cap_id=m.capture_id
              and rownum < 2
           ),
           'other activity')]';
       dimTable('capture_id').addInfo.idNameXML := 'capture_id_name_xml';
    ELSE
      dimTable('capture_id').mapSQL := dimTable('capture_id').mapSQL ||
        q'[, map_captureid_xml as
            (SELECT XMLELEMENT("capture_id",
                       XMLAGG(
                          XMLELEMENT("m",
                             XMLATTRIBUTES(id as "i",
                                           capture_id as "v")))) as x
             FROM map_captureid) ]';
      dimTable('capture_id').mapXML := 'map_captureid_xml';
    END IF;
    ----------------------------------------------------------------
    -- End - Capture and Replay specific dimensions ----------------
    ----------------------------------------------------------------

    -----------------------------------------------
    -- Enable all dimensions
    -----------------------------------------------
    dim := dimTable.FIRST;
    while dim IS NOT NULL LOOP
      IF dimTable(dim).enabled IS NULL THEN
        dimTable(dim).enabled := TRUE;
      END IF;
      IF dimTable(dim).isDimMasked IS NULL THEN
        dimTable(dim).isDimMasked := FALSE;
      END IF;
      IF dimTable(dim).is_pdb_specific IS NULL THEN
        dimTable(dim).is_pdb_specific := FALSE;
        IF context.show_sql THEN
          dbms_output.put_line('ERROR: DIMENSION ' || dim || ' is assumed not PDB specific');
        END IF;
      END IF;
      dim := dimTable.NEXT(dim);
    END LOOP;
  END initialize_dimtable;

  FUNCTION i_replace_id2name_column(context IN OUT NOCOPY ContextType, dim IN VARCHAR2)
  RETURN VARCHAR2
  IS
    q1    VARCHAR2(10000) := NULL;
    q2    VARCHAR2(10000) := NULL;
    idNameSQL  varchar2(32767);
  BEGIN
    IF (context.dimTable(dim).addInfo.id2name_const IS NOT NULL) THEN
      q1 := context.dimTable(dim).addInfo.id2name_const;
    ELSE
      IF (context.is_local AND
          context.dimTable(dim).addInfo.id2name_dynamic IS NOT NULL) THEN
        q1 := context.dimTable(dim).addInfo.id2name_dynamic;
        q2 := context.dimTable(dim).addInfo.id2name_awr;
      ELSE
        q1 := context.dimTable(dim).addInfo.id2name_awr;
      END IF;
    END IF;

    -- In case we have no map
    IF q1 IS NULL THEN
      idNameSQL := replace(context.dimTable(dim).addInfo.idNameSQL,
                          '%id_name_col%', 'NULL');
      RETURN idNameSQL;
    END IF;

    IF q2 IS NULL THEN
      idNameSQL := replace(context.dimTable(dim).addInfo.idNameSQL,
                           '%id_name_col%', '(' || q1 || ')');
      RETURN idNameSQL;
    END IF;

    idNameSQL:= replace(context.dimTable(dim).addInfo.idNameSQL,
                       '%id_name_col%', 
                       'NVL(' || q1 || ', ' || q2 || ')');
    RETURN idNameSQL;
  END i_replace_id2name_column;

  ---------------------------- i_validate_dimension --------------------------
  -- NAME:
  --   i_validate_dimension
  --
  -- DESCRIPTION:
  --   Validate a user-provided dimension name from the dimtable and raise
  --   an exception if it's invalid.
  --
  -- PARAMETERS:
  --    dimName (IN) - dimension name provided by the user
  --
  -- RETURNS:
  --    value equal to dimname if dimname is valid, else raise an error
  -----------------------------------------------------------------------------
  FUNCTION i_validate_dimension(context IN OUT NOCOPY ContextType,
    dimName IN VARCHAR2)
  RETURN VARCHAR2
  IS
    found     BOOLEAN := FALSE;
    toRet     VARCHAR2(30) := '';          -- return a different string
                                           -- to make sql inj tool happy
                                           -- match DimTableType length
    fromTable VARCHAR2(30) := '';
  BEGIN
    -- clearly wrong if > 30 chars
    IF (LENGTH(dimName) > 30) THEN
      raise_application_error(-20501,
        'Dimension name provided is too long');
    END IF;

    -- loop over context to validate
    fromTable := context.dimTable.FIRST;
    LOOP
      IF (lower(dimName) = lower(fromTable)) THEN
        toRet := dbms_assert.simple_sql_name(fromTable);
        found := TRUE;
        EXIT;
      END IF;

      fromTable := context.dimTable.NEXT(fromTable);
      EXIT WHEN fromTable IS NULL;
    END LOOP;

    -- error if not found
    IF (NOT found) THEN
      raise_application_error(-20501,
        'Dimension name provided is invalid');
    END IF;

    return toRet;
  END i_validate_dimension;

  PROCEDURE addFilterPred(name IN VARCHAR,
                          value IN VARCHAR,
                          context IN OUT NOCOPY ContextType)
  IS
    dim        VARCHAR(30);
    memSelect  VARCHAR2(1000) := NULL;
    diskSelect VARCHAR2(1000) := NULL;
    gvSelect   VARCHAR2(1000) := NULL;
    l_value    VARCHAR2(1000) := SYS.DBMS_ASSERT.ENQUOTE_LITERAL(value);
    l_and      VARCHAR2(10) := NULL;
  BEGIN
    dim := i_validate_dimension(context, name);
    CASE dim 
    WHEN 'physical_session' THEN
      memSelect := q'[(a.inst_id || ',' || a.session_id || ',' || a.session_serial#)]';
      diskSelect := q'[(a.instance_number || ',' || a.session_id || ',' || a.session_serial#)]';
      gvSelect := q'[(USERENV('INSTANCE') || ',' || a.session_id || ',' || a.session_serial#)]';
    WHEN 'instance_number' THEN
      memSelect := 'a.inst_id';
      diskSelect := 'a.instance_number';
      gvSelect := 'TO_NUMBER(USERENV(''INSTANCE''))';
    ELSE
      memSelect := context.dimTable(dim).selectStr;
      IF context.dimTable(dim).isDimMasked THEN
        memSelect := 'omc_ash_viewer.str_to_ascii(' || memSelect || ')';
      END IF;
      diskSelect := memSelect;
      gvSelect := memSelect;
    END CASE; 
    IF context.memFilterPredicate IS NOT NULL THEN
      l_and := ' AND ';
    END IF;
    context.memFilterPredicate := context.memFilterPredicate ||
      l_and || '(' || memSelect || ' = ' || l_value || ')';
    context.diskFilterPredicate := context.diskFilterPredicate ||
      l_and || '(' || diskSelect || ' = ' || l_value || ')';
    context.gvFilterPredicate := context.gvFilterPredicate ||
      l_and || '(' || gvSelect || ' = ' || l_value || ')';
  END addFilterPred;

  PROCEDURE buildFilterPredicate(filterList IN VARCHAR,
                                 context IN OUT NOCOPY ContextType)
  IS
    CURSOR from_xml(s VARCHAR) IS
    SELECT y.n as name, y.v as VALUE
    FROM   XMLTABLE('/fs/f'
              PASSING XMLPARSE(CONTENT s)
              COLUMNS n VARCHAR2(128) PATH '@n',
                      v VARCHAR2(128) PATH '@v') y;

    CURSOR from_str(s VARCHAR) IS
    SELECT TRIM(y.n) as name, TRIM(y.v) as value
    FROM   XMLTABLE('/fs/f'
              PASSING XMLPARSE(CONTENT
  '<fs><f n="' ||
  REPLACE(REPLACE(s,'=','" v="'), ' AND ','"/><f n="') ||
  '"/></fs>')
                COLUMNS n VARCHAR2(128) PATH '@n',
                        v VARCHAR2(128) PATH '@v') y;
  BEGIN
    IF filterList IS NULL THEN
      RETURN;
    END IF;
    IF TRIM(filterList) LIKE '<fs>%</fs>' THEN
      FOR r IN from_xml(filterList) LOOP
        addFilterPred(r.name, r.value, context);
      END LOOP;
    ELSE 
      FOR r IN from_str(filterList) LOOP
        addFilterPred(r.name, r.value, context);
      END LOOP;
    END IF;
  END buildFilterPredicate;

  PROCEDURE build_data_context(
    context         IN OUT NOCOPY ContextType
  , filter_list     IN VARCHAR2 := NULL)
  IS
    timepickerXML XMLType;
  BEGIN
    context.is_cdb_root := find_is_cdb_root(context);
    context.dbid := NVL(context.dbid, context.local_dbid);
    context.disk_comp_ver := 
      NVL(context.disk_comp_ver, context.local_comp_ver);
    context.diskTZ := NVL(context.diskTZ, context.memTZ);

--context.underscores := TRUE;
    IF NVL(context.disk_comp_ver,context.local_comp_ver) < VER_12_2 
       AND context.diskTZ IS NOT NULL 
       AND NOT context.underscores 
    THEN
      -- We genrate binds with a timezone shift so they are in the data's
      -- time zone. This is done because we do not have UTC timestamps 
      -- (version < 12.2) but we have a constant time zone so we can use
      -- the regular sample_time column as is.
      generate_binds(context, FALSE);
    ELSE
      -- Generate binds in UTC.
      -- Eitehr we are in 12.2 or above RDBMS so UTC timestamps 
      -- are available in ASH, or we have a complicated situation with 
      -- multiple time zones or usage of underscore parameters
      -- so we need multiple joins to get the UTC timestamp anyway.
      generate_binds(context, TRUE);
    END IF;

    initialize_dimtable(context,context.dimTable);
    buildFilterPredicate(filter_list, context);

    context.exp_row_count := OMC_DEF_ROWS_PER_BUCKET * context.bucketCount;
    IF context.show_sql THEN
      print_context(context);
    END IF;
    context.diag_context_secs := 
        timing_to_seconds(context.diag_start_time, SYSTIMESTAMP);
  END build_data_context;

  PROCEDURE appendDataSource(context IN OUT NOCOPY ContextType)
  IS
    l_sqltext     VARCHAR2(4000);
    l_disk_source_name VARCHAR2(30);
    l_dim_columns VARCHAR2(4000);
    l_dim_names   VARCHAR2(4000);
    dim           VARCHAR2(30);
    l_tz_shift    VARCHAR2(100) := NULL;
    l_tpr         VARCHAR2(100) := NULL;
    l_info_table  VARCHAR2(1000) := NULL;
    l_use_joins   BOOLEAN;
  BEGIN
    ----------------
    -- Construct the select list 
    ---------------
    dim := context.dimTable.FIRST;
    WHILE dim IS NOT NULL LOOP
      IF context.dimTable(dim).enabled
         AND context.dimTable(dim).selectStr IS NOT NULL THEN
        l_dim_columns := l_dim_columns || ','
                   || context.dimTable(dim).selectStr || ' as '
                   || context.dimTable(dim).name;
      END IF;
      dim := context.dimTable.NEXT(dim);
    END LOOP;

    ----------------
    -- MEMORY SOURCE
    ----------------
    IF context.memEnable THEN
      IF context.local_comp_ver < VER_12_2 AND context.use_utc_binds THEN
        l_tz_shift := '-ai.tz';
      ELSE
        l_tz_shift := NULL;
      END IF;
      IF context.local_comp_ver >= VER_12_2 THEN 
        l_tpr := '(a.usecs_per_row/1000000)';
      ELSE 
        l_tpr := 'ai.tpr';
        l_info_table := 'ai';
      END IF;
      IF context.diskEnable THEN 
        IF context.local_comp_ver < VER_12_2 OR context.underscores THEN
          l_tpr := l_tpr || ' * ai.disk_filter_ratio';
          l_info_table := 'ai';
        ELSE
          l_tpr := l_tpr || ' * 10';
        END IF;
      END IF;
      IF l_info_table IS NOT NULL THEN
        l_info_table := 
'(SELECT 86400*(CAST(latest_sample_time AS DATE) - CAST(oldest_sample_time AS DATE))
                 / (latest_sample_id - oldest_sample_id) as tpr,
                 disk_filter_ratio,
                 ROUND(96*(CAST(latest_sample_time AS DATE) - CAST(
                       SYS_EXTRACT_UTC(SYSTIMESTAMP) AS DATE)),0)/96 as tz
          FROM V$ASH_INFO
          WHERE ROWNUM <= 1
         ) ai, ';
      END IF;

      IF context.diskEnable THEN
        l_sqltext := ' mem_source';
      ELSE 
        l_sqltext := ' unified_ash';
      END IF;
      l_sqltext := l_sqltext || 
' AS (
    SELECT /*+ NO_MERGE */ *
    FROM TABLE(GV$(CURSOR( 
         SELECT TRUNC(86400*((CAST(@ASH_T_COL@ AS DATE)' 
        || l_tz_shift || ')-@BEGIN_TIME_D@ )) as t,
                TRUNC(86400*((CAST(@ASH_T_COL@ AS DATE)' 
        || l_tz_shift || ')-@BEGIN_TIME_D@ ) / @BUCK_SIZE@ )+1 as bucket_number,
                a.session_id , a.session_serial# , a.session_state, '
                || l_tpr || ' as sample_count, 
                USERENV(''INSTANCE'') as instance_number,
                USERENV(''INSTANCE'') || '','' || a.session_id || '','' || a.session_serial# 
                   as physical_session,
                a.sample_id ';
      addQueryBlock(context, l_sqltext, TRUE);
      addQueryBlock(context, l_dim_columns, FALSE);
      l_sqltext := 
       ' FROM ' || l_info_table || ' V$ACTIVE_SESSION_HISTORY a
         WHERE  CAST(@ASH_T_COL@ AS DATE)' || l_tz_shift || ' >=  @BEGIN_TIME_D@
           AND  CAST(@ASH_T_COL@ AS DATE)' || l_tz_shift || ' < @END_TIME_D@
           AND  (a.session_state = ''ON CPU'' 
                OR a.wait_class <> ''Idle'') @AND_FG_ONLY@ @AND_INST_GVD@ ';
      addQueryBlock(context, l_sqltext, TRUE);

      l_sqltext := NULL;
      IF context.diskEnable THEN
        l_sqltext := ' AND a.is_awr_sample = ''Y'' AND bitand(a.flags,128)=0 ';
      END IF;
      IF context.gvFilterPredicate IS NOT NULL THEN
        l_sqltext := l_sqltext || ' AND ' || context.gvFilterPredicate;
      END IF;
      IF context.sample_ratio > 1 THEN
        l_sqltext := l_sqltext || 
         ' AND ORA_HASH(USERENV(''INSTANCE'') || ''_'' || a.session_id || ''_''
           || a.sample_id ,1000000, 0) <= (1000000 / ' || context.sample_ratio || ') ';
      END IF;
      l_sqltext := l_sqltext || ')))) ';
      addQueryBlock(context, l_sqltext, FALSE);
    END IF;

    ----------------
    -- DISK SOURCE
    ----------------
    IF context.diskEnable THEN
      -- If we also have memory, get the lower memory time in UTC
      -- for stitching disk and memory data.
      IF context.memEnable THEN
        l_disk_source_name := ' disk_source';
        l_sqltext := 
' ,mem_times AS (
  SELECT /*+ NO_MERGE */ instance_number as inst_id, 
         MIN(sample_id) as min_sample_id
  FROM   mem_source
  GROUP BY instance_number )
 ,disk_times AS (
  SELECT /*+ NO_MERGE */ 
         DISTINCT a.instance_number as inst_id
  FROM @AWRTAB@DATABASE_INSTANCE a
  WHERE a.dbid = @DBID@ @AND_INST_V@)
 ,sample_id_bounds AS (
    SELECT /*+ NO_MERGE */ d.inst_id, m.min_sample_id
    FROM disk_times d FULL OUTER JOIN mem_times m
    ON (d.inst_id = m.inst_id)
  ) ';
        addQueryBlock(context, l_sqltext, TRUE);
      ELSE
        l_disk_source_name := ' unified_ash';
      END IF;

      -- determine if complicated joins are needed to take care of time zone 
      -- changes and usage of underscore parameters.
      IF context.disk_comp_ver >= VER_12_2 OR NOT context.use_utc_binds THEN
        l_use_joins := FALSE;
      ELSE
        l_use_joins := TRUE;
      END IF;

      -- add the time zone and parameter information in some query blocks.
      IF l_use_joins THEN
        -- step 1: use parameter table to get the time per row.
        l_sqltext :=
q'[ params AS
    (SELECT /*+ NO_MERGE */
            inst_id, snap_id, NVL(p1,1)*NVL(p2,10) as sec_per_row
     FROM (
       SELECT a.instance_number as inst_id,
              a.snap_id as snap_id,
              DECODE(a.parameter_name, '_ash_sampling_interval',
                   to_number(a.value)/1000,NULL) as p1,
              DECODE(a.parameter_name, '_ash_disk_filter_ratio',
                     to_number(a.value),NULL) as p2
       FROM @AWRTAB@parameter a
       WHERE  a.dbid = @DBID@ @AND_INST_V@
         AND  a.snap_id >= @B_SNAP@
         AND  a.snap_id <= @E_SNAP@
         AND  a.parameter_name IN
              ('_ash_sampling_interval','_ash_disk_filter_ratio')
       )) ]';
         addQueryBlock(context, l_sqltext, TRUE);
         -- step 2: find timezone information from snapshots
         --         use the latest snapshot from each instance as
         --         default timezone in case the snapshot information
         --         is not available.
         l_sqltext :=
q'[ ,max_snaps AS
    (SELECT /*+ NO_MERGE */
            ms.instance_number as inst_id,
            ms.snap_timezone as tz
     FROM @AWRTAB@SNAPSHOT ms
     WHERE  ms.dbid = @DBID@
       AND (ms.instance_number, ms.snap_id) IN
            (SELECT a.instance_number, max(a.snap_id) as snap_id
             FROM @AWRTAB@SNAPSHOT t
             WHERE  a.dbid = @DBID@ @AND_INST_V@
       AND  a.snap_id >= @B_SNAP@
       AND  a.snap_id <= @E_SNAP@
     GROUP BY a.instance_number)
    )
 ,snaps AS
    (SELECT /*+ NO_MERGE */
            a.instance_number as inst_id, a.snap_id, a.snap_timezone as tz
     FROM  @AWRTAB@SNAPSHOT a
     WHERE  a.dbid = @DBID@ @AND_INST_V@
       AND  a.snap_id >= @B_SNAP@
       AND  a.snap_id <= @E_SNAP@
  ) ]';
         addQueryBlock(context, l_sqltext, TRUE);
      END IF;

      -- Step 3: Main data block.
      -- several cases exist:
      -- 1. Use of complicated joins. We need to join to the snaps, and max_snaps
      --    query blocks. Also modify timezone
      -- 2. No complicated joins in 12.2: just need to handle time_per_row from ASH
      -- 3. No complicated joins in 12.1, 11g: binds are in local timezone so just
      --    handle TPR as 10 seconds. 
      IF l_use_joins THEN 
         l_sqltext := ', data';
      ELSIF context.memEnable THEN 
         l_sqltext := ' ,' || l_disk_source_name;
      ELSE 
         l_sqltext := l_disk_source_name;
      END IF;  
      l_sqltext := l_sqltext || 
' AS
   ( SELECT /*+ NO_MERGE */ 
            TRUNC(86400*(CAST((@ASH_T_COL@ @TZ_SHIFT@) 
       AS DATE)-@BEGIN_TIME_D@)) as t,
            TRUNC(86400*(CAST((@ASH_T_COL@ @TZ_SHIFT@) 
       AS DATE)-@BEGIN_TIME_D@
       ) / @BUCK_SIZE@ )+1 as bucket_number,
                a.session_id , a.session_serial# , a.session_state
                ,@TPR@ as sample_count, 
                a.instance_number as instance_number,
                a.instance_number || '','' || a.session_id || '','' || a.session_serial# 
                   as physical_session, a.sample_id @SNAP_ID_COL@';
      IF l_use_joins THEN
        l_sqltext := REPLACE(l_sqltext, '@TZ_SHIFT@', '-NVL(snaps.tz,max_snaps.tz)');
        l_sqltext := REPLACE(l_sqltext, '@TPR@', '1');
        l_sqltext := REPLACE(l_sqltext, '@SNAP_ID_COL@', ', a.snap_id');
      ELSE 
        l_sqltext := REPLACE(l_sqltext, '@TZ_SHIFT@', NULL);
        IF context.disk_comp_ver >= VER_12_2 THEN
          l_sqltext := REPLACE(l_sqltext, '@TPR@', 'a.usecs_per_row/1000000');
        ELSE
          l_sqltext := REPLACE(l_sqltext, '@TPR@', '10');
        END IF;
        l_sqltext := REPLACE(l_sqltext, '@SNAP_ID_COL@', NULL);
      END IF;
      addQueryBlock(context, l_sqltext, TRUE);
      addQueryBlock(context, l_dim_columns, FALSE);

      l_sqltext := 
   q'[  FROM  @AWRTAB@ACTIVE_SESS_HISTORY a @TZ_TABLES@ @MEM_BOUND_TABLE@
    WHERE  a.dbid = @DBID@ @AND_INST_V@
      AND  a.snap_id >= @B_SNAP@
      AND  a.snap_id <= @E_SNAP@
      AND  @ASH_T_COL@ @TZ_SHIFT@ >= @BEGIN_TIME_T@
      AND  @ASH_T_COL@ @TZ_SHIFT@ < @END_TIME_T@ @MEM_BOUND_PRED@
      AND  (a.session_state = 'ON CPU' OR a.wait_class <> 'Idle'
           ) @AND_FG_ONLY@ @TZ_PREDS@ ]'; 

      IF l_use_joins THEN
        l_sqltext := REPLACE(l_sqltext, '@TZ_SHIFT@', '-NVL(snaps.tz,max_snaps.tz)');
        l_sqltext := REPLACE(l_sqltext, '@TPR@', '1');
        l_sqltext := REPLACE(l_sqltext, '@TZ_TABLES@', ', max_snaps, snaps');
        l_sqltext := REPLACE(l_sqltext, '@TZ_PREDS@', 
' AND  a.instance_number = max_snaps.inst_id
      AND  a.instance_number = snaps.inst_id(+)
      AND  a.snap_id = snaps.snap_id(+) ');
        l_sqltext := REPLACE(l_sqltext, '@MEM_BOUND_TABLE@', ', sample_id_bounds');
        l_sqltext := REPLACE(l_sqltext, '@MEM_BOUND_PRED@', 
' AND a.instance_number = sample_id_bounds.inst_id AND 
  (sample_id_bounds.min_sample_id IS NULL OR sample_id_bounds.min_sample_id > a.sample_id) ');
      ELSE
        l_sqltext := REPLACE(l_sqltext, '@TZ_SHIFT@', NULL);
        IF context.disk_comp_ver >= VER_12_2 THEN
          l_sqltext := REPLACE(l_sqltext, '@TPR@', 'a.usecs_per_row/1000000');
        ELSE
          l_sqltext := REPLACE(l_sqltext, '@TPR@', '10');
        END IF;
        l_sqltext := REPLACE(l_sqltext, '@TZ_TABLES@', NULL);
        l_sqltext := REPLACE(l_sqltext, '@TZ_PREDS@', NULL);
        l_sqltext := REPLACE(l_sqltext, '@MEM_BOUND_TABLE@', NULL);
        l_sqltext := REPLACE(l_sqltext, '@MEM_BOUND_PRED@', NULL);
      END IF;
      addQueryBlock(context, l_sqltext, TRUE);

      l_sqltext := NULL;
      IF context.diskFilterPredicate IS NOT NULL THEN
        l_sqltext := l_sqltext || ' AND ' || context.diskFilterPredicate;
      END IF;
      IF context.sample_ratio > 1 THEN
        l_sqltext := l_sqltext || 
         ' AND ORA_HASH(a.instance_number || ''_'' || a.session_id || ''_''
           || a.sample_id ,1000000, 0) <= (1000000 / ' || context.sample_ratio || ') ';
      END IF;
      l_sqltext := l_sqltext || ') ';
      addQueryBlock(context, l_sqltext, FALSE);


      IF l_use_joins THEN 
         -- step 4: combine the bucket data with time per row data.
        dim := context.dimTable.FIRST;
        l_dim_names := NULL;
        WHILE dim IS NOT NULL LOOP
          IF context.dimTable(dim).enabled 
             AND context.dimTable(dim).selectStr IS NOT NULL THEN
            l_dim_names := l_dim_names || ',d.' || context.dimTable(dim).name;
          END IF;
          dim := context.dimTable.NEXT(dim);
        END LOOP;

        l_sqltext := ' ,' || l_disk_source_name || 
' AS
    (SELECT d.t,d.bucket_number,d.session_id,d.session_serial#,d.session_state,
            d.sample_count*NVL(params.sec_per_row,10) as sample_count, 
            d.instance_number,d.physical_session,d.sample_id '
 || l_dim_names || 
  '  FROM   data d, params
     WHERE  d.instance_number = params.inst_id(+)
       AND  d.snap_id = params.snap_id(+)
    ) ';
         addQueryBlock(context, l_sqltext, FALSE);
      END IF;
    END IF;

    --------------------------------------
    -- COMBINE THE DISK AND MEMORY SOURCES
    --------------------------------------
    IF context.diskEnable AND context.memEnable THEN
      l_sqltext := 
' ,unified_ash AS (SELECT /*+ NO_MERGE */ * FROM  
  (SELECT * FROM mem_source UNION ALL SELECT * FROM disk_source )) ';
      addQueryBlock(context, l_sqltext, FALSE);
    END IF;
  END appendDataSource;

  PROCEDURE generate_maps(context IN OUT NOCOPY ContextType)
  IS
    dim        varchar2(30);
    l_text     varchar2(4000) := NULL;
  BEGIN
    dim := context.dimTable.FIRST;
    while dim is not null loop
      IF context.dimTable(dim).enabled THEN 
        addQueryBlock(context, context.dimTable(dim).mapSQL, FALSE);
      END IF;
      dim := context.dimTable.NEXT(dim);
    end loop;
    -- map for physical_session 
    l_text := 
      q'[, map_physical_session as
           (SELECT physical_session, rownum as id
            FROM (SELECT distinct physical_session FROM unified_ash))
         , map_sess_xml as
           (SELECT xmlelement("physical_session",
                      xmlagg(xmlelement("m", xmlattributes(
                         physical_session as "v", id as "i")))) as x
            FROM map_physical_session) ]';
    addQueryBlock(context, l_text, FALSE);
    -- map for instance_number
    IF context.is_local THEN
      l_text := 
      q'[, map_instance_number as
         (SELECT instance_number, rownum as id
          FROM (SELECT DISTINCT instance_number FROM unified_ash ORDER BY 1)
         )
         , map_instance_names as
         (SELECT inst_id,
                 substr(max(name),15) as name
          FROM (
            SELECT inst_id,
                   to_char(SYSDATE+7,'YYYYMMDDHH24MISS') || instance_name 
                           || ' ' || CHR(64) || ' ' || host_name as name
            FROM   gv$instance
            UNION ALL
            SELECT instance_number as inst_id,
                   max(to_char(startup_time,'YYYYMMDDHH24MISS') || instance_name 
                       || ' ' || CHR(64) || ' ' || host_name) as name
            FROM   ]' || context.awrTablePrefix || q'[database_instance
            WHERE dbid = ]' || context.dbid || q'[
            GROUP BY instance_number
          )
          GROUP BY inst_id
         )
         , map_instance_number_xml as
         (SELECT XMLELEMENT("instance_number",
                    XMLAGG(
                       XMLELEMENT("m",
                          XMLATTRIBUTES( m.id as "i"
                                       , m.instance_number as "v"
                , omc_ash_viewer.str_to_ascii(n.name) as "name")))) as x
          FROM map_instance_number m, map_instance_names n
          WHERE n.inst_id(+) = m.instance_number)]';
    ELSE
      l_text := 
      q'[, map_instance_number as
         (SELECT instance_number, rownum as id
          FROM (SELECT DISTINCT instance_number FROM unified_ash ORDER BY 1)
         )
         , map_instance_names as
         (SELECT instance_number as inst_id,
                 substr(max(name),15) as name
          FROM (
            SELECT instance_number,
                   max(to_char(startup_time,'YYYYMMDDHH24MISS') || instance_name 
                       || ' ' || CHR(64) || ' ' || host_name) as name
            FROM   ]' || context.awrTablePrefix || q'[database_instance
            WHERE dbid = ]' || context.dbid || q'[
            GROUP BY instance_number
            )
           )
         )
         , map_instance_number_xml as
         (SELECT XMLELEMENT("instance_number",
                    XMLAGG(
                       XMLELEMENT("m",
                          XMLATTRIBUTES( m.id as "i"
                                       , m.instance_number as "v"
                , omc_ash_viewer.str_to_ascii(n.name) as "name")))) as x
          FROM map_instance_number m, map_instance_names n
          WHERE n.inst_id(+) = m.instance_number)]';
    END IF;
    addQueryBlock(context, l_text, FALSE);
  END generate_maps;

  PROCEDURE generate_idnamemaps(context IN OUT NOCOPY ContextType)
  IS
    dim varchar2(30);
  BEGIN
    dim := context.dimTable.FIRST;
    while dim is not null loop
      IF context.dimTable(dim).enabled
         AND context.dimTable(dim).addInfo.idNameSQL IS NOT NULL THEN
        addQueryBlock(context, i_replace_id2name_column(context,dim), FALSE);
      END IF;
      dim := context.dimTable.NEXT(dim);
    end loop;
  END generate_idnamemaps;

  PROCEDURE generate_ashxml(context IN OUT NOCOPY ContextType)
  IS
    dim         varchar2(30);
    selectList  varchar2(32767);
    fromList    varchar2(32767);
    whereList   varchar2(32767);
    dimListStr  varchar2(32767);
    selectStr   varchar2(32767);
    dimIsMapStr varchar2(32767);
    dimIsPDBStr varchar2(32767);
    l_text      varchar2(4000);
  BEGIN
    dim := context.dimTable.FIRST;

    WHILE dim IS NOT NULL LOOP
      ----------------------------------------------------------------------
      -- Each dimension in the dimension table has the following
      -- name (mandatory)
      --   Name of the dimension
      -- selectStr (optional)
      --   This defines the columns to be selected from the unified_ash view.
      --   Some dimensions are version specific(con_dbid, sqlid_fullphv etc).
      --   Such dimensions will have an empty selectStr in versions in which
      --   they do not exist.
      --   Some dimensions like physical_session, instance_number and dbid
      --   also have a null selectStr. These columns selected by these dimension
      --   have different names in the in-memory ash and on-disk ash. They will
      --   be handled as special cases.
      -- mapSQL (optional)
      -- fromClause
      -- mapXML
      -- whereClause
      -- addInfo (AddInfoType)
      ----------------------------------------------------------------------
      IF context.dimTable(dim).enabled THEN
        IF context.dimTable(dim).selectStr IS NOT NULL THEN
          dimListStr := dimListStr || ',' || context.dimTable(dim).name;
          IF (context.dimTable(dim).fromClause IS NOT NULL) THEN
            dimIsMapStr := dimIsMapStr || ',Y';
            fromList := fromList || ',' || context.dimTable(dim).fromClause;
            whereList := whereList || ' AND ' || context.dimTable(dim).whereClause;
            selectList := selectList || q'#|| ',' ||#' ||
                          nvl(context.dimTable(dim).selectStrMap,
                              context.dimTable(dim).fromClause) || '.id';
          ELSE
            dimIsMapStr := dimIsMapStr || ',N';
            selectList := selectList || q'#|| ',' ||#' ||
                          context.dimTable(dim).name;
          END IF;
          IF context.dimTable(dim).is_pdb_specific IS NOT NULL THEN
            dimIsPDBStr := dimIsPDBStr ||
                          (case when context.dimTable(dim).is_pdb_specific = TRUE 
                                then ',Y'
                                else ',N' end);
          END IF;
        END IF;
      END IF;
      dim := context.dimTable.NEXT(dim);
    END LOOP;

    dimIsMapStr := q'[, xmlelement("dimension_is_map", 'N,N,N,Y,Y]' 
                   || dimIsMapStr || ''')';
    IF context.is_cdb_root THEN
      dimIsPDBStr := q'[, xmlelement("dim_is_pdb_specific", 'N,N,N,N,N]' 
                   || dimIsPDBStr || ''')';
    ELSE
      dimIsPDBStr := NULL;
    END IF;

    l_text := '''sample_time, bucket_number, sample_count,physical_session,instance_number';
    l_text := 
     q'[, ash_xml as
          (SELECT xmlconcat(
                     xmlelement("dimensions",]' || l_text;
    addQueryBlock(context, l_text, FALSE);
    addQueryBlock(context, dimListStr, FALSE);
    l_text := ''')' || dimIsMapStr || dimIsPDBStr || q'[,
                     xmlelement("data",
                        xmlagg(
                           xmlelement("a", ash.t || ',' ||
                                      ash.bucket_number || ',' ||
                                      ROUND(ash.sample_count,2) || ',' ||
                                      map_physical_session.id || ',' ||
                                      map_instance_number.id ]';
    addQueryBlock(context, l_text, FALSE);
    addQueryBlock(context, selectList, FALSE);
    l_text := 
    q'[    ) order by ash.bucket_number, ash.t))) as x
           FROM unified_ash ash,
                map_physical_session, map_instance_number ]' || fromList;
    addQueryBlock(context, l_text, FALSE);
    l_text := 
    q'[ WHERE ash.physical_session = map_physical_session.physical_session 
          AND ash.instance_number = map_instance_number.instance_number ]'
            || whereList || ')';
    addQueryBlock(context, l_text, FALSE);
  END generate_ashxml;

  -----------------------------------------------
  -- Use i_getashdata_count instead of i_getashdata_xml
  -- To experiment on the performance of the ASH data source
  -- without the added dimensions
  -----------------------------------------------
  FUNCTION i_getashdata_count(context IN OUT NOCOPY ContextType)
  RETURN XMLTYPE
  IS
    retxml   XMLTYPE;
    l_text VARCHAR2(4000);
  BEGIN
    resetQuery(context);
    addQueryBlock(context, 'WITH ', FALSE);
    appendDataSource(context);
    l_text := 'SELECT xmlelement("ash_count",xmlattributes(
               to_char(count(*)) as "row_count")) FROM unified_ash';
    addQueryBlock(context, l_text, FALSE);
    retxml := executeQuery(context, FALSE);
    RETURN retxml;
  END i_getashdata_count;

  FUNCTION i_getashdata_xml(context IN OUT NOCOPY ContextType)
  RETURN XMLTYPE
  IS
    retxml   XMLTYPE;
    menuxml  VARCHAR2(32767);
    dim varchar2(30);
    dimListStr  varchar2(32767) := NULL;
    l_text VARCHAR2(4000);
  BEGIN
    resetQuery(context);
    addQueryBlock(context, 'WITH ', FALSE);
    appendDataSource(context);
    generate_maps(context);
    generate_idnamemaps(context);
    generate_ashxml(context);

    l_text := 
        ', ashdata as
          ( SELECT xmlelement("ash_data", 
                   xmlattributes(round(' || nvl(context.sample_ratio,1) 
                      || ', 4) as "sampling_ratio"),
                   map_sess_xml.x,
                   map_instance_number_xml.x,
                   ash_xml.x ' ;
    dim := context.dimTable.FIRST;
    WHILE dim IS NOT NULL LOOP
      IF context.dimTable(dim).enabled THEN
        if (context.dimTable(dim).mapXML IS NOT NULL) then
          l_text := l_text || ', ' || context.dimTable(dim).mapXML || '.x ';
        end if;
        IF (context.dimTable(dim).addInfo.idNameXML IS NOT NULL) THEN
          l_text := l_text || ', ' ||
                         context.dimTable(dim).addInfo.idNameXML || '.xml ';
        END IF;
        IF dimListStr IS NOT NULL THEN
          dimListStr := dimListStr || ',';
        END IF;
        dimListStr := dimListStr || context.dimTable(dim).name;
      END IF;
      dim := context.dimTable.NEXT(dim);
    END LOOP;
    addQueryBlock(context, l_text, FALSE);

    l_text := ') as data
            FROM ash_xml, map_sess_xml, map_instance_number_xml ' ;
    dim := context.dimTable.FIRST;
    while dim is not null loop
      IF context.dimTable(dim).enabled THEN
        if (context.dimTable(dim).mapXML IS NOT NULL) then
          l_text := l_text || ', ' || context.dimTable(dim).mapXML;
        end if;
        IF (context.dimTable(dim).addInfo.idNameXML IS NOT NULL) THEN
          l_text := l_text || ', ' ||
                        context.dimTable(dim).addInfo.idNameXML;
        END IF;
      END IF;
      dim := context.dimTable.NEXT(dim);
    end loop;

    l_text := l_text || ' )  
         SELECT ashdata.data
         FROM ashdata ';
    addQueryBlock(context, l_text, FALSE);

    retxml :=  executeQuery(context, FALSE);
    RETURN retxml;
  END i_getashdata_xml;

  FUNCTION getashdata(
    context         IN OUT NOCOPY ContextType
  , p_input         IN OUT NOCOPY XMLTYPE
  , filter_list     IN VARCHAR2 := NULL
  , histogram_only  IN BOOLEAN)
  RETURN XMLTYPE
  IS
    retxml        XMLTYPE;
    sqlstr        CLOB;
    l_timing      XMLTYPE;
    l_cpu         XMLTYPE;
    l_is_cdb_root CHAR(1);
    l_t1          TIMESTAMP;
    l_t2          TIMESTAMP;
    l_t3          TIMESTAMP;
  BEGIN
    -- build the data part of the Context
    build_data_context(context, filter_list);
    IF context.is_cdb_root THEN
      l_is_cdb_root := 'Y';
    ELSE
      l_is_cdb_root := 'N';
    END IF;
 
    IF NOT context.memEnable AND NOT context.diskEnable THEN 
      context.error_xml := error_to_xml(
          'No data in AWR',
          'err_no_data_awr');
      RETURN createErrorReport(context, p_input);
    END IF;
    -- generate the activity line XML
    l_t1 := SYSTIMESTAMP;
    context.activityLineXML := getActivityLine(context);
    l_t2 := SYSTIMESTAMP;
    context.diag_picker_secs := timing_to_seconds(l_t1, l_t2);
    IF context.error_xml IS NOT NULL THEN
      RETURN createErrorReport(context, p_input);
    END IF;

    -- assume getting and organizing data is twice as expensive as time picker.
    -- Therefore, our total budget for additional info calls is the query budget 
    -- minus 3 times the time picker observed 
    add_info_budget := add_info_budget - (3 * context.diag_picker_secs);
    IF context.minimize_cost THEN
      add_info_budget := 0;
    END IF;
 
    -- Determine the down sample ratio
    IF context.exp_row_count IS NULL OR context.exp_row_count <= 1 THEN
      context.sample_ratio := 1;
    ELSE 
      context.sample_ratio := 
        greatest(1, context.est_row_count/context.exp_row_count);
    END IF;
 
    IF histogram_only THEN
      retxml := NULL;
    ELSE
      retxml := i_getashdata_xml(context);
    END IF;
    l_t3 := SYSTIMESTAMP;
    context.diag_data_secs := timing_to_seconds(l_t2, l_t3);
    IF context.error_xml IS NOT NULL THEN
      RETURN createErrorReport(context, p_input);
    END IF;

    -- generate the cpu information
    l_cpu := internalGetCPU(context);

    -- generate the queries and get the XML
    l_timing := timing_to_xml(context);
    SELECT xmlelement("report",
              xmlattributes(to_char(context.beginTimeUTC, 'MM/DD/YYYY HH24:MI:SS')
                                     as "begin_time",
                            to_char(context.endTimeUTC, 'MM/DD/YYYY HH24:MI:SS')
                                     as "end_time",
                            to_char(ROUND(NVL(context.diskTZ,context.memTZ)*24,2)) 
                                     as "time_zone",
                            REPORT_INTERNAL_VERSION as "xml_version",
                            l_is_cdb_root as "is_cdb_root"
                           ),
              l_timing, p_input,l_cpu, context.activityLineXML, retxml)
    INTO retxml
    FROM sys.dual;
 
    RETURN retxml;
  END getashdata;

  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  -- ************ PUBLIC APIS ***********************************************
  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------

  -- str_to_ascii converts a string in the DB language and character set to 
  -- ASCII8 that is safe to use in XML and XMLCDATA elements. Special 
  -- characters are masked based on UTF16 standard of \xxxx using asciistr 
  -- SQL function.
  FUNCTION str_to_ascii(s IN VARCHAR) 
  RETURN VARCHAR
  IS
    t VARCHAR2(4000);
  BEGIN
    t := asciistr(s);
    t := replace(t, CHR(0), '\0000');
    t := replace(t, CHR(91), '\005B');
    t := replace(t, CHR(93), '\005D');
    t := replace(t, CHR(60), '\003C');
    t := replace(t, CHR(62), '\003E');
    RETURN t;
  END str_to_ascii;

  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  -- fetch_sqltext_local and fetch_sqltext_root and fetch_sqltext_pdb
  --   Returns the text of a SQL (if found) 
  -- local looks at v$sql (not gv$).
  -- root looks at dba_hist_sqltext
  -- pdb looks at awr_pdb_sqltext
  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  FUNCTION fetch_sqltext_local(p_sqlid IN VARCHAR, p_dbid IN NUMBER,
                               p_time_limit IN VARCHAR)
  RETURN   VARCHAR
  IS
    l_text VARCHAR2(4000);
    l_t    TIMESTAMP := SYSTIMESTAMP;
    l_secs NUMBER;
  BEGIN
    IF p_time_limit = 'Y' AND add_info_time >= add_info_budget THEN 
      RETURN NULL;
    END IF;
    IF p_sqlid IS NULL or p_sqlid = 'NULL' OR LENGTH(p_sqlid)<>13 THEN
      RETURN NULL;
    END IF;
    EXECUTE IMMEDIATE
' SELECT max(substr(sql_text,1,:1))
    FROM   v$sql
    WHERE  sql_id = :2
      AND  rownum <= 1 '
    INTO l_text USING OMC_DEF_SQLTEXT_LEN, p_sqlid;
--dbms_output.put_line('fetch local ' || p_sqlid || ' ' ||
--(case when l_text is null then 'NULL' else 'found' end)
--|| ' ' || timing_to_seconds(l_t, SYSTIMESTAMP));
    l_secs := timing_to_seconds(l_t, SYSTIMESTAMP);
    add_info_time := add_info_time + l_secs;
    IF l_text IS NULL THEN
      RETURN fetch_sqltext_awr(p_sqlid, p_dbid, 'N', p_time_limit);
    END IF;
    RETURN str_to_ascii(l_text);
  END fetch_sqltext_local;

  FUNCTION fetch_sqltext_awr(p_sqlid IN VARCHAR, p_dbid IN NUMBER, 
                             p_is_pdb IN VARCHAR, p_time_limit IN VARCHAR)
  RETURN   VARCHAR
  IS
    l_text VARCHAR2(4000);
    l_t    TIMESTAMP := SYSTIMESTAMP;
    l_secs NUMBER;
  BEGIN
    IF p_time_limit = 'Y' AND add_info_time >= add_info_budget THEN 
      RETURN NULL;
    END IF;
    IF p_sqlid IS NULL or p_sqlid = 'NULL' OR LENGTH(p_sqlid)<>13 THEN
      RETURN NULL;
    END IF;
    IF p_is_pdb = 'N' THEN
      EXECUTE IMMEDIATE 
'SELECT max(dbms_lob.substr(sql_text,:1,1))
 FROM   dba_hist_sqltext 
 WHERE  sql_id = :2
   AND  dbid = :3
   AND  rownum <= 1'
      INTO l_text
      USING OMC_DEF_SQLTEXT_LEN, p_sqlid, p_dbid;
    ELSE 
      EXECUTE IMMEDIATE 
'SELECT max(dbms_lob.substr(sql_text,:1,1))
 FROM   awr_pdb_sqltext 
 WHERE  sql_id = :2
   AND  dbid = :3
   AND  rownum <= 1'
      INTO l_text
      USING OMC_DEF_SQLTEXT_LEN, p_sqlid, p_dbid;
    END IF;
    l_secs := timing_to_seconds(l_t, SYSTIMESTAMP);
    add_info_time := add_info_time + l_secs;
--dbms_output.put_line('fetch  root ' || p_sqlid || ' ' || 
--(case when l_text is null then 'NULL' else 'found' end)
--|| ' ' || timing_to_seconds(l_t, SYSTIMESTAMP));
    RETURN str_to_ascii(l_text);
  END fetch_sqltext_awr;

  FUNCTION fetch_obj_name_local(p_obj_id IN NUMBER, p_dbid IN NUMBER,
                                p_con_dbid IN NUMBER, p_time_limit IN VARCHAR)
  RETURN   VARCHAR
  IS
    l_name VARCHAR2(4000);
    l_text VARCHAR2(4000);
    l_t    TIMESTAMP; 
    l_secs NUMBER;
  BEGIN
    l_name := fetch_obj_name_awr(p_obj_id,p_dbid,p_con_dbid,'N',p_time_limit);
    IF l_name IS NOT NULL THEN
      RETURN str_to_ascii(l_name);
    END IF;
    IF p_time_limit = 'Y' AND add_info_time >= add_info_budget THEN 
      RETURN NULL;
    END IF;
    l_t := SYSTIMESTAMP;
    IF p_con_dbid IS NOT NULL THEN
      l_text :=
q'[ SELECT max(owner || '.' || object_name || 
           decode(subobject_name, NULL, NULL, '.' || subobject_name)) 
    FROM   cdb_objects
    WHERE  object_id = :1
      AND  con_id = con_dbid_to_id(:2)
      AND  rownum <= 1 ]';
      EXECUTE IMMEDIATE l_text
      INTO l_name
      USING p_obj_id, p_con_dbid;
    ELSE 
      l_text :=
q'[ SELECT max(owner || '.' || object_name || 
           decode(subobject_name, NULL, NULL, '.' || subobject_name)) 
    FROM   dba_objects
    WHERE  object_id = :1
      AND  rownum <= 1 ]';
      EXECUTE IMMEDIATE l_text
      INTO l_name
      USING p_obj_id;
    END IF;
    l_secs := timing_to_seconds(l_t, SYSTIMESTAMP);
    add_info_time := add_info_time + l_secs;
--dbms_output.put_line('fetch obj name local ' || p_obj_id || ' ' ||
--(case when l_name is null then 'NULL' else 'found' end)
--|| ' ' || timing_to_seconds(l_t, SYSTIMESTAMP));
    RETURN str_to_ascii(l_name);
  END fetch_obj_name_local;

  FUNCTION fetch_obj_name_awr(p_obj_id IN NUMBER, p_dbid IN NUMBER, 
                              p_con_dbid IN NUMBER, p_is_pdb IN VARCHAR,
                              p_time_limit IN VARCHAR)
  RETURN   VARCHAR
  IS
    l_name VARCHAR2(4000);
    l_text VARCHAR2(4000);
    l_t    TIMESTAMP := SYSTIMESTAMP;
    l_secs NUMBER;
  BEGIN
    IF p_time_limit = 'Y' AND add_info_time >= add_info_budget THEN 
      RETURN NULL;
    END IF;
    l_text := 
q'[SELECT max(name) 
   FROM (
    SELECT owner || '.' || object_name || 
           decode(subobject_name, NULL, NULL, '.' || subobject_name) as name
    FROM   @AWRTAB@seg_stat_obj
    WHERE  dbid = :1
      AND  obj# = :2 @PDB_PRED@
      AND  rownum <= 1
   )]';
    IF p_is_pdb = 'Y' THEN
      l_text := REPLACE(l_text, '@AWRTAB@', 'awr_pdb_');
    ELSE
      l_text := REPLACE(l_text, '@AWRTAB@', 'dba_hist_');
    END IF;
    IF p_con_dbid IS NOT NULL THEN
      l_text := REPLACE(l_text, '@PDB_PRED@', ' AND con_dbid = :3 ');
      EXECUTE IMMEDIATE l_text
      INTO l_name
      USING p_dbid, p_obj_id, p_con_dbid;
    ELSE
      l_text := REPLACE(l_text, '@PDB_PRED@', NULL);
      EXECUTE IMMEDIATE l_text
      INTO l_name
      USING p_dbid, p_obj_id;
    END IF;
    l_secs := timing_to_seconds(l_t, SYSTIMESTAMP);
    add_info_time := add_info_time + l_secs;
--dbms_output.put_line('fetch obj name awr ' || p_obj_id || ' ' || 
--(case when l_name is null then 'NULL' else 'found' end)
--|| ' ' || timing_to_seconds(l_t, SYSTIMESTAMP));
    RETURN str_to_ascii(l_name);
  END fetch_obj_name_awr;

  FUNCTION fetch_procedure_name(p_obj_id IN NUMBER, p_subobj_id IN NUMBER,
                                p_con_dbid IN NUMBER, p_time_limit IN VARCHAR)
  RETURN VARCHAR
  IS
    l_name VARCHAR2(4000);
    l_t    TIMESTAMP := SYSTIMESTAMP;
    l_secs NUMBER;
  BEGIN
    IF p_time_limit = 'Y' AND add_info_time >= add_info_budget THEN 
      RETURN NULL;
    END IF;
    IF p_con_dbid IS NULL THEN
      EXECUTE IMMEDIATE
q'[SELECT max(owner || '.' || object_name || '.' || procedure_name)
   FROM   dba_procedures
   WHERE  object_id = :1
     AND  subprogram_id = :2
     AND  rownum <= 1 ]'
      INTO l_name
      USING p_obj_id, p_subobj_id;
    ELSE
      EXECUTE IMMEDIATE
q'[SELECT max(owner || '.' || object_name || '.' || procedure_name)
   FROM   cdb_procedures
   WHERE  object_id = :1
     AND  subprogram_id = :2
     AND  con_id = con_dbid_to_id(:3)
     AND  rownum <= 1 ]'
      INTO l_name
      USING p_obj_id, p_subobj_id, p_con_dbid;
    END IF;
    l_secs := timing_to_seconds(l_t, SYSTIMESTAMP);
    add_info_time := add_info_time + l_secs;
--dbms_output.put_line('fetch procedure name ' || p_obj_id || ' ' || p_subobj_id || ' ' || 
--(case when l_name is null then 'NULL' else 'found' end)
--|| ' ' || timing_to_seconds(l_t, SYSTIMESTAMP));
    RETURN str_to_ascii(l_name);
  END fetch_procedure_name;

  FUNCTION fetch_user_name(p_user_id IN NUMBER, p_con_dbid IN NUMBER,
                           p_time_limit IN VARCHAR)
  RETURN VARCHAR
  IS
    l_name VARCHAR2(4000);
    l_t    TIMESTAMP := SYSTIMESTAMP;
    l_secs NUMBER;
  BEGIN
    IF p_time_limit = 'Y' AND add_info_time >= add_info_budget THEN 
      RETURN NULL;
    END IF;
    IF p_con_dbid IS NULL THEN
      EXECUTE IMMEDIATE
q'[SELECT max(username)
   FROM   dba_users
   WHERE  user_id = :1
     AND  rownum <= 1 ]'
      INTO l_name
      USING p_user_id;
    ELSE
      EXECUTE IMMEDIATE
q'[SELECT max(username)
   FROM   cdb_users
   WHERE  user_id = :1
     AND  con_id = con_dbid_to_id(:2)
     AND  rownum <= 1 ]'
      INTO l_name
      USING p_user_id, p_con_dbid;
    END IF;
    l_secs := timing_to_seconds(l_t, SYSTIMESTAMP);
    add_info_time := add_info_time + l_secs;
--dbms_output.put_line('fetch user name ' || p_user_id || ' ' || p_con_dbid || ' ' || 
--(case when l_name is null then 'NULL' else 'found' end)
--|| ' ' || timing_to_seconds(l_t, SYSTIMESTAMP));
    RETURN str_to_ascii(l_name);
  END fetch_user_name;

  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  -- getVersion
  --   Returns the version of the package
  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  FUNCTION getVersion RETURN VARCHAR
  IS
  BEGIN
    RETURN REPORT_INTERNAL_VERSION;
  END getVersion;

  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  -- getData
  --   Single API for all other public functions in this package.
  --  "data_type"
  --     specifies which type of API is to be used. accepted values are:
  --     "data" for ASH data
  --     "timepicker" for the Time Picker graph
  --     "histogram" for a filtered time picker.
  --     If an invalid value is given, ORA-20001 is raised as an error.
  --  "time_type"
  --     specifies how the time period is to be interpreted.
  --     "realtime" for all Real Time interfaces (from some time in the past to NOW)
  --     "incremental" for an increment over real time (bucket size must be defined)
  --     "historical" for a longer time period or a time period in the past (two time stamps)
  --     If an invalid value is given, ORA-20002 is raised as an error.
  --  "filter_list"
  --     is the filter used in the same way as the original package
  --  "args"
  --     contains the rest of the arguments in XML format.
  --     The xml format is as follows (example containing all valid arguments)
  --  
  --    <args>
  --       <dbid>87658765</dbid>
  --       <instance_number>1</instance_number>
  --       <time_since_sec>3600</time_since_sec>
  --       <begin_time_utc>07/23/2018 10:20:00</begin_time_utc>
  --       <end_time_utc>07/24/2018 08:30:00</end_time_utc>
  --       <bucket_size>30</bucket_size>
  --       <show_sql>n</show_sql>
  --       <verbose_xml>n</verbose_xml>
  --       <include_bg>n</include_bg>
  --       <minimize_cost>n</minimize_cost>
  --    </args>
  --  
  --     Arguments that are not needed or that you wish to use the default values for,
  --     do not need to be specified in the XML doc.
  --     
  --     CPU info is now included in all API calls.    
  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  FUNCTION getData(data_type   VARCHAR2,
                   time_type   VARCHAR2,
                   filter_list VARCHAR2,
                   args        VARCHAR2
  ) RETURN XMLTYPE
  IS
    l_dbid            NUMBER;
    l_instance_number NUMBER;
    l_show_sql        VARCHAR2(100);
    l_verbose_xml     VARCHAR2(100);
    l_include_bg      VARCHAR2(100);
    l_time_since_sec  NUMBER;
    l_begin_time_utc  VARCHAR2(100);
    l_end_time_utc    VARCHAR2(100);
    l_bucket_size     NUMBER;
    l_minimize_cost   VARCHAR2(100);
  
    l_data_type       VARCHAR2(100) := lower(data_type);
    l_time_type       VARCHAR2(100) := lower(time_type);
  
    l_result          XMLTYPE := NULL;
  
    CURSOR read_args(x VARCHAR2) 
    IS
    SELECT t.dbid
        ,t.instance_number
        ,t.time_since_sec 
        ,t.begin_time_utc 
        ,t.end_time_utc 
        ,t.bucket_size 
        ,decode(lower(t.show_sql), 'y', 'y', 'n') as show_sql
        ,decode(lower(t.verbose_xml), 'y', 'y', 'n') as verbose_xml
        ,decode(lower(t.include_bg), 'y', 'y', 'n') as include_bg
        ,decode(lower(t.minimize_cost), 'y', 'y', 'n') as minimize_cost
    FROM XMLTABLE('/args'
            PASSING XMLPARSE(CONTENT x)
            COLUMNS dbid NUMBER PATH 'dbid'
                   ,instance_number NUMBER PATH 'instance_number'
                   ,time_since_sec NUMBER PATH 'time_since_sec'
                   ,begin_time_utc VARCHAR2(100) PATH 'begin_time_utc'
                   ,end_time_utc VARCHAR2(100) PATH 'end_time_utc'
                   ,bucket_size NUMBER PATH 'bucket_size'
                   ,show_sql VARCHAR2(100) PATH 'show_sql'
                   ,verbose_xml VARCHAR2(100) PATH 'verbose_xml'
                   ,include_bg VARCHAR2(100) PATH 'include_bg'
                   ,minimize_cost VARCHAR2(100) PATH 'minimize_cost'
         ) t;
  BEGIN
    IF NOT l_data_type IN ('data','timepicker','histogram') THEN
      RAISE_APPLICATION_ERROR(-20001, 'Invalid value for data_type: ' || data_type);
    END IF;
  
    IF NOT l_time_type IN ('realtime','historical','incremental') THEN
      RAISE_APPLICATION_ERROR(-20002, 'Invalid value for time_type: ' || time_type);
    END IF;
    
    FOR a IN read_args(args) LOOP
      l_dbid            := a.dbid;
      l_instance_number := a.instance_number;
      l_show_sql        := a.show_sql;
      l_verbose_xml     := a.verbose_xml;
      l_include_bg      := a.include_bg;
      l_time_since_sec  := a.time_since_sec;
      l_begin_time_utc  := a.begin_time_utc;
      l_end_time_utc    := a.end_time_utc;
      l_bucket_size     := a.bucket_size;
      l_minimize_cost   := a.minimize_cost;
    END LOOP;
  
    IF lower(data_type) = 'timepicker' THEN
      IF lower(time_type) = 'realtime' THEN
        l_result := omc_ash_viewer.getTimePickerRealTime(
            l_time_since_sec, l_show_sql, l_verbose_xml, l_instance_number);
      ELSIF lower(time_type) = 'historical' THEN
        l_result := omc_ash_viewer.getTimePickerHistorical(
            l_dbid, l_begin_time_utc, l_end_time_utc, l_time_since_sec, 
            l_show_sql, l_verbose_xml, l_instance_number);
      ELSE -- incremental
        l_result := omc_ash_viewer.incrementTimePicker(
            l_begin_time_utc, l_bucket_size, 
            l_show_sql, l_verbose_xml, l_instance_number);
      END IF;
    ELSIF lower(data_type) = 'data' THEN
      IF lower(time_type) = 'realtime' THEN
        l_result := omc_ash_viewer.getDataRealTime(
            filter_list, l_time_since_sec, l_show_sql, l_verbose_xml, 
            l_include_bg, l_instance_number, l_minimize_cost);
      ELSIF lower(time_type) = 'historical' THEN
        l_result := omc_ash_viewer.getDataHistorical(
            l_dbid, filter_list, l_begin_time_utc, l_end_time_utc, 
            l_time_since_sec, l_show_sql, l_verbose_xml, 
            l_include_bg, l_instance_number, l_minimize_cost);
      ELSE -- incremental
        l_result := omc_ash_viewer.incrementData(
            filter_list, l_begin_time_utc, l_bucket_size, 
            l_show_sql, l_verbose_xml, l_include_bg, l_instance_number, 
            l_minimize_cost);
      END IF;
    ELSE -- histogram
      IF lower(time_type) = 'realtime' THEN
        l_result := omc_ash_viewer.getHistogramRealTime(
            filter_list, l_time_since_sec, l_show_sql, l_verbose_xml, 
            l_include_bg, l_instance_number);
      ELSIF lower(time_type) = 'historical' THEN
        l_result := omc_ash_viewer.getHistogramHistorical(
            l_dbid, filter_list, l_begin_time_utc, l_end_time_utc, 
            l_time_since_sec, l_show_sql, l_verbose_xml, 
            l_include_bg, l_instance_number);
      ELSE -- incremental
        l_result := omc_ash_viewer.incrementHistogram(
            filter_list, l_begin_time_utc, l_bucket_size,
            l_show_sql, l_verbose_xml, l_include_bg, l_instance_number);
      END IF;
    END IF;

    RETURN l_result;
  END getData;

  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  -- getCPUInfo
  --   Returns information about availbale CPUs in XML format at a single 
  --   point in time.
  --    - dbid : specifies which db to look for, default (NULL) is DB we are
  --             conncted to.
  --    - observationTime : approximate time in which to look for data.
  --             default (NULL) is the latest possible data available 
  --             (NOW if possible).
  -- If instance_number is NULL it means all instances. Otherwise, fetch 
  --  only data for the specified instance number.
  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  FUNCTION getCPUInfo(dbid IN NUMBER := NULL,
                      observationTime IN VARCHAR := NULL,
                      instance_number IN NUMBER := NULL)
  RETURN XMLTYPE
  IS
  BEGIN
    RETURN getCPUInfoReport(dbid, observationTime, instance_number);
  END getCPUInfo;

  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  -- getTimePickerRealTime
  --   Returns the time picker data for Real Time usage in XML format
  --   Time period is from NOW-time_since_sec to NOW. 
  --   The default time period is the last hour. 
  -- data is for entire database (all instances) we ara currently connected to
  -- ,foreground only, and in case we connect to a PDB - limited to that PDB.
  -- If instance_number is NULL it means all instances. Otherwise, fetch 
  --  only data for the specified instance number.
  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  FUNCTION getTimePickerRealTime(
      time_since_sec IN NUMBER := 3600
    , show_sql       IN VARCHAR2 := 'n'
    , verbose_xml    IN VARCHAR2 := 'n'
    , instance_number IN NUMBER := NULL)
  RETURN XMLTYPE
  IS
    context ContextType;
    l_input XMLTYPE;
  BEGIN
    context := buildBaseContextRealTime(NVL(time_since_sec,3600), 
               NVL(show_sql,'n'), NVL(verbose_xml,'n'),'n',instance_number,'n');
    SELECT xmlelement("report_parameters",xmlforest(
             'time picker real time' as "type"
            ,NVL(time_since_sec,3600) as "time_since_sec"
            ,NVL(show_sql,'n') as "show_sql"
            ,NVL(verbose_xml,'n') as "verbose_xml"
            ,instance_number as "instance_number"
           ))
    INTO l_input
    FROM SYS.DUAL;
    IF context.error_xml IS NOT NULL THEN
      RETURN createErrorReport(context, l_input);
    END IF;
    RETURN getTimePickerReport(context, l_input);
  END getTimePickerRealTime;

  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  -- incrementTimePicker
  --   Returns the time picker data for Real Time usage in XML format
  --   This function is used to get incremental data after the initial load.
  --   Incremental use case is only for Real Time.
  --   Time period is from begin_time_utc to NOW.
  --   There is no default time period. 
  --   The time is bucketized using bucket_size (in seconds). 
  --   The bucket boundaries are: 
  --     begin_time_utc, begin_time_utc+bucket_size, 
  --     begin_time_utc+2*bucket_size etc.
  -- If instance_number is NULL it means all instances. Otherwise, fetch 
  --  only data for the specified instance number.
  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  FUNCTION incrementTimePicker(
      begin_time_utc IN VARCHAR2 
    , bucket_size    IN NUMBER 
    , show_sql       IN VARCHAR2 := 'n'
    , verbose_xml    IN VARCHAR2 := 'n'
    , instance_number IN NUMBER := NULL)
  RETURN XMLTYPE
  IS
    context ContextType;
    l_input XMLTYPE;
  BEGIN
    context := buildBaseContextIncremental(
                     TO_DATE(begin_time_utc, OMC_TIME_FORMAT),
                     bucket_size, NVL(show_sql,'n'), NVL(verbose_xml,'n'), 'n', 
                     instance_number,'n');
    SELECT xmlelement("report_parameters",xmlforest(
             'time picker increment' as "type"
            ,begin_time_utc as "begin_time_utc"
            ,bucket_size as "bucket_size"
            ,NVL(show_sql,'n') as "show_sql"
            ,NVL(verbose_xml,'n') as "verbose_xml"
            ,instance_number as "instance_number"
           ))
    INTO l_input
    FROM SYS.DUAL;
    IF context.error_xml IS NOT NULL THEN
      RETURN createErrorReport(context, l_input);
    END IF;
    RETURN getTimePickerReport(context, l_input);
  END incrementTimePicker;

  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  -- getTimePickerHistorical
  --   Returns the time picker data for historical in an XML format
  --   dbid determines which RDBMS to look for, default is the one we are
  --     connected to.
  --   Time period is one of the following
  --     a) From begin_time_utc to end_time_utc if both are specified.
  --     b) From NOW-time_since_sec to NOW (default is 24 hours)
  -- If instance_number is NULL it means all instances. Otherwise, fetch 
  --  only data for the specified instance number.
  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  FUNCTION getTimePickerHistorical(
      dbid           IN NUMBER := NULL
    , begin_time_utc IN VARCHAR2 := NULL
    , end_time_utc   IN VARCHAR2 := NULL
    , time_since_sec IN NUMBER := 86400
    , show_sql       IN VARCHAR2 := 'n'
    , verbose_xml    IN VARCHAR2 := 'n'
    , instance_number IN NUMBER := NULL)
  RETURN XMLTYPE
  IS
    context ContextType;
    l_input XMLTYPE;
  BEGIN
    context := buildBaseContextHistorical( 
                  dbid, begin_time_utc, end_time_utc, NVL(time_since_sec,86400),
                  NVL(show_sql,'n'), NVL(verbose_xml,'n'), 'n', 
                  instance_number,'n');
    SELECT xmlelement("report_parameters",xmlforest(
             'time picker historical' as "type"
            ,dbid as "dbid"
            ,begin_time_utc as "begin_time_utc"
            ,end_time_utc as "end_time_utc"
            ,NVL(time_since_sec,86400) as "time_since_sec"
            ,NVL(show_sql,'n') as "show_sql"
            ,NVL(verbose_xml,'n') as "verbose_xml"
            ,instance_number as "instance_number"
           ))
    INTO l_input
    FROM SYS.DUAL;
    IF context.error_xml IS NOT NULL THEN
      RETURN createErrorReport(context, l_input);
    END IF;
    RETURN getTimePickerReport(context, l_input);
  END getTimePickerHistorical;

  -- ------------------------------------------------------------------------
  -- internalDataRealTime
  --   Returns the ASH data for Real Time Usage in an XML format
  --   Time period is from NOW-time_since_sec to NOW (default is one hour)
  --   The data can be filtered using the filter list.
  -- data is for entire database (all instances) we ara currently connected to
  -- ,foreground only, and in case we connect to a PDB - limited to that PDB.
  -- If instance_number is NULL it means all instances. Otherwise, fetch 
  --  only data for the specified instance number.
  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  FUNCTION internalDataRealTime(
      histogram_only  IN BOOLEAN
    , filter_list     IN VARCHAR2 := NULL
    , time_since_sec  IN NUMBER := 3600
    , show_sql        IN VARCHAR2 := 'n'
    , verbose_xml     IN VARCHAR2 := 'n'
    , include_bg      IN VARCHAR2 := 'n'
    , instance_number IN NUMBER := NULL
    , minimize_cost   IN VARCHAR := 'n')
  RETURN XMLTYPE
  IS
    context ContextType;
    l_input XMLTYPE;
    l_desc  VARCHAR2(100) := 'data real time';
  BEGIN
    IF histogram_only THEN
      l_desc := 'histogram real time';
    END IF;
    context := buildBaseContextRealTime(time_since_sec, show_sql, 
                   verbose_xml, include_bg, instance_number, minimize_cost);
    SELECT xmlelement("report_parameters",xmlforest(
             l_desc as "type"
            ,filter_list as "filter_list"
            ,time_since_sec as "time_since_sec"
            ,show_sql as "show_sql"
            ,verbose_xml as "verbose_xml"
            ,include_bg as "include_bg"
            ,instance_number as "instance_number"
            ,minimize_cost as "minimize_cost"
           ))
    INTO l_input
    FROM SYS.DUAL;
    validateBaseContextForData(context);
    IF context.error_xml IS NOT NULL THEN
      RETURN createErrorReport(context, l_input);
    END IF;
    IF context.minimize_cost THEN
      add_info_budget := 0;
    ELSIF time_since_sec >= 7200 THEN
      add_info_budget := 5;
    ELSE
      add_info_budget := 3;
    END IF;
    RETURN getashdata(context, l_input, filter_list, histogram_only);
  END internalDataRealTime;

  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  -- internalIncrementData
  --   Returns the ASH data for Real Time usage in XML format
  --   This function is used to get incremental data after the initial load.
  --   Incremental use case is only for Real Time.
  --   Time period is from begin_time_utc to NOW.
  --   There is no default time period. 
  --   The time is bucketized using bucket_size (in seconds). 
  --   The bucket boundaries are: 
  --     begin_time_utc, begin_time_utc+bucket_size, 
  --     begin_time_utc+2*bucket_size etc.
  --   The data can be filtered using the filter list.
  -- If instance_number is NULL it means all instances. Otherwise, fetch 
  --  only data for the specified instance number.
  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  FUNCTION internalIncrementData(
      histogram_only  IN BOOLEAN
    , filter_list     IN VARCHAR2 := NULL
    , begin_time_utc  IN VARCHAR2
    , bucket_size     IN NUMBER
    , show_sql        IN VARCHAR2 := 'n'
    , verbose_xml     IN VARCHAR2 := 'n'
    , include_bg      IN VARCHAR2 := 'n'
    , instance_number IN NUMBER := NULL
    , minimize_cost   IN VARCHAR := 'n')
  RETURN XMLTYPE
  IS
    context ContextType;
    l_input XMLTYPE;
    l_desc  VARCHAR2(100) := 'data increment';
  BEGIN
    IF histogram_only THEN
      l_desc := 'histogram increment';
    END IF;
    context := buildBaseContextIncremental(
                     TO_DATE(begin_time_utc, OMC_TIME_FORMAT),
                     bucket_size, show_sql, verbose_xml, include_bg, 
                     instance_number, minimize_cost);
    SELECT xmlelement("report_parameters",xmlforest(
             l_desc as "type"
            ,filter_list as "filter_list"
            ,begin_time_utc as "begin_time_utc"
            ,to_char(bucket_size) as "bucket_size"
            ,show_sql as "show_sql"
            ,verbose_xml as "verbose_xml"
            ,include_bg as "include_bg"
            ,instance_number as "instance_number"
            ,minimize_cost as "minimize_cost"
           ))
    INTO l_input
    FROM SYS.DUAL;
    validateBaseContextForData(context);
    IF context.error_xml IS NOT NULL THEN
      RETURN createErrorReport(context, l_input);
    END IF;
    IF context.minimize_cost THEN
      add_info_budget := 0;
    ELSE
      add_info_budget := 2.5;
    END IF;
    RETURN getashdata(context, l_input, filter_list, histogram_only);
  END internalIncrementData;

  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  -- internalDataHistorical
  --   Returns the ASH data for historical usage in an XML format
  --   dbid determines which RDBMS to look for, default is the one we are
  --     connected to.
  --   Time period is one of the following
  --     a) From begin_time_utc to end_time_utc if both are specified.
  --     b) From NOW-time_since_sec to NOW (default is 24 hours)
  --   The data can be filtered using the filter list.
  -- If instance_number is NULL it means all instances. Otherwise, fetch 
  --  only data for the specified instance number.
  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  FUNCTION internalDataHistorical(
      histogram_only  IN BOOLEAN
    , dbid            IN NUMBER := NULL
    , filter_list     IN VARCHAR2 := NULL
    , begin_time_utc  IN VARCHAR2 := NULL
    , end_time_utc    IN VARCHAR2 := NULL
    , time_since_sec  IN NUMBER := 86400
    , show_sql        IN VARCHAR2 := 'n'
    , verbose_xml     IN VARCHAR2 := 'n'
    , include_bg      IN VARCHAR2 := 'n'
    , instance_number IN NUMBER := NULL
    , minimize_cost   IN VARCHAR := 'n')
  RETURN XMLTYPE  
  IS
    context ContextType;
    l_input XMLTYPE;
    l_desc  VARCHAR2(100) := 'data historical';
  BEGIN
    IF histogram_only THEN
      l_desc := 'histogram historical';
    END IF;
    context := buildBaseContextHistorical(
                  dbid, begin_time_utc, end_time_utc, time_since_sec,
                  show_sql, verbose_xml, include_bg, instance_number, 
                  minimize_cost);
    SELECT xmlelement("report_parameters",xmlforest(
             l_desc as "type"
            ,dbid as "dbid"
            ,filter_list as "filter_list"
            ,begin_time_utc as "begin_time_utc"
            ,end_time_utc as "end_time_utc"
            ,time_since_sec as "time_since_sec"
            ,show_sql as "show_sql"
            ,verbose_xml as "verbose_xml"
            ,include_bg as "include_bg"
            ,instance_number as "instance_number"
            ,minimize_cost as "minimize_cost"
           ))
    INTO l_input
    FROM SYS.DUAL;
    validateBaseContextForData(context);
    IF context.error_xml IS NOT NULL THEN
      RETURN createErrorReport(context, l_input);
    END IF;
    IF context.minimize_cost THEN
      add_info_budget := 0;
    ELSIF context.endTimeUTC - context.beginTimeUTC < 0.1 THEN
      add_info_budget := 5;
    ELSE
      add_info_budget := 10;
    END IF;
    RETURN getashdata(context, l_input, filter_list, histogram_only);
  END internalDataHistorical;

    -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  -- getHistogramRealTime
  --   Returns the ASH histogram for Real Time Usage in an XML format
  --   Time period is from NOW-time_since_sec to NOW (default is one hour)
  --   The data can be filtered using the filter list.
  -- data is for entire database (all instances) we ara currently connected to
  -- ,foreground only, and in case we connect to a PDB - limited to that PDB.
  -- If instance_number is NULL it means all instances. Otherwise, fetch 
  --  only data for the specified instance number.
  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  FUNCTION getHistogramRealTime(
      filter_list     IN VARCHAR2 := NULL
    , time_since_sec  IN NUMBER := 3600
    , show_sql        IN VARCHAR2 := 'n'
    , verbose_xml     IN VARCHAR2 := 'n'
    , include_bg      IN VARCHAR2 := 'n'
    , instance_number IN NUMBER := NULL)
  RETURN XMLTYPE
  IS
  BEGIN
    RETURN internalDataRealTime(TRUE, filter_list, NVL(time_since_sec,3600),
              NVL(show_sql,'n'), NVL(verbose_xml,'n'),
              NVL(include_bg,'n'), instance_number, 'n');
  END getHistogramRealTime;

  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  -- incrementHistogram
  --   Returns the ASH histogram for Real Time usage in XML format
  --   This function is used to get incremental data after the initial load.
  --   Incremental use case is only for Real Time.
  --   Time period is from begin_time_utc to NOW.
  --   There is no default time period. 
  --   The time is bucketized using bucket_size (in seconds). 
  --   The bucket boundaries are: 
  --     begin_time_utc, begin_time_utc+bucket_size, 
  --     begin_time_utc+2*bucket_size etc.
  --   The data can be filtered using the filter list.
  -- If instance_number is NULL it means all instances. Otherwise, fetch 
  --  only data for the specified instance number.
  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  FUNCTION incrementHistogram(
      filter_list    IN VARCHAR2 := NULL
    , begin_time_utc IN VARCHAR2
    , bucket_size    IN NUMBER
    , show_sql       IN VARCHAR2 := 'n'
    , verbose_xml    IN VARCHAR2 := 'n'
    , include_bg      IN VARCHAR2 := 'n'
    , instance_number IN NUMBER := NULL)
  RETURN XMLTYPE
  IS
  BEGIN
    RETURN internalIncrementData(TRUE, filter_list, begin_time_utc,
              bucket_size, NVL(show_sql,'n'), NVL(verbose_xml,'n'),
              NVL(include_bg,'n'), instance_number, 'n');
  END incrementHistogram;

    -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  -- getHistogramHistorical
  --   Returns the ASH histogram for historical usage in an XML format
  --   dbid determines which RDBMS to look for, default is the one we are
  --     connected to.
  --   Time period is one of the following
  --     a) From begin_time_utc to end_time_utc if both are specified.
  --     b) From NOW-time_since_sec to NOW (default is 24 hours)
  --   The data can be filtered using the filter list.
  -- If instance_number is NULL it means all instances. Otherwise, fetch 
  --  only data for the specified instance number.
  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  FUNCTION getHistogramHistorical(
      dbid            IN NUMBER := NULL
    , filter_list     IN VARCHAR2 := NULL
    , begin_time_utc  IN VARCHAR2 := NULL
    , end_time_utc    IN VARCHAR2 := NULL
    , time_since_sec  IN NUMBER := 86400
    , show_sql        IN VARCHAR2 := 'n'
    , verbose_xml     IN VARCHAR2 := 'n'
    , include_bg      IN VARCHAR2 := 'n'
    , instance_number IN NUMBER := NULL)
  RETURN XMLTYPE
  IS
  BEGIN
    RETURN internalDataHistorical(TRUE, dbid, filter_list, begin_time_utc,
              end_time_utc, NVL(time_since_sec,86400), 
              NVL(show_sql,'n'), NVL(verbose_xml,'n'),
              NVL(include_bg,'n'), instance_number, 'n');
  END getHistogramHistorical;


  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  -- getDataRealTime
  --   Returns the ASH data for Real Time Usage in an XML format
  --   Time period is from NOW-time_since_sec to NOW (default is one hour)
  --   The data can be filtered using the filter list.
  -- data is for entire database (all instances) we ara currently connected to
  -- ,foreground only, and in case we connect to a PDB - limited to that PDB.
  -- If instance_number is NULL it means all instances. Otherwise, fetch 
  --  only data for the specified instance number.
  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  FUNCTION getDataRealTime(
      filter_list     IN VARCHAR2 := NULL
    , time_since_sec  IN NUMBER := 3600
    , show_sql        IN VARCHAR2 := 'n'
    , verbose_xml     IN VARCHAR2 := 'n'
    , include_bg      IN VARCHAR2 := 'n'
    , instance_number IN NUMBER := NULL
    , minimize_cost   IN VARCHAR2 := 'n')
  RETURN XMLTYPE
  IS
  BEGIN
    RETURN internalDataRealTime(FALSE, filter_list, NVL(time_since_sec,3600),
              NVL(show_sql,'n'), NVL(verbose_xml,'n'),
              NVL(include_bg,'n'), instance_number, NVL(minimize_cost,'n'));
  END getDataRealTime;

    -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  -- incrementData
  --   Returns the ASH data for Real Time usage in XML format
  --   This function is used to get incremental data after the initial load.
  --   Incremental use case is only for Real Time.
  --   Time period is from begin_time_utc to NOW.
  --   There is no default time period. 
  --   The time is bucketized using bucket_size (in seconds). 
  --   The bucket boundaries are: 
  --     begin_time_utc, begin_time_utc+bucket_size, 
  --     begin_time_utc+2*bucket_size etc.
  --   The data can be filtered using the filter list.
  -- If instance_number is NULL it means all instances. Otherwise, fetch 
  --  only data for the specified instance number.
  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  FUNCTION incrementData(
      filter_list    IN VARCHAR2 := NULL
    , begin_time_utc IN VARCHAR2
    , bucket_size    IN NUMBER
    , show_sql       IN VARCHAR2 := 'n'
    , verbose_xml    IN VARCHAR2 := 'n'
    , include_bg      IN VARCHAR2 := 'n'
    , instance_number IN NUMBER := NULL
    , minimize_cost   IN VARCHAR2 := 'n')
  RETURN XMLTYPE
  IS
  BEGIN
    RETURN internalIncrementData(FALSE, filter_list, begin_time_utc,
              bucket_size, NVL(show_sql,'n'), NVL(verbose_xml,'n'),
              NVL(include_bg,'n'), instance_number, NVL(minimize_cost,'n'));
  END incrementData;


  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  -- getDataHistorical
  --   Returns the ASH data for historical usage in an XML format
  --   dbid determines which RDBMS to look for, default is the one we are
  --     connected to.
  --   Time period is one of the following
  --     a) From begin_time_utc to end_time_utc if both are specified.
  --     b) From NOW-time_since_sec to NOW (default is 24 hours)
  --   The data can be filtered using the filter list.
  -- If instance_number is NULL it means all instances. Otherwise, fetch 
  --  only data for the specified instance number.
  -- ------------------------------------------------------------------------
  -- ------------------------------------------------------------------------
  FUNCTION getDataHistorical(
      dbid            IN NUMBER := NULL
    , filter_list     IN VARCHAR2 := NULL
    , begin_time_utc  IN VARCHAR2 := NULL
    , end_time_utc    IN VARCHAR2 := NULL
    , time_since_sec  IN NUMBER := 86400
    , show_sql        IN VARCHAR2 := 'n'
    , verbose_xml     IN VARCHAR2 := 'n'
    , include_bg      IN VARCHAR2 := 'n'
    , instance_number IN NUMBER := NULL
    , minimize_cost   IN VARCHAR2 := 'n')
  RETURN XMLTYPE
  IS
  BEGIN
    RETURN internalDataHistorical(FALSE, dbid, filter_list, begin_time_utc,
              end_time_utc, NVL(time_since_sec,86400), NVL(show_sql,'n'), 
              NVL(verbose_xml,'n'), NVL(include_bg,'n'), instance_number, 
              NVL(minimize_cost,'n'));
  END getDataHistorical;

END omc_ash_viewer;
/
Rem
Rem $Header: emdb/source/oracle/sysman/emdrep/sql/db/latest/instance/priv_grant_omc_ash.sql /main/1 2018/03/28 21:55:44 bram Exp $
Rem
Rem priv_grant_omc_ash.sql
Rem
Rem Copyright (c) 2018, Oracle and/or its affiliates. All rights reserved.
Rem
Rem    NAME
Rem      priv_grant_omc_ash.sql - <one-line expansion of the name>
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    BEGIN SQL_FILE_METADATA
Rem    SQL_SOURCE_FILE: emdb/source/oracle/sysman/emdrep/sql/db/latest/instance/priv_grant_omc_ash.sql
Rem    SQL_SHIPPED_FILE:
Rem    SQL_PHASE:
Rem    SQL_STARTUP_MODE: NORMAL
Rem    SQL_IGNORABLE_ERRORS: NONE
Rem    END SQL_FILE_METADATA
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    bram        03/10/18 - Created
Rem

BEGIN
    BEGIN
       EXECUTE IMMEDIATE 'GRANT EXECUTE ON omc_ash_viewer to PUBLIC';
    EXCEPTION 
       when others then
        --ignore ORA-00955
        null;
    END;

end;
/
 
