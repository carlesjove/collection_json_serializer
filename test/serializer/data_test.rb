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

      # def test_that_unknown_attributes_are_silently_ignored
      #   @serializer_with_unknown_attr = UnknownAttributeSerializer.new(@user)
      #   refute @serializer_with_unknown_attr.attributes.include?(:unknown)
      #   #assert @serializer_with_unknown_attr.attributes[:unknown].nil?
      # end

      def test_that_any_attributes_can_be_passed
        custom_serializer = CustomItemSerializer.new(@user)
        expected = [name: { 
          anything: "at all", 
          whatever: "really" 
          }]

        assert_equal expected, custom_serializer.class.attributes
      end
    end
  end
end
