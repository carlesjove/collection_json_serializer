require "minitest_helper"

module CollectionJsonSerializer
  class Serializer
    class TestTemplate < Minitest::Test
      def setup
        @user = User.new(name: "Carles Jove", email: "hola@carlus.cat")
        @user_serializer = UserSerializer.new(@user)
      end

      def test_template_attributes
        assert_equal [:name, email: { prompt: "My email" }], @user_serializer.class.template
      end

      def test_that_any_attributes_can_be_passed
        custom_serializer = CustomTemplateSerializer.new(@user)
        expected = [
          :name,
          email: {
            prompt: "My email",
            anything: "at all",
            whatever: "really"
          }
        ]

        assert_equal expected, custom_serializer.class.template
      end
    end
  end
end
