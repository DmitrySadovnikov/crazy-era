Rails.application.routes.draw do
  root 'users#index'

  get '/auth/spotify/callback', to: 'users#spotify'

  resources :users, only: %i[index show] do
    get :logout

    collection do
      get :spotify
    end
  end
end
