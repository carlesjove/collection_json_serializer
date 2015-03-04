require "minitest_helper"

class MyConstant; end

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

        def test_that_an_url_with_placeholder_can_be_parsed
          url = "http://example.com/users/{id}"
          expected = "http://example.com/users/#{@user.id}"

          assert_equal expected, parse_url(url, @user)
        end
      end
    end
  end
end
