require "minitest_helper"

module CollectionJson
  class Serializer
    class TestModel < Minitest::Test
      include TestHelper

      def setup
        @user = User.new(name: "Carles Jove", email: "hola@carlus.cat")
        @serializer = empty_serializer_for(@user)
        @serializer.class._extensions = [:model]
        @serializer.class._links = [
          posts: {
            href: "http://example.com/posts",
            model: "post"
          }
        ]
        @serializer.items.attributes = [:name]
        @serializer.items.links = [
          author: {
            href: "http://example.com/author",
            model: "people"
          }
        ]
      end

      def test_that_serializer_is_valid_using_model_extension
        assert @serializer.valid?, "should be valid using :model"
      end

      def test_that_a_collection_can_be_built_using_model_extension
        json = Builder.new(@serializer).pack

        assert_equal json[:collection][:items][0][:links][0][:model], "people"
        assert_equal json[:collection][:links][0][:model], "post"
      end
    end
  end
end

