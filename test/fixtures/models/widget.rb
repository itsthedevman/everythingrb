# frozen_string_literal: true

# Each line below uses an extension from a different category. If any
# category fails to load before this file is read (eager_load in prod,
# autoload in dev), boot crashes with NoMethodError - exactly the
# regression we're guarding against.
class Widget
  NAMES = [{name: "Alice"}, {name: "Bob"}].key_map(:name).freeze

  attr_predicate :active

  def initialize(active:)
    @active = active
  end

  def tagged
    {a: 1, b: 2}.transform_values(with_key: true) { |v, k| "#{k}=#{v}" }
  end
end
