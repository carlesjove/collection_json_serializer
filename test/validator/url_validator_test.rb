require 'minitest_helper'

module CollectionJsonSerializer
  class Serializer
    class Validator
      class Url
        class TestUrl < Minitest::Test
          def test_that_urls_validate
            invalid = %w(
              /hello
              http:hello
              )
            
            invalid.each do |url|
              value = Url.new(url)
              refute value.valid?
              assert value.invalid?
            end
          end
        end
      end
    end
  end
end
