require_relative '../acceptance_helper.rb'

feature 'Add files to question', %q{
  "In order to illustrate my question
  as an question's author I'd like
  to be able to attach files"
} do

 given(:user) { create(:user) }

 background do
   sign_in(user)
   visit new_question_path
   fill_in 'Title', with: 'Test question title'
   fill_in 'Body', with: 'Test text body'
   attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
 end

 scenario 'User tries to add multiple files when asks question', js: true do
   click_on 'Add attachment'

   within first('.nested-fields') do
     attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
   end

   click_on 'Create'

   expect(page).to have_link 'spec_helper.rb'
   expect(page).to have_link 'rails_helper.rb'
 end
end
