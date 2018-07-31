require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:subscription) { create(:subscription, question: question) }

  describe 'POST#create' do
    sign_in_user

    it 'assigns subscription to user' do
      expect { post :create, params: { question_id: question, user: user }, format: :js}.to change(@user.subscriptions, :count).by(1)
    end

    it 'assigns subscription to question' do
      expect { post :create, params: { question_id: question, user: user }, format: :js}.to change(question.subscriptions, :count).by(1)
    end
  end

  describe 'DELETE#destroy' do
    sign_in_user

    it 'deletes subscription' do
      expect { delete :destroy, params: { id: subscription }, format: :js }.to change(Subscription, :count).by(-1)
    end
  end
end
