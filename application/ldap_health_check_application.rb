require 'sinatra'
require 'sinatra/config_file'
require 'sinatra/cross_origin'
require 'json'

$LOAD_PATH<< File.expand_path('../../lib', __FILE__)
require 'ldap_health_check/people'


module LDAPHealthCheck

  class Application < Sinatra::Application
    register Sinatra::ConfigFile
    register Sinatra::CrossOrigin

    VERSION         = "1.0.0"
    VERSION_MESSAGE = { api_version: VERSION }

    configure do
      fail("You should to configure the 'APP_CONFIG_FILE' environment variable") unless ENV['APP_CONFIG_FILE']

      config_file File.expand_path(ENV['APP_CONFIG_FILE'])

      set :run,     false
      set :logging, true

      enable :cross_origin
      set :allow_origin,      :any
      set :allow_methods,     [:get]
      set :allow_credentials, true
      set :max_age,           '1728000'
      set :expose_headers,    ['Content-Type']

    end

    helpers do
      def return_response(http_code, message, data=[])
        {
          http_code: http_code,
          route:     env['REQUEST_PATH'],
          message:   message,
          people:    data
        }.to_json()
      end
    end

    error do
      return_response(500, 'Because shit happens...')
    end

    not_found do
      return_response(404, 'Resource not found')
    end

    before do
      content_type :json
    end

    get '/api/v1' do
      VERSION_MESSAGE.to_json
    end

    get '/api/v1/people' do
  
      ds   = DataSource.new(settings.uri, settings.base, settings.username, settings.password, settings.filter)
      data = People.new(ds).find_all()

      halt(404) if data.empty?
      logger.info("People that match your query: #{data.length}")
      return_response(200, 'ok', data)
    end

    get '/api/v1/people/:uid' do

      uid  = params[:uid]
      ds   = DataSource.new(settings.uri, settings.base, settings.username, settings.password, settings.filter)
      data = People.new(ds).find_by_uid(uid)

      halt(404) if data.empty?
      logger.info("Person: #{data.first.dn}")
      return_response(200, 'Ok', data)
    end
  end
end
