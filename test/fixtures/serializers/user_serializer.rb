class UserSerializer < CollectionJsonSerializer::Serializer
  href self: "http://example.com/users/1", collection: "http://example.com/users"
  attributes :name, :email
  template :name, email: { prompt: "My email" }
  links :account, dashboard: { href: "/my-dashboard" }
end
