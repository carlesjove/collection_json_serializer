require "minitest_helper"

module CollectionJson
  class Serializer
    class Objects
      class Query
        class TestQuery < Minitest::Test
          def setup
            @user = User.new(name: "Carles Jove", email: "hola@carlus.cat")
            @user_serializer = UserSerializer.new(@user)
          end

          def test_that_a_query_can_be_build
            query = Query.new(@user_serializer, item: 0)
            expected = {
              rel: "search",
              href: "http://example.com/search"
            }

            assert_equal expected.to_json, query.create.to_json
          end

          def test_that_a_query_can_include_optional_fields
            query = Query.new(@user_serializer, item: 1)
            expected = {
              rel: "page",
              href: "http://example.com/page",
              name: "pagination",
              prompt: "Select a page number",
              data: [
                { name: "page", value: "" }
              ]
            }

            assert_equal expected.to_json, query.create.to_json
          end
        end
      end
    end
  end
end
