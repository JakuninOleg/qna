require_relative "../acceptance_helper"

feature 'Question editing', %q{
  As an authorized user
  I want to be able to
  edit my questions
} do

  given(:user) { create(:user) }
  given(:user_2) { create(:user) }
  let(:question) { create(:question, user: user) }

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
      expect(page).to have_link 'Edit'
    end

    scenario 'tries to edit his question', js: true do
      within ".question_#{question.id}" do
        click_on 'Edit'
        fill_in 'Title', with: 'edited question title'
        fill_in 'Body', with: 'edited question body'
        click_on 'Save'

        expect(page).to have_content 'edited question title'
        expect(page).to have_content 'edited question body'
        expect(page).to_not have_button 'Save'
      end
    end
  end

  scenario "tries to edit not his question" do
    sign_in(user_2)
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end
end
