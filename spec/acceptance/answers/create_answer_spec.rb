require 'rails_helper'

feature 'Create answer', %q{
  As an authenticated user
  I want to be able to
  create answer for a question
} do

  given(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  scenario 'Authenticated user creates answer' do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: 'test text'
    click_on 'Create'

    expect(page).to have_content 'test text'
    expect(page).to have_content 'Answer was successfully created'
  end

  scenario 'Authenticated user creates answer with invalid parameters' do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: ''
    click_on 'Create'

    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Guest visits question page' do
    visit question_path(question)

    expect(page).to have_no_selector('textarea#answer_body')
  end
end
