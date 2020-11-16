# frozen_string_literal: true

require 'watir'
require 'edabit_tasks/version'
require 'edabit_tasks/configuration'
require 'edabit_tasks/errors/not_authorized'
require 'edabit_tasks/errors/invalid_language'
require 'edabit_tasks/errors/invalid_level'
require 'edabit_tasks/parser'

module EdabitTasks
  class << self
    attr_accessor :configuration
    attr_writer :logger

    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    def reset
      self.configuration = Configuration.new
    end

    def logger
      @logger ||= Logger.new($stdout).tap { |log| log.progname = name }
    end
  end
end
