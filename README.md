# CollectionJson::Serializer

[![Build Status](https://travis-ci.org/carlesjove/collection_json_serializer.svg?branch=master)](https://travis-ci.org/carlesjove/collection_json_serializer)

| :warning: This is _not finished_ yet, so use it at your own risk. |
--------------------------------------------------------------------
| :warning: Until version 1.X breaking changes might happen |
-------------------------------------------------------------

CollectionJson::Serializer serializes Ruby objects to Collection+JSON, the hypermedia type by Mike Amudsen.

Please note that CollectionJson::Serializer _only serializes data_. You still need to set the proper Headers or media-types in your app.

If you're working on a Rails app, you might want to use [Collection+JSON
Rails](https://github.com/carlesjove/collection_json_rails) instead.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'collection_json_serializer', '~> 0.4.2'
```

Or if you want to use the mornings build:

```ruby
gem 'collection_json_serializer',
  git: 'https://github.com/carlesjove/collection_json_serializer',
  branch: 'dev'
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

  link dashboard: { href: "http://example.com/my-dashboard" }

  query search: {
    href: "http://example.com/search",
    name: false # Don't automatically include the name attribute
  }
  query pagination: {
    rel: "page",
    href: "http://example.com/page",
    prompt: "Select a page number",
    data: [
      { name: "page" }
    ]
  }

  items do
    attribute :id
    attribute name: { prompt: "Your full name" }}
    attribute :email

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
# user_serializer = UserSerializer.new([@user1, @user2])

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
    # This will work
    href "http://example.com/users/{id}/{username}"

    # This won't work
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
    attribute name: { css_class: "people" }
  end

  template name: { regex: "/\A[a-zA-Z0-9_]*\z/" }

  link profile: { on_click: "reboot_universe" }
end
```

## Contributing

Please, all Pull Request should point to the `dev` branch. `master` is for the
latest release only.
