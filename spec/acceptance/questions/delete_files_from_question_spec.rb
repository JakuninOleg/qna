require_relative '../acceptance_helper.rb'

feature 'Delete files from question', %q{
  "As an authenticated user I would
  like to be able to delete files
  I've attached to the question"
} do

 given(:user) { create(:user) }
 given(:user_2) { create(:user) }
 let(:question) { create(:question, user: user) }
 let!(:attachment) { create(:attachment, attachable: question) }

 scenario 'User deletes file from his question', js: true do
   sign_in(user)
   visit question_path(question)

   within ".question_#{question.id}" do
     click_on 'Delete attachment'
     expect(page).to_not have_link attachment.file
   end
 end

  scenario 'User tries to delete not his file', js: true do
   sign_in(user_2)
   visit question_path(question)

   within ".question_#{question.id}" do
     expect(page).to_not have_link 'Delete attachment'
   end
 end
end
