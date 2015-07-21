require 'spec_helper'
require 'ldap_health_check/people'


module LDAPHealthCheck

  describe People do

    before do
    
      @data = {
        uri:      "ldap://localhost",
        base:     "dc=tuenti,dc=com", 
        username: "cn=admin,dc=tuenti,dc=com",
        password: "supersecret",
        filter:   "(objectClass=inetOrgPerson)"
      }

      @ds     = DataSource.new(@data[:uri], @data[:base], @data[:username], @data[:password], @data[:filter])
      @people = People.new(@ds)
    end

    it "can be created from a DataSource" do 
      People.new(@ds).must_be_instance_of(People)
    end

    it "can be respond to find_all" do 
      @people.must_respond_to(:find_all)
    end

    it "can be respond to find_by_uid" do 
      @people.must_respond_to(:find_by_uid)
    end
  end
end
