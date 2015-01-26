require 'minitest_helper'

module CollectionJson
  class Serializer
    class Validation
      class TestValidation < MiniTest::Test
        include TestHelper

        def test_that_instantiating_validation_raises_error
          user = User.new(name: 'Carles Jove')
          serializer = empty_serializer_for(user)

          assert_raises(NotImplementedError) do
            Validation.new(serializer)
          end
        end
      end
    end
  end
end

