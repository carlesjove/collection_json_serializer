require "minitest_helper"

module CollectionJson
  class Serializer
    class TestQueries < Minitest::Test
      def setup
        @user = User.new(name: "Carles Jove", email: "hola@carlus.cat")
        @user_serializer = UserSerializer.new(@user)
      end

      def test_template_attributes
        expected = [
          search: { 
            href: "http://example.com/search",
            name: false
          },
          pagination: {
            rel: "page",
            href: "http://example.com/page",
            prompt: "Select a page number",
            data: [
              { name: "page" }
            ]
          }
        ]

        assert_equal expected, @user_serializer.class.queries
      end
    end
  end
end
