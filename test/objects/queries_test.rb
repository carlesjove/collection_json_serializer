require "minitest_helper"

module CollectionJson
  class Serializer
    class Objects
      class Query
        class TestQuery < Minitest::Test
          def setup
            @user = User.new(name: "Carles Jove", email: "hola@carlus.cat")
            @user_serializer = UserSerializer.new(@user)
            @query = Query.new(@user_serializer)
          end

          def test_that_a_query_can_be_build
            expected = { 
              rel: "search",
              href: "http://example.com/search"
            }

            assert_equal expected.to_json, @query.create.to_json
          end
        end
      end
    end
  end
end
