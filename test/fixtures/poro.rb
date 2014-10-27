class Model
  def initialize(hash = {})
    @attributes = hash
  end
end

class User < Model
end

class UserSerializer < CollectionJsonRails::Serializer
  data :name, :email
end
