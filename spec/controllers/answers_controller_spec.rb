require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let(:question) { create(:question, user: @user) }
  let(:user_2) { create(:user) }
  let!(:answer) { create(:answer, question: question, user: @user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js } }.to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js  }
        expect(response).to render_template :create
      end

      it 'associates new answer with user created it' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js  } }.to change(@user.answers, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js  } }.to_not change(question.answers, :count)
      end

      it 're-renders create template' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end

    context 'unathorized user tries to create answer' do
      before { sign_out @user }
      it 'redirects to sign-in view' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    it 'assigns the requested answer to @answer' do
      patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }, format: :js
      expect(assigns(:answer)).to eq answer
    end

    it 'assigns the question' do
      patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }, format: :js
      expect(assigns(:question)).to eq question
    end

    context 'author of the answer tries to update the answer' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, question_id: question, answer: { body: 'new body'} }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'render update template' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'Different user question' do
      let!(:answer_2) { create(:answer, question: question, user: user_2) }

      it 'current user tries to update it' do
        patch :update, params: { id: answer_2, question_id: question, answer: { body: 'new body'} }, format: :js
        expect(flash[:alert]).to eq "You can not update other users' answers"
      end
    end
  end

describe 'DELETE #destroy' do
  context 'delete own answer' do
    it 'delete answer' do
      expect { delete :destroy, params: { id: answer }, format: :js }.to change(question.answers, :count).by(-1)
    end

    it 'render destroy template' do
      delete :destroy, params: { id: answer }, format: :js

      expect(response).to render_template :destroy
    end
  end

  context 'delete not yours answer' do
    before do
      @user_2 = create(:user)
      @answer_2 = create(:answer, question: question, user: @user_2)
    end

    it 'delete answer' do
      expect { delete :destroy, params: { id: @answer_2 }, format: :js }.to_not change(Answer, :count)
    end
  end
end

describe "PUT #choose_best" do
  let(:user_2) { create(:user) }
  let(:question_2) { create(:question, user: user_2) }
  let(:answer_2) { create(:answer, question: question_2, user: user_2) }

  it 'assigns the answer to @answer' do
    put :choose_best, params: { id: answer }, format: :js
    expect(assigns(:answer)).to eq answer
  end

  it 'author chooses the best answer 'do
    put :choose_best, params: { id: answer }, format: :js
    answer.reload

    expect(answer).to be_best
  end

  it 'another user chooses the best answer 'do
    put :choose_best, params: { id: answer_2 }, format: :js
    answer.reload

    expect(flash[:alert]).to eq 'You can not choose best answer for not yours question'
  end
 end

  it_behaves_like 'rated' do
    let(:resource) { create(:question, user: user_2) }
    let(:resource_2) { create(:question, user: @user) }
  end
end
