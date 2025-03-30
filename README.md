# EverythingRB

[![Gem Version](https://badge.fury.io/rb/everythingrb.svg)](https://badge.fury.io/rb/everythingrb)
![Ruby Version](https://img.shields.io/badge/ruby-3.3.7-ruby)
[![Tests](https://github.com/itsthedevman/everythingrb/actions/workflows/main.yml/badge.svg)](https://github.com/everythingrb/sortsmith/actions/workflows/main.yml)

Super handy extensions to Ruby core classes that you never knew you needed until now. Write more expressive, readable, and maintainable code with less boilerplate.

## Looking for a Software Engineer?

I'm currently looking for opportunities where I can tackle meaningful problems and help build reliable software while mentoring the next generation of developers. If you're looking for a senior engineer with full-stack Rails expertise and a passion for clean, maintainable code, let's talk!

[bryan@itsthedevman.com](mailto:bryan@itsthedevman.com)

# Table of Contents

- [Introduction](#introduction)
- [Compatibility](#compatibility)
- [Installation](#installation)
- [Features](#features)
  - [Data Structure Conversions](#data-structure-conversions)
  - [Collection Processing](#collection-processing)
  - [JSON & String Handling](#json--string-handling)
  - [Object Freezing](#object-freezing)
  - [Array Trimming](#array-trimming)
  - [Predicate Methods](#predicate-methods)
- [Core Extensions](#core-extensions)
  - [Array](#array)
  - [Enumerable](#enumerable)
  - [Hash](#hash)
  - [Module](#module)
  - [OpenStruct](#openstruct)
  - [String](#string)
  - [Symbol](#symbol)
- [Advanced Usage](#advanced-usage)
- [Requirements](#requirements)
- [Contributing](#contributing)
- [License](#license)
- [Changelog](#changelog)
- [Credits](#credits)

Also see: [API Documentation](https://itsthedevman.com/docs/everythingrb)

## Introduction

EverythingRB adds powerful, intuitive extensions to Ruby's core classes that help you write cleaner, more expressive code. It focuses on common patterns that typically require multiple method calls or temporary variables, turning them into single fluid operations.

Whether you're transforming data, working with JSON, or building complex object structures, EverythingRB makes your code more readable and maintainable with minimal effort.

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

## Features

### Data Structure Conversions

Easily convert between different Ruby data structures:

```ruby
# Convert any hash to an OpenStruct, Struct, or Data (immutable) object
config = { server: { host: "example.com", port: 443 } }.to_ostruct
config.server.host  # => "example.com"

# Parse JSON directly to your preferred structure
'{"user":{"name":"Alice"}}'.to_istruct.user.name  # => "Alice"
'{"items":[1,2,3]}'.to_struct.items  # => [1, 2, 3]
```

### Collection Processing

Process collections with elegant, chainable methods:

```ruby
# Extract specific data from arrays of hashes in one step
users = [{ name: "Alice", roles: ["admin"] }, { name: "Bob", roles: ["user"] }]
users.key_map(:name)  # => ["Alice", "Bob"]
users.dig_map(:roles, 0)  # => ["admin", "user"]

# Filter, map, and join in a single operation
[1, 2, nil, 3, 4].join_map(" | ") { |n| "Item #{n}" if n&.odd? }
# => "Item 1 | Item 3"
```

### JSON & String Handling

Work with JSON and strings more naturally:

```ruby
# Parse JSON with symbolized keys
'{"name": "Alice"}'.to_h  # => { name: "Alice" }

# Recursively parse nested JSON strings
nested = '{"user":"{\"profile\":\"{\\\"name\\\":\\\"Bob\\\"}\"}"}'
nested.to_deep_h  # => { user: { profile: { name: "Bob" } } }

# Format strings with quotes
"hello".with_quotes  # => "\"hello\""
```

### Object Freezing

Freeze nested structures with a single call:

```ruby
config = {
  api: {
    key: "secret",
    endpoints: ["v1", "v2"]
  }
}.deep_freeze

# Everything is frozen!
config.frozen?  # => true
config[:api].frozen?  # => true
config[:api][:endpoints].frozen?  # => true
config[:api][:endpoints][0].frozen?  # => true
```

### Array Trimming

Clean up array boundaries without losing internal structure:

```ruby
# Remove nil values from the beginning or end
[nil, nil, 1, nil, 2, nil, nil].trim_nils  # => [1, nil, 2]

# With ActiveSupport, remove any blank values (nil, "", etc.)
[nil, "", 1, "", 2, nil, ""].trim_blanks  # => [1, "", 2]

# Only trim from one end if needed
[nil, nil, 1, 2, 3].compact_prefix  # => [1, 2, 3]
[1, 2, 3, nil, nil].compact_suffix  # => [1, 2, 3]
```

### Predicate Methods

Create boolean accessors with minimal code:

```ruby
class User
  attr_accessor :admin, :verified
  attr_predicate :admin, :verified
end

user = User.new
user.admin = true
user.admin?  # => true
user.verified?  # => false

# Works with Struct and Data objects too
Person = Struct.new(:active)
Person.attr_predicate(:active)

person = Person.new(true)
person.active?  # => true
```

**ActiveSupport Integration:** When ActiveSupport is loaded, predicate methods automatically use `present?` instead of just checking truthiness:

```ruby
# With ActiveSupport loaded
class Product
  attr_accessor :tags, :category
  attr_predicate :tags, :category
end

product = Product.new
product.tags = []
product.tags?  # => false (empty array is not "present")

product.tags = ["sale"]
product.tags?  # => true (non-empty array is "present")

product.category = ""
product.category?  # => false (blank string is not "present")
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

#### `compact_prefix` / `compact_suffix` / `trim_nils`
Remove nil values from the beginning, end, or both ends of an array without touching interior nil values.

```ruby
[nil, nil, 1, nil, 2, nil, nil].compact_prefix
# => [1, nil, 2, nil, nil]

[1, nil, 2, nil, nil].compact_suffix
# => [1, nil, 2]

[nil, nil, 1, nil, 2, nil, nil].trim_nils
# => [1, nil, 2]
```

#### `compact_blank_prefix` / `compact_blank_suffix` / `trim_blanks` (with ActiveSupport)
Remove blank values (nil, empty strings, etc.) from the beginning, end, or both ends of an array.

```ruby
[nil, "", 1, "", 2, nil, ""].compact_blank_prefix
# => [1, "", 2, nil, ""]

[nil, "", 1, "", 2, nil, ""].compact_blank_suffix
# => [nil, "", 1, "", 2]

[nil, "", 1, "", 2, nil, ""].trim_blanks
# => [1, "", 2]
```

#### `deep_freeze`
Recursively freezes an array and all of its nested elements.

```ruby
array = ["hello", { name: "Alice" }, [1, 2, 3]]
array.deep_freeze
# => All elements and nested structures are now frozen
```

### Enumerable

#### `join_map`
Combines filtering, mapping and joining operations into one convenient method.

```ruby
# Basic usage with arrays
[1, 2, nil, 3].join_map(", ") { |n| n&.to_s if n&.odd? }
# => "1, 3"

# Works with any Enumerable
(1..10).join_map(" | ") { |n| "num#{n}" if n.even? }
# => "num2 | num4 | num6 | num8 | num10"

# Supports with_index option
%w[a b c].join_map("-", with_index: true) { |char, i| "#{i}:#{char}" }
# => "0:a-1:b-2:c"
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

#### `deep_freeze`
Recursively freezes a hash and all of its nested values.

```ruby
hash = { user: { name: "Alice", roles: ["admin", "user"] } }
hash.deep_freeze
# => Hash and all nested structures are now frozen
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

### Symbol

#### `with_quotes` / `in_quotes`
Wraps the symbol in double quotes

```ruby
:hello_world.with_quotes
# => :"\"hello_world\""
```

## Advanced Usage

See how EverythingRB transforms your code from verbose to elegant:

### Extracting Data from Nested JSON

**Before:**
```ruby
# Standard Ruby approach
json_data = '[{"user":{"name":"Alice","role":"admin"}},{"user":{"name":"Bob","role":"guest"}}]'

parsed_data = JSON.parse(json_data, symbolize_names: true)
names = parsed_data.map { |item| item[:user][:name] }
result = names.join(", ")
# => "Alice, Bob"
```

**After:**
```ruby
# With EverythingRB
json_data = '[{"user":{"name":"Alice","role":"admin"}},{"user":{"name":"Bob","role":"guest"}}]'
result = json_data.to_a.dig_map(:user, :name).join(", ")
# => "Alice, Bob"
```

### Freezing Nested Configurations

**Before:**
```ruby
# Standard Ruby approach
config_json = File.read("config.json")
config = JSON.parse(config_json, symbolize_names: true)

deep_freeze = lambda do |obj|
  case obj
  when Hash
    obj.each_value { |v| deep_freeze.call(v) }
    obj.freeze
  when Array
    obj.each { |v| deep_freeze.call(v) }
    obj.freeze
  else
    obj.freeze
  end
end

frozen_config = deep_freeze.call(config)
```

**After:**
```ruby
# With EverythingRB
config_json = File.read("config.json")
frozen_config = config_json.to_h.deep_freeze
```

### Filtering and Formatting Nested Collections

**Before:**
```ruby
# Standard Ruby approach
users_json = '[{"user":{"name":"Alice","admin":true,"active":true}},{"user":{"name":"Bob","admin":true,"active":false}}]'

users = JSON.parse(users_json, symbolize_names: true)
active_admins = users.map { |u| u[:user] }.select { |u| u[:admin] && u[:active] }
admin_names = active_admins.map { |u| u[:name] }.join(", ")
# => "Alice"
```

**After:**
```ruby
# With EverythingRB
users_json = '[{"user":{"name":"Alice","admin":true,"active":true}},{"user":{"name":"Bob","admin":true,"active":false}}]'
admin_names = users_json.to_a.key_map(:user).join_map(", ") do |user|
  user[:name] if user[:admin] && user[:active]
end
# => "Alice"
```

## Requirements

- Ruby 3.2 or higher

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
