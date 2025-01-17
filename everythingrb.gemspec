# frozen_string_literal: true

require_relative "lib/everythingrb/version"

Gem::Specification.new do |spec|
  spec.name = "everythingrb"
  spec.version = Everythingrb::VERSION
  spec.authors = ["Bryan"]
  spec.email = ["bryan@itsthedevman.com"]

  spec.summary = "Practical extensions to Ruby core classes that combine common operations, add convenient data structure conversions, and enhance JSON handling."
  spec.description = "EverythingRB extends Ruby core classes with useful methods for combining operations (join_map), converting data structures (to_struct, to_ostruct, to_istruct), and handling JSON with nested parsing support."
  spec.homepage = "https://github.com/itsthedevman/everythingrb"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata = {
    "source_code_uri" => "https://github.com/itsthedevman/everythingrb",
    "changelog_uri" => "https://github.com/itsthedevman/everythingrb/blob/main/CHANGELOG.md",
    "bug_tracker_uri" => "https://github.com/itsthedevman/everythingrb/issues",
    "documentation_uri" => "https://github.com/itsthedevman/everythingrb#readme",
    "rubygems_mfa_required" => "true"
  }

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github .direnv appveyor Gemfile])
    end
  end
  spec.require_paths = ["lib"]

  spec.add_dependency "ostruct", "~> 0.6.1"
  spec.add_dependency "json", "~> 2.9"
end
