require_relative "../acceptance_helper"

feature 'Answer editing', %q{
  As an authorized user
  I want to be able to
  edit my answers
} do

  given(:user) { create(:user) }
  given(:user_2) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user tries to edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end


  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees edit link' do
      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'tries to edit his own answer', js: true do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end

  scenario 'tries to edit not his question' do
    sign_in(user_2)
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end
end
