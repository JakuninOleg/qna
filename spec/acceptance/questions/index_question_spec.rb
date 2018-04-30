require 'rails_helper'

feature 'Index question', %q{
  I want to be able
  to see all questions and
  visit page of any question
} do

  given(:user) { create(:user) }
  let!(:questions) { create_list(:question, 2, user: user) }

  scenario 'Show all questions on index page' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_content question.user.email
    end
  end

  scenario 'Visit question page' do
    visit questions_path
    click_on(questions[0].title)

    expect(page).to have_content questions[0].body
  end
end
