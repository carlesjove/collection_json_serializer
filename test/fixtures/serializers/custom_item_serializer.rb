class CustomItemSerializer < CollectionJsonSerializer::Serializer
  attributes name: { anything: "at all", whatever: "really" }
end
