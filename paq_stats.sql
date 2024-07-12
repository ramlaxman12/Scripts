@big_job
col mq_table format a25
col realm_name format a15
col service_name format a12
col queue_name format a30
col msg_sta format 9 head 'S'
col cnt format 99,999,999

break on report
compute sum of cnt on report
select 'PAQ_MESSAGES_01A' mq_table, count(*) cnt, message_status msg_sta, realm_name, service_name, queue_name
from PAQ_MESSAGES_01A
group by realm_name, service_name, queue_name, message_status;
