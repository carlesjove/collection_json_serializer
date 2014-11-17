class Model
  def initialize(hash = {})
    @attributes = hash
  end

  def id
    @attributes[:id] || @attributes['id'] || object_id
  end

  def method_missing(method, *args)
    if method.to_s =~ /^(.*)=$/
      @attributes[$1.to_sym] = args[0]
    elsif @attributes.key?(method)
      @attributes[method]
    else
      super
    end
  end
end

User = Class.new(Model)
Account = Class.new(Model)

class UserSerializer < CollectionJsonRails::Serializer
  attributes :name, :email
  template :name, email: { prompt: "My email" }
  links :account, dashboard: { href: "/my-dashboard" }
end
