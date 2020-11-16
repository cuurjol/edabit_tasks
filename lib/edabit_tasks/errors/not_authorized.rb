# frozen_string_literal: true

module EdabitTasks
  module Errors
    class NotAuthorized < StandardError
      def initialize
        super('User is not authorized.')
      end
    end
  end
end
