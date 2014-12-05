class InvalidSerializer < CollectionJsonSerializer::Serializer
  href self: "/users/1", collection: "www.users.com"
  links dashboard: { href: "/my-dashboard" }
end
