Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/matches/:id', to: 'application#match'
  post '/', to: 'application#start'
  post '/clear_cache', to: 'application#clear_cache'
  root to: 'application#index'
end
