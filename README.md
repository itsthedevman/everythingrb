# EverythingRB

[![Gem Version](https://badge.fury.io/rb/everythingrb.svg)](https://badge.fury.io/rb/everythingrb)
![Ruby Version](https://img.shields.io/badge/ruby-3.3.7-ruby)
[![Tests](https://github.com/itsthedevman/everythingrb/actions/workflows/main.yml/badge.svg)](https://github.com/everythingrb/sortsmith/actions/workflows/main.yml)

Super handy extensions to Ruby core classes that make your code more expressive, readable, and fun to write.

```ruby
users = [{ name: "Alice", role: "admin" }, { name: "Bob", role: "user" }]

# Instead of this:
admin_names = users.select { |u| u[:role] == "admin" }.map { |u| u[:name] }.join(", ")

# Write this:
users.join_map(", ") { |u| u[:name] if u[:role] == "admin" }
```

## Installation

```ruby
# In your Gemfile
gem "everythingrb"

# Or install manually
gem install everythingrb
```

## Usage

There are two ways to use EverythingRB:

### Load Everything (Default)

The simplest approach - just require and go:

```ruby
require "everythingrb"

# Now you have access to all extensions!
users = [{name: "Alice"}, {name: "Bob"}]
users.key_map(:name).join(", ")  # => "Alice, Bob"

config = {server: {port: 443}}.to_ostruct
config.server.port  # => 443
```

### Cherry-Pick Extensions

If you only need specific extensions, you can load just what you want:

```ruby
require "everythingrb/prelude"  # Required base module
require "everythingrb/array"    # Just Array extensions
require "everythingrb/string"   # Just String extensions

# Now you have access to only the extensions you loaded
["a", "b"].join_map(" | ") { |s| s.upcase }  # => "A | B"
'{"name": "Alice"}'.to_ostruct.name   # => "Alice"

# But Hash extensions aren't loaded yet
{}.to_ostruct  # => NoMethodError
```

Available modules:
- `array`: Array extensions (join_map, key_map, etc.)
- `boolean`: Boolean extensions (in_quotes, with_quotes)
- `data`: Data extensions (to_deep_h, in_quotes)
- `date`: Date and DateTime extensions (in_quotes)
- `enumerable`: Enumerable extensions (join_map, group_by_key)
- `hash`: Hash extensions (to_ostruct, deep_freeze, etc.)
- `kernel`: Kernel extensions (morph alias for then)
- `module`: Extensions like attr_predicate
- `nil`: NilClass extensions (in_quotes)
- `numeric`: Numeric extensions (in_quotes)
- `ostruct`: OpenStruct extensions (map, join_map, etc.)
- `range`: Range extensions (in_quotes)
- `regexp`: Regexp extensions (in_quotes)
- `string`: String extensions (to_h, to_ostruct, etc.)
- `struct`: Struct extensions (to_deep_h, in_quotes)
- `symbol`: Symbol extensions (with_quotes)
- `time`: Time extensions (in_quotes)

## What's Included

EverythingRB extends Ruby's core classes with intuitive methods that simplify common patterns.

### Data Structure Conversions

Convert between data structures with ease:

```ruby
# Convert hashes to more convenient structures
config = { server: { host: "example.com", port: 443 } }.to_ostruct
config.server.host  # => "example.com"

# Parse JSON directly to your preferred structure
'{"user":{"name":"Alice"}}'.to_istruct.user.name  # => "Alice"

# Deep conversion to plain hashes
data = OpenStruct.new(user: Data.define(:name).new(name: "Bob"))
data.to_deep_h  # => {user: {name: "Bob"}}
```

**Extensions:** `to_struct`, `to_ostruct`, `to_istruct`, `to_h`, `to_deep_h`

### Collection Processing

Extract and transform data elegantly:

```ruby
# Extract data from arrays of hashes in one step
users = [{ name: "Alice", roles: ["admin"] }, { name: "Bob", roles: ["user"] }]
users.key_map(:name)  # => ["Alice", "Bob"]
users.dig_map(:roles, 0)  # => ["admin", "user"]

# Filter, map, and join in a single operation
[1, 2, nil, 3, 4].join_map(" | ") { |n| "Item #{n}" if n&.odd? }
# => "Item 1 | Item 3"

# Group elements by key or nested keys
users.group_by_key(:roles, 0)
# => {"admin" => [{name: "Alice", roles: ["admin"]}], "user" => [{name: "Bob", roles: ["user"]}]}

# With ActiveSupport loaded, join arrays in natural language with "or"
["red", "blue", "green"].to_or_sentence  # => "red, blue, or green"
```

**Extensions:** `join_map`, `key_map`, `dig_map`, `to_or_sentence`, `group_by_key`

### Object Protection

Prevent unwanted modifications with a single call:

```ruby
config = {
  api: {
    key: "secret",
    endpoints: ["v1", "v2"]
  }
}.deep_freeze

# Everything is frozen!
config.frozen?  # => true
config[:api][:endpoints][0].frozen?  # => true
```

**Extensions:** `deep_freeze`

### Hash Convenience

Work with hashes more intuitively:

```ruby
# Create deeply nested structures without initialization
stats = Hash.new_nested_hash
stats[:server][:region][:us_east][:errors] << "Connection timeout"
# No need to initialize each level first!

# Transform values with access to keys
users.transform_values(with_key: true) { |v, k| "User #{k}: #{v[:name]}" }

# Find values based on conditions
users.value_where { |_k, v| v[:role] == "admin" }  # Returns first admin
users.values_where { |_k, v| v[:role] == "admin" } # Returns all admins

# Rename keys while preserving order
config = {api_key: "secret", timeout: 30}
config.rename_keys(api_key: :key, timeout: :request_timeout)
# => {key: "secret", request_timeout: 30}

# Filter hash by values
{a: 1, b: nil, c: 2}.select_values { |v| v.is_a?(Integer) && v > 1 }
# => {c: 2}
```

**Extensions:** `new_nested_hash`, `with_key`, `value_where`, `values_where`, `rename_key(s)`, `select_values`, `reject_values`

### Array Cleaning

Clean up array boundaries while preserving internal structure:

```ruby
# Remove nil values from the beginning/end
[nil, nil, 1, nil, 2, nil, nil].trim_nils  # => [1, nil, 2]

# With ActiveSupport, remove blank values
[nil, "", 1, "", 2, nil, ""].trim_blanks  # => [1, "", 2]
```

**Extensions:** `trim_nils`, `compact_prefix`, `compact_suffix`, `trim_blanks` (with ActiveSupport)

### String Formatting

Add quotation marks to any value with a consistent interface - useful for user messages, formatting, and more:

```ruby
# Wrap any value in quotes - works on ALL types!
"hello".in_quotes      # => "\"hello\""
42.in_quotes           # => "\"42\""
nil.in_quotes          # => "\"nil\""
:symbol.in_quotes      # => "\"symbol\""
[1, 2].in_quotes       # => "\"[1, 2]\""
Time.now.in_quotes     # => "\"2025-05-04 12:34:56 +0000\""

# Perfect for user-facing messages with mixed types
puts "You selected #{selection.in_quotes}"
puts "Item #{id.in_quotes} was added to category #{category.in_quotes}"

# Great for formatting responses
response = "Command #{command.in_quotes} completed successfully"

# Ideal for error messages and logging
log.info "Received values: #{values.join_map(", ", &:in_quotes)}"
raise "Expected #{expected.in_quotes} but got #{actual.in_quotes}"

# CLI argument descriptions
puts "Valid modes are: #{MODES.join_map(", ", &:in_quotes)}"
```

**Extensions:** `in_quotes`, `with_quotes` (alias)

### Boolean Methods

Create predicate methods with minimal code:

```ruby
class User
  attr_accessor :admin
  attr_predicate :admin
end

user = User.new
user.admin = true
user.admin?  # => true

# Works with Data objects too!
Person = Data.define(:active)
Person.attr_predicate(:active)

person = Person.new(active: false)
person.active? # => false
```

**Extensions:** `attr_predicate`

### Value Transformation

Chain transformations with a more descriptive syntax:

```ruby
# Instead of this:
result = value.then { |v| transform_it(v) }

# Write this:
result = value.morph { |v| transform_it(v) }
```

**Extensions:** `morph` (alias for `then`/`yield_self`)

## Full Documentation

For complete method listings, examples, and detailed usage, see the [API Documentation](https://itsthedevman.com/docs/everythingrb).

## Requirements

- Ruby 3.2 or higher

## Contributing

Bug reports and pull requests are welcome! This project is intended to be a safe, welcoming space for collaboration.

## License

[MIT License](LICENSE.txt)

## Looking for a Software Engineer?

I'm currently looking for opportunities where I can tackle meaningful problems and help build reliable software while mentoring the next generation of developers. If you're looking for a senior engineer with full-stack Rails expertise and a passion for clean, maintainable code, let's talk!

[bryan@itsthedevman.com](mailto:bryan@itsthedevman.com)
