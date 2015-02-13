require "minitest_helper"

module CollectionJson
  class Serializer
    class TestDSL < Minitest::Test
      def setup
        @user = User.new(name: "Carles Jove", email: "hola@carlus.cat",
                         date_created: "2015-02-01")
        @serializer = Serializer.new(@user)
      end

      def test_top_level_dsl
        assert @serializer.respond_to?(:href)
        assert @serializer.respond_to?(:links)
        assert @serializer.respond_to?(:template)
        assert @serializer.respond_to?(:queries)
        assert @serializer.respond_to?(:items)
        assert @serializer.respond_to?(:extensions)
      end

      def test_items_dsl
        assert_equal Items, @serializer.items.class
        assert @serializer.items.respond_to?(:attributes)
        assert @serializer.items.respond_to?(:links)
        assert @serializer.items.respond_to?(:href)
      end
    end
  end
end
