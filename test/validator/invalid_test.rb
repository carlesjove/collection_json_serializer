require 'minitest_helper'

module CollectionJsonSerializer
  class Serializer
    class Validator
      class TestInvalid < Minitest::Test
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
          @invalid_serializer = InvalidSerializer.new(@user)
          @resource = Validator.new @invalid_serializer
        end

        def test_that_it_is_invalid
          refute @resource.valid?
          refute @invalid_serializer.valid?

          assert @resource.invalid?
          assert @invalid_serializer.invalid?
        end

        def test_that_there_is_an_errors_array
          assert @resource.errors.any?
          assert @invalid_serializer.errors.any?
          assert_equal @resource.errors, @invalid_serializer.errors
        end

        def test_that_the_following_errors_exist
          assert @resource.errors.include? :href
          assert @resource.errors.include? :links
        end
      end
    end
  end
end
