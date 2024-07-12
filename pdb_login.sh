#!/bin/bash

source $DBA/bin/ora_standard_functions

function get_pdb_name
{
pdb_name=`sqlplus -s "/ as sysdba" << EOF
set pagesize 0 feedback off verify off heading off echo off;
select name from v\\$pdbs where con_id=3;
EOF`
}

get_pdb_name

#source /n01/oraadmin1/dba/bin/get_secrets.sh
#sys_pdb_password=$(env |grep "SYS_PASSWORD="|cut -d "=" -f 2)

#------------------------------------------------------------------------#
# Fetching the standard SYS PASSWORD
#------------------------------------------------------------------------#

  #if [[ "$SUPPORT_GROUP" = "ORACLE-SUPPORT" ]]; then
    if [[ "$ENV_CD" = "prod" ]]; then
      # source non-prod passwords
      . /tools/dba/oracle/linux_64/scripts/cfg/.DCIS_password_prod > /dev/null
    else
      # source non-prod passwords
      . /tools/dba/oracle/linux_64/scripts/cfg/.DCIS_password_non_prod > /dev/null
    fi
  #fi

SYS_PASSWD=`echo ${WALLETPASSWORDENCRYPTED}  | openssl enc -base64 -d | openssl enc -des3 -k w@ll3t -d`

domain_name=$(hostname -d)
service_name=$pdb_name.$domain_name

alias pdb='sqlplus sys/${SYS_PASSWD}@${service_name} as sysdba'
