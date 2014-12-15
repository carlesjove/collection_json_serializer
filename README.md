# CollectionJson::Serializer

[![Build Status](https://travis-ci.org/carlesjove/collection_json_serializer.svg?branch=master)](https://travis-ci.org/carlesjove/collection_json_serializer)

| :warning: ** This is _not finished_ yet, so you better do not use it ** |
---------------------------------------------------------------------------

A Ruby gem to respond with Collection+JSON.

CollectionJson::Serializer formats JSON responses following the Collection+JSON media type by Mike Amudsen. It also handles input data templates.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'collection_json_serializer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install collection_json_serializer

## Usage

As this gem user, you will be mainly writing/generating and mantaining serializers for your models. A serializer goes like:

```ruby
class UserSerializer < CollectionJson::Serializer
  href self: "http://example.com/users/1",
       collection: "http://example.com/users"

  attributes :id, name: { prompt: "Your full name" }, :email

  template :name, email: { prompt: "My email" }

  # Please note that links can only be passed as hashes
  links dashboard: { href: "http://example.com/my-dashboard" }
end
```

Then, you pass your objects to the serializer:

```ruby
# Create your object as you wish
@user = User.new(name: "Carles Jove", email: "hola@carlus.cat")

# You can also pass an array of objects
# user_serializer = UserSerializer.new([@user1, @user2, etc])

# Pass it to the serializer
user_serializer = UserSerializer.new(@user)

# Pass the serializer to the builder, and pack it as a hash
builder = Builder.new(user_serializer)
builder.pack
# => { collection: { version: "1.0" } }

# Get it as JSON
builder.to_json
```

This will generate this Collection+JSON response:

```javascript
{ "collection": 
  {
    "version" : "1.0",
    "href" : "http://example.com/users",
    "items" : [{
      "href": "http://example.com/users/1",
      "data": [
        { "name": "id", "value": "1" },
        { "name": "name", "value": "Carles Jove", "prompt": "Your full name" },
        { "name": "email", "value": "email@example.com" },
      ],
      "links": [
        { "name": "dashboard", "href": "http://example.com/my-dashboard" }
      ]
    }],
    "template" : {
      "data": [
        { "name": "name", "value": "" },
        { "name": "email", "value": "", "prompt": "My email" }
      ]
    }
  }
}
```

#### URL placeholders

URLs can be generated dinamically with placeholder. A placeholder is a URL segment wrapped in curly braces. A placeholder can be any method that can be called on the object that the serializer takes (i.e. `id`, `username`, etc.).

```ruby
class UserSerializer < CollectionJson::Serializer
  href self: "http://example.com/users/{id}"
end
```

All placeholders will be called, so you can use more than one if necessary, but you may use only one placeholer per segment.

```ruby
class UserSerializer < CollectionJson::Serializer
  # This is ok
  href self: "http://example.com/users/{id}/{username}"

  # This is not ok
  href self: "http://example.com/users/{id}-{username}"
end
```

#### Open Attributes Policy

Collection+JSON serializer has an __open attributes policy__, which means that objects' attributes can be extended at will. That is good if you want to use many of the [extensions available](https://github.com/collection-json/extensions), and also if you need to add custom extensions to suit your particular needs. Be aware that, [as the specs say](https://github.com/collection-json/spec#7-extensibility), you must only extend attributes in a way that won't break clients that are not aware of them.

```ruby
class UserSerializer < CollectionJson::Serializer
  attributes :id, name: { css_class: "people" }

  template name: { regex: "/\A[a-zA-Z0-9_]*\z/" }

  links profile: { css_class: "button" }
end
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/collection_json_serializer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
