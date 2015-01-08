require "minitest_helper"

module CollectionJson
  class Serializer
    class TestItems < Minitest::Test
      def setup
        @user = User.new(name: "Carles Jove", email: "hola@carlus.cat")
        @user_serializer = UserSerializer.new(@user)
      end

      def test_an_items_instance_is_created
        assert_equal Items, @user_serializer.items.class
      end

      def test_that_items_has_an_attributes_dsl
        assert @user_serializer.items.respond_to?(:attributes)
      end

      def test_that_items_has_a_links_dsl
        assert @user_serializer.items.respond_to?(:links)
      end
    end
  end
end
