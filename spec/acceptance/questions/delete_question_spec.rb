require_relative '../acceptance_helper'

feature 'Delete question', %q{
  As an authenticated user
  I want to be able to delete
  my question
} do

  given(:user) { create_list(:user, 2) }
  let(:question_1) { create(:question, user: user[0]) }
  let(:question_2) { create(:question, user: user[1]) }

  scenario "Authenticated user can't delete not his question" do
    sign_in(user[0])
    visit question_path(question_2)

    expect(page).to_not have_link 'Delete question'
  end

  scenario 'Authenticated user deletes his question' do
    sign_in(user[0])
    visit question_path(question_1)
    click_on 'Delete question'

    expect(page).to have_content 'Your question was successfully deleted'
    expect(page).to_not have_content question_1.title
    expect(page).to_not have_content question_1.body
  end

  scenario 'Unauthorized guest can not delete a question' do
    visit question_path(question_1)

    expect(page).to_not have_link 'Delete question'
  end
end
