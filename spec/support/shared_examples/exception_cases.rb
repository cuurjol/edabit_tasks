RSpec.shared_examples 'exception cases' do |language, level, authorized, exception_class|
  it "returns #{exception_class} exception" do
    allow(EdabitTasks::Parser).to receive(:authorize_user).and_return(authorized)

    expect { EdabitTasks::Parser.find_tasks_by(language: language, level: level) }.to raise_error(exception_class)
  end
end
