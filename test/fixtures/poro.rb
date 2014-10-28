class Model
  def initialize(hash = {})
    @attributes = hash
  end
end

class User < Model
  def name
    @attributes[:name]
  end

  def email
    @attributes[:email]
  end
end

class UserSerializer < CollectionJsonRails::Serializer
  data :name, :email
  template :name, { email: { prompt: 'My email' } }
end
