require_relative '../acceptance_helper'

feature 'Choose the best answer', %q{
  Author of the question
  should be able to Choose
  the best answer for
  his question
}  do

  given(:user) { create(:user) }
  given(:user_2) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    scenario 'sets the best answer', js: true do
      sign_in(user)
      visit question_path(question)

      within ".answer_#{answer.id}" do
        click_link 'Make this answer the best'
        expect(page).to_not have_link 'Make this answer the best'
      end
    end

     scenario 'tries to set the best answer for not his answer' do
      sign_in(user_2)
      visit question_path(question)

      expect(page).to_not have_link 'Make this answer the best'
    end
  end

  scenario 'Unautheticated user tries to set the best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Make this answer the best'
  end
end
