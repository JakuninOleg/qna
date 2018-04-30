require 'rails_helper'

feature 'Delete question', %q{
  As an authenticated user
  I want to be able to delete
  my question
} do

  given(:user) { create_list(:user, 2) }
  let(:question_1) { create(:question, user: user[0]) }
  let(:question_2) { create(:question, user: user[1]) }

  scenario 'Authenticated user can delete his question' do
    sign_in(user[0])
    visit question_path(question_1)

    expect(page).to have_content('Delete')
  end

  scenario "Authenticated user can't delete not his question" do
    sign_in(user[0])
    visit question_path(question_2)

    expect(page).to_not have_content('Delete')
  end

  scenario 'Authenticated user deletes his question' do
    sign_in(user[0])
    visit question_path(question_1)
    click_on 'Delete'

    expect(page).to have_content('Your question was successfully deleted')
  end
end
