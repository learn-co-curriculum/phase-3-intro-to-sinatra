require 'rack'
require 'rack/test'

def app
  Rack::Builder.parse_file('config.ru').first
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
