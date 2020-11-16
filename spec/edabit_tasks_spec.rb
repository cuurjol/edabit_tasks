# frozen_string_literal: true

RSpec.describe EdabitTasks do
  it 'has a version number' do
    expect(EdabitTasks::VERSION).not_to be nil
  end

  describe '.configure' do
    it 'configures new params' do
      EdabitTasks.configure do |config|
        config.email = 'cooler_man@rambler.ru'
        config.password = '12345'
      end

      expect(EdabitTasks.configuration.email).to eq('cooler_man@rambler.ru')
      expect(EdabitTasks.configuration.password).to eq('12345')
    end
  end

  describe '.reset' do
    it 'changes the params by default' do
      EdabitTasks.reset

      expect(EdabitTasks.configuration.default_timeout).to eq(Watir.default_timeout)
      expect(EdabitTasks.configuration.browser_name).to eq(:chrome)
      expect(EdabitTasks.configuration.browser_headless).to be_truthy
      expect(EdabitTasks.configuration.email).to be_nil
      expect(EdabitTasks.configuration.email).to be_nil
    end
  end
end
