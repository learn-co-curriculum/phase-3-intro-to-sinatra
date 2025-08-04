require 'rack'
require 'rack/test'

def app
  Rack::Builder.parse_file('config.ru')
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.order = 'defined'
end
