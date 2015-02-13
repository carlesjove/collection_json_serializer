# CollectionJson::Serializer

[![Build Status](https://travis-ci.org/carlesjove/collection_json_serializer.svg?branch=master)](https://travis-ci.org/carlesjove/collection_json_serializer)

| :warning: This is _not finished_ yet, so use it at your own risk. |
--------------------------------------------------------------------

CollectionJson::Serializer serializes Ruby objects to Collection+JSON, the hypermedia type by Mike Amudsen.

Please note that CollectionJson::Serializer _only serializes data_. You still need to set the proper Headers or media-types in your app.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'collection_json_serializer'
```

And then execute:

    $ bundle


## Usage

As this gem user, you will be mainly writing/generating and mantaining serializers for your models. A serializer goes like:

```ruby
class UserSerializer < CollectionJson::Serializer
  href "http://example.com/users",

  template :name
  template email: { prompt: "My email" }
  # This could be written in a single line, too, wrapping the hash:
  # template :name, { email: { ... } }

  # Please note that links can only be passed as hashes
  links dashboard: { href: "http://example.com/my-dashboard" }

  queries search: {
    href: "http://example.com/search",
    name: false # Don't automatically include the name attribute
  }, pagination: {
    rel: "page",
    href: "http://example.com/page",
    prompt: "Select a page number",
    data: [
      { name: "page" }
    ]
  }

  item do
    attributes :id, {name: { prompt: "Your full name" }}, :email
	# You can also add each attribute on a single line
	attribute date_created: { prompt: "Member since"}
    href "http://example.com/users/{id}"
    link avatar: { href: "http://assets.example.com/avatar.jpg", render: "image" }
  end
end
```

Then, you pass your objects to the serializer:

```ruby
@user = User.new(name: "Carles Jove", email: "hola@carlus.cat")

# Pass it to the serializer
user_serializer = UserSerializer.new(@user)

# You can also pass an array of objects
# user_serializer = UserSerializer.new([@user1, @user2, etc])

# Pass the serializer to the builder
collection = CollectionJson::Serializer::Builder.new(user_serializer)
collection.to_json

# You can get the collection as a hash, too
collection.pack
# => { collection: { version: "1.0" } }
```

This will generate this Collection+JSON response:

```javascript
{ "collection": 
  {
    "version" : "1.0",
    "href" : "http://example.com/users",
    "links": [
      { "name": "dashboard", "href": "http://example.com/my-dashboard" }
    ],
    "items" : [{
      "href": "http://example.com/users/1",
      "data": [
        { "name": "id", "value": "1" },
        { "name": "name", "value": "Carles Jove", "prompt": "Your full name" },
        { "name": "email", "value": "email@example.com" },
      ],
      "links": [
        { "name": "avatar", "href": "http://assets.example.com/avatar.jpg",
        "render": "image" }
      ]
    }],
    "template" : {
      "data": [
        { "name": "name", "value": "" },
        { "name": "email", "value": "", "prompt": "My email" }
      ]
    },
    "queries": [{
      "rel": "search",
      "href": "http://example.com/search"
    },{
      "rel": "page",
      "href": "http://example.com/page",
      "name": "pagination",
      "prompt": "Select a page number",
      "data": [
        { "name": "page", "value": "" }
      ]
    }]
  }
}
```

#### URL placeholders

Items' URLs can be generated dinamically with a placeholder. A placeholder is a URL segment wrapped in curly braces. A placeholder can be any method that can be called on the object that the serializer takes (i.e. `id`, `username`, etc.).

```ruby
class UserSerializer < CollectionJson::Serializer
  items do
    href "http://example.com/users/{id}"
  end
end
```

All placeholders will be called, so you can use more than one if necessary, but you may use only one placeholer per segment.

```ruby
class UserSerializer < CollectionJson::Serializer
  items do
    # This is ok
    href "http://example.com/users/{id}/{username}"

    # This is wrong
    href "http://example.com/users/{id}-{username}"
  end
end
```

Please, notice that placeholders can _only_ be used within the `items` block.

#### Open Attributes Policy

Collection+JSON Serializer introduces an __open attributes policy__, which means that objects' attributes can be extended at will. This makes it easy to add custom extensions to suit your particular needs. Be aware that, [as the specs say](https://github.com/collection-json/spec#7-extensibility), you must only extend attributes in a way that won't break clients that are not aware of them.

In order to use the Open Attributes policy, it must be declared as an extension.

```ruby
class UserSerializer < CollectionJson::Serializer
  # Add Open Attrs as an extension
  extensions :open_attrs

  # Now you can use your crazy properties everywhere
  items do
    attributes :id, name: { css_class: "people" }
  end

  template name: { regex: "/\A[a-zA-Z0-9_]*\z/" }

  links profile: { on_click: "reboot_universe" }
end
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/collection_json_serializer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
