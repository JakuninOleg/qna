require_relative "../acceptance_helper"

feature 'Rating for answer', %q{
  I want to be able to vote up
  or down for the answer and to see
  the rating of it
} do

  given(:user) { create(:user) }
  given(:user_2) { create(:user) }
  let(:question) { create(:question, user: user_2) }
  let!(:answer) { create(:answer, user: user_2, question: question) }

  before do
    sign_in(user)
  end

  scenario 'user votes up the answer', js: true do
    visit question_path(question)
    within '.answers' do
      click_on '+1'
      expect(page).to_not have_link '-1'
      expect(page).to_not have_link '+1'
      expect(page).to have_link 'Reset'
      expect(page).to have_content 'rating1'
    end
  end

  scenario 'the user votes down the answer', js: true do
    visit question_path(question)
    within ".answers" do
      click_link '-1'
      expect(page).to_not have_link '-1'
      expect(page).to_not have_link '+1'
      expect(page).to have_link 'Reset'
      expect(page).to have_content 'rating-1'
    end
  end

  scenario 'user resets his vote', js: true do
    visit question_path(question)
    within ".answers" do
    click_link '-1'
    expect(page).to have_content 'rating-1'
    expect(page).to have_link 'Reset'
    click_link 'Reset'
    expect(page).to have_content 'rating0'
    end
  end
end
