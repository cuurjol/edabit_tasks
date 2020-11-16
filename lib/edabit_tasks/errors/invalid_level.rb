# frozen_string_literal: true

module EdabitTasks
  module Errors
    class InvalidLevel < StandardError
      def initialize
        super("Invalid level. Use the follow levels: #{EdabitTasks::Parser::LEVELS.join(', ')}.")
      end
    end
  end
end
