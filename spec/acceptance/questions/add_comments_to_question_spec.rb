require_relative "../acceptance_helper"

feature 'Leave comments within questions', %q{
  As an uthenticated user I
  would like to be able to
  leave comments for questions
} do

  given!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  scenario 'leave a comment', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'Comment', with: 'comment text'
    click_on 'Create Comment'

    expect(page).to have_content 'comment text'
  end

  scenario 'leave a comment with invalid attributes', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'Comment', with: ''
    click_on 'Create Comment'

    expect(page).to have_content "Body can't be blank"
  end

  context 'mulitple sessions' do
    scenario 'comment visible for another user', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Comment', with: 'comment text'
        click_on 'Create Comment'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'comment text'
      end
    end
  end
end
