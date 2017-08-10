Rails.application.routes.draw do
  resources :cocktails, only: [:index, :new, :create, :show]
  root to: 'cocktails#index'
end
