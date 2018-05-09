require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let(:question) { create(:question, user: @user) }
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
    let(:answer) { create(:answer, question: question, user: @user) }

    it 'assigns the requested answer to @answer' do
      patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }, format: :js
      expect(assigns(:answer)).to eq answer
    end

   it 'assigns the question' do
      patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }, format: :js
      expect(assigns(:question)).to eq question
    end

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


  describe 'DELETE #destroy' do
    context 'delete own answer' do
      it 'delete answer' do
        expect { delete :destroy, params: { id: answer } }.to change(question.answers, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: answer }

        expect(response).to redirect_to question_path(question)
      end
    end

    context 'delete not yours answer' do
      before do
        @user_2 = create(:user)
        @answer_2 = create(:answer, question: question, user: @user_2)
      end

      it 'delete answer' do
        expect { delete :destroy, params: { id: @answer_2 } }.to_not change(Answer, :count)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: @answer_2 }

        expect(response).to redirect_to question_path(@answer_2.question)
      end
    end
  end
end
