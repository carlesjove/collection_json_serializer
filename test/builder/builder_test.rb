require 'minitest_helper'

module CollectionJsonRails
  class Serializer
    class Builder
      class TestBuilder < Minitest::Test
        def setup
          @user = User.new({name: 'Carles Jove', email: 'hola@carlus.cat'})
          @account = Account.new({id: 1, name: 'My Account', created_at: Time.now})
          @user.account = @account
          @user_serializer = UserSerializer.new(@user)
          @builder = Builder.new(@user_serializer)
        end

        def test_response_format
          expected = {
            collection: {
              items: [
                {
                  data: [
                    { name: 'name', value: 'Carles Jove' },
                    { name: 'email', value: 'hola@carlus.cat' }
                  ],
                  links: [
                    { name: 'account', href: "/accounts/#{@account.id}" },
                    { name: 'dashboard', href: "/my-dashboard" }
                  ]
                }
              ],
              template: {
                data: [
                  { name: 'name', value: '' },
                  { name: 'email', value: '', prompt: 'My email' }
                ]
              }
            }
          }

          assert_equal expected.to_json, @builder.to_json
        end
      end
    end
  end
end
