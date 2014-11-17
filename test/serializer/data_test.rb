require 'minitest_helper'

module CollectionJsonRails
  class Serializer
    class TestData < Minitest::Test
      def setup
        @user = User.new(name: "Carles Jove", email: "hola@carlus.cat")
        @user_serializer = UserSerializer.new(@user)
      end

      def test_attributes_properties
        assert_equal [:name, :email], @user_serializer.class.attributes
      end
    end
  end
end
