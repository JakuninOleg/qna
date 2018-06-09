Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'questions#index'

  concern :rateable do
    member do
      post :vote_up
      post :vote_down
      post :reset_vote
    end
  end

  resources :attachments, only: :destroy

  concern :commentable do
    resources :comments, only: :create, shallow: true
  end

  resources :questions, concerns: [:rateable, :commentable] do
    resources :answers, concerns: [:rateable, :commentable], shallow: true do
      member do
        put :choose_best
      end
    end
  end

  mount ActionCable.server => '/cable'
end
