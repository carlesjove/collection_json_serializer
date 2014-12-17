require "minitest_helper"

module CollectionJson
  class Serializer
    class TestHref < Minitest::Test
      include TestHelper

      def setup
        @user = User.new(name: "Carles Jove", email: "hola@carlus.cat")
        @user_serializer = UserSerializer.new(@user)
      end

      def test_href_object
        expected = [{
          self: "http://example.com/users/{id}",
          collection: "http://example.com/users"
        }]
        assert_equal expected, @user_serializer.class.href
      end

      def test_that_only_one_href_value_is_passed_to_builder
        multiple_href_serializer = MultipleHrefSerializer.new(@user)
        assert_equal %w(/a /b /c), multiple_href_serializer.class.href
        assert_equal "/a", multiple_href_serializer.href
      end

      def test_that_a_placeholder_can_be_used_for_urls
        user_serializer = empty_serializer_for(@user)
        user_serializer.class.attributes = [:name]
        user_serializer.class.href = [self: "http://example.com/users/{id}"]
        builder = Builder.new(user_serializer)

        expected = "http://example.com/users/#{@user.id}"
        actual = builder.pack[:collection][:items].first[:href]
        assert_equal expected, actual
      end
    end
  end
end
