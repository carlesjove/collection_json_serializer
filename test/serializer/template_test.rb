require 'minitest_helper'

module CollectionJsonRails
  class Serializer
    class TestTemplate < Minitest::Test
      def setup
        @user = User.new({name: 'Carles Jove', email: 'hola@carlus.cat'})
        @user_serializer = UserSerializer.new(@user)
      end

      def test_template_attributes
        assert_equal [:name, { email: { prompt: 'My email' } }], @user_serializer.class.template
      end
    end
  end
end
