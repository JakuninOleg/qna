require 'rails_helper'

feature 'Show question', %q{
  I want to be able
  to see question page
  with answers
} do

  given(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  scenario 'Show question page' do
    visit question_path(question)
    answers = create_list(:answer, 3, question: question, user: user)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content question.user.email
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end

  scenario 'User can answer the question' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_field("answer_body")
  end
end
