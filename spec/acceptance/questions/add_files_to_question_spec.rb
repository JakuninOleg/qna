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
   click_on 'Add attachment'
 end

 scenario 'User tries to add multiple files when asks question', js: true do
   file_fields = page.all('input[type=file]')
   file_fields[0].set("#{Rails.root}/spec/spec_helper.rb")
   file_fields[1].set("#{Rails.root}/spec/rails_helper.rb")


   click_on 'Create'

   expect(page).to have_link 'spec_helper.rb'
   expect(page).to have_link 'rails_helper.rb'
 end
end
