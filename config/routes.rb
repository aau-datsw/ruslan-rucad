Rails.application.routes.draw do
  resources :matches, only: %i[index show] do
    collection do
      post :clear_cache
      post :start
    end
  end

  resources :servers, except: [:show]

  root to: 'matches#index'
end
