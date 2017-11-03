Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users do
    collection do
      get 'profile', to: 'users#profile'
      post 'recovery', to: 'users#recovery'
      post 'signup', to: 'users#create'
    end
    resources :properties    
  end
  
  resources :regions do
  end
   
  resources :comunas do
  end
  
  resources :likes do
    collection do
      get '/ids', to: 'likes#getAllLikesIds'
      delete '/:property_id', to: 'likes#destroy'
    end
  end
  
  resources :dislikes do
    collection do
      get '/ids', to: 'dislikes#getAllDislikesIds'
      delete '/:property_id', to: 'dislikes#destroy'
    end
  end
  
  resources :favourites do
    collection do
      get '/ids', to: 'favourites#getAllFavouritesIds'
      delete '/:property_id', to: 'favourites#destroy'
    end
  end
  
  resources :properties do
    collection do
      get 'search', to: 'properties#search'
    end
    member do
      put 'views', to: 'properties#views'
      put 'active', to: 'properties#active'
    end
  end
  
  post 'auth/login', to: 'authentication#authenticate'
  
end
