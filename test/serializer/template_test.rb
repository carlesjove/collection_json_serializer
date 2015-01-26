require "minitest_helper"

module CollectionJson
  class Serializer
    class TestTemplate < Minitest::Test
      def setup
        @user = User.new(name: "Carles Jove", email: "hola@carlus.cat")
        @user_serializer = UserSerializer.new(@user)
      end

      def test_template_attributes
        expected = [
          :name,
          { email: { prompt: "My email" } },
          :password
        ]

        assert_equal expected, @user_serializer.class.template
      end
    end
  end
end
