$LOAD_PATH<< File.expand_path('../../lib', __FILE__)

require 'sinatra/base'
require 'yaml'
require 'json'
require 'ldap_health_check/people'


module LDAPHealthCheck

  class Application < Sinatra::Application

    VERSION         = "1.0.0"
    VERSION_MESSAGE = { api_version: VERSION }

    configure do

      set :run,             false
      set :logging,         true
      set :root,            File.expand_path('../..', __FILE__)

      set :config_filename, File.expand_path(File.join(settings.root, 'config', 'config.yaml'))
      set :config,          YAML.load(IO.read(settings.config_filename))[settings.environment]
    end

    helpers do

      def return_error(http_error, message)
        {
          http_error: http_error,
          route: env['REQUEST_PATH'],
          message: message
        }.to_json()
      end
  
      def return_response(http_error, data)
        {
          http_error: http_error,
          route: env['REQUEST_PATH'],
          people: data
        }.to_json()
      end
    end

    error do
      return_error(500, 'Opps! this is an error')
    end

    not_found do
      return_error(404, 'Resource not found')
    end

    before do
      content_type :json
      headers "#{settings.config[:custom_header_key]}" => "#{settings.config[:custom_header_value]}"
    end

    get '/' do
      redirect('/api/v1', 301)
    end

    get '/api/v1' do
      VERSION_MESSAGE.to_json
    end

    get '/api/v1/people' do
  
      data = People.new(DataSource.build(settings.config)).find_all()

      logger.info("Number of people in your query: #{data.length}")

      halt(404, "/api/v1/people") if data.empty?
      return_response(200, data)
    end

    get '/api/v1/people/:uid' do

      uid  = params[:uid]
      data = People.new(DataSource.build(settings.config)).find_by_uid(uid)

      logger.info("Person: #{data.to_json()}")

      halt(404, "/api/v1/people/#{uid}") if data.empty?
      return_response(200, data)
    end
  end
end