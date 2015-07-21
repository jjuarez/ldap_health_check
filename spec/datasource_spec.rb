require 'spec_helper'
require 'ldap_health_check/datasource'


module LDAPHealthCheck

  describe DataSource do

    before do
    
      @data = {
        uri:      "ldap://localhost",
        base:     "dc=tuenti,dc=com", 
        username: "cn=admin,dc=tuenti,dc=com",
        password: "supersecret",
        filter:   "(objectClass=inetOrgPerson)"
      }

      @ds = DataSource.new(@data[:uri], @data[:base], @data[:username], @data[:password], @data[:filter])
    end

    it "can be created by parameters" do 
      DataSource.new(
        @data[:uri],
        @data[:base],
        @data[:username],
        @data[:password],
        @data[:filter]).must_be_instance_of(DataSource)
    end

    it "can be respond to find_all" do 
      @ds.must_respond_to(:find_all)
    end

    it "can be respond to find_by_uid" do 
      @ds.must_respond_to(:find_by_uid)
    end
  end
end
