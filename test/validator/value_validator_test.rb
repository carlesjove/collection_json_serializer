require 'minitest_helper'

module CollectionJsonSerializer
  class Serializer
    class Validator
      class Value
        class TestValue < Minitest::Test
          def test_that_values_validate
            invalid = [
              /regex/,
              :symbol,
              {},
              []
            ]

            valid = [
              "string",
              1,
              1.5,
              -1,
              true,
              false,
              nil
            ]

            invalid.each do |v|
              value = Value.new(v)
              refute value.valid?, "#{v} should be invalid, but was valid"
              assert value.invalid?, "#{v} should be invalid, but was valid"
            end

            valid.each do |v|
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
