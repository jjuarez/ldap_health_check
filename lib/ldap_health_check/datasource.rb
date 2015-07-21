require 'net/ldap'
require 'uri'


module LDAPHealthCheck

  class DataSource

    TLS_SCHEME = 'ldaps'

    def initialize(uri, base, username, password, filter)

      parsed_uri    = URI.parse(uri)
      build_options = {
        host: parsed_uri.host,
        port: parsed_uri.port,
        base: base,
        auth: { method: :simple, username: username, password: password }
      }

      build_options[:encryption] = { method: :simple_tls } if parsed_uri.scheme == TLS_SCHEME

      @connection     = ::Net::LDAP.new(build_options)
      @default_filter = ::Net::LDAP::Filter.construct(filter)

      self
    end

    def find_all()
      @connection.search(filter: @default_filter)
    end

    def find_by_uid(uid)
      @connection.search(filter: @default_filter & ::Net::LDAP::Filter.eq('uid', uid))
    end
  end
end
