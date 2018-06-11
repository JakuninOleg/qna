require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  sign_in_user
  let(:question) { create(:question, user: @user) }
  let(:user_2) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2, user: @user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'associates new question with user created it' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(@user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end

    context 'unathorized user tries to create answer' do
      before { sign_out @user }
      it 'redirects to sign-in view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'delete own question' do
      it 'delete question' do
        question

        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to questions_path
      end
    end

    context 'delete not yours question' do
      before do
        @user_2 = create(:user)
        @question_2 = create(:question, user: @user_2)
      end

      it 'delete question' do
        expect { delete :destroy, params: { id: @question_2 } }.to_not change(Question, :count)
      end
    end
  end

  describe 'PATCH #update' do
    it 'assigns the requested question to @question' do
      patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
      expect(assigns(:question)).to eq question
    end

    it 'changes question attributes' do
      patch :update, params: { id: question, question: { body: 'new body'} }, format: :js
      question.reload
      expect(question.body).to eq 'new body'
    end

    it 'render update template' do
      patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
      expect(response).to render_template :update
    end

    context 'Other user' do
      let(:question_2) { create(:question, user: user_2) }

      it "tries to edit someone else's question" do
        patch :update, params: { id: question_2, question: { body: 'new body'} }, format: :js
        question_2.reload
        expect(question_2.body).to_not eq 'new body'
      end

      it 'redirects to question' do
        patch :update, params: { id: question_2, question: { body: 'new body'} }, format: :js
        question_2.reload
        expect(response).to redirect_to question_2
      end
    end
  end

  it_behaves_like 'rated' do
    let(:resource) { create(:question, user: user_2) }
    let(:resource_2) { create(:question, user: @user) }
  end
end
