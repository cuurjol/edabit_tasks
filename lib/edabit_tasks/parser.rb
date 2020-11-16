# frozen_string_literal: true

module EdabitTasks
  class Parser
    URL = 'https://edabit.com/challenges'
    LANGUAGES = %w[C# C++ Java JavaScript PHP Python Ruby Swift].freeze
    LEVELS = ['Very Easy', 'Easy', 'Medium', 'Hard', 'Very Hard', 'Expert', 'Any'].freeze

    def self.find_tasks_by(language:, level:, solved: false)
      @browser = open_browser
      authorized = authorize_user
      EdabitTasks.logger.info("Finished authorizing. Status: #{authorized}")

      catch_exception(language, level, authorized)
      EdabitTasks.logger.info('Started session')
      configure_dropdown_filters(language, level)
      configure_checkbox_filter unless solved
      load_tasks(level)
      result = transform_elements(filter_task_divs(level, true))

      EdabitTasks.logger.info('Finished session')
      @browser.close
      result
    end

    class << self
      private

      def open_browser
        Watir.default_timeout = EdabitTasks.configuration.default_timeout
        browser_name = EdabitTasks.configuration.browser_name
        browser_headless = EdabitTasks.configuration.browser_headless
        EdabitTasks.logger.info("The browser is opened and redirected to the #{URL}")
        Watir::Browser.start(URL, browser_name, headless: browser_headless)
      end

      def authorize_user
        EdabitTasks.logger.info('Started authorizing')
        email = EdabitTasks.configuration.email
        password = EdabitTasks.configuration.password
        return false unless valid_string?(email) && email.match?(URI::MailTo::EMAIL_REGEXP) && valid_string?(password)

        authenticate(email, password)
      end

      def authenticate(email, password)
        @browser.button(text: 'Sign In').wait_until(&:present?).click
        error_message = @browser.div(class: %w[middle aligned eight wide column]).p
        user_dropdown = @browser.div(id: 'UserDropdown')

        @browser.text_field(name: 'email').set(email)
        @browser.text_field(name: 'password').set(password)
        @browser.button(class: %w[ui green big fluid button]).click

        Watir::Wait.until { error_message.present? || user_dropdown.present? }
        user_dropdown.present?
      end

      def valid_string?(string)
        string.is_a?(String) && string.length.positive?
      end

      def catch_exception(language, level, authorized)
        @browser.close unless authorized && LANGUAGES.include?(language) && LEVELS.include?(level)
        raise EdabitTasks::Errors::NotAuthorized unless authorized
        raise EdabitTasks::Errors::InvalidLanguage unless LANGUAGES.include?(language)
        raise EdabitTasks::Errors::InvalidLevel unless LEVELS.include?(level)
      end

      def configure_dropdown_filters(language, level)
        language_dropdown, level_dropdown = @browser.wait_until do |b|
          b.div(id: 'UserDropdown').present?
        end.divs(class: %w[ui fluid selection dropdown])[0..1]

        EdabitTasks.logger.info("Filtered language by value: #{language}")
        select_item(language_dropdown, language)
        sleep(10) # delay before every new requests

        EdabitTasks.logger.info("Filtered level by value: #{level}")
        select_item(level_dropdown, level)
        sleep(10) # delay before every new requests
      end

      def select_item(dropdown, text)
        dropdown.click
        dropdown.div(class: %w[visible menu transition]).divs(class: 'item').find { |div| div.text == text }.click
      end

      def configure_checkbox_filter
        EdabitTasks.logger.info('Filtered completed tasks by value: true')
        @browser.div(class: %w[field float-right]).click
        sleep(10) # delay before every new requests
      end

      def load_tasks(level)
        loop do
          load_more_btn = @browser.button(text: 'LOAD MORE')
          difficulty = @browser.divs(class: %w[item no-highlight]).last.text.split("\n").last

          break unless difficulty == level && load_more_btn.present?

          EdabitTasks.logger.info('Loading next tasks')
          load_more_btn.click
          sleep(10) # delay before every new requests
        end
      end

      def filter_task_divs(level, completed = false)
        EdabitTasks.logger.info("Filtering loading tasks by values: #{level}, #{completed}")
        level = level == LANGUAGES.last ? LANGUAGES.first : level
        task_divs = @browser.divs(class: %w[item no-highlight])
        task_divs.select do |div|
          task_level = div.text.split("\n").last
          completed ? task_level == level && div.span(text: 'complete').present? : task_level == level
        end
      end

      def transform_elements(divs)
        EdabitTasks.logger.info('Getting task divs and transforming their to hash')
        divs.group_by { |div| div.text.split("\n").last }.map do |k, v|
          [k, v.map { |div| { name: div.text.split("\n").first, link: div.link.href } }]
        end.to_h
      end
    end
  end
end
