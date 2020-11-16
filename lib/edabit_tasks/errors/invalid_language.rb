# frozen_string_literal: true

module EdabitTasks
  module Errors
    class InvalidLanguage < StandardError
      def initialize
        super("Invalid language. Use the follow languages: #{EdabitTasks::Parser::LANGUAGES.join(', ')}.")
      end
    end
  end
end
