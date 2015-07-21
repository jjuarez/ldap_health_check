$LOAD_PATH<< File.expand_path('../application', __FILE__)
require 'ldap_health_check_application'

run LDAPHealthCheck::Application
