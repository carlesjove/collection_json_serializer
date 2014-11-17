# CollectionJsonRails

| :warning: ** This is _not finished_ yet, so you better do not use it ** |
---------------------------------------------------------------------------

A Rails gem to respond with Collection+JSON.

CollectionJsonRails formats JSON responses following the Collection+JSON media type by Mike Amudsen. It also handles input data templates.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'collection_json_rails'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install collection_json_rails

## Usage

As this gem user, you will be mainly writing/generating and mantaining serializers for your models. A serializer goes like:

```ruby
class UserSerializer < CollectionJsonRails::Serializer
  attributes :id, :name, :email
  
  template :name, email: { prompt: "My email" }
  
  links :profile, dashboard: { href: "/my-dashboard" }
end
```

This will generate this Collection+JSON response:

```javascript
{ "collection": {
  "version" : "1.0",
    "href" : "http://example.com/users",
    "items" : [{
      "href": "http://example.com/users/1",
      "data": [
        { "name": "id", "value": "1" },
        { "name": "name", "value": "Carles Jove" },
        { "name": "email", "value": "email@example.com" },
      ],
      "links": [
        { "name": "profile", "href": "http://example.com/profile" },
        { "name": "dashboard", "href": "http://example.com/my-dashboard" }
      ]
    }],
    "template" : {
      "data": [
        { "name": "name", "value": "" },
        { "name": "email", "value": "", "prompt": "My email" }
      ]
    },
  }
}
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/collection_json_rails/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
