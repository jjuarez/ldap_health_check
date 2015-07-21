require 'json'

module LDAPHealthCheck

  class InetOrgPerson

    DEFAULT_ENCODING = 'UTF-8'

    def self.build(data)

      case data
        when ::Net::LDAP::Entry then
          InetOrgPerson.new(
            data.dn,
            data[:uid].first,
            data[:cn].first.force_encoding(DEFAULT_ENCODING),
            data[:sn].first.force_encoding(DEFAULT_ENCODING),
            data[:mail])

        when Hash then
          InetOrgPerson.new(
            data[:dn],
            data[:uid],
            data[:cn].force_encoding(DEFAULT_ENCODING),
            data[:sn].force_encoding(DEFAULT_ENCODING),
            data[:mail])
        else
          raise StandardError.new("Invalid data type: #{data.class.name}")
        end  
    end

    def initialize(dn, uid, cn, sn, mail)

      @dn   = dn
      @uid  = uid
      @cn   = cn
      @sn   = sn
      @mail = mail

      self
    end

    def to_json(*a)
      { 
        'json_class' =>"InetOrgPerson",
        'data'       =>{ 'dn' =>@dn, 'uid' =>@uid, 'cn' => @cn, 'sn' =>@sn, 'mail' =>@mail } 
      }.to_json(*a)
    end

    attr_reader :dn, :uid, :cn, :sn, :mail
  end
end
