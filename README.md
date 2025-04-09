# EverythingRB

[![Gem Version](https://badge.fury.io/rb/everythingrb.svg)](https://badge.fury.io/rb/everythingrb)
![Ruby Version](https://img.shields.io/badge/ruby-3.3.7-ruby)
[![Tests](https://github.com/itsthedevman/everythingrb/actions/workflows/main.yml/badge.svg)](https://github.com/everythingrb/sortsmith/actions/workflows/main.yml)

Super handy extensions to Ruby core classes that make your code more expressive, readable, and fun to write.

```ruby
# Instead of this:
users = [{ name: "Alice", role: "admin" }, { name: "Bob", role: "user" }]
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
```

**Extensions:** `join_map`, `key_map`, `dig_map`

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

### Array Cleaning

Clean up array boundaries while preserving internal structure:

```ruby
# Remove nil values from the beginning/end
[nil, nil, 1, nil, 2, nil, nil].trim_nils  # => [1, nil, 2]

# With ActiveSupport, remove blank values
[nil, "", 1, "", 2, nil, ""].trim_blanks  # => [1, "", 2]
```

**Extensions:** `trim_nils`, `compact_prefix`, `compact_suffix`, `trim_blanks` (with ActiveSupport)

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
