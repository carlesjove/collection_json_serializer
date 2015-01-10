require "minitest_helper"

module CollectionJson
  class Serializer
    class TestLinks < Minitest::Test
      def setup
        @user = User.new(name: "Carles Jove", email: "hola@carlus.cat")
        @user_serializer = UserSerializer.new(@user)
      end

      def test_links_properties
        expected = { avatar: {
          href: "http://assets.example.com/avatar.jpg"
        } }

        assert_equal [expected], @user_serializer.items.links
      end
    end
  end
end
