# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!--
## [Unreleased]

### Added

### Changed

### Removed
-->

## [0.9.1] - 12026-01-22

### Changed

- **Deprecated `Hash.new_nested_hash`** - This method is now deprecated and will be removed in v1.0.0. Consider using `Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }` instead.

## [0.9.0] - 12025-08-01

### Added

- **Added `Hash#compact_blank_merge` and `Hash#compact_blank_merge!`** - Merge only present (non-blank) values when ActiveSupport is loaded. Filters out nil, empty strings, empty arrays, false, and other blank values according to ActiveSupport's definition.
- Added `with_index` parameter to `Hash#join_map` for API consistency with `Array#join_map`.

### Changed

- **BREAKING: Renamed `Hash#merge_compact` to `Hash#compact_merge`** - Updated method naming for consistency with other operation-first methods like `compact_prefix`, `trim_nils`, etc. The old method names will be removed in this version.
- **BREAKING: Renamed `Hash#merge_compact!` to `Hash#compact_merge!`** - In-place version follows the same naming convention.

### Removed

- **BREAKING: Removed `Hash#merge_compact` and `Hash#merge_compact!`** - These methods have been renamed to `Hash#compact_merge` and `Hash#compact_merge!` respectively for naming consistency.
- **Removed deprecated Hash value filtering methods** - `Hash#select_values`, `Hash#select_values!`, `Hash#reject_values`, `Hash#reject_values!`, and `Hash#filter_values`, `Hash#filter_values!` have been removed as planned. These methods were deprecated in v0.8.3. Use the standard Ruby alternatives instead:
  - `hash.select_values { |v| condition }` → `hash.select { |k, v| condition }`
  - `hash.reject_values { |v| condition }` → `hash.reject { |k, v| condition }`
  - For blank filtering: `hash.reject_values(&:blank?)` → `hash.compact_blank` (with ActiveSupport)

## [0.8.3] - 12025-05-31

### Added

### Changed

- **Deprecated Hash value filtering methods** - `Hash#select_values`, `Hash#reject_values`, `Hash#select_values!` and `Hash#reject_values!` are now deprecated and will be removed in v0.9.0. These methods largely duplicate existing Ruby/ActiveSupport functionality:

  - `hash.reject_values(&:blank?)` → use `hash.compact_blank` instead
  - `hash.select_values { |v| condition }` → use `hash.select { |k, v| condition }`
  - `hash.reject_values { |v| condition }` → use `hash.reject { |k, v| condition }`

  See [Issue #61](https://github.com/itsthedevman/everythingrb/issues/61) for full details.

### Removed

## [0.8.2] - 12025-05-25

### Added

### Changed

- Fixed `Hash#rename_key_unordered` and `Hash#rename_key_unordered!` to not create new key-value pairs when the original key doesn't exist. Previously, these methods would incorrectly add the `new_key` to the hash even when `old_key` was missing.

### Removed

## [0.8.1] - 12025-05-21

### Added

- Added configuration option for Rails for granular control
  ```ruby
  # In config/initializers/everythingrb.rb
  Rails.application.configure do
    config.everythingrb.extensions = [:array, :string, :hash]
  end
  ```

### Fixed

- Fixed Rails compatibility with a Railtie to resolve a crash caused by load order

## [0.8.0] - 12025-05-11

### Added

- Added conditional hash merging methods:
  - `Hash#merge_if` and `Hash#merge_if!` - Merge key-value pairs based on a condition
  - `Hash#merge_if_values` and `Hash#merge_if_values!` - Merge based on values only
  - `Hash#merge_compact` and `Hash#merge_compact!` - Merge only non-nil values
- Added `String#to_camelcase` - Converts strings to camelCase/PascalCase while handling spaces, hyphens, underscores, and special characters
  - Supports both lowercase first letter (`:lower`) and uppercase first letter (`:upper`), which is default

### Changed

- Updated documentation

### Removed

- Removed potentially dangerous `Array#deep_freeze` and `Hash#deep_freeze` methods to prevent accidental freezing of classes and singleton objects. This creates a safer API for the 1.0.0 milestone.

## [0.7.0] - 12025-05-04

### Added

- Created `Everythingrb::InspectQuotable` and `Everythingrb::StringQuotable` modules for consistent quote functionality
- Extended quotable functionality to many more Ruby core classes:
  - `TrueClass` and `FalseClass` (boolean values)
  - `NilClass`
  - `Numeric`
  - `Range`
  - `Regexp`
  - `Time`, `Date`, and `DateTime`
  - `Data` and `Struct` classes
- Added new Hash methods for filtering based on values only:
  - `Hash#select_values` - Returns a new hash with entries where the block returns true for the value
  - `Hash#select_values!` - Same as `select_values` but modifies the hash in place
  - `Hash#reject_values` - Returns a new hash with entries where the block returns false for the value
  - `Hash#reject_values!` - Same as `reject_values` but modifies the hash in place
  - Added `filter_values` and `filter_values!` as aliases for `select_values` and `select_values!` respectively
- Added `Kernel#morph` as an alias for `then` (and `yield_self`) that better communicates transformation intent:

  ```ruby
  # Instead of this:
  value.then { |v| transform_somehow(v) }

  # You can write this:
  value.morph { |v| transform_somehow(v) }
  ```

### Changed

- Refactored existing quotable implementations to use the new modules
- Standardized method order to prefer `in_quotes` as the primary method with `with_quotes` as an alias

### Removed

## [0.6.1] - 12025-04-26

### Changed

- Fixed invalid use of `private` in `Hash` when ActiveSupport is enabled. This unintentionally caused other public methods to be private

## [0.6.0] - 12025-04-26

### BREAKING CHANGES:

- **Replaced method-based `with_key` approach with direct parameter**:
  The chainable `.with_key` method approach has been replaced with a more straightforward parameter-based approach.

  **Before:**

  ```ruby
  hash.transform_values.with_key { |value, key| "#{key}:#{value}" }
  hash.transform_values!.with_key { |value, key| "#{key}:#{value}" }
  ```

  **After:**

  ```ruby
  hash.transform_values(with_key: true) { |value, key| "#{key}:#{value}" }
  hash.transform_values!(with_key: true) { |value, key| "#{key}:#{value}" }
  ```

### Added:

- Added ActiveSupport integration for deep transforms with key access:
  - `Hash#deep_transform_values(with_key: true)`
  - `Hash#deep_transform_values!(with_key: true)`

## [0.5.0] - 12025-04-17

**BREAKING:**

The parameter order in `Hash#transform_values.with_key` has been changed to yield `|value, key|` instead of `|key, value|` to maintain consistency with Ruby's standard enumeration methods like `each_with_index`.

**Before:**

```ruby
hash.transform_values.with_key { |key, value| "#{key}: #{value}" }
```

**After:**

```ruby
hash.transform_values.with_key { |value, key| "#{key}: #{value}" }
```

This change aligns our method signatures with Ruby's conventions and matches our other methods like `join_map(with_index: true)` which yields `|value, index|`.

### Added

- Added `Hash#transform` and `Hash#transform!` for transforming a hash's keys and values at the same time.

### Changed

- Changed parameter order in `Hash#transform_values.with_key` to yield `|value, key|` instead of `|key, value|` for consistency with Ruby conventions.

### Removed

## [0.4.0] - 12025-04-11

### Added

- Added new `Hash` methods for renaming keys:
  - `#rename_key` - Renames a key in the hash while preserving the original order of elements
  - `#rename_key!` - Same as `#rename_key` but modifies the hash in place
  - `#rename_keys` - Renames multiple keys in the hash while preserving the original order of elements
  - `#rename_keys!` - Same as `#rename_keys` but modifies the hash in place
  - `#rename_key_unordered` - Renames a key without preserving element order (faster operation)
  - `#rename_key_unordered!` - Same as `#rename_key_unordered` but modifies the hash in place
- Added `to_deep_h` to core Ruby classes for consistent deep hash conversion:
  - `Struct#to_deep_h` - Recursively converts Struct objects and all nested values to hashes
  - `OpenStruct#to_deep_h` - Recursively converts OpenStruct objects and all nested values to hashes
  - `Data#to_deep_h` - Recursively converts Data objects and all nested values to hashes
- Added `depth` parameter to `Hash.new_nested_hash` to control nesting behaviors

### Changed

- Reorganized internal file structure for better modularity with full backward compatibility
- Updated documentation headers to each module file explaining available extensions

### Removed

## [0.3.1] - 12025-04-09

### Added

### Changed

- Fixed `Hash#value_where` error when nothing is found

### Removed

## [0.3.0] - 12025-04-09

### Added

- Added `Array#to_or_sentence`, creates a sentence with "or" connector between items
- Added `#with_key` method to `Hash#transform_values` and `Hash#transform_values!`, grants access to both keys and values during transformations
- Added `Array#to_deep_h` and `Hash#to_deep_h`, recursively converts underlying values to hashes
- Added `Enumerable#group_by_key`, group an array of hashes by their keys
- Added `Hash#new_nested_hash`, creates a new Hash that automatically initializes the value to a hash
- Added `Hash#value_where` and `Hash#values_where`, easily find values in a hash based on key-value conditions

### Changed

### Removed

## [0.2.5] - 12025-03-29

### Added

- New array trimming methods that preserve internal structure:
  - `compact_prefix` - Removes nil values from the beginning of an array
  - `compact_suffix` - Removes nil values from the end of an array
  - `trim_nils` - Removes nil values from both ends of an array
  - ActiveSupport integration with blank-aware versions:
    - `compact_blank_prefix` - Removes blank values from the beginning
    - `compact_blank_suffix` - Removes blank values from the end
    - `trim_blanks` - Removes blank values from both ends

## [0.2.4] - 12025-03-20

### Changed

- Improved documentation
- Fixed an issue with `Hash#to_struct` on Ruby 3.2 would raise an exception if called on an empty Hash

## [0.2.3] - 12025-03-09

### Added

- Added `Symbol#with_quotes` and `Symbol#in_quotes`

## [0.2.2] - 12025-03-03

### Added

- Added `Array#key_map` and `Array#dig_map` for mapping over `Hash`
- Added `with_index:` keyword argument to `Array#join_map`. Defaults to `false`
- Added `Enumerable#join_map`
- Added `Array#deep_freeze` and `Hash#deep_freeze` to recursively freeze the underlying values

## [0.2.1] - 12025-03-01

### Added

- Added `with_quotes` / `in_quotes` to `String`

### Removed

- Removed `Data` definition check for `to_istruct`

## [0.2.0] - 12025-02-17

### Added

- Added Ruby version test matrix

### Changed

- Updated `flake.nix` to use 3.4

### Removed

- Removed Ruby 3.1 support

## [0.1.2] - 12025-02-11

### Added

- Added `#presence` support to `Module.attr_predicate` if `ActiveSupport` is loaded.

### Changed

- Separated out tests that require `ActiveSupport` into their own test process. Files that end with `_active_support` will be tested separately with ActiveSupport loaded

## [0.1.1] - 12025-02-07

### Added

- Added `Struct` support to `Module.attr_predicate`

## [0.1.0] - 12025-01-17

### Added

- `Array#join_map` method that combines `filter_map` and `join` operations
- `Hash#join_map` method for consistent interface with Array implementation
- `Hash#to_istruct` for converting hashes to immutable Data structures (Ruby 3.2+)
- `Hash#to_struct` for recursive hash to Struct conversion
- `Hash#to_ostruct` for recursive hash to OpenStruct conversion
- `Module#attr_predicate` for generating boolean accessor methods
- Extended `OpenStruct` with:
  - `blank?` and `present?` methods when ActiveSupport is available
  - `map` and `filter_map` methods
  - `join_map` method consistent with Array/Hash implementations
- Enhanced `String` class with:
  - `to_h` and `to_a` methods for JSON parsing with `nil` fallback on error
  - `to_deep_h` for recursive JSON string parsing
  - `to_istruct`, `to_ostruct`, and `to_struct` conversion methods

### Changed

- Added alias `each` to `each_pair` in OpenStruct for better enumerable compatibility

[unreleased]: https://github.com/itsthedevman/everythingrb/compare/v0.9.1...HEAD
[0.9.1]: https://github.com/itsthedevman/everythingrb/compare/v0.9.0...v0.9.1
[0.9.0]: https://github.com/itsthedevman/everythingrb/compare/v0.8.3...v0.9.0
[0.8.3]: https://github.com/itsthedevman/everythingrb/compare/v0.8.2...v0.8.3
[0.8.3]: https://github.com/itsthedevman/everythingrb/compare/v0.8.2...v0.8.3
[0.8.2]: https://github.com/itsthedevman/everythingrb/compare/v0.8.1...v0.8.2
[0.8.1]: https://github.com/itsthedevman/everythingrb/compare/v0.8.0...v0.8.1
[0.8.0]: https://github.com/itsthedevman/everythingrb/compare/v0.7.0...v0.8.0
[0.7.0]: https://github.com/itsthedevman/everythingrb/compare/v0.6.1...v0.7.0
[0.6.1]: https://github.com/itsthedevman/everythingrb/compare/v0.6.0...v0.6.1
[0.6.0]: https://github.com/itsthedevman/everythingrb/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/itsthedevman/everythingrb/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/itsthedevman/everythingrb/compare/v0.3.1...v0.4.0
[0.3.1]: https://github.com/itsthedevman/everythingrb/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/itsthedevman/everythingrb/compare/v0.2.5...v0.3.0
[0.2.5]: https://github.com/itsthedevman/everythingrb/compare/v0.2.4...v0.2.5
[0.2.4]: https://github.com/itsthedevman/everythingrb/compare/v0.2.3...v0.2.4
[0.2.3]: https://github.com/itsthedevman/everythingrb/compare/v0.2.2...v0.2.3
[0.2.2]: https://github.com/itsthedevman/everythingrb/compare/v0.2.1...v0.2.2
[0.2.1]: https://github.com/itsthedevman/everythingrb/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/itsthedevman/everythingrb/compare/v0.1.2...v0.2.0
[0.1.2]: https://github.com/itsthedevman/everythingrb/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/itsthedevman/everythingrb/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/itsthedevman/everythingrb/compare/5870052e137cb430d084eab1ec3934f3c50b4501...v0.1.0
