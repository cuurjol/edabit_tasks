# frozen_string_literal: true

module EdabitTasks
  class Configuration
    attr_accessor :default_timeout, :browser_name, :browser_headless, :email, :password

    def initialize
      @default_timeout = Watir.default_timeout
      @browser_name = :chrome
      @browser_headless = true
      @email = nil
      @password = nil
    end
  end
end
