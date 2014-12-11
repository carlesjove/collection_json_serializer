require "minitest_helper"

module CollectionJsonSerializer
  class Serializer
    class Validator
      class TestValidator < Minitest::Test
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

          # Invalid
          @invalid_serializer = InvalidSerializer.new(@user)
          @invalid_resource = Validator.new @invalid_serializer

          # Valid
          @valid_serializer = ValidSerializer.new(@user)
          @valid_resource = Validator.new @valid_serializer
        end

        def test_that_it_is_invalid
          refute @invalid_resource.valid?
          refute @invalid_serializer.valid?

          assert @invalid_resource.invalid?
          assert @invalid_serializer.invalid?

          # test_that_there_is_an_errors_array
          assert @invalid_resource.errors.any?
          assert @invalid_serializer.errors.any?
          assert_equal @invalid_resource.errors, @invalid_serializer.errors

          # test_that_the_following_errors_exist
          assert @invalid_resource.errors.include? :href
          assert @invalid_resource.errors.include? :links
        end

        def test_that_it_is_valid
          assert @valid_resource.valid?
          assert @valid_serializer.valid?

          refute @valid_resource.invalid?
          refute @valid_serializer.invalid?

          # test_that_there_is_an_errors_array
          refute @valid_resource.errors.any?
          refute @valid_serializer.errors.any?
          assert_equal @valid_resource.errors, @valid_serializer.errors

          # test_that_the_following_errors_exist
          refute @valid_resource.errors.include? :href
          refute @valid_resource.errors.include? :links
        end
      end
    end
  end
end
