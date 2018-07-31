require_relative '../acceptance_helper'

feature 'Authenticted user is able to subscribe and unsubscribe to question'  do
  let(:user) { create(:user) }
  let(:user_2) { create(:user) }
  let(:question) { create(:question, user: user_2) }

  context 'Authenticated user' do
    before { sign_in(user) }

    scenario 'subscribes to question', js: true do
      visit question_path(question)

      click_on 'Subscribe'

      expect(page).to_not have_link 'Subscribe'
      expect(page).to have_link 'Unsubscribe'
    end

    scenario 'unsubscribes from question', js: true do
      visit question_path(question)

      click_on 'Subscribe'
      expect(page).to_not have_link 'Subscribe'

      click_on 'Unsubscribe'
      expect(page).to_not have_link 'Unsubscribe'
    end
  end
end
