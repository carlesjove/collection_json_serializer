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

          def test_that_links_are_validated
            values_for_test(:invalid).each do |invalid|
              serializer = empty_serializer_for(@user)
              serializer.items.links = [
                dashboard: {
                  href: "invalid url"
                }
              ]

              items_validator = ItemsValidator.new(serializer)

              assert items_validator.errors.any?, "should have errors"
              assert items_validator.errors.key?(:items),
                     "should have key items"
              assert items_validator.errors[:items][0].
                include?("items:links:dashboard:href is an invalid URL")
            end
          end
        end
      end
    end
  end
end

