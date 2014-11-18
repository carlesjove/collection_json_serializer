require 'minitest_helper'

module CollectionJsonSerializer
  class Serializer
    class TestData < Minitest::Test
      def setup
        @user = User.new(name: "Carles Jove", email: "hola@carlus.cat")
        @user_serializer = UserSerializer.new(@user)
      end

      def test_attributes_properties
        assert_equal [:name, :email], @user_serializer.class.attributes
      end

      def test_that_unknown_attributes_are_silently_ignored
        @serializer_with_unknown_attr = UnknownAttributeSerializer.new(@user)
        assert @serializer_with_unknown_attr.attributes[:unknown].nil?
      end
    end
  end
end
