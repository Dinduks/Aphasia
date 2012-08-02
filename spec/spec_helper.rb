require File.join(File.dirname(__FILE__), '..', 'aphasia.rb')

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
