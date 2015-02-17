class InvalidSerializer < CollectionJson::Serializer
  href self: "/users/1", collection: "www.users.com"
  link dashboard: { href: "/my-dashboard" }
end
