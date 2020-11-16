# frozen_string_literal: true

require 'bundler/setup'
require 'edabit_tasks'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:all) do
    EdabitTasks.configure do |c|
      c.default_timeout = 120
      c.browser_name = :chrome
      c.browser_headless = true
      c.email = 'cool_email@gmail.com'
      c.password = '123456789'
    end
  end
end
