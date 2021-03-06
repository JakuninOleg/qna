require_relative "../acceptance_helper"

feature 'Leave comments within answers', %q{
  As an uthenticated user I
  would like to be able to
  leave comments for answers
} do

  given(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, user: user, question: question) }

  scenario 'leave comment', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      fill_in 'Comment', with: 'comment text'
      click_on 'Create Comment'
      expect(page).to have_content 'comment text'
    end
  end

  scenario 'leave a comment with invalid attributes', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      fill_in 'Comment', with: ''
      click_on 'Create Comment'
      expect(page).to have_content "Body can't be blank"
    end
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
        within '.answers' do
          fill_in 'Comment', with: 'comment text'
          click_on 'Create Comment'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'comment text'
      end
    end
  end
end
