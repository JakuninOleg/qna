require_relative '../acceptance_helper'

feature 'User sign out', %q{
  As an User I want to be able
  to sign out from my account
} do

  given(:user) { create(:user) }

  scenario 'Registered user tries to sign out' do
    sign_in(user)
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
