require 'minitest_helper'

module CollectionJsonSerializer
  class Serializer
    class Validator
      class TestValid < Minitest::Test
        def setup
          @user = User.new(
            name: "Carles Jove",
            email: "hola@carlus.cat"
          )
          @account = Account.new(
            id: 1,
            name: "My Account",
            created_at: Time.now
          )
          @user.account = @account
          @valid_serializer = ValidSerializer.new(@user)
          @resource = Validator.new @valid_serializer
        end

        def test_that_it_is_valid
          assert @resource.valid?
          assert @valid_serializer.valid?

          refute @resource.invalid?
          refute @valid_serializer.invalid?
        end

        def test_that_there_is_not_errors_array
          refute @resource.errors.any?
          refute @valid_serializer.errors.any?
        end
      end
    end
  end
end
