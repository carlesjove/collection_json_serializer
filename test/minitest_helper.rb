$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'collection_json_serializer'

require 'minitest/autorun'

require 'fixtures/poro'
require 'fixtures/models'
Dir.glob(File.dirname(__FILE__) + "/fixtures/serializers/**/*.rb") { |file| require file }

require 'active_support/json'
require 'active_support/inflector'
