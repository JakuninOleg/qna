Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'questions#index'

  concern :rateable do
    member do
      post :vote_up
      post :vote_down
      post :reset_vote
    end
  end

  resources :users, only: [] do
    member do
      get :setup_email
      patch :confirm_email
    end
  end

  resources :attachments, only: :destroy

  concern :commentable do
    resources :comments, only: :create, shallow: true
  end

  resources :questions, concerns: [:rateable, :commentable] do
    resources :subscriptions, only: [:create, :destroy], shallow: true
    resources :answers, concerns: [:rateable, :commentable], shallow: true do
      member do
        put :choose_best
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end

      resources :questions, only: [:index, :show, :create] do
        resources :answers, only: [:index, :show, :create], shallow: true
      end
    end
  end

  resources :search, only: :index

  mount ActionCable.server => '/cable'
end
