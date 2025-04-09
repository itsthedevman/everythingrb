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

## [Unreleased]

### Added

- Added `Array#to_or_sentence`, creates a sentence with "or" connector between items
- Added `#with_key` method to `Hash#transform_values` and `Hash#transform_values!`, grants access to both keys and values during transformations
- Added `Array#to_deep_h` and `Hash#to_deep_h`, recursively converts underlying values to hashes
- Added `Enumerable#group_by_key`, group an array of hashes by their keys
- Added `Hash#new_nested_hash`, creates a new Hash that automatically initializes the value to a hash

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

[unreleased]: https://github.com/itsthedevman/everythingrb/compare/v0.2.5...HEAD
[0.2.5]: https://github.com/itsthedevman/everythingrb/compare/v0.2.4...v0.2.5
[0.2.4]: https://github.com/itsthedevman/everythingrb/compare/v0.2.3...v0.2.4
[0.2.3]: https://github.com/itsthedevman/everythingrb/compare/v0.2.2...v0.2.3
[0.2.2]: https://github.com/itsthedevman/everythingrb/compare/v0.2.1...v0.2.2
[0.2.1]: https://github.com/itsthedevman/everythingrb/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/itsthedevman/everythingrb/compare/v0.1.2...v0.2.0
[0.1.2]: https://github.com/itsthedevman/everythingrb/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/itsthedevman/everythingrb/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/itsthedevman/everythingrb/compare/5870052e137cb430d084eab1ec3934f3c50b4501...v0.1.0
