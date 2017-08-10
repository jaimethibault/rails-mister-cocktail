Rails.application.routes.draw do
  resources :cocktails, only: [:index, :new, :create, :show] do
    resources :doses, only: :create
  end
  resources :doses, only: [:destroy]
  root to: 'cocktails#index'
end
