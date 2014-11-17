$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'collection_json_rails'

require 'minitest/autorun'

require 'fixtures/poro'
require 'fixtures/models'
Dir.glob(File.dirname(__FILE__) + "/fixtures/serializers/**/*.rb") { |file| require file }

require 'rails'

require 'active_support/json'
