# EverythingRB

[![Gem Version](https://badge.fury.io/rb/everythingrb.svg)](https://badge.fury.io/rb/everythingrb)
![Ruby Version](https://img.shields.io/badge/ruby-3.3.7-ruby)
[![Tests](https://github.com/itsthedevman/everythingrb/actions/workflows/main.yml/badge.svg)](https://github.com/everythingrb/sortsmith/actions/workflows/main.yml)

Useful extensions to Ruby core classes that you never knew you needed until now.

## Looking for a Software Engineer?

I'm currently looking for opportunities where I can tackle meaningful problems and help build reliable software while mentoring the next generation of developers. If you're looking for a senior engineer with full-stack Rails expertise and a passion for clean, maintainable code, let's talk!

[bryan@itsthedevman.com](mailto:bryan@itsthedevman.com)

# Table of Contents

- [Compatibility](#compatibility)
- [Installation](#installation)
- [Core Extensions](#core-extensions)
  - [Array](#array)
    - [join_map](#join_map)
  - [Hash](#hash)
    - [to_struct](#to_struct)
    - [to_ostruct](#to_ostruct)
    - [to_istruct](#to_istruct)
    - [join_map](#join_map-1)
  - [Module](#module)
    - [attr_predicate](#attr_predicate)
  - [OpenStruct](#openstruct)
    - [each](#each)
    - [map](#map)
    - [filter_map](#filter_map)
    - [join_map](#join_map-2)
  - [String](#string)
    - [to_h / to_a](#to_h--to_a)
    - [to_istruct](#to_istruct-1)
    - [to_ostruct](#to_ostruct-1)
    - [to_struct](#to_struct-1)
    - [to_deep_h](#to_deep_h)
- [Requirements](#requirements)
- [Contributing](#contributing)
- [License](#license)
- [Changelog](#changelog)
- [Credits](#credits)

Also see: [API Documentation](https://itsthedevman.com/docs/everythingrb)

## Compatibility

Currently tested on:
- MRI Ruby 3.2+
- NixOS (see `flake.nix` for details)

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
Combines `filter_map` and `join` operations in one convenient method. Optionally provides the index to the block.

```ruby
# Without index
[1, 2, nil, 3].join_map(" ") { |n| n&.to_s if n&.odd? }
# => "1 3"

# With index
["a", "b", "c"].join_map(", ", with_index: true) { |char, i| "#{i}:#{char}" }
# => "0:a, 1:b, 2:c"

# Default behavior without block
[1, 2, nil, 3].join_map(", ")
# => "1, 2, 3"
```

#### `key_map`
Extracts a specific key from each hash in an array.

```ruby
users = [
  { name: "Alice", age: 30 },
  { name: "Bob", age: 25 }
]

users.key_map(:name)
# => ["Alice", "Bob"]
```

#### `dig_map`
Extracts nested values from each hash in an array using the `dig` method.

```ruby
data = [
  { user: { profile: { name: "Alice" } } },
  { user: { profile: { name: "Bob" } } }
]

data.dig_map(:user, :profile, :name)
# => ["Alice", "Bob"]
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
Recursively converts a hash into an immutable Data structure.

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
Parses JSON string into an immutable Data structure.

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

#### `with_quotes` / `in_quotes`
Wraps the string in double quotes

```ruby
"Hello World".with_quotes
# => "\"Hello World\""
```

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
