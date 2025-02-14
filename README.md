# EverythingRB

[![Gem Version](https://badge.fury.io/rb/everythingrb.svg)](https://badge.fury.io/rb/everythingrb)
[![Tests](https://github.com/itsthedevman/everythingrb/actions/workflows/main.yml/badge.svg)](https://github.com/everythingrb/sortsmith/actions/workflows/main.yml)
![Ruby Version](https://img.shields.io/badge/ruby-3.3.6-ruby)

Useful extensions to Ruby core classes that you never knew you needed until now.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "everythingrb"
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install everythingrb
```

## Core Extensions

### Array

#### `join_map`
Combines `filter_map` and `join` operations in one convenient method.

```ruby
[1, 2, nil, 3].join_map(" ") { |n| n&.to_s if n&.odd? }
# => "1 3"
```

### Hash

#### `to_struct`
Recursively converts a hash into a Struct, including nested hashes and arrays.

```ruby
hash = { user: { name: "Alice", roles: ["admin", "user"] } }
struct = hash.to_struct
struct.class # => Struct
struct.user.name # => "Alice"
struct.user.roles # => ["admin", "user"]
```

#### `to_ostruct`
Recursively converts a hash into an OpenStruct, including nested hashes and arrays.

```ruby
hash = { config: { api_key: "secret", endpoints: ["v1", "v2"] } }
config = hash.to_ostruct
config.class # => OpenStruct
config.config.api_key # => "secret"
```

#### `to_istruct`
Recursively converts a hash into an immutable Data structure (requires Ruby 3.2+).

```ruby
hash = { person: { name: "Bob", age: 30 } }
data = hash.to_istruct
data.class # => Data
data.person.name # => "Bob"
```

#### `join_map`
Similar to Array#join_map but operates on hash values.

```ruby
{ a: 1, b: 2, c: nil, d: 3 }.join_map(" ") { |k, v| [k, v] if v }
# => "a 1 b 2 d 3"
```

### Module

#### `attr_predicate`
Creates predicate (boolean) methods for instance variables.

```ruby
class User
  attr_writer :admin
  attr_predicate :admin, :active
end

user = User.new
user.active? # => false
user.admin = true
user.admin? # => true
```

### OpenStruct

#### `each`
Alias for `each_pair`.

```ruby
struct = OpenStruct.new(a: 1, b: 2)
struct.each { |key, value| puts "#{key}: #{value}" }
```

#### `map`
Maps over OpenStruct entries.

```ruby
struct = OpenStruct.new(a: 1, b: 2)
struct.map { |key, value| [key, value * 2] }
# => [[:a, 2], [:b, 4]]
```

#### `filter_map`
Combines `map` and `compact` operations in one convenient method.

```ruby
struct = OpenStruct.new(a: 1, b: nil, c: 2)
struct.filter_map { |key, value| value * 2 if value }
# => [2, 4]
```

#### `join_map`
Combines `filter_map` and `join` operations in one convenient method.

```ruby
config = OpenStruct.new(
  alice: {roles: ["admin"]},
  bob: {roles: ["user"]},
  carol: {roles: ["admin"]}
)

config.join_map(", ") { |key, value| key if value[:roles].include?("admin") }
# => "alice, carol"
```

### String

#### `to_h` / `to_a`
Parses JSON string into a Ruby Hash or Array.

```ruby
'{"name": "Alice"}'.to_h
# => {name: "Alice"}

'["Alice"]'.to_h # Or you can use #to_a for different readability
# => ["Alice"]
```

#### `to_istruct`
Parses JSON string into an immutable Data structure (requires Ruby 3.2+).

```ruby
'{"user": {"name": "Alice"}}'.to_istruct
# => #<data user=#<data name="Alice">>
```

#### `to_ostruct`
Parses JSON string into an OpenStruct.

```ruby
'{"user": {"name": "Alice"}}'.to_ostruct
# => #<OpenStruct user=#<OpenStruct name="Alice">>
```

#### `to_struct`
Parses JSON string into a Struct.

```ruby
'{"user": {"name": "Alice"}}'.to_struct
# => #<struct user=#<struct name="Alice">>
```

#### `to_deep_h`
Recursively parses nested JSON strings within a structure.

```ruby
nested_json = {
  users: [
    {name: "Alice", roles: ["admin", "user"]}.to_json,
  ]
}.to_json

nested_json.to_deep_h
# => {users: [{name: "Alice", roles: ["admin", "user"]}]}
```

## Requirements

- Ruby 3.0+
- Ruby 3.2+ for `to_istruct` functionality

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b feature/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-new-feature`)
5. Create new Pull Request

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

## License

The gem is available as open source under the terms of the [MIT License](LICENSE.txt).

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes.

## Credits

- Author: Bryan "itsthedevman"
