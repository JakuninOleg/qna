require_relative '../acceptance_helper.rb'

feature 'Add files to answer', %q{
  "In order to illustrate my answer
  as an answer's author I'd like
  to be able to attach files"
} do

 given(:user) { create(:user) }
 let(:question) { create(:question, user: user) }

 background do
  sign_in(user)
  visit question_path(question)
 end

 scenario 'User adds files when asking a question', js: true do
   within '.new-answer-form' do
     fill_in 'Body', with: 'Test answer'
     attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
     click_on 'Create'
   end

   within '.answers' do
     expect(page).to have_content 'Test answer'
     expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/spec_helper.rb'
   end
 end
end
