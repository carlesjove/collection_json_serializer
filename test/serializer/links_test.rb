require "minitest_helper"

module CollectionJsonSerializer
  class Serializer
    class TestLinks < Minitest::Test
      def setup
        @user = User.new(name: "Carles Jove", email: "hola@carlus.cat")
        @user_serializer = UserSerializer.new(@user)
      end

      def test_item_links_attributes
        expected = [dashboard: { href: "http://example.com/my-dashboard" }]
        assert_equal expected, @user_serializer.class.links
      end

      def test_item_links_attributes_can_take_unlimited_properties
        custom_serializer = CustomItemLinksSerializer.new(@user)
        expected = [dashboard: { href: "/my-dashboard", anything: "at all", whatever: "really" }]
        assert_equal expected, custom_serializer.class.links
      end
    end
  end
end
