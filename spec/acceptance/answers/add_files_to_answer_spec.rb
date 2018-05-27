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
  fill_in 'Body', with: 'Test answer'
  click_on 'Add attachment'
 end


 scenario 'User tries to add multiple files when creating an answer to question', js: true do
   file_fields = page.all('input[type=file]')
   file_fields[0].set("#{Rails.root}/spec/spec_helper.rb")
   file_fields[1].set("#{Rails.root}/spec/rails_helper.rb")

   click_on 'Create'

   within '.answers' do
     expect(page).to have_link 'spec_helper.rb'
     expect(page).to have_link 'rails_helper.rb'
   end
 end
end
