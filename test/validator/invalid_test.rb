require 'minitest_helper'

module CollectionJsonSerializer
  class Serializer
    class Validator
      class TestInvalid < Minitest::Test
        def setup
          @invalid = CollectionJsonSerializer::Serializer.new(@user)
          @invalid.class.attributes = []
          @invalid.class.href = []
          @invalid.class.links = []
          @invalid.class.template = []
        end

        def test_that_href_generates_errors
          @invalid.class.href = [self: "/users/1", collection: "www.users.com"]

          assert @invalid.invalid?
          assert @invalid.errors.include? :href
        end

        def test_that_links_generates_errors
          @invalid.class.links = [dashboard: { href: "/my-dashboard" }]

          assert @invalid.invalid?
          assert @invalid.errors.include? :links
        end
      end
    end
  end
end
