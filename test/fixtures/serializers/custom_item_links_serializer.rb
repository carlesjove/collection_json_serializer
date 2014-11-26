class CustomItemLinksSerializer < CollectionJsonSerializer::Serializer
  links dashboard: { href: "/my-dashboard", anything: "at all", whatever: "really" }
end
