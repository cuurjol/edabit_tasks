# frozen_string_literal: true

require_relative 'lib/edabit_tasks/version'

Gem::Specification.new do |spec|
  spec.name          = 'edabit_tasks'
  spec.version       = EdabitTasks::VERSION
  spec.authors       = ['Kirill Ilyin']
  spec.email         = ['cuurjol@gmail.com']

  spec.summary       = 'Parses information of tasks from the site (https://edabit.com/).'
  spec.description   = <<~DESCRIPTION_MESSAGE
    Shows a list of your unsolved tasks or gets a list of user solved tasks 
    (including description and solution if these are your tasks) from the site (https://edabit.com/).
  DESCRIPTION_MESSAGE
  spec.homepage      = 'http://github.com/cuurjol/edabit_tasks'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'reverse_markdown'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'watir'
end
