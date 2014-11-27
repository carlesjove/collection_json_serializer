require 'minitest_helper'

module CollectionJsonSerializer
  class Serializer
    class TestHref < Minitest::Test
      def setup
        @user = User.new(name: "Carles Jove", email: "hola@carlus.cat")
        @user_serializer = UserSerializer.new(@user)
      end

      def test_href_object
        assert_equal ["/users"], @user_serializer.class.href
      end

      def test_that_only_one_value_is_passed
        skip
      end
    end
  end
end
