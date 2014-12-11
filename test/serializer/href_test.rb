require "minitest_helper"

module CollectionJsonSerializer
  class Serializer
    class TestHref < Minitest::Test
      def setup
        @user = User.new(name: "Carles Jove", email: "hola@carlus.cat")
        @user_serializer = UserSerializer.new(@user)
      end

      def test_href_object
        expected = [{
          self: "http://example.com/users/1",
          collection: "http://example.com/users"
        }]
        assert_equal expected, @user_serializer.class.href
      end

      def test_that_only_one_href_value_is_passed_to_builder
        multiple_href_serializer = MultipleHrefSerializer.new(@user)
        assert_equal %w(/a /b /c), multiple_href_serializer.class.href
        assert_equal "/a", multiple_href_serializer.href
      end
    end
  end
end
