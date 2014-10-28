require 'minitest_helper'

module CollectionJsonRails
  class Serializer
    class Builder
      class TestBuilder < Minitest::Test
        def setup
          @user = User.new({name: 'Carles Jove', email: 'hola@carlus.cat'})
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
