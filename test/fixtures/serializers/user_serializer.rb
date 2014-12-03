class UserSerializer < CollectionJsonSerializer::Serializer
  href self: "/users/1", collection: "/users"
  attributes :name, :email
  template :name, email: { prompt: "My email" }
  links :account, dashboard: { href: "/my-dashboard" }
end
