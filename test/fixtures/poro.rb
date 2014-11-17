# Base class for pseudo Models
#
# Create a model:
# User = Class.new(Model)
# 
# and then populate it in your tests:
# @user = User.new(name: "Carles Jove", email: "hola@carlus.cat")
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
