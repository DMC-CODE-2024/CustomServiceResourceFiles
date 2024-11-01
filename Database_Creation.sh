source ~/.bash_profile

source $commonConfigurationFilePath
dbDecryptPassword=$(java -jar  ${APP_HOME}/encryption_utility/PasswordDecryptor-0.1.jar spring.datasource.password)

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
INSERT INTO check_imei_response_param (tag, value, feature_name, language) VALUES ('CheckImeiErrorMessage', 'មានអ្វីមួយខុសប្រក្រតី សូមព្យាយាមបន្តិចទៀត។', 'CheckImei', 'kh');


INSERT IGNORE INTO eirs_response_param (tag, value, feature_name, language) VALUES ('customImeiRegisterReqLength0', 'JSON Array length is 0', 'CustomCheckImei', 'en');
INSERT INTO eirs_response_param (tag, value, feature_name, language) VALUES ('customImeiRegisterPayLoadMaxSize', 'JSON Array length is greater than MAX Allowed IMEI count', 'CustomCheckImei', 'en');


INSERT IGNORE INTO sys_param_list_value(description, display_name, interpretation, list_order, tag, tag_id, value) VALUES ('Name of Mobile Operator in Cambodia', 'Operators Name', 'METFONE', 1, 'OPERATORS', 'GSM', '1');
INSERT IGNORE INTO sys_param_list_value (description, display_name, interpretation, list_order, tag, tag_id, value) VALUES ('Name of Mobile Operator in Cambodia', 'Operators Name', 'SEATEL', 2, 'OPERATORS', 'GSM', '2');
INSERT IGNORE INTO sys_param_list_value(description, display_name, interpretation, list_order, tag, tag_id, value) VALUES ('Name of Mobile Operator in Cambodia', 'Operators Name', 'CELLCARD', 3, 'OPERATORS', 'CDMA', '3');
INSERT IGNORE INTO sys_param_list_value (description, display_name, interpretation, list_order, tag, tag_id, value) VALUES (NULL, 'Operators Name', 'SMART', 0, 'OPERATORS', 'GSM', '0');

INSERT IGNORE INTO sys_param (tag, value, feature_name) VALUES ('CustomApiAuthOperatorCheck', 'false', 'CustomCheckImei');
INSERT IGNORE INTO sys_param (tag, value, feature_name) VALUES ('CustomApiAuthWithIpCheck', 'false', 'CustomCheckImei');
INSERT IGNORE INTO sys_param (tag, value, feature_name) VALUES ('CustomApiFilePath', '/u02/eirsdata/GdceFiles/','CustomCheckImei');
INSERT IGNORE INTO sys_param (tag, value,feature_name) VALUES ('alert_api_url_path','http://64.227.146.191:9509/eirs/alert', 'Alert');
INSERT IGNORE INTO sys_param(tag, value, feature_name) VALUES ('platFormComponentApiUrl', 'http://64.227.146.191:9509/eirs', 'CustomCheckImei');

INSERT INTO feature_rule (feature, grace_action, name, post_grace_action, rule_order, user_type, failed_rule_action_grace, failed_rule_action_post_grace, output) VALUES ('CustomCheckImei', 'Skip', 'CUSTOM_GDCE', 'Skip', 1, 'default', 'Record', 'Record', 'NO');

INSERT INTO feature_rule (feature, grace_action, name, post_grace_action, rule_order, user_type, failed_rule_action_grace, failed_rule_action_post_grace, output) VALUES ('CustomCheckImei', 'Skip', 'EXIST_IN_BLACKLIST_DB', 'Skip', 2, 'default', 'Record', 'Record', 'NO');
INSERT INTO feature_rule (feature, grace_action, name, post_grace_action, rule_order, user_type, failed_rule_action_grace, failed_rule_action_post_grace, output) VALUES ('CustomCheckImei', 'Skip', 'GREYLIST_BY_LOST_STOLEN', 'Skip', 3, 'default', 'Record', 'Record', 'NO');

INSERT INTO feature_rule (feature, grace_action, name, post_grace_action, rule_order, user_type, failed_rule_action_grace, failed_rule_action_post_grace, output) VALUES ('CustomCheckImei', 'Skip', 'INVALID_IMEI', 'Skip', 4, 'default', 'Record', 'Record', 'NO');


INSERT INTO feature_rule (feature, grace_action, name, post_grace_action, rule_order, user_type, failed_rule_action_grace, failed_rule_action_post_grace, output) VALUES ('CustomCheckImei', 'Skip', 'NATIONAL_WHITELISTS', 'Skip', 5, 'default', 'Record', 'Record', 'NO');

INSERT INTO feature_rule (feature, grace_action, name, post_grace_action, rule_order, user_type, failed_rule_action_grace, failed_rule_action_post_grace, output) VALUES ('CustomCheckImei', 'Skip', 'LOCAL_MANUFACTURER', 'Skip', 6, 'default', 'Record', 'Record', 'No');

INSERT INTO feature_rule (feature, grace_action, name, post_grace_action, rule_order, user_type, failed_rule_action_grace, failed_rule_action_post_grace, output) VALUES ('CustomCheckImei', 'Skip', 'GSMA_TYPE_APPROVED', 'Skip', 7, 'default', 'Record', 'Record', 'NO');

INSERT INTO feature_rule (feature, grace_action, name, post_grace_action, rule_order, user_type, failed_rule_action_grace, failed_rule_action_post_grace, output) VALUES ('CustomCheckImei', 'Skip', 'CUSTOM_GDCE', 'Skip', 8, 'default', 'Record', 'Record', 'No');

insert ignore into cfg_feature_alert(alert_id,description,feature) values ('alert1110','Something went wrong. Exception <e> occurred for process <process_name> ','General');

INSERT INTO rule (name, output, state) VALUES ('EXIST_IN_BLACKLIST_DB', 'No', 'Enabled');
INSERT INTO rule (name, output, state) VALUES ('NATIONAL_WHITELISTS', 'No', 'Enabled');
INSERT INTO rule (name, output, state) VALUES ('CUSTOM_GDCE', 'No', 'Enabled');
INSERT INTO rule (name, output, state) VALUES ('LOCAL_MANUFACTURER', 'No', 'Enabled');
INSERT INTO rule (name, output, state) VALUES ('GSMA_TYPE_APPROVED', 'No', 'Enabled');
INSERT INTO rule (name, output, state) VALUES ('INVALID_IMEI', 'No', 'Enabled');
INSERT INTO rule (name, output, state) VALUES ('CUSTOM_GDCE', 'No', 'Enabled');
INSERT INTO rule (name, output, state) VALUES ('GREYLIST_BY_LOST_STOLEN', 'No', 'Enabled');


INSERT INTO sys_param (tag, value, feature_name, active) VALUES ('CustomAuthApiUrlPath', 'https://stage-gateway.customs.gov.kh/dmc-interface/api/v1/oauth/token', 'CustomCheckImei', 1);
INSERT INTO sys_param (tag, value, feature_name, active) VALUES ('CustomAuthApiClientId', '2', 'CustomCheckImei', 1);
INSERT INTO sys_param (tag, value, feature_name, active) VALUES ('CustomAuthApiSecretKey', 'QNzhRKixNfStVkomv5S1XsQdgb3ufgAiktF2wPMz', 'CustomCheckImei', 1);
INSERT INTO sys_param (tag, value, feature_name, active) VALUES ('CustomCheckImeiApiUrlPath', 'https://stage-gateway.customs.gov.kh/dmc-interface/api/v1/imei-tax-check', 'CustomCheckImei', 1);
INSERT INTO sys_param (tag, value, feature_name, active) VALUES ('CamDxLayerHeaderName', 'X-Road-Client', 'CustomCheckImei', 1);
INSERT INTO sys_param (tag, value, feature_name, active) VALUES ('CamDxLayerHeaderValue', 'CAMBODIA/GOV/CAMDX-20201222/GDCE_EIRS_TEST', 'CustomCheckImei', 1);

insert into sys_param(tag , value)values ( 'gdce_register_imei_update_last_run_time' , '2020-01-01');
insert into cfg_feature_alert( alert_id,description,feature )values ('alert1607','Exception <e> occurred for <process_name>.' , 'RegisterCustomImeiUpdate');

alter table gdce_data add column sim int default 0, add column brand varchar(50) default '', add column model varchar(50) default '', add column device_type varchar(50) default '', add column goods_description varchar(50) default '', drop column transaction_id  , modify column serial_number varchar(50) default '';

EOFMYSQL
