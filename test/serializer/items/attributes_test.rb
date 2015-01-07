require "minitest_helper"

module CollectionJson
  class Serializer
    class TestAttributes < Minitest::Test
      def setup
        @user = User.new(name: "Carles Jove", email: "hola@carlus.cat")
        @user_serializer = UserSerializer.new(@user)
      end

      def test_attributes_properties
        assert_equal [:name, :email], @user_serializer.items.attributes
      end

      def test_that_any_attributes_can_be_passed
        custom_serializer = CustomItemSerializer.new(@user)
        expected = [
          name:
          {
            anything: "at all",
            whatever: "really"
          }
        ]

        assert_equal expected, custom_serializer.items.attributes
      end
    end
  end
end
