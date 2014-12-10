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

          @invalid_value_types = [
            /regex/,
            :symbol,
            {},
            []
          ]

          @invalid = CollectionJsonSerializer::Serializer.new(@user)
          @invalid.class.attributes = []
          @invalid.class.href = []
          @invalid.class.links = []
          @invalid.class.template = []
        end

        # href
        def test_that_href_generates_errors
          @invalid.class.href = [self: "/users/1", collection: "www.users.com"]

          assert @invalid.invalid?
          assert @invalid.errors.include? :href
        end

        # links
        def test_that_links_generates_errors
          @invalid.class.links = [dashboard: { href: "/my-dashboard" }]
          assert @invalid.invalid?
          assert @invalid.errors.include? :links

          @invalid.class.links = [
            dashboard: {
              href: "http://valid.url.com",
              prompt: /invalid/
            }
          ]
          assert @invalid.invalid?
          assert @invalid.errors.include? :links
          assert @invalid.errors[:links].first.
                  include? 'links:dashboard:prompt is an invalid value'
        end

        def test_that_links_missing_href_generates_error
          @invalid.class.links = [dashboard: {}]
          assert @invalid.invalid?
          assert @invalid.errors.include? :links
        end

        # attributes
        def test_that_invalid_attributes_return_values_generate_errors
          @invalid.class.attributes = [:name]

          @invalid_value_types.each do |invalidate|
            @user.name = invalidate
            assert @invalid.invalid?,
                   "#{invalidate} should be invalid"
            assert @invalid.errors.include?(:attributes),
                   "#{invalidate} should be invalid"
            assert @invalid.errors[:attributes].
                    first.include? 'attributes:name is an invalid value'
          end
        end

        def test_that_invalid_attributes_properties_values_generate_errors
          @invalid_value_types.each do |invalidate|
            @invalid.class.attributes = [
              name: {
                prompt: invalidate,
                test: invalidate
              }
            ]

            assert @invalid.invalid?,
                   "#{invalidate} should be invalid"
            assert @invalid.errors.include?(:attributes),
                   "#{invalidate} should be invalid"
            assert @invalid.errors[:attributes][0].
                    include? 'attributes:name:prompt is an invalid value'
            assert @invalid.errors[:attributes][1].
                    include? 'attributes:name:test is an invalid value'
          end
        end

        # template
        def test_that_template_values_validate
          @invalid_value_types.each do |invalidate|
            @invalid.class.template = [
              name: {
                prompt: invalidate,
                name: invalidate
              }
            ]

            assert @invalid.invalid?,
                   "#{invalidate} should be invalid"
            assert @invalid.errors.include?(:template),
                   "#{invalidate} should be invalid"
            assert @invalid.errors[:template][0].
                    include? 'template:name:prompt is an invalid value'
            assert @invalid.errors[:template][1].
                    include? 'template:name:name is an invalid value'
          end
        end
      end
    end
  end
end
