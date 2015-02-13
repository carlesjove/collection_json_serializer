require "minitest_helper"

module CollectionJson
  class Serializer
    class TestAttributes < Minitest::Test
      def setup
        @user = User.new(name: "Carles Jove", email: "hola@carlus.cat",
                         date_created: "2015-02-01")
        @user_serializer = UserSerializer.new(@user)
      end

      def test_attributes_properties
        expected_attributes = [:name, :email, { date_created: { prompt: "Member since" } }]
        assert_equal expected_attributes, @user_serializer.items.attributes
      end
    end
  end
end
