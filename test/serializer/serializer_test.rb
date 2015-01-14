require "minitest_helper"

# Here we test Serializer's stuff _other_ than the DSL and Validations
# - For the DSL tests, check serializer/dsl_test.rb
# - For validation tests, check validator/validator_test.rb 
module CollectionJson
  class Serializer
    class TestSerializer < Minitest::Test
      include TestHelper

      def setup
        @user = User.new(name: "Carles Jove", email: "hola@carlus.cat")
        @serializer = empty_serializer_for(@user)
      end

      def test_uses_method
        @serializer.class.extensions(:open_attrs, :another_ext)
        assert @serializer.uses?(:open_attrs)
        assert @serializer.uses?(:another_ext)
        refute @serializer.uses?(:unexistent_ext)
      end
    end
  end
end
