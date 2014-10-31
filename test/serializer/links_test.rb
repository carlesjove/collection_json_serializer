require 'minitest_helper'

module CollectionJsonRails
  class Serializer
    class TestLinks < Minitest::Test
      def setup
        @user = User.new({name: 'Carles Jove', email: 'hola@carlus.cat'})
        @user_serializer = UserSerializer.new(@user)
      end

      def test_item_links_attributes
        assert_equal [:account, { dashboard: '/dashboard'}], @user_serializer.class.links
      end
    end
  end
end
