require 'ldap_health_check/datasource'
require 'ldap_health_check/inetorgperson'


module LDAPHealthCheck

  class People

    def initialize(datasource)

      @ds = datasource

      self
    end

    def find_all()
      @ds.find_all().map { |e| InetOrgPerson.build(e) }
    end

    def find_by_uid(uid)

      entries = @ds.find_by_uid(uid)

      return [] if entries.length == 0

      entries.map { |e| InetOrgPerson.build(e) }
    end
  end
end
