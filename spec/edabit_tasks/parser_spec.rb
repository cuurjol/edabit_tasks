# frozen_string_literal: true

RSpec.describe EdabitTasks::Parser do
  describe '.find_tasks_by' do
    context 'when user account is authorized and valid params' do
      let(:tasks) { { 'Expert' => [{ name: 'Task1', link: 'link1' }, { name: 'Task2', link: 'link2' }] } }
      let(:language) { 'Ruby' }
      let(:level) { 'Expert' }

      before(:each) do
        allow(EdabitTasks::Parser).to receive(:authorize_user).and_return(true)
        allow(EdabitTasks::Parser).to receive(:find_tasks_by).and_return(tasks)
      end

      it 'returns a hash of tasks' do
        expect(EdabitTasks::Parser.find_tasks_by(language: language, level: level)).to eq(tasks)
      end
    end

    context 'when invalid language param' do
      it_behaves_like('exception cases', '', 'Expert', true, EdabitTasks::Errors::InvalidLanguage)
    end

    context 'when invalid level param' do
      it_behaves_like('exception cases', 'Ruby', '', true, EdabitTasks::Errors::InvalidLevel)
    end

    context 'when user account is not authorized' do
      it_behaves_like('exception cases', 'Ruby', 'Expert', false, EdabitTasks::Errors::NotAuthorized)
    end
  end
end
