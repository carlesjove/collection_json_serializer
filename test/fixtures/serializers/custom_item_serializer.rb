class CustomItemSerializer < CollectionJson::Serializer
  attributes name: { anything: "at all", whatever: "really" }
end
