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
 end

  scenario 'User adds files when asking a question' do
    fill_in 'Title', with: 'Test question title'
    fill_in 'Body', with: 'Test text body'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

    click_on 'Create'

    expect(page).to have_content 'Your question succesfully created.'
    expect(page).to have_content 'Test question title'
    expect(page).to have_content 'Test text body'
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/2/spec_helper.rb'
  end
end
