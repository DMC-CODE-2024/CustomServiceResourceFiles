source ~/.bash_profile

source $commonConfigurationFile
dbDecryptPassword=$(java -jar  ${pass_dypt} spring.datasource.password)

mysql  -h$dbIp -P$dbPort -u$dbUsername -p${dbDecryptPassword} $appdbName <<EOFMYSQL
 
CREATE TABLE  IF NOT EXISTS check_imei_req_detail (
  id int NOT NULL AUTO_INCREMENT,
  created_on timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  imei varchar(20) DEFAULT '',
  msisdn varchar(20) DEFAULT '',
  operator varchar(20) DEFAULT '',
  imsi varchar(20) DEFAULT '',
  language varchar(8) DEFAULT '',
  request_process_status varchar(10) DEFAULT '',
  imei_process_status varchar(10) DEFAULT '',
  channel varchar(10) DEFAULT '',
  check_process_time int DEFAULT '0',
  compliance_status varchar(200) DEFAULT '',
  utm_source varchar(50) DEFAULT '',
  browser varchar(255) DEFAULT '',
  public_ip varchar(50) DEFAULT '',
  header_browser varchar(255) DEFAULT '',
  header_public_ip varchar(50) DEFAULT '',
  symbol_color varchar(15) DEFAULT '',
  device_id varchar(50) DEFAULT '',
  os_type varchar(20) DEFAULT '',
  fail_process_description varchar(255) DEFAULT '',
  compliance_value int DEFAULT '0',
  request_id varchar(20) DEFAULT '',
  brand_name varchar(30) DEFAULT '',
  model_name varchar(30) DEFAULT '',
  manufacturer varchar(100) DEFAULT '',
  marketing_name varchar(150) DEFAULT '',
  device_type varchar(30) DEFAULT '',
  PRIMARY KEY (id)
) ;

CREATE TABLE  IF NOT EXISTS gdce_check_imei_req (
  id int NOT NULL AUTO_INCREMENT,
  created_on timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  imei varchar(20) DEFAULT '',
  serial_number varchar(20) DEFAULT '',
  status varchar(20) DEFAULT '',
  remark varchar(50) DEFAULT '',
  request_id varchar(23) DEFAULT '',
  imei_count int DEFAULT '0',
  file_name varchar(30) DEFAULT '',
  success_count int DEFAULT '0',
  fail_count int DEFAULT '0',
  PRIMARY KEY (id)
) ;

 CREATE TABLE IF NOT EXISTS gdce_data (
  id int NOT NULL AUTO_INCREMENT,
  imei varchar(20) DEFAULT NULL,
  created_on timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  importer_id varchar(25) DEFAULT '',
  importer_name varchar(50) DEFAULT '',
  serial_number varchar(15) DEFAULT '',
  registration_date timestamp NULL DEFAULT '',
  date_of_actual_import timestamp NULL DEFAULT '',
  is_used int DEFAULT '0',
  is_custom_tax_paid int DEFAULT '0',
  actual_imei varchar(20) DEFAULT '',
  transaction_id varchar(20) DEFAULT '',
  source varchar(20) DEFAULT '',
  request_id varchar(20) DEFAULT '',
  PRIMARY KEY (id),
  UNIQUE KEY index_un_imei (imei)
);

 CREATE TABLE IF NOT EXISTS gdce_register_imei_req (
  id int NOT NULL AUTO_INCREMENT,
  created_on timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status varchar(20) DEFAULT '',
  remark varchar(50) DEFAULT '',
  request_id varchar(20) DEFAULT '',
  imei_count int DEFAULT '0',
  success_count int DEFAULT '0',
  fail_count int DEFAULT '0',
  file_name varchar(50) DEFAULT '',
  http_status_code varchar(10) DEFAULT '',
  PRIMARY KEY (id)
) ;

CREATE TABLE IF NOT EXISTS gdce_auth_token_detail (
  id int NOT NULL AUTO_INCREMENT,
  created_on timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  token text,
  remark varchar(50) DEFAULT '',
  expire_on timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS gdce_api_call_history (
  id int NOT NULL AUTO_INCREMENT,
  created_on timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  imei varchar(20) DEFAULT '',
  status varchar(20) DEFAULT '',
  remark varchar(50) DEFAULT '',
  compliant_status varchar(10) DEFAULT '',
  source varchar(50) DEFAULT '',
  PRIMARY KEY (id)
);
 
 
INSERT IGNORE INTO check_imei_response_param(tag, value, feature_name, language) VALUES ('CheckImeiErrorMessage', 'Something went wrong, Please try after some time', 'CheckImei', 'en');
INSERT IGNORE INTO check_imei_response_param (tag, value, feature_name, language) VALUES ('CheckImeiErrorMessage', 'មានអ្វីមួយខុសប្រក្រតី សូមព្យាយាមបន្តិចទៀត។', 'CheckImei', 'kh');

INSERT IGNORE INTO eirs_response_param (tag, value, feature_name, language) VALUES ('customImeiRegisterReqLength0', 'JSON Array length is 0', 'CustomCheckImei', 'en');
INSERT IGNORE INTO eirs_response_param (tag, value, feature_name, language) VALUES ('customImeiRegisterPayLoadMaxSize', 'JSON Array length is greater than MAX Allowed IMEI count', 'CustomCheckImei', 'en');
 
INSERT IGNORE INTO feature_rule (feature, grace_action, name, post_grace_action, rule_order, user_type, failed_rule_action_grace, failed_rule_action_post_grace, output) VALUES ('CustomCheckImei', 'Skip', 'CUSTOM_GDCE', 'Skip', 1, 'default', 'Record', 'Record', 'NO');
INSERT IGNORE INTO feature_rule (feature, grace_action, name, post_grace_action, rule_order, user_type, failed_rule_action_grace, failed_rule_action_post_grace, output) VALUES ('CustomCheckImei', 'Skip', 'EXIST_IN_BLACKLIST_DB', 'Skip', 2, 'default', 'Record', 'Record', 'NO');
INSERT IGNORE INTO feature_rule (feature, grace_action, name, post_grace_action, rule_order, user_type, failed_rule_action_grace, failed_rule_action_post_grace, output) VALUES ('CustomCheckImei', 'Skip', 'GREYLIST_BY_LOST_STOLEN', 'Skip', 3, 'default', 'Record', 'Record', 'NO');
INSERT IGNORE INTO feature_rule (feature, grace_action, name, post_grace_action, rule_order, user_type, failed_rule_action_grace, failed_rule_action_post_grace, output) VALUES ('CustomCheckImei', 'Skip', 'INVALID_IMEI', 'Skip', 4, 'default', 'Record', 'Record', 'NO');
INSERT IGNORE INTO feature_rule (feature, grace_action, name, post_grace_action, rule_order, user_type, failed_rule_action_grace, failed_rule_action_post_grace, output) VALUES ('CustomCheckImei', 'Skip', 'NATIONAL_WHITELISTS', 'Skip', 5, 'default', 'Record', 'Record', 'NO');
INSERT IGNORE INTO feature_rule (feature, grace_action, name, post_grace_action, rule_order, user_type, failed_rule_action_grace, failed_rule_action_post_grace, output) VALUES ('CustomCheckImei', 'Skip', 'LOCAL_MANUFACTURER', 'Skip', 6, 'default', 'Record', 'Record', 'No');
INSERT IGNORE INTO feature_rule (feature, grace_action, name, post_grace_action, rule_order, user_type, failed_rule_action_grace, failed_rule_action_post_grace, output) VALUES ('CustomCheckImei', 'Skip', 'GSMA_TYPE_APPROVED', 'Skip', 7, 'default', 'Record', 'Record', 'NO');
insert IGNORE  into cfg_feature_alert(alert_id,description,feature) values ('alert1110','Something went wrong. Exception <e> occurred for process <process_name> ','CustomCheckImei');

INSERT IGNORE INTO rule (name, output, state) VALUES ('EXIST_IN_BLACKLIST_DB', 'No', 'Enabled');
INSERT IGNORE INTO rule (name, output, state) VALUES ('NATIONAL_WHITELISTS', 'No', 'Enabled');
INSERT IGNORE INTO rule (name, output, state) VALUES ('CUSTOM_GDCE', 'No', 'Enabled');
INSERT IGNORE INTO rule (name, output, state) VALUES ('LOCAL_MANUFACTURER', 'No', 'Enabled');
INSERT IGNORE INTO rule (name, output, state) VALUES ('GSMA_TYPE_APPROVED', 'No', 'Enabled');
INSERT IGNORE INTO rule (name, output, state) VALUES ('INVALID_IMEI', 'No', 'Enabled');

INSERT IGNORE INTO rule (name, output, state) VALUES ('GREYLIST_BY_LOST_STOLEN', 'No', 'Enabled');

INSERT IGNORE INTO sys_param (tag, value, feature_name ,type,active,remark,user_type,modified_by  ) VALUES ('CustomAuthApiUrlPath', 'https://stage-gateway.customs.gov.kh/dmc-interface/api/v1/oauth/token', 'CustomCheckImei',0,1,'','','' );
INSERT IGNORE INTO sys_param (tag, value, feature_name,type,active,remark,user_type,modified_by   ) VALUES ('CustomAuthApiClientId', '2', 'CustomCheckImei',0,1,'','','' );
INSERT IGNORE INTO sys_param (tag, value, feature_name,type,active,remark,user_type,modified_by   ) VALUES ('CustomAuthApiSecretKey', 'QNzhRKixNfStVkomv5S1XsQdgb3ufgAiktF2wPMz', 'CustomCheckImei',0,1,'','','');
INSERT IGNORE INTO sys_param (tag, value, feature_name,type,active,remark,user_type,modified_by   ) VALUES ('CustomCheckImeiApiUrlPath', 'https://stage-gateway.customs.gov.kh/dmc-interface/api/v1/imei-tax-check', 'CustomCheckImei',0,1,'','','' );
INSERT IGNORE INTO sys_param (tag, value, feature_name,type,active,remark,user_type,modified_by   ) VALUES ('CamDxLayerHeaderName', 'X-Road-Client', 'CustomCheckImei',0,1,'','','');
INSERT IGNORE INTO sys_param (tag, value, feature_name,type,active,remark,user_type,modified_by   ) VALUES ('CamDxLayerHeaderValue', 'CAMBODIA/GOV/CAMDX-20201222/GDCE_EIRS_TEST', 'CustomCheckImei',0,1,'','','');

INSERT IGNORE INTO sys_param (tag, value, feature_name,type,active,remark,user_type,modified_by ) VALUES ('CustomApiFilePath', '/u02/eirsdata/GdceFiles/','CustomCheckImei',0,1,'','','');
INSERT IGNORE INTO sys_param (tag, value,feature_name,type,active,remark,user_type,modified_by ) VALUES ('alert_api_url_path','http://64.227.146.191:9509/eirs/alert', 'Alert',0,1,'','','');
INSERT IGNORE INTO sys_param(tag, value, feature_name,type,active,remark,user_type,modified_by ) VALUES ('platFormComponentApiUrl', 'http://64.227.146.191:9509/eirs', 'CustomCheckImei',0,1,'','','');

INSERT IGNORE INTO sys_param (tag, value, feature_name,type,active,remark,user_type,modified_by ) VALUES ('CustomApiAuthOperatorCheck', 'false', 'CustomCheckImei',0,1,'','','');
INSERT IGNORE INTO sys_param (tag, value, feature_name,type,active,remark,user_type,modified_by ) VALUES ('CustomApiAuthWithIpCheck', 'false', 'CustomCheckImei',0,1,'','','');

insert IGNORE into sys_param(tag , value,feature_name ,type,active,remark,user_type,modified_by )values ( 'gdce_register_imei_update_last_run_time' , '2020-01-01' , 'CustomCheckImei',0,1,'','','');
insert IGNORE into cfg_feature_alert( alert_id,description,feature )values ('alert1607','Exception <e> occurred for <process_name>.' , 'RegisterCustomImeiUpdate');


alter table gdce_data add column sim int default 0, add column brand varchar(255) default '', add column model varchar(255) default '', add column device_type varchar(50) default '', add column goods_description varchar(255) default '', drop column transaction_id  , modify column serial_number varchar(50) default '';

EOFMYSQL
