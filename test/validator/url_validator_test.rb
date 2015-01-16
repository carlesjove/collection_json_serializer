require "minitest_helper"

module CollectionJson
  class Serializer
    class Validator
      class Url
        class TestUrl < Minitest::Test
          include TestHelper

          def test_that_urls_validate
            urls_for_test(:invalid).each do |url|
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
