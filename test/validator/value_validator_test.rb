require "minitest_helper"

module CollectionJson
  class Serializer
    class Validation
      class Value
        class TestValue < Minitest::Test
          include TestHelper

          def test_that_values_validate
            values_for_test(:invalid).each do |v|
              value = Value.new(v)
              refute value.valid?, "#{v} should be invalid, but was valid"
              assert value.invalid?, "#{v} should be invalid, but was valid"
            end

            values_for_test(:valid) do |v|
              value = Value.new(v)
              assert value.valid?, "#{v} should be valid, but was invalid"
              refute value.invalid?, "#{v} should be valid, but was invalid"
            end
          end
        end
      end
    end
  end
end
