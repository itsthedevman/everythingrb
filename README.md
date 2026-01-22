# EverythingRB

[![Gem Version](https://badge.fury.io/rb/everythingrb.svg)](https://badge.fury.io/rb/everythingrb)
![Ruby Version](https://img.shields.io/badge/ruby-3.3.7-ruby)
[![Tests](https://github.com/itsthedevman/everythingrb/actions/workflows/main.yml/badge.svg)](https://github.com/everythingrb/sortsmith/actions/workflows/main.yml)

Super handy extensions to Ruby core classes that make your code more expressive, readable, and fun to write. Stop writing boilerplate and start writing code that _actually matters_!

## Express Your Intent, Not Your Logic

We've all been there - writing the same tedious patterns over and over:

```ruby
# BEFORE
users = [
  { name: "Alice", role: "admin" },
  { name: "Bob", role: "user" },
  { name: "Charlie", role: "admin" }
]
admin_users = users.select { |u| u[:role] == "admin" }
admin_names = admin_users.map { |u| u[:name] }
result = admin_names.join(", ")
# => "Alice, Charlie"
```

With EverythingRB, you can write code that actually says what you mean:

```ruby
# AFTER
users.join_map(", ") { |u| u[:name] if u[:role] == "admin" }
# => "Alice, Charlie"
```

_Methods used: [`join_map`](https://itsthedevman.com/docs/everythingrb/Array.html#join_map-instance_method)_

Because life's too short to write all that boilerplate!

## Installation

```ruby
# In your Gemfile
gem "everythingrb"

# Or install manually
gem install everythingrb
```

## Usage

There are two ways to use EverythingRB:

### Standard Ruby Projects

#### Load Everything (Default)

The simplest approach - just require and go:

```ruby
require "everythingrb"

# Now you have access to all extensions!
users = [{name: "Alice"}, {name: "Bob"}]
users.key_map(:name).join(", ")  # => "Alice, Bob"

config = {server: {port: 443}}.to_ostruct
config.server.port  # => 443
```

#### Cherry-Pick Extensions

If you only need specific extensions (or you're a minimalist at heart):

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
- `hash`: Hash extensions (to_ostruct, transform_values(with_key: true), etc.)
- `kernel`: Kernel extensions (morph alias for then)
- `module`: Extensions like attr_predicate
- `nil`: NilClass extensions (in_quotes)
- `numeric`: Numeric extensions (in_quotes)
- `ostruct`: OpenStruct extensions (map, join_map, etc.)
- `range`: Range extensions (in_quotes)
- `regexp`: Regexp extensions (in_quotes)
- `string`: String extensions (to_h, to_ostruct, to_camelcase, etc.)
- `struct`: Struct extensions (to_deep_h, in_quotes)
- `symbol`: Symbol extensions (with_quotes)
- `time`: Time extensions (in_quotes)

### Rails Applications

EverythingRB works out of the box with Rails! Just add it to your Gemfile and you're all set.

If you only want specific extensions, configure them in an initializer:

```ruby
# In config/initializers/everythingrb.rb
Rails.application.configure do
  config.everythingrb.extensions = [:array, :string, :hash]
end
```

By default (when `config.everythingrb.extensions` is not set), all extensions are loaded. Setting this to an empty array would effectively disable the gem.

## What's Included

### Data Structure Conversions

Stop writing complicated parsers and nested transformations:

```ruby
# BEFORE
json_string = '{"user":{"name":"Alice","roles":["admin"]}}'
parsed = JSON.parse(json_string)
result = OpenStruct.new(
  user: OpenStruct.new(
    name: parsed["user"]["name"],
    roles: parsed["user"]["roles"]
  )
)
result.user.name  # => "Alice"
```

With EverythingRB, it's one elegant step:

```ruby
# AFTER
'{"user":{"name":"Alice","roles":["admin"]}}'.to_ostruct.user.name  # => "Alice"
```

_Methods used: [`to_ostruct`](https://itsthedevman.com/docs/everythingrb/String.html#to_ostruct-instance_method)_

Convert between data structures with ease:

```ruby
# BEFORE
config_hash = { server: { host: "example.com", port: 443 } }
ServerConfig = Struct.new(:host, :port)
Config = Struct.new(:server)
config = Config.new(ServerConfig.new(config_hash[:server][:host], config_hash[:server][:port]))
```

```ruby
# AFTER
config = { server: { host: "example.com", port: 443 } }.to_struct
config.server.host  # => "example.com"
```

_Methods used: [`to_struct`](https://itsthedevman.com/docs/everythingrb/Hash.html#to_struct-instance_method)_

Deep conversion to plain hashes is just as easy:

```ruby
# BEFORE
data = OpenStruct.new(user: Data.define(:name).new(name: "Bob"))
result = {
  user: {
    name: data.user.name
  }
}
```

```ruby
# AFTER
data = OpenStruct.new(user: Data.define(:name).new(name: "Bob"))
data.to_deep_h  # => {user: {name: "Bob"}}
```

_Methods used: [`to_deep_h`](https://itsthedevman.com/docs/everythingrb/OpenStruct.html#to_deep_h-instance_method)_

**Extensions:** [`to_struct`](https://itsthedevman.com/docs/everythingrb/Hash.html#to_struct-instance_method), [`to_ostruct`](https://itsthedevman.com/docs/everythingrb/Hash.html#to_ostruct-instance_method), [`to_istruct`](https://itsthedevman.com/docs/everythingrb/Hash.html#to_istruct-instance_method), [`to_h`](https://itsthedevman.com/docs/everythingrb/String.html#to_h-instance_method), [`to_deep_h`](https://itsthedevman.com/docs/everythingrb/Hash.html#to_deep_h-instance_method)

### Collection Processing

Extract and transform data with elegant, expressive code:

```ruby
# BEFORE
users = [{ name: "Alice", role: "admin" }, { name: "Bob", role: "user" }]
names = users.map { |user| user[:name] }
# => ["Alice", "Bob"]
```

```ruby
# AFTER
users.key_map(:name)  # => ["Alice", "Bob"]
```

_Methods used: [`key_map`](https://itsthedevman.com/docs/everythingrb/Array.html#key_map-instance_method)_

Simplify nested data extraction:

```ruby
# BEFORE
users = [
  {user: {profile: {name: "Alice"}}},
  {user: {profile: {name: "Bob"}}}
]
names = users.map { |u| u.dig(:user, :profile, :name) }
# => ["Alice", "Bob"]
```

```ruby
# AFTER
users.dig_map(:user, :profile, :name)  # => ["Alice", "Bob"]
```

_Methods used: [`dig_map`](https://itsthedevman.com/docs/everythingrb/Array.html#dig_map-instance_method)_

Combine filter, map, and join operations in one step:

```ruby
# BEFORE
data = [1, 2, nil, 3, 4]
result = data.compact.filter_map { |n| "Item #{n}" if n.odd? }.join(" | ")
# => "Item 1 | Item 3"
```

```ruby
# AFTER
[1, 2, nil, 3, 4].join_map(" | ") { |n| "Item #{n}" if n&.odd? }
# => "Item 1 | Item 3"
```

_Methods used: [`join_map`](https://itsthedevman.com/docs/everythingrb/Array.html#join_map-instance_method)_

Need position-aware processing? Both Array and Hash support `with_index`:

```ruby
# BEFORE
users = {alice: "Alice", bob: "Bob", charlie: "Charlie"}
users.filter_map.with_index { |(k, v), i| "#{i + 1}. #{v}" }.join(", ")
# => "1. Alice, 2. Bob, 3. Charlie"
```

```ruby
# AFTER
users.join_map(", ", with_index: true) { |(k, v), i| "#{i + 1}. #{v}" }
# => "1. Alice, 2. Bob, 3. Charlie"
```

_Methods used: [`join_map`](https://itsthedevman.com/docs/everythingrb/Hash.html#join_map-instance_method)_

Group elements with natural syntax:

```ruby
# BEFORE
users = [
  {name: "Alice", department: {name: "Engineering"}},
  {name: "Bob", department: {name: "Sales"}},
  {name: "Charlie", department: {name: "Engineering"}}
]
users.group_by { |user| user[:department][:name] }
# => {"Engineering"=>[{name: "Alice",...}, {name: "Charlie",...}], "Sales"=>[{name: "Bob",...}]}
```

```ruby
# AFTER
users.group_by_key(:department, :name)
# => {"Engineering"=>[{name: "Alice",...}, {name: "Charlie",...}], "Sales"=>[{name: "Bob",...}]}
```

_Methods used: [`group_by_key`](https://itsthedevman.com/docs/everythingrb/Enumerable.html#group_by_key-instance_method)_

Create natural language lists:

```ruby
# BEFORE
options = ["red", "blue", "green"]
# The default to_sentence uses "and"
options.to_sentence  # => "red, blue, and green"

# Need "or" instead? Time for string surgery
if options.size <= 2
  options.to_sentence(words_connector: " or ")
else
  # Replace the last "and" with "or" - careful with i18n!
  options.to_sentence.sub(/,?\s+and\s+/, ", or ")
end
# => "red, blue, or green"
```

```ruby
# AFTER
["red", "blue", "green"].to_or_sentence  # => "red, blue, or green"
```

_Methods used: [`to_or_sentence`](https://itsthedevman.com/docs/everythingrb/Array.html#to_or_sentence-instance_method)_

**Extensions:** [`join_map`](https://itsthedevman.com/docs/everythingrb/Array.html#join_map-instance_method), [`key_map`](https://itsthedevman.com/docs/everythingrb/Array.html#key_map-instance_method), [`dig_map`](https://itsthedevman.com/docs/everythingrb/Array.html#dig_map-instance_method), [`to_or_sentence`](https://itsthedevman.com/docs/everythingrb/Array.html#to_or_sentence-instance_method), [`group_by_key`](https://itsthedevman.com/docs/everythingrb/Enumerable.html#group_by_key-instance_method)

### Hash Convenience

Work with hashes more intuitively.

Transform values with access to their keys:

```ruby
# BEFORE
users = {alice: {name: "Alice"}, bob: {name: "Bob"}}
result = {}
users.each do |key, value|
  result[key] = "User #{key}: #{value[:name]}"
end
# => {alice: "User alice: Alice", bob: "User bob: Bob"}
```

```ruby
# AFTER
users.transform_values(with_key: true) { |v, k| "User #{k}: #{v[:name]}" }
# => {alice: "User alice: Alice", bob: "User bob: Bob"}
```

_Methods used: [`transform_values(with_key: true)`](https://itsthedevman.com/docs/everythingrb/Hash.html#transform_values-instance_method)_

Find values based on conditions:

```ruby
# BEFORE
users = {
  alice: {name: "Alice", role: "admin"},
  bob: {name: "Bob", role: "user"},
  charlie: {name: "Charlie", role: "admin"}
}
admins = users.select { |_k, v| v[:role] == "admin" }.values
# => [{name: "Alice", role: "admin"}, {name: "Charlie", role: "admin"}]
```

```ruby
# AFTER
users.values_where { |_k, v| v[:role] == "admin" }
# => [{name: "Alice", role: "admin"}, {name: "Charlie", role: "admin"}]
```

_Methods used: [`values_where`](https://itsthedevman.com/docs/everythingrb/Hash.html#values_where-instance_method)_

Just want the first match? Even simpler:

```ruby
# BEFORE
users.find { |_k, v| v[:role] == "admin" }&.last
# => {name: "Alice", role: "admin"}
```

```ruby
# AFTER
users.value_where { |_k, v| v[:role] == "admin" }
# => {name: "Alice", role: "admin"}
```

_Methods used: [`value_where`](https://itsthedevman.com/docs/everythingrb/Hash.html#value_where-instance_method)_

Rename keys while preserving order:

```ruby
# BEFORE
config = {api_key: "secret", timeout: 30}
new_config = config.each_with_object({}) do |(key, value), hash|
  new_key =
    case key
    when :api_key
      :key
    when :timeout
      :request_timeout
    else
      key
    end

  hash[new_key] = value
end
# => {key: "secret", request_timeout: 30}
```

```ruby
# AFTER
config = {api_key: "secret", timeout: 30}
config.rename_keys(api_key: :key, timeout: :request_timeout)
# => {key: "secret", request_timeout: 30}
```

_Methods used: [`rename_keys`](https://itsthedevman.com/docs/everythingrb/Hash.html#rename_keys-instance_method)_

Conditionally merge hashes with clear intent:

```ruby
# BEFORE
user_params = {name: "Alice", role: "user"}
filtered = {verified: true, admin: true}.select { |k, v| v == true && k == :verified }
user_params.merge(filtered)
# => {name: "Alice", role: "user", verified: true}
```

```ruby
# AFTER
user_params = {name: "Alice", role: "user"}
user_params.merge_if(verified: true, admin: true) { |k, v| v == true && k == :verified }
# => {name: "Alice", role: "user", verified: true}
```

_Methods used: [`merge_if`](https://itsthedevman.com/docs/everythingrb/Hash.html#merge_if-instance_method)_

The nil-filtering pattern we've all written dozens of times:

```ruby
# BEFORE
params = {sort: "created_at"}
filtered = {filter: "active", search: nil}.compact
params.merge(filtered)
# => {sort: "created_at", filter: "active"}
```

```ruby
# AFTER
params = {sort: "created_at"}
params.compact_merge(filter: "active", search: nil)
# => {sort: "created_at", filter: "active"}
```

_Methods used: [`compact_merge`](https://itsthedevman.com/docs/everythingrb/Hash.html#compact_merge-instance_method)_

Filter out blank values too when ActiveSupport is loaded:

```ruby
# BEFORE
config = {api_key: "secret", timeout: 30}
user_settings = {timeout: "", retries: nil, debug: true, tags: []}
clean_settings = user_settings.reject { |k, v| v.blank? }
config.merge(clean_settings)
# => {api_key: "secret", timeout: 30, debug: true}
```

```ruby
# AFTER
config = {api_key: "secret", timeout: 30}
config.compact_blank_merge(timeout: "", retries: nil, debug: true, tags: [])
# => {api_key: "secret", timeout: 30, debug: true}
```

_Methods used: [`compact_blank_merge`](https://itsthedevman.com/docs/everythingrb/Hash.html#compact_blank_merge-instance_method)_

**Extensions:** [`transform_values(with_key: true)`](https://itsthedevman.com/docs/everythingrb/Hash.html#transform_values-instance_method), [`value_where`](https://itsthedevman.com/docs/everythingrb/Hash.html#value_where-instance_method), [`values_where`](https://itsthedevman.com/docs/everythingrb/Hash.html#values_where-instance_method), [`rename_key`](https://itsthedevman.com/docs/everythingrb/Hash.html#rename_key-instance_method), [`rename_keys`](https://itsthedevman.com/docs/everythingrb/Hash.html#rename_keys-instance_method), [`merge_if`](https://itsthedevman.com/docs/everythingrb/Hash.html#merge_if-instance_method), [`merge_if!`](https://itsthedevman.com/docs/everythingrb/Hash.html#merge_if%21-instance_method), [`merge_if_values`](https://itsthedevman.com/docs/everythingrb/Hash.html#merge_if_values-instance_method), [`merge_if_values!`](https://itsthedevman.com/docs/everythingrb/Hash.html#merge_if_values%21-instance_method), [`compact_merge`](https://itsthedevman.com/docs/everythingrb/Hash.html#compact_merge-instance_method), [`compact_merge!`](https://itsthedevman.com/docs/everythingrb/Hash.html#compact_merge%21-instance_method), [`compact_blank_merge`](https://itsthedevman.com/docs/everythingrb/Hash.html#compact_blank_merge-instance_method), [`compact_blank_merge!`](https://itsthedevman.com/docs/everythingrb/Hash.html#compact_blank_merge%21-instance_method)

### Array Cleaning

Clean up array boundaries while preserving internal structure:

```ruby
# BEFORE
data = [nil, nil, 1, nil, 2, nil, nil]
data.drop_while(&:nil?).reverse.drop_while(&:nil?).reverse
# => [1, nil, 2]
```

```ruby
# AFTER
[nil, nil, 1, nil, 2, nil, nil].trim_nils  # => [1, nil, 2]
```

_Methods used: [`trim_nils`](https://itsthedevman.com/docs/everythingrb/Array.html#trim_nils-instance_method)_

With ActiveSupport, remove blank values too:

```ruby
# BEFORE
data = [nil, "", 1, "", 2, nil, ""]
data.drop_while(&:blank?).reverse.drop_while(&:blank?).reverse
# => [1, "", 2]
```

```ruby
# AFTER
[nil, "", 1, "", 2, nil, ""].trim_blanks  # => [1, "", 2]
```

_Methods used: [`trim_blanks`](https://itsthedevman.com/docs/everythingrb/Array.html#trim_blanks-instance_method)_

**Extensions:** [`trim_nils`](https://itsthedevman.com/docs/everythingrb/Array.html#trim_nils-instance_method), [`compact_prefix`](https://itsthedevman.com/docs/everythingrb/Array.html#compact_prefix-instance_method), [`compact_suffix`](https://itsthedevman.com/docs/everythingrb/Array.html#compact_suffix-instance_method), [`trim_blanks`](https://itsthedevman.com/docs/everythingrb/Array.html#trim_blanks-instance_method) (with ActiveSupport)

### String Formatting

Format strings and other values consistently:

```ruby
# BEFORE
def format_value(value)
  case value
  when String
    "\"#{value}\""
  when Symbol
    "\"#{value}\""
  when Numeric
    "\"#{value}\""
  when NilClass
    "\"nil\""
  when Array, Hash
    "\"#{value.inspect}\""
  else
    "\"#{value}\""
  end
end

selection = nil
message = "You selected #{format_value(selection)}"
```

```ruby
# AFTER
"hello".in_quotes      # => "\"hello\""
42.in_quotes           # => "\"42\""
nil.in_quotes          # => "\"nil\""
:symbol.in_quotes      # => "\"symbol\""
[1, 2].in_quotes       # => "\"[1, 2]\""
Time.now.in_quotes     # => "\"2025-05-04 12:34:56 +0000\""

message = "You selected #{selection.in_quotes}"
```

_Methods used: [`in_quotes`](https://itsthedevman.com/docs/everythingrb/Everythingrb/InspectQuotable.html#in_quotes-instance_method), [`with_quotes`](https://itsthedevman.com/docs/everythingrb/Everythingrb/InspectQuotable.html#with_quotes-instance_method)_

Convert strings to camelCase with ease:

```ruby
# BEFORE
name = "user_profile_settings"
pascal_case = name.gsub(/[-_\s]+([a-z])/i) { $1.upcase }.gsub(/[-_\s]/, '')
pascal_case[0].upcase!
pascal_case
# => "UserProfileSettings"

camel_case = name.gsub(/[-_\s]+([a-z])/i) { $1.upcase }.gsub(/[-_\s]/, '')
camel_case[0].downcase!
camel_case
# => "userProfileSettings"
```

```ruby
# AFTER
"user_profile_settings".to_camelcase       # => "UserProfileSettings"
"user_profile_settings".to_camelcase(:lower)  # => "userProfileSettings"

# Handles all kinds of input consistently
"please-WAIT while_loading...".to_camelcase  # => "PleaseWaitWhileLoading"
```

_Methods used: [`to_camelcase`](https://itsthedevman.com/docs/everythingrb/String.html#to_camelcase-instance_method)_

**Extensions:** [`in_quotes`](https://itsthedevman.com/docs/everythingrb/Everythingrb/InspectQuotable.html#in_quotes-instance_method), [`with_quotes`](https://itsthedevman.com/docs/everythingrb/Everythingrb/InspectQuotable.html#with_quotes-instance_method) (alias), [`to_camelcase`](https://itsthedevman.com/docs/everythingrb/String.html#to_camelcase-instance_method)

### Boolean Methods

Create predicate methods with minimal code:

```ruby
# BEFORE
class User
  attr_accessor :admin

  def admin?
    !!@admin
  end
end

user = User.new
user.admin = true
user.admin?  # => true
```

```ruby
# AFTER
class User
  attr_accessor :admin
  attr_predicate :admin
end

user = User.new
user.admin = true
user.admin?  # => true
```

_Methods used: [`attr_predicate`](https://itsthedevman.com/docs/everythingrb/Module.html#attr_predicate-instance_method)_

Works with Data objects too:

```ruby
# BEFORE
Person = Data.define(:active) do
  def active?
    !!active
  end
end

# AFTER
Person = Data.define(:active)
Person.attr_predicate(:active)

person = Person.new(active: false)
person.active? # => false
```

_Methods used: [`attr_predicate`](https://itsthedevman.com/docs/everythingrb/Module.html#attr_predicate-instance_method)_

**Extensions:** [`attr_predicate`](https://itsthedevman.com/docs/everythingrb/Module.html#attr_predicate-instance_method)

### Value Transformation

Chain transformations with a more descriptive syntax:

```ruby
# BEFORE
result = value.then { |v| transform_it(v) }
```

```ruby
# AFTER
result = value.morph { |v| transform_it(v) }
```

_Methods used: [`morph`](https://itsthedevman.com/docs/everythingrb/Kernel.html#morph-instance_method)_

**Extensions:** [`morph`](https://itsthedevman.com/docs/everythingrb/Kernel.html#morph-instance_method) (alias for `then`/`yield_self`)

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
