require "minitest_helper"

module CollectionJson
  class Serializer
    class Validator
      class ItemsValidator
        class ItemsValidatorTest < MiniTest::Test
          include TestHelper

          def setup
            @user = User.new
          end

          def test_that_attributes_are_validated
            values_for_test(:invalid).each do |invalid|
              @user.name = invalid
              serializer = empty_serializer_for(@user)
              serializer.items.attributes = [:name]

              items_validator = ItemsValidator.new(serializer)

              assert items_validator.errors.any?, "should have errors"
              assert items_validator.errors.key?(:attributes),
                     "should have key attributes"
              assert items_validator.errors[:attributes][0].
                include?("attributes:name is an invalid value")
            end
          end
        end
      end
    end
  end
end

