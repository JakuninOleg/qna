require_relative '../acceptance_helper'

feature 'Delete answer', %q{
  As an authenticated user
  I want to be able to
  delete my answers for a question
} do

  given(:user_1) { create(:user) }
  given(:user_2) { create(:user) }
  let(:question) { create(:question, user: user_1) }

  scenario 'Deleting my own answer', js: true do
    sign_in(user_1)
    answer = create(:answer, question: question, user: user_1)
    visit question_path(question)
    click_on 'Delete answer'

    expect(page).to_not have_content answer.body
  end

  scenario 'Authorized user visiting question page without his answers' do
    sign_in(user_1)
    answer = create(:answer, question: question, user: user_2)
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end

  scenario 'Unauthorized user visiting question page' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end
end

