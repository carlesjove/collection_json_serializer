require "minitest_helper"

module CollectionJson
  class Serializer
    module Support
      class TestSupport < Minitest::Test
        include CollectionJson::Serializer::Support

        def setup
          @user = User.new(name: "Carles Jove", email: "hola@carlus.cat")
          @user_serializer = UserSerializer.new(@user)
          @builder = Builder.new(@user_serializer)
        end

        def test_extract_value
          actual = extract_value_from(@user_serializer.resources.first, :name)
          assert_equal "Carles Jove", actual
        end
      end
    end
  end
end
