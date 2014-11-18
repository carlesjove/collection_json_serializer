class UserSerializer < CollectionJsonSerializer::Serializer
  attributes :name, :email
  template :name, email: { prompt: "My email" }
  links :account, dashboard: { href: "/my-dashboard" }
end
