require "minitest_helper"

module CollectionJson
  class Serializer
    class TestItemsHref < Minitest::Test
      include TestHelper

      def setup
        @user = User.new(name: "Carles Jove", email: "hola@carlus.cat")
        @user_serializer = UserSerializer.new(@user)
      end

      def test_href_object
        expected = "http://example.com/users/{id}"
        assert_equal expected, @user_serializer.items.href
      end

      def test_that_only_one_href_is_passed_if_multiple_strings
        multiple_href_serializer = empty_serializer_for(@user)
        multiple_href_serializer.items.href("/a", "/b", "/c")

        assert_equal "/a", multiple_href_serializer.items.href
      end

      def test_that_only_one_href_is_passed_if_an_array
        multiple_href_serializer = empty_serializer_for(@user)
        multiple_href_serializer.items.href(%w(/a /b /c))

        assert_equal "/a", multiple_href_serializer.items.href
      end

      def test_that_a_placeholder_can_be_used_for_urls
        user_serializer = empty_serializer_for(@user)
        user_serializer.items.attributes = [:name]
        user_serializer.items.href("http://example.com/users/{id}")
        builder = Builder.new(user_serializer)

        expected = "http://example.com/users/#{@user.id}"
        actual = builder.pack[:collection][:items].first[:href]

        assert_equal expected, actual
      end
    end
  end
end
