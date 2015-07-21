# encoding: utf-8
require 'spec_helper'
require 'net/ldap/entry'
require 'ldap_health_check/inetorgperson'


module LDAPHealthCheck

  describe InetOrgPerson do

    before do

      @suffix = "dc=tuenti,dc=com"
      @ou     = "people"
      @uid    = "jjuarez"
      @dn     = "uid=#{@uid},ou=#{@ou},#{@suffix}"
      @cn     = "Javier Juarez Martinez"
      @sn     = "Juarez Martinez"
      @mail   = ["jjuarez@tuenti.com"]

      @entry = ::Net::LDAP::Entry.from_single_ldif_string(File.read("spec/fixtures/ldif/#{@dn}.ldif"))

      @data = {
        dn:   @dn,
        uid:  @uid,
        cn:   @cn, 
        sn:   @sn,
        mail: @mail
      }

      @ioph = InetOrgPerson.build(@data)
      @iope = InetOrgPerson.build(@entry)
    end

    it "can be created from a LDAP entry" do
      InetOrgPerson.build(@entry).must_be_instance_of(InetOrgPerson)
    end

    it "can be created from a hash" do
      InetOrgPerson.build(@data).must_be_instance_of(InetOrgPerson)
    end

    it "can be created from parameters" do
      InetOrgPerson.new(@dn, @uid, @cn, @sn, @mail).must_be_instance_of(InetOrgPerson)
    end

    it "can´t be created from other kind of objects" do
      proc { InetOrgPerson.build("Foo String") }.must_raise(StandardError) 
    end

    it "has a DN" do    
      @ioph.dn.must_equal(@dn)
      @iope.dn.must_equal(@dn)
    end

    it "has a UID" do
      @ioph.uid.must_equal(@uid)
      @iope.uid.must_equal(@uid)
    end

    it "has a CN" do
      @ioph.cn.must_equal(@cn)
      @iope.cn.must_equal(@cn)
    end

    it "has a SN" do
      @ioph.sn.must_equal(@sn)
      @iope.sn.must_equal(@sn)
    end

    it "has at least a mail" do

      @ioph.mail.must_be_instance_of(Array)
      @iope.mail.must_equal(@mail)

      @ioph.mail.must_be_instance_of(Array)
      @iope.mail.must_equal(@mail)
    end

    it "is JSON serializable" do

      @ioph.must_respond_to(:to_json)
      JSON.parse(@ioph.to_json()).must_be_instance_of(Hash)

      @iope.must_respond_to(:to_json)
      JSON.parse(@iope.to_json()).must_be_instance_of(Hash)
    end
  end
end