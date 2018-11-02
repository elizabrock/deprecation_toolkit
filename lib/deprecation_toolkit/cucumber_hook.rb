# frozen_string_literal: true

require 'capybara/dsl'
World(Capybara::DSL)

require 'collector'

After do |scenario|
  begin
    current_deprecations = Collector.new(Collector.deprecations)
    recorded_deprecations = Collector.load(self)
    if current_deprecations != recorded_deprecations
      Configuration.behavior.trigger(self, current_deprecations, recorded_deprecations)
    end
  ensure
    Collector.reset!
  end
end
