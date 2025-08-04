require 'rack'
require 'rack/test'
require 'sinatra'

def app
  app, _ = Rack::Builder.parse_file('config.ru')
  app
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.order = 'defined'
end

ENV['RACK_ENV'] = 'test'

if ENV['RACK_ENV'] == 'test'
  require 'rack/protection'
  module Rack
    module Protection
      class HostAuthorization
        def call(env)
          @app.call(env)
        end
      end
    end
  end
end
