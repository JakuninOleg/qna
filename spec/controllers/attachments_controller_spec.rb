require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  sign_in_user
  let(:user_2) { create(:user) }
  let!(:question) { create(:question, user: @user) }
  let!(:question_2) { create(:question, user: user_2) }
  let!(:attachment) { create(:attachment, attachable: question) }
  let!(:attachment_2) { create(:attachment, attachable: question_2) }

  describe 'DELETE #destroy' do
    context 'User tries to delete his own attachment' do
      it 'deletes the attachment' do
        expect { delete :destroy, params: { id: attachment }, format: :js }.to change(question.attachments, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, params: { id: attachment }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'User tries to delete not his attachment' do
      it 'delete attachment' do
        expect { delete :destroy, params: { id: attachment_2 }, format: :js }.to_not change(Attachment, :count)
      end

      it 'redirect to attachment view' do
        delete :destroy, params: { id: attachment_2 }, format: :js
        expect(response).to redirect_to attachment_path(attachment_2)
      end
    end
  end
end
