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
        assert_equal ["http://example.com/users"], @user_serializer.class.href
      end

      def test_that_only_one_href_value_is_passed_to_builder
        serializer = empty_serializer_for(@user)
        serializer.class.href = %w(/a /b /c)

        assert_equal %w(/a /b /c), serializer.class.href
        assert_equal "/a", serializer.href
      end
    end
  end
end
