require 'rails_helper'

feature 'User sign up', %q{
  In order to be able to ask question
  And give answers I want to create an account
} do

  scenario 'Guest tries to create new account with valid parameters' do

    visit new_user_registration_path
    fill_in 'Email', with: 'user@email.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_button 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Guest tries to create new account with invalid parameters' do

    visit new_user_registration_path
    fill_in 'Email', with: ''
    fill_in 'Password', with: ''
    fill_in 'Password confirmation', with: ''
    click_button 'Sign up'

    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
  end
end
