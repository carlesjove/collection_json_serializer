require "minitest_helper"

module CollectionJson
  class Serializer
    class TestLinks < Minitest::Test
      include TestHelper

      def setup
        @user = User.new(name: "Carles Jove", email: "hola@carlus.cat")
        @user_serializer = UserSerializer.new(@user)
      end

      def test_item_links_attributes
        expected = [dashboard: { href: "http://example.com/my-dashboard" }]
        assert_equal expected, @user_serializer.class.links
      end
    end
  end
end
