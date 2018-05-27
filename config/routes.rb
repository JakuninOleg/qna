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

  resources :questions, concerns: [:rateable] do
    resources :answers, shallow: true, concerns: [:rateable] do
      member do
        put :choose_best
      end
    end
  end
end
