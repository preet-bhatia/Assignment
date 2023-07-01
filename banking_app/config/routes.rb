Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'pages#home'
  resources :users, only: [:new, :create, :show]
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  resources :accounts, only: [:new, :create, :show]
  resources :loan_account_infos, only: [:new, :create, :index]
  get 'transactions', to: 'transactions#index', as: 'transactions'
  get 'debit', to: 'transactions#withdrawal'
  post 'debit', to: 'transactions#debit'
  get 'credit', to: 'transactions#deposit'
  post 'credit', to: 'transactions#credit'
  get 'transfer', to: 'transactions#transfer'
end
