Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/keys/new', to: 'keys#new'
  get '/keys/available', to: 'keys#available'
  get '/keys/unblock/:id', to: 'keys#unblock'
  get '/keys/delete/:id', to: 'keys#destroy'
  get '/keys/alive/:id', to: 'keys#alive'
end